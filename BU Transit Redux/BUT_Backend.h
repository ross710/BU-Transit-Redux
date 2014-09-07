//
//  BUT_Backend.h
//  BU Transit Redux
//
//  Created by Ross Tang Him on 9/6/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^BUT_ArrayBlock) (NSMutableArray *array);
typedef void (^BUT_VoidBlock) (void);

@interface BUT_Backend : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocation *myLocation;
}
@property (strong,nonatomic) NSString *userLocationString;
@property (strong,nonatomic) NSMutableArray *arrivalEstimates;
@property (strong,nonatomic) NSMutableArray *routes;
@property (strong,nonatomic) NSMutableArray *stops;
@property (strong,nonatomic) NSMutableArray *segments;
@property (strong,nonatomic) NSMutableArray *vehicles;




+(NSMutableArray*) getArrivalEstimatesWithBlock: (BUT_VoidBlock) block;
+(NSMutableArray*) getRoutesWithBlock: (BUT_VoidBlock) block;
+(NSMutableArray*) getStopsWithBlock: (BUT_VoidBlock) block;
+(NSMutableArray*) getSegmentsWithBlock: (BUT_VoidBlock) block;
+(NSMutableArray*) getVehiclesWithBlock: (BUT_VoidBlock) block;
+(BUT_Backend *)sharedInstance;

-(void) initLocation;

@end
