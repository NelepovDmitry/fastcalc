//
//  MLocationGetter.m
//  MediTimer
//
//  Created by Gevorg Petrosyan on 03.10.11.
//  Copyright (c) 2011 MKB FineMechanics. All rights reserved.
//

#import "MLocationGetter.h"

@implementation MLocationGetter

@synthesize locationManager, delegate;

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

- (void)dealloc
{
    [locationManager release];
    [super dealloc];
}

@end
