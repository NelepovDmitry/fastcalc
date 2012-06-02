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

@interface ChooseViewController ()

- (void)initPrivate;
- (void)getCities;
- (void)getBrands;
- (void)getFastFoodCitys:(NSData *)jsonData;

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
    //mInternetUtils = [[InternetUtils alloc] init];
    //NSDate *date = [NSDate date];
    //UIImage *image = [UIImage imageNamed:@"IMG_0255.JPG"];
    //NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //NSDate *date1 = [NSDate date];
    //NSLog(@"timing %f", [date1 timeIntervalSinceDate:date]);
    //[mInternetUtils makeURLDataRequestByNameResponser:@"sendData:" urlCall:[NSURL URLWithString:@"http://rent.orionsource.ru/api/test.php"] responder:self data:imageData];
    // Do any additional setup after loading the view from its nib.
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
    [mInternetUtils release];
    [mLocationGetter release];
    [super dealloc];
}

#pragma mark - Custom functions

- (void)initPrivate {
    mInternetUtils = [[InternetUtils alloc] init];
    mLocationGetter = [[MLocationGetter alloc] init];
    mLocationGetter.delegate = self;
    [mLocationGetter startUpdates];
    isLoadingAddress = true;
    //http://fastcalc.orionsource.ru/api?apifastcalc.getFastFoodsOnCity={"city_id":2,"locale":"ru"}
    //[self getCities];
}

//http://fastcalc.orionsource.ru/api?apifastcalc.getFastFoodCitys={"locale":"ru"}
- (void)getCities {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"ru" forKey:@"locale"];
    //http://rent.orionsource.ru/api?apirent.getUserLocation={"access_token":"","google_json":""}
    [mInternetUtils makeURLRequestByNameResponser:@"getFastFoodCitys:" 
                                          urlCall:[NSURL URLWithString:@"http://fastcalc.orionsource.ru/api/"] 
                                    requestParams:[NSDictionary dictionaryWithObject:[dict JSONRepresentation] forKey:@"apifastcalc.getFastFoodCitys="]
                                        responder:self
                             progressFunctionName:nil
     ];
}

- (void)getFastFoodCitys:(NSData *)jsonData {
    
}

- (void)getBrands {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"ru" forKey:@"locale"];
    //http://rent.orionsource.ru/api?apirent.getUserLocation={"access_token":"","google_json":""}
    [mInternetUtils makeURLRequestByNameResponser:@"getFastFoodCitys:" 
                                          urlCall:[NSURL URLWithString:@"http://fastcalc.orionsource.ru/api/"] 
                                    requestParams:[NSDictionary dictionaryWithObject:[dict JSONRepresentation] forKey:@"apifastcalc.getFastFoodCitys="]
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

    isLoadingAddress = false;
}


@end
