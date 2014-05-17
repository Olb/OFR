//
//  BPBSlideView.m
//  Origins
//
//  Created by billy bray on 5/16/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBSlideView.h"

@implementation BPBSlideView

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
    CGFloat radius = 66.0;
	CGMutablePathRef path = CGPathCreateMutable();
	UIColor *color;
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Determine size
    rect = self.bounds;
    
    // Create path for callout bubble
    CGPathMoveToPoint(path, NULL, rect.origin.x+rect.size.width, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y+rect.size.height);

//	CGPathAddArc(path, NULL, rect.origin.x, rect.origin.y,
//				 radius, M_PI, M_PI / 2, 1);

	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width,
				 (rect.origin.y + rect.size.height)/2, radius, M_PI / 2, 0.0f, NO);
	//CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y);

	CGPathCloseSubpath(path);
    
    //Fill Callout Bubble & Add Shadow
	color = [[UIColor blackColor] colorWithAlphaComponent:.7];
	[color setFill];
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
    
	//Cleanup
	CGPathRelease(path);
}


@end
