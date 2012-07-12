//
//  FMObserver.m
//  TestInApp
//
//  Created by Казанский Александр on 10.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FMObserver.h"


@implementation FMObserver
@synthesize store;


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"transactions %@", transactions);
    for (SKPaymentTransaction *transaction in transactions)
    {
        //if (transaction.transactionState != SKPaymentTransactionStatePurchasing){
            // Remove the transaction from the payment queue.
        //    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        //}
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [store deleteIndicator];
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [store deleteIndicator];
                [self failedTransaction:transaction];
                break;
				
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"sdfsdgsg");
                NSString * recData=[[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
                NSLog(@"DAT:%@",recData);
                break;
        }		
    }	
}


- (void)completeTransaction: (SKPaymentTransaction *)transaction {	
	NSLog(@"Платеж прошел");
	[store provideContent:transaction.payment.productIdentifier forReceipt:transaction.transactionReceipt];	
	// Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction: (SKPaymentTransaction *)transaction
{
	NSLog(@"Платеж уже прошел раньше");
    [store provideContent:transaction.payment.productIdentifier forReceipt:transaction.transactionReceipt];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
}

- (void)failedTransaction: (SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
		NSLog(@"Платеж не прошел");
        // Optionally, display an error here.
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

+ (FMObserver*)shareObserver {
    static FMObserver* shareObserver;
    @synchronized(self)
    {
        if (!shareObserver){
            shareObserver = [[FMObserver alloc] init];
        }
        
        return shareObserver;
    }
}

@end
