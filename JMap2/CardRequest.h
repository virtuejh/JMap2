//
//  CardRequest.h
//  JMap2
//
//  Created by JAE LEE on 7/26/13.
//  Copyright (c) 2013 JAE LEE. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SSLBasic.h"

//static NSString* RegisteringDeviceSuccessNotification = @"RegisteringDeviceSuccessNotification";
//static NSString* RegisteringDeviceFailedNotification = @"RegisteringDeviceFailedNotification";

@protocol ConversationRequestDelegate
- (void)didReceivedConversationMessage:(NSArray*)result;
@end

typedef enum {
    ConversationWrite,
    ConversationRead,
}ConversationRequestType;


@interface CardRequest : NSObject
//@interface InstallRequest : SSLBasic
{
    id <ConversationRequestDelegate> _delegate;
    ConversationRequestType _requestType;
    //NSMutableData *_mutableResult;
    //NSString *_myUserID;
}

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSString *myUserID;
@property (strong, nonatomic) NSMutableData *mutableResult;

//1. 전화번호로 사용자 임시 등록
//- (void)requestRegisteringDeviceWithMyPhoneNumber:(NSString*)myPhoneNumber countryCode:(NSString*)myCC deviceToken:(NSString*)d_Token deviceType:(NSString*)d_Type delegate:(id)aDelegate;

//2. 액티베이션 코드 재전송 요청
- (void)requestActivateCode:(NSString*)userDeviceID delegate:(id)aDelegate;


@end
