//
//  ItemImageRequest.m
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 6/27/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import "ItemImageRequest.h"

@implementation ItemImageRequest
    NSURLConnection *urlImg;
    @synthesize imageData;

-(id) initWithURLString: (NSString*) path {
    self = [super init];
    imageData = [[NSMutableData alloc] init];
    NSLog(@"*** URL PATH *** %@", path);
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:path]
                                          cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSURLResponse *response = nil;
    NSError *error = nil;
    imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    return self;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
}

@end
