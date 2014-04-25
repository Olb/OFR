//
//  BPBProductStateViewController.h
//  Origins
//
//  Created by billy bray on 4/25/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPBProductStateViewController : UIViewController

@property (nonatomic) NSString *barCode;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
