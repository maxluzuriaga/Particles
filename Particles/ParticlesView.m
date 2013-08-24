//
//  ParticlesView.m
//  Particles
//
//  Created by Max Luzuriaga on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ParticlesView.h"
#import <AVFoundation/AVFoundation.h>

@implementation ParticlesView

@synthesize velocity;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.velocity = 1.0;
        
        // Create an array of sound files
        NSURL *sound1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pop_1" ofType:@"caf"]];
        NSURL *sound2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pop_2" ofType:@"caf"]];
        NSURL *sound3 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pop_3" ofType:@"caf"]];
        NSURL *sound4 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pop_4" ofType:@"caf"]];
        
        sounds = [NSArray arrayWithObjects:
                  [[AVAudioPlayer alloc] initWithContentsOfURL:sound1 error:nil],
                  [[AVAudioPlayer alloc] initWithContentsOfURL:sound2 error:nil],
                  [[AVAudioPlayer alloc] initWithContentsOfURL:sound3 error:nil],
                  [[AVAudioPlayer alloc] initWithContentsOfURL:sound4 error:nil],
                  nil];
        
        dragging = NO;
        
        self.backgroundColor = [UIColor blackColor];
        
        // Insert the background image
        UIImage *backgroundImage = [UIImage imageNamed:@"background"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundImageView.frame = self.frame;
        [self addSubview:backgroundImageView];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    dragging = NO;
    
    currentColor = arc4random() % 7;
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    [self configureEmitterForPosition:touchLocation];
    lastPoint = touchLocation;
    
    AVAudioPlayer *sound = (AVAudioPlayer *)[sounds objectAtIndex:(arc4random() % [sounds count])];
    if (sound.isPlaying) {
        sound = (AVAudioPlayer *)[sounds objectAtIndex:(arc4random() % [sounds count])];
        if (sound.isPlaying)
            sound = (AVAudioPlayer *)[sounds objectAtIndex:(arc4random() % [sounds count])];
    }
    
    [sound play];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    dragging = YES;
    
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    [self configureEmitterForPosition:touchLocation];
    lastPoint = touchLocation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dragging = NO;
    
    emitterLayer.birthRate = 0;
    
    CABasicAnimation *removeEmitterAnimation = [CABasicAnimation animationWithKeyPath:@"birthRate"];
    
    removeEmitterAnimation.duration = 0.15;
    removeEmitterAnimation.autoreverses = NO;
    removeEmitterAnimation.fromValue = [NSNumber numberWithFloat:4.0];
    removeEmitterAnimation.toValue = [NSNumber numberWithFloat:0];
    
    [emitterLayer addAnimation:removeEmitterAnimation forKey:@"removeEmitter"];
    
    AVAudioPlayer *sound = (AVAudioPlayer *)[sounds objectAtIndex:(arc4random() % [sounds count])];
    if (sound.isPlaying) {
        sound = (AVAudioPlayer *)[sounds objectAtIndex:(arc4random() % [sounds count])];
        if (sound.isPlaying) {
            sound = (AVAudioPlayer *)[sounds objectAtIndex:(arc4random() % [sounds count])];
            if (sound.isPlaying)
                sound = (AVAudioPlayer *)[sounds objectAtIndex:(arc4random() % [sounds count])];
        }
    }
    
    [sound play];
}

