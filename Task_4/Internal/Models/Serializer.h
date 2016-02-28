#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Serializer : NSObject

+ (NSString *)serialize:(id)dictionary withError:(NSError *__autoreleasing*)error;

@end