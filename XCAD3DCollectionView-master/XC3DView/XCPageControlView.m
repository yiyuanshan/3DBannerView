//
//  XCPageControlView.m
//  XCADView
//
//  Created by 刘小椿 on 17/4/28.
//  Copyright © 2017年 刘小椿. All rights reserved.
//

#import "XCPageControlView.h"

@interface XCPageControlView ()

@property (nonatomic, strong) NSMutableArray * indicatorViews;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, assign) CGFloat indicatorMargin;
@property (nonatomic, assign) CGFloat indicatorWidth;
@property (nonatomic, assign) CGFloat currentIndicatorWidth;
@property (nonatomic, assign) CGFloat indicatorHeight;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat itemY;
@property (nonatomic, assign) CGFloat originX;

@end

@implementation XCPageControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.indicatorMargin = 5;
        self.indicatorHeight = 6;
        self.currentPageIndicatorColor = [UIColor redColor];
        self.pageIndicatorColor = [UIColor grayColor];
        self.itemY = self.frame.size.height / 2 - self.indicatorHeight / 2;
    }
    return self;
}

#pragma mark - Private Method


#pragma mark - Setter/Getter
- (NSMutableArray *)indicatorViews
{
    if (!_indicatorViews) {
        _indicatorViews = [NSMutableArray array];
    }
    return _indicatorViews;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:self];
    [self.indicatorViews removeAllObjects];
    
    self.originX = (self.frame.size.width - ((numberOfPages + 1) * self.indicatorHeight + numberOfPages * self.indicatorMargin)) / 2;
    
    _numberOfPages = numberOfPages;
    for (NSInteger index = 0; index < numberOfPages; index++) {
        UIView* indicator;
        if (0 == index) {
            indicator = [[UIView alloc] initWithFrame:CGRectMake(self.originX, self.itemY, 2 * self.indicatorHeight + self.indicatorMargin , self.indicatorHeight)];
            indicator.backgroundColor = self.currentPageIndicatorColor;
            indicator.layer.masksToBounds = YES;
            indicator.layer.cornerRadius = self.indicatorHeight / 2;
            [self addSubview:indicator];
        }else{
            indicator = [[UIView alloc] initWithFrame:CGRectMake(self.originX + 2 * self.indicatorHeight + 2 * self.indicatorMargin + (index - 1) * (self.indicatorHeight + self.indicatorMargin), self.itemY, self.indicatorHeight, self.indicatorHeight)];
            indicator.backgroundColor = self.pageIndicatorColor;
            indicator.layer.masksToBounds = YES;
            indicator.layer.cornerRadius = self.indicatorHeight / 2;
            [self addSubview:indicator];
        }
        [self.indicatorViews addObject:indicator];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage >= self.indicatorViews.count) {
        return;
    }
    if (self.currentIndex != currentPage) {
        if ((0 == self.currentIndex && currentPage == _numberOfPages - 1) || (self.currentIndex > currentPage && !(_numberOfPages - 1 == self.currentIndex && 0 == currentPage))) {
            //左滑
            UIView* currentView;
            UIView* lastView;
            if (_numberOfPages - 1 == currentPage) {
                currentView = self.indicatorViews[currentPage];
                currentView.backgroundColor = self.currentPageIndicatorColor;
                
                lastView = self.indicatorViews[0];
                lastView.backgroundColor = self.pageIndicatorColor;
                
                [UIView animateWithDuration:0.4 animations:^{
                    for (NSInteger index = 1; index < _numberOfPages - 1; index++) {
                        ((UIView*)self.indicatorViews[index]).frame = CGRectMake(self.originX + index * (self.indicatorHeight + self.indicatorMargin), self.itemY, self.indicatorHeight, self.indicatorHeight);
                    }
                    lastView.frame = CGRectMake(self.originX, self.itemY, self.indicatorHeight, self.indicatorHeight);
                    currentView.frame = CGRectMake(self.originX + (_numberOfPages - 1) * (self.indicatorHeight + self.indicatorMargin), self.itemY, 2 * self.indicatorHeight + self.indicatorMargin, self.indicatorHeight);
                }];
            }else{
                currentView = self.indicatorViews[currentPage];
                currentView.backgroundColor = self.currentPageIndicatorColor;
                
                lastView = self.indicatorViews[currentPage + 1];
                lastView.backgroundColor = self.pageIndicatorColor;
                
                [UIView animateWithDuration:0.4 animations:^{
                    currentView.frame = CGRectMake(self.originX + currentPage * (self.indicatorHeight + self.indicatorMargin), self.itemY, 2 * self.indicatorHeight + self.indicatorMargin, self.indicatorHeight);
                    lastView.frame = CGRectMake(currentView.frame.origin.x + currentView.frame.size.width + self.indicatorMargin, self.itemY, self.indicatorHeight, self.indicatorHeight);
                }];
            }
            self.currentIndex = currentPage;
        }else{
            //右滑
            UIView* currentView;
            UIView* lastView;
            if (0 == currentPage) {
                currentView = self.indicatorViews[currentPage];
                currentView.backgroundColor = self.currentPageIndicatorColor;
                
                lastView = self.indicatorViews[_numberOfPages - 1];
                lastView.backgroundColor = self.pageIndicatorColor;
                
                if (lastView.frame.size.width == self.indicatorHeight) {
                    [UIView animateWithDuration:0.4 animations:^{
                        currentView.frame = CGRectMake(self.originX, self.itemY, 2 * self.indicatorHeight + self.indicatorMargin, self.indicatorHeight);
                    }];
                }else{
                    [UIView animateWithDuration:0.4 animations:^{
                        for (NSInteger index = 1; index < _numberOfPages - 1; index++) {
                            ((UIView*)self.indicatorViews[index]).frame = CGRectMake(self.originX + 2 * self.indicatorHeight + 2 * self.indicatorMargin + (index - 1) * (self.indicatorHeight + self.indicatorMargin), self.itemY, self.indicatorHeight, self.indicatorHeight);
                        }
                        lastView.frame = CGRectMake(self.originX + 2 * self.indicatorHeight + 2 * self.indicatorMargin + (_numberOfPages - 2) * (self.indicatorHeight + self.indicatorMargin), self.itemY, self.indicatorHeight, self.indicatorHeight);
                        currentView.frame = CGRectMake(self.originX, self.itemY, 2 * self.indicatorHeight + self.indicatorMargin, self.indicatorHeight);
                    }];
                }
            }else{
                currentView = self.indicatorViews[currentPage];
                currentView.backgroundColor = self.currentPageIndicatorColor;
                
                lastView = self.indicatorViews[currentPage - 1];
                lastView.backgroundColor = self.pageIndicatorColor;
                
                [UIView animateWithDuration:0.4 animations:^{
                    lastView.frame = CGRectMake(lastView.frame.origin.x, self.itemY, self.indicatorHeight, self.indicatorHeight);
                    currentView.frame = CGRectMake(lastView.frame.origin.x + self.indicatorMargin + self.indicatorHeight, self.itemY, 2 * self.indicatorHeight + self.indicatorMargin, self.indicatorHeight);
                }];
            }
            self.currentIndex = currentPage;
        }
    }
}

@end
