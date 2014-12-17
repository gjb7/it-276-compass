//
//  CMPTiledLayer.m
//  Compass
//
//  Created by Grant Butler on 12/17/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPTiledLayer.h"

static BOOL CMPTiledLayerFadingInEnabled = YES;

@implementation CMPTiledLayer

+ (void)setFadingInEnabled:(BOOL)enabled {
    CMPTiledLayerFadingInEnabled = enabled;
}

+ (CFTimeInterval)fadeDuration {
    return (CMPTiledLayerFadingInEnabled) ? 0.08 : 0.0;
}

@end
