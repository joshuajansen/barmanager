//
//  locationManager.m
//  barmanager
//
//  Created by Joshua Jansen on 25-10-12.
//  Copyright (c) 2012 ITflows. All rights reserved.
//

#import "LocationManager.h"

static LocationManager *locationManager = nil;

@implementation LocationManager

@synthesize manager, lastLocation, dataModel;

NSString *const BMCityChange = @"ITflows.barmanager.City:BMCityChange";

#pragma mark Singleton Methods
+ (id)sharedManager
{
    @synchronized(self) {
        if(locationManager == nil)
            locationManager = [[super allocWithZone:NULL] init];
    }
    
    return locationManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)init
{
    if (self = [super init])
    {
        self.dataModel = [DataModel sharedManager];
        
        manager = [[CLLocationManager alloc] init];
        manager.desiredAccuracy = kCLLocationAccuracyKilometer;
        manager.delegate = self;
        manager.distanceFilter = 100.0f;
        
        [manager startUpdatingLocation];
        NSLog(@"locationManager initialized");
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    lastLocation = [locations lastObject];
    
    if ( [self.dataModel.auth_token length] != 0 ) {
        NSLog(@"Reload cities.json from locationmananger did update locations");
        [City findCityForLocation:lastLocation WithDelegate:self];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if ([[objectLoader.URL path] isEqualToString:@"/api/cities.json"]) {
        if ( [[objects objectAtIndex:0] isKindOfClass:[City class]] ){
            City *city = [objects objectAtIndex:0];
            self.dataModel.city_id = city.cityId;
            self.dataModel.city_name = city.name;
            NSLog(@"Loaded City ID #%@ -> Name: %@, Population: %@", city.cityId, city.name, city.population);
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:BMCityChange
             object:city];
        }
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Encountered an error: %@", [error localizedDescription]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fout"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
