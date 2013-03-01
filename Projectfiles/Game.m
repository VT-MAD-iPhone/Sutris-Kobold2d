/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "Game.h"
#import "SimpleAudioEngine.h"
#import "StartScene.h"


@implementation Game

@synthesize velocity;
int currentTime = 5;
CCLabelTTF *countdown;
CCMenu *menu;
CCMenu *pauseMenu;

CCMenu *leftButton;
CCMenu *rightButton;

CCSprite *pauseScreen;
CCSprite *background;
float xScale;
float yScale;
float xIncrement;
int currentCol;

CCSprite * block;
CGFloat cols[9];

float bottom;

-(id) init
{
   	if ((self = [super init]))
	{
        bottom = 0;
        background =[CCSprite spriteWithFile:@"sutris_background.png"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        xIncrement = winSize.width/9;
        CGSize imageSize = background.contentSize;
        xScale = winSize.width / imageSize.width;
        yScale = winSize.height / imageSize.height;
        background.scaleX = xScale;
        background.scaleY = yScale;
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background z:0];

        
        CCMenuItemFont *pause = [CCMenuItemImage itemWithNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(pauseGame:)];
        pause.scaleX = xScale;
        pause.scaleY = yScale;
        pauseMenu = [CCMenu menuWithItems: pause, nil];
        pauseMenu.position=ccp(winSize.width - pause.boundingBox.size.width, winSize.height - pause.boundingBox.size.height);
        [pauseMenu alignItemsVertically];
        [self addChild:pauseMenu];
        
        CCMenuItemFont *right = [CCMenuItemFont itemWithString:@"Right"
                                                          target:self
                                                        selector:@selector(moveRight:)];        
        rightButton= [CCMenu menuWithItems: right, nil];
        rightButton.position=ccp((winSize.width - winSize.width/4), winSize.height - 50);
        [rightButton alignItemsVertically
         ];
        [self addChild:rightButton];
        
        CCMenuItemFont *left = [CCMenuItemFont itemWithString:@"Left"
                                                        target:self
                                                      selector:@selector(moveLeft:)];
        leftButton= [CCMenu menuWithItems: left, nil];
        leftButton.position=ccp(winSize.width/4, winSize.height - 50);
        [leftButton alignItemsVertically];
        [self addChild:leftButton];
        
        
        [self addBlock];
    }
    return self;
}

-(void) pauseGame: (id) sender
{
    [self pauseSchedulerAndActions];
    [self removeChild:pauseMenu];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    pauseScreen =[CCSprite spriteWithFile:@"pauseScreen.png"];
    pauseScreen.scaleX = xScale;
    pauseScreen.scaleY = yScale;
    pauseScreen.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:pauseScreen z:2];

    CCMenuItemFont *continueButton = [CCMenuItemImage itemWithNormalImage:@"continue.png" selectedImage:@"continue.png" target:self selector:@selector(resumeGame:)];
    continueButton.scaleX = xScale;
    continueButton.scaleX = xScale;
    continueButton.scaleY = yScale;
    menu = [CCMenu menuWithItems: continueButton, nil];
    menu.position=ccp(winSize.width/2, winSize.height - (winSize.height/4));
    [menu alignItemsVertically];
    [self addChild:menu z:3];
}

-(void) resumeGame:(id) sender
{
    [self removeChild:pauseScreen cleanup:YES];
    [self removeChild:menu];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCMenuItemFont *pause = [CCMenuItemImage itemWithNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(pauseGame:)];
    pause.scaleX = xScale;
    pause.scaleY = yScale;
    pauseMenu = [CCMenu menuWithItems: pause, nil];
    pauseMenu.position=ccp(winSize.width - pause.boundingBox.size.width, winSize.height - pause.boundingBox.size.height);
    [pauseMenu alignItemsVertically];
    [self addChild:pauseMenu];
    [self resumeSchedulerAndActions];
    
}


-(void)gameLogic:(ccTime)dt
{
    cols[currentCol]++;
    currentCol = 4;
    [self addBlock];
}


-(void) moveRight:(id) sender
{
    float currentWidth = block.position.x;
    float currentHeight = block.position.y;
    block.position = ccp(currentWidth + xIncrement, currentHeight);
    currentCol++;
    bottom= block.boundingBox.size.height*cols[currentCol];
    NSLog(@"%f", bottom);
    NSLog(@"%i", currentCol);
}

-(void) moveLeft:(id) sender
{
    float currentWidth = block.position.x;
    float currentHeight = block.position.y;
    block.position = ccp(currentWidth - xIncrement, currentHeight);
    currentCol--;
    bottom= block.boundingBox.size.height*cols[currentCol];
}

-(void) addBlock
{
    int number = (arc4random() % 10) + 1;
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    block = [CCSprite spriteWithFile:[NSString stringWithFormat:@"block%i.png", number]];
    block.scaleX = xScale;
    block.scaleY = yScale;
    block.position = ccp(winSize.width/2, winSize.height);
   [self addChild:block];
    int actualDuration = 5.0;
    
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                position:ccp(winSize.width/2, bottom)];
    [block runAction:[CCSequence actions:actionMove, nil]];
    
    [self schedule:@selector(gameLogic:) interval:5.0];
}


-(void)updateModel
{
    currentCol++;
}

-(void) setScreenSaverEnabled:(bool)enabled
{
#if KK_PLATFORM_IOS
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = !enabled;
#endif
}

-(void) dealloc
{
#ifndef KK_ARC_ENABLED
	[super dealloc];
#endif // KK_ARC_ENABLED
}


@end
