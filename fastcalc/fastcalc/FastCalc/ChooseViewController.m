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
#import "IIViewDeckController.h"
#import "MainViewController.h"
#import "MenuTableViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "Brand.h"
#import "BrandMenu.h"
#import "ZipArchive.h"
#import "BrandCell.h"
#import "iRate.h"
#import "AboutController.h"
#import "FMStore.h"

@interface ChooseViewController ()

- (void)initPrivate;
- (void)requestCity:(NSString *)cityName;
- (void)getBrandsFromData:(NSData *)data;

- (void)startPreloader;
- (void)getFastFoodsOnCityZip:(NSData *)data;
- (void)setBorderToTheView:(UIView *)view;
- (void)showDonate;

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
    [mLocationLbl release];
    mLocationLbl = nil;
    [mSoundBtn release];
    mSoundBtn = nil;
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
    [mLocationLbl release];
    [mSoundBtn release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
}

#pragma mark - Custom functions

- (void)setBorderToTheView:(UIView *)view {
    view.layer.cornerRadius = 8;
    [view.layer setBorderColor:[[UIColor colorWithRed:24.0/255.0 green:92.0/255.0 blue:52.0/255.0 alpha:1.0f] CGColor]];
    [view.layer setBorderWidth:2.0];
    view.clipsToBounds = YES;
}

- (void)initPrivate {
    mStore = [FMStore sharedStore];
    mInternetUtils = [[InternetUtils alloc] init];
    mApplicationSingleton = [ApplicationSingleton createSingleton];
    mArrayOfBrandsMenus = [[NSMutableArray alloc] init];
    mArrayOfBrands = [[NSMutableArray alloc] init];
    mLocationGetter = [[MLocationGetter alloc] init];
    mLocationGetter.delegate = self;
    menuID = mApplicationSingleton.idOfMenu;
    if(!mApplicationSingleton.firstStart) {
        mLocationLbl.text = [NSString stringWithFormat:@"  %@  ", NSLocalizedString(@"localizationString", @"")];
        [self getBrandsFromCache];
    } else {
        [self startPreloader];
        [self newPhysicalLocation:nil];
    }
    
    [self setBorderToTheView:mBrandsTable];
    [self setBorderToTheView:mLocationLbl];
    
}

