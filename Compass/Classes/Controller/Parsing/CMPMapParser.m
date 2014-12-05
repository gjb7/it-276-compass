
//
//  CMPMapParser.m
//  Compass
//
//  Created by Grant Butler on 12/5/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMapParser.h"

@implementation CMPMapParser

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (BOOL)parseIntoMap:(CMPMap *)map error:(NSError **)error {
    
    
    return YES;
}

@end
