//
//  MainViewController.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "ChooseViewController.h"
#import "PriceTableViewController.h"
#import "MenuItem.h"
#import "AppDelegate.h"
#import "GroupItem.h"
#import "IIViewDeckController.h"
#import "EClockPlayer.h"
#import "ApplicationSingleton.h"
#import "JSON.h"
#import "InternetUtils.h"
#import "ZipArchive.h"

@interface MainViewController ()

- (void)initGestureProp;
- (void)initPlayers;
- (void)setMainProp;
- (void)finishAnimation;

- (void)setMainCheckViewFrameWithAnimation:(BOOL)animate duration:(float)duration;
- (void)requsetMenuById:(NSNumber *)menuId;
- (void)getMenuItems:(NSData *)data;

@end

@implementation MainViewController
@synthesize priceTableViewController;
@synthesize menuTableViewController;

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
    [self setMainProp];
    [self performSelectorInBackground:@selector(initPlayers) withObject:nil];
    [self performSelectorInBackground:@selector(initGestureProp) withObject:nil];
    
}

- (void)viewDidUnload
{
    [self setPriceTableViewController:nil];
    [self setMenuTableViewController:nil];
    [secondMenuTableViewController release];
    secondMenuTableViewController = nil;
    [mAnimationView release];
    mAnimationView = nil;
    [mGestureRecognizerDown release];
    mGestureRecognizerDown = nil;
    [mTotalLbl release];
    mTotalLbl = nil;
    [mCheckView release];
    mCheckView = nil;
    [mMainView release];
    mMainView = nil;
    [mGestureRecognizerUp release];
    mGestureRecognizerUp = nil;
    [mGestureRecognizerLeft release];
    mGestureRecognizerLeft = nil;
    [mMaskView release];
    mMaskView = nil;
    [mPriceView release];
    mPriceView = nil;
    [mPaperBottomImageView release];
    mPaperBottomImageView = nil;
    [mPaperTopImageView release];
    mPaperTopImageView = nil;
    [mPriceLbl release];
    mPriceLbl = nil;
    [currentGroupBtn release];
    currentGroupBtn = nil;
    [mPageControl release];
    mPageControl = nil;
    [mPriceMask release];
    mPriceMask = nil;
    [mThanksView release];
    mThanksView = nil;
    [mThanksLabel release];
    mThanksLabel = nil;
    [mBrandImage release];
    mBrandImage = nil;
    [mScrollViewForTableView release];
    mScrollViewForTableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [priceTableViewController release];
    [secondMenuTableViewController release];
    [menuTableViewController release];
    [mAnimationView release];
    [mGestureRecognizerDown release];
    [mTotalLbl release];
    [mCheckView release];
    [mMainView release];
    [mGestureRecognizerUp release];
    [mGestureRecognizerLeft release];
    [mMaskView release];
    [mPriceView release];
    [mPaperBottomImageView release];
    [mPaperTopImageView release];
    [mPriceLbl release];
    [currentGroupBtn release];
    [mPageControl release];
    [mPriceMask release];
    [mThanksView release];
    [mThanksLabel release];
    [mBrandImage release];
    [mScrollViewForTableView release];
    [super dealloc];
}

#pragma mark - Custom functions

