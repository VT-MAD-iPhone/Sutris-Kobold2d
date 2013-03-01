//
//  StartMenuViewController.h
//  Sutris
//
//  Created by David Odell on 2/27/13.
//
//

#import <UIKit/UIKit.h>

@interface StartMenuViewController : UIViewController
{

}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIButton *startButton;

- (IBAction)startButtonPressed:(id)sender;


@end
