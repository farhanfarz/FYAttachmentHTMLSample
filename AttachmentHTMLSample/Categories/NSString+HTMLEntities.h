//
//  NSString+HTMLEntities.h
//  AttachmentHTMLSample
//
//  Created by Farhan Yousuf on 12/21/16.
//  Copyright © 2016 July Systems Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTMLEntities)

-(NSString*) stringByInsertingHTMLEntities;
-(NSString*) stringByInsertingHTMLEntitiesAndLineBreaks: (BOOL)br;

@end
