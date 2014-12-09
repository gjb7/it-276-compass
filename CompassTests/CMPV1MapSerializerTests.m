//
//  CMPV1MapSerializerTests.m
//  Compass
//
//  Created by Grant Butler on 12/7/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import XCTest;

#import "CMPMap.h"
#import "CMPV1MapSerializer.h"

@interface CMPV1MapSerializerTests : XCTestCase

@end

@implementation CMPV1MapSerializerTests

- (void)testMapSerialization {
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *temporaryMapFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:@"temp.map"];
    
    CMPMap *map = [[CMPMap alloc] initWithFileURL:temporaryMapFileURL];
    map.size = CGSizeMake(5.0, 5.0);
    
    uint8_t *layerBytes = malloc(25 * sizeof(uint8_t));
    memcpy(layerBytes, (uint8_t[]){
        0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    }, 100);
    [map.layers addObject:[NSValue valueWithPointer:layerBytes]];
    
    CMPV1MapSerializer *serializer = [[CMPV1MapSerializer alloc] init];
    NSData *serializedMap = [serializer serializeMap:map];
    
    uint8_t validMap[] = {
        0x56, 0x01, 0x3B, 0x57, 0x05, 0x3B, 0x48, 0x05, 0x3B, 0x4C, 0x01, 0x3B, 0x6C, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x3B
    };
    
    XCTAssertEqualObjects(serializedMap, [NSData dataWithBytes:validMap length:sizeof(validMap)]);
}

@end
