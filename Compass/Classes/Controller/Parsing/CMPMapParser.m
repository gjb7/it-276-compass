
//
//  CMPMapParser.m
//  Compass
//
//  Created by Grant Butler on 12/5/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMapParser.h"

#import "CMPV1MapParser.h"

#import "CMPDataReader.h"

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
        _dataReader = [[CMPDataReader alloc] initWithData:data];
    }
    return self;
}

- (BOOL)parseIntoMap:(CMPMap *)map error:(NSError **)error {
    NSString *key;
    NSData *value;
    
    if (![self.dataReader readNextKey:&key value:&value]) {
        if (error) {
            NSString *localizedDescription = NSLocalizedString(@"Did not read version of map.", nil);
            *error = CMPMapParserUnexpectedDataError(localizedDescription);
        }
        
        return NO;
    }
    
    if (![key isEqualToString:@"V"]) {
        if (error) {
            NSString *localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"Unexpected '%@' found, was expecting 'V'.", nil), key];
            *error = CMPMapParserUnexpectedDataError(localizedDescription);
        }
        
        return NO;
    }
    
    CMPMapParser *internalParser;
    uint8_t version;
    [value getBytes:&version length:sizeof(version)];
    
    switch (version) {
        case 1:
            internalParser = [[CMPV1MapParser alloc] initWithData:self.dataReader.remainingData];
            break;
            
        default:
            if (error) {
                NSString *localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"Unknown map version '%c' found.", nil), version];
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
