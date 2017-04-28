//
//  ShoppingCartSession.h
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 7/1/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartSession : NSObject
    @property (strong, nonatomic) NSString *sessionId;
    @property (strong, nonatomic) NSString *routeId;
    @property (strong, nonatomic) NSDate *sessionExpiresOn;
    @property (strong, nonatomic) NSArray *cartItems;

    -(id) initWithURLString: (NSString*) path;
    -(BOOL) shouldLogin;
    -(void) login;
    -(void) logout;
@end
