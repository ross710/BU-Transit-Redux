//
//  MapAnnotation.m
//  BU Transit Redux
//
//  Created by Ross Tang Him on 9/6/14.
//
//

#import "MapAnnotation.h"
@interface MapAnnotation()


@end

@implementation MapAnnotation

- (id)initWithType:(NSInteger) type
              name:(NSString*)name
            stopId:(NSNumber*)stopId
            location:(CLLocationCoordinate2D)location {
    if ((self = [super init])) {
        self.type = type;
        switch (type) {
            case BUT_AnnotationTypeArrivalEstimates:
                
                break;
            case BUT_AnnotationTypeRoutes:
                
                break;
            case BUT_AnnotationTypeStops:
                self.name = name;
                self.stopId = stopId;
                self.location = location;
                
                break;
            case BUT_AnnotationTypeSegments:
                
                break;
            case BUT_AnnotationTypeVehicles:
                
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
        case BUT_AnnotationTypeVehicles:
            
            break;
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
            return self.stopId;
            break;
        case BUT_AnnotationTypeSegments:
            
            break;
        case BUT_AnnotationTypeVehicles:
            
            break;
        default:
            break;
    }
    return @"";
}

- (CLLocationCoordinate2D)coordinate {
    return self.location;
}

@end
