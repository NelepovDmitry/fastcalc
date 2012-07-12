//
//  FMStore.h
//  TestInApp
//
//  Created by Казанский Александр on 10.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol FMStoreDelegate

- (void)getProductData;
- (void)getProductList;
- (void)loadImageWithURL:(NSURL*) url;
- (void)productPurchased:(NSString *)productID;
- (void)clickPurchase;

@end


@interface FMStore : NSObject <SKProductsRequestDelegate> {
	
	NSArray *purchasableObjects;
	id delegate;
	NSOutputStream *fileStream;
}
@property (nonatomic, retain) NSArray *purchasableObjects;
@property (nonatomic, retain) id delegate;

- (void)deleteIndicator;
- (void)requestProductData;
- (void)buyFeature:(NSString*) featureId;
- (void)provideContent: (NSString*) productIdentifier forReceipt:(NSData*) receiptData;
+ (FMStore*)sharedStore;

@end
