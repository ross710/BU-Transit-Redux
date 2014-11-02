//
//  BUT_Backend.m
//  BU Transit Redux
//
//  Created by Ross Tang Him on 9/6/14.
//
//

#import "BUT_Backend.h"
#import "UNIRest.h"

@interface BUT_Backend()
@property (strong, nonatomic) NSDictionary *headers;
@end
@implementation BUT_Backend

static BUT_Backend *sharedInstance;

#pragma mark - Shared Instance
+(BUT_Backend*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance){
            sharedInstance = [[BUT_Backend alloc] init];
            sharedInstance.userLocationString = @"BU Transit";
            [sharedInstance initLocation];
            sharedInstance.headers = @{@"X-Mashape-Authorization": @"TiLRMRlEidBm0KT2ra9y2K6F43diqKsc"};
            sharedInstance.arrivalEstimates = [[NSMutableDictionary alloc] init];
            sharedInstance.routes = [[NSMutableArray alloc] init];
            sharedInstance.stops = [[NSMutableArray alloc] init];
            sharedInstance.segments = [[NSMutableArray alloc] init];
            sharedInstance.vehicles= [[NSMutableArray alloc]init];
            
            

        }
    });
    
    return sharedInstance;
}

+(NSMutableDictionary*) getArrivalEstimatesWithBlock: (BUT_VoidBlock) block{
    [[UNIRest get:^(UNISimpleRequest* request) {
        [request setUrl:@"https://transloc-api-1-2.p.mashape.com/arrival-estimates.json?agencies=bu"];
        [request setHeaders:[BUT_Backend sharedInstance].headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        NSData* data = [response rawBody];
        if (error) {
            NSLog(@"Error: %@", error);
        } else if ([data length] > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (!error && [dict count] > 0) {
                
                NSArray *aeArray = [dict objectForKey:@"data"];
                [BUT_Backend sharedInstance].arrivalEstimates = [NSMutableDictionary dictionary];

                for (NSDictionary *arrivalEstimate in aeArray) {
                    [[BUT_Backend sharedInstance].arrivalEstimates setObject:arrivalEstimate forKey:[arrivalEstimate objectForKey:@"stop_id"]];
                }
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"arrivalEstimatesUpdated"
                 object:self];
                
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                    [BUT_Backend performSelector:@selector(getArrivalEstimatesWithBlock:) withObject:nil afterDelay:5.0];
                }];
                
                if (block) {
                    block();
                }
            }
        }
        
    }];
    return [BUT_Backend sharedInstance].arrivalEstimates;
}


+(NSMutableArray*) getRoutesWithBlock: (BUT_VoidBlock) block {
    
    
    return [BUT_Backend sharedInstance].routes;
}

+(NSMutableArray*) getStopsWithBlock: (BUT_VoidBlock) block {
    if (![BUT_Backend sharedInstance].stops || [BUT_Backend sharedInstance].stops.count <= 0) {
        [[UNIRest get:^(UNISimpleRequest* request) {
            [request setUrl:@"https://transloc-api-1-2.p.mashape.com/stops.json?agencies=bu"];
            [request setHeaders:[BUT_Backend sharedInstance].headers];
        }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
            NSData* data = [response rawBody];
            if (error) {
                NSLog(@"Error: %@", error);
            } else if ([data length] > 0) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                if (!error && [dict count] > 0) {
                    [BUT_Backend sharedInstance].stops = [dict objectForKey:@"data"];
//                    NSLog(@"%@",[BUT_Backend sharedInstance].stops);
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"stopsUpdated"
                     object:self];
                    if (block) {
                        block();
                    }
                }
            }
            
        }];
    }
    return [BUT_Backend sharedInstance].stops;
}
+(NSMutableArray*) getSegmentsWithBlock: (BUT_VoidBlock) block {
    
    
    return [BUT_Backend sharedInstance].segments;
}
+(NSMutableArray*) getVehiclesWithBlock: (BUT_VoidBlock) block {
    [[UNIRest get:^(UNISimpleRequest* request) {
        [request setUrl:@"https://transloc-api-1-2.p.mashape.com/vehicles.json?agencies=bu"];
        [request setHeaders:[BUT_Backend sharedInstance].headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        NSData* data = [response rawBody];
        if (error) {
            NSLog(@"Error: %@", error);
        } else if ([data length] > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (!error && [dict count] > 0) {
                [BUT_Backend sharedInstance].vehicles = [[dict objectForKey:@"data"] objectForKey:@"132"];
//                NSLog(@"%@",[BUT_Backend sharedInstance].vehicles);
                
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"vehiclesUpdated"
                 object:self];
                
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                    [BUT_Backend performSelector:@selector(getVehiclesWithBlock:) withObject:nil afterDelay:5.0];
                }];

                if (block) {
                    block();
                }
            }
        }
        
    }];

    
    return [BUT_Backend sharedInstance].vehicles;
}


#pragma mark - location manager
-(void) initLocation {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    locationManager.delegate = self;
    geocoder = [[CLGeocoder alloc] init];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [locationManager stopUpdatingLocation];
    myLocation = [locations lastObject];
    [geocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            NSString *checkLength = [NSString stringWithFormat:@"%@ %@, %@, %@",
                                     placemark.subThoroughfare,
                                     placemark.thoroughfare,
                                     placemark.locality,
                                     placemark.administrativeArea];
            NSLog(@"%@", [NSString stringWithFormat:@"%@ %@",
                          placemark.subThoroughfare,
                          placemark.thoroughfare]);
            if ([checkLength length] <= 17) {
                [self setUserLocationString:checkLength];
            } else if (placemark.subThoroughfare == NULL){
                [self setUserLocationString:[NSString stringWithFormat:@"%@",
                                placemark.thoroughfare]];
            } else {
                [self setUserLocationString:[NSString stringWithFormat:@"%@ %@",
                                placemark.subThoroughfare,
                                placemark.thoroughfare]];
            }
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"userLocationChanged"
             object:self];

        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];

}



-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

}
@end