- (void)startPreloader {
    mLoader = [[[UIAlertView alloc] initWithTitle:@"Загрузка списка брендов\nПожалуйста подождите..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
    [mLoader show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(mLoader.bounds.size.width / 2, mLoader.bounds.size.height - 50);
    [indicator startAnimating];
    [mLoader addSubview:indicator];
    [indicator release];
}

#pragma mark - Data work functions

- (void)getBrandsFromCache {
    NSString *cachesDirectory = [mApplicationSingleton cacheDirectory];
    NSString *storePath = [cachesDirectory stringByAppendingPathComponent:@"/brands/brands.json"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        NSData *data = [NSData dataWithContentsOfFile:storePath];
        [self getBrandsFromData:data];
    } else {
        [self requestCity:@"Москва"];
    }
}

- (void)getFastFoodsOnCityZip:(NSData *)data {
    NSString *path = [mApplicationSingleton cacheDirectory];
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
    NSLog(@"toDirectory %@", toDirectory);
    
    NSString *jsonPath = [path stringByAppendingPathComponent:@"brands.json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    [self getBrandsFromData:jsonData];
}

- (void)getBrandsFromData:(NSData *)data {
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *mainDict = [json JSONValue];
    NSNumber *cityId = [mainDict valueForKeyPath:@"city.object_id"];
    NSString *cityName = [mainDict valueForKeyPath:@"city.string_value"];
    mApplicationSingleton.idOfCity = cityId;
    mApplicationSingleton.nameOfCity = cityName;
    
    [mApplicationSingleton commitSettings];
    
    NSArray *arrayOfBrands = [mainDict valueForKeyPath:@"brands.info"];
    for(NSDictionary *dictOfBrand in arrayOfBrands) {
        Brand *brand = [[Brand alloc] initWithArray:[dictOfBrand objectForKey:@"objectValues"]];
        [mArrayOfBrands addObject:brand];
        [brand release];
    }
    
    NSArray *arrayOfBrandsMenus = [mainDict valueForKeyPath:@"brands.menus"];
    
    for(NSArray *array in arrayOfBrandsMenus) {
        NSMutableDictionary *lastDict = [NSMutableDictionary dictionary];
        [lastDict setObject:[mainDict valueForKeyPath:@"brands.brandname"] forKey:@"name"];
        NSMutableArray *arrayOfMenus = [NSMutableArray array];
        for(NSDictionary *brand in array) {
            NSArray *objectValues = [brand objectForKey:@"objectValues"];
            BrandMenu *brand = [[BrandMenu alloc] initWithArray:objectValues];
            [arrayOfMenus addObject:brand];
            [brand release];
        }
        [lastDict setObject:arrayOfMenus forKey:@"menus"];
        [mArrayOfBrandsMenus addObject:lastDict];
    }
    
    [mBrandsTable reloadData];
    [json release];
    
    NSString *cachesDirectory = [mApplicationSingleton cacheDirectory];
    NSString *storePath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.json", mApplicationSingleton.idOfCity.intValue]];
    [data writeToFile:storePath atomically:YES];
    
    [mLoader dismissWithClickedButtonIndex:0 animated:YES];
}
//api?apifastcalc.getFastFoodsOnCityZip={"city_name":"Москва","locale":"ru","responseBinary":1}
//http://fastcalc.orionsource.ru/api/?apifastcalc.getFastFoodsOnCity={%22city_name%22:%22%D0%9C%D0%BE%D1%81%D0%BA%D0%B2%D0%B0%22,%22locale%22:%22ru%22}
- (void)requestCity:(NSString *)cityName {
    mLocationLbl.text = [NSString stringWithFormat:@"  %@  ", NSLocalizedString(@"localizationString", @"")];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:cityName forKey:@"city_name"];
    [dict setObject:@"ru" forKey:@"locale"];
    [dict setObject:@"RUS" forKey:@"iso_country"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"responseBinary"];
    //http://rent.orionsource.ru/api?apirent.getUserLocation={"access_token":"","google_json":""}
    [mInternetUtils makeURLRequestByNameResponser:@"getFastFoodsOnCityZip:" 
                                          urlCall:[NSURL URLWithString:URL] 
                                    requestParams:[NSDictionary dictionaryWithObject:[dict JSONRepresentation] forKey:@"apifastcalc.getFastFoodsOnCityZip"]
                                        responder:self
                             progressFunctionName:nil
     ];
}

- (void)updateCache {
    
}

#pragma mark - Location Delegate 

- (void)newPhysicalLocation:(CLLocation *)location {
    /*[mLocationGetter getUserAddress:location];
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
    }*/
    if(mApplicationSingleton.idOfCity.intValue == 0) {
        [self requestCity:@"Москва"];
    } else {
        [self getBrandsFromCache];
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
                [self getBrandsFromCache];
            }
            break;
        case 256:
            if(mApplicationSingleton.idOfCity.intValue != 0)
                [self getBrandsFromCache];
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
                [self getBrandsFromCache];
            }
            break;
    }
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Brand *brand = [mArrayOfBrands objectAtIndex:section];
    UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, mBrandsTable.frame.size.width, 44)] autorelease];
    v.backgroundColor = [UIColor colorWithRed:0.0 / 255.0 green:59.0 / 255.0 blue:18.0 / 255.0 alpha:1];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 43, mBrandsTable.frame.size.width, 1)];
    [separator setBackgroundColor:tableView.separatorColor];
    
    NSString *path = [mApplicationSingleton cacheDirectory];
    path = [NSString stringWithFormat:@"%@/brands", path];
    NSString *imagePath = [path stringByAppendingPathComponent:brand.brandPicturePath];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    UIImageView *imageView;
    if(image == nil) {
        imageView = [[UIImageView alloc] init];
    } else {
        imageView = [[UIImageView alloc] initWithImage:image];
    }
    [imageView setFrame:CGRectMake(5, 3, 35, 35)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(46, 5, mBrandsTable.frame.size.width - 50, 30)];
    [lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [lbl setText:brand.brandName];
    [lbl setTextColor:[UIColor whiteColor]];
    lbl.backgroundColor = [UIColor clearColor];
    
    [v addSubview:imageView];
    [v addSubview:lbl];
    [v addSubview:separator];
    [imageView release];
    [lbl release];
    [separator release];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return mArrayOfBrandsMenus.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [[mArrayOfBrandsMenus objectAtIndex:section] objectForKey:@"menus"];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BrandCell";
    
    NSArray *array = [[mArrayOfBrandsMenus objectAtIndex:indexPath.section] objectForKey:@"menus"];
    BrandMenu *brand = [array objectAtIndex:indexPath.row];
    BrandCell *cell= (BrandCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BrandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for (id currentObject in array) {
            if ([currentObject isKindOfClass:[BrandCell class]]) {
                cell = currentObject;
                break;
            }
        }
    }
    [cell.brandImageView setImage:[UIImage imageNamed:@"not_choose_button.png"]];
    
    if(brand.objectId.integerValue == menuID.integerValue) {
        [cell.brandImageView setImage:[UIImage imageNamed:@"choose_button.png"]];
    }
    cell.reloadBtn.tag = indexPath.row;
    [cell.reloadBtn addTarget:self action:@selector(brandCellReloadClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.brandLbl.text = brand.brandMenuName;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [menuID release];
    NSArray *array = [[mArrayOfBrandsMenus objectAtIndex:indexPath.section] objectForKey:@"menus"];
    NSLog(@"array %@", mArrayOfBrandsMenus);
    NSLog(@"array %@", [array objectAtIndex:indexPath.row]);
    BrandMenu *brandMenu = [array objectAtIndex:indexPath.row];
    menuID = [[NSNumber alloc] initWithInt:brandMenu.objectId.intValue];
    [mApplicationSingleton.dictOfMenuImages removeAllObjects];
    Brand *brand = [mArrayOfBrands objectAtIndex:indexPath.section];
    mApplicationSingleton.brandPath = brand.brandPicturePath;
    [mApplicationSingleton commitSettings];
    
    //[mApplicationSingleton.mainViewController.menuTableViewController performSelectorInBackground:@selector(requsetMenuById:) withObject:numberId];
    [mApplicationSingleton.mainViewController performSelectorInBackground:@selector(requsetMenuById:) withObject:menuID];
    //[mApplicationSingleton.mainViewController requsetMenuById:menuID];
    [mApplicationSingleton.mainViewController.viewDeckController toggleLeftViewAnimated:YES];
    [mBrandsTable reloadData];
}

#pragma mark - Actions

- (IBAction)reloadLocationClicked:(id)sender {
    [self reloadListClicked:nil];
}

- (IBAction)reloadListClicked:(id)sender {
    mApplicationSingleton.idOfCity = [NSNumber numberWithInt:0];
    [mArrayOfBrandsMenus removeAllObjects];
    [mArrayOfBrands removeAllObjects];
    [self startPreloader];
    //[mLocationGetter startUpdates];
    [self newPhysicalLocation:nil];
}

- (IBAction)rateClicked:(id)sender {
    [[iRate sharedInstance] openRatingsPageInAppStore];
}

- (IBAction)infoClicked:(id)sender {
    aboutController = [[AboutController alloc] initWithNibName:@"AboutController" bundle:nil];
    aboutController.delegate = self;
    [self presentPopupViewController:aboutController animationType:MJPopupViewAnimationFade];
}

- (IBAction)soundClicked:(id)sender {
    UIViewController *menuController = (UIViewController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
    UINavigationController *rootNavController = (UINavigationController *)menuController;
    NSArray *viewControllers = rootNavController.viewControllers;
    MainViewController *rootViewController = [viewControllers objectAtIndex:0];
    if(soundClicked) {
        [mSoundBtn setImage:[UIImage imageNamed:@"sound_on.png"] forState:UIControlStateNormal];
        [rootViewController volume:0.5f];
    } else {
        [mSoundBtn setImage:[UIImage imageNamed:@"sound_off.png"] forState:UIControlStateNormal];
        [rootViewController volume:0];
    }
    soundClicked = !soundClicked;
}

- (void)brandCellReloadClicked:(id)sender {
    BrandCell * clickedCell = (BrandCell *)[[sender superview] superview];
    NSIndexPath * clickedButtonPath = [mBrandsTable indexPathForCell:clickedCell];
    NSArray *array = [[mArrayOfBrandsMenus objectAtIndex:clickedButtonPath.section] objectForKey:@"menus"];
    BrandMenu *brand = [array objectAtIndex:clickedButtonPath.row];
    [ApplicationSingleton removeDirectoryById:brand.objectId];
    menuID = brand.objectId;
    Brand *brandP = [mArrayOfBrands objectAtIndex:clickedButtonPath.section];
    mApplicationSingleton.brandPath = brandP.brandPicturePath;
    [mApplicationSingleton commitSettings];
    [mApplicationSingleton.mainViewController requsetMenuById:brand.objectId];
    [mApplicationSingleton.mainViewController.viewDeckController toggleLeftViewAnimated:YES];
    [mBrandsTable reloadData];
}

#pragma mark - AboutController delegate

- (void)cancelButtonClicked:(AboutController *)aAboutController {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    aboutController = nil;
}

#pragma mark - Donate functions

- (IBAction)donateClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Пожертвование" message:@"Помогите дальнейшему развитию программы" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"1$", @"5$", @"10$", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"Cancel");
            break;
        case 1:
            NSLog(@"1$");
            break;
        case 2:
            NSLog(@"5$");
            break;
        case 3:
            NSLog(@"10$");
            break;
        default:
            break;
    }
    //NSLog(@"%@", mStore.purchasableObjects);
}

@end
