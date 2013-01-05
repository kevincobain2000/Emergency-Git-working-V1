//
//  CustomTextViewController.h
//  temp
//
//  Created by Pulkit Kathuria on 11/4/12.
//  Copyright (c) 2012 Pulkit Kathuria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YIPopupTextView.h"
#import "SharedData.h"

@interface CustomTextViewController : UIViewController <YIPopupTextViewDelegate>{
    NSUserDefaults *userData;
    SharedData *sharedData;
}

@property (strong, nonatomic) IBOutlet UITextView *textView;


@end
