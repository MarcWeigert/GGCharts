//
//  LuaContext.m
//  Givit
//
//  Created by Sean Meiners on 2013/11/19.
//
//

#import "LuaContext.h"
#import "LuaExport.h"
#import "LuaExportMetaData.h"

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#import "lua.h"
#import "lauxlib.h"
#import "lualib.h"

#if ! TARGET_OS_IPHONE
const CATransform3D CATransform3DIdentity = {
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1 };
#endif

NSString *const LuaErrorDomain = @"LuaErrorDomain";

const char *LuaWrapperObjectMetatableName = "LuaWrapperObjectMetaTable";

typedef struct LuaWrapperObject {
    void *context;
    void *instance;
    void *exportData;
} LuaWrapperObject;

static int luaWrapperIndex(lua_State *L);
static int luaWrapperNewIndex(lua_State *L);

static int luaDumpVar(lua_State *L);

static const struct luaL_Reg luaWrapperMetaFunctions[] = {
    {"__index", luaWrapperIndex},
    {"__newindex", luaWrapperNewIndex},
    {NULL, NULL}
};


@interface LuaContext () {
    lua_State *L;
    NSMutableDictionary *_exportedClasses;
}
@end

static int luaPanicked(lua_State *L) {
    NSLog(@"Lua panicked: %s", luaL_checkstring(L, -1));
    return 0;
}

static const luaL_Reg loadedlibs[] = {
  {"_G", luaopen_base},
//  {LUA_LOADLIBNAME, luaopen_package},
//  {LUA_COLIBNAME, luaopen_coroutine},
  {LUA_TABLIBNAME, luaopen_table},
//  {LUA_IOLIBNAME, luaopen_io},
//  {LUA_OSLIBNAME, luaopen_os},
  {LUA_STRLIBNAME, luaopen_string},
//  {LUA_BITLIBNAME, luaopen_bit32},
  {LUA_MATHLIBNAME, luaopen_math},
//  {LUA_DBLIBNAME, luaopen_debug},
  {NULL, NULL}
};

@implementation LuaContext

