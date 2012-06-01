//
//  ChooseViewController.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 01.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseViewController.h"
#import "InternetUtils.h"

@interface ChooseViewController ()

- (void)getCities;
- (void)getBrands;

@end

@implementation ChooseViewController

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
    //mInternetUtils = [[InternetUtils alloc] init];
    //NSDate *date = [NSDate date];
    //UIImage *image = [UIImage imageNamed:@"IMG_0255.JPG"];
    //NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //NSDate *date1 = [NSDate date];
    //NSLog(@"timing %f", [date1 timeIntervalSinceDate:date]);
    //[mInternetUtils makeURLDataRequestByNameResponser:@"sendData:" urlCall:[NSURL URLWithString:@"http://rent.orionsource.ru/api/test.php"] responder:self data:imageData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Custom functions

- (void)getCities {
    
}

- (void)getBrands {

}

@end
