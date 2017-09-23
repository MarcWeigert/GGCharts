//
//  LuaExportUserData.h
//  Givit
//
//  Created by Sean Meiners on 2013/11/19.
//
//

#import <Foundation/Foundation.h>

@interface LuaExportMetaData : NSObject

+ (LuaExportMetaData*)createExport;

- (void)addAllowedProperty:(const char*)propertyName withAttrs:(const char*)attrs;

- (BOOL)canReadProperty:(const char*)propertyName;
- (BOOL)canWriteProperty:(const char*)propertyName;

- (id)getProperty:(const char*)propertyName onInstance:(id)instance;
- (void)setProperty:(const char*)propertyName toValue:(id)value onInstance:(id)instance;

- (void)addAllowedMethod:(const char*)methodName withTypes:(const char*)types;

- (BOOL)canCallMethod:(const char*)methodName;

- (id)callMethod:(const char*)method withArgs:(NSArray*)args onInstance:(id)instance;

@end
