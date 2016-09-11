//
//  MainTabBarController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MainTabBarController.h"
#import "ContentViewController.h"
#import "ContentNavigationController.h"

static CGFloat const kTipLabelHeight = 2.0;
#define kTipLabelWidth SCREEN_WIDTH / 4.0


@interface MainTabBarController ()
@property (strong, nonatomic) UILabel *bottomTipLabel;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addViewToTabBar];
    //内容
    ContentViewController *contentViewController = [[UIStoryboard storyboardWithName:@"Content" bundle:nil] instantiateViewControllerWithIdentifier:@"ContentView"];
    [self setupChildControllerWith:contentViewController normalImage:nil selectedImage:nil title:@"内容" index:0];
    
    //问诊
    UIViewController *viewController2 = [[UIViewController alloc] init];
    [self setupChildControllerWith:viewController2 normalImage:nil selectedImage:nil title:@"问诊" index:1];
    
    //消息
    UIViewController *viewController3 = [[UIViewController alloc] init];
    [self setupChildControllerWith:viewController3 normalImage:nil selectedImage:nil title:@"消息" index:2];
    
    //个人中心
    UIViewController *viewController4 = [[UIViewController alloc] init];
    [self setupChildControllerWith:viewController4 normalImage:nil selectedImage:nil title:@"个人中心" index:3];

}
- (UILabel *)bottomTipLabel {
    if (!_bottomTipLabel) {
        _bottomTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kTipLabelWidth, kTipLabelHeight)];
        _bottomTipLabel.backgroundColor = [UIColor redColor];
    }
    return _bottomTipLabel;
}
- (void)addViewToTabBar {
    [self.tabBar addSubview:self.bottomTipLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupChildControllerWith:(UIViewController *)childViewController normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage title:(NSString *)title index:(NSInteger)index {
    if (index == 0) {
        ContentNavigationController *navigationController = [[ContentNavigationController alloc] initWithRootViewController:childViewController];
        childViewController.title = title;
        childViewController.tabBarItem.image = normalImage;
        childViewController.tabBarItem.selectedImage = selectedImage;
        [self addChildViewController:navigationController];
    } else {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:childViewController];
        childViewController.title = title;
        childViewController.tabBarItem.image = normalImage;
        childViewController.tabBarItem.selectedImage = selectedImage;
        [self addChildViewController:navigationController];
    }
    
 
}
- (void)changeTipLabelPosition:(CGFloat)positionX {
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomTipLabel.frame = CGRectMake(positionX, 0, kTipLabelWidth, kTipLabelHeight);
    }];
}


#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    CGFloat positionX = index * kTipLabelWidth;
    [self changeTipLabelPosition:positionX];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
