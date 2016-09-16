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
    NSDictionary *initDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              KOCHAVA_APP_ID, @"kochavaAppId",
                              nil];

    self.kochavaTracker = [[KochavaTracker alloc] initKochavaWithParams:initDict];

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
      [self.kochavaTracker identityLinkEvent:identityLinkData];
    }
  }
  @catch (NSException *exception) {
    NSLOG(@"{kochava} Exception while setting user id: %@", exception);
  }
}

- (void) trackPurchase:(NSDictionary *)jsonObject {
    NSDictionary *valuePayload = @{
              @"currency": [NSString stringWithFormat:@"%@", [jsonObject valueForKey:@"currency"]],
              @"sum": [NSString stringWithFormat:@"%@", [jsonObject valueForKey:@"revenue"]],
              @"items_in_basket": @"1",
              @"checkout_as_guest": @"false"
           };

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:valuePayload 
                                            options:0 error:&error];
    if(jsonData) {
      NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                               encoding:NSUTF8StringEncoding];
      [self.kochavaTracker trackEvent:@"Purchase" withValue:jsonString
                      andReceipt:[jsonObject valueForKey:@"receipt"]];
    }
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
    [self.kochavaTracker trackEvent:eventTitle :jsonString];
  }
}

- (void) handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
  [self.kochavaTracker sendDeepLink:url:sourceApplication];
}

@end
