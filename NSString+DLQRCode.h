//
//  NSString+DLQRCode.h
//  TestHook
//
//  Created by famulei on 27/03/2017.
//  Copyright © 2017 famulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (DLQRCode)
- (UIImage *)dl_qrcodeWithSize:(CGSize)size logoImage:(UIImage *)logoImage logoSize:(CGSize)logoSize;
@end
