//
//  ShoppingCartParser.h
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 7/9/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface ShoppingCartParser : NSObject
    @property(strong,atomic) NSMutableDictionary *cartItems;
    @property NSManagedObjectContext *managedContext;
@end
