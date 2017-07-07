//
//  LuaExportUserData.m
//  Givit
//
//  Created by Sean Meiners on 2013/11/19.
//
//

#import "LuaExportMetaData.h"

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#import "LuaContext.h"

@interface LuaExportMethodMetaData : NSObject {
@public
    NSInvocation *invocation;
    NSArray *argumentSizes;
}

+ (LuaExportMethodMetaData*)methodMetaDataFor:(const char*)name withTypes:(const char*)types;
- (id)initWithMethod:(const char*)name andTypes:(const char*)types;

@end

@implementation LuaExportMethodMetaData

+ (LuaExportMethodMetaData*)methodMetaDataFor:(const char*)name withTypes:(const char*)types {
    return [[self alloc] initWithMethod:name andTypes:types];
}

- (id)initWithMethod:(const char*)name andTypes:(const char*)typesStr {
    if( (self = [super init]) ) {
        NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:typesStr];
        invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:sel_registerName(name)];
        NSUInteger num = invocation.methodSignature.numberOfArguments;
        NSMutableArray *argSizes = [NSMutableArray arrayWithCapacity:(num-2)];
        for( NSUInteger i = 2; i < num; ++i ) { // skip the first two (self & _cmd)
            NSUInteger size;
            NSGetSizeAndAlignment([invocation.methodSignature getArgumentTypeAtIndex:i], &size, NULL);
            [argSizes addObject:@(size)];
        }
        argumentSizes = [NSArray arrayWithArray:argSizes];
    }
    return self;
}

@end

@interface LuaExportPropertyMetaData : NSObject {
@public
    unichar type;
    Class objCType;
    BOOL readonly;
    NSUInteger propertySize;
    NSInvocation *getter;
    NSInvocation *setter;
}

+ (LuaExportPropertyMetaData*)propertyMetaDataFor:(NSString*)name withAttrs:(const char*)attrs;
- (id)initWithProperty:(NSString*)name andAttrs:(const char*)attrs;

@end

@implementation LuaExportPropertyMetaData

+ (LuaExportPropertyMetaData*)propertyMetaDataFor:(NSString*)name withAttrs:(const char *)attrs {
    return [[self alloc] initWithProperty:name andAttrs:attrs];
}

- (id)initWithProperty:(NSString*)propName andAttrs:(const char*)attrs {
    if( (self = [super init]) ) {
        NSArray *propAttrs = [[NSString stringWithUTF8String:attrs] componentsSeparatedByString:@","];
        readonly = [propAttrs indexOfObject:@"R"] != NSNotFound;

        NSUInteger idx;

        // find the type
        idx = [propAttrs indexOfObjectPassingTest:^BOOL(NSString *str, NSUInteger idx, BOOL *stop) {
            if( [str length] > 1 && [str characterAtIndex:0] == 'T' )
                *stop = YES;
            return *stop;
        }];
        NSString *propType = [[propAttrs objectAtIndex:idx] substringFromIndex:1];

        NSGetSizeAndAlignment([propType UTF8String], &propertySize, NULL);

        type = [propType characterAtIndex:0];
        switch( type ) {
            // white-list of types we know will work
            case _C_ID:
            {
                NSString *typeName = [propType substringFromIndex:1];
                if( [typeName length] > 2 && [typeName characterAtIndex:0] == '"' )
                    typeName = [typeName substringWithRange:NSMakeRange(1, [typeName length] - 2)];
                objCType = NSClassFromString(typeName);
                break;
            }
            case _C_CHR:
            case _C_UCHR:
            case _C_SHT:
            case _C_USHT:
            case _C_INT:
            case _C_UINT:
            case _C_LNG:
            case _C_ULNG:
            case _C_LNG_LNG:
            case _C_ULNG_LNG:
            case _C_FLT:
            case _C_DBL:
            case _C_BOOL:
                break;
            case _C_STRUCT_B:
            {
                const char *pType = [propType UTF8String];
                if( ! strncmp(pType, "{CGRect=", 8) )
                    break;
                else if( ! strncmp(pType, "{CGPoint=", 9) )
                    break;
                else if( ! strncmp(pType, "{CGSize=", 8) )
                    break;
                else if( ! strncmp(pType, "{CGAffineTransform=", 19) )
                    break;
                else if( ! strncmp(pType, "{CATransform3D=", 15) )
                    break;
                else
                    return nil;
                break;
            }
            default:
                return nil;
        }

        // find the getter
        idx = [propAttrs indexOfObjectPassingTest:^BOOL(NSString *str, NSUInteger idx, BOOL *stop) {
            if( [str length] > 1 && [str characterAtIndex:0]  == 'G' )
                *stop = YES;
            return *stop;
        }];

        SEL sel;

        if( idx == NSNotFound )
            sel = sel_registerName([propName UTF8String]);
        else
            sel = sel_registerName([[[propAttrs objectAtIndex:idx] substringFromIndex:1] UTF8String]);
        NSString *getterSig = [NSString stringWithFormat:@"%@@:", propType];
        getter = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:[getterSig UTF8String]]];
        [getter setSelector:sel];

        if( ! readonly ) {
            // find the setter
            idx = [propAttrs indexOfObjectPassingTest:^BOOL(NSString *str, NSUInteger idx, BOOL *stop) {
                if( [str length] > 1 && [str characterAtIndex:0]  == 'S' )
                    *stop = YES;
                return *stop;
            }];

            if( idx == NSNotFound ) {
                NSMutableString *setterName = [NSMutableString stringWithString:@"set"];
                unichar first = [propName characterAtIndex:0];
                [setterName appendFormat:@"%c%@:", toupper(first), [propName substringFromIndex:1]];
                sel = sel_registerName([setterName UTF8String]);
            }
            else
                sel = sel_registerName([[[propAttrs objectAtIndex:idx] substringFromIndex:1] UTF8String]);
            NSString *setterSig = [@"v@:" stringByAppendingString:propType];
            setter = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:[setterSig UTF8String]]];
            [setter setSelector:sel];
        }
    }
    return self;
}

