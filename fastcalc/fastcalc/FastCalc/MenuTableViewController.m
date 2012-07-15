//
//  MenuTableViewController.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MenuCell.h"
#import "InternetUtils.h"
#import "JSON.h"
#import "MenuItem.h"
#import "ApplicationSingleton.h"
#import "ZipArchive.h"
#import "GroupItem.h"
#import "IIViewDeckController.h"

@interface MenuTableViewController ()
- (void)setMainProp;

- (void)cellTouchUp:(id)sender;
- (void)cellTouchDown:(id)sender;
- (void)cellTouchUpCancel:(id)sender;

@end

@implementation MenuTableViewController

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setMainProp];
    //[self requsetMenuById:mApplicationSingleton.idOfMenu];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
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
    /*int count = 0;
    if(mArrayOfProductsNames.count > indexOfMenu) {
        NSString *key = [mArrayOfProductsNames objectAtIndex:indexOfMenu];
        NSArray *arrayOfBrands = [mDictOfProducts objectForKey:key];
        count = arrayOfBrands.count;
    }*/
    return arrayOfProducts.count;
}

- (MenuCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    
    MenuCell *cell= (MenuCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for (id currentObject in array) {
            if ([currentObject isKindOfClass:[MenuCell class]]) {
                cell = currentObject;
                break;
            }
        }
    }
    MenuItem *menuItem = [arrayOfProducts objectAtIndex:indexPath.row];
    cell.textLabel.text = menuItem.menuName;
    [cell.backgroundImage addTarget:self action:@selector(cellTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [cell.backgroundImage addTarget:self action:@selector(cellTouchUpCancel:) forControlEvents:UIControlEventTouchCancel];
    [cell.backgroundImage addTarget:self action:@selector(cellTouchDown:) forControlEvents:UIControlEventTouchDown];
    cell.priceLabel.text = menuItem.menuPrice.stringValue;
    UIImage *image = [mApplicationSingleton.dictOfMenuImages objectForKey:menuItem.menuPicturePath];
    cell.menuImage.image = image;
    cell.caloriesLabel.text = menuItem.menuKcal.stringValue;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - Public functions

- (void)setArrayOfTableView:(NSArray *)array {
    [arrayOfProducts removeAllObjects];
    arrayOfProducts = [[NSMutableArray alloc] initWithArray:array];
    [self.tableView reloadData];
}

#pragma mark - Cell touch actions

- (void)cellTouchDown:(id)sender {
    MenuCell * clickedCell = (MenuCell *)[[sender superview] superview];
    clickedCell.menuImage.alpha = 0.5f;
    clickedCell.textLabel.alpha = 0.5f;
    clickedCell.priceLabel.alpha = 0.5f;
    clickedCell.rublImage.alpha = 0.5f;
    clickedCell.caloriesLabel.alpha = 0.5f;
}

- (void)cellTouchUp:(id)sender {
    MenuCell * clickedCell = (MenuCell *)[[sender superview] superview];
    clickedCell.menuImage.alpha = 1;
    clickedCell.textLabel.alpha = 1;
    clickedCell.priceLabel.alpha = 1;
    clickedCell.rublImage.alpha = 1;
    clickedCell.caloriesLabel.alpha = 1;
    NSIndexPath * clickedButtonPath = [self.tableView indexPathForCell:clickedCell];
    //NSString *key = [mArrayOfProductsNames objectAtIndex:indexOfMenu];
    //NSArray *arrayOfProducts = [mDictOfProducts objectForKey:key];
    MenuItem *menuItem = [arrayOfProducts objectAtIndex:clickedButtonPath.row];
    [delegate performSelectorInBackground:@selector(getNewPrice:) withObject:menuItem];
    //[delegate getNewPrice:menuItem];
    //[self tableView:self.tableView didSelectRowAtIndexPath:clickedButtonPath];
}

- (void)cellTouchUpCancel:(id)sender {
    MenuCell * clickedCell = (MenuCell *)[[sender superview] superview];
    clickedCell.menuImage.alpha = 1;
    clickedCell.textLabel.alpha = 1;
    clickedCell.priceLabel.alpha = 1;
    clickedCell.rublImage.alpha = 1;
    clickedCell.caloriesLabel.alpha = 1;
}

#pragma mark - Private functions

- (void)setMainProp {
    mApplicationSingleton = [ApplicationSingleton createSingleton];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

@end
