//
//  CMPV1MapSerializer.m
//  Compass
//
//  Created by Grant Butler on 12/7/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPV1MapSerializer.h"

#import "CMPMap.h"

@implementation CMPV1MapSerializer

- (NSData *)serializeMap:(CMPMap *)map {
    NSMutableData *buffer = [[NSMutableData alloc] init];
    
    [self appendMapVersionToBuffer:buffer];
    [self appendMapSize:map.size toBuffer:buffer];
    
    return buffer;
}

- (void)appendMapVersionToBuffer:(NSMutableData *)buffer {
    uint8_t versionBuffer[3] = { 'V', 1, ';' };
    [buffer appendBytes:versionBuffer length:3];
}

- (void)appendMapSize:(CGSize)size toBuffer:(NSMutableData *)buffer {
    uint8_t widthBuffer[3] = { 'W', (uint8_t)size.width, ';' };
    [buffer appendBytes:widthBuffer length:3];
    
    uint8_t heightBuffer[3] = { 'H', (uint8_t)size.height, ';' };
    [buffer appendBytes:heightBuffer length:3];
}

@end
