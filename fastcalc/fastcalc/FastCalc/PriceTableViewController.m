//
//  PriceTableViewController.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PriceTableViewController.h"
#import "PriceCell.h"

@interface PriceTableViewController ()

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
    [self tableView].backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture.png"]];
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
    int count = COUNT;
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
    cell.textLabel.text = @"data";
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
    [mTableView release];
    [super dealloc];
}

#pragma mark - Custom Functions

- (void)goToTop:(BOOL)toTop {
    if(COUNT > 8) {
        [mTableView setFrame: CGRectMake(0, 0, mTableView.frame.size.width, BEGIN_HEIGHT)];
    } else {
        //set size from count of cells
        CGRect frame = [mTableView frame];
        frame.size.height = [[mTableView dataSource] tableView: mTableView numberOfRowsInSection: 0] *
        [[mTableView delegate] tableView: mTableView heightForRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 0]];
        frame.origin.y = 0;
        [mTableView setFrame: frame];
    }
    if(toTop) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } else {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:COUNT - 1 inSection:0];
        [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

@end
