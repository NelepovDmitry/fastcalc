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
    [mArrayOfProducts addObject:@"Спасибо за покупку"];
    [mArrayOfProducts addObject:@"кофе"];
    [mArrayOfProducts addObject:@"чизбургер"];
    [mArrayOfProducts addObject:@"мак"];
    self.tableView.editing = YES;
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
    PriceCell *cell= (PriceCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for (id currentObject in array) {
            if ([currentObject isKindOfClass:[PriceCell class]]) {
                cell = currentObject;
                break;
            }
        }
    }
    cell.textLabel.text = [mArrayOfProducts objectAtIndex:indexPath.row];
    return cell;
}

/*- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
}*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
    [mArrayOfProducts release];
    [super dealloc];
}

#pragma mark - Public Functions

- (void)addNewProduct:(MenuItem *)menuItem {
    [mArrayOfProducts addObject:menuItem.menuName];
    //NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:mArrayOfProducts.count - 1 inSection:0]];
    //[self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView reloadData];
    [self goToTop:NO];
}

- (void)goToTop:(BOOL)toTop {
    int count = mArrayOfProducts.count;
    if(count > 0) {
        if(count > 8) {
            [self.tableView setFrame: CGRectMake(0, 0, self.tableView.frame.size.width, BEGIN_HEIGHT)];
        } else {
            //set size from count of cells
            self.tableView.scrollEnabled = NO;
            [self setTableViewFrameByCells];
        }
        if(toTop) {
            if(count > 8) {
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
    [mArrayOfProducts addObject:@"Спасибо за покупку"];
    [self.tableView reloadData];
    [self setTableViewFrameByCells];
}

#pragma mark - Private Functions

- (void)removePriduct {
    
}

- (void)setTableViewFrameByCells {
    //[UIView beginAnimations : @"Display notif" context:nil];
    //[UIView setAnimationDuration:1.0f];
    //[UIView setAnimationBeginsFromCurrentState:FALSE];
    CGRect frame = [self.tableView frame];
    frame.size.height = [[self.tableView dataSource] tableView: self.tableView numberOfRowsInSection: 0] *
    [[self.tableView delegate] tableView: self.tableView heightForRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 0]];
    frame.origin.y = 0;
    [self.tableView setFrame: frame];
    //[UIView commitAnimations];
}

@end
