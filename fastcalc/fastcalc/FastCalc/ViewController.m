//
//  ViewController.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 01.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ChooseViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Custom functions

- (IBAction)chooseBrandsClicked:(id)sender {
    ChooseViewController *chooseViewController = [[ChooseViewController alloc] initWithNibName:@"ChooseViewController" bundle:nil];
    [self.navigationController pushViewController:chooseViewController animated:YES];
    [chooseViewController release];
}

@end
