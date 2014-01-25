//
//  CompanyViewController.m
//  Seva
//
//  Created by Vadym Zakovinko on 1/25/14.
//  Copyright (c) 2014 Vadym Zakovinko. All rights reserved.
//

#import "CompanyViewController.h"
#import "Technology.h"

@interface CompanyViewController () {
    NSArray *technologies;
}

@end

@implementation CompanyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Technology"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"avg_level" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error;
    NSInteger oldAvgLevel = 0;
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSMutableArray *group = [[NSMutableArray alloc] init];
    for (Technology *tech in [context executeFetchRequest:fetchRequest error:&error]) {
        if ([[tech valueForKey:@"avg_level"] integerValue] != oldAvgLevel) {
            if ([group count] > 0) {
                [results addObject:group];
            }
            oldAvgLevel = [[tech valueForKey:@"avg_level"] integerValue];
            group = [[NSMutableArray alloc] init];
        }
        [group addObject:tech];
    }

    technologies = [results copy];
    results = nil;
    group = nil;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [technologies count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[technologies objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Technology *t = [[technologies objectAtIndex:section] objectAtIndex:0];
    NSLog(@"%@", t);
    return [NSString stringWithFormat:@"★ x %d", [[t valueForKey:@"avg_level"] integerValue]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    Technology *technology = [[technologies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSLog(@"%@", technology);
    NSNumber *avgLevel = [technology valueForKey:@"avg_level"];
    NSMutableString *details = [[NSMutableString alloc] init];
    for (int i=0; i<[avgLevel intValue]; i++) {
        [details appendString:@"★"];
    }

//    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    cell.textLabel.text = [technology valueForKey:@"title"];
    cell.detailTextLabel.text = details;
    
//    cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
//    cell.textLabel.shadowColor = [UIColor colorWithWhite:0.1 alpha:0.6];
//    cell.detailTextLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.1 alpha:1];
//    cell.detailTextLabel.shadowColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