- (void)initGestureProp {
    [mGestureRecognizerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [mGestureRecognizerUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [mGestureRecognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    //[mThanksView addGestureRecognizer:mGestureRecognizerDown];
    //[mThanksView addGestureRecognizer:mGestureRecognizerUp];
    [mThanksView addGestureRecognizer:mGestureRecognizerLeft];
    //[mPriceMask addGestureRecognizer:mGestureRecognizerDown];
    //[mPriceMask addGestureRecognizer:mGestureRecognizerUp];
    [mPriceMask addGestureRecognizer:mGestureRecognizerLeft];
}

- (void)initPlayers {
    mKassaPlayer = [[EClockPlayer alloc] initWithFileName:@"Kassa.wav"];
    [mKassaPlayer adjustVolume:0.4f];
    mBumagaPlayer = [[EClockPlayer alloc] initWithFileName:@"Bumaga.wav"];
    [mBumagaPlayer adjustVolume:0.2f];
}

- (void)setMainProp {
    //set main prop
    mApplicationSingleton = [ApplicationSingleton createSingleton];
    mArrayOfProductsNames = [[NSMutableArray alloc] init];
    mArrayOfMenuItemGroups = [[NSMutableArray alloc] init];
    mInternetUtils = [[InternetUtils alloc] init];
    mDictOfMenus = [[NSMutableDictionary alloc] init];
    indexOfMenu = 0;
    isFinishedCut = true;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgorund.png"]];
    self.viewDeckController.delegate = self;
    mPriceView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture.png"]];
    mThanksLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture.png"]];
    menuTableViewController.delegate = self;
    priceTableViewController.delegate = self;
    
    secondMenuTableViewController = [[MenuTableViewController alloc] init];
    secondMenuTableViewController.delegate = self;
    secondMenuTableViewController.tableView.rowHeight = 46;
    secondMenuTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    secondMenuTableViewController.tableView.backgroundColor = menuTableViewController.tableView.backgroundColor;
    secondMenuTableViewController.view.frame = menuTableViewController.view.frame;
    CGRect rect = secondMenuTableViewController.view.frame;
    rect.origin.x = menuTableViewController.tableView.frame.size.width;
    [secondMenuTableViewController.view setFrame:rect];
    
    [self requsetMenuById:mApplicationSingleton.idOfMenu];
    
    mScrollViewForTableView.contentSize = CGSizeMake(menuTableViewController.tableView.frame.size.width * mArrayOfMenuItemGroups.count, mScrollViewForTableView.frame.size.height);
    mScrollViewForTableView.pagingEnabled = YES;
    [mScrollViewForTableView addSubview:secondMenuTableViewController.view];
    [mScrollViewForTableView setShowsHorizontalScrollIndicator:NO];
    [mScrollViewForTableView setShowsVerticalScrollIndicator:NO];
    
    mAppDelegate = [UIApplication sharedApplication].delegate;
    
    //set scroll prop
    [mMainView setContentSize:CGSizeMake(320, 830)];
    [mMainView setShowsHorizontalScrollIndicator:NO];
    [mMainView setShowsVerticalScrollIndicator:NO];
    mMainView.pagingEnabled = YES;
    mMainView.bounces = NO;
    CGPoint bottomOffset = CGPointMake(0, mMainView.contentSize.height - mMainView.frame.size.height);
    [mMainView setContentOffset:bottomOffset animated:NO];
    //[mMainView setScrollEnabled:NO];
    
    [self setMainCheckViewFrameWithAnimation:NO duration:0];
    rect = mCheckView.frame;
    rect.origin.y = BEGIN_Y - BEGIN_OFFSET;
    [mCheckView setFrame:rect];
    [self setMainCheckViewFrameWithAnimation:YES duration:0.5f];
}

- (void)volume:(float)volume {
    [mKassaPlayer adjustVolume:volume];
    [mBumagaPlayer adjustVolume:volume];
}

- (void)newCheck {
    if(isFinishedCut) {
        isFinishedCut = false;
        [mBumagaPlayer playAudio];
        [priceTableViewController clearCheck];
        mPrice = 0;
        mPriceLbl.text = [NSString stringWithFormat:@"%d", mPrice];
        [UIView transitionWithView:mCheckView
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:^{
                            mCheckView.hidden = YES;
                            mMaskView.clipsToBounds = NO;
                        }
                        completion:^(BOOL finished) {
                            [self setMainCheckViewFrameWithAnimation:NO duration:0.0f];
                            CGRect rect = mCheckView.frame;
                            rect.origin.y = BEGIN_Y - BEGIN_OFFSET;
                            [mCheckView setFrame:rect];
                            mCheckView.hidden = NO;
                            mMaskView.clipsToBounds = YES;
                            mPaperTopImageView.hidden = YES;
                            [self setMainCheckViewFrameWithAnimation:YES duration:0.5f];
                        }];
    }
}

- (void)finishAnimation {
    mPaperTopImageView.hidden = NO;
    isFinishedCut = true;
}

#pragma mark - Actions

- (IBAction)gestureTaped:(id)sender {
    UISwipeGestureRecognizer *gesture = sender;
    if(gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        CGPoint topOffset = CGPointMake(0, 0);
        [mMainView setContentOffset:topOffset animated:YES];
        [priceTableViewController goToTop:YES];
        mAppDelegate.viewController.viewDeckController.panningMode = IIViewDeckNoPanning;
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        CGPoint bottomOffset =  CGPointMake(0, mMainView.contentSize.height - mMainView.frame.size.height);
        [mMainView setContentOffset:bottomOffset animated:YES];
        [priceTableViewController goToTop:NO];
        mAppDelegate.viewController.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    } else if(gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self newCheck];
    }
}

- (IBAction)changeMenuClicked:(id)sender {
    if(mArrayOfMenuItemGroups.count > 0) {
        indexOfMenu = (indexOfMenu + 1) % mArrayOfMenuItemGroups.count;
        //[menuTableViewController nextMenuByIndex:index];
        GroupItem *groupItem = [mArrayOfMenuItemGroups objectAtIndex:indexOfMenu];
        [currentGroupBtn setTitle:groupItem.groupName forState:UIControlStateNormal];
        mPageControl.currentPage = indexOfMenu;
        NSString *key = [mArrayOfProductsNames objectAtIndex:indexOfMenu];
        NSArray *arrayOfProducts = [mDictOfMenus objectForKey:key];
        [menuTableViewController setArrayOfTableView:arrayOfProducts];
        mScrollViewForTableView.contentSize = CGSizeMake(menuTableViewController.tableView.frame.size.width * mArrayOfMenuItemGroups.count, mScrollViewForTableView.frame.size.height);
    }
}

- (IBAction)menuClicked:(id)sender {
    [mAppDelegate.viewController.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)newChecked:(id)sender {
    [self newCheck];
}

#pragma mark - MenuTableViewController Delegate

- (void)getAllProducts {
    GroupItem *groupItem = [mArrayOfMenuItemGroups objectAtIndex:0];
    [currentGroupBtn setTitle:groupItem.groupName forState:UIControlStateNormal];
    mPageControl.numberOfPages = mArrayOfMenuItemGroups.count;
    mPageControl.currentPage = 0;
}

- (void)getNewPrice:(MenuItem *)menu {
    [mKassaPlayer playAudio];
    
    mPrice += menu.menuPrice.integerValue;
    mPriceLbl.text = [NSString stringWithFormat:@"%d", mPrice];
    [priceTableViewController addNewProduct:menu];
    
    //CGRect rect = mCheckView.frame;
    //rect.origin.y = BEGIN_Y;
    //[mCheckView setFrame:rect];
    [priceTableViewController goToTop:NO];
    [self setMainCheckViewFrameWithAnimation:YES duration:0.3f];
}

#pragma mark - Scroll View delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    mAppDelegate.viewController.viewDeckController.panningMode = IIViewDeckNoPanning;
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        // Page has changed
        // Do your thing!
        previousPage = page;
    }
    if(mPageControl.currentPage != previousPage) {
        NSLog(@"mPageControl.currentPage %d", mPageControl.currentPage);
        NSLog(@"previousPage %d", previousPage);
    }
    mPageControl.currentPage = previousPage;
    //NSLog(@"previousPage %d", previousPage);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y >= 350 && scrollView == mMainView) {
        mAppDelegate.viewController.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    }
}

