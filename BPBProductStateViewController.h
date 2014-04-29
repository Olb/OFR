//
//  BPBProductStateViewController.h
//  Origins
//
//  Created by billy bray on 4/25/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPBMainScreenViewController.h"

@interface BPBProductStateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *originsVerifiedView;

@property (nonatomic, strong) NSString *storeName;
@property (nonatomic) NSString *barCode;
@property (nonatomic, weak) BPBMainScreenViewController *mvc;

@end
