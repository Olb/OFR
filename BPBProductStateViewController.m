//
//  BPBProductStateViewController.m
//  Origins
//
//  Created by billy bray on 4/25/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBProductStateViewController.h"
#import "BPBMainScreenViewController.h"
#import "BPBConstants.h"

@interface BPBProductStateViewController () <NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;

@property (nonatomic) NSURLSession *session;
@property (nonatomic, copy) NSArray *barcode;

@end

@implementation BPBProductStateViewController

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
    
    // Edge on directions label view
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,0.0,0.0);
    CGPathAddLineToPoint(path, NULL, self.originsVerifiedView.bounds.size.width/2-10, 0.0f);
    CGPathAddLineToPoint(path, NULL, self.originsVerifiedView.bounds.size.width/2, -10.0f);
    CGPathAddLineToPoint(path, NULL, self.originsVerifiedView.bounds.size.width/2+10, 0.0f);
    CGPathAddLineToPoint(path, NULL, self.originsVerifiedView.bounds.size.width/2-10, 0.0f);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:path];
    [shapeLayer setFillColor:[[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor]];
    [shapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    [[self.originsVerifiedView layer] addSublayer:shapeLayer];
    
    self.storeNameLabel.text = self.storeName;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config
                                             delegate:self
                                        delegateQueue:nil];
    [self fetchFeed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchFeed
{
    // First database to check
    NSMutableString *requestString = [[NSMutableString alloc] initWithString:@"http://www.outpan.com/api/get_product.php?barcode="];
    // Append the passed in barcode
    [requestString appendString:self.barCode];
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                     completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:0
                                                                                                       error:nil];
                                          // Once done with request set labels and image
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                              self.productNameLabel.text = jsonObject[@"name"];
                                              NSString *urlAddress = [jsonObject[@"images"] objectAtIndex:0];
                                              NSString *fixedAddress = [urlAddress stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                                              [self.productImageView setImage:[UIImage imageWithData:
                                                                             [NSData dataWithContentsOfURL:
                                                                              [NSURL URLWithString: fixedAddress]]]];
                                              [self.view setNeedsDisplay];
                                              
                                              
                                          });
                                          
                                          NSLog(@"%@", jsonObject);
                                      }];
    [dataTask resume];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
//    NSURLCredential *cred = [NSURLCredential credentialWithUser:@"BigNerdRanch"
//                                                       password:@"AchieveNerdvana"
//                                                    persistence:NSURLCredentialPersistenceForSession];
//    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

//-(void)loadWebImage:(NSString*)url
//{
//    NSString *urlAddress = url;
//    NSString *fixedAddress = [urlAddress stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//    NSURL *imageUrl = [NSURL URLWithString:fixedAddress];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:imageUrl];
//
//    [self.imageWebView loadRequest:requestObj];
//    
//}

                                                         

- (IBAction)back:(id)sender {
//    [self.presentingViewController dismissViewControllerAnimated:YES
//                                                      completion:self.dismissBlock];
   // [self.navigationController presentViewController:self.mvc animated:YES completion:nil];
    
    //[self.mvc getStoreNameAndCoordinateForImpact:HarmfulImpact];

    [self.navigationController popToViewController:self.mvc animated:YES];
    
}
@end
