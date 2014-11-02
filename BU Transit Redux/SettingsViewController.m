//
//  SettingsViewController.m
//  BU Transit Redux
//
//  Created by Ross Tang Him on 9/6/14.
//
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import "Constants.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sendFeedbackButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *onLaunchSwitchBackgroundView;
@property (weak, nonatomic) IBOutlet UISwitch *onLaunchSwitch;

@end

@implementation SettingsViewController

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

    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

    self.navigationItem.title = @"Settings";
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self.onLaunchSwitchBackgroundView.layer.cornerRadius = 48.0;
    self.onLaunchSwitch.center = CGPointMake(screenRect.size.width/2 - self.onLaunchSwitch.frame.size.width/4, self.onLaunchSwitch.center.y);
    
    self.sendFeedbackButton.layer.cornerRadius = 20.0;
    
    
    


    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    //Flip switch
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:kShowMapByDefault]) {
        if ([[prefs objectForKey:kShowMapByDefault] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            [self.onLaunchSwitch setOn:YES animated:NO];

        } else {
            [self.onLaunchSwitch setOn:NO animated:NO];

        }

    } else {
        [self.onLaunchSwitch setOn:NO animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedbackButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send Feedback/Request Feature"
                                                    message:@"Any feedback is always appreciated and will be anonymous unless you include your contact info."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Send Feedback",nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *contactInfo = [alert textFieldAtIndex:0];
    contactInfo.keyboardType = UIKeyboardTypeDefault;
    contactInfo.placeholder = @"Write feedback here";

    [alert show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == [alertView cancelButtonIndex]) {
        
    } else {
        NSString *feedback = [alertView textFieldAtIndex:0].text;
        if (feedback.length <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry :("
                                                            message:@"Couldn't send your feedback because you didn't write anything."
                                                           delegate:self
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            [self sendFeedbackWithString:feedback];
        }
        
    }

}


-(void) sendFeedbackWithString: (NSString *) string {
    PFObject *obj = [PFObject objectWithClassName:@"Feedback"
                                       dictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   string, @"message",
                                                   [PFInstallation currentInstallation], @"installation",
                                                   nil]];
    
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks for the feedback!"
                                                            message:@"Successfully Sent"
                                                           delegate:self
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh oh"
                                                            message:@"Couldn't send the feedback you wrote. Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}
- (IBAction)onLaunchSwitchChanged:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    

    if (self.onLaunchSwitch.isOn) {
        [prefs setObject:[NSNumber numberWithBool:YES] forKey:kShowMapByDefault];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                        message:@"BU Transit will show the Map View by default on launch now."
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [prefs setObject:[NSNumber numberWithBool:NO] forKey:kShowMapByDefault];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                        message:@"BU Transit will show the List View by default on launch now."
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [prefs synchronize];

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

@end
