//
//  PageViewController.m
//  BU Transit Redux
//
//  Created by Ross Tang Him on 9/7/14.
//
//

#import "PageViewController.h"

static const NSInteger indexSchedule = 1;
static const NSInteger indexList = 2;
static const NSInteger indexMap = 3;
static const NSInteger indexTwitter = 4;
static const NSInteger indexSettings = 5;

@interface PageViewController ()
@property (nonatomic) NSArray *VCs;
@property (nonatomic) UITabBar *tabBar;
@end

@implementation PageViewController

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
    self.dataSource = self;
    self.delegate = self;
    
    //Tabbar
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    self.tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0,
                                                             screenFrame.size.height-49,
                                                             screenFrame.size.width,
                                                             49)];
    [self.view addSubview:self.tabBar];
    UITabBarItem *schedule = [[UITabBarItem alloc] initWithTitle:@"Schedule"
                                                           image:[UIImage imageNamed:@"BUT_ScheduleIcon.png"]
                                                             tag:indexSchedule];
    UITabBarItem *list = [[UITabBarItem alloc] initWithTitle:@"List"
                                                         image:[UIImage imageNamed:@"BUT_ListIcon.png"]
                                                           tag:indexList];

    UITabBarItem *map = [[UITabBarItem alloc] initWithTitle:@"Map"
                                                       image:[UIImage imageNamed:@"BUT_MapIcon.png"]
                                                         tag:indexMap];
    UITabBarItem *twitter = [[UITabBarItem alloc] initWithTitle:@"Twitter"
                                                       image:[UIImage imageNamed:@"BUT_TwitterIcon.png"]
                                                         tag:indexTwitter];
    UITabBarItem *settings = [[UITabBarItem alloc] initWithTitle:@"Settings"
                                                       image:[UIImage imageNamed:@"BUT_SettingsIcon.png"]
                                                         tag:indexSettings];
    [self.tabBar setItems:@[schedule, list, map, twitter, settings]];
    [self.tabBar setSelectedItem:list];

    
    
    
    
    //PageView
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                             bundle: nil];
    UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"scheduleNav"];
    UINavigationController *controller2 = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"listNav"];
    UINavigationController *controller3 = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mapNav"];
    UINavigationController *controller4 = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"twitterNav"];
    UINavigationController *controller5 = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"settingsNav"];
    self.VCs = @[controller, controller2, controller3, controller4, controller5];
    
    [self setViewControllers:@[controller2] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished){}];
    
    for (UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
        gestureRecognizer.delegate = self;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
    
}

-(void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
}


#pragma mark - UIPageViewControllerDataSource Methods

// Returns the view controller before the given view controller. (required)
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger currentIndex = [self.VCs indexOfObject:viewController];
    if(currentIndex == 0)
        return nil;
    
    return [self.VCs objectAtIndex:currentIndex -1];
    
}



// Returns the view controller after the given view controller. (required)
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.VCs indexOfObject:viewController];
    if(currentIndex == self.VCs.count - 1)
        return nil;
    
    return [self.VCs objectAtIndex:currentIndex + 1];
    
}


@end
