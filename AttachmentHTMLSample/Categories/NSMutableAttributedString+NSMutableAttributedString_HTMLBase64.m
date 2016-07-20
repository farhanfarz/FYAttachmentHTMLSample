//
//  NSAttributedString+NSAttributedString_HTMLBase64.m
//  AttachmentHTMLSample
//
//  Created by Farhan Yousuf on 08/06/16.
//  Copyright © 2016 July Systems Pvt. Ltd. All rights reserved.
//

#import "NSMutableAttributedString+NSMutableAttributedString_HTMLBase64.h"
#import <UIKit/UIKit.h>

@implementation NSMutableAttributedString (NSMutableAttributedString_HTMLBase64)

- (NSString *)htmlStringWithBase64Encoding {
    
    __block UIImage *currentImage = nil;
//    __block NSRange imageRange;
    __block NSMutableString *body = [NSMutableString new];
    
    // Do the styling here
    
    [body appendString:[NSString stringWithFormat:@"<h2>%@</h2>",[self string]]];
    
    [self enumerateAttribute:NSAttachmentAttributeName
                              inRange:NSMakeRange(0, [self length])
                              options:0
                           usingBlock:^(id value, NSRange range, BOOL *stop)
     {
         if ([value isKindOfClass:[NSTextAttachment class]])
         {
             NSTextAttachment *attachment = (NSTextAttachment *)value;
             UIImage *image = nil;
             if ([attachment image])
                 image = [attachment image];
             else
                 image = [attachment imageForBounds:[attachment bounds]
                                      textContainer:nil
                                     characterIndex:range.location];
             
             if (image)
             {
                 currentImage = image;
//                 imageRange = range;
                 
                 NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
                 
                 [body appendString:[NSString stringWithFormat:@"<img src=\"data:IMAGE/PNG;BASE64,%@\" alt=\"Image\" width=\"400\" height=\"200\"",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]]];
             }
         }
     }];
    
    return  body;
}

@end
