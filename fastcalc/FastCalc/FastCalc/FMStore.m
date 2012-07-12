//
//  FMStore.m
//  TestInApp
//
//  Created by Казанский Александр on 10.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FMStore.h"
#import "FMObserver.h"


@implementation FMStore
@synthesize purchasableObjects;
@synthesize delegate;

- (id)init {
    self=[super init];
    [self requestProductData];
    FMObserver *observer = [FMObserver shareObserver];
	observer.store = self;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
    return self;
}

+ (FMStore*)sharedStore {
    static FMStore* sharedStore;
    
    @synchronized(self) {
        if (!sharedStore) {
            sharedStore = [[FMStore alloc] init];
        }
        
        return sharedStore;
    }
}

- (void)requestProductData {
    NSSet *myset=[NSSet setWithObjects:
                  @"org.fmech.enso.testupdate",
                  @"org.fmech.enso.test23",
                  @"org.fmech.enso.test2",
                  @"org.fmech.enso.test4",
                  @"org.fmech.zenclockhd.donate25",
                  nil];
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:myset];
    request.delegate = self;
    [request start];
    [request autorelease];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.purchasableObjects = response.products;
    //NSLog(@"", )
    NSLog(@"Store products:%d BBB %d",[purchasableObjects count], [response.invalidProductIdentifiers count]);
}

- (void)buyFeature:(NSString*) featureId {
	if([SKPaymentQueue canMakePayments]) {
		NSLog(@"buy %@", featureId);
		SKPayment *payment = nil;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0)
            for (SKProduct *prd in  purchasableObjects) {
                if ([prd.productIdentifier isEqualToString:featureId]) {
                    NSLog(@"featureId %@", featureId);
                    payment = [SKPayment paymentWithProduct:prd];
                    break;
                }
            }
        else
            payment = [SKPayment paymentWithProductIdentifier:featureId];
        if (payment==nil)
            return;
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
}

- (void) deleteIndicator {
    //[delegate clickPurchase];
}

- (void)provideContent: (NSString*) productIdentifier forReceipt:(NSData*) receiptData{
    //FIXME подставить локализацию
    NSLog(@"%@",[[NSString alloc] initWithData:receiptData encoding:NSUTF8StringEncoding]);
    NSLog(@"ProductPurchased: %@", productIdentifier);
    [delegate productPurchased:productIdentifier];
}

@end
