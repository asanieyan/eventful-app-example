//
//  EFFormMessageDisplayer.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-23.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EFForm;
@protocol EFFormElement;

/**
 @class
 
 Handles displaying visual messages for a form
*/
@interface EFFormMessageDisplayer : NSObject

/**
 @method
 
 Intializer
*/
- (id)initWithForm:(EFForm*)form;

/** @property Form property */
@property(nonatomic,readonly) EFForm *form;

/**
 @method
 
 Shows a message for an element 
 
 @todo 
 at the time only shows message with error type, later must be able to 
 pass the type of message
*/
- (void)displayMessage:(NSString*)message forElement:(NIFormElement<EFFormElement>*)element;

/**
 @method
 
 If a message is displaying for an element, it will hide it
*/
- (void)hideMessageForElement:(NIFormElement<EFFormElement>*)element;

@end
