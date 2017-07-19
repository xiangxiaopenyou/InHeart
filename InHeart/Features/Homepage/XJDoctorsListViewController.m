//
//  XJDoctorsListViewController.m
//  InHeart
//
//  Created by 项小盆友 on 2017/7/4.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJDoctorsListViewController.h"

@interface XJDoctorsListViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *searchTextField;

@end

@implementation XJDoctorsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self createNavigationTitleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PrivateMethods
- (void)createNavigationTitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 70, 30)];
    titleView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    titleView.layer.masksToBounds = YES;
    titleView.layer.cornerRadius = 4.0;
    UIImageView *searchImage = [[UIImageView alloc] init];
    searchImage.image = [UIImage imageNamed:@"content_search"];
    [titleView addSubview:searchImage];
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleView.mas_leading).with.mas_offset(15);
        make.size.mas_offset(CGSizeMake(18, 18));
        make.centerY.equalTo(titleView);
    }];
    [titleView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(searchImage.mas_trailing).with.mas_offset(5);
        make.top.bottom.trailing.equalTo(titleView);
    }];
    self.navigationItem.titleView = titleView;
}

#pragma mark - Getters
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"请输入你要搜索的内容";
        [_searchTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _searchTextField.textColor = NAVIGATIONBAR_COLOR;
        _searchTextField.font = XJSystemFont(14);
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.delegate = self;
        
    }
    return _searchTextField;
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
