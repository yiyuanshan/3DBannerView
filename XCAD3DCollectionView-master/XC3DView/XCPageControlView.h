//
//  XCPageControlView.h
//  XCADView
//
//  Created by 刘小椿 on 17/4/28.
//  Copyright © 2017年 刘小椿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCPageControlView : UIView

@property (nonatomic, assign) NSInteger numberOfPages;                 /** < 指示器页数 */
@property (nonatomic, strong) UIColor* pageIndicatorColor;            /** < 指示器颜色 */
@property (nonatomic, strong) UIColor* currentPageIndicatorColor;     /** < 当前指示器颜色 */
@property (nonatomic, assign) NSInteger currentPage;                   /** < 当前页 */

@end
