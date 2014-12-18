//
//  CMPV1MapParser.m
//  Compass
//
//  Created by Grant Butler on 12/5/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPV1MapParser.h"
#import "CMPMap.h"
#import "CMPDataReader.h"

@implementation CMPV1MapParser

- (BOOL)parseIntoMap:(CMPMap *)map error:(NSError *__autoreleasing *)error {
    uint8_t width = 0;
    uint8_t height = 0;
    uint8_t layerCount = 0;
    NSString *tilesetFilename;
    NSMutableArray *layers = [NSMutableArray array];
    
    NSString *key;
    NSData *value;
    
    while ([self.dataReader readNextKey:&key value:&value]) {
        if ([key isEqualToString:@"W"]) {
            if (width != 0) {
                if (error) {
                    NSString *localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"Attempting to set width, when width already set to %i", nil), width];
                    *error = [NSError errorWithDomain:CMPMapParserErrorDomain
                                                 code:CMPMapParserErrorCodeValueAlreadyParsed
                                             userInfo:@{
                                                        NSLocalizedDescriptionKey: localizedDescription
                                                        }];
                }
                
                goto cleanup;
            }
            
            [value getBytes:&width length:sizeof(width)];
        }
        else if ([key isEqualToString:@"H"]) {
            if (height != 0) {
                if (error) {
                    NSString *localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"Attempting to set height, when height already set to %i", nil), height];
                    *error = [NSError errorWithDomain:CMPMapParserErrorDomain
                                                 code:CMPMapParserErrorCodeValueAlreadyParsed
                                             userInfo:@{
                                                        NSLocalizedDescriptionKey: localizedDescription
                                                        }];
                }
                
                goto cleanup;
            }
            
            [value getBytes:&height length:sizeof(height)];
        }
        else if ([key isEqualToString:@"L"]) {
            if (layerCount != 0) {
                if (error) {
                    NSString *localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"Attempting to set layerCount, when layerCount already set to %i", nil), layerCount];
                    *error = [NSError errorWithDomain:CMPMapParserErrorDomain
                                                 code:CMPMapParserErrorCodeValueAlreadyParsed
                                             userInfo:@{
                                                        NSLocalizedDescriptionKey: localizedDescription
                                                        }];
                }
                
                goto cleanup;
            }
            
            [value getBytes:&layerCount length:sizeof(layerCount)];
        }
        else if ([key isEqualToString:@"T"]) {
            tilesetFilename = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
        }
        else if ([key isEqualToString:@"l"]) {
            if (value.length != width * height) {
                if (error) {
                    NSString *localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"Found layer of size %i. Needs to be size %i", nil), value.length, (width * height)];
                    *error = [NSError errorWithDomain:CMPMapParserErrorDomain
                                                 code:CMPMapParserErrorCodeInvalidSyntax
                                             userInfo:@{
                                                        NSLocalizedDescriptionKey: localizedDescription
                                                        }];
                }
                
                return NO;
            }
            
            [layers addObject:value];
        }
    }
    
    if (layers.count <= 0) {
        if (error) {
            NSString *localizedDescription = NSLocalizedString(@"Invalid file format. No layers found.", nil);
            *error = [NSError errorWithDomain:CMPMapParserErrorDomain
                                         code:CMPMapParserErrorCodeInvalidSyntax
                                     userInfo:@{
                                                NSLocalizedDescriptionKey: localizedDescription
                                                }];
        }
        
        goto cleanup;
    }
    
    if (!tilesetFilename) {
        if (error) {
            NSString *localizedDescription = NSLocalizedString(@"Invalid file format. No tilesheet filename provided.", nil);
            *error = [NSError errorWithDomain:CMPMapParserErrorDomain
                                         code:CMPMapParserErrorCodeInvalidSyntax
                                     userInfo:@{
                                                NSLocalizedDescriptionKey: localizedDescription
                                                }];
        }
        
        goto cleanup;
    }
    
    map.tilesheetPath = tilesetFilename;
    
    if (layers.count < layerCount) {
        if (error) {
            NSString *localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"Invalid file format. Found %i layers when %i specified.", nil), layers.count, layerCount];
            *error = [NSError errorWithDomain:CMPMapParserErrorDomain
                                         code:CMPMapParserErrorCodeInvalidSyntax
                                     userInfo:@{
                                                NSLocalizedDescriptionKey: localizedDescription
                                                }];
        }
        
        goto cleanup;
    }
    
    map.layers = layers;
    
    map.size = CGSizeMake(width, height);
    
    if (error) {
        *error = nil;
    }
    
    return YES;
    
cleanup:
    return NO;
}

@end
