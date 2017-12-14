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
NSString * const WECHATAPPID = @"wxc8cffdde73682f6b";
NSString * const WECHATAPPSECRET = @"fea4338269d6675af018200ed59f7dc7";

NSString * const USERID = @"XJPatientUserId";
NSString * const USERTOKEN = @"XJPatientUserToken";
NSString * const USERNAME = @"XJPatientUsername";
NSString * const USERREALNAME = @"XJPatientUserRealname";
NSString * const RYTOKEN = @"XJPatientRyToken";
NSString * const USERAVATARDATA = @"XJPatientUserAvatarData";
NSString * const USERAVATARSTRING = @"XJPatientUserAvatarString";
NSString * const KEYCHAINSERVICE = @"com.midvision.vruser";

CGFloat const TABBARHEIGHT = 49.0;
CGFloat const NAVIGATIONBARHEIGHT = 64.0;

NSString * const XJSearchPlaceholder = @"请输入你要搜索的内容";
NSString * const XJNetworkError = @"网络错误";

NSString * const XJClickToLogin = @"点击登录";
NSString * const XJCommonTip = @"提示";
NSString * const XJCommonCancel = @"取消";
NSString * const XJCommonEnsure = @"确定";
NSString * const XJIsMakePhoneCall = @"打电话给医生？";

NSString * const XJMyInterrogation = @"我的问诊";
NSString * const XJMyDoctors = @"我的医生";
NSString * const XJMyCollections = @"我的收藏";
NSString * const XJMyAccount = @"我的账单";
NSString * const XJMyPrescriptions = @"我的处方";
NSString * const XJMyAttention = @"我的关注";
NSString * const XJMyBills = @"我的账单";
NSString * const XJHelpAndFeedback = @"帮助与反馈";
NSString * const XJPersonalSetting = @"设置";
NSString * const XJClearCache = @"清除缓存";
NSString * const XJAboutUs = @"关于";
NSString * const XJName = @"姓名";
NSString * const XJIdCardNumber = @"身份证号";
NSString * const XJAge = @"年龄";
NSString * const XJEmergencyContactPerson = @"紧急联系人";
NSString * const XJEmergencyContactPhone = @"紧急联系方式";
NSString * const XJHomeAddress = @"家庭住址";
NSString * const XJInputRealname = @"请输入身份证号对应的真实姓名";
NSString * const XJInputEmergencyContactPhone = @"请输入紧急联系人的联系方式";
NSString * const XJInputSomeInformations = @"请先填写一些个人信息吧";

NSString * const XJInputPhoneNumber = @"请输入您的手机号";
NSString * const XJInputPassword = @"请输入您的密码";
NSString * const XJInputVerificationCode = @"请输入验证码";
NSString * const XJInputPasswordAgain = @"请再次输入您的密码";
NSString * const XJUserAgreement = @"用户协议";
NSString * const XJFetchVerificationCode = @"获取验证码";
NSString * const XJInputCorrectPhoneNumberTip = @"请输入正确的手机号";
NSString * const XJInputPasswordTip = @"请输入密码";
NSString * const XJPasswordFormatTip = @"密码要求是6-16位数字、字母和符号任意两种的组合";
NSString * const XJDifferentPasswordTip = @"两次密码输入不一致";
NSString * const XJInputVerificationCodeTip = @"请输入收到的验证码";
NSString * const XJCameraNotAvailable = @"您的设备不支持拍照";
NSString * const XJAppCameraAccessNotAuthorized = @"请在“设置-隐私-相机”选项中允许心景访问您的相机";
NSString * const XJAppPhotoLibraryAccessNotAuthorized = @"请在“设置-隐私-照片”选项中允许心景访问您的相册";
NSString * const XJPleaseUploadAuthenticationPicture = @"请先上传医生资格证照片";
NSString * const XJPleaseInputCorrectIDCardNumber = @"请输入正确的身份证号";
NSString * const XJFindPassword = @"找回密码";
NSString * const XJChangePassword = @"修改密码";

NSString * const XJLoginSuccess = @"LoginSuccess";
NSString * const XJSetupUnreadMessagesCount = @"SetupUnreadMessagesCount";
NSString * const XJConversationsDidChange = @"ConversationsDidChange";
NSString * const XJDidReceiveWechatPayResponse = @"DidReceiveWechatPayResponse";

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

NSString * const FETCH_USERS_NAME = @"getUserIDAndName";
NSString * const FETCH_CONTENT_DETAIL = @"content/info";
NSString * const EDIT_INFORMATIONS = @"fillInfo";
NSString * const FETCH_CONCERNED_DOCTORS = @"doctor/collect/search";

NSString * const FETCH_PRESCRIPTION_CONTENTS = @"prescription/info";
NSString * const WECHAT_PAY = @"wxGoPay";