- (id)init {
    if( (self = [super init]) ) {
        L = luaL_newstate();
        lua_atpanic(L, &luaPanicked);

        // load the lua libraries
        const luaL_Reg *lib;
        for (lib = loadedlibs; lib->func; ++lib) {
            luaL_requiref(L, lib->name, lib->func, 1);
            lua_pop(L, 1);  /* remove lib */
        }

        lua_register(L, "dumpVar", luaDumpVar);

        luaL_newmetatable(L, LuaWrapperObjectMetatableName);
        luaL_setfuncs(L, luaWrapperMetaFunctions, 0);
        lua_pop(L, 1);

        _exportedClasses = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    if( L )
        lua_close(L);
}

- (BOOL)parse:(NSString *)script error:(NSError *__autoreleasing *)error {
    int result = luaL_dostring(L, [script UTF8String]);
    if( result == LUA_OK )
        return YES;
    if( error ) {
        *error = [NSError errorWithDomain:LuaErrorDomain
                                     code:result
                                 userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Could not parse script: %s", lua_tostring(L,-1)] }];
    }
    return NO;
}

- (BOOL)parseURL:(NSURL *)url error:(NSError *__autoreleasing *)error {
    if( ! [[url scheme] isEqualToString:@"file"] ) {
        if( error )
            *error = [NSError errorWithDomain:LuaErrorDomain
                                         code:LuaError_Invalid
                                     userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Invalid script path '%@'", url] }];
        return NO;
    }
    int result = luaL_dofile(L, [[url path] UTF8String]);
    if( result == LUA_OK )
        return YES;
    if( error ) {
        *error = [NSError errorWithDomain:LuaErrorDomain
                                     code:result
                                 userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Could not parse script: %s", lua_tostring(L,-1)] }];
    }
    return NO;
}

- (BOOL)fromObjC:(id)object {
    if( ! object )
        lua_pushnil(L);
    else if( [object isKindOfClass:[NSString class]] )
        lua_pushstring(L, [object UTF8String]);
    else if( [object isKindOfClass:[NSNumber class]] ) {
        switch( [object objCType][0] ) {
            case _C_FLT:
            case _C_DBL:
                lua_pushnumber(L, [object doubleValue]);
                break;
            case _C_CHR:
            case _C_UCHR:
                lua_pushboolean(L, [object boolValue]);
                break;
            case _C_SHT:
            case _C_USHT:
            case _C_INT:
            case _C_UINT:
            case _C_LNG:
            case _C_ULNG:
            case _C_LNG_LNG:
            case _C_ULNG_LNG:
                lua_pushinteger(L, [object longValue]);
                break;
            default:
                return NO;
        }
    }
    else if( [object isKindOfClass:[NSArray class]] ) {
        lua_newtable(L);
        [object enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            [self fromObjC:item];
            lua_rawseti(L, -2, (int)idx + 1); // lua arrays start at 1, not 0
        }];
    }
    else if( [object isKindOfClass:[NSDictionary class]] ) {
        lua_newtable(L);
        [object enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self fromObjC:key];
            [self fromObjC:obj];
            lua_rawset(L, -3);
        }];
    }
    else if( [object isKindOfClass:[NSValue class]] ) {
        const char *objType = [object objCType];
        if( ! strncmp(objType, "{CGRect=", 8) ) {
            CGRect rect;
            [object getValue:&rect];
            lua_newtable(L);
            lua_pushstring(L, "x");
            lua_pushnumber(L, rect.origin.x);
            lua_rawset(L, -3);
            lua_pushstring(L, "y");
            lua_pushnumber(L, rect.origin.y);
            lua_rawset(L, -3);
            lua_pushstring(L, "width");
            lua_pushnumber(L, rect.size.width);
            lua_rawset(L, -3);
            lua_pushstring(L, "height");
            lua_pushnumber(L, rect.size.height);
            lua_rawset(L, -3);
        }
        else if( ! strncmp(objType, "{CGPoint=", 9) ) {
            CGPoint point;
            [object getValue:&point];
            lua_newtable(L);
            lua_pushstring(L, "x");
            lua_pushnumber(L, point.x);
            lua_rawset(L, -3);
            lua_pushstring(L, "y");
            lua_pushnumber(L, point.y);
            lua_rawset(L, -3);
        }
        else if( ! strncmp(objType, "{CGSize=", 8) ) {
            CGSize cgsize;
            [object getValue:&cgsize];
            lua_newtable(L);
            lua_pushstring(L, "width");
            lua_pushnumber(L, cgsize.width);
            lua_rawset(L, -3);
            lua_pushstring(L, "height");
            lua_pushnumber(L, cgsize.height);
            lua_rawset(L, -3);
        }
        else if( ! strncmp(objType, "{CGAffineTransform=", 19) ) {
            CGAffineTransform xform;
            [object getValue:&xform];
            lua_newtable(L);
            lua_pushnumber(L, xform.a);
            lua_rawseti(L, -2, 1);
            lua_pushnumber(L, xform.b);
            lua_rawseti(L, -2, 2);
            lua_pushnumber(L, xform.c);
            lua_rawseti(L, -2, 3);
            lua_pushnumber(L, xform.d);
            lua_rawseti(L, -2, 4);
            lua_pushnumber(L, xform.tx);
            lua_rawseti(L, -2, 5);
            lua_pushnumber(L, xform.ty);
            lua_rawseti(L, -2, 6);
        }
        else if( ! strncmp(objType, "{CATransform3D=", 15) ) {
            CATransform3D xform;
            [object getValue:&xform];
            lua_newtable(L);
            lua_pushnumber(L, xform.m11);
            lua_rawseti(L, -2, 1);
            lua_pushnumber(L, xform.m12);
            lua_rawseti(L, -2, 2);
            lua_pushnumber(L, xform.m13);
            lua_rawseti(L, -2, 3);
            lua_pushnumber(L, xform.m14);
            lua_rawseti(L, -2, 4);
            lua_pushnumber(L, xform.m21);
            lua_rawseti(L, -2, 5);
            lua_pushnumber(L, xform.m22);
            lua_rawseti(L, -2, 6);
            lua_pushnumber(L, xform.m23);
            lua_rawseti(L, -2, 7);
            lua_pushnumber(L, xform.m24);
            lua_rawseti(L, -2, 8);
            lua_pushnumber(L, xform.m31);
            lua_rawseti(L, -2, 9);
            lua_pushnumber(L, xform.m32);
            lua_rawseti(L, -2, 10);
            lua_pushnumber(L, xform.m33);
            lua_rawseti(L, -2, 11);
            lua_pushnumber(L, xform.m34);
            lua_rawseti(L, -2, 12);
            lua_pushnumber(L, xform.m41);
            lua_rawseti(L, -2, 13);
            lua_pushnumber(L, xform.m42);
            lua_rawseti(L, -2, 14);
            lua_pushnumber(L, xform.m43);
            lua_rawseti(L, -2, 15);
            lua_pushnumber(L, xform.m44);
            lua_rawseti(L, -2, 16);
        }
        else
            return NO;
    }
    else if( [object conformsToProtocol:@protocol(LuaExport)] ) {
        NSString *clasName = NSStringFromClass([object class]);
        //NSLog(@"%@ conforms", clasName);
        LuaExportMetaData *exportData = _exportedClasses[clasName];

        if( ! exportData )
        {
            exportData = [LuaExportMetaData createExport];
            Protocol *exportProtocol = @protocol(LuaExport);
            for( Class clas = [object class]; clas; clas = [clas superclass] )
            {
                unsigned int protocolCount = 0;
                Protocol *__unsafe_unretained *protocols = class_copyProtocolList(clas, &protocolCount);
                for( unsigned int i = 0; i < protocolCount; ++i )
                {
                    //NSLog(@"%@ implements %s", object, protocol_getName(protocols[i]));
                    if( protocol_conformsToProtocol(protocols[i], exportProtocol) )
                    {
                        unsigned int propertyCount = 0;
                        objc_property_t *properties = protocol_copyPropertyList(protocols[i], &propertyCount);
                        unsigned int methodCount = 0;
                        struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocols[i], YES, YES, &methodCount);

                        if( propertyCount || methodCount ) {
                            for( unsigned int j = 0; j < propertyCount; ++j ) {
                                const char *name = property_getName(properties[j]);
                                //NSLog(@"property: %s", name);
                                [exportData addAllowedProperty:name withAttrs:property_getAttributes(properties[j])];
                            }
                            for( unsigned int k = 0; k < methodCount; ++k ) {
                                //NSLog(@"method: %s", sel_getName(methods[k].name));
                                [exportData addAllowedMethod:sel_getName(methods[k].name) withTypes:methods[k].types];
                            }
                        }

                        free(properties);
                        properties = NULL;
                        free(methods);
                        methods = NULL;
                    }
                }
                free(protocols);
                protocols = NULL;
            }
        }

        if( exportData ) {
            _exportedClasses[clasName] = exportData;
            LuaWrapperObject *wrapper = lua_newuserdata(L, sizeof(*wrapper));
            wrapper->context = (__bridge void*)self;
            wrapper->instance = (__bridge void*)object;
            wrapper->exportData = (__bridge void*)exportData;
            luaL_getmetatable(L, LuaWrapperObjectMetatableName);
            lua_setmetatable(L, -2);
            //NSLog(@"%@ adding wrapper %p with ed: %p", object, wrapper, exportData);
        }
        else
            return NO;
    }
    else
        return NO;

    return YES;
}

