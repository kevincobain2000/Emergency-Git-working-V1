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
    MGBoxLine *head2 = [MGBoxLine lineWithLeft:@"Earthquakes" right:nil];
    head2.font = headerFont;
    [box2.topLines addObject:head2];
    
    /*
    NSEnumerator *enumerator = [sharedData.jsonResults keyEnumerator];
    NSLog(@"%i",[sharedData.jsonResults count]);
    id key;
    while ((key = [enumerator nextObject])) {
        NSDictionary *tmp = [sharedData.jsonResults objectForKey:key];
        
        MGStyledBox *boxI = [MGStyledBox box];
        [scroller.boxes addObject:boxI];
        
        float pos = [[tmp objectForKey:@"Pos"] floatValue];
        float neg = [[tmp objectForKey:@"Neg"] floatValue];
        float sub = [[tmp objectForKey:@"Subjectivity"] floatValue];
        float obj = [[tmp objectForKey:@"Objectivity"] floatValue];
        
        NSString *leftString = [NSString alloc];
        NSString *rightString = [NSString alloc];
        if (pos >= neg) {
            leftString = [NSString stringWithFormat:@"Happy = %i%%", (int) (pos*100) ];
            
        }
        else{
            leftString = [NSString stringWithFormat:@"Sad = %i%%", (int) (neg*100)];
        }
        if (sub >= obj) {
            rightString = [NSString stringWithFormat:@"Subjective = %i%%", (int) (sub*100)];
        }
        else{
            rightString = [NSString stringWithFormat:@"Objective = %i%%", (int) (obj*100)];
        }
        
        MGBoxLine *headI = [MGBoxLine lineWithLeft:leftString right:rightString];
        headI.font = headerFont;
        if (pos >= neg) {
            headI.textColor = [UIColor darkGrayColor];
            
        }
        else{
            headI.textColor = [UIColor redColor];
        }
        
        
        [boxI.topLines addObject:headI];
        
        NSString *tweetI = [tmp objectForKey:@"Tweet"];
        MGBoxLine *multiI = [MGBoxLine multilineWithText:tweetI font:nil padding:24];
        [boxI.topLines addObject:multiI];
        
    }
    */
    
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
