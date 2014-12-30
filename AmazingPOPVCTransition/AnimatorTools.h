//
//  AnimatorTools.h
//  AmazingCollectionViewTest
//
//  Created by goguhuan on 12/21/14.
//  Copyright (c) 2014 goguhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, DepartRectType)
{
    DepartRectUp=0,
    DepartRectLeft,
    DepartRectBottom,
    DepartRectRight
};

@interface AnimatorTools : NSObject

+ (UIImageView *)snapshotFromView:(UIView *)fromView;

+ (UIImageView *)cropFromImageView:(UIImageView *)fromImageView fromRect:(CGRect)fromRect;

+ (CGRect)rectFromRect:(CGRect)fromRect withDepartRect:(CGRect)departRect withType:(DepartRectType)departType;

@end
