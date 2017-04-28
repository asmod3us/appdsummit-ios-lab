//
//  DetailViewController.m
//  AcmeBookStore
//
//  Created by Adam Leftik on 6/16/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import "DetailViewController.h"
#import "ShoppingCartSession.h"
#import "AppDelegate.h"
#import "CartViewController.h"

@interface DetailViewController ()

- (void)configureView;
- (void)addToCart:(id) sender;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"title"] description];

        UIImage *image = [[UIImage alloc] initWithData:[self.detailItem valueForKey:@"imageData"]];
        self.imageView.image = image;
        
        self.addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add to Cart" style:UIBarButtonSystemItemAdd target:self action:@selector(addToCart:)];
        self.navigationItem.rightBarButtonItem = self.addButton;
        
        [self.navigationItem.rightBarButtonItem setAccessibilityLabel:@"Add To Cart"];
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        
        NSDecimalNumber *priceDecimal = (NSDecimalNumber *)[self.detailItem valueForKey:@"price"];
        NSString *currencyLabel = @"Buy New";
        self.priceLabel.text = [currencyLabel stringByAppendingString:[formatter stringFromNumber: priceDecimal]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self configureView];
}



-(void) addToCart:(id) sender
{
    NSLog(@"add to cart");
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if ([appDelegate.session shouldLogin])  {
        [appDelegate.session login];
    }
    
    NSNumber *theId = [self.detailItem valueForKey:@"id"];
    
    NSMutableString *cartUrl = [NSString stringWithString:appDelegate.url];
    cartUrl = [appDelegate.url stringByAppendingString:@"rest/cart/"];
    NSLog(@"URL is :%@ ", cartUrl);
    NSMutableString *itemId = [theId stringValue];
    cartUrl =  [cartUrl stringByAppendingString:itemId];
    NSURL *url = [NSURL URLWithString:cartUrl];
    NSLog(@"URL is :%@ ", cartUrl);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSLog(@"Session id to:%@", appDelegate.session.sessionId);
    [request setValue:appDelegate.session.sessionId forHTTPHeaderField:@"JSESSIONID"];
    [request setValue:appDelegate.username forHTTPHeaderField:@"USERNAME"];
    [request setValue:appDelegate.session.routeId forHTTPHeaderField:@"ROUTEID"];
    [request setValue:@"true" forHTTPHeaderField:@"appdynamicssnapshotenabled"];
    NSURLConnection *theURL = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:TRUE];

    
}

-(void) sendToCart {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    NSDictionary *responseHeaders = [httpResponse allHeaderFields];
    if (code == 204) {
        NSString *cartSize = [responseHeaders valueForKey:@"cart-size"];
        NSLog(@"Cart size %@", cartSize);
    

        NSLog(@"Response code %d", code);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *barController = appDelegate.tabBarController;
        NSArray *controllers = [barController viewControllers];
        NSLog(@"Num of Controllers %d ", [controllers count]);
        [self insertNewObject];
        UINavigationController *cartViewController = [controllers objectAtIndex:1];
        barController.selectedViewController=cartViewController;
    } else {
         NSLog(@"Response code %d", code);
    }
    
}

- (void)insertNewObject
{    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CartItem" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name]inManagedObjectContext:self.managedObjectContext];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[self.detailItem valueForKey:@"id"] forKey:@"id"];
    NSLog(@"detail id %@", [self.detailItem valueForKey:@"id"]);
    [newManagedObject setValue:[self.detailItem valueForKey:@"id"] forKey:@"itemId"];
    [newManagedObject setValue:[self.detailItem valueForKey:@"title"] forKey:@"title"];
     NSLog(@"item  id %@", [newManagedObject valueForKey:@"id"]);
    [newManagedObject setValue:[self.detailItem valueForKey:@"imagePath"] forKey:@"imagePath"];
     NSLog(@"item  id %@", [newManagedObject valueForKey:@"id"]);
    [newManagedObject setValue:[self.detailItem valueForKey:@"imageData"] forKey:@"imageData"];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received data");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Item Details", @"Item Details");
        
    }
    [self configureView];
    return self;
}


							
@end
