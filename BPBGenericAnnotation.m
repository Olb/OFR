//
//  BPBGenericAnnotation.m
//  Origins
//
//  Created by billy bray on 5/16/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBGenericAnnotation.h"

@implementation BPBGenericAnnotation 

-(instancetype) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *) st
{
    if (self = [super init]) {
        _coordinate = c;
        _title = t;
        _subTitle = st;
    }
    
    return self;
}

@end
