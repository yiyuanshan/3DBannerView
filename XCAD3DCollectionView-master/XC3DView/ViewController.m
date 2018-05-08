//
//  ViewController.m
//  XC3DView
//
//  Created by IOS技术专用 on 2017/12/25.
//  Copyright © 2017年 LXC. All rights reserved.
//

#import "ViewController.h"
#import "XCADView.h"

@interface ViewController ()<XCADViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) XCADView* adView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backView addSubview:self.adView];
    [self.adView perform:@[@"1.jpg",@"a.jpg"] andStartTimer:YES];
}

#pragma mark - Delegate Method
- (void)adView:(XCADView *)adView lazyLoadAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imageURL:(NSString *)imageURL
{
    imageView.image = [UIImage imageNamed:imageURL];
}

- (void)adView:(XCADView *)adView didSelectedAtIndex:(NSUInteger)index
{
    NSLog(@"点击第%lu个",index);
}

- (XCADView *)adView
{
    if (!_adView) {
        _adView = [[XCADView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.backView.frame.size.height)];
        _adView.delegate = self;
        _adView.pageControl.frame = CGRectMake(0, _adView.frame.size.height - 30, [UIScreen mainScreen].bounds.size.width, 30);
    }
    return _adView;
}

@end
