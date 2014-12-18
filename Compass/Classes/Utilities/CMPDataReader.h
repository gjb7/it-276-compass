//
//  CMPDataReader.h
//  Compass
//
//  Created by Grant Butler on 12/18/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import Foundation;

@interface CMPDataReader : NSObject

@property (nonatomic, readonly) NSData *sourceData;
@property (nonatomic, readonly) NSData *remainingData;

- (instancetype)initWithData:(NSData *)data NS_DESIGNATED_INITIALIZER;

- (BOOL)readNextKey:(NSString **)key value:(NSData **)value;

@end
