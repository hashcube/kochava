#import "KochavaPlugin.h"

@implementation KochavaPlugin 

// The plugin must call super dealloc.
- (void) dealloc {
  [super dealloc];
  [self.kochavaTracker release];
}

// The plugin must call super init.
- (id) init {
  self = [super init];
  if (!self) {
    return nil;
  }
  return self;
}

- (void) initializeWithManifest:(NSDictionary *)manifest
                    appDelegate:(TeaLeafAppDelegate *)appDelegate {
  @try {
    NSDictionary *ios = [manifest valueForKey:@"ios"];
    NSString *const KOCHAVA_APP_ID = [ios valueForKey:@"kochavaAppGUID"];

    self.kochavaTracker = [[KochavaTracker alloc]
      initWithParametersDictionary:@{kKVAParamAppGUIDStringKey:
      KOCHAVA_APP_ID} delegate:nil];

    // To enable log messages 
    // NOTE: DO NOT ENABLE FOR PRODUCTION BUILDS
    //[self.kochavaTracker enableConsoleLogging:YES];
  }
  @catch (NSException *exception) {
    NSLOG(@"{kochava} Exception while initializing: %@", exception);
  }
}

- (void) setUserId:(NSDictionary *)jsonObject {
    
  @try {
    if([jsonObject objectForKey:@"uid"]) {
      NSString *uid = [NSString stringWithFormat:@"%@", [jsonObject valueForKey:@"uid"]];
      NSDictionary *identityLinkData = [NSDictionary dictionaryWithObjectsAndKeys:
                    uid, @"customer_id",
                    nil];
      [self.kochavaTracker sendIdentityLinkWithDictionary:identityLinkData];
    }
  }
  @catch (NSException *exception) {
    NSLOG(@"{kochava} Exception while setting user id: %@", exception);
  }
}

- (void) trackPurchase:(NSDictionary *)jsonObject {
    KochavaEvent *event = [KochavaEvent eventWithEventTypeEnum:KochavaEventTypeEnumPurchase];

    event.currencyString = [NSString stringWithFormat:@"%@", [jsonObject valueForKey:@"currency"]];
    event.checkoutAsGuestString = @"false";
    event.itemAddedFromString = @"1";
    event.infoString = [NSString stringWithFormat:@"%@", [jsonObject valueForKey:@"revenue"]];
    event.receiptIdString = [NSString stringWithFormat:@"%@", [jsonObject valueForKey:@"transactionId"]];
    event.appStoreReceiptBase64EncodedString = [NSString stringWithFormat:@"%@", [jsonObject valueForKey:@"receipt"]];

    [self.kochavaTracker sendEvent:event];
}

//TODO: To be tested
- (void) trackEventWithValue:(NSDictionary *)jsonObject {
  NSError *error;
  NSDictionary *valuePayload = @{
              @"value": [jsonObject valueForKey:@"value"]
            };
  NSString *eventTitle = [NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"event_name"]];
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:valuePayload options:0 error:&error];
  if(jsonData) {
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
    [self.kochavaTracker sendEventWithNameString:eventTitle infoString:jsonString];
  }
}
@end
