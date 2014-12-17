//
//  CMPTilesheet.h
//  Compass
//
//  Created by Grant Butler on 12/5/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

extern const CGSize CMPTilesheetTileSize;

@interface CMPTilesheet : NSObject

@property (nonatomic) UIImage *sprite;

@property (nonatomic, readonly) NSUInteger numberOfColumns;
@property (nonatomic, readonly) NSUInteger numberOfRows;

@property (nonatomic, readonly) NSString *path;

- (instancetype)initWithPath:(NSString *)path;

@end
