//
//  ChooseViewController.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 01.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseViewController.h"
#import "InternetUtils.h"
#import "JSON.h"
#import "ApplicationSingleton.h"
#import "MenuViewController.h"
#import "MainViewController.h"

@interface ChooseViewController ()

- (void)initPrivate;
- (void)requestCity:(NSString *)cityName;
- (void)getBrandsFromData:(NSData *)data;

@end

@implementation ChooseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPrivate];
}

- (void)viewDidUnload
{
    [mBrandsTable release];
    mBrandsTable = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [mInternetUtils release];
    [mLocationGetter release];
    [mBrandsTable release];
    [super dealloc];
}

#pragma mark - Custom functions

- (void)initPrivate {
    mInternetUtils = [[InternetUtils alloc] init];
    mApplicationSingleton = [ApplicationSingleton createSingleton];
    mArrayOfBrands = [[NSMutableArray alloc] init];
    mLocationGetter = [[MLocationGetter alloc] init];
    mLocationGetter.delegate = self;
    [mLocationGetter startUpdates];
    isLoadingAddress = true;
}


- (void)getBrandsFromData:(NSData *)data {
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *mainDict = [json JSONValue];
    NSNumber *cityId = [mainDict valueForKeyPath:@"response.city.object_id"];
    NSString *cityName = [mainDict valueForKeyPath:@"response.city.string_value"];
    mApplicationSingleton.idOfCity = cityId;
    mApplicationSingleton.nameOfCity = cityName;
    NSArray *arrayOfBrands = [mainDict valueForKeyPath:@"response.brands.menus"];
    
    NSMutableDictionary *lastDict = [NSMutableDictionary dictionary];
    [lastDict setObject:[mainDict valueForKeyPath:@"response.brands.brandname"] forKey:@"name"];
    
    NSMutableArray *arrayOfMenus = [NSMutableArray array];
    for(NSDictionary *brand in [arrayOfBrands objectAtIndex:0]) {
        NSArray *objectValues = [brand objectForKey:@"objectValues"];
        for(NSDictionary *objectValue in objectValues) {
            NSString *attrname = [objectValue objectForKey:@"attrname"];
            if([attrname isEqualToString:@"Menu info_Name"]) {
                [arrayOfMenus addObject:objectValue];
            }
        }
    }
    [lastDict setObject:arrayOfMenus forKey:@"menus"];
    [mArrayOfBrands addObject:lastDict];
    NSLog(@"lastDict %@", lastDict);
    [mBrandsTable reloadData];
    //NSLog(@"json %@", [mainDict valueForKeyPath:@"response.brands"]);
}

//http://fastcalc.orionsource.ru/api/?apifastcalc.getFastFoodsOnCity={%22city_name%22:%22%D0%9C%D0%BE%D1%81%D0%BA%D0%B2%D0%B0%22,%22locale%22:%22ru%22}
- (void)requestCity:(NSString *)cityName {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:cityName forKey:@"city_name"];
    //http://rent.orionsource.ru/api?apirent.getUserLocation={"access_token":"","google_json":""}
    [mInternetUtils makeURLRequestByNameResponser:@"getBrandsFromData:" 
                                          urlCall:[NSURL URLWithString:@"http://fastcalc.orionsource.ru/api/"] 
                                    requestParams:[NSDictionary dictionaryWithObject:[dict JSONRepresentation] forKey:@"apifastcalc.getFastFoodsOnCity"]
                                        responder:self
                             progressFunctionName:nil
     ];
}

#pragma mark - Location Delegate 

- (void)newPhysicalLocation:(CLLocation *)location {
    NSDictionary *dictOfFullLocal = [mLocationGetter.addresJSON JSONValue];
    NSArray *types = [[dictOfFullLocal valueForKeyPath:@"results.address_components"] objectAtIndex:0];
    NSString *cityName = @"";
    for(NSDictionary *dictOfTypes in types) {
        NSArray *arrayofTypes = [dictOfTypes objectForKey:@"types"];
        if(arrayofTypes.count == 2) {
            NSString *firstParam = [arrayofTypes objectAtIndex:0];
            NSString *secondParam = [arrayofTypes objectAtIndex:1];
            if([firstParam isEqualToString:@"locality"] && [secondParam isEqualToString:@"political"]) {
                cityName = [dictOfTypes objectForKey:@"long_name"];
                break;
            }
        }
    }
    [self requestCity:@"Москва"];
    isLoadingAddress = false;
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //UIView v = nil;
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return mArrayOfBrands.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [[mArrayOfBrands objectAtIndex:section] objectForKey:@"menus"];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchListCell";
    
    NSArray *array = [[mArrayOfBrands objectAtIndex:indexPath.section] objectForKey:@"menus"];
    NSDictionary *objects = [array objectAtIndex:indexPath.row];
    
    UITableViewCell *cell= (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        /*NSArray *array = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for (id currentObject in array) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = currentObject;
                break;
            }
        }*/
    }
    cell.textLabel.text = [objects objectForKey:@"string_value"];
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuViewController *menuController = (MenuViewController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
    MainViewController *controller = [[MainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [menuController setRootController:navController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
