
//
//  CMPMapParser.m
//  Compass
//
//  Created by Grant Butler on 12/5/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMapParser.h"

#import "CMPV1MapParser.h"

NSString * const CMPMapParserErrorDomain = @"com.grantjbutler.Compass.CMPMapParser.error-domain";

static NSError *CMPMapParserUnexpectedDataError(NSString *localizedDescription) {
    return [NSError errorWithDomain:CMPMapParserErrorDomain
                               code:CMPMapParserErrorCodeInvalidSyntax
                           userInfo:@{
                                      NSLocalizedDescriptionKey: localizedDescription
                                      }];
}

@implementation CMPMapParser

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (BOOL)parseIntoMap:(CMPMap *)map error:(NSError **)error {
    uint8_t buffer[3];
    [self.data getBytes:buffer length:3];
    
    if (buffer[0] != 'V') {
        if (error) {
            NSString *localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"Unexpected '%c' found, was expecting 'V'.", nil), buffer[0]];
            *error = CMPMapParserUnexpectedDataError(localizedDescription);
        }
        
        return NO;
    }
    
    if (buffer[2] != ';') {
        if (error) {
            NSString *localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"Unexpected '%c' found, was expecting ';'.", nil), buffer[0]];
            *error = CMPMapParserUnexpectedDataError(localizedDescription);
        }
        
        return NO;
    }
    
    CMPMapParser *internalParser;
    
    switch (buffer[1]) {
        case 1:
            internalParser = [[CMPV1MapParser alloc] initWithData:[self.data subdataWithRange:NSMakeRange(3, self.data.length - 3)]];
            break;
            
        default:
            if (error) {
                NSString *localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"Unknown map version '%c' found.", nil), buffer[1]];
                *error = [NSError errorWithDomain:CMPMapParserErrorDomain
                                             code:CMPMapParserErrorCodeUnknownVersion
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey: localizedDescription
                                                    }];
            }
            
            return NO;
    }
    
    return [internalParser parseIntoMap:map error:error];
}

@end
