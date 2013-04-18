//
//  TouchDemoViewController.m
//  Demo's
//
//  Created by David Cabrera on 2/27/13.
//  Copyright (c) 2013 David Cabrera. All rights reserved.
//

#import "TouchDemoViewController.h"

@interface TouchDemoViewController ()
@end

@implementation TouchDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.revealMenuButton setTarget: self.revealViewController];
    [self.revealMenuButton setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    UIImage *blockStar = [UIImage imageNamed:@"Block*.png"];
    self.viewOne.image = blockStar;
    
    // require the swipe to fail before we recognize the pan
    [self.panGesture requireGestureRecognizerToFail:self.swipeGesture];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) handleSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    // Get the location of the gesture
    CGPoint gestureLocation = [recognizer locationInView:self.view];
    
    // Get the xcoordinate of the imageview
    CGFloat viewX = self.viewOne.center.x;
    // Make sure the swipe gesture is downward
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
        // get the dimensions of the main view window and calculate how far down
        // to the bottom is left
        CGRect mainViewRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = mainViewRect.size.height;
        CGFloat amountToFinalLocation = screenHeight - gestureLocation.y;
        
        // Add the amount needed to get the final location
        gestureLocation.y += amountToFinalLocation;
        gestureLocation.x = viewX;
        
        // Subtract the y of the image view from the center to determine
        // the offset from the bottom to move up from so swipe down doesnt
        // block half of the image view
        CGFloat imageViewHeight = self.viewOne.bounds.size.height;
        gestureLocation.y = self.view.bounds.size.height - (imageViewHeight / 2);
        
        // Animate the image view in the direction of the downward swipe
        [UIView animateWithDuration:0.1 animations:^{
            //self.viewOne.alpha = 0.0;
            self.viewOne.center = gestureLocation;
        }];
    }
    
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
{
    // make sure the pan is either in the left or right
    CGPoint velocity = [recognizer velocityInView:self.view];
    
    // get the y coordinate of the recognizer
    CGFloat yCoordinate = recognizer.self.view.center.y;
    if ((velocity.x > 0 || velocity.x < 0))
    {
        CGPoint translation = [recognizer translationInView:self.view];
        
        // no translation in y so the user can't move the block up or down
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        
        // We're going to detect when the gesture ends and figure out how fast the touch
        // was moving so it can continue to move in that direction
        
        if (recognizer.state == UIGestureRecognizerStateEnded)
        {
            // the velocity of the gesture. It is given in horizontal and
            // vertical components. Change in x vs change in y
            CGPoint velocity = [recognizer velocityInView:self.view];
            
            //Calculate the length of the velocity vector
            // = sqrt(x^2 + y^2)
            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
            
            // if the length is less than 200 then decrease base speed, else increase it
            // Then we calculate the final point based on the velocity and a slide factor
            // Make sure our point is within the bounds of the viewController
            // Then we animate the view the end
            
            CGFloat slideMultiplier = magnitude / 10000;
            
            // We can increase 0.1 to another number for more of a sublt slide
            float slideFactor = 0.1 * slideMultiplier;
            
            // We create our final point by getting the x and y coordinates of the center
            // of the frame and adding the x and y components of the velocity (which is the change in
            // the x and y direction) and muliplying by our slide factor
            
            CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                             recognizer.view.center.y);
            
            // Here, we modify our final point to make sure it is within bounds of the screen
            // We take the max of the finalPoint's x and y versus 0 (so no negative bounds) and
            // then the min of that results and the bounds of the vew
            finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
            NSLog(@"final x point %f", finalPoint.x);
            //finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
            
            finalPoint.y = yCoordinate;
            // animate to end point
            //[UIViewAnimationCurveLinear]
            [UIView animateWithDuration:slideFactor delay:0 options:UIViewAnimationCurveLinear animations: ^{
                recognizer.view.center = finalPoint;
            } completion:nil];
        }

    }
    
}
@end
