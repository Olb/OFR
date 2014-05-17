//
//  BPBAnnotationCalloutView.h
//  Origins
//
//  Created by billy bray on 5/12/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPBAnnotationCalloutView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *annotationCalloutImageView;
@property (weak, nonatomic) IBOutlet UILabel *annotationCalloutLabel;
@property (weak, nonatomic) IBOutlet UILabel *annotationShowAllPinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *annotationSeeStorePromotionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *annotationBuyOriginGoodsLabel;
@property (weak, nonatomic) IBOutlet UIButton *annotationShowAllPinsButton;
@property (weak, nonatomic) IBOutlet UIButton *annotationSeeStorePromotionsButton;
@property (weak, nonatomic) IBOutlet UIButton *annotationBuyOriginGoodsButton;
@property (weak, nonatomic) IBOutlet UIButton *annotationShowDetailsButton;


- (IBAction)showAddidtionalDetails:(id)sender;
- (IBAction)showAllPins:(id)sender;
- (IBAction)seeStorePromotions:(id)sender;
- (IBAction)buyOriginGoods:(id)sender;

@end
