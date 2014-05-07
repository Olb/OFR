//
//  BPBProductStateViewController.m
//  Origins
//
//  Created by billy bray on 5/7/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBProductStateViewController.h"

@interface BPBProductStateViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *productDescriptionTextView;

@end

@implementation BPBProductStateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Edge on directions label view
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,0.0,0.0);
    CGPathAddLineToPoint(path, NULL, self.originsTitleDrawingView.bounds.size.width/2-10, 0.0f);
    CGPathAddLineToPoint(path, NULL, self.originsTitleDrawingView.bounds.size.width/2, -10.0f);
    CGPathAddLineToPoint(path, NULL, self.originsTitleDrawingView.bounds.size.width/2+10, 0.0f);
    CGPathAddLineToPoint(path, NULL, self.originsTitleDrawingView.bounds.size.width/2-10, 0.0f);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:path];
    [shapeLayer setFillColor:[[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor]];
    [shapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    [[self.originsTitleDrawingView layer] addSublayer:shapeLayer];
    
    self.storeNameLabel.text = self.storeName;
    self.productImageView.image = self.productImage;
    self.productNameLabel.text = self.productName;
    self.productDescriptionTextView.text = self.productDescription;
    
    // Swipe right gesture for scanner view
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scannerSwipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.swipeReturnView addGestureRecognizer:swipeRight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scannerSwipeRight:(UIGestureRecognizer*)g
{
    [self.navigationController popToViewController:self.mvc animated:YES];
    
}

@end
