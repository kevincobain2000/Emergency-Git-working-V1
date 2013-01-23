//
//  ViewController.m
//  temp
//
//  Created by Pulkit Kathuria on 10/30/12.
//  Copyright (c) 2012 Pulkit Kathuria. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self settingTheBackgrounds];
    [self settingScrollViewSize];
    [self allocatingMemory];
    
    //Repeating the Location Method
    //[self myLocationMethod];
    //dimView = [[UIView alloc] initWithFrame:CGRectMake(0, -100, 320, SCROLL_HEIGHT+200)];
    
    //Use the Following if needs the shared data but we are using NSUserDefaults
    sharedData = [SharedData sharedData];
    

}


-(void)viewWillAppear:(BOOL)animated{

    //User Data Country code is first set by the location
    self.locationManager = [[CLLocationManager alloc] init];
    [self myLocationMethod];
    //If the user doesn't allow the app for location services then it chooses from Locale
    emergencyText = [[NSMutableString alloc] initWithString:NSLocalizedString([userData objectForKey:@"EmergencyMessage"], [userData objectForKey:@"EmergencyMessage"])];
    //For more see SharedData.m
    [self settingUserDefaults];

    if ([ NSLocalizedString([userData objectForKey:@"EmergencyContactPersonNumber"], @"Choose Contact") isEqualToString:NSLocalizedString(@"Choose Contact", @"Choose Contact") ])  {
        self.buttonChooseContactOutlet.hidden = NO;
        self.buttonChooseContactIcon.hidden = NO;
    }
    else{
        self.buttonChooseContactOutlet.hidden = YES;
        self.buttonChooseContactIcon.hidden = YES;
    }
   
    [self settingTextInLabels];
    if ([userData objectForKey:@"EmergencyContactPersonImageData"] != NULL){
        UIImage *contactImage = [ [UIImage alloc] initWithData:[userData objectForKey:@"EmergencyContactPersonImageData"] ];
        self.imageViewContactPerson.image = contactImage;
        self.imageViewContactPerson.contentMode = UIViewContentModeScaleToFill;
    }
    else{
        self.imageViewContactPerson.image = [UIImage imageNamed:@"image_contact_128.png"];
        //self.imageViewContactPerson.contentMode = UIViewContentModeCenter;
    }
    //[Animations frameAndShadow:self.imageViewContactPerson andFrameColor:[UIColor whiteColor]];
    
    [self getEmergencyText];

}

#pragma mark Location Method
-(void) myLocationMethod{
    
    
    self.geoCoder = [[CLGeocoder alloc] init];
    self.locationManager.delegate=self;
    
    //Get user location
    [self.locationManager startUpdatingLocation];
    [self.geoCoder reverseGeocodeLocation: self.locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //Get nearby address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         
         //Print the location to console
         //NSLog(@"I am currently at %@",locatedAt);
         if (locatedAt) {
             [userData setObject:locatedAt forKey:@"CurrentLocation"];
         }
         /*
         NSString *countryCodeByLocation = [placemark.addressDictionary valueForKey:@"CountryCode"];
         NSString *countryNameByLocation = placemark.country;
         [userData setObject:countryNameByLocation forKey:@"CountryName"];
         [userData setObject:countryCodeByLocation forKey:@"CountryCode"];
          */
         [userData synchronize];
         
         //Set the label text to current location
     }];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    
    if (locationAge > 5.0) return;
    
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    if (newLocation.horizontalAccuracy > 0.0f &&
		newLocation.horizontalAccuracy < 120.0f) {
        // roughly an accuracy of 120 meters, we can adjust this.
        
        [self myLocationMethod];
    }
    else{
         [self.locationManager stopUpdatingLocation];
    }
}
-(void)getEmergencyText{
    
 
    //[self myLocationMethod];

    if ([userData objectForKey:@"CurrentLocation"] && [[userData objectForKey:@"AddLocation"] isEqualToString:@"YES"]) {
        [emergencyText appendString:@"\n"];
        [emergencyText appendString:[userData objectForKey:@"CurrentLocation"]];
    }
    NSLog(@"%@",emergencyText);
}

