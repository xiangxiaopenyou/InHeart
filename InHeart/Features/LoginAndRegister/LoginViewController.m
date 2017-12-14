//
//  LoginViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/21.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "LoginViewController.h"

#import "LoginContentCell.h"
#import "RegisterPhoneCell.h"

#import "UserModel.h"
#import "UserInfo.h"

@interface LoginViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) UIButton *fetchCodeButton;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger countInt;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    [self.timer invalidate];
    self.timer = nil;
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
    if (!GJCFStringIsMobilePhone(self.phoneTextField.text)) {
        XLShowThenDismissHUD(NO, XJInputCorrectPhoneNumberTip, self.view);
        return;
    }
    XLShowHUDWithMessage(nil, self.view);
    self.fetchCodeButton.enabled = NO;
    [UserModel fetchCode:self.phoneTextField.text handler:^(id object, NSString *msg) {
        if (msg) {
            XLDismissHUD(self.view, YES, NO, msg);
            [self.timer invalidate];
            self.timer = nil;
            self.fetchCodeButton.enabled = YES;
            [self.fetchCodeButton setTitle:XJFetchVerificationCode forState:UIControlStateNormal];
            [self.fetchCodeButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        } else {
            XLDismissHUD(self.view, YES, YES, @"验证码已发送");
            self.countInt = 60;
            [self.fetchCodeButton setTitle:[NSString stringWithFormat:@"%@", @(self.countInt)] forState:UIControlStateNormal];
            [self.fetchCodeButton setTitleColor:BREAK_LINE_COLOR forState:UIControlStateNormal];
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countNumber) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            }
        }
    }];
}
- (void)countNumber {
    if (self.countInt == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.fetchCodeButton.enabled = YES;
        [self.fetchCodeButton setTitle:XJFetchVerificationCode forState:UIControlStateNormal];
        [self.fetchCodeButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        
    } else {
        self.countInt -= 1;
        [self.fetchCodeButton setTitle:[NSString stringWithFormat:@"%@", @(self.countInt)] forState:UIControlStateNormal];
    }
}

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
- (IBAction)loginClick:(id)sender {
    [self resignTextField];
    if (XLIsNullObject(self.codeTextField.text)) {
        XLDismissHUD(self.view, YES, NO, @"请输入验证码");
        return;
    }
    XLShowHUDWithMessage(nil, self.view);
    [UserModel userLogin:self.phoneTextField.text password:self.codeTextField.text handler:^(id object, NSString *msg) {
        if (object) {
            UserModel *userModel = object;
            if ([[UserInfo sharedUserInfo] saveUserInfo:userModel]) {
                //连接融云
                [[RCIM sharedRCIM] connectWithToken:userModel.rytoken success:^(NSString *userId) {
                    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:userModel.realname portrait:userModel.headPictureUrl];
                    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userId];
                    GJCFAsyncMainQueue(^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:XJLoginSuccess object:@YES];
                    });
                } error:^(RCConnectErrorCode status) {
                    XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"login.loginFailed", nil));
                } tokenIncorrect:^{
                    XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"login.loginFailed", nil));
                }];
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
