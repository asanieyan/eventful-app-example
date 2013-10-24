//
//  EFFormValueValidator.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-21.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EFFormInputValidator.h"

@class EFFormValidator;
@protocol EFFormElement;

/**
 @protocol
 
 EFFormValidator delegate that can react to the validation stages
 
 @todo better be done later with RAC
*/
@protocol EFFormValidatorDelegate <NSObject>

/**
 @method
 
 Delegate method called when the validator starts to validate
*/
- (void)formValidatorWillStartValidation:(EFFormValidator*)formValidator;

/**
 @method
 
 Delegate method called when the validator completed the validation with a suceed boolean 
 value
*/
- (void)formValidatorDidCompletetValidation:(EFFormValidator*)formValidator succeed:(BOOL)suceed;

@optional

/**
 @method
 
 Delegate method called when the an input validator fails validating a value of a form element
*/
- (void)formValidator:(EFFormValidator*)formValidator
        inputValidator:(id<EFFormInputValidator>)inputValidator
        didFailValidating:(NIFormElement<EFFormElement>*)formElement
        error:(NSError*)error;

/**
 @method
 
 Delegate method called when the a form element succeed all of its validators
*/
- (void)formValidator:(EFFormValidator*)formValidator
        formElementIsValid:(NIFormElement<EFFormElement>*)formElement;

@end

/**
 @class
 
 @abstract
*/
@interface EFFormValidator : NSObject

/** Validator delegate */
@property(nonatomic,assign) id<EFFormValidatorDelegate> delegate;

/**
 @method
 
 @abstract
*/
- (void)addValidators:(id<NSFastEnumeration>)validators forElement:(NIFormElement<EFFormElement> *)element;

/**
 @method
 
 @abstract
*/
- (void)addValidator:(id)validator forElement:(NIFormElement<EFFormElement>*)element;

/**
 @method
 
 Validates a form an calls the delegate to update the listener of the validation status
 
 This method is non blocking and will return immedietly. The delegate method will be called on the main thread
 
*/
- (void)validate;

/**
 @method
 
 Validates an element and calls the delegate
 
 This method is non blocking and will return immedietly. The delegate method will be called on the main thread
 
*/
- (void)validateElement:(NIFormElement<EFFormElement>*)element;

@end
