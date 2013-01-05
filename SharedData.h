//
//  SharedData.h
//  temp
//
//  Created by Pulkit Kathuria on 11/20/12.
//  Copyright (c) 2012 Pulkit Kathuria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Animations.h"
#import "WCAlertView.h"


#define IS_IPHONE_4 ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_IPOD   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPod touch"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_HEIGHT_GTE_568 )

#define RGBConvert (float) 255

@interface SharedData : UIView {
    NSUserDefaults *userData;

}

+(void)initialNumbersByLocation: (NSUserDefaults *) userData;
+(SharedData *) sharedData;
+ (NSString *) stringToPhone: (NSString *) unformatted;

@property (strong, nonatomic) NSNumber *isEnabledToShowHUD;

@end
