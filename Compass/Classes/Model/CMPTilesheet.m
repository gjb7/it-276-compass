//
//  CMPTilesheet.m
//  Compass
//
//  Created by Grant Butler on 12/5/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPTilesheet.h"

const CGSize CMPTilesheetTileSize = { 16.0, 16.0 };

@implementation CMPTilesheet

- (NSUInteger)numberOfColumns {
    return ceilf(self.sprite.size.width / 16.0);
}

- (NSUInteger)numberOfRows {
    return ceilf(self.sprite.size.height / 16.0);
}

@end
