//
//  CMPTiledView.m
//  Compass
//
//  Created by Grant Butler on 12/17/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPTiledView.h"

#import "CMPTiledLayer.h"

@implementation CMPTiledView

+ (Class)layerClass {
    return [CMPTiledLayer class];
}

@end
