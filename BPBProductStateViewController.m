//
//  BPBProductStateViewController.m
//  Origins
//
//  Created by billy bray on 4/25/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBProductStateViewController.h"

@interface BPBProductStateViewController () <NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productBarcodeLabel;
@property (nonatomic) NSURLSession *session;
@property (nonatomic, copy) NSArray *barcode;
- (IBAction)back:(id)sender;

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
    // NSString *requestString = @"http://bookapi.bignerdranch.com/courses.json";
    NSMutableString *requestString = [[NSMutableString alloc] initWithString:@"http://www.outpan.com/api/get_product.php?barcode="];
    [requestString appendString:self.barCode];
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                     completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:0
                                                                                                       error:nil];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              self.productBarcodeLabel.text = jsonObject[@"barcode"];
                                              self.productNameLabel.text = jsonObject[@"name"];
                                              NSString *urlAddress = [jsonObject[@"images"] objectAtIndex:0];
                                              NSString *fixedAddress = [urlAddress stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                                              [self.productImageView setImage:[UIImage imageWithData:
                                                                             [NSData dataWithContentsOfURL:
                                                                              [NSURL URLWithString: fixedAddress]]]];
                                              NSLog(@"%@", fixedAddress);
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
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}
@end
