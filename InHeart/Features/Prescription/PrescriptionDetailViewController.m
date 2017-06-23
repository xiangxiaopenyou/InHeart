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
#import "MXWechatSignAdaptor.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayResult:) name:XJDidReceiveWechatPayResponse object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XJDidReceiveWechatPayResponse object:nil];
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
            //XLDismissHUD(self.view, NO, YES, nil);
            WechatPayModel *model = (WechatPayModel *)object;
            [self goWechatPay:model];
            //[self wechatSign:model];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Notification
- (void)wechatPayResult:(NSNotification *)notification {
    
    if ([notification.object isKindOfClass:[PayResp class]]) {
        PayResp *response = notification.object;
        switch (response.errCode) {
            case 0:
                XLDismissHUD(self.view, YES, YES, @"支付成功");
                self.model.payStatus = @(2);
                if (self.block) {
                    self.block(self.model);
                }
                [self performSelector:@selector(dismissView) withObject:nil afterDelay:1.0];
                break;
            case -1:
                //payResoult = @"支付失败！";
                XLDismissHUD(self.view, YES, NO, @"支付失败");
                break;
            case -2:
                //payResoult = @"用户已经退出支付！";
                XLDismissHUD(self.view, YES, NO, @"已经退出支付");
                break;
            default: {
                XLDismissHUD(self.view, YES, NO, @"支付失败");
            }
            break;
        }
    } else if ([notification.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *temp = notification.object;
        NSInteger code = [temp[@"ret"] integerValue];
        switch (code) {
            case 0:
                XLDismissHUD(self.view, YES, YES, @"支付成功");
                self.model.payStatus = @(2);
                if (self.block) {
                    self.block(self.model);
                }
                [self performSelector:@selector(dismissView) withObject:nil afterDelay:1.0];
                break;
            case -1:
                //payResoult = @"支付失败！";
                XLDismissHUD(self.view, YES, NO, @"支付失败");
                break;
            case -2:
                //payResoult = @"用户已经退出支付！";
                XLDismissHUD(self.view, YES, NO, @"已经退出支付");
                break;
            default: {
                XLDismissHUD(self.view, YES, NO, @"支付失败");
            }
                break;
        }
    }
}

#pragma mark - IBAction
- (void)dismissView {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)payAction:(id)sender {
    [self wechatPayRequest];
}
- (IBAction)callAction:(id)sender {
    [[UIApplication sharedApplication] openURL:XLURLFromString([NSString stringWithFormat:@"tel://4001667866"])];
}

- (void)wechatSign:(WechatPayModel *)model {
    NSString *tradeType = @"APP";                                       //交易类型
    NSString *totalFee  = @"1";                                         //交易价格1表示0.01元，10表示0.1元
    NSString *tradeNO   = [self generateTradeNO];                       //随机字符串变量 这里最好使用和安卓端一致的生成逻辑
    NSString *addressIP = @"8.8.8.8";                        //设备IP地址,请再wifi环境下测试,否则获取的ip地址为error,正确格式应该是8.8.8.8
    NSString *orderNo = model.orderId;
    NSString *notifyUrl = @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php";
    MXWechatSignAdaptor *adaptor = [[MXWechatSignAdaptor alloc] initWithWechatAppId:MXWechatAPPID
                                                                        wechatMCHId:MXWechatMCHID
                                                                            tradeNo:tradeNO
                                                                   wechatPartnerKey:MXWechatPartnerKey
                                                                           payTitle:@"充值"
                                                                            orderNo:orderNo
                                                                           totalFee:totalFee
                                                                           deviceIp:addressIP
                                                                          notifyUrl:notifyUrl
                                                                          tradeType:tradeType];
    //转换成XML字符串,这里只是形似XML，实际并不是正确的XML格式，需要使用AF方法进行转义
    NSString *string = [[adaptor dic] XMLString];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 这里传入的XML字符串只是形似XML，但不是正确是XML格式，需要使用AF方法进行转义
    session.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [session.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [session.requestSerializer setValue:kUrlWechatPay forHTTPHeaderField:@"SOAPAction"];
    [session.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return string;
    }];
    
    [session POST:kUrlWechatPay
       parameters:string
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         //  输出XML数据
         NSString *responseString = [[NSString alloc] initWithData:responseObject
                                                          encoding:NSUTF8StringEncoding] ;
         //  将微信返回的xml数据解析转义成字典
         NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
         
         // 判断返回的许可
         if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"]
             &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
             // 发起微信支付，设置参数
             PayReq *request = [[PayReq alloc] init];
             request.openID = [dic objectForKey:WXAPPID];
             request.partnerId = [dic objectForKey:WXMCHID];
             request.prepayId= [dic objectForKey:WXPREPAYID];
             request.package = @"Sign=WXPay";
             request.nonceStr= [dic objectForKey:WXNONCESTR];
             
             // 将当前时间转化成时间戳
             NSDate *datenow = [NSDate date];
             NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
             UInt32 timeStamp =[timeSp intValue];
             request.timeStamp= timeStamp;
             
             // 签名加密
             MXWechatSignAdaptor *md5 = [[MXWechatSignAdaptor alloc] init];
             
             request.sign=[md5 createMD5SingForPay:request.openID
                                         partnerid:request.partnerId
                                          prepayid:request.prepayId
                                           package:request.package
                                          noncestr:request.nonceStr
                                         timestamp:request.timeStamp];
             
             
             // 调用微信
             [WXApi sendReq:request];
             //XLDismissHUD(self.view, NO, YES, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         XLDismissHUD(self.view, YES, NO, @"支付失败");
     }];
}

