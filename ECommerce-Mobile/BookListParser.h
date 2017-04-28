//
//  BookListParser.h
//  AcmeBookStore
//
//  Created by Adam Leftik on 6/16/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BookListParser : NSObject
    @property(strong,atomic) NSMutableDictionary *bookList;
    @property NSManagedObjectContext *managedContext;
@end
