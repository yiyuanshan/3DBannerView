//
//  XCADView.m
//  XC3DView
//
//  Created by IOS技术专用 on 2018/5/3.
//  Copyright © 2018年 LXC. All rights reserved.
//

#import "XCADView.h"

@interface XCADView()

@property (nonatomic, strong) NSArray* imageUrls;

@property (nonatomic, assign) BOOL isStart;

@end

@implementation XCADView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.displayTime = 3;
        self.isWebImage = YES;
    }
    return self;
}

#pragma mark - Public Method
- (void)perform:(NSArray *)imageUrls andStartTimer:(BOOL)isStart
{
    self.imageUrls = imageUrls;
    self.isStart = isStart;
    if (0 == self.imageUrls.count) return;
    self.collectionView.displayTime = 0;
    self.collectionView.isWebImage = self.isWebImage;
    [self.collectionView perform:imageUrls andStartTimer:isStart];
}

#pragma mark - Setter/Getter
- (XCListCollectionView *)collectionView
{
    if (!_collectionView) {
        XCCollectionViewLayout* layout = [[XCCollectionViewLayout alloc] init];
        _collectionView = [[XCListCollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height) collectionViewLayout:layout andLists:self.imageUrls andBlock:^(NSInteger index) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(adView:didSelectedAtIndex:)]) [self.delegate adView:self didSelectedAtIndex:index];
        }andLoadImageBlock:^(NSInteger index, UIImageView * _Nonnull imageView, NSString * _Nonnull imageUrl) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(adView:lazyLoadAtIndex:imageView:imageURL:)]) [self.delegate adView:self lazyLoadAtIndex:index imageView:imageView imageURL:imageUrl];
        }];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

@end
