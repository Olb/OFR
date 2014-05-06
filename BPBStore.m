//
//  BPBStore.m
//  Origins
//
//  Created by billy bray on 5/1/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBStore.h"

@implementation BPBStore

-(void)makeStore:(NSString*)store withImpact:(NSInteger)impact andProduct:(NSString*)productBarcode andLocation:(CLLocationCoordinate2D)coord
{
    self.storeName = store;
    self.impact = impact;
    if (!self.productBarcodes) {
        self.productBarcodes = [[NSMutableArray alloc] init];
    }
    [self.productBarcodes addObject:productBarcode];
    self.storeLocation = coord;
}

@end
