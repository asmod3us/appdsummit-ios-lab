//
//  SettingsViewController.h
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 8/29/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
    @property (nonatomic, retain) IBOutlet UITextField *bookstoreTextField;
    @property (nonatomic, retain) IBOutlet UITextField *eumUrl;
    @property (nonatomic, retain) IBOutlet UITextField *eumAppKey;
    @property (nonatomic, retain) IBOutlet UITextField *user;
    @property (nonatomic, retain) IBOutlet UITextField *password;
    @property (strong, nonatomic) IBOutlet UIButton *reloadButton;
    @property (strong, nonatomic) IBOutlet UIButton *saveButton;
    @property (strong, nonatomic) IBOutlet UIButton *crashMeButton;
    - (IBAction)savePressed;
    - (IBAction)reloadPressed;
    - (IBAction)crashMe;
@end
