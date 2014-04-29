//
//  BPBDataFetch.m
//  Origins
//
//  Created by billy bray on 4/29/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBDataFetch.h"
#import <MapKit/MapKit.h>

// Google API Key
#define API_KEY "AIzaSyDlFcGWWUhqrcinZfrUbWPr5zzf80mg-ic"

@interface BPBDataFetch () <CLLocationManagerDelegate,NSURLSessionDataDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@end

@implementation BPBDataFetch

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
        [builder appendString:@API_KEY];
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
                                              });
                                          }];
        [dataTask resume];
    }
}

@end
