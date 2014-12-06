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

- (BOOL)parseIntoMap:(CMPMap *)map error:(NSError *__autoreleasing *)error {
    uint32_t startIndex = 0;
    
    uint8_t width = 0;
    uint8_t height = 0;
    uint8_t layerCount = 0;
    NSString *tilesetFilename;
    NSMutableArray *layers = [NSMutableArray array];
    
    while (startIndex < self.data.length) {
        uint8_t key;
        [self.data getBytes:&key range:NSMakeRange(startIndex, sizeof(key))];
        startIndex += sizeof(key);
        
        switch (key) {
            case 'W':
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
                
                [self.data getBytes:&width range:NSMakeRange(startIndex, sizeof(width))];
                startIndex += sizeof(width);
                
                break;
                
            case 'H':
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
                
                [self.data getBytes:&height range:NSMakeRange(startIndex, sizeof(height))];
                startIndex += sizeof(height);
                
                break;
                
            case 'L':
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
                
                [self.data getBytes:&layerCount range:NSMakeRange(startIndex, sizeof(layerCount))];
                startIndex += sizeof(layerCount);
                
                break;
                
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
                
                [self.data getBytes:layer range:NSMakeRange(startIndex, layerSize)];
                startIndex += layerSize;
                
                NSValue *layerValue = [NSValue valueWithPointer:layer];
                [layers addObject:layerValue];
                
                break;
            }
                
            case 'T': {
                NSMutableData *tilesetNameData = [[NSMutableData alloc] init];
                
                while (YES) {
                    char character;
                    [self.data getBytes:&character range:NSMakeRange(startIndex, sizeof(character))];
                    
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
        [self.data getBytes:&buffer range:NSMakeRange(startIndex, sizeof(buffer))];
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
    
    
    return YES;
    
cleanup:
    
    [layers enumerateObjectsUsingBlock:^(NSValue *layerValue, NSUInteger idx, BOOL *stop) {
        uint8_t *layerData = [layerValue pointerValue];
        free(layerData);
    }];
    
    return NO;
}

@end