#pragma mark - PriceTableViewController Delegate

- (void)deleteProductWithPrice:(MenuItem *)menuItem count:(NSNumber *)count{
    mPrice -= menuItem.menuPrice.integerValue * count.integerValue;
    mPriceLbl.text = [NSString stringWithFormat:@"%d", mPrice];
    //CGRect rect = mCheckView.frame;
    //rect.origin.y = BEGIN_Y;
    //[mCheckView setFrame:rect];
    [self setMainCheckViewFrameWithAnimation:YES duration:0.3f];
}

#pragma mark - Set Frames Functions

- (void)setMainCheckViewFrameWithAnimation:(BOOL)animate duration:(float)duration {
    if(animate) {
        [UIView beginAnimations : @"Display notif" context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(finishAnimation)];
    }
    CGRect frameOfThanksView = mThanksView.frame;
    
    [priceTableViewController setTableViewFrameByCells];
    CGRect frameOfPriceTableView = priceTableViewController.tableView.frame;
    frameOfPriceTableView.origin.y = frameOfThanksView.size.height + frameOfThanksView.origin.y;
    
    [priceTableViewController.tableView setFrame:frameOfPriceTableView];
    CGRect frameOfPriceView = mPriceView.frame;
    frameOfPriceView.origin.y = frameOfPriceTableView.origin.y + frameOfPriceTableView.size.height;
    [mPriceView setFrame:frameOfPriceView];
    
    CGRect frameOfCheckView = mCheckView.frame;
    frameOfCheckView.size.height = frameOfThanksView.size.height + frameOfPriceTableView.size.height + frameOfPriceView.size.height;
    frameOfCheckView.origin.y = BEGIN_Y - frameOfCheckView.size.height;
    [mCheckView setFrame:frameOfCheckView];
    if(animate) {
        [UIView commitAnimations];
    }
}

