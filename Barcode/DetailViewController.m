//
//  DetailViewController.m
//  Barcode
//
//  Created by Paolo Carollo on 20/03/2018.
//  Copyright © 2018 Paolo Carollo. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *scanContainerView;
@property (weak, nonatomic) IBOutlet UIView *inputContainerView;

@end

@implementation DetailViewController

- (void)configureView {
    
    switch (_actionType) {
        case kActionTypeScan:
            
            self.scanContainerView.hidden = NO;
            self.inputContainerView.hidden = YES;
            
            break;
        case kActionTypeInput:

            self.scanContainerView.hidden = YES;
            self.inputContainerView.hidden = NO;
            
            break;
        default:
            break;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item


@end
