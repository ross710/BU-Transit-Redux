//
//  MapViewController.m
//  BU Transit Redux
//
//  Created by Ross Tang Him on 9/6/14.
//
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "BUT_Backend.h"
#import "MapAnnotation.h"
#import "Constants.h"

#define ZOOM_CONSTANT_IOS7 5150.0
#define ZOOM_CONSTANT 4500


@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineView *routeLineView;
@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLocationChanged:)
                                                 name:@"userLocationChanged"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(vehiclesUpdated:)
                                                 name:@"vehiclesUpdated"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopsUpdated:)
                                                 name:@"stopsUpdated"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(arrivalEstimatesUpdated:)
                                                 name:@"arrivalEstimatesUpdated"
                                               object:nil];
    //Navbar
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(helpButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem = helpButton;
    
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = resetButton;
    
    
    [self plotRoute];
    [self plotVehicles];
    [self plotStops];
    
    [self resetMap];


    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = [BUT_Backend sharedInstance].userLocationString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - nsnotification
- (void) userLocationChanged:(NSNotification *) notification
{
    self.navigationItem.title = [BUT_Backend sharedInstance].userLocationString;
}

- (void) stopsUpdated:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self plotStops];
    });
}
- (void) vehiclesUpdated:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self plotVehicles];
    });
}
- (void) arrivalEstimatesUpdated:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (MapAnnotation *annotation in self.mapView.annotations) {
            NSString *stop_id = [annotation objId];
            NSDictionary *arrivalEstimate = [[BUT_Backend sharedInstance].arrivalEstimates objectForKey:stop_id];
            [annotation setArrivalEstimate:[Utilities minutesMapFromArrivalEstimate:arrivalEstimate]];
        }
    });
}

#pragma mark - MKMapView delegate
- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
    
    
    //try to first dequeue but if not there create a new one
	static NSString *pinIdentifier = @"BUT_Annotation";
    MKAnnotationView *annotationView = (MKAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
    }
    annotationView.canShowCallout = YES;
    
    MapAnnotation *mapAnnotation = annotation;
    switch (mapAnnotation.type) {
        case BUT_AnnotationTypeArrivalEstimates:
            
            break;
        case BUT_AnnotationTypeRoutes:
            
            break;
        case BUT_AnnotationTypeStops:
            
            annotationView.image = [UIImage imageNamed:@"BUT_StopAnnotationIcon.png"];
            break;
        case BUT_AnnotationTypeSegments:
            
            break;
        case BUT_AnnotationTypeVehicles:
            annotationView.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
            annotationView.image = [UIImage imageNamed:@"BUT_BusRedIcon.png"];

            break;
        default:
            break;
    }

	return annotationView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay
{
    MKOverlayView *overlayView = nil;
    
    if(overlay == self.routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.strokeColor = [UIColor blueColor];
            self.routeLineView.alpha = 0.8;
            self.routeLineView.lineWidth = 3;
        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
}

-(void) plotRoute {
    NSString* filePath;
    filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];

//    if (isNightTime) {
//        filePath = [[NSBundle mainBundle] pathForResource:@"routeNight" ofType:@"csv"];
//    } else {
//        filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
//    }
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // while we create the route points, we will also be calculating the bounding box of our route
    // so we can easily zoom in on it.
    MKMapPoint northEastPoint;
    MKMapPoint southWestPoint;
    
    // create a c array of points.
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * pointStrings.count);
    
    for(int idx = 0; idx < pointStrings.count; idx++)
    {
        // break the string down even further to latitude and longitude fields.
        NSString* currentPointString = [pointStrings objectAtIndex:idx];
        
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        CLLocationDegrees latitude = [[latLonArr objectAtIndex:0] doubleValue];
        CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
        
        // create our coordinate and add it to the correct spot in the array
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        // if it is the first point, just use them, since we have nothing to compare to yet.
        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        }
        else
        {
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if(point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
        }
        
        pointArr[idx] = point;
        
    }
    
    // create the polyline based on the array of points.
    self.routeLine = [MKPolyline polylineWithPoints:pointArr count:pointStrings.count];
    
    // clear the memory allocated earlier for the points
    free(pointArr);

    
    [self.mapView addOverlay:self.routeLine];

}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        if ([[aV annotation] isKindOfClass:[MKUserLocation class]])
        {
            aV.layer.zPosition = 2049;
            continue;
        } else if ([[aV annotation] isKindOfClass:[MapAnnotation class]])
        {
            aV.layer.zPosition = 2047;
        }
        else
        {
            aV.layer.zPosition = 2048;
            
        }
        
        
        // Check if current annotation is inside visible map rect
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x,
                              aV.frame.origin.y - self.mapView.frame.size.height,
                              aV.frame.size.width,
                              aV.frame.size.height);
        aV.frame = endFrame;
    }
}



#pragma mark - reset map
-(void) resetMap {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 42.34091;
    zoomLocation.longitude= -71.09682;
    
    // 2
    MKCoordinateRegion viewRegion;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, ZOOM_CONSTANT_IOS7, ZOOM_CONSTANT_IOS7);
    } else {
        viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, ZOOM_CONSTANT, ZOOM_CONSTANT);
    }
    //3.2
    //20
    
    // 3
    [self.mapView setRegion:viewRegion animated:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
    [self resetMap];
}
- (IBAction)resetButtonPressed:(id)sender {
    [self resetMap];
}


#pragma mark - plot data
-(void) plotStops {
    NSArray *stops = [BUT_Backend sharedInstance].stops;
    if (stops) {
        for (NSDictionary *object in stops) {
            NSDictionary *locationDictionary = [object objectForKey:@"location"];
            NSString *latitudeString = [locationDictionary objectForKey:@"lat"];
            NSString *longitudeString = [locationDictionary objectForKey:@"lng"];
            
            
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([latitudeString doubleValue], [longitudeString doubleValue]);
            MapAnnotation *mapAnnotation = [[MapAnnotation alloc] initWithType:BUT_AnnotationTypeStops
                                                                          name:[object objectForKey:@"name"]
                                                                        objectId:[object objectForKey:@"stop_id"]
                                                                      location:location];
            [self.mapView addAnnotation:mapAnnotation];
        }

    }
    
}


-(void) plotVehicles {
    NSArray *vehicles = [BUT_Backend sharedInstance].vehicles;
    
    if (vehicles) {
        

        
        for (NSDictionary *object in vehicles) {
            NSDictionary *locationDictionary = [object objectForKey:@"location"];
            NSString *latitudeString = [locationDictionary objectForKey:@"lat"];
            NSString *longitudeString = [locationDictionary objectForKey:@"lng"];
            
            
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([latitudeString doubleValue], [longitudeString doubleValue]);
            
            NSString *objectId = [object objectForKey:@"vehicle_id"];
            MapAnnotation *annotation = [self annotationForObjectId: objectId];
            
            if (annotation) {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                
                [annotation setLocation:location];
                [UIView commitAnimations];
            } else {

                MapAnnotation *mapAnnotation = [[MapAnnotation alloc] initWithType:BUT_AnnotationTypeVehicles
                                                                              name:[object objectForKey:@"call_name"]
                                                                          objectId:objectId
                                                                          location:location];
                [self.mapView addAnnotation:mapAnnotation];
            }
        }
        
    }
    
}

-(MapAnnotation *) annotationForObjectId:(NSString *) objectId{
    for (MapAnnotation *annotation in self.mapView.annotations) {
        if ([annotation.objId isEqualToString:objectId]) {
            return annotation;
        }
    }
    return nil;
}


@end
