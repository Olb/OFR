//
//  BPBAnnotationCalloutView.m
//  Origins
//
//  Created by billy bray on 5/12/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBAnnotationCalloutView.h"

@implementation BPBAnnotationCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Down arrow on directions label view
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,0.0,0.0);
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width/2-10, self.bounds.size.height);
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width/2, self.bounds.size.height+ 10.0f);
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width/2+10, self.bounds.size.height);
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width/2-10, self.bounds.size.height);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:path];
    [shapeLayer setFillColor:[[UIColor colorWithWhite:0.0f alpha:0.9] CGColor]];
    [shapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    [[self layer] addSublayer:shapeLayer];
    
    
}


@end
