//
//  CMPMap.m
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMap.h"
#import "CMPMapParser.h"

NSString * const CMPMapErrorDomain = @"com.grantjbutler.Compass.CMPMap.error-domain";

@implementation CMPMap

- (BOOL)readFromURL:(NSURL *)url error:(NSError *__autoreleasing *)outError {
    NSData *mapData = [[NSData alloc] initWithContentsOfURL:url options:0 error:outError];
    if (!mapData) {
        return NO;
    }
    
    CMPMapParser *parser = [[CMPMapParser alloc] initWithData:mapData];
    
    NSError *error;
    if (![parser parseIntoMap:self error:&error]) {
        // TODO: Pass the error back up.
        
        return NO;
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
