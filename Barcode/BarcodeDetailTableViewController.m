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
            self.itemDictionary = (NSDictionary *)self.items.firstObject;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
            
        } else {
            
            // TODO: Handle the error
            NSLog(@"%@", error.localizedDescription);
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
