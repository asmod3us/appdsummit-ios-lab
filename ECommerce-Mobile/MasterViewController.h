//
//  MasterViewController.h
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 6/24/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

@class DetailViewController;

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIWindow *window;
@end


