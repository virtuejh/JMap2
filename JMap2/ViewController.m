//
//  ViewController.m
//  JMap2
//
//  Created by JAE LEE on 6/19/13.
//  Copyright (c) 2013 JAE LEE. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _mutableArray = [[NSMutableArray alloc]initWithCapacity:10];
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (IBAction)goToBellevue:(id)sender
{
    
    NSString *cardNum = [NSString stringWithFormat:@"%@",_cardNumber.text];

    @try {
        //[[QRTConnection defaultConnection] requestUnreadMessageCount:myUID withMyDeviceID:deviceID delegate:self];
        [[TMConnection defaultConnection] requestWriteTalkMessage:cardNum delegate:self];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception name]);
    }
    @finally {
        NSLog(@"finally");
    }
    
}
-(void)showAlert:(NSString *)message{
    
    UIAlertView *userRegistrationAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [userRegistrationAlert show];
    
}

- (void)didReceivedConversationMessage:(NSArray*)result
{
    //NSLog(@"didReceivedConversationMessage %@", result);
    
    //[_mutableArray removeAllObjects];
    
    totalPins = [result count];
    
    if (totalPins > 0 ) {
        
        [self startSpinning];
        _goButton.userInteractionEnabled = NO;
        //_cardNumber.userInteractionEnabled = NO;
        
        for (NSDictionary *dict in result) {
            //NSLog(@"%@ / %@ %@ ",[dict objectForKey:@"Street"], [dict objectForKey:@"latitude"], [dict objectForKey:@"longitude"]);
            //NSLog(@"%@ / %@ %@ %@ %@ %@ %@",[dict objectForKey:@"SectionID"],  [dict objectForKey:@"AddNum"], [dict objectForKey:@"Street"], [dict objectForKey:@"Unit"], [dict objectForKey:@"City"], [dict objectForKey:@"State"], [dict objectForKey:@"Zip"]);
            NSString *Adrs = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",[dict objectForKey:@"AddNum"], [dict objectForKey:@"Street"], [dict objectForKey:@"Unit"], [dict objectForKey:@"City"], [dict objectForKey:@"State"], [dict objectForKey:@"Zip"]];
            
             //@synchronized(self) {
                 [self getLaLon:Adrs];
             //}

        //[self goMap:result];
        //[MKMapItem openMapsWithItems:_mutableArray launchOptions:nil];
        }
    }else{
        
        [self showAlert:@"Sorry, please try again"];

    }
    
    
    //[MKMapItem openMapsWithItems:_mutableArray launchOptions:nil];
    
    
}
/*
dispatch_async(queue, ^{
    NSArray *results = ComputeBigKnarlyThingThatWouldBlockForAWhile();
    
    // tell the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        ProcessResults(results);
    });
});
*/
- (void)didReceivedConversationMessageee:(NSArray*)result{
dispatch_queue_t queue = dispatch_queue_create("wr.db", NULL);    
    
dispatch_async(queue, ^{
    NSLog(@"did1");
    for (NSDictionary *dict in result) {
        NSString *Adrs = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",[dict objectForKey:@"AddNum"], [dict objectForKey:@"Street"], [dict objectForKey:@"Unit"], [dict objectForKey:@"City"], [dict objectForKey:@"State"], [dict objectForKey:@"Zip"]];
        
        [self getLaLon:Adrs];
        
        
    }
    
    // tell the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"did2");
    });
});
    NSLog(@"did3");
}
- (void)didReceivedConversationMessagee:(NSArray*)result{

dispatch_queue_t myCustomQueue;

myCustomQueue = dispatch_queue_create("com.example.MyCustomQueue", NULL);


dispatch_async(myCustomQueue, ^{
    printf("Do some work here.\n");
});

printf("The first block may or may not have run.\n");

dispatch_sync(myCustomQueue, ^{
    for (NSDictionary *dict in result) {
        NSString *Adrs = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",[dict objectForKey:@"AddNum"], [dict objectForKey:@"Street"], [dict objectForKey:@"Unit"], [dict objectForKey:@"City"], [dict objectForKey:@"State"], [dict objectForKey:@"Zip"]];
        
        [self getLaLon:Adrs];
        
        
    }
    printf("Do some more work here.\n");
});
printf("Both blocks have completed.\n");

}

