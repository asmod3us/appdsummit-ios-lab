//
//  Product.h
//  AcmeBookStore
//
//  Created by Adam Leftik on 6/17/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject
    @property (nonatomic, retain) NSNumber * id;
    @property (nonatomic, retain) NSString * title;
    @property (nonatomic, retain) NSString * imagePath;
    @property (strong, nonatomic) NSMutableData *imageData;
@end
