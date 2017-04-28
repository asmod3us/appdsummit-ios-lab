//
//  AddToCartTestCase.m
//  Ecommerce Mobile Application
//
//  Created by Adam Leftik on 10/2/14.
//  Copyright (c) 2014 Adam Leftik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIFTestCase.h>
#import <KIF/KIF.h>
//#import "AcmeConfiguration.h"
//#import "KIFUITestActor+EXAdditions.h"

@interface AcmeConfiguration : NSObject
@property NSString *acmeUrl;
@property NSString *eumKey;
@property NSString *username;
@property NSString *password;
@property NSString *collectorUrl;
@end

@implementation AcmeConfiguration
- (id)init
{
    self = [super init];
    return self;
}
@end

@interface AddToCartTestCase : KIFTestCase

@end

@implementation AddToCartTestCase
static const NSString *kTitles[] = { @"The Tourist", @"The Lost City Of Z", @"Personal",@"The Godfather", @"Shantaram", @"Sacred Hoops", @"Freakonomics", @"Farewell To Arms",@"Driven From Within",@"A Clockwork Orange"};
static const int kRandomCrash = 2;
static const int CRASH_INTERVAL = -1;
NSMutableDictionary *map = nil;

- (void)setUp {
    [super setUp];
    [KIFUITestActor setDefaultTimeout:10];
    map = [NSMutableDictionary dictionary];
    
    AcmeConfiguration *pmDemo =[[AcmeConfiguration alloc] init];
    pmDemo.eumKey = @"pm-cloud-AAB-AUN";
    pmDemo.acmeUrl = @"http://ec2-54-90-14-200.compute-1.amazonaws.com/appdynamicspilot/";
    pmDemo.collectorUrl = @"http://ec2-54-202-222-83.us-west-2.compute.amazonaws.com";
    pmDemo.username = @"test";
    pmDemo.password = @"appdynamics";
    [map setValue:pmDemo forKey:@"pm-demo"];
    
    AcmeConfiguration *pm2 =[[AcmeConfiguration alloc] init];
    pm2.eumKey = @"pm-cloud-AAB-AUZ";
    pm2.acmeUrl = @"http://ec2-54-167-95-227.compute-1.amazonaws.com/appdynamicspilot/";
    pm2.collectorUrl = @"http://ec2-54-202-222-83.us-west-2.compute.amazonaws.com";
    pm2.username = @"test";
    pm2.password = @"appdynamics";
    [map setValue:pm2 forKey:@"pm2"];
    
    AcmeConfiguration *demo1 =[[AcmeConfiguration alloc] init];
    demo1.eumKey = @"EUM-AAB-AUN";
    demo1.acmeUrl = @"http://54.214.13.135:8000/appdynamicspilot/";
    demo1.collectorUrl = @"http://54.244.124.19";
    demo1.username = @"test";
    demo1.password = @"appdynamics";
    [map setValue:demo1 forKey:@"demo1"];
    
    AcmeConfiguration *demo2 =[[AcmeConfiguration alloc] init];
    demo2.eumKey = @"demo-AAB-AUY";
    demo2.acmeUrl = @"http://54.214.16.198:8000/appdynamicspilot/";
    demo2.collectorUrl = @"http:/54.71.42.123:9001";
    demo2.username = @"test";
    demo2.password = @"appdynamics";
    [map setValue:demo2 forKey:@"demo2"];
    
    AcmeConfiguration *demo3 =[[AcmeConfiguration alloc] init];
    demo3.eumKey = @"DEMO-AAB-AUM";
    demo3.acmeUrl = @"http://54.203.82.235/appdynamicspilot/";
    demo3.collectorUrl = @"http://54.244.95.83:9001";
    demo3.username = @"test";
    demo3.password = @"appdynamics";
    [map setValue:demo3 forKey:@"demo3"];
    
    AcmeConfiguration *demo4 =[[AcmeConfiguration alloc] init];
    demo4.eumKey = @"DEMO-AAB-AUN";
    demo4.acmeUrl = @"http://54.71.114.82/appdynamicspilot/";
    demo4.collectorUrl = @"http://54.244.95.83:9001";
    demo4.username = @"test";
    demo4.password = @"appdynamics";
    [map setValue:demo4 forKey:@"demo4"];
    
    //    AcmeConfiguration *staging =[[AcmeConfiguration alloc] init];
    //    staging.eumKey = @"EUM-AAB-AUA";
    //    staging.acmeUrl = @"http://54.203.82.235/appdynamicspilot/";
    //    staging.collectorUrl = @"http:/54.71.42.123:9001";
    //    staging.username = @"test";
    //    staging.password = @"appdynamics";
    //    [map setValue:staging forKey:@"staging"];
    
}

