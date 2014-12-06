//
//  CMPMap.m
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMap.h"
#import "CMPMapParser.h"

@implementation CMPMap

- (BOOL)readFromURL:(NSURL *)url error:(NSError *__autoreleasing *)outError {
    NSData *mapData = [[NSData alloc] initWithContentsOfURL:url options:0 error:outError];
    if (!mapData) {
        return NO;
    }
    
    CMPMapParser *parser = [[CMPMapParser alloc] initWithData:mapData];
    
    NSError *parseError;
    if (![parser parseIntoMap:self error:&parseError]) {
        if (outError) {
            *outError = parseError;
        }
        
        return NO;
    }
    
    if (outError) {
        *outError = nil;
    }
    
    return YES;
}

- (NSMutableArray *)layers {
    if (!_layers) {
        _layers = [[NSMutableArray alloc] init];
    }
    return _layers;
}

@end
