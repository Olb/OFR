//
//  BPBProductStateViewController.h
//  Origins
//
//  Created by billy bray on 4/25/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPBMainScreenViewController.h"
#import <MapKit/MapKit.h>

@interface BPBProductStateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *originsVerifiedView;
@property (weak, nonatomic) IBOutlet UIView *swipeReturnView;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, weak) BPBMainScreenViewController *mvc;
@property (nonatomic, copy) NSString *productDescription;
@property (nonatomic) NSInteger impact;
@property (nonatomic, strong) UIImage *productImage;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic) CLLocationCoordinate2D storeLocation;
@property (nonatomic, copy) NSString *productBarcode;

@end
