//
//  BPBDataFetch.h
//  Origins
//
//  Created by billy bray on 4/29/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BPBDataFetchDelegate <NSObject>
- (void)setStoreName:(NSString*)storeName;
@end

@interface BPBDataFetch : NSObject

@property (nonatomic, weak) id <BPBDataFetchDelegate> delegate;

+(instancetype)sharedFetcher;
-(void)getStoreName;

@end
