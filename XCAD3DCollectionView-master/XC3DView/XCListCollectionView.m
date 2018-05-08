//
//  XCListCollectionViewCell.m
//  HMT-APP
//
//  Created by IOS技术专用 on 2017/12/15.
//  Copyright © 2017年 LXC. All rights reserved.
//

#import "XCListCollectionView.h"
#import "XCItemCollectionViewCell.h"

@interface XCListCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) clickBlock block;

@property (nonatomic, copy) loadImageBlock loadBlock;

@property (nonatomic, strong) NSArray* lists;

@property (nonatomic, strong) XCCollectionViewLayout* layout;

#if OS_OBJECT_USE_OBJC
@property (strong, nonatomic)  dispatch_source_t timer;
#else
@property (nonatomic)  dispatch_source_t timer;
#endif

@property (nonatomic, strong) NSTimer* delayTimer;

@property (nonatomic, assign) BOOL isStart;

@end

@implementation XCListCollectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull XCCollectionViewLayout *)layout andLists:(NSArray*)models andBlock:(clickBlock)block andLoadImageBlock:(nonnull loadImageBlock)loadBlock
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        self.layout = layout;
        self.lists = models;
        self.block = block;
        self.loadBlock = loadBlock;
        
        [self registerNib:[UINib nibWithNibName:@"XCItemCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
        
        CGFloat width = layout.itemSize.width + layout.minimumLineSpacing;
        
        UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width,40)];
        scrollview.pagingEnabled = YES;
        scrollview.backgroundColor = [UIColor clearColor];
        scrollview.delegate = self;
        scrollview.showsHorizontalScrollIndicator = NO;
        [scrollview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [self addSubview:scrollview];
        self.placeholderScrollView = scrollview;
        
        self.placeholderScrollView.contentOffset = CGPointMake(self.lists.count * 250 * self.placeholderScrollView.frame.size.width, 0);
    }
    return self;
}

- (void)perform:(NSArray *)imageUrls andStartTimer:(BOOL)isStart
{
    self.isStart = isStart;
    if (1 == imageUrls.count) {
        self.placeholderScrollView.scrollEnabled = NO;
        self.pageControl.hidden = YES;
        if (self.timer) dispatch_source_cancel(self.timer);
        return;
    }else{
        self.placeholderScrollView.scrollEnabled = YES;
        self.pageControl.hidden = NO;
    }
    
    if (self.timer) dispatch_source_cancel(self.timer);
    
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.displayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isStart) {
            [weakself startTime];
        }
    });
    self.pageControl.hidden = YES;
}

#pragma mark - Responder Method
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return self.placeholderScrollView;
}

- (void)tap:(UITapGestureRecognizer *)tapGR {
    CGPoint point = [tapGR locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    [self startRunloop];
    if (self.block) {
        self.block(indexPath.row % self.lists.count);
    }
}

- (void)delayStart
{
    if (self.isStart) [self startTime];
}

#pragma mark - Delegate Method
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.timer) dispatch_source_cancel(self.timer);
    if ([self.delayTimer isValid]) {
        [self.delayTimer invalidate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startRunloop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.placeholderScrollView]) {
        self.contentOffset = scrollView.contentOffset;
    }else{
        int num = [self currentIndex];
        self.pageControl.currentPage = num % self.lists.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.placeholderScrollView.contentSize = CGSizeMake(self.placeholderScrollView.frame.size.width * self.lists.count , 0);
    [self.superview addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.lists.count;
    return self.lists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XCItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"XCItemCollectionViewCell" owner:nil options:nil].lastObject;
    }
    if (self.loadBlock) {
        self.loadBlock(indexPath.row % self.lists.count, cell.imageView, self.lists[indexPath.row % self.lists.count]);
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 60, 250);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0001f;
}

#pragma mark - Private Method
- (void)startRunloop
{
    if (self.timer) dispatch_source_cancel(self.timer);
    if ([self.delayTimer isValid]) [self.delayTimer invalidate];
    self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:self.displayTime target:self selector:@selector(delayStart) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.delayTimer forMode:NSRunLoopCommonModes];
}

- (void)startTime
{
    __block NSInteger timeout = self.displayTime;
    __weak typeof(self) weakself = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), timeout * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakself.placeholderScrollView.tracking) {
                    dispatch_source_cancel(_timer);
                    return ;
                }
                int currentIndex = [self currentIndex];
                int targetIndex = currentIndex + 1;
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     weakself.placeholderScrollView.contentOffset = CGPointMake(targetIndex * weakself.placeholderScrollView.frame.size.width, 0);
                                 }];
            });
        }
    });
    dispatch_resume(self.timer);
}

- (int)currentIndex
{
    if (self.frame.size.width == 0 || self.frame.size.height == 0) return 0;
    
    int index = 0;
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.contentOffset.x + self.layout.itemSize.width * 0.5) / self.layout.itemSize.width;
    } else {
        index = (self.contentOffset.y + self.layout.itemSize.height * 0.5) / self.layout.itemSize.height;
    }
    return MAX(0, index);
}

#pragma mark - Setter/Getter
- (XCPageControlView *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[XCPageControlView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44, self.frame.size.width, 30)];
        _pageControl.pageIndicatorColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorColor = [UIColor whiteColor];
    }
    return _pageControl;
}

@end
