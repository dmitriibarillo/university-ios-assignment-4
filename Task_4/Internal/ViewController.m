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
    CGRect cgrect = CGRectMake(1, 2, 3, 4);
    NSDictionary *testDictionary = @{
        @"_id": @"5680919d930653b61fb96bcf",
        @"index": @0,
        @"guid": @"54bbcf1c-3503-4378-b66d-21706ac40bd6",
        @"isActive": [NSNull null],
        @"CGRect": [NSValue valueWithCGRect:cgrect],
        @"balance": @"$3,686.89",
        @"about": @"Enim consectetur ut fugiat quis nulla qui proident cillum dolore dolore enim. Excepteur non reprehenderit pariatur voluptate velit ex eu. Fugiat sit esse voluptate aliqua cupidatat duis eiusmod cillum. Dolor ex aliqua exercitation aliqua incididunt veniam deserunt ex commodo cillum aute ut aliqua cupidatat. Excepteur sint proident irure consectetur eiusmod aliquip do. Veniam est proident anim duis dolore qui aliquip aute dolor ullamco.\r\n",
        @"tags": @[
                 @"Lorem",
                 @"exercitation",
                 @"id",
                 @"esse",
                 @"pariatur",
                 @"ipsum",
                 @"est"
                 ],
        @"friends": @[
                    @{
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
                    ],
        @"greeting": @"Hello, Kirsten Ratliff! You have 2 unread messages.",
        @"favoriteFruit": @"strawberry"
        };
  
  
    NSString *serializedDictionary = [Serializer serialize:testDictionary withError:&error];
    
    NSLog(@"%@", serializedDictionary);

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
