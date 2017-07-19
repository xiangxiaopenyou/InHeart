//
//  MyDoctorsViewController.m
//  InHeart
//
//  Created by 项小盆友 on 2017/6/5.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "MyDoctorsViewController.h"
#import "DoctorInformationsCell.h"
#import "DoctorModel.h"

@interface MyDoctorsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (copy, nonatomic) NSArray *doctorsArray;

@end

@implementation MyDoctorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //取消tableview中按钮点击效果延迟效果
    for (UIView *subView in self.tableView.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subView).delaysContentTouches = NO;
        }
    }
    //[self myDoctorsRequest];
    self.doctorsArray = @[@"1", @"2"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)myDoctorsRequest {
    XLShowHUDWithMessage(nil, self.view);
    [DoctorModel fetchConcernedDoctors:^(id object, NSString *msg) {
        XLDismissHUD(self.view, NO, YES, nil);
        if (object) {
            self.doctorsArray = [(NSArray *)object copy];
            if (self.doctorsArray.count > 0) {
                self.tipLabel.hidden = YES;
                GJCFAsyncMainQueue(^{
                    [self.tableView reloadData];
                });
            } else {
                self.tipLabel.hidden = NO;
            }
        } else {
            XLDismissHUD(self.view, YES, NO, XJNetworkError);
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.doctorsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DoctorModel *tempModel = self.doctorsArray[indexPath.row];
//    return [DoctorInformationsCell heightOfCell:tempModel.expertise];
    return 140.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DoctorInformationsCell";
    DoctorInformationsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    //DoctorModel *tempModel = self.doctorsArray[indexPath.row];
    //[cell fillContents:tempModel];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
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
