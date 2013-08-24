//
//  ParticlesViewController.m
//  Particles
//
//  Created by Max Luzuriaga on 8/24/13.
//
//

#import "ParticlesViewController.h"

#import "ParticlesView.h"
#import <QuartzCore/QuartzCore.h>

@interface ParticlesViewController ()

@end

@implementation ParticlesViewController

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
	
    CAGradientLayer *controlsBackground = [[CAGradientLayer alloc] init];
    NSLog(@"%f", _controlsView.frame.size.width);
    controlsBackground.frame = CGRectMake(-1, 0, _controlsView.frame.size.width + 1, _controlsView.frame.size.height);
    
    UIColor *firstColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UIColor *secondColor = [UIColor colorWithRed:0.0 green:0 blue:0 alpha:0.2];
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)firstColor.CGColor, secondColor.CGColor, nil];
    controlsBackground.colors = colors;
    
    controlsBackground.borderWidth = 1;
    controlsBackground.borderColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] CGColor];
    
    [_controlsView.layer insertSublayer:controlsBackground atIndex:0];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)velocityChanged:(id)sender {
    self.particlesView.velocity = [(UISlider *)sender value];
}

@end
