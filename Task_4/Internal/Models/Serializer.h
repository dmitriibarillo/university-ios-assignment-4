#import <Foundation/Foundation.h>

@interface Serializer : NSObject

+ (NSString *)serialize:(id)dictionary withError:(NSError *__autoreleasing*)error;

@end