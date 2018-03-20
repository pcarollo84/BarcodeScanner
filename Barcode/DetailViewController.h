//
//  DetailViewController.h
//  Barcode
//
//  Created by Paolo Carollo on 20/03/2018.
//  Copyright © 2018 Paolo Carollo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

