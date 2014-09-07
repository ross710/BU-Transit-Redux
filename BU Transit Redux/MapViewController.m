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

#define ZOOM_CONSTANT_IOS7 5150.0
#define ZOOM_CONSTANT 4500


@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

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

    //Navbar
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                target:self
                                                                                action:nil];
    
    self.navigationItem.leftBarButtonItem = helpButton;
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                target:self
                                                                                   action:@selector(refreshButtonPressed:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    [self resetMap];

    [self plotStops];
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

            break;
        default:
            break;
    }

	return annotationView;
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

- (IBAction)refreshButtonPressed:(id)sender {
    [self resetMap];
}

#pragma mark - plot data
-(void) plotStops {
    NSArray *stops = [BUT_Backend getStopsWithBlock:^{
        for (NSDictionary *object in [BUT_Backend sharedInstance].stops) {
            NSDictionary *locationDictionary = [object objectForKey:@"location"];
            NSString *latitudeString = [locationDictionary objectForKey:@"lat"];
            NSString *longitudeString = [locationDictionary objectForKey:@"lng"];
            
            
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([latitudeString doubleValue], [longitudeString doubleValue]);
            MapAnnotation *mapAnnotation = [[MapAnnotation alloc] initWithType:BUT_AnnotationTypeStops
                                                                          name:[object objectForKey:@"name"]
                                                                        stopId:[object objectForKey:@"stop_id"]
                                                                      location:location];
            [self.mapView addAnnotation:mapAnnotation];
        }

    }];
    if (stops) {
        for (NSDictionary *object in stops) {
            NSDictionary *locationDictionary = [object objectForKey:@"location"];
            NSString *latitudeString = [locationDictionary objectForKey:@"lat"];
            NSString *longitudeString = [locationDictionary objectForKey:@"lng"];
            
            
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([latitudeString doubleValue], [longitudeString doubleValue]);
            MapAnnotation *mapAnnotation = [[MapAnnotation alloc] initWithType:BUT_AnnotationTypeStops
                                                                          name:[object objectForKey:@"name"]
                                                                        stopId:[object objectForKey:@"stop_id"]
                                                                      location:location];
            [self.mapView addAnnotation:mapAnnotation];
        }

    }
    
}


@end
