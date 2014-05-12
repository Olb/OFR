//
//  BPBFaceBookView.m
//  Origins
//
//  Created by billy bray on 5/8/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBFaceBookView.h"
#import <QuartzCore/QuartzCore.h>

@implementation BPBFaceBookView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Blank
    }
    return self;
}

+ (id)faceBookView
{
    BPBFaceBookView *fbView = [[[NSBundle mainBundle] loadNibNamed:@"BPBFaceBookView" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([fbView isKindOfClass:[BPBFaceBookView class]]) {
        fbView.postBackgroundView.layer.borderWidth = 2.0f;
        fbView.postBackgroundView.layer.borderColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor;
        return fbView;
    } else {
        return nil;
    }
}

-(IBAction)cancel:(id)sender
{
    [self.delegate cancelPost];
}

-(IBAction)postToFaceBook:(id)sender
{
    [self.delegate postToFaceBook];
}

@end
