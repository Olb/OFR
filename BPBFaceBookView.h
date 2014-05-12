//
//  BPBFaceBookView.h
//  Origins
//
//  Created by billy bray on 5/8/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BPBFaceBookViewDelegate <NSObject>
-(void)cancelPost;
-(void)postToFaceBook;
@end

@interface BPBFaceBookView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *fbUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *fbUserName;
@property (weak, nonatomic) IBOutlet UILabel *fbProductName;
@property (weak, nonatomic) IBOutlet UIImageView *fbproductImageView;
@property (nonatomic, weak) id <BPBFaceBookViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *postBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *fbPostTextField;
+ (id)faceBookView;
-(IBAction)cancel:(id)sender;
-(IBAction)postToFaceBook:(id)sender;

@end