@end

@interface LuaExportMetaData () {
    NSMutableDictionary *exportedProperties;
    NSMutableDictionary *exportedMethods;
}
@end

static inline void setArgumentAt(NSInvocation *invocation, NSUInteger idx, NSUInteger size, id obj) {
    idx += 2; // skip self & _cmd
    static void* NullArgument = NULL;
    if( obj == [NSNull null] ) {
        [invocation setArgument:&NullArgument atIndex:idx];
        return;
    }

    const char *argType = [invocation.methodSignature getArgumentTypeAtIndex:idx];
//NSLog(@"%ld: %s (%lu b) obj: %@", (long)idx, argType, (unsigned long)size, [[obj description] stringByReplacingOccurrencesOfString:@"\n" withString:@" "]);
    void *buffer = calloc(1, size);
#define SET_BUFFER(TYPE, SELECTOR) \
{ \
    TYPE value = [obj SELECTOR]; \
    memcpy(buffer, &value, size); \
    break; \
}

    switch( argType[0] ) {
        case _C_FLT:
            SET_BUFFER(float, floatValue);
        case _C_DBL:
            SET_BUFFER(double, doubleValue);
            break;
        case _C_CHR:
            SET_BUFFER(char, charValue);
            break;
        case _C_UCHR:
            SET_BUFFER(unsigned char, unsignedCharValue);
            break;
        case _C_SHT:
            SET_BUFFER(short, shortValue);
            break;
        case _C_USHT:
            SET_BUFFER(unsigned short, unsignedShortValue);
            break;
        case _C_INT:
            SET_BUFFER(int, intValue);
            break;
        case _C_UINT:
            SET_BUFFER(unsigned int, unsignedIntValue);
            break;
        case _C_LNG:
            SET_BUFFER(long, longValue);
            break;
        case _C_ULNG:
            SET_BUFFER(unsigned long, unsignedLongValue);
            break;
        case _C_LNG_LNG:
            SET_BUFFER(long long, longLongValue);
            break;
        case _C_ULNG_LNG:
            SET_BUFFER(unsigned long long, unsignedLongLongValue);
            break;
        case _C_ID:
            *(id __unsafe_unretained*)buffer = obj;
            break;
        case _C_STRUCT_B:
        {
            if( ! strncmp(argType, "{CGRect=", 8) ) {
                CGRect rect;
                if( [obj isKindOfClass:[NSDictionary class]] && [obj count] == 4 )
                    rect = CGRectMake([obj[@"x"] floatValue], [obj[@"y"] floatValue], [obj[@"width"] floatValue], [obj[@"height"] floatValue]);
                else if( [obj isKindOfClass:[NSArray class]] && [obj count] == 4 )
                    rect = CGRectMake([obj[0] floatValue], [obj[1] floatValue], [obj[2] floatValue], [obj[3] floatValue]);
                memcpy(buffer, &rect, size);
            }
            else if( ! strncmp(argType, "{CGPoint=", 9) ) {
                CGPoint point;
                if( [obj isKindOfClass:[NSDictionary class]] && [obj count] == 2 )
                    point = CGPointMake([obj[@"x"] floatValue], [obj[@"y"] floatValue]);
                else if( [obj isKindOfClass:[NSArray class]] && [obj count] == 2 )
                    point = CGPointMake([obj[0] floatValue], [obj[1] floatValue]);
                memcpy(buffer, &point, size);
            }
            else if( ! strncmp(argType, "{CGSize=", 8) ) {
                CGSize cgsize;
                if( [obj isKindOfClass:[NSDictionary class]] && [obj count] == 2 )
                    cgsize = CGSizeMake([obj[@"width"] floatValue], [obj[@"height"] floatValue]);
                else if( [obj isKindOfClass:[NSArray class]] && [obj count] == 2 )
                    cgsize = CGSizeMake([obj[0] floatValue], [obj[1] floatValue]);
                memcpy(buffer, &cgsize, size);
            }
            else if( ! strncmp(argType, "{CGAffineTransform=", 19) ) {
                CGAffineTransform xform;
                if( [obj isKindOfClass:[NSDictionary class]] && [obj count] == 6 )
                    xform = (CGAffineTransform){
                        [obj[@"a"] floatValue], [obj[@"b"] floatValue],
                        [obj[@"c"] floatValue], [obj[@"d"] floatValue],
                        [obj[@"tx"] floatValue], [obj[@"ty"] floatValue] };
                else if( [obj isKindOfClass:[NSArray class]] && [obj count] == 6 )
                    xform = (CGAffineTransform){
                        [obj[0] floatValue], [obj[1] floatValue],
                        [obj[2] floatValue], [obj[3] floatValue],
                        [obj[4] floatValue], [obj[5] floatValue] };
                memcpy(buffer, &xform, size);
            }
            else if( ! strncmp(argType, "{CATransform3D=", 15) ) {
                CATransform3D xform;
                if( [obj isKindOfClass:[NSDictionary class]] && [obj count] == 16 )
                    xform = (CATransform3D){
                        [obj[@"m11"] floatValue], [obj[@"m12"] floatValue], [obj[@"m13"] floatValue], [obj[@"m14"] floatValue],
                        [obj[@"m21"] floatValue], [obj[@"m22"] floatValue], [obj[@"m23"] floatValue], [obj[@"m24"] floatValue],
                        [obj[@"m31"] floatValue], [obj[@"m32"] floatValue], [obj[@"m33"] floatValue], [obj[@"m34"] floatValue],
                        [obj[@"m41"] floatValue], [obj[@"m42"] floatValue], [obj[@"m43"] floatValue], [obj[@"m44"] floatValue] };
                else if( [obj isKindOfClass:[NSArray class]] && [obj count] == 16 )
                    xform = (CATransform3D){
                        [obj[0] floatValue], [obj[1] floatValue], [obj[2] floatValue], [obj[3] floatValue],
                        [obj[4] floatValue], [obj[5] floatValue], [obj[6] floatValue], [obj[7] floatValue],
                        [obj[8] floatValue], [obj[9] floatValue], [obj[10] floatValue], [obj[11] floatValue],
                        [obj[12] floatValue], [obj[13] floatValue], [obj[14] floatValue], [obj[15] floatValue] };
                memcpy(buffer, &xform, size);
            }
            break;
        }
    }
    [invocation setArgument:buffer atIndex:idx];
    free(buffer);
}

