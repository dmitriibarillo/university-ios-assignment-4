#import "ViewController.h"
#import "Serializer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Case 1:
    NSLog(@"Case 1: Positive.");
    NSError *__autoreleasing error = nil;
    NSDictionary *testDictionary = @{@"Object": @1};
    
    NSString *serializedDictionary = [Serializer serialize:testDictionary withError:&error];
    
    
    NSLog(@"%@", serializedDictionary);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
