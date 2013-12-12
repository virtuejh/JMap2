//
//  TMConnection.h
//  JMap2
//
//  Created by JAE LEE on 7/26/13.
//  Copyright (c) 2013 JAE LEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardRequest.h"

@interface TMConnection : NSObject
{
    //NSURLConnection *connection;
    //NSString *_countryNumber, *_phoneNumber, *_deviceID;
    
}
@property (strong, nonatomic) NSURLConnection *connection;
//@property (strong, nonatomic) NSString *countryNumber;
//@property (strong, nonatomic) NSString *phoneNumber;
//@property (strong, nonatomic) NSString *deviceID;

+ (id)defaultConnection;

#pragma  mark conversation
- (void)requestWriteTalkMessage:(NSString*)message delegate:(id<ConversationRequestDelegate>)aDelegate;

//- (void)requestActivateCode:(NSString*)userDeviceID delegate:(id)aDelegate;

@end
