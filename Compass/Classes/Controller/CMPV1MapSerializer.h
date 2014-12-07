//
//  CMPV1MapSerializer.h
//  Compass
//
//  Created by Grant Butler on 12/7/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import Foundation;

@class CMPMap;

@interface CMPV1MapSerializer : NSObject

- (NSData *)serializeMap:(CMPMap *)map;

@end
