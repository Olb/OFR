//
//  BPBMainScreenViewController.h
//  Origins
//
//  Created by billy bray on 4/23/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BPBMainScreenViewController : UIViewController

-(void)addStore:(NSString*)store withImpact:(NSInteger)impact andProduct:(NSString*)productBarcode andLocation:(CLLocationCoordinate2D)coord;
-(void)addProduct:(NSString*)product withImpact:(NSInteger)impact andProductBarCode:(NSString*)productBarcode andImage:(UIImage*)image withDescription:(NSString*)description;

@end
