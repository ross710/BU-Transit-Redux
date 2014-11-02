//
//  ScheduleViewController.m
//  BU Transit Redux
//
//  Created by Ross Tang Him on 9/7/14.
//
//

#import "ScheduleViewController.h"

@interface ScheduleViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ScheduleViewController

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
    self.navigationItem.title = @"BU Shuttle Schedule";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(webViewGoHome)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(webViewGoBack)];
    [self setUpWebView];
    // Do any additional setup after loading the view.
}


-(void) setUpWebView {
    UIWebView *webview = [UIWebView new];
    
    self.view = webview;
    [self webViewGoHome];
}

-(void) webViewGoHome {
    NSString *fullURL = @"http://www.bu.edu/thebus/schedules/";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [((UIWebView *)self.view) loadRequest:requestObj];

}

-(void) webViewGoBack {
    if ([((UIWebView *)self.view) canGoBack]) {
        [((UIWebView *)self.view) goBack];
    } else {
        
    }
    
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

@end
