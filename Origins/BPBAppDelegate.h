//
//  BPBAppDelegate.h
//  Origins
//
//  Created by billy bray on 4/23/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPBLoginViewController.h"

@interface BPBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) BPBLoginViewController *rootViewController;

@end
