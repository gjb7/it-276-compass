//
//  NSString+CMPAdditions.m
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "NSString+CMPAdditions.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (CMPAdditions)

- (NSString *)MD5Hash {
    unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    unsigned int length = (unsigned int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    CC_MD5(self.UTF8String, length, output);
    
    NSMutableString *hashString = [NSMutableString string];
    for (unsigned int i = 0; i < outputLength; i++) {
        [hashString appendFormat:@"%02x", output[i]];
    }
    return hashString;
}

@end
