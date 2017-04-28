//
//  CartViewController.h
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 7/2/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DetailViewController.h"

@interface CartViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIButton *checkoutButton;
@property (nonatomic, strong, readwrite) IBOutlet UIActivityIndicatorView *   activityIndicator;
@property (strong, nonatomic) UIWindow *window;

@end
