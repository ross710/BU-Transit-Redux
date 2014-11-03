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
    return 145.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCell";
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell =  [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    NSDictionary *stop = [[BUT_Backend sharedInstance].stops objectAtIndex:indexPath.row];
    cell.stopName.text = [stop objectForKey:@"name"];
    
    
    NSDictionary *arrivalEstimate = [[BUT_Backend sharedInstance].arrivalEstimates objectForKey:[stop objectForKey:@"stop_id"]];
    
    cell.timeAway.text = [Utilities minutesFromArrivalEstimate:arrivalEstimate];

    return cell;
}



@end
