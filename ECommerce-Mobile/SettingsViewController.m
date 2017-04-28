//
//  SettingsViewController.m
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 8/29/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
    @synthesize bookstoreTextField = _bookstoreTextField;
    @synthesize eumAppKey = _eumAppKey;
    @synthesize eumUrl = _eumUrl;
    @synthesize user = _user;
    @synthesize password = _password;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.tabBarItem.image = [UIImage imageNamed:@"settings.png"];
        self.tabBarController.title = @"ACME Bookstore Settings";
    }
    
    return self;
}


-(void) updateSettings
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    _bookstoreTextField.text = appDelegate.url;
    _user.text = appDelegate.username;
    _password.text = appDelegate.password;
    _eumUrl.text = appDelegate.collectorUrl;
    _eumAppKey.text = appDelegate.appKey;


}

- (void) saveSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:_user.text forKey:kUsername];
    [prefs setValue:_password.text forKey:kPassword];
    [prefs setValue:_eumAppKey.text forKey:kAppKey];
    [prefs setValue:_bookstoreTextField.text forKey:kUrl];
    [prefs setValue:_eumUrl.text forKey:kCollectorUrl];
    [prefs synchronize];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved"
                                                    message:@"Settings Updated"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [self updateSettings];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate relogin];
    [alert show];
        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateSettings];
}

- (IBAction) crashMe {
   strcpy(0, "bla");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)savePressed {
    [self saveSettings];
}

- (IBAction)reloadPressed {
    [self updateSettings];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reloaded"
                                                    message:@"Settings Reloaded."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