static inline id toObjC(lua_State *L, int index) {
    switch( lua_type(L, index) ) {
        case LUA_TNIL:
            return nil;
        case LUA_TNUMBER:
            return @(lua_tonumber(L, index));
        case LUA_TBOOLEAN:
            return @(lua_tonumber(L, index) > 0);
        case LUA_TSTRING:
            return [NSString stringWithUTF8String:lua_tostring(L, index)];
        case LUA_TTABLE:
        {
            BOOL isDict = NO;

            lua_pushvalue(L, index); // make sure the table is at the top
            lua_pushnil(L);  /* first key */
            while( ! isDict && lua_next(L, -2) ) {
                if( lua_type(L, -2) != LUA_TNUMBER ) {
                    isDict = YES;
                    lua_pop(L, 2); // pop key and value off the stack
                }
                else
                    lua_pop(L, 1);
            }

            id result = nil;

            if( isDict ) {
                result = [NSMutableDictionary dictionary];
                
                lua_pushnil(L);  /* first key */
                while( lua_next(L, -2) ) {
                    id key = toObjC(L, -2);
                    id object = toObjC(L, -1);
                    if( ! key )
                        continue;
                    if( ! object )
                        object = [NSNull null];
                    result[key] = object;
                    lua_pop(L, 1); // pop the value off
                }
            }
            else {
                result = [NSMutableArray array];
                
                lua_pushnil(L);  /* first key */
                while( lua_next(L, -2) ) {
                    int index = lua_tonumber(L, -2) - 1;
                    id object = toObjC(L, -1);
                    if( ! object )
                        object = [NSNull null];
                    result[index] = object;
                    lua_pop(L, 1);
                }
            }
              
            lua_pop(L, 1); // pop the table off
            return result;
        }
        case LUA_TFUNCTION:
        case LUA_TUSERDATA:
        case LUA_TTHREAD:
        case LUA_TLIGHTUSERDATA:
        default:
            return nil;
    }
}

- (id)call:(char*)name with:(NSArray *)args error:(NSError *__autoreleasing *)error {
    lua_getglobal(L, name);
    if( lua_type(L, -1) != LUA_TFUNCTION ) {
        if( error )
            *error = [NSError errorWithDomain:LuaErrorDomain
                                         code:LuaError_Invalid
                                     userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Function %s not found", name] }];
        return nil;
    }
    int count = 0;
    for( id arg in args ) {
        count += [self fromObjC:arg] ? 1 : 0;
    }
    int err = lua_pcall(L, count, 1, 0);
    id result = toObjC(L, -1);
    if( err != LUA_OK ) {
        if( error )
            *error = [NSError errorWithDomain:LuaErrorDomain code:err userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"function %s threw an error: %@", name, result] }];
        result = nil;
    }
    lua_pop(L, 1);
    return result;
}

