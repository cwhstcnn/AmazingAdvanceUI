//
//  AnimatorTools.m
//  AmazingCollectionViewTest
//
//  Created by goguhuan on 12/21/14.
//  Copyright (c) 2014 goguhuan. All rights reserved.
//

#import "AnimatorTools.h"

@implementation AnimatorTools

+ (UIImageView *)snapshotFromView:(UIView *)fromView
{
    UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, fromView.opaque, [UIScreen mainScreen].scale);
    [fromView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [[UIImageView alloc] initWithImage:snapshotImage];
}

+ (UIImageView *)cropFromImageView:(UIImageView *)fromImageView fromRect:(CGRect)fromRect
{
    CGImageRef fromImageRef=fromImageView.image.CGImage;
    if (fromImageView.image.scale > 1.0f) {
        fromRect = CGRectMake(fromRect.origin.x * fromImageView.image.scale,
                              fromRect.origin.y * fromImageView.image.scale,
                              fromRect.size.width * fromImageView.image.scale,
                              fromRect.size.height * fromImageView.image.scale);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect(fromImageRef, fromRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:fromImageView.image.scale orientation:fromImageView.image.imageOrientation];
    CGImageRelease(imageRef);
    return [[UIImageView alloc] initWithImage:result];
}

+ (CGRect)rectFromRect:(CGRect)fromRect withDepartRect:(CGRect)departRect withType:(DepartRectType)departType
{
    CGRect resultRect;
    switch (departType) {
        case DepartRectUp:
        {
            resultRect=CGRectMake(fromRect.origin.x, fromRect.origin.y, fromRect.size.width, departRect.origin.y-fromRect.origin.y);
        }
            break;
        case DepartRectLeft:
        {
            resultRect=CGRectMake(fromRect.origin.x,departRect.origin.y,departRect.origin.x-fromRect.origin.x,departRect.size.height);
        }
            break;
        case DepartRectBottom:
        {
            resultRect=CGRectMake(fromRect.origin.x,departRect.origin.y+departRect.size.height,fromRect.size.width,fromRect.size.height-departRect.size.height-departRect.origin.y+fromRect.origin.y);
        }
            break;
        case DepartRectRight:
        {
            resultRect=CGRectMake(departRect.origin.x+departRect.size.width,departRect.origin.y,fromRect.size.width-departRect.size.width-departRect.origin.x+fromRect.origin.x,departRect.size.height);
        }
            break;
            
        default:
            break;
    }
    return resultRect;
}

@end
