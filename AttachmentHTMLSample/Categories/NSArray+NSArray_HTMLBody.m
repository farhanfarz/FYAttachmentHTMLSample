//
//  NSArray+NSArray_HTMLBody.m
//  AttachmentHTMLSample
//
//  Created by Farhan Yousuf on 08/06/16.
//  Copyright © 2016 July Systems Pvt. Ltd. All rights reserved.
//

#import "NSArray+NSArray_HTMLBody.h"
#import <UIKit/UIKit.h>
#import "NSMutableAttributedString+NSMutableAttributedString_HTMLBase64.h"

@implementation NSArray (NSArray_HTMLBody)
- (NSString *)htmlBody {
    
    NSMutableString *html = [NSMutableString stringWithString:@"<!DOCTYPE html><html><body>"];
    
    for (NSDictionary *htmlBodyDictionary in self) {
        
        NSString *textString = htmlBodyDictionary[@"text"];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = htmlBodyDictionary[@"attachment"];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
        
        NSAttributedString *attstringImage = [NSAttributedString  attributedStringWithAttachment:textAttachment];
        
        [attributedString appendAttributedString:attstringImage];
        
        [html appendString:[attributedString htmlStringWithBase64Encoding]];
    }
    
    [html appendString:@"</body></html>"];
    
    return html;
}

@end