- (id)objectForKeyedSubscript:(id)key {
    if( ! [key isKindOfClass:[NSString class]] ) {
        if( [key respondsToSelector:@selector(stringValue)] )
            key = [key stringValue];
        else
            key = [key description];
    }
    lua_getglobal(L, [key UTF8String]);
    id result = toObjC(L, -1);
    lua_pop(L, 1);
    return result;
}

- (void)setObject:(id)object forKeyedSubscript:(id)key {
    if( ! [key isKindOfClass:[NSString class]] ) {
        if( [key respondsToSelector:@selector(stringValue)] )
            key = [key stringValue];
        else
            key = [key description];
    }
    if( [self fromObjC:object] )
        lua_setglobal(L, [key UTF8String]);
}

@end

static int callMethod(lua_State *L) {
    LuaWrapperObject *wrapper = (LuaWrapperObject*)lua_touserdata(L, lua_upvalueindex(1));
    const char *name = lua_tostring(L, lua_upvalueindex(2));
    //NSLog(@"calling method for %p - %s", wrapper, name);
    if( wrapper && name ) {
        int nArgs = lua_gettop(L);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:nArgs];
        for( int i = 1; i <= nArgs; ++i ) {
            id obj = toObjC(L, i);
            if( obj )
                [arr addObject:obj];
            else
                [arr addObject:[NSNull null]];
        }
        LuaExportMetaData *ed = (__bridge LuaExportMetaData*)wrapper->exportData;
        id obj = (__bridge id)wrapper->instance;
        id result = [ed callMethod:name withArgs:arr onInstance:obj];
        id context = (__bridge id)wrapper->context;
        return [context fromObjC:result] ? 1 : 0;
    }
    return 0;
}

int luaWrapperIndex(lua_State *L) {
    LuaWrapperObject *wrapper = (LuaWrapperObject*)luaL_checkudata(L, 1, LuaWrapperObjectMetatableName);
    const char *name = luaL_checkstring(L, 2);
    //NSLog(@"getting index for %p - %s", wrapper, name);
    if( wrapper && name ) {
        LuaExportMetaData *ed = (__bridge LuaExportMetaData*)wrapper->exportData;
        id obj = (__bridge id)wrapper->instance;
        if( [ed canReadProperty:name] ) {
            //NSLog(@"  is readable property");
            id result = [ed getProperty:name onInstance:obj];
            id context = (__bridge id)wrapper->context;
            [context fromObjC:result];
            return 1;
        }
        else if( [ed canCallMethod:name] ) {
            //NSLog(@"  is callable method");
            lua_pushlightuserdata(L, wrapper);
            lua_pushstring(L, name);
            lua_pushcclosure(L, callMethod, 2);
            return 1;
        }
        else
            lua_pushfstring(L, "unable to find method or property '%s'", name);
    }
    else
        lua_pushfstring(L, "missing object wrapper for method or property '%s'", name);

    //NSLog(@"  failed");
    lua_error(L);
    return 0;
}

int luaWrapperNewIndex(lua_State *L) {
    LuaWrapperObject *wrapper = (LuaWrapperObject*)luaL_checkudata(L, 1, LuaWrapperObjectMetatableName);
    const char *name = luaL_checkstring(L, 2);
    id object = toObjC(L, 3);
    //NSLog(@"setting index for %p - %s to '%@'", wrapper, name, [object description]);
    if( wrapper && name ) {
        LuaExportMetaData *ed = (__bridge LuaExportMetaData*)wrapper->exportData;
        if( [ed canWriteProperty:name] ) {
            //NSLog(@"  is writable property");
            @try {
                id obj = (__bridge id)wrapper->instance;
                [ed setProperty:name toValue:object onInstance:obj];
                return 0;
            }
            @catch (NSException *e) {
                //NSLog(@"exception thrown while setting property '%s': %@", name, e);
                lua_pushfstring(L, "exception thrown while setting property '%s': %s", name, [[e description] UTF8String]);
            }
        }
        else {
            //NSLog(@"unable to set property '%s'", name);
            lua_pushfstring(L, "unable to set property '%s'", name);
        }
    }
    else {
        //NSLog(@"missing object wrapper for property '%s'", name);
        lua_pushfstring(L, "missing object wrapper for property '%s'", name);
    }

    lua_error(L);
    return 0;
}

static int luaDumpVar(lua_State *L) {
    int nArgs = lua_gettop(L);
    NSMutableString *result = [NSMutableString string];
    for( int i = 1; i <= nArgs; ++i ) {
        id obj = toObjC(L, i);
        [result appendFormat:@"%@", [obj description]];
    }
    lua_pushstring(L, [result UTF8String]);
    return 1;
}