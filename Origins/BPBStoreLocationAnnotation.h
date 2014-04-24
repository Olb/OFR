//
//  BPBStoreLocationAnnotation.h
//  Origins
//
//  Created by billy bray on 4/24/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BPBStoreLocationAnnotation : NSObject

@property (nonatomic, strong) NSString *storeName;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSInteger impact;

@end
