//
//  InformationViewController.m
//  help.ME
//
//  Created by Pulkit Kathuria on 1/23/13.
//  Copyright (c) 2013 Pulkit Kathuria. All rights reserved.
//

#import "InformationViewController.h"
#import "MGScrollView.h"
#import "MGStyledBox.h"
#import "MGBoxLine.h"
#define ANIM_SPEED 0.0
#define IsRunningTallPhone() ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
@interface InformationViewController ()

@end

@implementation InformationViewController{
    MGScrollView *scroller;
    
}
//static NSDictionary *countryNamesByCode = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Location and Distance
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        if (!place1Lat){
            place1Lat =  (double)currentLocation.coordinate.latitude;
            place1Long = (double)currentLocation.coordinate.longitude;
            //Roughly get the current location and then stop updating it
            [LocationManager stopUpdatingLocation];
        }
        
    }
}
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    LocationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    LocationManager.delegate = self;
    [LocationManager startUpdatingLocation];
    
    
    self.title = NSLocalizedString(@"Updates", @"Updates");
    //Start the Header for the updates
    UIFont *headerFont = [UIFont fontWithName:@"ArialHebrew" size:16];
    // make an MGScrollView for holding boxes
    CGFloat scrollHeight = 420;
    if (IsRunningTallPhone()) {
        scrollHeight = 520;
    }
    CGRect frame = CGRectMake(0, 0, 320, scrollHeight);
    scroller = [[MGScrollView alloc] initWithFrame:frame];
    [self.view addSubview:scroller];
    scroller.alwaysBounceVertical = YES;
    scroller.delegate = self;
    
    MGStyledBox *box2 = [MGStyledBox box];
    [scroller.boxes addObject:box2];
    MGBoxLine *head2 = [MGBoxLine lineWithLeft:NSLocalizedString(@"Earthquakes", @"Earthquakes") right:nil];
    head2.font = headerFont;
    
    [box2.topLines addObject:head2];
    //End the header for the Earthquakes
    
    //Parse the updates from the api Magnitude + 2.5
    NSString* myFile = [NSString stringWithFormat:@"http://earthquake.usgs.gov/earthquakes/catalogs/eqs1day-M2.5.txt"];
    NSString* myFileURLString = [myFile stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSData *myFileData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:myFileURLString]];
    NSString *returnedMyFileContents=[[NSString alloc] initWithData:myFileData encoding:NSASCIIStringEncoding];
    NSString *cleanString = [returnedMyFileContents stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSArray *returnedList = [cleanString componentsSeparatedByString:@"\n"];
    
    NSMutableDictionary *distanceAndDisaster = [[NSMutableDictionary alloc] init];
    
    for (NSString *line in returnedList) {
        
        NSArray *firstlistItems = [line componentsSeparatedByString:@","];
        if ([firstlistItems count] > 10) {
            double lon = [[firstlistItems objectAtIndex:7] doubleValue];
            double lat = [[firstlistItems objectAtIndex:6] doubleValue];
            CLLocation *disasterLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
            CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:place1Lat longitude:place1Long];
            CLLocationDistance meters = [disasterLocation distanceFromLocation:thisLocation];
            distanceBetweenTwo = meters/1000;
            [distanceAndDisaster setObject:firstlistItems forKey:[NSNumber numberWithFloat:distanceBetweenTwo]];
        }
    }
    NSArray *sortedKeys = [[distanceAndDisaster allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSMutableArray *sortedValues = [NSMutableArray array];
    for (NSString *key in sortedKeys)
        [sortedValues addObject: [distanceAndDisaster objectForKey: key]];;
    
    //Parsing Complete into array with each line
    //Note that the top line is only 10 commas because of the date in others
    
    NSEnumerator *e = [sortedValues objectEnumerator];//Change this to returnedList if want the latest results by Date
    id listItems;
    while (listItems = [e nextObject]) {
        //NSArray *listItems = [object componentsSeparatedByString:@","];
        if ([listItems count] > 10 ) {
            MGStyledBox *boxI = [MGStyledBox box];
            [scroller.boxes addObject:boxI];
            
            //Country Name or Region
            NSString *region = [NSString stringWithFormat:@"%@",[listItems objectAtIndex:11]] ;
            NSString *leftString = [region stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString *rightString = [NSString stringWithFormat:@"M %@",[listItems objectAtIndex:8]];
            
            
            MGBoxLine *headI = [MGBoxLine lineWithLeft:leftString right:rightString];
            
            headI.font = headerFont;
            [boxI.topLines addObject:headI];
            
            //Day Date Time
            NSString *day = NSLocalizedString([listItems objectAtIndex:3], @"Day");
            NSString *inMainBox = [NSString stringWithFormat:@"%@ %@ %@",day, [listItems objectAtIndex:4],  [[listItems objectAtIndex:5] substringToIndex:11]];
            
            MGBoxLine *multiI = [MGBoxLine multilineWithText:inMainBox font:nil padding:24];
            multiI.textColor = [UIColor grayColor];
            [boxI.topLines addObject:multiI];
            
            
        }
        
    }
    [scroller drawBoxesWithSpeed:ANIM_SPEED];
    [scroller flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (MGBox *)parentBoxOf:(UIView *)view {
    while (![view.superview isKindOfClass:[MGBox class]]) {
        if (!view.superview) {
            return nil;
        }
        view = view.superview;
    }
    return (MGBox *)view.superview;
}
@end
