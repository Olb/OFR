//
//  BPBProductStateViewController.m
//  Origins
//
//  Created by billy bray on 4/25/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBProductStateViewController.h"
#import "BPBMainScreenViewController.h"
#import "BPBConstants.h"




@interface BPBProductStateViewController ()

@property (weak, nonatomic) IBOutlet UIView *textDividerLineView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIView *productDescriptionView;
@property (weak, nonatomic) IBOutlet UIButton *tagButtonView;
@property (weak, nonatomic) IBOutlet UITextView *productDescriptionTextView;
@property (nonatomic) NSURLSession *session;

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
    CGPathAddLineToPoint(path, NULL, self.originsVerifiedView.bounds.size.width/2-10, 0.0f);
    CGPathAddLineToPoint(path, NULL, self.originsVerifiedView.bounds.size.width/2, -10.0f);
    CGPathAddLineToPoint(path, NULL, self.originsVerifiedView.bounds.size.width/2+10, 0.0f);
    CGPathAddLineToPoint(path, NULL, self.originsVerifiedView.bounds.size.width/2-10, 0.0f);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:path];
    [shapeLayer setFillColor:[[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor]];
    [shapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    [[self.originsVerifiedView layer] addSublayer:shapeLayer];
    
    self.storeNameLabel.text = self.storeName;
    self.productImageView.image = self.productImage;
    self.productNameLabel.text = self.productName;
    self.productDescriptionTextView.text = self.productDescription;
    
//    if (self.impact == GoodImpact) {
//        self.tagButtonView.imageView.image = [UIImage imageNamed:@"tag_this_item.png"];
//    } else if (self.impact == HarmfulImpact) {
//        self.tagButtonView.imageView.image = [UIImage imageNamed:@"flag_this_item.png"];
//        self.productDescriptionView.backgroundColor = [UIColor colorWithRed: 255/255.0 green:36/255.0 blue:0/255.0 alpha:1];
//        self.productDescriptionTextView.textColor = [UIColor whiteColor];
//
//        self.textDividerLineView.hidden = YES;
//    }
    // Swipe right gesture for scanner view
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scannerSwipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.swipeReturnView addGestureRecognizer:swipeRight];
}

-(void)scannerSwipeRight:(UIGestureRecognizer*)g
{
    [self.navigationController popToViewController:self.mvc animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tagItem:(id)sender
{
    [self.mvc addStore:self.storeName withImpact:self.impact andProduct:self.productBarcode andLocation:self.storeLocation];
    // Add the product
    [self.mvc addProduct:self.productName withImpact:self.impact andProductBarCode:self.productBarcode andImage:self.productImage withDescription:self.productDescription];
    // Return to main view controller
    [self.navigationController popToViewController:self.mvc animated:YES];
}
                                                         
- (IBAction)flagThisItem:(id)sender
{
    [self.mvc addStore:self.storeName withImpact:self.impact andProduct:self.productBarcode andLocation:self.storeLocation];
    // Add the product
    [self.mvc addProduct:self.productName withImpact:self.impact andProductBarCode:self.productBarcode andImage:self.productImage withDescription:self.productDescription];
    // Return to main view controller
    [self.navigationController popToViewController:self.mvc animated:YES];
}

@end
