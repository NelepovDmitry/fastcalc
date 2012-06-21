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

@interface MenuTableViewController ()

- (void)getMenuItems:(NSData *)data;
- (void)setMainProp;

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
    [mArrayOfProductsNames release];
    [mInternetUtils release];
    [mDictOfProducts release];
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
    int count = 0;
    if(mArrayOfProductsNames.count > indexOfMenu) {
        NSString *key = [mArrayOfProductsNames objectAtIndex:indexOfMenu];
        NSArray *arrayOfBrands = [mDictOfProducts objectForKey:key];
        count = arrayOfBrands.count;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    NSString *key = [mArrayOfProductsNames objectAtIndex:indexOfMenu];
    NSArray *arrayOfProducts = [mDictOfProducts objectForKey:key];
    MenuItem *menuItem = [arrayOfProducts objectAtIndex:indexPath.row];
    cell.textLabel.text = menuItem.menuName;
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
    NSString *key = [mArrayOfProductsNames objectAtIndex:indexOfMenu];
    NSArray *arrayOfProducts = [mDictOfProducts objectForKey:key];
    MenuItem *menuItem = [arrayOfProducts objectAtIndex:indexPath.row];
    [delegate getNewPrice:menuItem];
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

- (void)nextMenu {
    indexOfMenu = (indexOfMenu + 1) % mDictOfProducts.count;
}

//http://fastcalc.orionsource.ru/api?apifastcalc.getMenuItemsZip={"menu_id":6,"responseBinary":1}
//http://fastcalc.orionsource.ru/api/?apifastcalc.getMenuItems={menu_id:6}
- (void)requsetMenuById:(NSNumber *)menuId {
    
    if([ApplicationSingleton isMenuExistinChache:menuId]) {
        
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:menuId forKey:@"menu_id"];
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"responseBinary"];
        [mInternetUtils makeURLRequestByNameResponser:@"getMenuItemsZip:" 
                                              urlCall:[NSURL URLWithString:@"http://fastcalc.orionsource.ru/api/"] 
                                        requestParams:[NSDictionary dictionaryWithObject:[dict JSONRepresentation] forKey:@"apifastcalc.getMenuItemsZip"]
                                            responder:self
                                 progressFunctionName:nil
         ];
    }
}

#pragma mark - Private functions

- (void)setMainProp {
    mArrayOfProductsNames = [[NSMutableArray alloc] init];
    mInternetUtils = [[InternetUtils alloc] init];
    mDictOfProducts = [[NSMutableDictionary alloc] init];
    indexOfMenu = 0;
}

- (void)getMenuItemsZip:(NSData *)data {
    
}

- (void)getMenuItems:(NSData *)data {
    [mDictOfProducts removeAllObjects];
    [mArrayOfProductsNames removeAllObjects];
    
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *mainDict = [json JSONValue];
    NSArray *arrayOfGroups = [mainDict valueForKeyPath:@"response.groups"];
    
    for(NSDictionary *dictOfgroup in arrayOfGroups) {
        NSArray *objectValues = [dictOfgroup objectForKey:@"items"];
        NSMutableArray *arrayOfobjects = [NSMutableArray array];
        for(NSDictionary *objectValue in objectValues) {
            MenuItem *menuItem = [[MenuItem alloc] initWithArray:[objectValue objectForKey:@"objectValues"]];
            [arrayOfobjects addObject:menuItem];
            [menuItem release];
        }
        [mArrayOfProductsNames addObject:[dictOfgroup objectForKey:@"groupname"]];
        [mDictOfProducts setObject:arrayOfobjects forKey:[dictOfgroup objectForKey:@"groupname"]];
    }
    [self.tableView reloadData];
}

@end