-(void) allocatingMemory{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/beep.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.numberOfLoops = 1000;
    [self.audioPlayer prepareToPlay];
}
#pragma mark Scroll View
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    /*
    //Switching off the DIM View
    if(self.dimViewIsOn){
        dimView.backgroundColor = [UIColor blackColor];
        dimView.alpha = 0.45f;
        [UIView beginAnimations:@"fade" context:nil];
        [UIView setAnimationDuration:1.5f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        dimView.alpha = 0.0f;
        [UIView commitAnimations];
        self.dimViewIsOn = NO;

    }
     */
     
}
- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (!self.dimViewIsOn) {
        //[dimView removeFromSuperview];
    }

}

-(void)settingScrollViewSize{
    if (IS_HEIGHT_GTE_568){
        self.scrollView.contentSize = CGSizeMake(320, SCROLL_HEIGHT-30);
    }
    else{
        self.scrollView.contentSize = CGSizeMake(320, SCROLL_HEIGHT);
    }
}


#pragma mark Setting UserDefaults

-(void)settingUserDefaults{
    userData = [NSUserDefaults standardUserDefaults];

    if (![userData objectForKey:@"Police"] && ![userData objectForKey:@"Fire"] && ![userData objectForKey:@"Hospital"]){
        [SharedData initialNumbersByLocation:userData];
    }
}


-(void)settingTextInLabels{
    
    self.labelEmailAddress.text = [[userData objectForKey:@"EmergencyContactPersonEmails"] objectAtIndex:0];
    self.labelFirstName.text = NSLocalizedString([userData objectForKey:@"EmergencyContactPersonFirstName"], @"First") ;
    self.labelLastName.text = NSLocalizedString([userData objectForKey:@"EmergencyContactPersonLastName"], @"Last");
    self.labelContactPersonNumber.text = NSLocalizedString([userData objectForKey:@"EmergencyContactPersonNumber"], @"Choose Contact");
    self.labelPoliceNumber.text = [SharedData stringToPhone:[userData objectForKey:@"Police"]];
    self.labelFireNumber.text = [SharedData stringToPhone:[userData objectForKey:@"Fire"]];
    self.labelHospitalNumber.text = [SharedData stringToPhone:[userData objectForKey:@"Hospital"]];
    //Font Size Changed for iOS 5
    self.labelContactPersonNumber.font=[self.labelContactPersonNumber.font fontWithSize:12];
    self.labelEmailAddress.font=[self.labelEmailAddress.font fontWithSize:12];
    self.labelPoliceNumber.font=[self.labelPoliceNumber.font fontWithSize:12];
    self.labelFireNumber.font=[self.labelFireNumber.font fontWithSize:12];
    self.labelHospitalNumber.font=[self.labelHospitalNumber.font fontWithSize:12];
    self.labelSocialHeader.font = [self.labelSocialHeader.font fontWithSize:14];
    self.labelContactsHeaderOutlet.font = [self.labelContactsHeaderOutlet.font fontWithSize:14];
    self.labelGadgetsHeader.font = [self.labelGadgetsHeader.font fontWithSize:14];
    //Setting Size of Font for different languages
    [self adjustingFontSizesForLanguages:self.buttonCallPersonOutlet];
    [self adjustingFontSizesForLanguages:self.buttonCallPoliceOutlet];
    [self adjustingFontSizesForLanguages:self.buttonCallFireOutlet];
    [self adjustingFontSizesForLanguages:self.buttonCallHospitalOutlet];
     
    
}

