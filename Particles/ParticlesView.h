//
//  ParticlesView.h
//  Particles
//
//  Created by Max Luzuriaga on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum ParticleColor {
    ParticleColorRed,
    ParticleColorGreen,
    ParticleColorBlue,
    ParticleColorPink,
    ParticleColorYellow,
    ParticleColorLightGreen,
    ParticleColorLightBlue
} ParticleColor;

@interface ParticlesView : UIView {
    CAEmitterLayer *emitterLayer;
    CGPoint lastPoint;
    ParticleColor currentColor;
    BOOL dragging;
    NSArray *sounds;
}

@property (nonatomic) float velocity;

- (void)configureEmitterForPosition:(CGPoint)position;

@end
