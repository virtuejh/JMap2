//
//  CardRequest.m
//  JMap2
//
//  Created by JAE LEE on 7/26/13.
//  Copyright (c) 2013 JAE LEE. All rights reserved.
//12/11/13 111

#import "CardRequest.h"

@implementation CardRequest

@synthesize delegate = _delegate;

//1.SendMessageByConversation
//#define FAKE_URL @"http://ec2-54-214-91-109.us-west-2.compute.amazonaws.com/gh/terr3.php"
#define FAKE_URL @"http://ec2-54-203-59-203.us-west-2.compute.amazonaws.com/gh/terr3.php"
//static NSString *GroupConversationWriteRequestURL = @"https://devtalksvc.qrobo.com/MessageService/SendMessageByConversation.ashx";

//-(NSString*)GroupConversationWriteRequestURL
//{
//    return GroupConversationWriteRequestURL;
//}


//1.SendMessageByConversation
- (void)requestActivateCode:(NSString*)userDeviceID delegate:(id)aDelegate;
{
    //_requestType = ConversationWrite;
    
	//NSURL *url = [NSURL URLWithString: [urlArray objectAtIndex:[which intValue]]];
    //NSString * req = [NSString stringWithFormat:@"%@?item=%@",FAKE_URL,@"KR012"];
    NSString * req = [NSString stringWithFormat:@"%@?item=%@",FAKE_URL,userDeviceID];
    
    NSURL *url = [NSURL URLWithString:req];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
	//NSURLResponse *response;
	//NSError *error;
    //NSData* result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    
    NSURLConnection *connectionDeviceAuthentication = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (connectionDeviceAuthentication != nil) {
        self.delegate = aDelegate;
        //[self retain];
        _mutableResult = [[NSMutableData alloc]init];
        
    }else {
        //[[NSNotificationCenter defaultCenter]postNotificationName:ConversationRequestWritingFailedNotification object:nil];
        
        @throw [NSException exceptionWithName:@"ImageServerError" reason:@"Can't Open Network" userInfo:nil];
    }
    
}

#pragma mark -
#pragma mark URL Connection Informal Protocol

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mutableResult appendData:data];
    NSString *responsestring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"responsestring     %@", responsestring);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    //[aConnection release];
    
    NSData *data = [NSData dataWithData: _mutableResult];
    NSArray *conversationArray = [self conversationArrayWithData:data];
    for (NSDictionary *dict in conversationArray) {
        
        //NSLog(@"%@ / %@ %@ ",[dict objectForKey:@"Street"], [dict objectForKey:@"latitude"], [dict objectForKey:@"longitude"]);
       // NSLog(@"%@ / %@ %@ %@ %@ %@ %@",[dict objectForKey:@"SectionID"],  [dict objectForKey:@"AddNum"], [dict objectForKey:@"Street"], [dict objectForKey:@"Unit"], [dict objectForKey:@"City"], [dict objectForKey:@"State"], [dict objectForKey:@"Zip"]);
 
    }
    
    
    
    if([(NSObject*)_delegate respondsToSelector:@selector(didReceivedConversationMessage:)]) {
        [(NSObject*)_delegate performSelector:@selector(didReceivedConversationMessage:) withObject:conversationArray];
    }
    //[_mutableResult release];
    
    //[(NSObject*)_delegate release];
    
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");

    //[aConnection release];
    //[_mutableResult release];
    _mutableResult = nil;
    
    if([(NSObject*)_delegate respondsToSelector:@selector(didReceivedConversationMessage:)]) {
        [(NSObject*)_delegate performSelector:@selector(didReceivedConversationMessage:) withObject:nil];
    }
    //[self notifyFailedWithResult:nil];
    
    
    //[(NSObject*)_delegate release];
}

- (NSArray*)conversationArrayWithData:(NSData*)data
{
    //@synchronized(self) {
        NSArray *conversationArray = [[NSArray alloc]init];
        
        if ( data != nil && [data length] != 0 ) {
            NSError *e;
            NSMutableArray *dataResults =  [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
            //NSLog(@"dataResults     %@", dataResults);
            //NSLog(@"dict     %@", dataResults);
            if (dataResults == nil) {
                //Json 변경 실패
                return nil;
            }
            
            if ([dataResults isKindOfClass:[NSMutableArray class]]) {
                //딕트가 어레이로 오는 타입인지 확인해 보고,
                for (NSDictionary *dict in dataResults) {
                    
                    //NSError *e;
                    //NSArray *dResults =  [NSJSONSerialization JSONObjectWithData: dict options: NSJSONReadingMutableContainers error: &e];
                    //for (NSDictionary *dic in dResults) {
                    //NSLog(@"%@ / %@ %@ %@ %@ %@ %@",[dict objectForKey:@"SectionID"],  [dict objectForKey:@"AddNum"], [dict objectForKey:@"Street"], [dict objectForKey:@"Unit"], [dict objectForKey:@"City"], [dict objectForKey:@"State"], [dict objectForKey:@"Zip"]);
                    
                    //}
                    //NSLog(@"dict     %@", dict);
                    //NSLog(@"dict     %@", dResults);
                    
                    //NSLog(@"dict     %@", [dict objectForKey:@"Street"]);
                    
                    //NSDictionary *dit = [NSDictionary dictionaryWithDictionary:dict];
                    //[conversationMutableArray addObject:dict];
                    conversationArray = [NSArray arrayWithArray:dataResults];
                }
                
            }else {
                //아니라면 딕트 하나로 처리한다.
                NSLog(@"dict");
                
            }
        }
        
        //NSArray *conversationArray = [NSArray arrayWithArray:conversationMutableArray];
        //[conversationMutableArray release];
        
        return conversationArray;
    //}
}



@end
