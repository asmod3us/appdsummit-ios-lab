//
//  AppDelegate.m
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 6/24/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "CartViewController.h"
#import "SettingsViewController.h"
#import "Reachability.h"

@implementation AppDelegate
    @synthesize managedObjectContext = _managedObjectContext;
    @synthesize managedObjectModel = _managedObjectModel;
    @synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
    @synthesize username = _username;
    @synthesize password = _password;

    @synthesize url = _url;
    @synthesize offline = _offline;
    @synthesize appKey = _appKey;
    @synthesize collectorUrl = _collectorUrl;
    @synthesize isConnected = _isConnected;
    @synthesize tabBarController = _tabBarController;

    NSString* const kUsername			= @"username";
    NSString* const kPassword			= @"password";
    NSString* const kUrl                = @"url";
    NSString* const kOffline            = @"offline";
    NSString* const kAppKey             = @"appKey";
    NSString* const kCollectorUrl       = @"collectorUrl";
    NSString* const kSQLLite            = @"AcmeBookstore.sqlite";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&HandleExceptions);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(onDefaultsChanged:)
                                          name:NSUserDefaultsDidChangeNotification
                                          object:nil];
    
    [self populateRegistrationDomain];
    [self setupReachabilityNotification];
    [self deleteSQLLite];
    _isConnected = [self isReachable];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    masterViewController.managedObjectContext = self.managedObjectContext;
    masterViewController.window = self.window;

    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    
    CartViewController *cartViewController = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
    cartViewController.managedObjectContext = self.managedObjectContext;
    
    UINavigationController *cartNavigationController = [[UINavigationController alloc] initWithRootViewController:cartViewController];
    
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController setAccessibilityLabel:@"TabBar"];
    [navigationController setAccessibilityLabel:@"Best Sellers"];
    [settingsNavigationController setAccessibilityLabel:@"Settings"];
    _tabBarController.viewControllers = @[navigationController,cartNavigationController,settingsNavigationController];
    _window.rootViewController = self.tabBarController;
    [self saveContext];
    [self.window makeKeyAndVisible];
    
    NSString *userurl = [_url stringByAppendingString:@"rest/user"];
    self.session = [[ShoppingCartSession alloc] initWithURLString:userurl];
    return YES;

}


-(void) setupReachabilityNotification {
    NSURL *url = [[NSURL alloc] initWithString:_url];
    Reachability* reach = [Reachability reachabilityWithHostname:url.host];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];
}


-(void) reachabilityChanged:(NSNotification*)notifcation
{
    Reachability *  reach = [notifcation object];
    if (reach.isReachable) {
        [self pingSite];
    } else {
        _isConnected = FALSE;
    }
}

-(BOOL) isReachable {
    NSURL *url = [[NSURL alloc] initWithString:_url];
    Reachability* reach = [Reachability reachabilityWithHostname:url.host];
    if (reach.isReachable) {
        return [self pingSite];
        
    }
    return reach.isReachable;
}

-(BOOL) pingSite {
    NSMutableString *cartUrl = [_url stringByAppendingString:@"rest/ping"];
    NSURL *url = [NSURL URLWithString:cartUrl];
    NSLog(@"URL is :%@ ", cartUrl);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    NSURLResponse *response = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    if (code != 204) {
        _isConnected = FALSE;
        return _isConnected;
    } else {
        _isConnected = TRUE;
        return _isConnected;
    }
    
}

-(void) loadShoppingCartFromDisk {

    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Employee" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"title" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void) deleteSQLLite {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *sqlPath = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kSQLLite];
    if ([fileManager fileExistsAtPath:sqlPath.path]) {
        [fileManager removeItemAtURL:sqlPath error:&error];
        NSLog(@"The app has encountered an unhandled exception: %@", [error debugDescription]);
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EcommerceMobileApplication" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kSQLLite];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        [NSFetchedResultsController deleteCacheWithName:@"Master"];
    }
    
    return _persistentStoreCoordinator;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    if (code != 204) {
        _isConnected = FALSE;
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)populateRegistrationDomain
{
    NSURL *settingsBundleURL = [[NSBundle mainBundle] URLForResource:@"Settings" withExtension:@"bundle"];
    
    // loadDefaults:fromSettingsPage:inSettingsBundleAtURL: expects its caller
    // to pass it an initialized NSMutableDictionary.
    NSMutableDictionary *appDefaults = [NSMutableDictionary dictionary];
    
    // Invoke loadDefaults:fromSettingsPage:inSettingsBundleAtURL: on the property
    // list file for the root settings page (always named Root.plist).
    [self loadDefaults:appDefaults fromSettingsPage:@"Root.plist" inSettingsBundleAtURL:settingsBundleURL];
    
    // appDefaults is now populated with the preferences and their default values.
    // Add these to the registration domain.
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Preferences
    - (void) onDefaultsChanged:(NSNotification*) aNotification
    {
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        _username = [standardDefaults objectForKey:kUsername];
        _password = [standardDefaults objectForKey:kPassword];
        _url = [standardDefaults objectForKey:kUrl];
        _appKey = [standardDefaults objectForKey:kAppKey];
        _collectorUrl = [standardDefaults objectForKey:kCollectorUrl];
        NSLog(@"username is when changed %@", _username);
    }



- (void)loadDefaults:(NSMutableDictionary*)appDefaults fromSettingsPage:(NSString*)plistName inSettingsBundleAtURL:(NSURL*)settingsBundleURL
{

    // Create an NSDictionary from the plist file.
    NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfURL:[settingsBundleURL URLByAppendingPathComponent:plistName]];
    
    // The elements defined in a settings page are contained within an array
    // that is associated with the root-level PreferenceSpecifiers key.
    NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
    
    for (NSDictionary *prefItem in prefSpecifierArray)
        // Each element is itself a dictionary.
    {
        // What kind of control is used to represent the preference element in the
        // Settings app.
        NSString *prefItemType = prefItem[@"Type"];
        // How this preference element maps to the defaults database for the app.
        NSString *prefItemKey = prefItem[@"Key"];
        // The default value for the preference key.
        NSString *prefItemDefaultValue = prefItem[@"DefaultValue"];
        
        if ([prefItemType isEqualToString:@"PSChildPaneSpecifier"])
            // If this is a 'Child Pane Element'.  That is, a reference to another
            // page.
        {
            // There must be a value associated with the 'File' key in this preference
            // element's dictionary.  Its value is the name of the plist file in the
            // Settings bundle for the referenced page.
            NSString *prefItemFile = prefItem[@"File"];
            
            // Recurs on the referenced page.
            [self loadDefaults:appDefaults fromSettingsPage:prefItemFile inSettingsBundleAtURL:settingsBundleURL];
        }
        else if (prefItemKey != nil && prefItemDefaultValue != nil)
            // Some elements, such as 'Group' or 'Text Field' elements do not contain
            // a key and default value.  Skip those.
        {
            [appDefaults setObject:prefItemDefaultValue forKey:prefItemKey];
        }
    }
     NSLog(@"username is %@", _username);
}



void HandleExceptions(NSException *exception) {
    NSLog(@"The app has encountered an unhandled exception: %@", [exception debugDescription]);
    // Save application data on crash
}

-(void) relogin {
    NSLog(@"******** LOGGING IN ******");
    self.session = [[ShoppingCartSession alloc] initWithURLString:_url];
    NSLog(@"******** NEW'Ed a SESSION  ******");    
}




@end
