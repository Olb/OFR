//
//  BPBStore.h
//  Origins
//
//  Created by billy bray on 5/1/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BPBStore : NSObject

@property (nonatomic, copy) NSString *storeName;
@property (nonatomic) NSInteger impact;
@property (nonatomic) NSMutableArray *productBarcodes;
@property (nonatomic) CLLocationCoordinate2D storeLocation;

-(void)makeStore:(NSString*)store withImpact:(NSInteger)impact andProduct:(NSString*)productBarcode andLocation:(CLLocationCoordinate2D)coord;

@end
