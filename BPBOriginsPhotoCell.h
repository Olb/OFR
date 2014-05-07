//
//  BPBOriginsPhotoCell.h
//  Origins
//
//  Created by billy bray on 4/30/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//
// Used for Collection View images

#import <UIKit/UIKit.h>

@interface BPBOriginsPhotoCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *productName;


@end
