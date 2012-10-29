//
//  BankViewController.m
//  barmanager
//
//  Created by Joshua Jansen on 26-10-12.
//  Copyright (c) 2012 ITflows. All rights reserved.
//

#import "BankViewController.h"

@interface BankViewController ()
    - (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation BankViewController

@synthesize dataModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    balance = 0.00;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/users/%@.json", dataModel.user_id] delegate:self];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSArray * resource_path_array = [[objectLoader resourcePath] componentsSeparatedByString:@"?"];
    objectLoader.resourcePath = [resource_path_array objectAtIndex:0];
    
    if ([objectLoader wasSentToResourcePath:[NSString stringWithFormat:@"/users/%@.json", dataModel.user_id]]) {
        User *user = [objects objectAtIndex:0];
        NSLog(@"Loaded User ID #%@ -> Name: %@, Balance: %@", user.userId, user.name, user.balance);
        
        balance = [user.balance doubleValue];
        transaction_count = [ user.bank_transactions count ];
        bank_transactions = user.bank_transactions;
        [self.tableView reloadData];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return [NSString stringWithFormat:@"Huidige balans: € %.2f", balance];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return transaction_count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UIFont *textFont = [ UIFont fontWithName: @"Arial" size: 12.0 ];
    UIFont *detailFont = [ UIFont fontWithName: @"Arial" size: 12.0 ];
    cell.textLabel.font  = textFont;
    cell.detailTextLabel.font = detailFont;
    
    BankTransaction *transaction = [bank_transactions objectAtIndex:[indexPath row]];
    cell.textLabel.text = transaction.description;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"€ %.2f", [transaction.amount doubleValue]];
}

@end