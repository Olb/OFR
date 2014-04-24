//
//  BPBLoginViewController.m
//  Origins
//
//  Created by billy bray on 4/23/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBLoginViewController.h"
#import "BPBMainScreenViewController.h"

@interface BPBLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation BPBLoginViewController

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View loading, appearing, disappearing
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Logging in
- (IBAction)login:(id)sender {
    BPBMainScreenViewController *mvc = [[BPBMainScreenViewController alloc] init];
    [self.navigationController presentViewController:mvc animated:YES completion:nil];
}

@end
