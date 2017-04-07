//
//  EMCallViewController.h
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 22/11/2016.
//  Copyright © 2016 XieYajie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DemoCallManager.h"

@interface EMCallViewController : UIViewController


@property (strong, nonatomic, readonly) EMCallSession *callSession;

@property (nonatomic) BOOL isDismissing;

@property (copy, nonatomic) void (^timeBlock)(NSInteger time);

- (instancetype)initWithCallSession:(EMCallSession *)aCallSession;

- (void)stateToConnected;

- (void)stateToAnswered;

- (void)clearData;


@end
