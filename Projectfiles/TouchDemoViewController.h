//
//  TouchDemoViewController.h
//  Demo's
//
//  Created by David Cabrera on 2/27/13.
//  Copyright (c) 2013 David Cabrera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchDemoViewController : UIViewController

// Menu button that reveals the menu
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealMenuButton;

// the image view
@property (weak, nonatomic) IBOutlet UIImageView *viewOne;

@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint oldPoint;
@property (nonatomic) BOOL imageViewTouched;

// the handler for the pan gesture
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;

// handler for the swipe down gesture
- (IBAction)handleSwipeDown: (UISwipeGestureRecognizer *)recognizer;

// reference to the swipe and pan gestures
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGesture;

@end
