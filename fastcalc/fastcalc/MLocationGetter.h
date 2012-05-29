//
//  MLocationGetter.h
//  MediTimer
//
//  Created by Gevorg Petrosyan on 03.10.11.
//  Copyright (c) 2011 MKB FineMechanics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol MLocationGetterDelegate <NSObject>
@required
- (void) newPhysicalLocation:(CLLocation *)location;
@end

@interface MLocationGetter : NSObject <CLLocationManagerDelegate> { 
    CLLocationManager *locationManager;
    id<MLocationGetterDelegate> delegate;
}

- (void)startUpdates;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic , retain) id<MLocationGetterDelegate> delegate;

@end


#define GOOGLE_MAP_API @"http://maps.google.com/maps/geo?ll=%f,%f&output=json"
#define GOOGLE_MAP_PLACEMARK @"Placemark"
#define GOOGLE_MAP_PLACEMARK_COUNTRY @"Country"
#define GOOGLE_MAP_PLACEMARK_COUNTRY_NAME @"CountryName"
#define GOOGLE_MAP_PLACEMARK_LOCALITY @"Locality"
#define GOOGLE_MAP_PLACEMARK_LOCALITY_NAME @"LocalityName"
#define GOOGLE_MAP_PLACEMARK_THOROUGHFARE @"Thoroughfare"
#define GOOGLE_MAP_PLACEMARK_THOROUGHFARE_NAME @"ThoroughfareName"