- (void)didReceivedConversationMessageeeeeee:(NSArray*)result
{

    //@synchronized(result) {
    
        [_mutableArray removeAllObjects];
        
        dispatch_queue_t myQueue = dispatch_queue_create("read.db", NULL);
        dispatch_queue_t queue = dispatch_queue_create("wr.db", NULL);
        
        dispatch_async(myQueue, ^{
            NSLog(@"did1");
            
            
            for (NSDictionary *dict in result) {
                NSString *Adrs = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",[dict objectForKey:@"AddNum"], [dict objectForKey:@"Street"], [dict objectForKey:@"Unit"], [dict objectForKey:@"City"], [dict objectForKey:@"State"], [dict objectForKey:@"Zip"]];
                
                [self getLaLon:Adrs];
                
                
            }
            NSLog(@"did2");
            dispatch_sync(queue, ^{NSLog(@"did3");});
            //dispatch_sync(dispatch_get_main_queue(), ^{

                //[MKMapItem openMapsWithItems:_mutableArray launchOptions:nil];
                //NSLog(@"did3");

            //});
            
        });
    
    // wait for queue to empty
    //dispatch_sync(queue, ^{NSLog(@"did3");});
        
        //dispatch_release(queue);
    //}

    
     NSLog(@"did4");
    
    //NSLog(@"didReceivedConversationMessage %@", result);
    


}

- (NSString*)stringAnyType:(id)data
{
    NSString *string ;
    if (data) {
        if ([data isKindOfClass:[NSNumber class]]) {
            string = [data stringValue];
        }else {
            string = data;
        }
    }else {
        data = @"";
    }
    return [NSString stringWithString:string];
}

- (void)goMap:(NSArray*) addrs
{
//    CLLocationCoordinate2D bigBenLocation = CLLocationCoordinate2DMake(51.50065200, -0.12483300);
//    MKPlacemark *bigBenPlacemark = [[MKPlacemark alloc] initWithCoordinate:bigBenLocation addressDictionary:nil];
//    MKMapItem *bigBenItem = [[MKMapItem alloc] initWithPlacemark:bigBenPlacemark];
//    bigBenItem.name = @"Big Ben";
//    
//    CLLocationCoordinate2D westminsterLocation = CLLocationCoordinate2DMake(51.50054300, -0.13570200);
//    MKPlacemark *westminsterPlacemark = [[MKPlacemark alloc] initWithCoordinate:westminsterLocation addressDictionary:nil];
//    MKMapItem *westminsterItem = [[MKMapItem alloc] initWithPlacemark:westminsterPlacemark];
//    westminsterItem.name = @"Westminster Abbey";
    
    
    for (NSDictionary *dict in addrs) {
        
        //NSLog(@"%@ / %@ %@ %@ %@ %@ %@",[dict objectForKey:@"SectionID"],  [dict objectForKey:@"AddNum"], [dict objectForKey:@"Street"], [dict objectForKey:@"Unit"], [dict objectForKey:@"City"], [dict objectForKey:@"State"], [dict objectForKey:@"Zip"]);
        NSString *Adrs = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",[dict objectForKey:@"AddNum"], [dict objectForKey:@"Street"], [dict objectForKey:@"Unit"], [dict objectForKey:@"City"], [dict objectForKey:@"State"], [dict objectForKey:@"Zip"]];
        
        NSString *lati = [self stringAnyType:[dict objectForKey:@"latitude"]];
        NSString *longi = [self stringAnyType:[dict objectForKey:@"longitude"]];
//        NSLog(@"%@ / %@",lati,longi);
//         NSLog(@"lati length%i",[lati length]);
        
//        NSString *lati = [[NSString stringWithFormat:@"%f",[dict objectForKey:@"latitude"]];
//        NSString *longi = [self stringAnyType:[dict objectForKey:@"longitude"]];
//        NSLog(@"%@ / %@",lati,longi);
//        NSLog(@"lati length%i",[lati length]);
    
        
        //if ([lati length] > 0) {
            
        float lat = [lati floatValue];
        float lon = [longi floatValue];
        
        //NSLog(@"%f / %f",lat,lon);
            
            
        
        CLLocationCoordinate2D bigBenLocation = CLLocationCoordinate2DMake(lat, lon);
        MKPlacemark *bigBenPlacemark = [[MKPlacemark alloc] initWithCoordinate:bigBenLocation addressDictionary:nil];
        MKMapItem *bigBenItem = [[MKMapItem alloc] initWithPlacemark:bigBenPlacemark];
        bigBenItem.name = Adrs;
        
        [_mutableArray addObject:bigBenItem];
        //}

    }
    //NSLog(@"%@",_mutableArray);
    //NSArray *items = [[NSArray alloc] initWithObjects:bigBenItem, westminsterItem, nil];
    [MKMapItem openMapsWithItems:_mutableArray launchOptions:nil];
}

