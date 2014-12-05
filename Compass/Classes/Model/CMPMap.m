//
//  CMPMap.m
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMap.h"

NSString * const CMPMapErrorDomain = @"com.grantjbutler.Compass.CMPMap.error-domain";

@implementation CMPMap

- (BOOL)readFromURL:(NSURL *)url error:(NSError *__autoreleasing *)outError {
    NSInputStream *stream = [[NSInputStream alloc] initWithURL:url];
    if (!stream) {
        if (outError) {
            NSString *localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"Could not open file for reading from URL '%@'", nil), url];
            
            *outError = [NSError errorWithDomain:CMPMapErrorDomain
                                            code:CMPMapErrorCodeCouldNotOpenStream
                                        userInfo:@{
                                                   NSLocalizedDescriptionKey: localizedDescription
                                                   }];
        }
        
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
