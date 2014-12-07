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
    
    return buffer;
}

- (void)appendMapVersionToBuffer:(NSMutableData *)buffer {
    char versionBuffer[3] = { 'V', 1, ';' };
    [buffer appendBytes:versionBuffer length:3];
}

@end
