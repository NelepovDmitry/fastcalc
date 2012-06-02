//
//  MLocationGetter.m
//  MediTimer
//
//  Created by Gevorg Petrosyan on 03.10.11.
//  Copyright (c) 2011 MKB FineMechanics. All rights reserved.
//

#import "MLocationGetter.h"

@implementation MLocationGetter

@synthesize locationManager, delegate, addresJSON;

BOOL didUpdate = NO;

- (void)startUpdates {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    // You have some options here, though higher accuracy takes longer to resolve.
    //locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self.delegate conformsToProtocol:@protocol(MLocationGetterDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
        //SEL getAddress = NSSelectorFromString(@"getUserAddress:");
        [self getUserAddress:newLocation];
        //[self performSelectorInBackground:getAddress withObject:newLocation];
		[self.delegate newPhysicalLocation:newLocation];
	}
    [locationManager stopUpdatingLocation];
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self.delegate conformsToProtocol:@protocol(MLocationGetterDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
        NSLog(@"error Location");
        [locationManager stopUpdatingLocation];
	}
}


//http://maps.google.com/maps/geo?ll=46.3,30.46&output=json

- (void)getUserAddress:(CLLocation *)location{
    [addresJSON release];
    NSString *getRequest = [NSString stringWithFormat:GOOGLE_MAP_API, location.coordinate.latitude, location.coordinate.longitude];
    addresJSON = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:getRequest] encoding:NSUTF8StringEncoding error:nil];
    
    /*
    if (getAddressUser.count>0){
        
         #define GOOGLE_MAP_PLACEMARK @"Placemark"
         #define GOOGLE_MAP_PLACEMARK_COUNTRY @"Country"
         #define GOOGLE_MAP_PLACEMARK_COUNTRY_NAME @"CountryName"
         #define GOOGLE_MAP_PLACEMARK_LOCALITY @"Locality"
         #define GOOGLE_MAP_PLACEMARK_LOCALITY_NAME @"LocalityName"
         #define GOOGLE_MAP_PLACEMARK_THOROUGHFARE @"Thoroughfare"
         #define GOOGLE_MAP_PLACEMARK_THOROUGHFARE_NAME @"ThoroughfareName"
         
        NSArray * placemark=[getAddressUser objectForKey:GOOGLE_MAP_PLACEMARK];
        for (NSDictionary * plindex in placemark){
            NSString * idp=[plindex objectForKey:@"id"];
            if ([idp isEqualToString:@"p1"]){
                if ([plindex valueForKey:@"address"]){
                    NSDictionary * addressDetails=[plindex objectForKey:@"AddressDetails"];
                    NSDictionary * Country=[addressDetails objectForKey:@"Country"];
                    NSString * CountryName=[Country objectForKey:@"CountryName"];
                    NSDictionary * Locality=[Country objectForKey:@"Locality"];
                    NSString * LocalityName=[Locality objectForKey:@"LocalityName"];
                    if (LocalityName!=nil){
                        [FMApplicationSingleton createSingleton].address=[NSString stringWithFormat:@"%@ , %@",CountryName,LocalityName];
                    }else{
                        [FMApplicationSingleton createSingleton].address=[NSString stringWithFormat:@"%@",CountryName];
                    }
                    break;
                }
            }
        }
    }*/
    
}

- (void)dealloc
{
    [locationManager release];
    [super dealloc];
}

@end
