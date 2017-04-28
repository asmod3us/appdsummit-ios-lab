//
//  CartItem.h
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 7/11/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CartItem : NSManagedObject
    @property (nonatomic, retain) NSNumber * id;
    @property (nonatomic, retain) NSNumber * itemId;
    @property (nonatomic, retain) NSString * title;
    @property (nonatomic, retain) NSString * imagePath;
    @property (strong, nonatomic) NSMutableData *imageData;
@end
