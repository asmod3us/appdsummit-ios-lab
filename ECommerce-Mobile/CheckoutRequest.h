//
//  CheckoutRequest.h
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 8/29/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckoutRequest : NSObject
    -(void) checkout;
    @property (strong, nonatomic) NSString *checkoutResponse;
@end
