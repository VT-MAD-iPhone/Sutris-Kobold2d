/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "AppDelegate.h"

@implementation AppDelegate

-(void) initializationComplete
{
#ifdef KK_ARC_ENABLED
	CCLOG(@"ARC is enabled");
#else
	CCLOG(@"ARC is either not available or not enabled");
#endif
}

-(id) alternateView
{
#if KK_PLATFORM_IOS
	// =======================================================================================
	// --- WARNING --- WARNING --- WARNING --- WARNING --- WARNING --- WARNING --- WARNING ---
	// =======================================================================================
	// If you do need UIKit views both behind and in front of the cocos2d view, you can uncomment the following code.
	// However this solution will create a framebuffer twice the usual size for no apparent reason.
	// It may have other side-effects, too. Test thoroughly!
    
	// no dummy view, just return nil
	//return nil;
    
	// we want to be a dummy view the self.view to which we add the glView plus all other UIKit views
	KKAppDelegate* appDelegate = (KKAppDelegate*)[UIApplication sharedApplication].delegate;
    
	// add a dummy UIView to the view controller, which in turn will have the glView and later other UIKit views added to it
	CGRect bounds = [appDelegate.window bounds];
	UIView* dummyView = [[UIView alloc] initWithFrame:bounds];
#ifndef KK_ARC_ENABLED
	[dummyView autorelease];
#endif // KK_ARC_ENABLED
	
	[dummyView addSubview:[CCDirector sharedDirector].view];
    
	return dummyView;
    
#elif KK_PLATFORM_MAC
#endif
}

@end