static inline id getObjectResult(NSInvocation *invocation) {
#define GET_RESULT_PRIMITIVE(TYPE) \
{ \
    TYPE value; \
    [invocation getReturnValue:&value]; \
    result = @(value); \
    break; \
}

    const char *retType = invocation.methodSignature.methodReturnType;
    NSUInteger size = invocation.methodSignature.methodReturnLength;
//NSLog(@"ret: %s (%lu b)", retType, (unsigned long)size);

    id result = nil;
    switch( retType[0] ) {
        case _C_FLT:
            GET_RESULT_PRIMITIVE(float);
        case _C_DBL:
            GET_RESULT_PRIMITIVE(double);
        case _C_CHR:
            GET_RESULT_PRIMITIVE(char);
        case _C_UCHR:
            GET_RESULT_PRIMITIVE(unsigned char);
        case _C_SHT:
            GET_RESULT_PRIMITIVE(short);
        case _C_USHT:
            GET_RESULT_PRIMITIVE(unsigned short);
        case _C_INT:
            GET_RESULT_PRIMITIVE(int);
        case _C_UINT:
            GET_RESULT_PRIMITIVE(unsigned int);
        case _C_LNG:
            GET_RESULT_PRIMITIVE(long);
        case _C_ULNG:
            GET_RESULT_PRIMITIVE(unsigned long);
        case _C_LNG_LNG:
            GET_RESULT_PRIMITIVE(long long);
        case _C_ULNG_LNG:
            GET_RESULT_PRIMITIVE(unsigned long long);
        case _C_ID:
        {
            __unsafe_unretained id temp = nil;
            [invocation getReturnValue:&temp];
            result = temp;
            break;
        }
        case _C_STRUCT_B:
        {
            void *buffer = calloc(1, size);
            [invocation getReturnValue:buffer];
            result = [NSValue valueWithBytes:buffer objCType:retType];
            memset(buffer, 1, size);
            free(buffer);
            break;
        }
    }

    return result;
}

@implementation LuaExportMetaData

