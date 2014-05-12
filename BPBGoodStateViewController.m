//
//  BPBGoodStateViewController.m
//  Origins
//
//  Created by billy bray on 5/7/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBGoodStateViewController.h"
#import "BPBOriginsPhotoCell.h"
#import "BPBProduct.h"
//#import "BPBFaceBookView.h"
#import <Social/Social.h>

@interface BPBGoodStateViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *productDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIView *originSlideTagView;
@property (weak, nonatomic) IBOutlet UIView *originSlideReplaceView;
@property (weak, nonatomic) IBOutlet UICollectionView *productImageCollectionView;
@property (nonatomic) NSMutableArray *productCollectionDisplayArray;
@property (weak, nonatomic) IBOutlet UIView *similarGoodsView;
@property (weak, nonatomic) IBOutlet UIView *similarGoodsTitleView;
@property BOOL snapshotIsUp;
@property (weak, nonatomic) IBOutlet UIView *snapShotView;



@end

@implementation BPBGoodStateViewController

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
    
    // For Collection view cells
    // Collection view
    UINib *cellNib = [UINib nibWithNibName:@"PhotoCell" bundle:nil];
    [self.productImageCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"PhotoCell"];
    
    if (!self.productCollectionDisplayArray) {
        self.productCollectionDisplayArray = [[NSMutableArray alloc] init];
    }
    [self.productCollectionDisplayArray removeAllObjects];
    
    // Setup some test products
    BPBProduct *one = [[BPBProduct alloc] init];
    one.productName = @"Wooden Stand";
    one.productImage = [UIImage imageNamed:@"wood.png"];
    
    BPBProduct *two = [[BPBProduct alloc] init];
    two.productName = @"Handcrafted Chair";
    two.productImage = [UIImage imageNamed:@"chair.png"];
    
    BPBProduct *three = [[BPBProduct alloc] init];
    three.productName = @"Custom Cups";
    three.productImage = [UIImage imageNamed:@"cups.png"];
    
    BPBProduct *four = [[BPBProduct alloc] init];
    four.productName = @"Handmade Office Tools";
    four.productImage = [UIImage imageNamed:@"office_tools.png"];
    
    BPBProduct *five = [[BPBProduct alloc] init];
    five.productName = @"Wallet";
    five.productImage = [UIImage imageNamed:@"wallet.png"];
    
    // Array to hold products showing some test products if none yet added
    // Need to pull from server so this shouldn't happen
    [self.productCollectionDisplayArray addObject:one];
    [self.productCollectionDisplayArray addObject:two];
    [self.productCollectionDisplayArray addObject:three];
    [self.productCollectionDisplayArray addObject:four];
    [self.productCollectionDisplayArray addObject:five];
    
    // Tap gesture for snapshot view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSimilarGoods:)];
    tap.numberOfTouchesRequired = 1;
    [self.similarGoodsTitleView addGestureRecognizer:tap];
    
    // Swipe down gesture for Snapshot
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDown.numberOfTouchesRequired = 1;
    [self.similarGoodsTitleView addGestureRecognizer:swipeDown];
    
    
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
    
    [self replaceFirstTagView];
}

-(void)replaceFirstTagView
{
    // Remove the first view with tagging
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.originSlideTagView setHidden:YES];
                    }
                    completion:nil];
    
    // Add new view for thank you
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.originSlideReplaceView setHidden:NO];
                    }
                    completion:^(BOOL finished){
                        self.snapShotView.hidden = NO;
                    }];
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    // NSString *searchTerm = nil;
    return self.productCollectionDisplayArray.count;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BPBOriginsPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.productName.text = ((BPBProduct*)[self.productCollectionDisplayArray objectAtIndex:indexPath.row]).productName;
    cell.imageView.image = ((BPBProduct*)[self.productCollectionDisplayArray objectAtIndex:indexPath.row]).productImage;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 30, 10, 30);
}

#pragma mark - Gestures
-(void)swipeDown:(UIGestureRecognizer*)g
{
    if (!self.snapshotIsUp) {
        return;
    }
    self.snapshotIsUp = NO;
    // Swipe down lowers snapshots
    CGRect snapShotRect = CGRectMake(self.snapShotView.frame.origin.x, self.snapShotView.frame.origin.y+275,self.snapShotView.frame.size.width , self.snapShotView.frame.size.height);
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self.snapShotView setFrame:snapShotRect];
                     }
                     completion:^(BOOL finished){
                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
                     }];
}

-(void)tapSimilarGoods:(UITapGestureRecognizer*)t
{
    if (self.snapshotIsUp) {
        return;
    }
    self.snapshotIsUp = YES;
    // Show the snapshot of similar goods
    CGRect snapShotRect = CGRectMake(self.snapShotView.frame.origin.x, self.snapShotView.frame.origin.y-275,self.snapShotView.frame.size.width , self.snapShotView.frame.size.height);
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self.snapShotView setFrame:snapShotRect];
                     }
                     completion:^(BOOL finished){
                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
                     }];
}

- (IBAction)shareItemButton:(id)sender
{
//    UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
//    dimView.backgroundColor = [UIColor blackColor];
//    dimView.alpha = 0.5f;
//    dimView.tag = 1111;
//    dimView.userInteractionEnabled = NO;
//    [self.view addSubview:dimView];
//    
//    // Add the FaceBook View
//    BPBFaceBookView *fbv = [BPBFaceBookView faceBookView];
//    CGRect fbRect = CGRectMake(fbv.frame.origin.x+5, fbv.frame.origin.y+90, fbv.frame.size.width-10, fbv.frame.size.height);
//    fbv.frame = fbRect;
//    fbv.fbproductImageView.image = self.productImageView.image;
//    fbv.fbUserImageView.image = self.productImageView.image;
//    fbv.fbProductName.text = self.productName;
//    fbv.fbUserName.text = @"Sam Jones";
//    fbv.delegate = self;
//    fbv.tag = 100;
//    fbv.alpha = 0.0f;
//    [self.view addSubview:fbv];
//    [UIView animateWithDuration:0.25f
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         fbv.alpha = 1.0f;
//                     }
//                     completion:^(BOOL finished){
//                         [fbv.fbPostTextField becomeFirstResponder];
//                     }];
    
    SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
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
        
        [fbController setInitialText:[NSString stringWithFormat:@"%@\n%@", self.productName, @"Origin\n\n"]];
        [fbController addImage:self.productImage];
        [fbController setCompletionHandler:completionHandler];
        [self.navigationController presentViewController:fbController animated:YES completion:nil];
    }
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    return YES;
//}
//
//-(void)cancelPost
//{
//    for (UIView *v in [self.view subviews]) {
//        if (v.tag == 100 || v.tag == 1111) {
//            [v removeFromSuperview];
//        }
//    }
//}
//
//-(void)postToFaceBook
//{
//    
//}

@end
