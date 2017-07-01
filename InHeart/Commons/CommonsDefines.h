//
//  CommonsDefines.h
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, XJInformationType) {
    XJInformationTypeName,
    XJInformationTypeSex,
    XJInformationTypeAge
};

//key & secret
extern NSString * const EMChatKey;
extern NSString * const APNSCertName;
extern NSString * const WECHATAPPID;
extern NSString * const WECHATAPPSECRET;
/**
 *  用户相关
 */
extern NSString * const USERID;
extern NSString * const USERTOKEN;
extern NSString * const USERNAME;
extern NSString * const USERREALNAME;
extern NSString * const USERENCRYPTEDPASSWORD;
extern NSString * const USERAVATARDATA;
extern NSString * const USERAVATARSTRING;
extern NSString * const KEYCHAINSERVICE;
/**
 *  常用数值
 */
extern CGFloat const TABBARHEIGHT;
extern CGFloat const NAVIGATIONBARHEIGHT;

//内容
extern NSString * const XJSearchPlaceholder;
extern NSString * const XJNetworkError;

//消息
extern NSString * const XJClickToLogin;
extern NSString * const XJCommonTip;
extern NSString * const XJCommonCancel;
extern NSString * const XJCommonEnsure;
extern NSString * const XJIsMakePhoneCall;

//个人中心
extern NSString * const XJMyInterrogation;
extern NSString * const XJMyDoctors;
extern NSString * const XJMyCollections;
extern NSString * const XJMyAccount;
extern NSString * const XJMyPrescriptions;
extern NSString * const XJMyAttention;
extern NSString * const XJMyBills;
extern NSString * const XJHelpAndFeedback;
extern NSString * const XJPersonalSetting;
extern NSString * const XJClearCache;
extern NSString * const XJAboutUs;
extern NSString * const XJName;
extern NSString * const XJIdCardNumber;
extern NSString * const XJAge;
extern NSString * const XJEmergencyContactPerson;
extern NSString * const XJEmergencyContactPhone;
extern NSString * const XJHomeAddress;
extern NSString * const XJInputRealname;
extern NSString * const XJInputEmergencyContactPhone;
extern NSString * const XJInputSomeInformations;


//登录注册
extern NSString * const XJInputPhoneNumber;
extern NSString * const XJInputPassword;
extern NSString * const XJInputVerificationCode;
extern NSString * const XJInputPasswordAgain;
extern NSString * const XJUserAgreement;
extern NSString * const XJFetchVerificationCode;
extern NSString * const XJInputCorrectPhoneNumberTip;
extern NSString * const XJInputPasswordTip;
extern NSString * const XJPasswordFormatTip;
extern NSString * const XJDifferentPasswordTip;
extern NSString * const XJInputVerificationCodeTip;
extern NSString * const XJCameraNotAvailable;
extern NSString * const XJAppCameraAccessNotAuthorized;
extern NSString * const XJAppPhotoLibraryAccessNotAuthorized;
extern NSString * const XJPleaseUploadAuthenticationPicture;
extern NSString * const XJPleaseInputCorrectIDCardNumber;
extern NSString * const XJFindPassword;
extern NSString * const XJChangePassword;

//NotificationName
extern NSString * const XJLoginSuccess;
extern NSString * const XJSetupUnreadMessagesCount;
extern NSString * const XJConversationsDidChange;
extern NSString * const XJDidReceiveWechatPayResponse;

/**
 *  接口
 */
//1.BaseURL
extern NSString * const BASEAPIURL;

//2.用户相关
extern NSString * const USER_LOGIN;
extern NSString * const USER_REGISTER;
extern NSString * const FETCH_VERIFICATION_CODE;
extern NSString * const FIND_PASSWORD;
extern NSString * const USER_LOGOUT;

//3.首页
extern NSString * const FETCH_DOCTORS_LIST;
extern NSString * const FETCH_DISEASES;
extern NSString * const FETCH_AREAS;
extern NSString * const DOCTOR_DETAIL;
extern NSString * const ADD_ATTENTION;
extern NSString * const CANCEL_ATTENTION;

//4.消息
extern NSString * const FETCH_USERS_NAME;
extern NSString * const FETCH_CONTENT_DETAIL;

//5.个人中心
extern NSString * const EDIT_INFORMATIONS;
extern NSString * const FETCH_CONCERNED_DOCTORS;

//6.处方
extern NSString * const FETCH_PRESCRIPTION_CONTENTS;
extern NSString * const WECHAT_PAY;


