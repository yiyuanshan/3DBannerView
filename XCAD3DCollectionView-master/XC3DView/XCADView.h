//
//  XCADView.h
//  XC3DView
//
//  Created by IOS技术专用 on 2018/5/3.
//  Copyright © 2018年 LXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCPageControlView.h"
#import "XCListCollectionView.h"

@class XCADView;

@protocol XCADViewDelegate <NSObject>

/**
 *  慢加载网络图片
 *
 *  @param adView    广告控件
 *  @param index     索引
 *  @param imageView 控件
 *  @param imageURL  图片URL
 */
- (void)adView:(XCADView *)adView lazyLoadAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imageURL:(NSString *)imageURL;

/**
 *  选择到某个广告
 *
 *  @param adView    广告控件
 *  @param index     索引
 */
- (void)adView:(XCADView *)adView didSelectedAtIndex:(NSUInteger)index;

@end

@interface XCADView : UIView

@property (nonatomic, weak) id<XCADViewDelegate>delegate;

/**
 指示器
 */
@property (nonatomic, strong) XCPageControlView* pageControl;

/**
 *  滚动间隔时间，默认是2秒
 */
@property (assign, nonatomic) NSInteger displayTime;

/**
 *  设置是否为网络图片，默认是YES
 */
@property (nonatomic, assign) BOOL isWebImage;

/**
 主视图
 */
@property (nonatomic, strong) XCListCollectionView* collectionView;

/**
 启动广告栏
 
 @param imageUrls 数组图片
 @param isStart 是否启动
 */
- (void)perform:(NSArray*)imageUrls andStartTimer:(BOOL)isStart;

@end
