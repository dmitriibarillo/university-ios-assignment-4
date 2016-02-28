#import "Serializer.h"


static NSString *const ERROR_DOMAIN = @"Serialize.domain";

typedef NS_ENUM(NSInteger, ERROR_TYPE) {
    NOT_A_DICTIONARY = 1,
    INVALID_OBJECT_TYPE = 2,
    INVALIDE_KEY_TYPE = 3,
    INVALID_NSVALUE_TYPE = 4
};

@interface Serializer ()

@end

@implementation Serializer

+ (NSString *)serialize:(id)dictionary withError:(NSError *__autoreleasing *)error
{
    NSString *result = [[NSString alloc] init];
    int initDeep = 0;
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        result = [self serializeObject:dictionary deep:initDeep error:error];
    }
    else {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"Expected NSDictionary. %@ was received.", [dictionary class]];
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)};
            *error = [NSError errorWithDomain:ERROR_DOMAIN code:NOT_A_DICTIONARY userInfo:userInfo];
        }
        
        return nil;
    }
    
    return [result copy];
}

+ (NSString *)serializeObject:(id)object deep:(int)deep error:(NSError *__autoreleasing *)error
{
    NSString *result = [[NSString alloc] init];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        result = [self serializeNSDictionary:object deep:deep error:error];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        result = [self serializeNSArray:object deep:deep error:error];
    }
    else if ([object isKindOfClass:[NSSet class]]) {
        result = [self serializeNSSet:object deep:deep error:error];
    }
    else if ([object isKindOfClass:[NSString class]]) {
        result = [self serializeNSString:object];
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        result = [self serializeNSNumber:object];
    }
    else if ([object isKindOfClass:[NSValue class]]) {
        result = [self serializeCGRect:object deep:deep error:error];
    }
    else if ([object isKindOfClass:[NSNull class]]) {
        result = [self serializeNSNull];
    }
    else {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"Unknown object. %@ was received.", [object class]];
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)};
            *error = [NSError errorWithDomain:ERROR_DOMAIN code:INVALID_OBJECT_TYPE userInfo:userInfo];
        }
        
        return nil;
    }
    
    if (*error != nil) {
        return nil;
    }
    
    return [result copy];
}

+ (NSString *)serializeNSDictionary:(NSDictionary *)dictionary deep:(int)deep error:(NSError *__autoreleasing *)error
{
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:@"{"];
    
    if ([dictionary count] > 0){
        [result appendString:@"\n"];
        deep++;
    
        NSArray *keysArray = [NSArray arrayWithArray:[dictionary allKeys]];
        id lastObject = [keysArray lastObject];
        for (id key in keysArray) {
            if (![key isKindOfClass:[NSString class]]) {
                if (error) {
                    NSString *errorMessage = [NSString stringWithFormat:@"Key have invalid type: %@.", [key class]];
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)};
                    *error = [NSError errorWithDomain:ERROR_DOMAIN code:INVALID_OBJECT_TYPE userInfo:userInfo];
                }
                
                return nil;
            }
            else {
                [result appendString:[self indentation:deep]];
                [result appendFormat:@"\"%@\": ", key];
                NSString *temp = [[self serializeObject:dictionary[key] deep:deep error:error] copy];
                
                if (*error != nil) {
                    return nil;
                }
                
                [result appendString:temp];
                if (![key isEqual:lastObject]) {
                    [result appendString:@","];
                    [result appendString:@"\n"];
                }
            }
        }

        deep--;
        [result appendString:@"\n"];
        [result appendString:[self indentation:deep]];
    }
    [result appendString:@"}"];
    return [result copy];
}

+ (NSString *)serializeNSArray:(NSArray  *)array deep:(int)deep error:(NSError *__autoreleasing *)error
{
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:@"["];
    
    if ([array count] > 0) {
        [result appendString:@"\n"];
        deep++;
        
        id lastObject = [array lastObject];
        for (id val in array) {
            [result appendString:[self indentation:deep]];
            [result appendFormat:@"%@", [self serializeObject:val deep:deep error:error]];
            
            if (*error != nil) {
                return nil;
            }
            
            if (![val isEqual:lastObject]) {
                [result appendString:@","];
                [result appendString:@"\n"];
            }
        }
        
        deep--;
        [result appendString:@"\n"];
        [result appendString:[self indentation:deep]];
    }
    
    [result appendString:@"]"];
    return [result copy];
}

+ (NSString *)serializeNSSet:(NSSet *)set deep:(int)deep error:(NSError *__autoreleasing *)error
{
    NSArray *array = [set allObjects];
    return [self serializeNSArray:array deep:deep error:error];
}

+ (NSString *)serializeNSString:(NSString *)string
{
    return [[NSString alloc] initWithFormat:@"\"%@\"", string];
}

+ (NSString *)serializeNSNumber:(NSNumber *)number
{
    return [number stringValue];
}

+ (NSString *)serializeNSNull
{
    return @"null";
}

+ (NSString *)serializeCGRect:(NSValue *)value deep:(int)deep error:(NSError *__autoreleasing *)error
{
    NSString *result = [[NSMutableString alloc] init];
    int isCGRect = strcmp([value objCType], @encode(CGRect));
    
    if (isCGRect == 0) {
        CGRect temp = [value CGRectValue];
        NSDictionary *cgRect = @{@"x" : @(temp.origin.x),
                                 @"y" : @(temp.origin.y),
                                 @"width" : @(temp.size.width),
                                 @"height" : @(temp.size.height),
                                 };
        result = [self serializeObject:cgRect deep:deep error:error];
    }
    else {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"Expected CGRect. %@ was received.", [value class]];
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)};
            *error = [NSError errorWithDomain:ERROR_DOMAIN code:INVALID_NSVALUE_TYPE userInfo:userInfo];
        }
        return nil;

    }
    
    return result;
}

+ (NSString *)indentation:(int)deep
{
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < deep; i++) {
        [result appendString:@"\t"];
    }
    
    return [result copy];
}

@end