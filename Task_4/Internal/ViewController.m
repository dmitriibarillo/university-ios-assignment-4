#import "ViewController.h"
#import "Serializer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect cgrect = CGRectMake(1, 2, 3, 4);
    NSArray *tags = @[@"Lorem", @"exercitation", @"id", @"esse", @"pariatur", @"ipsum", @"est"];
    NSArray *friends = @[@{
                             @"id": @0,
                             @"name": @"Elma Ashley"
                             },
                         @{
                             @"id": @1,
                             @"name": @"Trujillo Gould"
                             },
                         @{
                             @"id": @2,
                             @"name": @"Alice Burns"
                             }
                         ];
    
    NSLog(@"Case 1: Positive.");
    NSError *__autoreleasing error = nil;
    NSDictionary *testDictionary = @{
        @"_id": @"5680919d930653b61fb96bcf",
        @"index": @0,
        @"guid": @"54bbcf1c-3503-4378-b66d-21706ac40bd6",
        @"isActive": [NSNull null],
        @"CGRect": [NSValue valueWithCGRect:cgrect],
        @"balance": @"$3,686.89",
        @"about": @"Enim consectetur ut fugiat quis nulla qui proident cillum dolore dolore enim. Excepteur non reprehenderit pariatur voluptate velit ex eu. Fugiat sit esse voluptate aliqua cupidatat duis eiusmod cillum. Dolor ex aliqua exercitation aliqua incididunt veniam deserunt ex commodo cillum aute ut aliqua cupidatat. Excepteur sint proident irure consectetur eiusmod aliquip do. Veniam est proident anim duis dolore qui aliquip aute dolor ullamco.\r\n",
        @"tags": tags,
        @"friends": friends,
        @"greeting": @"Hello, Kirsten Ratliff! You have 2 unread messages.",
        @"favoriteFruit": @"strawberry"
        };
  
  
    NSString *serializedDictionary = [Serializer serialize:testDictionary withError:&error];
    
    if (error != nil) {
        NSLog(@"Error! %@", error);
    }
    else {
        NSLog(@"%@", serializedDictionary);
    }
    
    NSLog(@"--------------------------");
    
    NSLog(@"Case 2: ERROR NOT_A_DICTIONARY");
    NSError *__autoreleasing error2 = nil;
    NSValue *testDictionary2 = @5;
    NSString *serializedDictionary2 = [Serializer serialize:testDictionary2 withError:&error2];
    
    if (error2 != nil) {
        NSLog(@"Error! %@", error2);
    }
    else {
        NSLog(@"%@", serializedDictionary2);
    }
    
    NSLog(@"--------------------------");
    
    NSLog(@"Case 3: ERROR INVALID_NSVALUE_TYPE");
    NSTimeInterval interval = 500;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
    NSError *__autoreleasing error3 = nil;
    NSDictionary *testDictionary3 = @{@"CGRect": date};
    NSString *serializedDictionary3 = [Serializer serialize:testDictionary3 withError:&error3];
    
    if (error3 != nil) {
        NSLog(@"Error! %@", error3);
    }
    else {
        NSLog(@"%@", serializedDictionary3);
    }
    NSLog(@"--------------------------");
    
    NSLog(@"Case 5: ERROR INVALID_NSVALUE_TYPE");
    CGSize size = CGSizeMake(5, 10);
    NSError *__autoreleasing error5 = nil;
    NSDictionary *testDictionary5 = @{@"CGRect": [NSValue valueWithCGSize:size]};
    NSString *serializedDictionary5 = [Serializer serialize:testDictionary5 withError:&error5];
    
    if (error5 != nil) {
        NSLog(@"%@", error5);
    }
    else {
        NSLog(@"%@", serializedDictionary5);
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
