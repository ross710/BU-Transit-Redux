//
//  ListViewController.m
//  BU Transit Redux
//
//  Created by Ross Tang Him on 9/6/14.
//
//

#import "ListViewController.h"
#import "BUT_Backend.h"
#import "ListCell.h"
#import "Constants.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];

    
    
    
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
    
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.backgroundColor = [UIColor redColor];
//    self.refreshControl.tintColor = [UIColor whiteColor];
//    [self.refreshControl addTarget:self
//                            action:@selector(updateData:)
//                  forControlEvents:UIControlEventValueChanged];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    
    



//    [BUT_Backend getStopsWithBlock:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//
//    }];
//    [self.tableView reloadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = [BUT_Backend sharedInstance].userLocationString;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateData:(id) sender {
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data"];
    
}

#pragma mark - nsnotification
- (void) userLocationChanged:(NSNotification *) notification
{
    self.navigationItem.title = [BUT_Backend sharedInstance].userLocationString;
}
- (void) stopsUpdated:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void) vehiclesUpdated:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void) arrivalEstimatesUpdated:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[BUT_Backend sharedInstance].stops count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 165.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCell";
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
  
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil];
        cell = (ListCell *)[nib objectAtIndex:0];
    }
   
   
    NSDictionary *stop = [[BUT_Backend sharedInstance].stops objectAtIndex:indexPath.row];
    cell.stopName.text = [stop objectForKey:@"name"];
    
    
    NSDictionary *arrivalEstimate = [[BUT_Backend sharedInstance].arrivalEstimates objectForKey:[stop objectForKey:@"stop_id"]];
    
    cell.timeAway.text = [Utilities minutesFromArrivalEstimate:arrivalEstimate];
    
    
    cell.busImage.tintColor = [UIColor blackColor];

    
    
//    NSDictionary *vehicle = [[BUT_Backend sharedInstance].vehicles objectForKey:[arrivalEstimate objectForKey:@"stop_id"]];
//    
//    cell.busInfo.text = [NSString stringWithFormat:@"%@ (%@)", [Utilities busTypeString:]]

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *busImage;
        
        busImage = [[UIImage imageNamed:@"BUT_SmallBusIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
//        dispatch_async(dispatch_get_main_queue(), ^{

            cell.busImage.image = busImage;
//        });
//    });
    

 
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kBUTTabBarHeight;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, kBUTTabBarHeight)];
    footer.backgroundColor = self.tableView.backgroundColor;
    return footer;
}
@end
