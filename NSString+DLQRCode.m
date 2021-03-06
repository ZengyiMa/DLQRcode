//
//  NSString+DLQRCode.m
//  TestHook
//
//  Created by famulei on 27/03/2017.
//  Copyright © 2017 famulei. All rights reserved.
//

#import "NSString+DLQRCode.h"

@implementation NSString (DLQRCode)

- (UIImage *)dl_qrcodeWithSize:(CGSize)size logoImage:(UIImage *)logoImage logoSize:(CGSize)logoSize;
{
    if (logoImage && !CGSizeEqualToSize(logoSize, CGSizeZero)) {
        UIGraphicsBeginImageContextWithOptions(size, NO, logoImage.scale);
        [logoImage drawInRect:CGRectMake(size.width / 2 - logoSize.width / 2, size.height / 2 - logoSize.height / 2, logoSize.width, logoSize.height)];
        logoImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        logoImage = nil;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    // 纠错等级提高，携带图片更可靠
    [filter setValue:@"H" forKey: @"inputCorrectionLevel"];

    CIImage *image = [filter valueForKey:@"outputImage"];
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width / CGRectGetWidth(extent), size.height / CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
#if TARGET_OS_IPHONE
    CIContext *context = [CIContext contextWithOptions:nil];
#else
    CIContext *context = [CIContext contextWithCGContext:bitmapRef options:nil];
#endif
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    if (logoImage) {
        CGContextDrawImage(bitmapRef, extent, logoImage.CGImage);
    }
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *qrcodeImage = [UIImage imageWithCGImage:scaledImage];
    return qrcodeImage;
}


@end
