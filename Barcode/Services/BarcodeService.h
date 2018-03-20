//
//  BarcodeService.h
//  Barcode
//
//  Created by Paolo Carollo on 20/03/2018.
//  Copyright © 2018 Paolo Carollo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarcodeService: NSObject

+ (instancetype)shared;

- (void)findBarcode:(NSString *)barcode withCompletionHandler:(void (^)(NSDictionary *dictionary, NSError *error))completionHandler;

@end
