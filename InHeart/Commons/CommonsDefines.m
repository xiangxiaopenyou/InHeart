//
//  CommonsDefines.m
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "CommonsDefines.h"
NSString * const EMChatKey = @"1109161016178876#xinjing";
NSString * const APNSCertName = @"InHeart-User-Dev";
//NSString * const APNSCertName = @"InHeart-User-Dis";

NSString * const USERID = @"UserId";
NSString * const USERTOKEN = @"UserToken";
NSString * const USERNAME = @"Username";
NSString * const USERREALNAME = @"UserRealname";
NSString * const USERENCRYPTEDPASSWORD = @"EncryptedPassword";
NSString * const KEYCHAINSERVICE = @"com.midvision.vruser";

CGFloat const TABBARHEIGHT = 49.0;
CGFloat const NAVIGATIONBARHEIGHT = 64.0;

NSString * const kSearchPlaceholder = @"请输入你要搜索的内容";
NSString * const kNetworkError = @"网络错误";

NSString * const kClickToLogin = @"点击登录";
NSString * const kCommonTip = @"提示";
NSString * const kCommonCancel = @"取消";
NSString * const kCommonEnsure = @"确定";
NSString * const kIsMakePhoneCall = @"打电话给医生？";

NSString * const kMyInterrogation = @"我的问诊";
NSString * const kMyDoctors = @"我的医生";
NSString * const kMyCollections = @"我的收藏";
NSString * const kMyAccount = @"我的账单";
NSString * const kMyPrescriptions = @"我的处方";
NSString * const kMyAttention = @"我的关注";
NSString * const kMyBills = @"我的账单";
NSString * const kHelpAndFeedback = @"帮助与反馈";
NSString * const kPersonalSetting = @"设置";
NSString * const kClearCache = @"清除缓存";
NSString * const kAboutUs = @"关于";
NSString * const kName = @"姓名";
NSString * const kIdCardNumber = @"身份证号";
NSString * const kAge = @"年龄";
NSString * const kEmergencyContactPerson = @"紧急联系人";
NSString * const kEmergencyContactPhone = @"紧急联系方式";
NSString * const kHomeAddress = @"家庭住址";
NSString * const kInputRealname = @"请输入身份证号对应的真实姓名";
NSString * const kInputEmergencyContactPhone = @"请输入紧急联系人的联系方式";
NSString * const kInputSomeInformations = @"请先填写一些个人信息吧";

NSString * const kInputPhoneNumber = @"请输入您的手机号";
NSString * const kInputPassword = @"请输入您的密码";
NSString * const kInputVerificationCode = @"请输入验证码";
NSString * const kInputPasswordAgain = @"请再次输入您的密码";
NSString * const kUserAgreement = @"用户协议";
NSString * const kFetchVerificationCode = @"获取验证码";
NSString * const kInputCorrectPhoneNumberTip = @"请输入正确的手机号";
NSString * const kInputPasswordTip = @"请输入密码";
NSString * const kPasswordFormatTip = @"密码要求是6-16位数字、字母和符号任意两种的组合";
NSString * const kDifferentPasswordTip = @"两次密码输入不一致";
NSString * const kInputVerificationCodeTip = @"请输入收到的验证码";
NSString * const kCameraNotAvailable = @"您的设备不支持拍照";
NSString * const kAppCameraAccessNotAuthorized = @"请在“设置-隐私-相机”选项中允许心景访问您的相机";
NSString * const kAppPhotoLibraryAccessNotAuthorized = @"请在“设置-隐私-照片”选项中允许心景访问您的相册";
NSString * const kPleaseUploadAuthenticationPicture = @"请先上传医生资格证照片";
NSString * const kPleaseInputCorrectIDCardNumber = @"请输入正确的身份证号";
NSString * const kFindPassword = @"找回密码";
NSString * const kChangePassword = @"修改密码";

NSString * const kLoginSuccess = @"LoginSuccess";
NSString * const kSetupUnreadMessagesCount = @"SetupUnreadMessagesCount";
NSString * const kConversationsDidChange = @"ConversationsDidChange";

//NSString * const BASEAPIURL = @"http://xj.dosnsoft.com:8000/api/v1/patient/";
NSString * const BASEAPIURL = @"http://test.med-vision.cn/api/v1/patient/";

NSString * const USER_LOGIN = @"login";
NSString * const USER_REGISTER = @"register";
NSString * const FETCH_VERIFICATION_CODE = @"sendCode";
NSString * const FIND_PASSWORD = @"modifyPassword";
NSString * const USER_LOGOUT = @"logout";

NSString * const FETCH_DOCTORS_LIST = @"doctor/search";
NSString * const FETCH_DISEASES = @"content/disease";
NSString * const FETCH_AREAS = @"getRegion";
NSString * const DOCTOR_DETAIL = @"doctor/info";
NSString * const ADD_ATTENTION = @"doctor/collect";
NSString * const CANCEL_ATTENTION = @"doctor/cancelCollect";
NSString * const UPLOAD_ORDER = @"wxGoPay";

NSString * const FETCH_USERS_NAME = @"getUserIDAndName";
NSString * const FETCH_CONTENT_DETAIL = @"content/info";
NSString * const FETCH_PRESCRIPTION_CONTENTS = @"prescription/info";
NSString * const EDIT_INFORMATIONS = @"fillInfo";
NSString * const FETCH_CONCERNED_DOCTORS = @"doctor/collect/search";
