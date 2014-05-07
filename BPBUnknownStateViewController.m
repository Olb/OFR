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

@interface BPBUnknownStateViewController () < UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (nonatomic) NSMutableArray *productCollectionDisplayArray;
@property (weak, nonatomic) IBOutlet UIView *snapShotView;
@property (weak, nonatomic) IBOutlet UIView *snapShotTitleBarView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIView *productDescriptionView;

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
    
    // Snapshot view swipes
    // Swipe up gesture for Snapshot
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(snapShotSwipeUp:)];
    swipeUp.numberOfTouchesRequired = 1;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.snapShotTitleBarView addGestureRecognizer:swipeUp];
    
    // Swipe down gesture for Snapshot
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(snapShowSwipeDown:)];
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
    
    [self.imageCollectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestAlternative:(id)sender {
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

#pragma mark - Swiping
-(void)snapShotSwipeUp:(UIGestureRecognizer*)g
{
    // Swipe up pulls up origins snapshots
    CGRect snapShotRect = CGRectMake(self.snapShotView.frame.origin.x, self.snapShotView.frame.origin.y-290,self.snapShotView.frame.size.width , self.snapShotView.frame.size.height);
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

-(void)snapShowSwipeDown:(UIGestureRecognizer*)g
{
    // Swipe down lowers snapshots
    CGRect snapShotRect = CGRectMake(self.snapShotView.frame.origin.x, self.snapShotView.frame.origin.y+290,self.snapShotView.frame.size.width , self.snapShotView.frame.size.height);
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
