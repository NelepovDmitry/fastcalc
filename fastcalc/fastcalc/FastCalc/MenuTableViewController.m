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

@interface MenuTableViewController ()

- (void)getMenuItems:(NSData *)data;
- (void)setMainProp;
- (void)startPreloader;

- (void)cellTouchUp:(id)sender;
- (void)cellTouchDown:(id)sender;
- (void)cellTouchUpCancel:(id)sender;

@end

@implementation MenuTableViewController
@synthesize menuCell;

@synthesize delegate, arrayOfMenuItemGroups;

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
    [self requsetMenuById:mApplicationSingleton.idOfMenu];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setMenuCell:nil];
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
    [menuCell release];
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

- (MenuCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    
    MenuCell *cell= (MenuCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = menuCell;
		self.menuCell = nil;
    }
    
    NSString *key = [mArrayOfProductsNames objectAtIndex:indexOfMenu];
    NSArray *arrayOfProducts = [mDictOfProducts objectForKey:key];
    
    MenuItem *menuItem = [arrayOfProducts objectAtIndex:indexPath.row];
    cell.textLabel.text = menuItem.menuName;
    [cell.backgroundImage addTarget:self action:@selector(cellTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [cell.backgroundImage addTarget:self action:@selector(cellTouchUpCancel:) forControlEvents:UIControlEventTouchCancel];
    [cell.backgroundImage addTarget:self action:@selector(cellTouchDown:) forControlEvents:UIControlEventTouchDown];
    cell.priceLabel.text = [NSString stringWithFormat:@"%d руб.", menuItem.menuPrice.integerValue];
    UIImage *image = [mApplicationSingleton.dictOfMenuImages objectForKey:menuItem.menuPicturePath];
    cell.menuImage.image = image;
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

- (void)nextMenuByIndex:(NSInteger)menuIndex {
    indexOfMenu = menuIndex;
    [self.tableView reloadData];
}

//http://fastcalc.orionsource.ru/api?apifastcalc.getMenuItemsZip={"menu_id":6,"responseBinary":1}
//http://fastcalc.orionsource.ru/api/?apifastcalc.getMenuItems={menu_id:6}
- (void)requsetMenuById:(NSNumber *)menuId {
    if(menuId.integerValue == 0) {
        [mLoader dismissWithClickedButtonIndex:0 animated:YES];
        return;
    }
    indexOfMenu = 0;
    mApplicationSingleton.idOfMenu = menuId;
    [mApplicationSingleton commitSettings];
    [self startPreloader];
    if([ApplicationSingleton isMenuExistinChache:menuId]) {
        NSString *path = [mApplicationSingleton cacheDirectory];
        path = [NSString stringWithFormat:@"%@/%d", path, mApplicationSingleton.idOfMenu.integerValue];
        NSString *jsonPath = [path stringByAppendingPathComponent:@"menu.json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
        [self getMenuItems:jsonData];
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

#pragma mark - Cell touch actions

- (void)cellTouchDown:(id)sender {
    MenuCell * clickedCell = (MenuCell *)[[sender superview] superview];
    clickedCell.menuImage.alpha = 0.5f;
    clickedCell.textLabel.alpha = 0.5f;
    clickedCell.priceLabel.alpha = 0.5f;
}

- (void)cellTouchUp:(id)sender {
    MenuCell * clickedCell = (MenuCell *)[[sender superview] superview];
    clickedCell.menuImage.alpha = 1;
    clickedCell.textLabel.alpha = 1;
    clickedCell.priceLabel.alpha = 1;
    NSIndexPath * clickedButtonPath = [self.tableView indexPathForCell:clickedCell];
    NSString *key = [mArrayOfProductsNames objectAtIndex:indexOfMenu];
    NSArray *arrayOfProducts = [mDictOfProducts objectForKey:key];
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
}

#pragma mark - Private functions

- (void)setMainProp {
    mApplicationSingleton = [ApplicationSingleton createSingleton];
    mArrayOfProductsNames = [[NSMutableArray alloc] init];
    arrayOfMenuItemGroups = [[NSMutableArray alloc] init];
    mInternetUtils = [[InternetUtils alloc] init];
    mDictOfProducts = [[NSMutableDictionary alloc] init];
    indexOfMenu = 0;
}

- (void)startPreloader {
    mLoader = [[[UIAlertView alloc] initWithTitle:@"Loading the data list\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
    [mLoader show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(mLoader.bounds.size.width / 2, mLoader.bounds.size.height - 50);
    [indicator startAnimating];
    [mLoader addSubview:indicator];
    [indicator release];
}

- (void)getMenuItemsZip:(NSData *)data {
    NSString *path = [mApplicationSingleton cacheDirectory];
    path = [NSString stringWithFormat:@"%@/%d", path, mApplicationSingleton.idOfMenu.integerValue];
	NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
    NSString *filename = @"brands.zip";
    NSString *toDirectory = [NSString stringWithFormat:@"%@/%@", path, filename];
    [data writeToFile:toDirectory atomically:YES];
    
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    [zipArchive UnzipOpenFile:toDirectory];
    [zipArchive UnzipFileTo:path overWrite:YES];
    [zipArchive UnzipCloseFile];
    [zipArchive release];
    
    NSString *jsonPath = [path stringByAppendingPathComponent:@"menu.json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    [self getMenuItems:jsonData];
    
}

- (void)getMenuItems:(NSData *)data {
    [mDictOfProducts removeAllObjects];
    [mArrayOfProductsNames removeAllObjects];
    [arrayOfMenuItemGroups removeAllObjects];
    
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *mainDict = [json JSONValue];
    NSArray *arrayOfGroups = [mainDict valueForKeyPath:@"groups"];
    
    for(NSDictionary *dictOfgroup in arrayOfGroups) {
        NSDictionary *info = [dictOfgroup objectForKey:@"info"];
        GroupItem *groupItem = [[GroupItem alloc] initWithArray:[info objectForKey:@"objectValues"]];
        [arrayOfMenuItemGroups addObject:groupItem];
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
    [mApplicationSingleton.mainViewController getAllProducts];
    [mLoader dismissWithClickedButtonIndex:0 animated:YES];
}

@end
