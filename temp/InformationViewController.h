//
//  InformationViewController.h
//  help.ME
//
//  Created by Pulkit Kathuria on 1/23/13.
//  Copyright (c) 2013 Pulkit Kathuria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class MGBox;
@interface InformationViewController : UIViewController <UIScrollViewDelegate, CLLocationManagerDelegate>{
    
    CLLocationManager *LocationManager;
    CLGeocoder *geocoder;
    double place1Long;
    double place1Lat;
    float distanceBetweenTwo;
}

- (MGBox *)parentBoxOf:(UIView *)view;
@end
