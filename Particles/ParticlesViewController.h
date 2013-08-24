//
//  ParticlesViewController.h
//  Particles
//
//  Created by Max Luzuriaga on 8/24/13.
//
//

#import <UIKit/UIKit.h>

@class ParticlesView;

@interface ParticlesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *controlsView;
@property (strong, nonatomic) IBOutlet ParticlesView *particlesView;

- (IBAction)velocityChanged:(id)sender;

@end
