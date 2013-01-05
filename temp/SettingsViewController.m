//
//  SettingsViewController.m
//  temp
//
//  Created by Pulkit Kathuria on 11/5/12.
//  Copyright (c) 2012 Pulkit Kathuria. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sharedData = [SharedData sharedData];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    
    
    self.cellResetOutlet.backgroundView = [ [UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"ipad-button-red.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    self.cellResetOutlet.selectedBackgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"ipad-button-red-pressed.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
}
-(void)viewWillAppear:(BOOL)animated{
    userData = [NSUserDefaults standardUserDefaults];
    if (sharedData.isEnabledToShowHUD == @YES) {
        [self showHUDCustom:NSLocalizedString(@"Done", @"Done")];
    }
    [self initialNumbersInCells];
}

-(void) initialNumbersInCells{
    
    
    
    self.cellPoliceOutlet.detailTextLabel.text = [SharedData stringToPhone:[userData objectForKey:@"Police"]];
    self.cellFireOutlet.detailTextLabel.text = [SharedData stringToPhone:[userData objectForKey:@"Fire"]];
    self.cellHospitalOutlet.detailTextLabel.text = [SharedData stringToPhone:[userData objectForKey:@"Hospital"]];
    
    self.cellMyCountry.detailTextLabel.text = [userData objectForKey:@"ChosenCountryName"];
    if ([userData objectForKey:@"EmergencyContactPersonFullName"]){
        self.cellEmergencyPerson.textLabel.text = [userData objectForKey:@"EmergencyContactPersonFullName"];
        self.cellEmergencyPerson.detailTextLabel.text = [userData objectForKey:@"EmergencyContactPersonNumber"];
    }
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.cellAddLocation.accessoryView = switchView;
    

    NSString *addLocation = [userData objectForKey:@"AddLocation"];
    //NSLog(@"%@", addLocation);
    
    if ([addLocation isEqualToString:@"YES"]){
        //[self myLocationMethod];
        [switchView setOn:YES animated:YES];
        self.cellAddLocation.detailTextLabel.text = [userData objectForKey:@"CurrentLocation"];
        NSLog(@"%@", [userData objectForKey:@"CurrentLocation"]);
    }
    else{
        [switchView setOn:NO animated:YES];
        self.cellAddLocation.detailTextLabel.text = NSLocalizedString(@"No Location", @"No Location");
    }
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

}

#pragma mark Location Method
-(void) myLocationMethod{
    
    self.locationManager = [[CLLocationManager alloc] init];
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
         NSLog(@"I am currently at %@",locatedAt);
         //if (locatedAt) {
             //[userData setObject:locatedAt forKey:@"CurrentLocation"];
         //}
         
         //NSString *countryCodeByLocation = [placemark.addressDictionary valueForKey:@"CountryCode"];
         //NSString *countryNameByLocation = placemark.country;
         //[userData setObject:countryNameByLocation forKey:@"CountryName"];
         //[userData setObject:countryCodeByLocation forKey:@"CountryCode"];
         //[userData synchronize];
         
         //Set the label text to current location
     }];
}
- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    if (switchControl.on) {
        [userData setObject:@"YES" forKey:@"AddLocation"];
        self.cellAddLocation.detailTextLabel.text = [userData objectForKey:@"CurrentLocation"];
    }
    else{
        [userData setObject:@"NO" forKey:@"AddLocation"];
        self.cellAddLocation.detailTextLabel.text = NSLocalizedString(@"No Location", @"No Location");
    }
    [userData synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
    self.globalCell = myCell;
    self.globalCell.selected = NO;
    if (indexPath.section == 0){
        NSString *textFieldBarTitle = [[NSString alloc] init];
        if (indexPath.row == 0){
            textFieldBarTitle = @"Police";
        }
        else if (indexPath.row == 1){
            textFieldBarTitle = @"Fire";
        }
        else if (indexPath.row == 2){
            textFieldBarTitle = @"Hospital";
        }
        NSString *textTitle = [NSString stringWithFormat:@"%@ - Phone number",textFieldBarTitle];
        [MKEntryPanel showPanelWithTitle:NSLocalizedString(textTitle, @"")
                                  inView:self.view
                           onTextEntered:^(NSString* enteredString)
         {
             if ([enteredString length] >0){
                 self.globalCell.detailTextLabel.text = enteredString;
                 [userData setObject:enteredString forKey:textFieldBarTitle];
                 [userData synchronize];
                 [self showHUDCustom:NSLocalizedString(@"Done", @"Done")];
                 [self initialNumbersInCells];
             }
         }];

    }
    else if (indexPath.section == 1){
        [self performSegueWithIdentifier:@"cnv" sender:self];
        
    }
    else if (indexPath.section == 2){
        //Access one number from the address book
        [self accessAddressBook];
    }
    else if (indexPath.section == 3 && indexPath.row == 0){
        //Bring the pop up View to edit the text
        CustomTextViewController *ctv = [[CustomTextViewController alloc] initWithNibName:@"CustomTextViewController" bundle:nil];
        [self presentViewController:ctv animated:YES completion:nil];
        
    }
    else if(indexPath.section == 4){
        //Reset Button
        [self alertToReset];
    }
    
}

#pragma mark Address Book
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
        self.globalCell.textLabel.text = fullName;
        
        ABMultiValueRef multiPhone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *choice = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multiPhone,identifier);
        self.globalCell.detailTextLabel.text = choice;
        
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
    [self showHUDCustom:NSLocalizedString(@"Done", @"Done")];
    return NO;
    
}


- (void)viewDidUnload {
    [self setCellPoliceOutlet:nil];
    [self setCellFireOutlet:nil];
    [self setCellHospitalOutlet:nil];
    [self setCellEmergencyPerson:nil];
    [self setCellMyCountry:nil];
    [self setCellResetOutlet:nil];
    [self setCellAddLocation:nil];
    [super viewDidUnload];
}
#pragma mark Alert View Reset
-(IBAction)alertToReset{
    [WCAlertView showAlertWithTitle:NSLocalizedString(@"Confirm", @"Confirm") message:NSLocalizedString(@"Restore saved contacts, message & location ?", @"Restore saved contacts, message & location ?") customizationBlock:^(WCAlertView *alertView) {
        alertView.style = WCAlertViewStyleWhiteHatched;
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        if (buttonIndex == 0) {
            NSLog(@"Cancel");

        } else {
            NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
            for (NSString *key in [defaultsDictionary allKeys]) {
                if ([key isEqualToString:@"CurrentLocation"]) {
                    NSLog(@"%@", [userData objectForKey:@"CurrentLocation"]);
                }
                else{
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
                }
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [SharedData initialNumbersByLocation:userData];
            [self initialNumbersInCells];
            [self showHUDCustom:NSLocalizedString(@"Information Reset", @"Information Reset")];
            
        }
    } cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Ok", @"Ok"), nil];
 
}


-(void)showHUDCustom: (NSString *) message{
    sharedData.isEnabledToShowHUD = @NO;
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.delegate = self;
    HUD.labelText = message;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:0.7];
}

@end