- (void)configureEmitterForPosition:(CGPoint)position
{
    if (dragging) {
        // If the user is dragging, don't animate the birthrate down, just move the emitter position to the new point
        CAEmitterCell *emitterCell = [[emitterLayer emitterCells] objectAtIndex:0];
        CAEmitterCell *subEmitterCell = [[emitterLayer emitterCells] objectAtIndex:1];
        emitterLayer.birthRate = 1.0;
        
        emitterCell.velocity = 100 * self.velocity;
        subEmitterCell.velocity = 100 * self.velocity;
        emitterCell.birthRate = 3000;
        subEmitterCell.birthRate = 1500;
        
        emitterLayer.emitterPosition = position;
        
        // Animate the emitter position
        CABasicAnimation *movePositionAnimation = [CABasicAnimation animationWithKeyPath:@"emitterPosition"];
        
        movePositionAnimation.duration = 0.15;
        movePositionAnimation.autoreverses = NO;
        movePositionAnimation.fromValue = [NSValue valueWithCGPoint:lastPoint];
        movePositionAnimation.toValue = [NSValue valueWithCGPoint:position];
        
        [emitterLayer addAnimation:movePositionAnimation forKey:@"movePosition"];
    } else {
        // Remove the last emitterLayer to make room for the new one
        [emitterLayer removeFromSuperlayer];
        emitterLayer = nil;
        
        // Configure the emitter layer
        emitterLayer = [[CAEmitterLayer alloc] init];
        emitterLayer.emitterPosition = position;
        emitterLayer.emitterShape = kCAEmitterLayerPoint;
        emitterLayer.renderMode = kCAEmitterLayerAdditive;
        emitterLayer.emitterSize = CGSizeMake(10, 10);
        emitterLayer.birthRate = 0;
        
        // Configure the emitter cell
        CAEmitterCell *emitterCell = [[CAEmitterCell alloc] init];
        emitterCell.enabled = YES;
        emitterCell.alphaRange = 0.3;
        emitterCell.alphaSpeed = -0.5;
        emitterCell.redRange = 0.2;
        emitterCell.greenRange = 0.5;
        emitterCell.blueRange = 0.5;
        emitterCell.lifetime = 2;
        emitterCell.lifetimeRange = 0.5;
        emitterCell.emissionRange = 2 * M_PI;
        emitterCell.scale = 1.0;
        emitterCell.scaleSpeed = -0.1;
        emitterCell.spin = 2.0;
        emitterCell.spinRange = 1.0;
        emitterCell.contents = (__bridge id) [[UIImage imageNamed:@"particle.png"] CGImage];
        emitterCell.yAcceleration = 60;
        emitterCell.velocity = 130 * self.velocity;
        emitterCell.birthRate = 5000;
        
        // Color the particles based on a randomly chosen integer
        switch (currentColor) {
            case ParticleColorRed:
                emitterCell.color = [[UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0] CGColor];
                break;
            case ParticleColorGreen:
                emitterCell.color = [[UIColor colorWithRed:0.2 green:1.0 blue:0.2 alpha:1.0] CGColor];
                break;
            case ParticleColorBlue:
                emitterCell.color = [[UIColor colorWithRed:0.2 green:0.2 blue:1.0 alpha:1.0] CGColor];
                break;
            case ParticleColorPink:
                emitterCell.color = [[UIColor colorWithRed:1.0 green:0.4 blue:0.7 alpha:1.0] CGColor];
                break;
            case ParticleColorYellow:
                emitterCell.color = [[UIColor colorWithRed:1.0 green:1.0 blue:0.2 alpha:1.0] CGColor];
                break;
            case ParticleColorLightGreen:
                emitterCell.color = [[UIColor colorWithRed:0.7 green:1.0 blue:0.2 alpha:1.0] CGColor];
                break;
            case ParticleColorLightBlue:
                emitterCell.color = [[UIColor colorWithRed:0.2 green:1.0 blue:1.0 alpha:1.0] CGColor];
                break;
        }
        
        // Configure the other emitter cell
        CAEmitterCell *subEmitterCell = [[CAEmitterCell alloc] init];
        subEmitterCell.enabled = YES;
        subEmitterCell.alphaRange = 0.3;
        subEmitterCell.alphaSpeed = -0.1;
        subEmitterCell.lifetime = 7;
        subEmitterCell.velocity = 130 * self.velocity;
        subEmitterCell.emissionRange = M_PI * 2;
        subEmitterCell.scale = 0.6;
        subEmitterCell.scaleSpeed = -0.1;
        subEmitterCell.birthRate = 2000;
        subEmitterCell.color = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] CGColor];
        subEmitterCell.contents = (__bridge id) [[UIImage imageNamed:@"particle.png"] CGImage];
        subEmitterCell.yAcceleration = 40;
        
        emitterLayer.emitterCells = [NSArray arrayWithObjects:emitterCell, subEmitterCell, nil];
        
        // Animate the birth rate down to 0
        CABasicAnimation *removeEmitterAnimation = [CABasicAnimation animationWithKeyPath:@"birthRate"];
        
        removeEmitterAnimation.duration = 0.15;
        removeEmitterAnimation.autoreverses = NO;
        removeEmitterAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        removeEmitterAnimation.toValue = [NSNumber numberWithFloat:0];
        
        [emitterLayer addAnimation:removeEmitterAnimation forKey:@"removeEmitter"];
        
        [self.layer addSublayer:emitterLayer];
    }
}

@end
