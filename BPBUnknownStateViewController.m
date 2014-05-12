//
//  BPBUnknownStateViewController.m
//  Origins
//
//  Created by billy bray on 5/7/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBUnknownStateViewController.h"
#import "BPBMainScreenViewController.h"
#import "BPBConstants.h"
#import "BPBOriginsPhotoCell.h"
#import "BPBProduct.h"
#import <Social/Social.h>

@interface BPBUnknownStateViewController () < UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (nonatomic) NSMutableArray *productCollectionDisplayArray;
@property (weak, nonatomic) IBOutlet UIView *snapShotView;
@property (weak, nonatomic) IBOutlet UIView *snapShotTitleBarView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIView *productDescriptionView;
@property BOOL snapShotIsUp;
@property (weak, nonatomic) IBOutlet UITextView *productDescriptionTextView;

@end

@implementation BPBUnknownStateViewController

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
    
    // Tap gesture for snapshot view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSimilarGoods:)];
    tap.numberOfTouchesRequired = 1;
    [self.snapShotTitleBarView addGestureRecognizer:tap];
    
    // Swipe down gesture for Snapshot
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDown.numberOfTouchesRequired = 1;
    [self.snapShotTitleBarView addGestureRecognizer:swipeDown];
    
    // For Collection view cells
    // Collection view
    UINib *cellNib = [UINib nibWithNibName:@"PhotoCell" bundle:nil];
    [self.imageCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"PhotoCell"];
    
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestAlternative:(id)sender {
    
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
        
        [twitterController setInitialText:[NSString stringWithFormat:@"@%@ Please stock Origin Made Alternatives", self.storeName]];
        [twitterController setCompletionHandler:completionHandler];
        [self.navigationController presentViewController:twitterController animated:YES completion:nil];
    }
    
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
    if (!self.snapShotIsUp) {
        return;
    }
    self.snapShotIsUp = NO;
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
    if (self.snapShotIsUp) {
        return;
    }
    self.snapShotIsUp = YES;
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

@end
