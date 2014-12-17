//
//  UIImage+CMPAdditions.m
//  Compass
//
//  Created by Grant Butler on 12/17/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "UIImage+CMPAdditions.h"

@implementation UIImage (CMPAdditions)

- (UIImage *)imageWithRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect drawRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGImageRef drawImage = CGImageCreateWithImageInRect(self.CGImage, rect);
    if (drawImage != NULL) {
        // Push current graphics state so we can restore later
        CGContextSaveGState(context);
        
        // Take care of Y-axis inversion problem by translating the context on the y axis
        CGContextTranslateCTM(context, 0, drawRect.origin.y + rect.size.height);
        
        // Scaling -1.0 on y-axis to flip
        CGContextScaleCTM(context, 1.0, -1.0);
        
        // Then accommodate the translate by adjusting the draw rect
        drawRect.origin.y = 0.0f;
        
        // Draw the image
        CGContextDrawImage(context, drawRect, drawImage);
        
        // Clean up memory and restore previous state
        CGImageRelease(drawImage);
        
        // Restore previous graphics state to what it was before we tweaked it
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
