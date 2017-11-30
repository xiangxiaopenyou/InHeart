//
//  HomepageNavigationController.m
//  InHeart
//
//  Created by 项小盆友 on 2017/6/7.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "HomepageNavigationController.h"
#import "HomepageViewController.h"


@interface HomepageNavigationController ()<UINavigationControllerDelegate>

@end

@implementation HomepageNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigation controller delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.interactivePopGestureRecognizer.delegate = (id)viewController;
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
