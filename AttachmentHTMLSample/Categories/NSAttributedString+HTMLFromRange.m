//
//  NSAttributedString+HTMLFromRange.m
//  AttachmentHTMLSample
//
//  Created by Farhan Yousuf on 12/21/16.
//  Copyright © 2016 July Systems Pvt. Ltd. All rights reserved.
//

#import "NSAttributedString+HTMLFromRange.h"
#import "NSString+HTMLEntities.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@implementation NSAttributedString (HTMLFromRange)

NSString* FontSizeToHTMLSize( UIFont* fnt )
{
    int     intSize = [fnt pointSize];
    
    if( intSize <= 9 )
        return @"-2";
    if( intSize <= 12 )
        return @"-1";
    if( intSize <= 14 )
        return @"4";
    if( intSize <= 16 )
        return @"+1";
    if( intSize > 16 )
        return @"+2";
    else
        return @"4";
}

NSString* ColorToHTMLColor( UIColor* tcol )
{
//    UIColor*    rgbColor = [tcol colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
    
    UIColor*    rgbColor = tcol; //[tcol colorUsingColorSpaceName: NSCalibratedRGBColorSpace];

    CGFloat       r, g, b, a;
    
    [rgbColor getRed: &r green: &g blue: &b alpha: &a];
    
    return [NSString stringWithFormat:@"#%2.2X%2.2X%2.2X", (int)(255 * r), (int)(255 * g), (int)(255 * b)];
}

-(NSString*)    HTMLFromRange: (NSRange)range
{
    __block unsigned long                location = 0;
    NSMutableString*            str = [NSMutableString string];
    NSMutableString*            endStr = [NSMutableString string];
    NSDictionary*               oldAttrs = nil;
    
    __block unsigned long    finalLen = range.location +range.length;
    
    // TODO: Use oldAttrs, add NSForegroundColorAttributeName and
    
//    attrs = [self attributesAtIndex: location effectiveRange: &effRange];
//    location = effRange.location +effRange.length;
    
    
    [self enumerateAttributesInRange:NSMakeRange(0, [self length]) options:kNilOptions usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        NSLog(@"\n\nAttribute : %@\nRange : %lu-%lu",attrs,(unsigned long)range.location,(unsigned long)range.location);
        
        location = range.location;
        
        finalLen = range.location +range.length;
        
        [attrs enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
            NSLog(@"\n\nkey --> %@\n\n%@",key,value);
            
            if ([key isEqualToString:NSAttachmentAttributeName]) {
                
                NSTextAttachment *attachment = (NSTextAttachment *)[attrs objectForKey:key];
                UIImage *image = nil;
                if ([attachment image])
                    image = [attachment image];
                else
                    image = [attachment imageForBounds:[attachment bounds]
                                         textContainer:nil
                                        characterIndex:range.location];
                
                if (image)
                {
                    
                    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
                    
                    [str appendString:[NSString stringWithFormat:@"<img src=\"data:IMAGE/PNG;BASE64,%@\" alt=\"Image\" width=\"%f\" height=\"%f\">",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength],image.size.width,image.size.height]];
                }
            }else {
                
                // Oblique changed?
                NSNumber* obliq = [attrs objectForKey: NSObliquenessAttributeName];
                if( obliq && obliq != [oldAttrs objectForKey: NSObliquenessAttributeName]
                   && [obliq floatValue] > 0 )
                {
                    [str appendString: @"<sup>"];
                    [endStr insertString: @"</sup>" atIndex: 0];
                }
                // Font/color changed?
                UIFont* fnt = [attrs objectForKey: NSFontAttributeName];
                UIColor* tcol = [attrs objectForKey: NSForegroundColorAttributeName];
                if( fnt || tcol )
                {
                    [str appendString: @"<font"];
                    if( fnt )
                    {
                        [str appendFormat: @" face=\"%@\"", [fnt familyName]];
                        [str appendFormat: @" size=\"%@\"", FontSizeToHTMLSize(fnt)];
                    }
                    if( tcol )
                    {
                        [str appendFormat: @" color=\"%@\"", ColorToHTMLColor(tcol)];
                    }
                    [str appendString: @">"];
                    [endStr insertString: @"</font>" atIndex: 0];
                    
                    UIFontDescriptor *fontDescriptor = fnt.fontDescriptor;
                    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
                    
                    if( (fontDescriptorSymbolicTraits & UIFontDescriptorTraitItalic) == UIFontDescriptorTraitItalic )
                    {
                        if( !obliq || [obliq floatValue] == 0 ) // Don't apply twice.
                        {
                            [str appendString: @"<i>"];
                            [endStr insertString: @"</i>" atIndex: 0];
                        }
                    }
                    
                    
                    if( (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) == UIFontDescriptorTraitBold
                       || [fontDescriptor.fontAttributes[UIFontWeightTrait] integerValue] >= 9 )
                    {
                        [str appendString: @"<b>"];
                        [endStr insertString: @"</b>" atIndex: 0];
                    }
                    
                    if( (fontDescriptorSymbolicTraits & UIFontDescriptorClassMask) == UIFontDescriptorClassMask )
                    {
                        [str appendString: @"<tt>"];
                        [endStr insertString: @"</tt>" atIndex: 0];
                    }
                }
                // Superscript changed?
                NSNumber* supers = [attrs objectForKey: (__bridge NSString *)kCTSuperscriptAttributeName];
                if( supers && supers != [oldAttrs objectForKey: (__bridge NSString *)kCTSuperscriptAttributeName] )
                {
                    [str appendString: @"<sup>"];
                    [endStr insertString: @"</sup>" atIndex: 0];
                }
                
            }
            
        }];
        
        // Actual text and closing tags:
        [str appendString: [[[self string] substringWithRange:range] stringByInsertingHTMLEntitiesAndLineBreaks: YES]];
        [str appendString: endStr];
        
    }];
    
    return str;
}

@end
