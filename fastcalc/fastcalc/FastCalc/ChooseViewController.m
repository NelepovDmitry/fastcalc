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
#import "MenuTableViewController.h"
#import "Brand.h"
#import "BrandMenu.h"
#import "ZipArchive.h"

@interface ChooseViewController ()

- (void)initPrivate;
- (void)requestCity:(NSString *)cityName;
- (void)getBrandsFromData:(NSData *)data;
- (void)getMenusById:(NSNumber *)menuId;

- (void)startPreloader;
- (void)getFastFoodsOnCityZip:(NSData *)data;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgorund.png"]];
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
    if(!mApplicationSingleton.firstStart) {
        [self getBrandsFromCacheById:mApplicationSingleton.idOfCity];
    } else {
        [self startPreloader];
        [mLocationGetter startUpdates];
    }
    
    mBrandsTable.layer.cornerRadius = 10;
    [mBrandsTable.layer setBorderColor:[[UIColor colorWithRed:24.0/255.0 green:92.0/255.0 blue:52.0/255.0 alpha:1.0f] CGColor]];
    [mBrandsTable.layer setBorderWidth:1.0];
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

- (void)getBrandsFromCacheById:(NSNumber *)cityId {
    NSString *cachesDirectory = [ApplicationSingleton cacheDirectory];
    NSString *storePath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.json", cityId.intValue]];
    NSData *data = [NSData dataWithContentsOfFile:storePath];
    [self getBrandsFromData:data];
}

- (void)getFastFoodsOnCityZip:(NSData *)data {
    
    NSString *path = [ApplicationSingleton cacheDirectory];
    path = [NSString stringWithFormat:@"%@/brands", path];
	NSError *error;
	if (![[NSFileManager defaultManager] fileExistsAtPath:path])	//Does directory already exist?
	{
		if (![[NSFileManager defaultManager] createDirectoryAtPath:path
									   withIntermediateDirectories:NO
														attributes:nil
															 error:&error])
		{
			NSLog(@"Create directory error: %@", error);
		}
	} else {
        
    }
    
    NSString *filename = @"brands.zip";
    NSString *toDirectory = [NSString stringWithFormat:@"%@/%@", path, filename];
    [data writeToFile:toDirectory atomically:YES];
    
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    [zipArchive UnzipOpenFile:toDirectory];
    [zipArchive UnzipFileTo:path overWrite:YES];
    [zipArchive UnzipCloseFile];
    [zipArchive release];
    
    
    
}

- (void)getBrandsFromData:(NSData *)data {
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *mainDict = [json JSONValue];
    NSNumber *cityId = [mainDict valueForKeyPath:@"response.city.object_id"];
    NSString *cityName = [mainDict valueForKeyPath:@"response.city.string_value"];
    mApplicationSingleton.idOfCity = cityId;
    mApplicationSingleton.nameOfCity = cityName;
    [mApplicationSingleton commitSettings];
    NSArray *arrayOfBrands = [mainDict valueForKeyPath:@"response.brands.menus"];
    
    NSMutableDictionary *lastDict = [NSMutableDictionary dictionary];
    [lastDict setObject:[mainDict valueForKeyPath:@"response.brands.brandname"] forKey:@"name"];
    
    NSMutableArray *arrayOfMenus = [NSMutableArray array];
    for(NSDictionary *brand in [arrayOfBrands objectAtIndex:0]) {
        NSArray *objectValues = [brand objectForKey:@"objectValues"];
        BrandMenu *brand = [[BrandMenu alloc] initWithArray:objectValues];
        [arrayOfMenus addObject:brand];
        [brand release];
    }
    
    [lastDict setObject:arrayOfMenus forKey:@"menus"];
    [mArrayOfBrands addObject:lastDict];
    [mBrandsTable reloadData];
    [json release];
    
    NSString *cachesDirectory = [ApplicationSingleton cacheDirectory];
    NSString *storePath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.json", mApplicationSingleton.idOfCity.intValue]];
    [data writeToFile:storePath atomically:YES];
    
    [mLoader dismissWithClickedButtonIndex:0 animated:YES];
}
//http://fastcalc.orionsource.ru/api?apifastcalc.getFastFoodsOnCityZip={"city_name":"Москва","locale":"ru","responseBinary":1}
//http://fastcalc.orionsource.ru/api/?apifastcalc.getFastFoodsOnCity={%22city_name%22:%22%D0%9C%D0%BE%D1%81%D0%BA%D0%B2%D0%B0%22,%22locale%22:%22ru%22}
- (void)requestCity:(NSString *)cityName {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:cityName forKey:@"city_name"];
    [dict setObject:@"ru" forKey:@"locale"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"responseBinary"];
    //http://rent.orionsource.ru/api?apirent.getUserLocation={"access_token":"","google_json":""}
    [mInternetUtils makeURLRequestByNameResponser:@"getFastFoodsOnCityZip:" 
                                          urlCall:[NSURL URLWithString:@"http://fastcalc.orionsource.ru/api/"] 
                                    requestParams:[NSDictionary dictionaryWithObject:[dict JSONRepresentation] forKey:@"apifastcalc.getFastFoodsOnCityZip"]
                                        responder:self
                             progressFunctionName:nil
     ];
}

- (void)updateCache {
    
}

#pragma mark - Location Delegate 

- (void)newPhysicalLocation:(CLLocation *)location {
    [mLocationGetter getUserAddress:location];
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
    if(mApplicationSingleton.idOfCity.intValue == 0) {
        [self requestCity:@"Москва"];
    } else {
        [self getBrandsFromCacheById:mApplicationSingleton.idOfCity];
    }
}

- (void)errorWithGettingLocation:(NSError *)error {
    NSInteger errorCode = [error code];
    switch (errorCode) {
        case 0:
        case 1:
            [mApplicationSingleton updateSettings];
            if(mApplicationSingleton.idOfCity.intValue == 0) {
                [self requestCity:@"Москва"];
            } else {
                [self getBrandsFromCacheById:mApplicationSingleton.idOfCity];
            }
            break;
        case 256:
            if(mApplicationSingleton.idOfCity.intValue != 0)
                [self getBrandsFromCacheById:mApplicationSingleton.idOfCity];
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error with connect to internet" message:@"Connect to internet" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
                [mLoader dismissWithClickedButtonIndex:0 animated:YES];
            }
            NSLog(@"error with internet");
            break;
        default:
            [mApplicationSingleton updateSettings];
            if(mApplicationSingleton.idOfCity.intValue == 0) {
                [self requestCity:@"Москва"];
            } else {
                [self getBrandsFromCacheById:mApplicationSingleton.idOfCity];
            }
            break;
    }
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
    BrandMenu *brand = [array objectAtIndex:indexPath.row];
    
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
    cell.textLabel.text = brand.brandMenuName;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = [[mArrayOfBrands objectAtIndex:indexPath.section] objectForKey:@"menus"];
    BrandMenu *brandMenu = [array objectAtIndex:indexPath.row];
    NSNumber *numberId =  brandMenu.objectId;
    
    MenuViewController *menuController = (MenuViewController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
    UINavigationController *rootNavController = (UINavigationController *)menuController.rootViewController;
    NSArray *viewControllers = rootNavController.viewControllers;
    MainViewController *rootViewController = [viewControllers objectAtIndex:0];
    [rootViewController.menuTableViewController requsetMenuById:numberId];
    [menuController showRootController:YES];
}

@end
