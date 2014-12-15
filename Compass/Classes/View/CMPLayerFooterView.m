//
//  CMPLayerFooterView.m
//  Compass
//
//  Created by Grant Butler on 12/15/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPLayerFooterView.h"

@implementation CMPLayerFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 44.0)];
    if (self) {
        [self setUpButton];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:44.0]];
    }
    return self;
}

- (void)setUpButton {
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button setTitle:NSLocalizedString(@"Insert Layer", nil) forState:UIControlStateNormal];
    [self addSubview:self.button];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];
}

@end
