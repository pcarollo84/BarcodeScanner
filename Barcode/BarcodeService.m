//
//  BarcodeService.m
//  Barcode
//
//  Created by Paolo Carollo on 20/03/2018.
//  Copyright © 2018 Paolo Carollo. All rights reserved.
//

#import "BarcodeService.h"

@implementation BarcodeService

+ (instancetype)shared {
    static BarcodeService *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[self alloc] init];
    });
    return sharedService;
}

- (void)findBarcode:(NSString *)barcode withCompletionHandler:(void (^)(NSDictionary *ditcionary,  NSError *error))completionHandler {
    
    NSString *barcodeURLString = [NSString stringWithFormat:@"https://api.upcitemdb.com/prod/trial/lookup?upc=%@", barcode];
    NSURL *URL = [NSURL URLWithString:barcodeURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      NSDictionary *json = nil;
                                      if (data) {
                                          json = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];

                                      }
                                      
                                      NSDictionary *items = json[@"items"];
                                      if (items) {
                                          completionHandler(items, nil);
                                      } else {
                                          completionHandler(nil, error);
                                      }
                                      
                                      
                                  }];
    
    [task resume];
    
}

@end
