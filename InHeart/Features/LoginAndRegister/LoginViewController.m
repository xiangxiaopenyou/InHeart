//
//  LoginViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/21.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "LoginContentCell.h"
#import "RegisterPhoneCell.h"

#import "UserModel.h"
#import "UserInfo.h"
#import <OpenShareHeader.h>

@interface LoginViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) UIButton *fetchCodeButton;
//@property (strong, nonatomic) UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignTextField {
    [self.codeTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}

- (void)fetchCodeClick {
}

//#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField == self.passwordTextField) {
//        [self.passwordTextField resignFirstResponder];
//    }
//    return YES;
//}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *identifier = @"PhoneCell";
        RegisterPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImageView.image = [UIImage imageNamed:@"phone_number"];
        [cell.contentView addSubview:self.phoneTextField];
        [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
            make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
            make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-112);
            make.height.mas_offset(30);
        }];
        [cell.contentView addSubview:self.fetchCodeButton];
        [self.fetchCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-22);
            make.top.equalTo(cell.contentView.mas_top);
            make.height.mas_offset(44);
            make.width.mas_offset(80);
        }];
        return cell;
    } else {
        static NSString *identifier = @"ContenCell";
        LoginContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImageView.image = [UIImage imageNamed:@"Identify_code"];
        [cell.contentView addSubview:self.codeTextField];
        [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
            make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
            make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
            make.height.mas_offset(30);
        }];
        return cell;
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

#pragma mark - Action & Selector
- (IBAction)registerNowClick:(id)sender {
    RegisterViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Register"];
    [self.navigationController pushViewController:registerViewController animated:YES];
}
- (IBAction)forgetPasswordClick:(id)sender {
}
- (IBAction)wechatLoginAction:(id)sender {
    [OpenShare WeixinAuth:@"snsapi_userinfo" Success:^(NSDictionary *message) {
        
    } Fail:^(NSDictionary *message, NSError *error) {
        
    }];
}
- (IBAction)loginClick:(id)sender {
//    if (!GJCFStringIsMobilePhone(self.phoneTextField.text)) {
//        XLShowThenDismissHUD(NO, XJInputCorrectPhoneNumberTip, self.view);
//        return;
//    }
//    if (XLIsNullObject(self.passwordTextField.text)) {
//        XLShowThenDismissHUD(NO, XJInputPasswordTip, self.view);
//        return;
//    }
    [self resignTextField];
    XLShowHUDWithMessage(nil, self.view);
    [UserModel userLogin:@"15658888800" password:@"qaz123" handler:^(id object, NSString *msg) {
        if (object) {
            UserModel *userModel = object;
            if ([[UserInfo sharedUserInfo] saveUserInfo:userModel]) {
                GJCFAsyncGlobalDefaultQueue(^{
                    EMError *error = [[EMClient sharedClient] loginWithUsername:userModel.username password:userModel.encryptPw];
                    GJCFAsyncMainQueue(^{
                        if (!error) { //环信登录成功
                            XLDismissHUD(self.view, NO, YES, nil);
                            [[NSNotificationCenter defaultCenter] postNotificationName:XJLoginSuccess object:@YES];
                            [[EMClient sharedClient].options setIsAutoLogin:YES];
                            [[EMClient sharedClient] migrateDatabaseToLatestSDK];
                        } else {
                            XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"login.loginFailed", nil));
                        }
                    });
                });
            } else {
                XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"login.loginFailed", nil));
            }
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - getters
- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] init];
        [_codeTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _codeTextField.font = XJSystemFont(14);
        _codeTextField.textColor = MAIN_TEXT_COLOR;
        _codeTextField.placeholder = XJInputVerificationCode;
        _codeTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.delegate = self;
    }
    return _codeTextField;
}
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] init];
        [_phoneTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _phoneTextField.font = XJSystemFont(14);
        _phoneTextField.textColor = MAIN_TEXT_COLOR;
        _phoneTextField.placeholder = XJInputPhoneNumber;
        _phoneTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.delegate = self;
    }
    return _phoneTextField;
}
- (UIButton *)fetchCodeButton {
    if (!_fetchCodeButton) {
        _fetchCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fetchCodeButton setTitle:XJFetchVerificationCode forState:UIControlStateNormal];
        [_fetchCodeButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        _fetchCodeButton.titleLabel.font = XJSystemFont(14);
        [_fetchCodeButton addTarget:self action:@selector(fetchCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fetchCodeButton;
}

@end
