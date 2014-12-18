//
//  CMPDataReader.m
//  Compass
//
//  Created by Grant Butler on 12/18/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPDataReader.h"

@interface CMPDataReader ()

@property (nonatomic) NSUInteger readIndex;

@end

@implementation CMPDataReader

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _sourceData = data;
    }
    return self;
}

- (BOOL)readNextKey:(NSString **)key value:(NSData **)value {
    if (self.readIndex == self.sourceData.length) {
        return NO;
    }
    
    char keyChar;
    [self.sourceData getBytes:&keyChar range:NSMakeRange(self.readIndex, sizeof(keyChar))];
    
    self.readIndex += sizeof(keyChar);
    
    NSMutableData *buffer = [[NSMutableData alloc] init];
    
    while (YES) {
        char character;
        [self.sourceData getBytes:&character range:NSMakeRange(self.readIndex, sizeof(character))];
        
        if (character == ';') {
            break;
        }
        
        self.readIndex += sizeof(character);
        
        [buffer appendBytes:&character length:sizeof(character)];
    }
    
    char semicolon;
    [self.sourceData getBytes:&semicolon range:NSMakeRange(self.readIndex, sizeof(semicolon))];
    
    self.readIndex += sizeof(semicolon);
    
    if (semicolon != ';') {
        return NO;
    }

    if (key != NULL) {
        *key = [NSString stringWithFormat:@"%c", keyChar];
    }
    
    if (value != NULL) {
        *value = buffer;
    }
    
    return YES;
}

- (NSData *)remainingData {
    return [self.sourceData subdataWithRange:NSMakeRange(self.readIndex, self.sourceData.length - self.readIndex)];
}

@end