#pragma mark - GoWechatPay
- (void)goWechatPay:(WechatPayModel *)model {
    PayReq *request = [[PayReq alloc] init];
    //request.openID = WECHATAPPID;
    // 商家id，在注册的时候给的
    request.partnerId = model.partnerid;
    
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    request.prepayId  = model.prepayid;
    
    // 根据财付通文档填写的数据和签名
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    request.package   = @"Sign=WXPay";
    
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
            height = 20 + XLSizeOfText(self.model.disease, SCREEN_WIDTH - 30, XJSystemFont(14)).height;
            break;
        case 1:
            height = 20 + XLSizeOfText(self.model.suggestion, SCREEN_WIDTH - 30, XJSystemFont(14)).height;
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
    headerLabel.font = XJSystemFont(14);
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
#pragma mark - Private Method
/**
 ------------------------------
 产生随机字符串
 ------------------------------
 1.生成随机数算法 ,随机字符串，不长于32位
 2.微信支付API接口协议中包含字段nonce_str，主要保证签名不可预测。
 3.我们推荐生成随机数算法如下：调用随机数函数生成，将得到的值转换为字符串。
 */
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    //  srand函数是初始化随机数的种子，为接下来的rand函数调用做准备。
    //  time(0)函数返回某一特定时间的小数值。
    //  这条语句的意思就是初始化随机数种子，time函数是为了提高随机的质量（也就是减少重复）而使用的。
    
    //　srand(time(0)) 就是给这个算法一个启动种子，也就是算法的随机种子数，有这个数以后才可以产生随机数,用1970.1.1至今的秒数，初始化随机数种子。
    //　Srand是种下随机种子数，你每回种下的种子不一样，用Rand得到的随机数就不一样。为了每回种下一个不一样的种子，所以就选用Time(0)，Time(0)是得到当前时时间值（因为每时每刻时间是不一样的了）。
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
    srand(time(0)); // 此行代码有警告:
#pragma clang diagnostic pop
    for (int i = 0; i < kNumber; i++) {
        
        unsigned index = rand() % [sourceStr length];
        
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

/**
 ------------------------------
 获取设备ip地址
 ------------------------------
 1.貌似该方法获取ip地址只能在wifi状态下进行
 */
- (NSString *)fetchIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end