-(void) adjustingFontSizesForLanguages: (UIButton *) button{
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    //button.titleLabel.lineBreakMode = UILineBreakModeClip;
    
}
-(void) settingTheBackgrounds{
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigationBarLogo.png"]];
    self.navigationItem.titleView = img;
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    
    
}
#pragma mark Buttons Pressed Actions
- (IBAction)buttonFlashPressed:(id)sender {
    
    
    //Move THIS INTO Flas is on condition
    
    
    
    if(self.flashIsOn)//flash is On
    {
        
        //turn off flash
        AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
        {
            BOOL success = [flashLight lockForConfiguration:nil];
            if(success)
            {
                [flashLight setTorchMode:AVCaptureTorchModeOff]; //turn off
                [flashLight unlockForConfiguration];
                self.flashIsOn = FALSE;
                NSLog(@"Turn off torch");
                self.buttonFlashOutlet.imageView.animationRepeatCount = 0;

                [self.buttonFlashOutlet setBackgroundImage:[UIImage imageNamed:@"red_push.png"] forState:UIControlStateNormal];
                //[self.buttonFlashOutlet setBackgroundImage:[UIImage imageNamed:@"ipad-button-grey-pressed.png"] forState:UIControlStateHighlighted];
                
            }
        }
    }
    else //flash is off
    {
        /*
        //Turn On the Dim View
        dimView.backgroundColor = [UIColor blackColor];
        dimView.alpha = 0.0f;
        [self.scrollView insertSubview:dimView atIndex:11];
        [UIView beginAnimations:@"fade" context:nil];
        [UIView setAnimationDuration:2.0f];
        [UIView setAnimationDelegate:self];
        dimView.alpha = 0.45f;
        [UIView commitAnimations];
        self.dimViewIsOn = YES;
         */
        //turn on flash
        AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
        {
            BOOL success = [flashLight lockForConfiguration:nil];
            if(success)
            {
                [flashLight setTorchMode:AVCaptureTorchModeOn]; //turn on
                [flashLight unlockForConfiguration];
                self.flashIsOn = YES;
                NSLog(@"Turn on torch");
                self.buttonFlashOutlet.imageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"flashlight-low.png"],[UIImage imageNamed:@"flashlight-hi.png"], nil];
                self.buttonFlashOutlet.imageView.animationDuration = 2.0;
                [self.buttonFlashOutlet.imageView startAnimating];
                [self.buttonFlashOutlet setBackgroundImage:[UIImage imageNamed:@"green_push.png"] forState:UIControlStateNormal];
                //[self.buttonFlashOutlet setBackgroundImage:[UIImage imageNamed:@"ipad-button-green-pressed.png"] forState:UIControlStateHighlighted];
            }
        }
        
    }
    [self animateGadgetsHeader];

}
- (IBAction)buttonSoundPressed:(id)sender {
    
    if(!self.audioIsOn)
    {
        self.audioIsOn=YES;
        NSLog(@"Audio On");
        [self.buttonSoundOutlet setBackgroundImage:[UIImage imageNamed:@"green_push.png"] forState:UIControlStateNormal];
        //[self.buttonSoundOutlet setBackgroundImage:[UIImage imageNamed:@"ipad-button-green-pressed.png"] forState:UIControlStateHighlighted];
        self.buttonSoundOutlet.imageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"volume_128b_1.png"],[UIImage imageNamed:@"volume_128b_2.png"],[UIImage imageNamed:@"volume_128b_3.png"],[UIImage imageNamed:@"volume_128b_4.png"], nil];
        self.buttonSoundOutlet.imageView.animationDuration = 2.0;
        [self.buttonSoundOutlet.imageView startAnimating];
        [self.audioPlayer play];
    }
    else
    {
        NSLog(@"Audio Off");
        [self.buttonSoundOutlet setBackgroundImage:[UIImage imageNamed:@"red_push.png"] forState:UIControlStateNormal];
        //[self.buttonSoundOutlet setBackgroundImage:[UIImage imageNamed:@"ipad-button-grey-pressed.png"] forState:UIControlStateHighlighted];
        //self.audioPlayer.numberOfLoops = -1;
        self.buttonSoundOutlet.imageView.animationRepeatCount = 0;
        [self.audioPlayer stop];
        self.audioIsOn = NO;
        
    }
    [self animateGadgetsHeader];
    
}

- (IBAction)buttonChooseContactPressed:(id)sender {
    [self accessAddressBook];
}

- (IBAction)buttonPersonCallPressed:(id)sender {
    NSString *telephoneNumber = [NSString stringWithFormat:@"%@",[userData objectForKey:@"EmergencyContactPersonNumber"]];
    [self invokeCallNumber:telephoneNumber];
        
}

- (IBAction)buttonPoliceCallPressed:(id)sender {
    NSString *telephoneNumber = [NSString stringWithFormat:@"%@",[userData objectForKey:@"Police"]];
    [self invokeCallNumber:telephoneNumber];
}

- (IBAction)buttonFireCallPressed:(id)sender {
    NSString *telephoneNumber = [NSString stringWithFormat:@"%@",[userData objectForKey:@"Fire"]];
    [self invokeCallNumber:telephoneNumber];
}

