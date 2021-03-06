//
//  BPBProduct.h
//  Origins
//
//  Created by billy bray on 5/1/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPBProduct : NSObject


@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productBarcode;
@property (nonatomic, strong) UIImage *productImage;
@property (nonatomic) NSInteger impact;
@property (nonatomic, copy) NSString *productDescription;


-(void)newProduct:(NSString*)product withBarcode:(NSString*)barcode andImage:(UIImage*)image withImpact:(NSInteger)impact withDescription:(NSString*)desc;

@end
