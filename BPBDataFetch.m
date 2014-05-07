//
//  BPBDataFetch.m
//  Origins
//
//  Created by billy bray on 4/29/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBDataFetch.h"
#import "BPBConstants.h"

// Google API Key
#define kGoogleAPIKey "AIzaSyDlFcGWWUhqrcinZfrUbWPr5zzf80mg-ic"

@interface BPBDataFetch () <CLLocationManagerDelegate,NSURLSessionDataDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@end

@implementation BPBDataFetch

+(instancetype)sharedFetcher
{
    static BPBDataFetch *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] init];
    });
    
    return sharedStore;
}

-(void)getStoreName
{
    // Check that location services are enabled by user
    if ([CLLocationManager locationServicesEnabled]) {
        CLLocationManager *mgr = [[CLLocationManager alloc] init];
        mgr.delegate = self;
        
        // Get the user's current location
        CLLocationCoordinate2D userCoordinate = mgr.location.coordinate;
        
        // Setup the 'Get' Request
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:self
                                            delegateQueue:nil];
        // First need to grab store info
        // Setup the request string parameters
        NSMutableString *builder = [[NSMutableString alloc] initWithString:@"location="];
        [builder appendString:[NSString stringWithFormat:@"%f", userCoordinate.latitude]];
        [builder appendString:@","];
        [builder appendString:[NSString stringWithFormat:@"%f", userCoordinate.longitude]];
        [builder appendString:@"&key="];
        [builder appendString:@kGoogleAPIKey];
        [builder appendString:@"&sensor=true"];
        [builder appendString:@"&types=establishment"];
        [builder appendString:@"&rankby=distance"];
        // Append the parameters to the request
        NSMutableString *requestString = [[NSMutableString alloc] initWithString:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?"];
        [requestString appendString:builder];
        
        NSURL *url = [NSURL URLWithString:requestString];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                         completionHandler:
                                          ^(NSData *data, NSURLResponse *response, NSError *error) {
                                              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:0
                                                                                                           error:nil];
                                              
                                              // Once done with request call 
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  // Get the first result
                                                  __weak NSString *storeNameResult = [[jsonObject[@"results"] objectAtIndex:0] valueForKey:@"name"];
                                                  [self.delegate setStoreName:storeNameResult];
                                                  [self.delegate setStoreLocation:userCoordinate];
                                                  NSLog(@"Store name from fetcher: %@", storeNameResult);
                                              });
                                          }];
        [dataTask resume];
    }
}

-(void)fetchProductInfo:(NSString*)barCode
{
    // First database to check - using temp outpan.com database
    NSMutableString *requestString = [[NSMutableString alloc] initWithString:@"http://www.outpan.com/api/get_product.php?barcode="];
    // Append the passed in barcode
    [requestString appendString:barCode];
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                     completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:0
                                                                                                       error:nil];
                                          // Once done with request tell the
                                          // delegate what the image and labels should be
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              NSString *urlAddress = [jsonObject[@"images"] objectAtIndex:0];
                                              NSString *fixedAddress = [urlAddress stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                                              
                                              UIImage *image = [UIImage imageWithData:
                                                                [NSData dataWithContentsOfURL:
                                                                 [NSURL URLWithString: fixedAddress]]];
                                              if (image == nil) {
                                                  image = [UIImage imageNamed:@"cups.png"];
                                              }
                                              [self.delegate setProductImpact:1 withName:jsonObject[@"name"] withImage:image withDescription:@"This is a description"];
                                          });
                                          
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




@end
