//
//  CMPV1MapParser.m
//  Compass
//
//  Created by Grant Butler on 12/5/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPV1MapParser.h"
#import "CMPMap.h"

@implementation CMPV1MapParser

- (BOOL)readBytes:(void *)buffer range:(NSRange)range error:(NSError **)error {
    if (NSMaxRange(range) > self.data.length) {
        if (error) {
            NSString *localzedDescription = [NSString stringWithFormat:NSLocalizedString(@"Trying to read %i bytes, but only %i bytes available.", nil), NSMaxRange(range), self.data.length];
            *error = [NSError errorWithDomain:CMPMapParserErrorDomain
                                         code:CMPMapParserErrorCodeNotEnoughBytes
                                     userInfo:@{
                                                NSLocalizedDescriptionKey: localzedDescription
                                                }];
        }
        
        return NO;
    }
    
    [self.data getBytes:buffer range:range];
    
    return YES;
}

- (BOOL)parseIntoMap:(CMPMap *)map error:(NSError *__autoreleasing *)error {
    uint32_t startIndex = 0;
    
    uint8_t width = 0;
    uint8_t height = 0;
    uint8_t layerCount = 0;
    NSString *tilesetFilename;
    NSMutableArray *layers = [NSMutableArray array];
    
    while (startIndex < self.data.length) {
        uint8_t key;
        NSError *readKeyError;
        
        if (![self readBytes:&key range:NSMakeRange(startIndex, sizeof(key)) error:&readKeyError]) {
            if (error) {
                *error = readKeyError;
            }
            
            goto cleanup;
        }
        
        startIndex += sizeof(key);
        
        switch (key) {
            case 'W': {
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
                
                NSError *readWidthError;
                if (![self readBytes:&width range:NSMakeRange(startIndex, sizeof(width)) error:&readWidthError]) {
                    if (error) {
                        *error = readWidthError;
                    }
                    
                    goto cleanup;
                }
                
                startIndex += sizeof(width);
                
                break;
            }
                
            case 'H': {
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
                
                NSError *readHeightError;
                if (![self readBytes:&height range:NSMakeRange(startIndex, sizeof(height)) error:&readHeightError]) {
                    if (error) {
                        *error = readHeightError;
                    }
                    
                    goto cleanup;
                }
                
                startIndex += sizeof(height);
                
                break;
            }
                
            case 'L': {
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
                
                NSError *readLayerCountError;
                if (![self readBytes:&layerCount range:NSMakeRange(startIndex, sizeof(layerCount)) error:&readLayerCountError]) {
                    if (error) {
                        *error = readLayerCountError;
                    }
                    
                    goto cleanup;
                }
                
                startIndex += sizeof(layerCount);
                
                break;
            }
                
            case 'l': {
                if (width == 0 || height == 0) {
                    if (error) {
                        NSString *localizedDescription = NSLocalizedString(@"Trying to specify number of layers when no width or height of level has been specified.", nil);
                        *error = [NSError errorWithDomain:CMPMapParserErrorDomain
                                                     code:CMPMapParserErrorCodeInvalidSyntax
                                                 userInfo:@{
                                                            NSLocalizedDescriptionKey: localizedDescription
                                                            }];
                    }
                    
                    goto cleanup;
                }
                
                uint32_t layerSize = width * height;
                uint8_t *layer = malloc(layerSize * sizeof(uint8_t));
                
                NSError *readLayerError;
                if (![self readBytes:layer range:NSMakeRange(startIndex, layerSize) error:&readLayerError]) {
                    free(layer);
                    
                    if (error) {
                        *error = readLayerError;
                    }
                    
                    goto cleanup;
                }
                
                // We have to do the calculation again because NSData was changing the value of layerSize as part of reading bytes.
                // I dunno why it's doing that, but it's doing that. Really weird!
                startIndex += width * height;
                
                NSValue *layerValue = [NSValue valueWithPointer:layer];
                [layers addObject:layerValue];
                
                break;
            }
                
            case 'T': {
                NSMutableData *tilesetNameData = [[NSMutableData alloc] init];
                
                while (YES) {
                    char character;
                    NSError *readCharacterError;
                    
                    if (![self readBytes:&character range:NSMakeRange(startIndex, sizeof(character)) error:&readCharacterError]) {
                        if (error) {
                            *error = readCharacterError;
                        }
                        
                        goto cleanup;
                    }
                    
                    if (character == ';') {
                        break;
                    }
                    
                    startIndex += sizeof(character);
                    
                    [tilesetNameData appendBytes:&character length:sizeof(character)];
                }
                
                tilesetFilename = [[NSString alloc] initWithData:tilesetNameData encoding:NSUTF8StringEncoding];
                
                break;
            }
        }
        
        uint8_t buffer;
        NSError *readSemicolonError;
        
        if (![self readBytes:&buffer range:NSMakeRange(startIndex, sizeof(buffer)) error:&readSemicolonError]) {
            if (error) {
                *error = readSemicolonError;
            }
            
            goto cleanup;
        }
        
        startIndex += sizeof(buffer);
        
        if (buffer != ';') {
            if (error) {
                NSString *localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"Invalid file format. Expected ';', instead got '%c'.", nil), buffer];
                *error = [NSError errorWithDomain:CMPMapParserErrorDomain
                                             code:CMPMapParserErrorCodeInvalidSyntax
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey: localizedDescription
                                                    }];
            }
            
            goto cleanup;
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
    
    if (error) {
        *error = nil;
    }
    
    return YES;
    
cleanup:
    
    [layers enumerateObjectsUsingBlock:^(NSValue *layerValue, NSUInteger idx, BOOL *stop) {
        uint8_t *layerData = [layerValue pointerValue];
        free(layerData);
    }];
    
    return NO;
}

@end
