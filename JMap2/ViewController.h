//
//  ViewController.h
//  JMap2
//
//  Created by JAE LEE on 6/19/13.
//  Copyright (c) 2013 JAE LEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TMConnection.h"

@interface ViewController : UIViewController <ConversationRequestDelegate>
{
    int totalPins;
}

@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) NSMutableArray *mutableArray;

- (IBAction)startWithOnePlacemark:(id)sender;
- (IBAction)startWithMultiplePlacemarks:(id)sender;
- (IBAction)startInDirectionsMode:(id)sender;

- (IBAction)goToBellevue:(id)sender;


@end
