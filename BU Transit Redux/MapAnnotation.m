//
//  MapAnnotation.m
//  BU Transit Redux
//
//  Created by Ross Tang Him on 9/6/14.
//
//

#import "MapAnnotation.h"
#import "Constants.h"
@interface MapAnnotation()
@property (nonatomic) NSDictionary* info;

@end

@implementation MapAnnotation

- (id)initWithType:(NSInteger) type
              name:(NSString*)name
          objectId:(NSString*)objectId
          location:(CLLocationCoordinate2D)location
              info:(NSDictionary *) info{
    if ((self = [super init])) {
        if (info) {
            self.info = info;
        }
        self.type = type;
        self.objId = objectId;
        self.arrivalEstimate = [NSString new];
        switch (type) {
            case BUT_AnnotationTypeArrivalEstimates:
                
                break;
            case BUT_AnnotationTypeRoutes:
                
                break;
            case BUT_AnnotationTypeStops:
                self.name = name;
                self.coordinate = location;
                
                break;
            case BUT_AnnotationTypeSegments:
                
                break;
            case BUT_AnnotationTypeVehicles:
                self.name = name;
                self.coordinate = location;
                break;
            default:
                break;
        }
    }
    return self;
}

- (id)initWithType:(NSInteger) type
              name:(NSString*)name
            objectId:(NSString*)objectId
            location:(CLLocationCoordinate2D)location {
    if ((self = [super init])) {
        self.type = type;
        self.objId = objectId;
        self.arrivalEstimate = [NSString new];
        switch (type) {
            case BUT_AnnotationTypeArrivalEstimates:
                
                break;
            case BUT_AnnotationTypeRoutes:
                
                break;
            case BUT_AnnotationTypeStops:
                self.name = name;
                self.coordinate = location;
                
                break;
            case BUT_AnnotationTypeSegments:
                
                break;
            case BUT_AnnotationTypeVehicles:
                self.name = name;
                self.coordinate = location;
                break;
            default:
                break;
        }
    }
    return self;
}

- (NSString *)title {
    switch (self.type) {
        case BUT_AnnotationTypeArrivalEstimates:
            
            break;
        case BUT_AnnotationTypeRoutes:
            
            break;
        case BUT_AnnotationTypeStops:
            return self.name;
            break;
        case BUT_AnnotationTypeSegments:
            
            break;
        case BUT_AnnotationTypeVehicles: {
            if (self.info &&
                [self.info objectForKey:kBUTBusTypeString]) {
                return [self.info objectForKey:kBUTBusTypeString];
            } else {
                return @"Bus";

            }
            
            break;

        }
        default:
            break;
    }
    return @"";
}

- (NSString *)subtitle {
    switch (self.type) {
        case BUT_AnnotationTypeArrivalEstimates:
            
            break;
        case BUT_AnnotationTypeRoutes:
            
            break;
        case BUT_AnnotationTypeStops:
            return self.arrivalEstimate;
            break;
        case BUT_AnnotationTypeSegments:
            
            break;
        case BUT_AnnotationTypeVehicles:
            return self.name;

            break;
        default:
            break;
    }
    return @"";
}





@end
