//
//  XCListCollectionViewCell.h
//  HMT-APP
//
//  Created by IOS技术专用 on 2017/12/15.
//  Copyright © 2017年 LXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCCollectionViewLayout.h"
#import "XCPageControlView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickBlock)(NSInteger index);
typedef void(^loadImageBlock)(NSInteger index, UIImageView* imageView, NSString* imageUrl);

@interface XCListCollectionView : UICollectionView

@property (nonatomic, assign) UIScrollView *placeholderScrollView;

@property (nonatomic, strong) XCPageControlView* pageControl;

- (instancetype _Nonnull )initWithFrame:(CGRect)frame collectionViewLayout:(nonnull XCCollectionViewLayout *)layout andLists:(NSArray* _Nonnull)models andBlock:(clickBlock)block andLoadImageBlock:(loadImageBlock)loadBlock;

/**
 *  滚动间隔时间，默认是2秒
 */
@property (assign, nonatomic) NSInteger displayTime;

/**
 *  设置是否为网络图片，默认是YES
 */
@property (nonatomic, assign) BOOL isWebImage;

/**
 启动广告栏
 
 @param imageUrls 数组图片
 @param isStart 是否启动
 */
- (void)perform:(NSArray*)imageUrls andStartTimer:(BOOL)isStart;

@end

NS_ASSUME_NONNULL_END
