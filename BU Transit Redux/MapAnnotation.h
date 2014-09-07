//
//  MapAnnotation.h
//  BU Transit Redux
//
//  Created by Ross Tang Him on 9/6/14.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


enum BUT_AnnotationType : NSUInteger {
    BUT_AnnotationTypeArrivalEstimates = 1,
    BUT_AnnotationTypeRoutes = 2,
    BUT_AnnotationTypeSegments = 3,
    BUT_AnnotationTypeStops = 4,
    BUT_AnnotationTypeVehicles = 5
};


@interface MapAnnotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *stopId;
@property (nonatomic) NSInteger type;

- (id)initWithType:(NSInteger) type
              name:(NSString*)name
            stopId:(NSNumber*)stopId
          location:(CLLocationCoordinate2D)location;
@end