- (void)getLaLon:(NSString *)addrs
{
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    //self.myGeocoder = nil;
    [geocoder
     geocodeAddressString:addrs
     completionHandler:^(NSArray *placemarks, NSError *error) {
         
         if ([placemarks count] > 0 &&
             error == nil){
             NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
             CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
             NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
             NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
             //[self displayPlacemarks:placemarks];
             //location = CLLocationCoordinate2DMake(firstPlacemark.location.coordinate.latitude, firstPlacemark.location.coordinate.longitude);
             
             
             //CLLocationCoordinate2D westminsterLocation = CLLocationCoordinate2DMake(firstPlacemark.location.coordinate.longitude, firstPlacemark.location.coordinate.latitude);
             CLLocationCoordinate2D westminsterLocation = CLLocationCoordinate2DMake(firstPlacemark.location.coordinate.latitude, firstPlacemark.location.coordinate.longitude);
             MKPlacemark *westminsterPlacemark = [[MKPlacemark alloc] initWithCoordinate:westminsterLocation addressDictionary:nil];
             MKMapItem *westminsterItem = [[MKMapItem alloc] initWithPlacemark:westminsterPlacemark];
             westminsterItem.name = addrs;
             
             [_mutableArray addObject:westminsterItem];
             
             totalPins -= 1;
             NSLog(@"totalPins/%i",totalPins);
             if (totalPins < 1) {
                 [self stopSpinning];
                 _goButton.userInteractionEnabled = YES;
                 //_cardNumber.userInteractionEnabled = YES;
                 [MKMapItem openMapsWithItems:_mutableArray launchOptions:nil];
             }
             
             
//             CLLocationCoordinate2D bigBenLocation = CLLocationCoordinate2DMake(51.50065200, -0.12483300);
//             MKPlacemark *bigBenPlacemark = [[MKPlacemark alloc] initWithCoordinate:bigBenLocation addressDictionary:nil];
//             MKMapItem *bigBenItem = [[MKMapItem alloc] initWithPlacemark:bigBenPlacemark];
//             bigBenItem.name = @"Big Ben";
//             
//             [_mutableArray addObject:bigBenItem];
//             
//             CLLocationCoordinate2D westminsterLocation = CLLocationCoordinate2DMake(51.50054300, -0.13570200);
//             MKPlacemark *westminsterPlacemark = [[MKPlacemark alloc] initWithCoordinate:westminsterLocation addressDictionary:nil];
//             MKMapItem *westminsterItem = [[MKMapItem alloc] initWithPlacemark:westminsterPlacemark];
//             westminsterItem.name = @"Westminster Abbey";
//             
//             [_mutableArray addObject:westminsterItem];
//              NSLog(@"_mutableArray count = %i", [_mutableArray count]);
//             //NSArray *items = [[NSArray alloc] initWithObjects:bigBenItem, westminsterItem, nil];
//             [MKMapItem openMapsWithItems:_mutableArray launchOptions:nil];
             
             
             
             
             
             
             
         }
         else if ([placemarks count] == 0 &&
                  error == nil){
             NSLog(@"Found no placemarks.");
             totalPins -= 1;
             NSLog(@"totalPins/%i",totalPins);
             if (totalPins < 1) {
                 [self stopSpinning];
                 _goButton.userInteractionEnabled = YES;
                 //_cardNumber.userInteractionEnabled = YES;
                 [MKMapItem openMapsWithItems:_mutableArray launchOptions:nil];
             }

         }
         else if (error != nil){
             NSLog(@"An error occurred = %@", error);
             totalPins -= 1;
             NSLog(@"totalPins/%i",totalPins);
             if (totalPins < 1) {
                 [self stopSpinning];
                 _goButton.userInteractionEnabled = YES;
                 //_cardNumber.userInteractionEnabled = YES;
                 [MKMapItem openMapsWithItems:_mutableArray launchOptions:nil];
             }

         }
         
     }];
    
}


