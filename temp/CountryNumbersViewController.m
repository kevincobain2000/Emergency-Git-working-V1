//
//  CountryNumbersViewController.m
//  temp
//
//  Created by Pulkit Kathuria on 11/2/12.
//  Copyright (c) 2012 Pulkit Kathuria. All rights reserved.
//

#import "CountryNumbersViewController.h"

@interface CountryNumbersViewController ()

@end

@implementation CountryNumbersViewController

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
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CodesNumbers" ofType:@"plist"];
    CodesNumbers = [[NSDictionary alloc] initWithContentsOfFile:path];
    userData = [NSUserDefaults standardUserDefaults];
    codeSetByUser = @"AF";
    countrySetByUser = @"Afghanistan";
    [self populateTextLabels:codeSetByUser];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]]; 
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)countryPicker:(CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code{
    [self populateTextLabels:code];
    codeSetByUser = code;
    countrySetByUser = name;
    
}

-(void) populateTextLabels: (NSString *) code{
    for(int i=0;i<=2;i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *myCell = [self.tableView cellForRowAtIndexPath:indexPath];
        myCell.detailTextLabel.text = [[CodesNumbers objectForKey:code] objectAtIndex:2-i];
        [myCell setNeedsDisplay];
    }
}

- (IBAction)buttonDonePressed:(id)sender {
    //Save the Settings Here
    [self alertToSetNumbers];
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Alert to Set Numbers
-(IBAction)alertToSetNumbers{
    [WCAlertView showAlertWithTitle:NSLocalizedString(@"Confirm", @"Confirm") message:NSLocalizedString(@"Set above Numbers ?", @"Set above Numbers ?") customizationBlock:^(WCAlertView *alertView) {
        alertView.style = WCAlertViewStyleWhiteHatched;
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        if (buttonIndex == 0) {
            //Cancel
            //[self dismissViewControllerAnimated:YES completion:nil];
        } else {
            
            [userData setObject:[[CodesNumbers objectForKey:codeSetByUser] objectAtIndex:2] forKey:@"Police"];
            [userData setObject:[[CodesNumbers objectForKey:codeSetByUser] objectAtIndex:1] forKey:@"Fire"];
            [userData setObject:[[CodesNumbers objectForKey:codeSetByUser] objectAtIndex:0] forKey:@"Hospital"];
            [userData setObject:codeSetByUser forKey:@"CountryCode"];
            
            [userData setObject:countrySetByUser forKey:@"ChosenCountryName"];
            [userData synchronize];
            sharedData = [SharedData sharedData];
            sharedData.isEnabledToShowHUD = @YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Ok", @"Ok"), nil];
}



- (void)viewDidUnload {
    [super viewDidUnload];
}
@end

