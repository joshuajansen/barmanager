//
//  BarIndexViewController.m
//  barmanager
//
//  Created by Joshua Jansen on 29-10-12.
//  Copyright (c) 2012 ITflows. All rights reserved.
//

#import "BarIndexViewController.h"

@interface BarIndexViewController ()
@end

@implementation BarIndexViewController

@synthesize dataModel, bar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    
    bar_count = 0;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/bars.json" delegate:self];
    //self.managedObjectContext = appDelegate.managedObjectContext;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSArray * resource_path_array = [[objectLoader resourcePath] componentsSeparatedByString:@"?"];
    objectLoader.resourcePath = [resource_path_array objectAtIndex:0];
    
    if ([objectLoader wasSentToResourcePath:@"/bars.json"]) {
        NSLog(@"Loaded Bars");
        user_bars = objects;
        bar_count = [ user_bars count ];
        [self.tableView reloadData];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return bar_count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BarCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Bar *loadBar = [user_bars objectAtIndex:[indexPath row]];
    City *bar_city = [ loadBar.city objectAtIndex:0];
    cell.detailTextLabel.text = bar_city.name;
    cell.textLabel.text = loadBar.name;
    
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"loadBar"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.bar = [user_bars objectAtIndex:[indexPath row]];
        
        BarViewController *barViewController = segue.destinationViewController;
        barViewController.managedObjectContext = self.managedObjectContext;
        
        NSLog(@"Passing selected bar (%@) to BarViewController", self.bar.name);
        barViewController.bar = self.bar;
    }
}

@end