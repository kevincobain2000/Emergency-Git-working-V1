//
//  SharedData.m
//  temp
//
//  Created by Pulkit Kathuria on 11/20/12.
//  Copyright (c) 2012 Pulkit Kathuria. All rights reserved.
//

#import "SharedData.h"


@implementation SharedData


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isEnabledToShowHUD = [NSNumber numberWithBool:NO];
        userData = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

+(void)initialNumbersByLocation: (NSUserDefaults *) userData{
    /*First the CountryCode, CountryName and CurrentLocation are taken
     from -(void) myLocationMethod in ViewController.m
     then this method is called back again
    */
    if (![userData objectForKey:@"AddLocation"]){
        [userData setObject:@"YES" forKey:@"AddLocation"];

    }

    NSString *countryCode = [userData objectForKey:@"CountryCode"];
    NSString *countryName = [userData objectForKey:@"CountryName"];
    NSLog(@"This ");
    
    
    if (!countryCode || !countryName){
        NSLocale* currentLocale = [NSLocale currentLocale];  // get the current locale.
        countryCode = [currentLocale objectForKey: NSLocaleCountryCode];
        countryName = [currentLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
    }
     
     
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CodesNumbers" ofType:@"plist"];
    NSDictionary *CountriesCodesAndNumbers = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    [userData setObject:countryName forKey:@"CountryName"];
    [userData setObject:countryCode forKey:@"CountryCode"];
    [userData setObject:countryName forKey:@"ChosenCountryName"];
    
    
    
    [userData setObject:[[CountriesCodesAndNumbers objectForKey:countryCode] objectAtIndex:2] forKey:@"Police"];
    [userData setObject:[[CountriesCodesAndNumbers objectForKey:countryCode] objectAtIndex:1] forKey:@"Fire"];
    [userData setObject:[[CountriesCodesAndNumbers objectForKey:countryCode] objectAtIndex:0] forKey:@"Hospital"];
    
    [userData setObject:NSLocalizedString(@"First Last", @"First Last") forKey:@"EmergencyContactPersonFullName"];
    //[userData setObject:@"First Last" forKey:@"EmergencyContactPersonFullName"];
    
    [userData setObject:NSLocalizedString(@"First", @"First") forKey:@"EmergencyContactPersonFirstName"];
    //[userData setObject:@"First" forKey:@"EmergencyContactPersonFirstName"];
    
    [userData setObject:NSLocalizedString(@"Last", @"Last") forKey:@"EmergencyContactPersonLastName"];
    //[userData setObject:@"Last" forKey:@"EmergencyContactPersonLastName"];
    
    [userData setObject:NSLocalizedString(@"Choose Contact", @"Choose Contact") forKey:@"EmergencyContactPersonNumber"];
    //[userData setObject:@"Choose Contact" forKey:@"EmergencyContactPersonNumber"];
    [userData setObject:NULL forKey:@"EmergencyContactPersonImageData"];
    
    [userData setObject:NSLocalizedString(@"I am in need of help ASAP. I am currently at -", @"I am in need of help ASAP. I am currently at -")  forKey:@"EmergencyMessage"];
    //[userData setObject:@"I am in need of help ASAP. I am currently at -\n" forKey:@"EmergencyMessage"];
    
    [userData setObject:[NSArray arrayWithObjects:@"", nil] forKey:@"EmergencyContactPersonEmails"];

    [userData synchronize];
}

+(SharedData *) sharedData;
{
    static SharedData* _sharedData;
    if (!_sharedData)
        _sharedData = [[SharedData alloc] init];
    return _sharedData;
}

+ (NSString *) stringToPhone: (NSString *) unformatted{
    if ([unformatted length] < 7) {
        return unformatted;
    }
    else{
        NSArray *stringComponents = [NSArray arrayWithObjects:[unformatted substringWithRange:NSMakeRange(0, 3)],
                                     [unformatted substringWithRange:NSMakeRange(3, 3)],
                                     [unformatted substringWithRange:NSMakeRange(6, [unformatted length]-6)], nil];
        
        NSString *formattedString = [NSString stringWithFormat:@"(%@) %@-%@", [stringComponents objectAtIndex:0], [stringComponents objectAtIndex:1], [stringComponents objectAtIndex:2]];
        return formattedString;
    }
}

@end