#pragma mark - IIViewDeckCountroller Delegate

- (void)viewDeckControllerDidOpenLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated {
    //[mThanksView removeGestureRecognizer:mGestureRecognizerDown];
    //[mThanksView removeGestureRecognizer:mGestureRecognizerUp];
    [mThanksView removeGestureRecognizer:mGestureRecognizerLeft];
    //[mPriceMask removeGestureRecognizer:mGestureRecognizerDown];
    //[mPriceMask removeGestureRecognizer:mGestureRecognizerUp];
    [mPriceMask removeGestureRecognizer:mGestureRecognizerLeft];
    [mMainView setScrollEnabled:NO];
}

- (void)viewDeckControllerDidCloseLeftView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated {
    //[mThanksView addGestureRecognizer:mGestureRecognizerDown];
    //[mThanksView addGestureRecognizer:mGestureRecognizerUp];
    [mThanksView addGestureRecognizer:mGestureRecognizerLeft];
    //[mPriceMask addGestureRecognizer:mGestureRecognizerDown];
    //[mPriceMask addGestureRecognizer:mGestureRecognizerUp];
    [mPriceMask addGestureRecognizer:mGestureRecognizerLeft];
    [mMainView setScrollEnabled:YES];
}

#pragma mark - Gesture Recognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Menu table view loader functions

- (void)requsetMenuById:(NSNumber *)menuId {
    if(menuId.integerValue == 0) {
        [mLoader dismissWithClickedButtonIndex:0 animated:YES];
        [self.viewDeckController toggleLeftView];
        return;
    }
    indexOfMenu = 0;
    mMenuID = menuId;
    [self performSelectorOnMainThread:@selector(startPreloader) withObject:nil waitUntilDone:YES];
    if([ApplicationSingleton isMenuExistinChache:menuId]) {
        NSString *path = [mApplicationSingleton cacheDirectory];
        path = [NSString stringWithFormat:@"%@/%d", path, menuId.integerValue];
        NSString *jsonPath = [path stringByAppendingPathComponent:@"menu.json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
        [self getMenuItems:jsonData];
    } else {
        [self performSelectorOnMainThread:@selector(sendRequestToServerWithObject:) withObject:menuId waitUntilDone:YES];
    }
}

//http://fastcalc.orionsource.ru/api?apifastcalc.getMenuItemsZip={"menu_id":6,"responseBinary":1}
//http://fastcalc.orionsource.ru/api/?apifastcalc.getMenuItems={menu_id:6}
- (void)sendRequestToServerWithObject:(id)object {
    NSNumber *menuId = object;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:menuId forKey:@"menu_id"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"responseBinary"];
    [mInternetUtils makeURLRequestByNameResponser:@"getMenuItemsZip:" 
                                          urlCall:[NSURL URLWithString:URL] 
                                    requestParams:[NSDictionary dictionaryWithObject:[dict JSONRepresentation] forKey:@"apifastcalc.getMenuItemsZip"]
                                        responder:self
                             progressFunctionName:@"progress:"
     ];
}

