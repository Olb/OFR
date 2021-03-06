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
#import "BPBStore.h"
#import "BPBAnnotationView.h"
#import "BPBAnnotationCalloutView.h"
#import "BPBGenericAnnotation.h"

@interface BPBMainScreenViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKPlacemark *placemark;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *snapShotView;
@property (weak, nonatomic) IBOutlet UIView *snapShotTitleBarView;
@property (weak, nonatomic) IBOutlet UIView *scannerTouchView;
@property (nonatomic) NSURLSession *session;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (nonatomic) NSMutableArray *productCollectionDisplayArray;
@property (nonatomic) NSMutableArray *stores;
@property (nonatomic) NSMutableArray *products;
@property BOOL snaphotIsDown;
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
    UITapGestureRecognizer *tapSnapshot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(snapShotUp:)];
    tapSnapshot.numberOfTouchesRequired = 1;
    [self.snapShotTitleBarView addGestureRecognizer:tapSnapshot];
    
    // Swipe down gesture for Snapshot
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(snapShowSwipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDown.numberOfTouchesRequired = 1;
    [self.snapShotTitleBarView addGestureRecognizer:swipeDown];
    
    // Tap gesture for scanner view
    UITapGestureRecognizer *tapScanner = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showScanner:)];
    tapScanner.numberOfTouchesRequired = 1;
    [self.scannerTouchView addGestureRecognizer:tapScanner];
    
    // Collection view
    UINib *cellNib = [UINib nibWithNibName:@"PhotoCell" bundle:nil];
    [self.imageCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"PhotoCell"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    // Stop snapshot from going up when it's already up
    self.snaphotIsDown = NO;
    // Create array for holding snapshot products if not already created
    if (!self.productCollectionDisplayArray) {
        self.productCollectionDisplayArray = [[NSMutableArray alloc] init];
    }
    // When reloading, pulling new data so go ahead and remove all old objects
    [self.productCollectionDisplayArray removeAllObjects];
    // Add known products
    if (self.products.count > 0) {
        for (BPBProduct *p in self.products) {
            if (p.impact == GoodImpact) {
                [self.productCollectionDisplayArray addObject:p];
            }
        }
        for (BPBProduct *x in self.productCollectionDisplayArray) {
            NSLog(@"Product Name: %@", x.productName);
        }
    } else {
        // No known products?(productCollectionArray empty)
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
        
        // Array to hold products showing some test products if none yet added
        // Need to pull from server so this shouldn't happen
        [self.productCollectionDisplayArray addObject:one];
        [self.productCollectionDisplayArray addObject:two];
        [self.productCollectionDisplayArray addObject:three];
        [self.productCollectionDisplayArray addObject:four];
        [self.productCollectionDisplayArray addObject:five];
        
    }
    
    for (BPBStore *s in self.stores) {
        [self addStoreAnnotation:s.storeName withImpact:s.impact withCoordinate:s.storeLocation];
    }
    for (BPBStore *s in self.stores) {
        NSLog(@"Store Name: %@", s.storeName);
    }
    [self.imageCollectionView reloadData];

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
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else if ([annotation isKindOfClass:[BPBGenericAnnotation class]]) {
        BPBGenericAnnotation *genericAnnotation = (BPBGenericAnnotation*)annotation;
        MKPinAnnotationView *av = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"GenericId"];
        if (!av) {
            av = [[MKPinAnnotationView alloc] initWithAnnotation:genericAnnotation reuseIdentifier:@"GenericId"];
            av.canShowCallout = YES;
            av.pinColor = MKPinAnnotationColorGreen;
        }
        return av;
    } else {
        // Typecast the annotation for which Map View has fired this delegate
        BPBStoreLocationAnnotation *senderAnnotation = (BPBStoreLocationAnnotation*)annotation;
        
        // Use defined class method to get reusable identifier for the pin about to be created
        NSString *annotationIdentifier = [BPBStoreLocationAnnotation reusableIdentifierForPinColor:senderAnnotation.pinColor];
        
        // Using retrieved identifier, attempt to reuse pin in the sender Map View
        // Using MKAnnotaionView instead of MKPinAnnotationView for custom background
        BPBAnnotationView *pinView =  (BPBAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!pinView) {
            // failed to reuse a pin, create it
            pinView = [[BPBAnnotationView alloc] initWithAnnotation:(BPBStoreLocationAnnotation *)senderAnnotation reuseIdentifier:annotationIdentifier];
            
            pinView.canShowCallout = NO;
            
        }
        
        // Make sure the color of pin matches the color of the annotaion
        if (senderAnnotation.pinColor == MKPinAnnotationColorGreen) {
            pinView.image = [UIImage imageNamed:@"green_circle.png"];
        } else {
            pinView.image = [UIImage imageNamed:@"red_circle.png"];
        }
        
        return pinView;
    }
    
    return nil;
    
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if(![view.annotation isKindOfClass:[MKUserLocation class]] && ![view
                                                                    .annotation isKindOfClass:[BPBGenericAnnotation class]]) {
        BPBAnnotationCalloutView *calloutView = (BPBAnnotationCalloutView *)[[[NSBundle mainBundle] loadNibNamed:@"BPBAnnotationCalloutView" owner:self options:nil] objectAtIndex:0];
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2+10, -calloutViewFrame.size.height-10);
        calloutView.frame = calloutViewFrame;
        [calloutView.annotationCalloutLabel setText:[(BPBStoreLocationAnnotation*)[view annotation] title]];
        [view addSubview:calloutView];
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    for (UIView *subview in view.subviews ){
        [subview removeFromSuperview];
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
-(void)snapShotUp:(UIGestureRecognizer*)g
{
    if (!self.snaphotIsDown) {
        return;
    }
    self.snaphotIsDown = NO;
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
    if (self.snaphotIsDown) {
        return;
    }
    self.snaphotIsDown = YES;
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

-(void)showScanner:(UIGestureRecognizer*)g
{
    // Swipe right in from left side launches scanner
    BPBScannerViewController *svc = [[BPBScannerViewController alloc] init];
    // Reference to self to pop
    svc.mvc = self;
    
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - Add pins
-(void)addStoreAnnotation:(NSString*)storeName withImpact:(NSInteger)impact withCoordinate:(CLLocationCoordinate2D)userCoordinate
{
    // Add the custom annotation
    BPBStoreLocationAnnotation *storeLocationAnnotation = [[ BPBStoreLocationAnnotation alloc] initWithCoordinate:userCoordinate title:storeName subTitle:nil withImpact:impact];
    [self.mapView addAnnotation:storeLocationAnnotation];
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.productCollectionDisplayArray.count;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BPBOriginsPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.productName.text = ((BPBProduct*)[self.productCollectionDisplayArray objectAtIndex:indexPath.row]).productName;
    cell.imageView.image = ((BPBProduct*)[self.productCollectionDisplayArray objectAtIndex:indexPath.row]).productImage;
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
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 30, 10, 30);
}

#pragma mark - Add Store with Product
-(void)addStore:(NSString*)store withImpact:(NSInteger)impact andProduct:(NSString*)productBarcode andLocation:(CLLocationCoordinate2D)coord
{
    if (!self.stores) {
        self.stores = [[NSMutableArray alloc] init];
    }
    for (BPBStore *s in self.stores) {
        if ([s.storeName isEqualToString:store]) {
            [s.productBarcodes addObject:productBarcode];
            return;
        }
    }
    
    BPBStore *newStore = [[BPBStore alloc] init];
    // coord is zero while using test buttons
    coord = self.locationManager.location.coordinate;
    [newStore makeStore:store withImpact:impact andProduct:productBarcode andLocation:coord];
    [self.stores addObject:newStore];
}

-(void)addProduct:(NSString*)product withImpact:(NSInteger)impact andProductBarCode:(NSString*)productBarcode andImage:(UIImage*)image withDescription:(NSString*)description
{
    if (!self.products) {
        self.products = [[NSMutableArray alloc] init];
    }
    // Check if we already have this product - if so, move on
    for (BPBProduct *p in self.products) {
        if ([p.productBarcode isEqualToString:productBarcode]) {
            return;
        }
    }
    // Not yet added? Let's add it
    BPBProduct *newProduct = [[BPBProduct alloc] init];
    [newProduct newProduct:product withBarcode:productBarcode andImage:image withImpact:impact withDescription:description];
    [self.products addObject:newProduct];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    NSLog(@"Searching...");
    [theSearchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        
        for (CLPlacemark *p in placemarks) {
            if ([p.location distanceFromLocation:self.locationManager.location] < ONE_MILE * 100) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                NSLog(@"%@", placemark);
                MKCoordinateRegion region;
                region.center = self.mapView.centerCoordinate;
                
                
                region.span = self.mapView.region.span;
                BPBGenericAnnotation *ga = [[BPBGenericAnnotation alloc] initWithCoordinate:placemark.location.coordinate title:placemark.name subTitle:nil];
                [self.mapView setRegion:region animated:YES];
                [self.mapView addAnnotation:ga];
            }
        }
        
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

@end
