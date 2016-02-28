#import "Serializer.h"

@interface Serializer ()

@end

@implementation Serializer

+ (NSString *)serialize:(id)dictionary withError:(NSError *__autoreleasing *)error
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@""];
    int initDeep = 0;
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        [result appendString:[self serializeObject:dictionary deep:initDeep]];
    }
    else {
        NSLog(@"ERROR\n");
    }
    
    return [result copy];
}

+ (NSString *)serializeObject:(id)object deep:(int)deep
{
    NSString *result = [[NSString alloc] init];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        result = [self serializeNSDictionary:object deep:deep];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        result = [self serializeNSArray:object deep:deep];
    }
    else if ([object isKindOfClass:[NSSet class]]) {
        result = [self serializeNSSet:object deep:deep];
    }
    else if ([object isKindOfClass:[NSString class]]) {
        result = [self serializeNSString:object];
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        result = [self serializeNSNumber:object];
    }
    else if ([object isKindOfClass:[NSValue class]]) {
        result = [self serializeCGRect:object deep:deep];
    }
    else if ([object isKindOfClass:[NSNull class]]) {
        result = [self serializeNSNull];
    }
    else {
        NSLog(@"ERROR serializeObject\n");
    }
    
    return [result copy];
}

+ (NSString *)serializeNSDictionary:(NSDictionary *)dictionary deep:(int)deep
{
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:@"{"];
    
    if ([dictionary count] > 0){
        [result appendString:@"\n"];
        deep++;
    
        NSArray *keysArray = [NSArray arrayWithArray:[dictionary allKeys]];
        id lastObject = [keysArray lastObject];
        for (id key in keysArray) {
            [result appendString:[self indentation:deep]];
            [result appendFormat:@"\"%@\": ", key];
            NSString *temp = [[self serializeObject:dictionary[key] deep:deep] copy];
            [result appendString:temp];
            if (![key isEqual:lastObject]) {
                [result appendString:@","];
                [result appendString:@"\n"];
            }
        }

        deep--;
        [result appendString:@"\n"];
        [result appendString:[self indentation:deep]];
    }
    [result appendString:@"}"];
    return [result copy];
}

+ (NSString *)serializeNSArray:(NSArray  *)array deep:(int)deep
{
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:@"["];
    
    if ([array count] > 0) {
        [result appendString:@"\n"];
        deep++;
        
        id lastObject = [array lastObject];
        for (id val in array) {
            [result appendString:[self indentation:deep]];
            [result appendFormat:@"%@", [self serializeObject:val deep:deep]];
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

+ (NSString *)serializeNSSet:(NSSet *)set deep:(int)deep
{
    NSArray *array = [set allObjects];
    return [self serializeNSArray:array deep:deep];
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

+ (NSString *)serializeCGRect:(NSValue *)value deep:(int)deep
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
        result = [self serializeObject:cgRect deep:deep];
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