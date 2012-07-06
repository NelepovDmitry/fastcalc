//
//  AboutController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AboutControllerDelegate;

@interface AboutController : UIViewController

@property (assign, nonatomic) id <AboutControllerDelegate>delegate;

- (IBAction)closeClicked:(id)sender;

@end

@protocol AboutControllerDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(AboutController*)secondDetailViewController;
@end