- (void)tearDown {
    [super tearDown];
}


- (void)testExample {
    //    [tester tapViewWithAccessibilityLabel:@"OK"];
    NSEnumerator *enumerator = [map keyEnumerator];
    
    id key;
    while((key = [enumerator nextObject])) {
        //    AcmeConfiguration *config  = [map objectForKey:key];
        //        [tester tapViewWithAccessibilityLabel:@"Settings"];
        //
        //    [tester clearTextFromAndThenEnterText:config.acmeUrl intoViewWithAccessibilityLabel:@"BookstoreUrl"];
        //        [tester clearTextFromAndThenEnterText:config.collectorUrl intoViewWithAccessibilityLabel:@"CollectorUrl"];
        //    [tester clearTextFromAndThenEnterText:config.username intoViewWithAccessibilityLabel:@"Username"];
        //    [tester clearTextFromAndThenEnterText:config.password intoViewWithAccessibilityLabel:@"Password"];
        //    [tester clearTextFromAndThenEnterText:config.eumKey intoViewWithAccessibilityLabel:@"Appkey"];
        //    [tester tapViewWithAccessibilityLabel:@"return"];
        //    [tester tapViewWithAccessibilityLabel:@"Save"];
        //    [tester tapViewWithAccessibilityLabel:@"OK"];
        
        
        unsigned int i = 0;
        unsigned int count = 1;
        
        for (i=0; i < count; i++) {
            [tester waitForViewWithAccessibilityLabel:@"Best Sellers"];
            [tester tapViewWithAccessibilityLabel:@"Best Sellers"];
            
            [tester tapViewWithAccessibilityLabel:@"Refresh"];
            [NSThread sleepForTimeInterval:1.0f];
            int maxBooks =arc4random() % sizeof kTitles/sizeof (kTitles[0]);
            int randomCrash =arc4random() % CRASH_INTERVAL;
            
            if (randomCrash!=kRandomCrash) {
                for (int i=1; i<maxBooks;i++) {
                    [self addToCart:kTitles[arc4random()%maxBooks]];
                }
            } else {
                [self crashTheApp];
            }
            
            [tester waitForViewWithAccessibilityLabel:@"CheckoutButton"];
            [tester tapViewWithAccessibilityLabel:@"CheckoutButton"];
            [tester waitForViewWithAccessibilityLabel:@"OK"];
            [tester tapViewWithAccessibilityLabel:@"OK"];
            [tester tapViewWithAccessibilityLabel:@"Best Sellers"];
            [tester tapViewWithAccessibilityLabel:@"Best Sellers"];
            [tester tapViewWithAccessibilityLabel:@"Refresh"];
        }
    }
}

- (void) addToCart:(NSString *) title {
    [tester tapViewWithAccessibilityLabel:@"Best Sellers"];
    [tester tapViewWithAccessibilityLabel:@"Best Sellers"];
    NSLog(@"Title is %@", title);
    [tester waitForViewWithAccessibilityLabel:title];
    [tester tapViewWithAccessibilityLabel:title];
    [tester waitForViewWithAccessibilityLabel:@"Add To Cart"];
    [tester tapViewWithAccessibilityLabel:@"Add To Cart"];
    
}
-(void) crashTheApp {
    [tester tapViewWithAccessibilityLabel:@"Settings"];
    [tester tapViewWithAccessibilityLabel:@"CrashMe"];
}



@end
