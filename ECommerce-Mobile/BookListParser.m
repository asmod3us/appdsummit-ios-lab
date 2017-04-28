//
//  BookListParser.m
//  AcmeBookStore
//
//  Created by Adam Leftik on 6/16/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookListParser.h"
#import "Product.h"
#import "ItemImageRequest.h"
#import "AppDelegate.h"


@implementation BookListParser
    NSMutableData *bookDataBookList;
    NSMutableString *currentNodeContentBookList;
    NSMutableString *currentElementBookList;
    NSMutableString *keyBookList;
    NSXMLParser     *parserBookList;
    NSEntityDescription *entityBookList;


- (void)parserDidStartDocument:(NSXMLParser *)parserBookList {
    self.bookList = [[NSMutableDictionary alloc] init];
    bookDataBookList = [[NSMutableData alloc] initWithCapacity:0];
}

- (void)parserDidEndDocument:(NSXMLParser *)parserBookList {
    [self saveContext];
    NSLog(@"Doc Parsed");
    NSLog(@"Count of books %d", [self.bookList count] );
}

- (void)parser:(NSXMLParser *)parserBookList didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    currentElementBookList = (NSMutableString *) [elementName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([elementName isEqualToString:@"product"]) {
        entityBookList = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.managedContext];
    }
}

- (void)parser:(NSXMLParser *)parserBookList foundCharacters:(NSString *)string {
    currentNodeContentBookList = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)parser:(NSXMLParser *)parserBookList didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
        if ([elementName isEqualToString:@"product"]) {
            [self.bookList setObject:entityBookList forKey:keyBookList];
        } else if ([elementName isEqualToString:@"title"]) {
            [entityBookList setValue:[currentNodeContentBookList copy] forKey:elementName];

        } else if ([elementName isEqualToString:@"id"]) {
            keyBookList = [currentNodeContentBookList copy];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterNoStyle];
            NSNumber *id = [f numberFromString:keyBookList];
            [entityBookList setValue:[id copy] forKey:elementName];
        } else if ([elementName isEqualToString:@"imagePath"]) {
            [entityBookList setValue:[currentNodeContentBookList copy] forKey:elementName];
            [self getImage: currentNodeContentBookList];
        } else if ([elementName isEqualToString:@"price"]) {
            NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:currentNodeContentBookList];
            [entityBookList setValue:[price copy] forKey:elementName];
        }
    
}

-(void) getImage: (NSString *) imagePath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *imageurl = [appDelegate.url stringByAppendingString:imagePath];
    ItemImageRequest *request = [[ItemImageRequest alloc] initWithURLString:imageurl];

    [entityBookList setValue:request.imageData forKey:@"imageData"];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //[bookDataBookList appendData:data];
    bookDataBookList = [NSMutableData dataWithData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    //[bookDataBookList setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[bookDataBookList length]);
    parserBookList = [[NSXMLParser alloc] initWithData:bookDataBookList ];
    parserBookList.delegate = self;
    [parserBookList parse];
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
