//
//  UIImage+FrostedGlass.m
//  Goal
//
//  Created by Peter van de Put on 16/08/2014.
//
//

#import "UIImage+FrostedGlass.h"

@implementation UIImage (FrostedGlass)
-(UIImage *)frostedGlassImage{
      UIImage *originalImage = self;
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    [gaussianBlurFilter setValue:[CIImage imageWithCGImage:[originalImage CGImage]] forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@5 forKey:kCIInputRadiusKey];
    
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context   = [CIContext contextWithOptions:nil];
    CGRect rect          = [outputImage extent];
    
    // these three lines ensure that the final image is the same size
    
    rect.origin.x        += (rect.size.width  - originalImage.size.width * originalImage.scale ) / 2;
    rect.origin.y        += (rect.size.height - originalImage.size.height * originalImage.scale) / 2;
    rect.size.width            = originalImage.size.width * originalImage.scale;
    rect.size.height           = originalImage.size.height * originalImage.scale;
    
    CGImageRef cgimg     = [context createCGImage:outputImage fromRect:rect];
    UIImage *resultImage       = [UIImage imageWithCGImage:cgimg scale:originalImage.scale orientation:originalImage.imageOrientation];
    CGImageRelease(cgimg);
    return  resultImage;
     
}
@end
