//
//  BPBMainScreenViewController.m
//  Origins
//
//  Created by billy bray on 4/23/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBMainScreenViewController.h"

#define ONE_MILE 1606.344
@interface BPBMainScreenViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) MKPlacemark *placemark;

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
    
    // Create a geocoder and save it for later.
    self.geocoder = [[CLGeocoder alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Mapping
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"Called");
    // Center the map the first time we get a real location change.
    static dispatch_once_t centerMapFirstTime;
    
    if ((userLocation.coordinate.latitude != 0.0) && (userLocation.coordinate.longitude != 0.0)) {
        dispatch_once(&centerMapFirstTime, ^{
            [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
            NSLog(@"%f, %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        });
    }
    
    // Lookup the information for the current location of the user.
    [self.geocoder reverseGeocodeLocation:self.mapView.userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ((placemarks != nil) && (placemarks.count > 0)) {
            // If the placemark is not nil then we have at least one placemark. Typically there will only be one.
            _placemark = [placemarks objectAtIndex:0];
            
            // Get region within 1 mile of user's current location
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([userLocation coordinate] ,ONE_MILE,ONE_MILE);
            
            // Zoom to user
            [self.mapView setRegion:region animated:YES];

        }
        else {
            // Handle the nil case if necessary.
        }
    }];
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    // TODO
    
}


@end
