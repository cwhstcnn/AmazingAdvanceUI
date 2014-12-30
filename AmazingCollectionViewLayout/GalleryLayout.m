//
//  GalleryLayout.m
//  CollectionViewCustomLayoutTest
//
//  Created by goguhuan on 12/26/14.
//  Copyright (c) 2014 goguhuan. All rights reserved.
//

#import "GalleryLayout.h"

@interface GalleryLayout()

@property UIEdgeInsets marginInsets;

@end

@implementation GalleryLayout

- (instancetype)init
{
    self=[super init];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - Common Init
- (void)setUp
{
    self.marginInsets=UIEdgeInsetsMake(40, 60, 40, 60);
    
    CGFloat width=self.collectionView.bounds.size.width;
    CGFloat height=self.collectionView.bounds.size.height;
    if (width == 0 || width == 600 || width < height) {
        
        self.itemSize=CGSizeMake(768-self.marginInsets.left-self.marginInsets.right,1024-self.marginInsets.top-self.marginInsets.bottom);
        self.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing=self.marginInsets.left+self.marginInsets.right;
        self.sectionInset=self.marginInsets;
    }
    else {
        
        self.itemSize=CGSizeMake(1024-self.marginInsets.left-self.marginInsets.right,768-self.marginInsets.top-self.marginInsets.bottom);
        self.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing=self.marginInsets.left+self.marginInsets.right;
        self.sectionInset=self.marginInsets;
    }
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self setUp];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    NSIndexPath *firstVisibleIndexPath=[self visibleIndexPathFirst];
    
    UICollectionViewLayoutAttributes *firstVisibleAttributes=[self layoutAttributesForItemAtIndexPath:firstVisibleIndexPath];
    CGFloat offsetX=firstVisibleAttributes.frame.origin.x;
    
    CGPoint targetPoint=CGPointMake(offsetX-self.marginInsets.left, 0);
    return targetPoint;
}

#pragma mark - Private

- (NSIndexPath *)visibleIndexPathFirst
{
    NSArray *visibleIndexPaths=[self.collectionView indexPathsForVisibleItems];
    
    NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"row" ascending:YES];
    NSArray *sortedVisibleIndexPaths=[visibleIndexPaths sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSIndexPath *fisrtIndexPaht=[sortedVisibleIndexPaths objectAtIndex:0];
    return fisrtIndexPaht;
}

@end
