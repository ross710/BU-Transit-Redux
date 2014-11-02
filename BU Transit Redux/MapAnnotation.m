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
            objectId:(NSString*)objectId
            location:(CLLocationCoordinate2D)location {
    if ((self = [super init])) {
        self.type = type;
        self.objId = objectId;

        switch (type) {
            case BUT_AnnotationTypeArrivalEstimates:
                
                break;
            case BUT_AnnotationTypeRoutes:
                
                break;
            case BUT_AnnotationTypeStops:
                self.name = name;
                self.location = location;
                
                break;
            case BUT_AnnotationTypeSegments:
                
                break;
            case BUT_AnnotationTypeVehicles:
                self.name = name;
                self.location = location;
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
            return @"Bus";
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
            return self.objId;
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

- (CLLocationCoordinate2D)coordinate {
    return self.location;
}

- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.location = newCoordinate;
}

@end
