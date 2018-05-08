//
//  XCCollectionViewLayout.m
//  广告栏collectionview
//
//  Created by 刘小椿 on 16/10/9.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import "XCCollectionViewLayout.h"

@implementation XCCollectionViewLayout

- (instancetype)init
{
    if (self = [super init]) {//自定义page大小
        self.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 60, 200);
        self.minimumLineSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);//item居中
    }
    return self;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    for (UICollectionViewLayoutAttributes *attributes in array) {
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        CGFloat norDistance = fabs(distance / 400);
        CGFloat zoom = 1 - 0.5 * norDistance;
        attributes.transform3D = CATransform3DMakeScale(1.04, zoom, 1.0);
        attributes.zIndex = 1;
    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
