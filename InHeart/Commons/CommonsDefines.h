//
//  CommonsDefines.h
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//
#import <UIKit/UIKit.h>

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
extern NSString * const KEYCHAINSERVICE;
/**
 *  常用数值
 */
extern CGFloat const TABBARHEIGHT;
extern CGFloat const NAVIGATIONBARHEIGHT;

//内容
extern NSString * const kSearchPlaceholder;
extern NSString * const kNetworkError;

//消息
extern NSString * const kClickToLogin;
extern NSString * const kCommonTip;
extern NSString * const kCommonCancel;
extern NSString * const kCommonEnsure;
extern NSString * const kIsMakePhoneCall;

//个人中心
extern NSString * const kMyInterrogation;
extern NSString * const kMyDoctors;
extern NSString * const kMyCollections;
extern NSString * const kMyAccount;
extern NSString * const kMyPrescriptions;
extern NSString * const kMyAttention;
extern NSString * const kMyBills;
extern NSString * const kHelpAndFeedback;
extern NSString * const kPersonalSetting;
extern NSString * const kClearCache;
extern NSString * const kAboutUs;
extern NSString * const kName;
extern NSString * const kIdCardNumber;
extern NSString * const kAge;
extern NSString * const kEmergencyContactPerson;
extern NSString * const kEmergencyContactPhone;
extern NSString * const kHomeAddress;
extern NSString * const kInputRealname;
extern NSString * const kInputEmergencyContactPhone;
extern NSString * const kInputSomeInformations;


//登录注册
extern NSString * const kInputPhoneNumber;
extern NSString * const kInputPassword;
extern NSString * const kInputVerificationCode;
extern NSString * const kInputPasswordAgain;
extern NSString * const kUserAgreement;
extern NSString * const kFetchVerificationCode;
extern NSString * const kInputCorrectPhoneNumberTip;
extern NSString * const kInputPasswordTip;
extern NSString * const kPasswordFormatTip;
extern NSString * const kDifferentPasswordTip;
extern NSString * const kInputVerificationCodeTip;
extern NSString * const kCameraNotAvailable;
extern NSString * const kAppCameraAccessNotAuthorized;
extern NSString * const kAppPhotoLibraryAccessNotAuthorized;
extern NSString * const kPleaseUploadAuthenticationPicture;
extern NSString * const kPleaseInputCorrectIDCardNumber;
extern NSString * const kFindPassword;
extern NSString * const kChangePassword;

//NotificationName
extern NSString * const kLoginSuccess;
extern NSString * const kSetupUnreadMessagesCount;
extern NSString * const kConversationsDidChange;

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


