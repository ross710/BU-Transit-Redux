//
//  PageViewController.m
//  BU Transit Redux
//
//  Created by Ross Tang Him on 9/7/14.
//
//

#import "PageViewController.h"
#import "ScheduleViewController.h"
#import "ListViewController.h"
#import "MapViewController.h"
#import "TwitterViewController.h"
#import "SettingsViewController.h"
#import "Constants.h"

static const NSInteger indexSchedule = 0;
static const NSInteger indexList = 1;
static const NSInteger indexMap = 2;
static const NSInteger indexTwitter = 3;
static const NSInteger indexSettings = 4;

@interface PageViewController ()
@property (nonatomic) NSArray *VCs;
@property (nonatomic) UITabBar *tabBar;
@property (nonatomic) NSInteger lastPageIndex;

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
                                                             screenFrame.size.height-cTabBarHeight,
                                                             screenFrame.size.width,
                                                             cTabBarHeight)];
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
    [self.tabBar setTranslucent:NO];

    
    self.tabBar.delegate = self;
    
    
    //PageView
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                             bundle: nil];

    UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"scheduleNav"];
    UINavigationController *controller2 = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"listNav"];
    UINavigationController *controller3 = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mapNav"];
    UINavigationController *controller4 = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"twitterNav"];
    UINavigationController *controller5 = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"settingsNav"];
    self.VCs = @[controller, controller2, controller3, controller4, controller5];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    

    if ([prefs objectForKey:kShowMapByDefault]) {
        if ([[prefs objectForKey:kShowMapByDefault] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            [self setViewControllers:@[controller3] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished){}];
            [self.tabBar setSelectedItem:map];

        } else {
            [self setViewControllers:@[controller2] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished){}];
            [self.tabBar setSelectedItem:list];

        }
        
    } else {
        [self setViewControllers:@[controller2] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished){}];
        [self.tabBar setSelectedItem:list];

    }
    


    
    for (UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
        gestureRecognizer.delegate = self;
    }
    
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                        self.view.frame.origin.y + 200,
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.height-cTabBarHeight);

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
    self.lastPageIndex = [self.VCs indexOfObject:[self.childViewControllers objectAtIndex:0]];
    

//
//    if ([[self.childViewControllers objectAtIndex:0] isKindOfClass:[ScheduleViewController class]]) {
//        self.lastPageIndex = indexSchedule;
//    } else if ([[self.childViewControllers objectAtIndex:0] isKindOfClass:[ListViewController class]]) {
//        self.lastPageIndex = indexList;
//    } else if ([[self.childViewControllers objectAtIndex:0] isKindOfClass:[MapViewController class]]) {
//        self.lastPageIndex = indexMap;
//    } else if ([[self.childViewControllers objectAtIndex:0] isKindOfClass:[TwitterViewController class]]) {
//        self.lastPageIndex = indexTwitter;
//    } else if ([[self.childViewControllers objectAtIndex:0] isKindOfClass:[SettingsViewController class]]) {
//        self.lastPageIndex = indexSettings;
//    }

}


#pragma mark - UIPageViewControllerDataSource Methods

// Returns the view controller before the given view controller. (required)
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger currentIndex = [self.VCs indexOfObject:viewController];
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:currentIndex]];

    if(currentIndex == 0)
        return nil;
    

    return [self.VCs objectAtIndex:currentIndex -1];
    
}



// Returns the view controller after the given view controller. (required)
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.VCs indexOfObject:viewController];
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:currentIndex]];

    if(currentIndex == self.VCs.count - 1)
        return nil;

    return [self.VCs objectAtIndex:currentIndex + 1];
    
}


#pragma mark - tab bar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    __weak PageViewController* pvcw = self;
    [self setViewControllers:@[[self.VCs objectAtIndex:item.tag]]
                   direction:UIPageViewControllerNavigationDirectionReverse
                    animated:NO completion:^(BOOL finished) {
                        PageViewController* pvcs = pvcw;
                        if (!pvcs) return;
                        dispatch_async(dispatch_get_main_queue(), ^{

                            [pvcs setViewControllers:@[[pvcs.VCs objectAtIndex:item.tag]]
                                           direction:UIPageViewControllerNavigationDirectionReverse
                                            animated:NO completion:nil];
                        });
                    }];

}

@end
