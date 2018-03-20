//
//  BarcodeDetailTableViewController.m
//  Barcode
//
//  Created by Paolo Carollo on 20/03/2018.
//  Copyright © 2018 Paolo Carollo. All rights reserved.
//

#import "BarcodeDetailTableViewController.h"
#import "BarcodeService.h"

static NSString *detailCellId = @"BarcodeDetailCellId";

@interface BarcodeDetailTableViewController ()

@property (strong, nonnull, nonatomic) NSArray *items;
@property (strong, nonnull, nonatomic) NSDictionary *itemDictionary;

@end

@implementation BarcodeDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BarcodeService shared] findBarcode:self.barcode withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {

            self.items = dictionary[@"items"];
            NSDictionary *allValuesDictionary = (NSDictionary *)self.items.firstObject;

            NSArray *validKeysToShow = @[@"title", @"brand", @"elid"];
            
            NSMutableDictionary *mutableItemDictionary = [[NSMutableDictionary alloc] init];
            for (NSString *validKey in validKeysToShow) {
                mutableItemDictionary[validKey] = allValuesDictionary[validKey];
            }
            
            self.itemDictionary = mutableItemDictionary;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
            
        } else {
            
            // TODO: Handle the error
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWithMessage:error.localizedDescription];
            });
        }
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellId forIndexPath:indexPath];
    
    NSString *key = (NSString *)_itemDictionary.allKeys[indexPath.row];
    if (key && key.length > 0) {
        cell.textLabel.text = key;
    }
    
    if ([_itemDictionary.allValues[indexPath.row] isKindOfClass:[NSString class]]) {
        NSString *value = _itemDictionary.allValues[indexPath.row];
        cell.detailTextLabel.text = value;
    }
    
    return cell;
}

#pragma mark - Error

- (void)showAlertWithMessage:(NSString *)errorMessage {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Attention!"
                                                                             message:errorMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
