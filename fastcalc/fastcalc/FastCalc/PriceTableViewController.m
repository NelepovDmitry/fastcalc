//
//  PriceTableViewController.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PriceTableViewController.h"
#import "PriceCell.h"
#import "MenuItem.h"

@interface PriceTableViewController ()

- (void)setTableViewFrameByCells;

@end

@implementation PriceTableViewController

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture.png"]];
    mArrayOfProducts = [[NSMutableArray alloc] init];
    mArrayOfCounts = [[NSMutableArray alloc] init];
    //[mArrayOfProducts addObject:[MenuItem menuItemWithName:@"чизбургер" price:[NSNumber numberWithInt:12]]];
    //[mArrayOfProducts addObject:[MenuItem menuItemWithName:@"мак" price:[NSNumber numberWithInt:12]]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = 1;
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = mArrayOfProducts.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"PriceCell";
    
    PriceCell *cell= (PriceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for (id currentObject in array) {
            if ([currentObject isKindOfClass:[PriceCell class]]) {
                cell = currentObject;
                break;
            }
        }
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    }
    MenuItem *menuItem = [mArrayOfProducts objectAtIndex:indexPath.row];
    cell.nameLbl.text = menuItem.menuName;
    //NSLog(@"priceLbl font %@", cell.priceLbl.font);
    cell.priceLbl.text = menuItem.menuPrice.stringValue;
    NSNumber *countNumber = [mArrayOfCounts objectAtIndex:indexPath.row];
    cell.countLbl.text = [NSString stringWithFormat:@"%@ x", countNumber.stringValue];
    return cell;
}

/*- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
}*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
    [mArrayOfProducts release];
    [mArrayOfCounts release];
    [super dealloc];
}

#pragma mark - Public Functions

- (void)addNewProduct:(MenuItem *)menuItem {
    BOOL p = false;
    for(int i = 0; i < mArrayOfProducts.count; ++i) {
        MenuItem *oneItem = [mArrayOfProducts objectAtIndex:i];
        if(oneItem.objectId.integerValue == menuItem.objectId.integerValue) {
            NSNumber *number = [mArrayOfCounts objectAtIndex:i];
            [mArrayOfCounts replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:number.integerValue + 1]];
            p = true;
        }
    }
    if(!p) {
        [mArrayOfProducts addObject:menuItem];
        [mArrayOfCounts addObject:[NSNumber numberWithInt:1]];
    }
    //NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:mArrayOfProducts.count - 1 inSection:0]];
    //[self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView reloadData];
    //[self goToTop:NO];
}

- (void)goToTop:(BOOL)toTop {
    int count = mArrayOfProducts.count;
    if(count > 0) {
        [self setTableViewFrameByCells];
        if(toTop) {
            if(count > 7) {
                self.tableView.scrollEnabled = YES;
            } else {
                self.tableView.scrollEnabled = NO;
            }
        } else {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            self.tableView.scrollEnabled = NO;
        }
    }
}

- (void)clearCheck {
    [mArrayOfProducts removeAllObjects];
    [mArrayOfCounts removeAllObjects];
    [self.tableView reloadData];
    [self setTableViewFrameByCells];
}

#pragma mark - Private Functions

- (void)setTableViewFrameByCells {
    //[UIView beginAnimations : @"Display notif" context:nil];
    //[UIView setAnimationDuration:1.0f];
    //[UIView setAnimationBeginsFromCurrentState:FALSE];
    CGRect frame = [self.tableView frame];
    int count = mArrayOfProducts.count;
    if(count < 7) {
        frame.size.height = [[self.tableView dataSource] tableView: self.tableView numberOfRowsInSection: 0] *
        [[self.tableView delegate] tableView: self.tableView heightForRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 0]];
    } else {
        frame.size.height = BEGIN_HEIGHT;
    }
    [self.tableView setFrame: frame];
    //[UIView commitAnimations];
}

#pragma  mark - Price Cell Delegate 

- (void)deleteAtIndex:(id)sender {
    PriceCell * clickedCell = (PriceCell *)[[sender superview] superview];
    NSIndexPath * clickedButtonPath = [self.tableView indexPathForCell:clickedCell];
    MenuItem *menuItem = [[mArrayOfProducts objectAtIndex:clickedButtonPath.row] retain];
    NSNumber *count = [[mArrayOfCounts objectAtIndex:clickedButtonPath.row] retain];
    [mArrayOfProducts removeObjectAtIndex:clickedButtonPath.row];
    [mArrayOfCounts removeObjectAtIndex:clickedButtonPath.row];
    NSArray *paths = [NSArray arrayWithObject:clickedButtonPath];
    [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView reloadData];
    [delegate deleteProductWithPrice:menuItem count:count];
    [menuItem release];
    [count release];
}

@end
