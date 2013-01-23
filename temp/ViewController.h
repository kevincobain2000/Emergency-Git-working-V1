//
//  ViewController.h
//  temp
//
//  Created by Pulkit Kathuria on 10/30/12.
//  Copyright (c) 2012 Pulkit Kathuria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedData.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AVFoundation/AVFoundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "MTAnimatedLabel.h"
#define OSVERSION [[UIDevice currentDevice].systemVersion floatValue]
#if defined(OSVERSION) >= 6
#import <Social/Social.h>
#endif
#define SCROLL_HEIGHT 620
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController : UIViewController <UIAlertViewDelegate, UIScrollViewDelegate, ABPeoplePickerNavigationControllerDelegate, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>{
    NSUserDefaults *userData;
    SharedData *sharedData;
    //UIView *dimView;
    NSMutableString *emergencyText;
    

    
}

@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLGeocoder *geoCoder;
-(void) myLocationMethod;
-(void)getEmergencyText;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)buttonInfoPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *buttonFlashLightOutlet;


@property (strong, nonatomic) IBOutlet UIButton *buttonCallPersonOutlet;

@property (strong, nonatomic) IBOutlet UIButton *buttonCallPoliceOutlet;

@property (strong, nonatomic) IBOutlet UIButton *buttonCallHospitalOutlet;

@property (strong, nonatomic) IBOutlet UIButton *buttonCallFireOutlet;







-(void) adjustingFontSizesForLanguages: (UIButton *) button;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *barItemSettingsOutlet;
@property (strong, nonatomic) IBOutlet UIView *viewPolice;
- (IBAction)buttonSMSPressed:(id)sender;


@property (strong, nonatomic) IBOutlet UIImageView *imageViewContactPerson;
@property (strong, nonatomic) IBOutlet UILabel *labelFirstName;
@property (strong, nonatomic) IBOutlet UILabel *labelLastName;
@property (strong, nonatomic) IBOutlet UILabel *labelContactPersonNumber;
@property (strong, nonatomic) IBOutlet UIButton *buttonSoundOutlet;

- (IBAction)buttonSoundPressed:(id)sender;
- (IBAction)buttonChooseContactPressed:(id)sender;
- (IBAction)buttonPersonCallPressed:(id)sender;
- (IBAction)buttonPoliceCallPressed:(id)sender;
- (IBAction)buttonFireCallPressed:(id)sender;
- (IBAction)buttonHospitalCallPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *labelEmailAddress;





@property (strong, nonatomic) IBOutlet UIButton *buttonFlashOutlet;
- (IBAction)buttonFlashPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *buttonChooseContactOutlet;
@property (strong, nonatomic) IBOutlet UIButton *buttonChooseContactIcon;

@property (strong, nonatomic) IBOutlet MTAnimatedLabel *labelContactsHeaderOutlet;

- (IBAction)buttonEmailPressed:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *labelPoliceNumber;
@property (strong, nonatomic) IBOutlet UILabel *labelFireNumber;
@property (strong, nonatomic) IBOutlet UILabel *labelHospitalNumber;
- (void) animateLabelAndButton:(MTAnimatedLabel *) labelHeader andButton:(UIView *) theView;
@property (nonatomic) BOOL audioIsOn;
@property (nonatomic) AVAudioPlayer *audioPlayer;

@property (nonatomic) BOOL flashIsOn;
@property (nonatomic) BOOL dimViewIsOn;
@property (strong, nonatomic) IBOutlet UIButton *buttonFacebookOutlet;
- (IBAction)buttonFacebookPressed:(id)sender;
- (void) invokeSocialService: (NSString *) serviceType;
-(void) invokeCallNumber:(NSString *)telephoneNumber;
@property (strong, nonatomic) IBOutlet MTAnimatedLabel *labelSocialHeader;
@property (strong, nonatomic) IBOutlet UIButton *buttonTwitterOutlet;
- (IBAction)buttonTwitterPressed:(id)sender;


@property (strong, nonatomic) IBOutlet MTAnimatedLabel *labelGadgetsHeader;
-(void)animateGadgetsHeader;
-(void) settingTheBackgrounds;
-(void)settingScrollViewSize;
-(void)settingUserDefaults;
-(void) allocatingMemory;
-(void)settingTextInLabels;
@end