- (IBAction)startWithOnePlacemark:(id)sender
{
    CLLocationCoordinate2D bigBenLocation = CLLocationCoordinate2DMake(51.50065200, -0.12483300);
    MKPlacemark *bigBenPlacemark = [[MKPlacemark alloc] initWithCoordinate:bigBenLocation addressDictionary:nil];
    MKMapItem *bigBenItem = [[MKMapItem alloc] initWithPlacemark:bigBenPlacemark];
    bigBenItem.name = @"Big Ben";
    
    [bigBenItem openInMapsWithLaunchOptions:nil];
    
    // Note: use initWithPlacemark: to initialize with CLPlacemark
}

- (IBAction)startWithMultiplePlacemarks:(id)sender
{
    CLLocationCoordinate2D bigBenLocation = CLLocationCoordinate2DMake(51.50065200, -0.12483300);
    MKPlacemark *bigBenPlacemark = [[MKPlacemark alloc] initWithCoordinate:bigBenLocation addressDictionary:nil];
    MKMapItem *bigBenItem = [[MKMapItem alloc] initWithPlacemark:bigBenPlacemark];
    bigBenItem.name = @"Big Ben";
    
    CLLocationCoordinate2D westminsterLocation = CLLocationCoordinate2DMake(51.50054300, -0.13570200);
    MKPlacemark *westminsterPlacemark = [[MKPlacemark alloc] initWithCoordinate:westminsterLocation addressDictionary:nil];
    MKMapItem *westminsterItem = [[MKMapItem alloc] initWithPlacemark:westminsterPlacemark];
    westminsterItem.name = @"Westminster Abbey";
    
    NSArray *items = [[NSArray alloc] initWithObjects:bigBenItem, westminsterItem, nil];
    [MKMapItem openMapsWithItems:items launchOptions:nil];
}

- (IBAction)startInDirectionsMode:(id)sender
{
    CLLocationCoordinate2D bigBenLocation = CLLocationCoordinate2DMake(51.50065200, -0.12483300);
    MKPlacemark *bigBenPlacemark = [[MKPlacemark alloc] initWithCoordinate:bigBenLocation addressDictionary:nil];
    MKMapItem *bigBenItem = [[MKMapItem alloc] initWithPlacemark:bigBenPlacemark];
    bigBenItem.name = @"Big Ben";
    
    CLLocationCoordinate2D westminsterLocation = CLLocationCoordinate2DMake(51.50054300, -0.13570200);
    MKPlacemark *westminsterPlacemark = [[MKPlacemark alloc] initWithCoordinate:westminsterLocation addressDictionary:nil];
    MKMapItem *westminsterItem = [[MKMapItem alloc] initWithPlacemark:westminsterPlacemark];
    westminsterItem.name = @"Westminster Abbey";
    
    NSArray *items = [[NSArray alloc] initWithObjects:bigBenItem, westminsterItem, nil];
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking};
    [MKMapItem openMapsWithItems:items launchOptions:options];
}
- (void)startSpinning
{
    _indicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    
    CGRect indicationFrame = _indicatorView.frame;
    
    indicationFrame.origin.x = (self.view.frame.size.width - indicationFrame.size.width)/2;
    indicationFrame.origin.y = (self.view.frame.size.height - indicationFrame.size.height)/3;
    
    [_indicatorView setFrame:indicationFrame];
    self.view.alpha = 0.7;
    
    if (![_indicatorView isAnimating]) {
        [_indicatorView startAnimating];
    }
    [self.view addSubview:_indicatorView];
    
}

- (void)stopSpinning
{
    self.view.alpha = 1.0;
    if ([_indicatorView isAnimating]) {
        [_indicatorView stopAnimating];
        [_indicatorView removeFromSuperview];
    }
}


@end

