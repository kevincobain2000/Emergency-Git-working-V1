//
//  InformationViewController.h
//  help.ME
//
//  Created by Pulkit Kathuria on 1/23/13.
//  Copyright (c) 2013 Pulkit Kathuria. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGBox;
@interface InformationViewController : UIViewController <UIScrollViewDelegate>

- (MGBox *)parentBoxOf:(UIView *)view;
@end
