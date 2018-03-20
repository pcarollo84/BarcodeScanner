//
//  InputViewController.m
//  Barcode
//
//  Created by Paolo Carollo on 20/03/2018.
//  Copyright © 2018 Paolo Carollo. All rights reserved.
//

#import "InputViewController.h"
#import "BarcodeDetailTableViewController.h"

@interface InputViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;


@property (strong, nonatomic) NSString *barcode;

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[BarcodeDetailTableViewController class]]) {
        BarcodeDetailTableViewController *viewController = (BarcodeDetailTableViewController *)segue.destinationViewController;
        viewController.barcode = self.barcode;
    }
}

#pragma mark - Handlers

- (IBAction)handleSearchButtonDidTouchUpInside:(id)sender {
    
    self.barcode = self.inputTextField.text;
    [self performSegueWithIdentifier:@"barcodeDetailSegue" sender:nil];
    
}

@end
