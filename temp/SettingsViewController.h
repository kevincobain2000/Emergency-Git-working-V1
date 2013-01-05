//
//  SettingsViewController.h
//  temp
//
//  Created by Pulkit Kathuria on 11/5/12.
//  Copyright (c) 2012 Pulkit Kathuria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CustomTextViewController.h"

#import "MBProgressHUD.h"
#import "CountryNumbersViewController.h"
#import "SharedData.h"
#import "MKEntryPanel.h"
#import <CoreLocation/CoreLocation.h>

@interface SettingsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate, MBProgressHUDDelegate, CLLocationManagerDelegate>{
    
    MBProgressHUD *HUD;
    NSUserDefaults *userData;
    SharedData *sharedData;
}


-(IBAction)accessAddressBook;
-(IBAction)alertToReset;

-(void) initialNumbersInCells;
-(void)showHUDCustom: (NSString *) message;


@property (nonatomic, strong) UITableViewCell *globalCell;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellPoliceOutlet;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellFireOutlet;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellHospitalOutlet;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellEmergencyPerson;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellMyCountry;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellResetOutlet;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellAddLocation;

@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLGeocoder *geoCoder;

- (void) switchChanged:(id)sender;

@end
