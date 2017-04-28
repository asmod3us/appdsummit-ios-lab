//
//  ShoppingCartSession.m
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 7/1/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import "ShoppingCartSession.h"
#import "ItemImageRequest.h"
#import "AppDelegate.h"

@implementation ShoppingCartSession
    NSString *url;
    @synthesize cartItems;
    @synthesize sessionExpiresOn;
    @synthesize sessionId;
    @synthesize routeId;


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

}
-(BOOL) shouldLogin {
    if (sessionId == nil) {
        return true;
    }
    
    if ([sessionExpiresOn timeIntervalSinceNow] < 0) {
        return true;
    }
    return false;
}
-(void) logout {
    sessionId = nil;
}

-(void) login {
    NSLog(@"LOGME IN");
    NSURL *theUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:theUrl
                                                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                        timeoutInterval:60.0];
   
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *postString = @"username=";
    postString = [postString stringByAppendingString:appDelegate.username];
    postString = [postString stringByAppendingString:@"&password="];
    postString = [postString stringByAppendingString:appDelegate.password];
    NSData *postBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    
    NSHTTPURLResponse *response=nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *headers = [response allHeaderFields];

    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:theUrl];
    if (error > 0)  {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Error Communicating witht the Server" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show]; 
    }
    
    for (int i = 0; i < [cookies count]; i++) {
        NSHTTPCookie *cookie = ((NSHTTPCookie *) [cookies objectAtIndex:i]);
        NSLog(@"***COOKIE NAME? %@", [cookie name]);
        NSString *cookieName = [cookie name];
        if ([cookieName isEqualToString:@"JSESSIONID"]) {
            NSDictionary *cookieProps = [cookie properties];
            sessionId = [cookieProps objectForKey:NSHTTPCookieValue];
        }
        
        if ([cookieName isEqualToString:@"ROUTEID"]) {
            NSDictionary *cookieProps = [cookie properties];
            routeId = [cookieProps objectForKey:NSHTTPCookieValue];
        }

    }
    
        
        NSLog(@"************************** Session ID is %@ *****************", sessionId);
        NSDate *expiresOn = [[NSDate alloc] initWithTimeIntervalSinceNow:(30*60)];
        sessionExpiresOn = expiresOn;
        NSLog(@"Logged in expires on %@", expiresOn);
        NSLog(@"Logged in session id is %@", sessionId);
}

-(id) initWithURLString: (NSString*) path {
    self = [super init];
    url = path;
    [self login];
    return self;
}
    
@end
