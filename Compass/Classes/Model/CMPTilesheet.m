//
//  CMPTilesheet.m
//  Compass
//
//  Created by Grant Butler on 12/5/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPTilesheet.h"

#import <CYAMLDeserializer.h>

const CGSize CMPTilesheetTileSize = { 16.0, 16.0 };

@implementation CMPTilesheet

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        NSData *yamlData = [NSData dataWithContentsOfFile:path];
        if (yamlData) {
            NSDictionary *document = [[CYAMLDeserializer deserializer] deserializeData:yamlData error:nil];
            
            NSString *relativeImageFilePath = document[@"sprite"];
            NSString *imageFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:relativeImageFilePath];
            _sprite = [[UIImage alloc] initWithContentsOfFile:imageFilePath];
        }
    }
    return self;
}

- (NSUInteger)numberOfColumns {
    return ceilf(self.sprite.size.width / CMPTilesheetTileSize.width);
}

- (NSUInteger)numberOfRows {
    return ceilf(self.sprite.size.height / CMPTilesheetTileSize.height);
}

@end
