//
//  XJChatViewController.m
//  InHeart
//
//  Created by 项小盆友 on 2017/12/5.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJChatViewController.h"
#import "XJOrderDetailViewController.h"

#import "XJPlanOrderMessage.h"
#import "XJPlanOrderMessageCell.h"

#import <IQKeyboardManager.h>

@interface XJChatViewController ()

@end

@implementation XJChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerClass:[XJPlanOrderMessageCell class] forMessageClass:[XJPlanOrderMessage class]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[XJPlanOrderMessage class]]) {
        XJPlanOrderMessage *message = (XJPlanOrderMessage *)model.content;
        XJOrderDetailViewController *detailController = [[UIStoryboard storyboardWithName:@"Orders" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderDetail"];
        detailController.orderId = message.orderId;
        [self.navigationController pushViewController:detailController animated:YES];
    }
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
