//
//  BPBHarmfulStateViewController.m
//  Origins
//
//  Created by billy bray on 5/7/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBHarmfulStateViewController.h"

@interface BPBHarmfulStateViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *productDescriptionTextView;

@end

@implementation BPBHarmfulStateViewController

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
    
    self.storeNameLabel.text = self.storeName;
    self.productImageView.image = self.productImage;
    self.productNameLabel.text = self.productName;
    self.productDescriptionTextView.text = self.productDescription;

}

-(void)scannerSwipeRight:(UIGestureRecognizer*)g
{
    [self.navigationController popToViewController:self.mvc animated:YES];
    
}

- (IBAction)flagItem:(id)sender
{
    [self.mvc addStore:self.storeName withImpact:self.impact andProduct:self.productBarcode andLocation:self.storeLocation];
    // Add the product
    [self.mvc addProduct:self.productName withImpact:self.impact andProductBarCode:self.productBarcode andImage:self.productImage withDescription:self.productDescription];
    // Return to main view controller
    [self.navigationController popToViewController:self.mvc animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
