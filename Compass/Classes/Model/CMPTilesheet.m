//
//  CMPTilesheet.m
//  Compass
//
//  Created by Grant Butler on 12/5/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPTilesheet.h"

#import <CYAMLDeserializer.h>

@implementation CMPTilesheet

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        NSData *yamlData = [NSData dataWithContentsOfFile:path];
        NSDictionary *document = [[CYAMLDeserializer deserializer] deserializeData:yamlData error:nil];
        
        NSString *imageFilePath = document[@"sprite"];
        _sprite = [[UIImage alloc] initWithContentsOfFile:imageFilePath];
    }
    return self;
}

@end
