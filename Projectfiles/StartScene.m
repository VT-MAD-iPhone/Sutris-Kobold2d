//
//  Start.m
//  Sutris
//
//  Created by David Odell on 2/27/13.
//
//

#import "StartScene.h"
#import "Game.h"

@implementation StartScene
+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    
    StartScene *layer = [StartScene node];
    [scene addChild: layer];
    return scene;
}

-(id) init
{
	if ((self = [super init]))
	{
        CCSprite *background =[CCSprite spriteWithFile:@"Default.png"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGSize imageSize = background.contentSize;
        background.scaleX = winSize.width / imageSize.width;
        background.scaleY = winSize.height / imageSize.height;
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background z:0];
        
        [CCMenuItemFont setFontName:@"Courier New"];
        [CCMenuItemFont setFontSize:18];
        
        CCMenuItemFont *newGame = [CCMenuItemFont itemWithString:@"New Game"
                                                          target:self
                                                        selector:@selector(startGame:)];
        
        
        CCMenu *menu = [CCMenu menuWithItems: newGame, nil];
        menu.position=ccp(240,100);
        
        [menu alignItemsVerticallyWithPadding:15];
        
        [self addChild:menu];
        
	}
    
	return self;
}

-(void) startGame: (id) sender
{
    [[CCDirector sharedDirector]
     replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[Game node]]];
}

-(void) dealloc
{
#ifndef KK_ARC_ENABLED
	[super dealloc];
#endif // KK_ARC_ENABLED
}


@end
