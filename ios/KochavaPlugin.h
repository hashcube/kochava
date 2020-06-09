#import "PluginManager.h"
#import "KochavaTracker.h"

@interface KochavaPlugin: GCPlugin
  @property (assign) KochavaTracker *kochavaTracker;
@end
