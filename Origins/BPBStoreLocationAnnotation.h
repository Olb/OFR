//
//  BPBStoreLocationAnnotation.h
//  Origins
//
//  Created by billy bray on 4/24/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

// Used for setting unique reuse identifiers
#define REUSABLE_PIN_RED @"Red"
#define RESUABLE_PIN_GREEN @"Green"

@interface BPBStoreLocationAnnotation : NSObject <MKAnnotation>

@property (nonatomic,readonly, unsafe_unretained) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;
@property (nonatomic, unsafe_unretained) MKPinAnnotationColor pinColor;

-(instancetype) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *) st withImpact:(NSInteger)impact;

+(NSString *) reusableIdentifierForPinColor:(MKPinAnnotationColor)color;

@end
