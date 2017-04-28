//
//  AppDelegate.h
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 6/24/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartSession.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
    @property (strong, nonatomic) UIWindow *window;
    @property (strong, nonatomic) ShoppingCartSession *session;
    @property (strong, nonatomic) UITabBarController *tabBarController;
    @property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
    @property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
    @property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
    @property (strong, nonatomic) NSString *username;
    @property (strong, nonatomic) NSString *password;
    @property (strong, nonatomic) NSString *url;
    @property (strong, nonatomic) NSString *collectorUrl;
    @property (strong, nonatomic) NSString *appKey;
    @property (nonatomic) BOOL isConnected;
    @property (nonatomic) BOOL *offline;

    extern  NSString * const kUsername;
    extern  NSString * const kPassword;
    extern  NSString * const kUrl;
    extern  NSString * const kAppKey;
    extern  NSString * const kCollectorUrl;
- (void)  relogin;
@end
