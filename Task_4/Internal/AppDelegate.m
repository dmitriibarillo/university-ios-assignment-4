#import "AppDelegate.h"
#import "Serializer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Case 1:
    NSLog(@"Case 1: Positive.");
    NSError *__autoreleasing error = nil;
    NSDictionary *testDictionary =
        @{@"Ogject": @1};
    
    Serializer *serialize = [[Serializer alloc] init];
    
    NSString *serializedDictionary = [serialize serialize:testDictionary withError:&error];
    
    
    NSLog(@"%@", serializedDictionary);
    
    return YES;
}

@end
