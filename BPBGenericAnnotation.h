//
//  BPBGenericAnnotation.h
//  Origins
//
//  Created by billy bray on 5/16/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface BPBGenericAnnotation : NSObject <MKAnnotation>

@property (nonatomic,readonly, unsafe_unretained) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;

-(instancetype) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *) st;

@end
