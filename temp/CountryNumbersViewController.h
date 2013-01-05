//
//  CountryNumbersViewController.h
//  temp
//
//  Created by Pulkit Kathuria on 11/2/12.
//  Copyright (c) 2012 Pulkit Kathuria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryPicker.h"
#import "SharedData.h"

@interface CountryNumbersViewController: UITableViewController <CountryPickerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    NSDictionary *CodesNumbers;
    NSUserDefaults *userData;
    NSString *codeSetByUser;
    NSString *countrySetByUser;
    SharedData *sharedData;

}

@property (strong, nonatomic) IBOutlet UITableView *tableView;



- (IBAction)buttonDonePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
-(IBAction)alertToSetNumbers;

-(void) populateTextLabels: (NSString *) code;

@end
