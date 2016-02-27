#import "Serializer.h"

@interface Serializer ()

@end

@implementation Serializer

- (NSString *)serialize:(id)dictionary withError:(NSError *__autoreleasing *)error
{
    NSMutableString *result = [[NSMutableString alloc] init];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        [result appendString:[self serializeObject:dictionary]];
    }
    else {
        NSLog(@"ERROR\n");
    }
    
    return [result copy];
}

- (NSString *)serializeObject:(id)object
{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        [self serializeNSDictionary:object];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        [self serializeNSArray:object];
    }
    else if ([object isKindOfClass:[NSSet class]]) {
        [self serializeNSSet:object];
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        [self serializeNSNumber:object];
    }
    else if ([object isKindOfClass:[NSValue class]]) {
        [self serializeCGRect:object];
    }
    else if ([object isKindOfClass:[NSNull class]]) {
        [self serializeNSNull];
    }
    else {
        NSLog(@"ERROR serializeObject\n");
    }
    
    return [result copy];
}

- (NSString *)serializeNSDictionary:(NSDictionary *)dictionary
{
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:@"{"];

    NSArray *keysArray = [NSArray arrayWithArray:[dictionary allKeys]];
    
    for (id key in keysArray) {
        [result appendFormat:@"%@ : ", key];
        NSString *temp = [[self serializeObject:dictionary[key]] copy];
        [result appendString:temp];
    }
    
    [result appendString:@"}"];
    return [result copy];
}

- (NSString *)serializeNSArray:(NSArray  *)array
{
    NSMutableString *arrayString = [[NSMutableString alloc] init];
    [arrayString appendString:@"["];

    id lastObject = [array lastObject];
    for (id val in array) {
        if ([val isEqual:lastObject]) {
            [arrayString appendString:[self serializeObject:val]];
            continue;
        }
            
        [arrayString appendFormat:@"%@, ", [self serializeObject:val]];
    }
    
    [arrayString appendString:@"]"];
    return [arrayString copy];
}

- (NSString *)serializeNSSet:(NSSet *)set
{
    NSArray *array = [set allObjects];
    return [array copy];
}

- (NSString *)serializeNSNumber:(NSNumber *)number
{
    NSString *numberString = [NSString stringWithFormat:@"%@", number];
    return numberString;
}

- (NSString *)serializeNSNull
{
    return @"null";
}


- (NSString *)serializeCGRect:(NSValue *)number
{
    NSMutableString *result = [[NSMutableString alloc] init];
    // TODO
    return [result copy];
}


@end