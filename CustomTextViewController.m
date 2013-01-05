//
//  CustomTextViewController.m
//  temp
//
//  Created by Pulkit Kathuria on 11/4/12.
//  Copyright (c) 2012 Pulkit Kathuria. All rights reserved.
//

#import "CustomTextViewController.h"

@interface CustomTextViewController ()

@end

@implementation CustomTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sharedData = [SharedData sharedData];
    
    userData = [NSUserDefaults standardUserDefaults];
    
   
    self.textView.text = [NSString stringWithFormat:@"%@",[userData objectForKey:@"EmergencyMessage"]];
    //self.textView.text = NSLocalizedString(@"I am in need of help ASAP. I am currently at -", @"Emergency Text");
    
    YIPopupTextView* popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"input here" maxCount:300];
    popupTextView.delegate = self;
    popupTextView.showCloseButton = YES;
    popupTextView.caretShiftGestureEnabled = YES;   // default = NO
    popupTextView.text = self.textView.text;
    [popupTextView showInView:self.view];
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -

#pragma mark YIPopupTextViewDelegate

- (void)popupTextView:(YIPopupTextView *)textView willDismissWithText:(NSString *)text
{
    self.textView.text = text;

    [userData setObject:text forKey:@"EmergencyMessage"];
    [userData synchronize];
    sharedData.isEnabledToShowHUD = @YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)popupTextView:(YIPopupTextView *)textView didDismissWithText:(NSString *)text
{
    
    
}



@end
