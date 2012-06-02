//
//  MLocationGetter.h
//  MediTimer
//
//  Created by Gevorg Petrosyan on 03.10.11.
//  Copyright (c) 2011 MKB FineMechanics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define GOOGLE_MAP_API @"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false&language=ru"
//http://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&sensor=false

@protocol MLocationGetterDelegate <NSObject>
@required
- (void) newPhysicalLocation:(CLLocation *)location;
@end

@interface MLocationGetter : NSObject <CLLocationManagerDelegate> { 
    CLLocationManager *locationManager;
    id<MLocationGetterDelegate> delegate;
}

- (void)startUpdates;

@property (nonatomic, retain) NSString *addresJSON;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic , retain) id<MLocationGetterDelegate> delegate;

@end