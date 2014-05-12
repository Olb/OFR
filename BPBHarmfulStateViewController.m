//
//  BPBHarmfulStateViewController.m
//  Origins
//
//  Created by billy bray on 5/7/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBHarmfulStateViewController.h"
#import <Social/Social.h>

@interface BPBHarmfulStateViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *productDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIView *originFirstAlertView;
@property (weak, nonatomic) IBOutlet UIView *originShareAlertView;

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
    // Present option to share
    [self replaceFirstTagView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareAlertButton:(id)sender
{
    
    SLComposeViewController *twitterController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [twitterController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                    [self.navigationController popToViewController:self.mvc animated:YES];
                    
                }
                    break;
            }};
        
        [twitterController setInitialText:[NSString stringWithFormat:@"I flagged an Origin Confirmed envirnonmentally harmful product @%@ Please stock Origin Made Alternatives.", self.storeName]];
        [twitterController setCompletionHandler:completionHandler];
        [self.navigationController presentViewController:twitterController animated:YES completion:nil];
    }
    
}

-(void)replaceFirstTagView
{
    // Remove the first view with tagging
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.originFirstAlertView setHidden:YES];
                    }
                    completion:nil];
    
    // Add new view for thank you
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.originShareAlertView setHidden:NO];
                    }
                    completion:^(BOOL finished){
                        // TODO
                    }];
}

@end
