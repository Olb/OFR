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
#import <MapKit/MapKit.h>
#import "BPBDataFetch.h"
#import "BPBOriginsPhotoCell.h"
#import "BPBProduct.h"

@interface BPBMainScreenViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKPlacemark *placemark;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *snapShotView;
@property (weak, nonatomic) IBOutlet UIView *snapShotTitleBarView;
@property (weak, nonatomic) IBOutlet UIView *scannerTouchView;
@property (nonatomic) NSURLSession *session;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (nonatomic, copy) NSArray *testArray;

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
    
    // Collection view
    UINib *cellNib = [UINib nibWithNibName:@"PhotoCell" bundle:nil];
    [self.imageCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"PhotoCell"];
    
    // Setup some test products
    BPBProduct *one = [[BPBProduct alloc] init];
    one.productName = @"Wooden Stand";
    one.productImage = [UIImage imageNamed:@"wood.png"];
    
    BPBProduct *two = [[BPBProduct alloc] init];
    two.productName = @"Handcrafted Chair";
    two.productImage = [UIImage imageNamed:@"chair.png"];
    
    BPBProduct *three = [[BPBProduct alloc] init];
    three.productName = @"Custom Cups";
    three.productImage = [UIImage imageNamed:@"cups.png"];
    
    BPBProduct *four = [[BPBProduct alloc] init];
    four.productName = @"Handmade Office Tools";
    four.productImage = [UIImage imageNamed:@"office_tools.png"];
    
    BPBProduct *five = [[BPBProduct alloc] init];
    five.productName = @"Wallet";
    five.productImage = [UIImage imageNamed:@"wallet.png"];
    
    // Test array to hold products
    self.testArray = @[one, two, three, four, five];
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

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
   // NSString *searchTerm = nil;
    return self.testArray.count;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BPBOriginsPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.productName.text = ((BPBProduct*)[self.testArray objectAtIndex:indexPath.row]).productName;
    cell.imageView.image = ((BPBProduct*)[self.testArray objectAtIndex:indexPath.row]).productImage;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
////    NSString *searchTerm = self.searches[indexPath.section];
////    FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
////    // 2
////    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
////    retval.height += 35;
////    retval.width += 35;
//    return CGSizeMake(20, 20);
//}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 30, 10, 30);
}
@end