+ (LuaExportMetaData*)createExport {
    LuaExportMetaData *ud = [LuaExportMetaData new];
    ud->exportedProperties = [NSMutableDictionary dictionary];
    ud->exportedMethods = [NSMutableDictionary dictionary];
    return ud;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<%@: %p { properties: %@, methods: %@ }>",
            NSStringFromClass([self class]), self,
            [exportedProperties allKeys], [exportedMethods allKeys]
    ];
}

- (void)addAllowedProperty:(const char*)propertyName withAttrs:(const char*)attrs {
    NSString *name = [NSString stringWithUTF8String:propertyName];
    LuaExportPropertyMetaData *metaData = [LuaExportPropertyMetaData propertyMetaDataFor:name withAttrs:attrs];
    if( metaData )
        exportedProperties[name] = metaData;
    else
        NSLog(@"not adding %s", propertyName);
}

- (BOOL)canReadProperty:(const char*)propertyName {
    NSString *name = [NSString stringWithUTF8String:propertyName];
    LuaExportPropertyMetaData *metaData = exportedProperties[name];
    if( ! metaData || ! metaData->getter )
        return NO;
    return YES;
}

- (BOOL)canWriteProperty:(const char*)propertyName {
    NSString *name = [NSString stringWithUTF8String:propertyName];
    LuaExportPropertyMetaData *metaData = exportedProperties[name];
    if( ! metaData || ! metaData->setter || metaData->readonly )
        return NO;
    return YES;
}

- (id)getProperty:(const char*)propertyName onInstance:(id)instance {
    NSString *name = [NSString stringWithUTF8String:propertyName];
    LuaExportPropertyMetaData *metaData = exportedProperties[name];
    if( ! metaData || ! metaData->getter )
        return nil;

    [metaData->getter invokeWithTarget:instance];
    return getObjectResult(metaData->getter);
}

- (void)setProperty:(const char*)propertyName toValue:(id)value onInstance:(id)instance {
    NSString *name = [NSString stringWithUTF8String:propertyName];
    LuaExportPropertyMetaData *metaData = exportedProperties[name];
    if( ! metaData || ! metaData->setter || metaData->readonly )
        return;
#if DEBUG
    if( value && metaData->type == _C_ID ) {
        Class valueClass = [value class];
        if( valueClass != metaData->objCType && ! [valueClass isSubclassOfClass:metaData->objCType] )
            [NSException raise:NSInvalidArgumentException format:@"object of type %@ can not be safely assigned to object of type %@", NSStringFromClass(valueClass), NSStringFromClass(metaData->objCType)];
    }
#endif
    setArgumentAt(metaData->setter, 0, metaData->propertySize, value);
    [metaData->setter invokeWithTarget:instance];
}

- (void)addAllowedMethod:(const char*)methodName withTypes:(const char *)types {
    NSString *name = [NSString stringWithUTF8String:methodName];
    NSArray *parts = [name componentsSeparatedByString:@":"];
    NSMutableString *mangled = [NSMutableString string];

    [parts enumerateObjectsUsingBlock:^(NSString *part, NSUInteger idx, BOOL *stop) {
        if( ! [part length] )
            return;
        if( idx == 0 )
            [mangled appendString:part];
        else {
            unichar first = [part characterAtIndex:0];
            if( [part length] > 1 )
                [mangled appendFormat:@"%c%@", toupper(first), [part substringFromIndex:1]];
            else
                [mangled appendFormat:@"%c", toupper(first)];
        }
    }];

    LuaExportMethodMetaData *metaData = [LuaExportMethodMetaData methodMetaDataFor:methodName withTypes:types];
    if( metaData )
        exportedMethods[mangled] = metaData;
}

- (BOOL)canCallMethod:(const char*)method {
    NSString *name = [NSString stringWithUTF8String:method];
    LuaExportMethodMetaData *metaData = exportedMethods[name];
    return (metaData && metaData->invocation);
}

- (id)callMethod:(const char*)method withArgs:(NSArray *)args onInstance:(id)instance {
    NSString *name = [NSString stringWithUTF8String:method];
    LuaExportMethodMetaData *metaData = exportedMethods[name];
    if( ! metaData || ! metaData->invocation )
        return nil;

    [args enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//NSLog(@"%ld: %s", idx, [metaData->signature getArgumentTypeAtIndex:idx+2]);
        setArgumentAt(metaData->invocation, idx, [metaData->argumentSizes[idx] unsignedIntValue], obj);
    }];
    // make sure all un-passed args are nil'd out
    for( NSUInteger idx = [args count]; idx < [metaData->argumentSizes count]; ++idx )
        setArgumentAt(metaData->invocation, idx, 0, [NSNull null]);

    [metaData->invocation invokeWithTarget:instance];

    return getObjectResult(metaData->invocation);
}

@end
