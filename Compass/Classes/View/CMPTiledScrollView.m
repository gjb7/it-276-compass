//
//  CMPTiledScrollView.m
//  Compass
//
//  Created by Grant Butler on 12/17/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPTiledScrollView.h"

#import "CMPTiledView.h"

@implementation CMPTiledScrollView

+ (Class)tiledLayerClass {
    return [CMPTiledView class];
}

@end
