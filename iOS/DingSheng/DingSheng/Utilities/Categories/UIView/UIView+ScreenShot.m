//
//  UIView+ScreenShot.m
//  Goal
//
//  Created by Jianying Shi on 8/17/14.
//
//

#import "UIView+ScreenShot.h"

@implementation UIView (ScreenShot)

- (UIImage*) convertViewToImage{
    
    if ( [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        UIGraphicsBeginImageContext(self.bounds.size);
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    else {
        CGRect rect;
        rect = self.frame;
        
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];
        
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
}

@end
