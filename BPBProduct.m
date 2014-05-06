//
//  BPBProduct.m
//  Origins
//
//  Created by billy bray on 5/1/14.
//  Copyright (c) 2014 Spartan Systems. All rights reserved.
//

#import "BPBProduct.h"

@implementation BPBProduct

-(void)newProduct:(NSString*)product withBarcode:(NSString*)barcode andImage:(UIImage*)image withImpact:(NSInteger)impact withDescription:(NSString*)desc
{
    self.productName = product;
    self.productBarcode = barcode;
    self.productImage = image;
    self.impact = impact;
    self.productDescription = desc;
}


@end
