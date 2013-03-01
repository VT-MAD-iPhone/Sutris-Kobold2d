//
//  StartScene.h
//  Sutris
//
//  Created by David Odell on 2/27/13.
//
//

#import "CCLayer.h"
#import "StartMenuViewController.h"

@interface StartScene : CCLayer
{
#if KK_PLATFORM_IOS
    
    StartMenuViewController *myViewController;
    
#endif

}

@end
