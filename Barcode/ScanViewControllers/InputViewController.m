//
//  InputViewController.m
//  Barcode
//
//  Created by Paolo Carollo on 20/03/2018.
//  Copyright © 2018 Paolo Carollo. All rights reserved.
//

#import "InputViewController.h"
#import "BarcodeDetailTableViewController.h"

@interface InputViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) NSString *barcode;

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.inputTextField.delegate = self;
    
    //  The button will be disable by default as the input will be empty at the start
    self.searchButton.enabled = NO;
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    //  do a simple validation disabling searchbutton if the barcode is less then 13 characters
    //  https://en.wikipedia.org/wiki/International_Article_Number#How_the_13-digit_EAN-13_is_encoded
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.searchButton.enabled = newString.length >= 13;
    
    return YES;
    
}

@end