- (void)progress:(OSInternetUtilsProgressInfo *)data {
    [mLoader setTitle:[NSString stringWithFormat:@"Loading in progress \n%d %%", (int)((data.contentLoaded.floatValue / data.contentSize.floatValue) * 100)]];
    //NSLog(@"loaded %f", (data.contentLoaded.floatValue / data.contentSize.floatValue) * 100);
    //NSLog(@"data.contentLoaded %@", data.contentLoaded);
}

- (void)getMenuItemsZip:(NSData *)data {
    mApplicationSingleton.idOfMenu = mMenuID;
    [mApplicationSingleton commitSettings];
    [mLoader setTitle:@"Archiving \nPlease Wait..."];
    NSString *path = [mApplicationSingleton cacheDirectory];
    path = [NSString stringWithFormat:@"%@/%d", path, mApplicationSingleton.idOfMenu.integerValue];
	NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
    NSString *filename = @"brands.zip";
    NSString *toDirectory = [NSString stringWithFormat:@"%@/%@", path, filename];
    [data writeToFile:toDirectory atomically:YES];
    
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    [zipArchive UnzipOpenFile:toDirectory];
    [zipArchive UnzipFileTo:path overWrite:YES];
    [zipArchive UnzipCloseFile];
    [zipArchive release];
    
    NSString *jsonPath = [path stringByAppendingPathComponent:@"menu.json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    [self getMenuItems:jsonData];
    
}

- (void)getMenuItems:(NSData *)data {
    mApplicationSingleton.idOfMenu = mMenuID;
    [mApplicationSingleton commitSettings];
    [mLoader setTitle:@"Caching \nPlease Wait..."];
    [mDictOfMenus removeAllObjects];
    [mArrayOfProductsNames removeAllObjects];
    [mArrayOfMenuItemGroups removeAllObjects];
    
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *mainDict = [json JSONValue];
    NSArray *arrayOfGroups = [mainDict valueForKeyPath:@"groups"];
    
    NSNumber *objectID;
    
    for(NSDictionary *dictOfgroup in arrayOfGroups) {
        NSDictionary *info = [dictOfgroup objectForKey:@"info"];
        GroupItem *groupItem = [[GroupItem alloc] initWithArray:[info objectForKey:@"objectValues"]];
        [mArrayOfMenuItemGroups addObject:groupItem];
        NSArray *objectValues = [dictOfgroup objectForKey:@"items"];
        NSMutableArray *arrayOfobjects = [NSMutableArray array];
        for(NSDictionary *objectValue in objectValues) {
            MenuItem *menuItem = [[MenuItem alloc] initWithArray:[objectValue objectForKey:@"objectValues"]];
            objectID = menuItem.objectId;
            [arrayOfobjects addObject:menuItem];
            [menuItem release];
        }
        [mArrayOfProductsNames addObject:[dictOfgroup objectForKey:@"groupname"]];
        [mDictOfMenus setObject:arrayOfobjects forKey:[dictOfgroup objectForKey:@"groupname"]];
    }
    NSString *key = [mArrayOfProductsNames objectAtIndex:indexOfMenu];
    NSArray *arrayOfProducts = [mDictOfMenus objectForKey:key];
    [menuTableViewController setArrayOfTableView:arrayOfProducts];
    if(mArrayOfProductsNames.count > indexOfMenu + 1) {
        NSString *key = [mArrayOfProductsNames objectAtIndex:indexOfMenu + 1];
        NSArray *arrayOfProducts = [mDictOfMenus objectForKey:key];
        [secondMenuTableViewController setArrayOfTableView:arrayOfProducts];
    }
    //[self.tableView reloadData];
    mScrollViewForTableView.contentSize = CGSizeMake(menuTableViewController.tableView.frame.size.width * mArrayOfMenuItemGroups.count, mScrollViewForTableView.frame.size.height);
    
    [self getAllProducts];
    [mLoader dismissWithClickedButtonIndex:0 animated:YES];
}


- (void)startPreloader {
    mLoader = [[[UIAlertView alloc] initWithTitle:@"Loading the data list\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
    [mLoader show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(mLoader.bounds.size.width / 2, mLoader.bounds.size.height - 50);
    [indicator startAnimating];
    [mLoader addSubview:indicator];
    [indicator release];
}

@end
