//
//  BPBStoreLocationAnnotation.m
//  Origins
//
//  Created by billy bray on 4/24/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBStoreLocationAnnotation.h"
#import "BPBConstants.h"

@interface BPBStoreLocationAnnotation ()



@end

@implementation BPBStoreLocationAnnotation

+(NSString *) reusableIdentifierForPinColor:(MKPinAnnotationColor)color
{
    NSString *result = nil;
    
    switch (color) {
        case MKPinAnnotationColorGreen:
            result = RESUABLE_PIN_GREEN;
            break;
        case MKPinAnnotationColorRed:
            result = REUSABLE_PIN_RED;
            break;
        default:
            result = nil;
    }
    
    return result;
}

-(instancetype) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *) st withImpact:(NSInteger)impact
{
    self = [super init];
    if (self) {
        _title = t;
        _coordinate = c;
        _subTitle = st;
        switch (impact) {
            case HarmfulImpact:
                _pinColor = MKPinAnnotationColorRed;
                break;
            case GoodImpact:
                _pinColor = MKPinAnnotationColorGreen;
                break;
        }
    }
    
    return self;
}


@end
