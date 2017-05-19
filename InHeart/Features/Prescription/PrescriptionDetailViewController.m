//
//  PrescriptionDetailViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/9.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "PrescriptionDetailViewController.h"

#import "PrescriptionDetailInformationCell.h"
#import "PrescriptionDetailContentCell.h"
#import "PrescriptionPriceCell.h"
#import "PrescriptionModel.h"
#import "ContentModel.h"
#import "WechatPayModel.h"

#import "WXApi.h"

@interface PrescriptionDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (strong, nonatomic) PrescriptionModel *model;

@end

@implementation PrescriptionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)fetchDetail {
    XLShowHUDWithMessage(nil, self.view);
    [PrescriptionModel prescriptionDetail:self.prescriptionId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.model = (PrescriptionModel *)object;
            GJCFAsyncMainQueue((^{
                //self.orderNumberLabel.text = self.model.billno;
                self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@", self.model.billno];
                NSString *payStateString;
                if (self.model.payStatus.integerValue == 1) {
                    payStateString = @"待付款";
                    self.payButton.hidden = NO;
                } else if (self.model.payStatus.integerValue == 2) {
                    payStateString = @"已付款";
                    self.payButton.hidden = YES;
                } else {
                    payStateString = @"已取消";
                    self.payButton.hidden = YES;
                }
                self.payStateLabel.text = payStateString;
                [self.tableView reloadData];
            }));
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
- (void)wechatPayRequest {
    XLShowHUDWithMessage(@"请稍候...", self.view);
    [WechatPayModel wechatPay:self.prescriptionId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            WechatPayModel *model = (WechatPayModel *)object;
            [self goWechatPay:model];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - IBAction
- (IBAction)payAction:(id)sender {
    [self wechatPayRequest];
}

#pragma mark - GoWechatPay
- (void)goWechatPay:(WechatPayModel *)model {
    PayReq *request = [[PayReq alloc] init];
    request.openID = WECHATAPPID;
    // 商家id，在注册的时候给的
    request.partnerId = model.partnerid;
    
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    request.prepayId  = model.prepayid;
    
    // 根据财付通文档填写的数据和签名
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    request.package   = model.package;
    
    // 随机编码，为了防止重复的，在后台生成
    request.nonceStr  = model.noncestr;
    
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    request.timeStamp = model.timestamp.intValue;
    
    // 这个签名也是后台做的
    request.sign = model.sign;
    
    //发送请求到微信，等待微信返回onResp
    [WXApi sendReq:request];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model ? 4 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
            height = 20 + XLSizeOfText(self.model.disease, SCREEN_WIDTH - 30, kSystemFont(14)).height;
            break;
        case 1:
            height = 20 + XLSizeOfText(self.model.suggestion, SCREEN_WIDTH - 30, kSystemFont(14)).height;
            break;
        case 2:
            height = 90.f * self.model.prescriptionContentList.count;
            break;
        case 3:
            height = 50.f;
            break;
            
        default:
            break;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            static NSString *identifier = @"DetailInformationCell";
            PrescriptionDetailInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentLabel.text = [NSString stringWithFormat:@"%@", self.model.disease];
            return cell;
        }
            
            break;
        case 1:{
            static NSString *identifier = @"DetailInformationCell";
            PrescriptionDetailInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentLabel.text = [NSString stringWithFormat:@"%@", self.model.suggestion];
            return cell;
        }
            break;
        case 2:{
            static NSString *identifier = @"PrescriptionDetailContentCell";
            PrescriptionDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *tempArray = [ContentModel setupWithArray:self.model.prescriptionContentList];
            [cell resetContents:tempArray];
            return cell;
        }
            break;
        case 3:{
            static NSString *identifier = @"PrescriptionPriceCell";
            PrescriptionPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", [self.model.price floatValue]];
            return cell;
        }
            break;
            
        default:
            return [UITableViewCell new];
            break;
    }
}

#pragma mark - UITableViewDelegae
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.backgroundColor = MAIN_BACKGROUND_COLOR;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
    headerLabel.font = kSystemFont(14);
    headerLabel.textColor = [UIColor blackColor];
    NSString *title;
    switch (section) {
        case 0:
            title = @"病症";
            break;
        case 1:
            title = @"医嘱";
            break;
        case 2:
            title = @"内容";
            break;
        case 3:
            title = @"总价";
            break;
            
        default:
            break;
    }
    headerLabel.text = title;
    [headerView addSubview:headerLabel];
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
