//
//  ItemImageRequest.h
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 6/27/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemImageRequest : NSObject
    -(id) initWithURLString: (NSString*) path;
    @property (strong, nonatomic) NSMutableData *imageData;
@end
