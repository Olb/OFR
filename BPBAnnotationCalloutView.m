//
//  BPBAnnotationCalloutView.m
//  Origins
//
//  Created by billy bray on 5/12/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBAnnotationCalloutView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>


@interface BPBAnnotationCalloutView ()

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation BPBAnnotationCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor clearColor];

    // Down arrow on directions label view
    CGMutablePathRef arrowPath = CGPathCreateMutable();
    CGPathMoveToPoint(arrowPath,NULL,0.0,0.0);
    CGPathAddLineToPoint(arrowPath, NULL, self.bounds.size.width/2-10, self.bounds.size.height);
    CGPathAddLineToPoint(arrowPath, NULL, self.bounds.size.width/2, self.bounds.size.height+ 10.0f);
    CGPathAddLineToPoint(arrowPath, NULL, self.bounds.size.width/2+10, self.bounds.size.height);
    CGPathAddLineToPoint(arrowPath, NULL, self.bounds.size.width/2-10, self.bounds.size.height);
    
    self.shapeLayer = [CAShapeLayer layer];
    [self.shapeLayer setPath:arrowPath];
    [self.shapeLayer setFillColor:[[[UIColor blackColor] colorWithAlphaComponent:0.7] CGColor]];
    [self.shapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [self.shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    [[self layer] addSublayer:self.shapeLayer];
    

    
	CGFloat radius = 6.0;
	CGMutablePathRef path = CGPathCreateMutable();
	UIColor *color;
	CGContextRef context = UIGraphicsGetCurrentContext();

    // Determine size
    rect = self.bounds;
    
    // Create path for callout bubble
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius,
				 radius, M_PI, M_PI / 2, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, // was - 15
						 rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius,
						 rect.origin.y + rect.size.height);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius,
				 rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius,
				 radius, 0.0f, -M_PI / 2, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius,
				 -M_PI / 2, M_PI, 1);
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
    CGPathRelease(arrowPath);
}

- (IBAction)showAddidtionalDetails:(id)sender
{
    NSLog(@"Callout button pressed");
    [self resizeSelf];
}

-(void)resizeSelf
{
    [self.shapeLayer removeFromSuperlayer];

    CGRect newFrame = self.frame;

    //self.backgroundColor = [UIColor clearColor];
    newFrame.origin.y = newFrame.origin.y-114;
    newFrame.size.height = newFrame.size.height + 114;

    [self setFrame:newFrame];
    [self showDetailsViews:NO];
    [self.annotationShowDetailsButton removeTarget:self action:@selector(showAddidtionalDetails:) forControlEvents:UIControlEventTouchUpInside];
    [self.annotationShowDetailsButton addTarget:self action:@selector(hideAdditionalDetails:) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsDisplay];
}

-(void)showDetailsViews:(BOOL)state
{
    self.annotationBuyOriginGoodsButton.hidden = state;
    self.annotationBuyOriginGoodsLabel.hidden = state;
    self.annotationShowAllPinsButton.hidden = state;
    self.annotationShowAllPinsLabel.hidden = state;
    self.annotationSeeStorePromotionsButton.hidden = state;
    self.annotationSeeStorePromotionsLabel.hidden = state;
}

-(void)hideAdditionalDetails:(id)sender
{
    [self.shapeLayer removeFromSuperlayer];
    
    CGRect newFrame = self.frame;
    //self.backgroundColor = [UIColor clearColor];
    newFrame.origin.y = newFrame.origin.y+114;
    newFrame.size.height = newFrame.size.height - 114;
    
    [self setFrame:newFrame];
    [self showDetailsViews:YES];
    [self.annotationShowDetailsButton removeTarget:self action:@selector(hideAdditionalDetails:) forControlEvents:UIControlEventTouchUpInside];
    [self.annotationShowDetailsButton addTarget:self action:@selector(showAddidtionalDetails:) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsDisplay];
}

- (IBAction)showAllPins:(id)sender
{
    NSLog(@"Show all pins");
}

- (IBAction)seeStorePromotions:(id)sender
{
    NSLog(@"See store promotions");
}

- (IBAction)buyOriginGoods:(id)sender
{
    NSLog(@"Buy Origin goods");
}

@end
