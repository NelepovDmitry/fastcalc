//
//  FMObserver.h
//  TestInApp
//
//  Created by Казанский Александр on 10.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "FMStore.h"

@interface FMObserver : NSObject<SKPaymentTransactionObserver>{
	FMStore *store;
}
@property (nonatomic, retain) FMStore *store;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
+(FMObserver*) shareObserver;

@end