- (IBAction)buttonHospitalCallPressed:(id)sender {
    NSString *telephoneNumber = [NSString stringWithFormat:@"%@",[userData objectForKey:@"Hospital"]];
    [self invokeCallNumber:telephoneNumber];
}
- (IBAction)buttonSMSPressed:(id)sender {
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *SMScontroller = [[MFMessageComposeViewController alloc] init];
        SMScontroller.messageComposeDelegate = self;
        SMScontroller.body = emergencyText;
        SMScontroller.recipients = [NSArray arrayWithObject:[userData objectForKey:@"EmergencyContactPersonNumber"]];
        [self presentViewController:SMScontroller animated:YES completion:nil];
    }
    else{
        
    }
}

- (IBAction)buttonEmailPressed:(id)sender {
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[userData objectForKey:@"EmergencyContactPersonEmails"]];
        [controller setSubject:@"help.ME"];
        UIImage * image = [UIImage imageNamed:@"logo_57.png"];
        [controller addAttachmentData:UIImagePNGRepresentation(image) mimeType:@"image/png" fileName:@"logo_57.png"];
        [controller setMessageBody:emergencyText isHTML:NO];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else{
        
    }
}

- (IBAction)buttonFacebookPressed:(id)sender {
    if (OSVERSION >= 6.0){
        NSString *serviceType = SLServiceTypeFacebook;
        [self invokeSocialService:serviceType];
    }
    else if (OSVERSION < 6.0){
        self.labelSocialHeader.text = NSLocalizedString(@"Facebook Requires iOS 6.0", @"Facebook Requires iOS 6.0");
        [self animateLabelAndButton:self.labelSocialHeader andButton:self.buttonFacebookOutlet];
        self.labelSocialHeader.text = NSLocalizedString(@"Social", @"Social");
    }

}


- (IBAction)buttonTwitterPressed:(id)sender {
    if (OSVERSION >= 6.0){
        NSString *serviceType = SLServiceTypeTwitter;
        [self invokeSocialService:serviceType];
    }
    else if (OSVERSION < 6.0){
        if ([TWTweetComposeViewController canSendTweet])
        {
            TWTweetComposeViewController *tweetSheet =
            [[TWTweetComposeViewController alloc] init];
            [tweetSheet setInitialText: emergencyText];
            //[tweetSheet addURL:[NSURL URLWithString:@"http://www.jaist.ac.jp/~s1010205"]];
            [tweetSheet addImage:[UIImage imageNamed:@"logo_114.png"]];

            [self presentModalViewController:tweetSheet animated:YES];
        }
        else
        {
            self.labelSocialHeader.text = NSLocalizedString(@"No Twitter Account Set on My Device", @"No Twitter Account Set on My Device");
            [self animateLabelAndButton:self.labelSocialHeader andButton:self.buttonTwitterOutlet];
            self.labelSocialHeader.text = NSLocalizedString(@"Social", @"Social");
        }
        
    }

}

