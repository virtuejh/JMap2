//
//  TMConnection.m
//  JMap2
//
//  Created by JAE LEE on 7/26/13.
//  Copyright (c) 2013 JAE LEE. All rights reserved.
//

#import "TMConnection.h"

@implementation TMConnection

static id instance = nil;

+ (id)defaultConnection
{
    @synchronized(self) {
        if(instance == nil) {
            instance = [[TMConnection alloc] init];
        }
        return instance;
    }
}

- (id)init {
    
    self = [super init];
    if (self) {
        instance = self;
    }
    
    return self;
}

#pragma mark Conversation
// 대화 내용을 서버로 보냅니다.
- (void)requestWriteTalkMessage:(NSString*)message delegate:(id)aDelegate
{
    CardRequest *conversation = [[CardRequest alloc]init];
    [conversation requestActivateCode:message delegate:aDelegate];

    
}
@end
