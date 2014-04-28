//
//  BPBMainScreenViewController.m
//  Origins
//
//  Created by billy bray on 4/23/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBMainScreenViewController.h"
#import "BPBConstants.h"
#import "BPBStoreLocationAnnotation.h"
#import "BPBScannerViewController.h"

// Google API Key
#define API_KEY "AIzaSyDlFcGWWUhqrcinZfrUbWPr5zzf80mg-ic"

@interface BPBMainScreenViewController () <CLLocationManagerDelegate, MKMapViewDelegate, NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKPlacemark *placemark;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *snapShotView;
@property (weak, nonatomic) IBOutlet UIView *snapShotTitleBarView;
@property (weak, nonatomic) IBOutlet UIView *scannerTouchView;
@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic) NSURLSession *session;


@end

@implementation BPBMainScreenViewController

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
    
    // Location manager fetch's information about the user's location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // show the user loc
    self.mapView.showsUserLocation = YES;
    
    // Swipe up gesture for Snapshot
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(snapShotSwipeUp:)];
    swipeUp.numberOfTouchesRequired = 1;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.snapShotTitleBarView addGestureRecognizer:swipeUp];
    
    // Swipe down gesture for Snapshot
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(snapShowSwipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDown.numberOfTouchesRequired = 1;
    [self.snapShotTitleBarView addGestureRecognizer:swipeDown];
    
    // Swipe right gesture for scanner view
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scannerSwipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.scannerTouchView addGestureRecognizer:swipeRight];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Mapping and annotations
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    // For user there is one object grab first
    MKAnnotationView *annotaionView = [views objectAtIndex:0];
    id<MKAnnotation> mp = [annotaionView annotation];
    
    // Set the region to a two mile radius
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], ONE_MILE*2, ONE_MILE*2);
    
    [mapView setRegion:region animated:YES];
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // This is the user, don't do anything special
    if ([annotation isKindOfClass:[BPBStoreLocationAnnotation class]] == NO) {
        return nil;
    }
    
    // Typecast the annotation for which Map View has fired this delegate
    BPBStoreLocationAnnotation *senderAnnotation = (BPBStoreLocationAnnotation*)annotation;
    
    // Use defined class method to get reusable identifier for the pin about to be created
    NSString *annotationIdentifier = [BPBStoreLocationAnnotation reusableIdentifierForPinColor:senderAnnotation.pinColor];
    
    // Using retrieved identifier, attempt to reuse pin in the sender Map View
    MKPinAnnotationView *pinView =  (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!pinView) {
        // failed to reuse a in, create it
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:(BPBStoreLocationAnnotation *)senderAnnotation reuseIdentifier:annotationIdentifier];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
    }
    
    // Make sure the color of pin matches the color of the annotaion
    pinView.pinColor = senderAnnotation.pinColor;
    
    return pinView;
    
}

-(void)getStoreNameAndCoordinateForImpact:(NSInteger)impact
{
    // Check that location services are enabled by user
    if ([CLLocationManager locationServicesEnabled]) {
        CLLocationManager *mgr = [[CLLocationManager alloc] init];
        mgr.delegate = self;
        
        // Get the user's current location
        CLLocationCoordinate2D userCoordinate = mgr.location.coordinate;
        
        // Setup the 'Get' Request
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:self
                                            delegateQueue:nil];
        // First need to grab store info
        // Setup the request string parameters
        NSMutableString *builder = [[NSMutableString alloc] initWithString:@"location="];
        [builder appendString:[NSString stringWithFormat:@"%f", userCoordinate.latitude]];
        [builder appendString:@","];
        [builder appendString:[NSString stringWithFormat:@"%f", userCoordinate.longitude]];
        [builder appendString:@"&key="];
        [builder appendString:@API_KEY];
        [builder appendString:@"&sensor=true"];
        [builder appendString:@"&types=establishment"];
        [builder appendString:@"&rankby=distance"];
        // Append the parameters to the request
        NSMutableString *requestString = [[NSMutableString alloc] initWithString:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?"];
        [requestString appendString:builder];
        
        NSURL *url = [NSURL URLWithString:requestString];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                         completionHandler:
                                          ^(NSData *data, NSURLResponse *response, NSError *error) {
                                              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:0
                                                                                                           error:nil];
                                              
                                              // Once done with request call addStoreLocation:withImpact:withCoordinate to set pin
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  // Get the first result
                                                  __weak NSString *storeName = [[jsonObject[@"results"] objectAtIndex:0] valueForKey:@"name"];
                                                  [self addStoreLocation:storeName
                                                              withImpact:impact
                                                          withCoordinate:userCoordinate];
                                                  
                                              });
                                          }];
        [dataTask resume];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Swiping
-(void)snapShotSwipeUp:(UIGestureRecognizer*)g
{
    // Swipe up pulls up origins snapshots
    CGRect snapShotRect = CGRectMake(self.snapShotView.frame.origin.x, self.snapShotView.frame.origin.y-325,self.snapShotView.frame.size.width , self.snapShotView.frame.size.height);
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self.snapShotView setFrame:snapShotRect];
                     }
                     completion:^(BOOL finished){
                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
                     }];
}

-(void)snapShowSwipeDown:(UIGestureRecognizer*)g
{
    // Swipe down lowers snapshots
    CGRect snapShotRect = CGRectMake(self.snapShotView.frame.origin.x, self.snapShotView.frame.origin.y+325,self.snapShotView.frame.size.width , self.snapShotView.frame.size.height);
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self.snapShotView setFrame:snapShotRect];
                     }
                     completion:^(BOOL finished){
                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
                     }];
}

-(void)scannerSwipeRight:(UIGestureRecognizer*)g
{
    // Swipe right in from left side launches scanner
    BPBScannerViewController *svc = [[BPBScannerViewController alloc] init];
    // Reference to self to pop
    svc.mvc = self;
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - Add pins
-(void)addStoreLocation:(NSString*)storeName withImpact:(NSInteger)impact withCoordinate:(CLLocationCoordinate2D)userCoordinate
{
    // Add the custom annotation
    BPBStoreLocationAnnotation *storeLocationAnnotation = [[ BPBStoreLocationAnnotation alloc] initWithCoordinate:userCoordinate title:storeName subTitle:nil withImpact:impact];
    [self.mapView addAnnotation:storeLocationAnnotation];
}

@end