#pragma mark delegate methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Accessing AccessAddress Book
-(IBAction)accessAddressBook{
    // creating the picker
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	// place the delegate of the picker to the controll
	picker.peoplePickerDelegate = self;
    
	// showing the picker
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    // assigning control back to the main controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
    
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (property == kABPersonPhoneProperty){
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        ABMultiValueRef multiPhone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *choice = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multiPhone,identifier);
        ABMultiValueRef multiEmail = ABRecordCopyValue(person, kABPersonEmailProperty);
        if (ABMultiValueGetCount(multiEmail)>0){
            //self.labelEmails.text = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiEmail, 0);
            NSArray *arrayEmail = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(multiEmail);
            [userData setObject:arrayEmail forKey:@"EmergencyContactPersonEmails"];
        }
        
        NSData *contactImageData = (__bridge NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        //UIImage * image = [[UIImage alloc] initWithData:contactImageData];
        [userData setObject:contactImageData forKey:@"EmergencyContactPersonImageData"];
        [userData setObject:fullName forKey:@"EmergencyContactPersonFullName"];
        [userData setObject:firstName forKey:@"EmergencyContactPersonFirstName"];
        [userData setObject:lastName forKey:@"EmergencyContactPersonLastName"];
        [userData setObject:choice forKey:@"EmergencyContactPersonNumber"];
        [userData synchronize];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
    
}
- (void) invokeSocialService: (NSString *) serviceType{
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            
            NSLog(@"ResultCancelled");
            
        } else
            
        {
            NSLog(@"Success");
        }
        
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    controller.completionHandler =myBlock;
    
    [controller setInitialText:emergencyText];
    //[controller addURL:[NSURL URLWithString:@"http://www.jaist.ac.jp/~s1010205"]];
    [controller addImage:[UIImage imageNamed:@"logo_114.png"]];
    
    [self presentViewController:controller animated:YES completion:Nil];
}
-(void) invokeCallNumber:(NSString *)telephoneNumber{

    if (![telephoneNumber isEqualToString:@"Choose Contact"]) {
        NSString * strippedNumber = [NSString alloc];
        strippedNumber = [telephoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        
        [WCAlertView showAlertWithTitle:telephoneNumber message:nil customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhiteHatched;
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex == 0) {
                NSLog(@"Cancel");
                
            } else {
                NSLog(@"%@", strippedNumber);
                NSString *toDial = [NSString stringWithFormat:@"tel://%@",strippedNumber];
                NSURL *url = [NSURL URLWithString:toDial];
                [[UIApplication sharedApplication] openURL:url];
            }
        } cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Call", @"Call"), nil];
        
    }
    
}
-(void)animateGadgetsHeader{

    if(self.flashIsOn || self.audioIsOn){
        [self.labelGadgetsHeader startAnimating];
    }
    else {
        [self.labelGadgetsHeader stopAnimating];
        self.labelGadgetsHeader.text = NSLocalizedString(@"Gadgets", @"Gadgets");
    }

    if (self.flashIsOn && self.audioIsOn){
        self.labelGadgetsHeader.text = NSLocalizedString(@"Torch & Sound - ON", @"Torch & Sound - ON");
    }
    else if (self.flashIsOn){
        self.labelGadgetsHeader.text = NSLocalizedString(@"Torch - ON", @"Torch - ON");
        
    }
    else if (self.audioIsOn){
        self.labelGadgetsHeader.text = NSLocalizedString(@"Sound - ON", @"Sound - ON");
    }
}
- (void) animateLabelAndButton:(MTAnimatedLabel *) labelHeader andButton:(UIView *) theView{
    [labelHeader startAnimating];
    [Animations rotate:theView andAnimationDuration:0.40 andWait:YES andAngle:10.0];
    [Animations rotate:theView andAnimationDuration:0.40 andWait:YES andAngle:-10.0];
    [Animations rotate:theView andAnimationDuration:0.40 andWait:YES andAngle:10.0];
    [Animations rotate:theView andAnimationDuration:0.40 andWait:YES andAngle:-10.0];
    [Animations rotate:theView andAnimationDuration:0.40 andWait:YES andAngle:10.0];
    [Animations rotate:theView andAnimationDuration:0.40 andWait:YES andAngle:-10.0];
    theView.transform = CGAffineTransformIdentity;
    [labelHeader stopAnimating];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {

    [self setScrollView:nil];
    [self setButtonFlashLightOutlet:nil];
    [self setImageViewContactPerson:nil];
    [self setLabelFirstName:nil];
    [self setLabelLastName:nil];
    [self setLabelContactPersonNumber:nil];
    [self setButtonChooseContactOutlet:nil];
    [self setButtonChooseContactIcon:nil];
    [self setBarItemSettingsOutlet:nil];
    [self setButtonSoundOutlet:nil];
    [self setButtonFlashOutlet:nil];
    [self setLabelPoliceNumber:nil];
    [self setLabelFireNumber:nil];
    [self setLabelHospitalNumber:nil];
    [self setButtonFacebookOutlet:nil];
    [self setLabelSocialHeader:nil];
    [self setButtonTwitterOutlet:nil];
    [self setLabelGadgetsHeader:nil];
    [self setLabelContactsHeaderOutlet:nil];
    [self setViewPolice:nil];
    [self setLabelEmailAddress:nil];
    [self setButtonCallPersonOutlet:nil];
    [self setButtonCallPoliceOutlet:nil];
    [self setButtonCallHospitalOutlet:nil];
    [self setButtonCallFireOutlet:nil];
    [super viewDidUnload];
}




- (IBAction)buttonInfoPressed:(id)sender {
}
@end
