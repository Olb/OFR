//
//  BPBDataFetch.h
//  Origins
//
//  Created by billy bray on 4/29/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol BPBDataFetchDelegate <NSObject>
-(void)setStoreName:(NSString*)storeName;
-(void)setProductImpact:(NSInteger)impact withName:(NSString*)name withImage:(UIImage*)image withDescirption:(NSString*)description;
-(void)setStoreLocation:(CLLocationCoordinate2D)coord;
@end

@interface BPBDataFetch : NSObject

@property (nonatomic, weak) id <BPBDataFetchDelegate> delegate;

+(instancetype)sharedFetcher;
-(void)getStoreName;
-(void)fetchProductInfo:(NSString*)barCode;

@end
