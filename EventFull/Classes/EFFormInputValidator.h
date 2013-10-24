//
//  EFFormInputValidator.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-22.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EFGeoLocatorService;

/**
 Some generic error codes
*/
typedef enum EFFormInputValidatorErrorCode {
  EFFormInputValidatorOutOfRangeError,
  EFFormInputValidatorInvalidFormatError,
  EFFormInputValidatorNotFoundError,
  EFFormInputValidatorValueEmptyError
} EFFormInputValidatorErrorCode;

/**
 @protocol
 
 Input validator protocol.
 
 Any object can be an invalidator as long as it conforms to this
 protocol
*/
@protocol EFFormInputValidator <NSObject>

/**
 @method
 
 Validates a value and return true or false depending if the value is validar 
 It can also return an error object back
*/
- (BOOL)validateValue:(id)value error:(NSError**)error;

@end

/**
 @class
 
 Presence Validator
*/
@interface EFFormValidatorRequired : NSObject<EFFormInputValidator>
@end

/**
 Some common format
 
 @todo add more later
*/
typedef enum EFFormValidatorFormatType {
  EFFormValidatorFormatNumber,
  EFFormValidatorFormatWord,
} EFFormValidatorFormatType ;

/**
 @class
 
 Format Validator
*/
@interface EFFormValidatorFormat : NSObject<EFFormInputValidator>

/**
 Instantiate using a format type
*/
+ (instancetype)validatorWithFormat:(EFFormValidatorFormatType)format;

/**
 Instantiate using a reg ex
*/
+ (instancetype)validatorWithRegexPattern:(NSString*)pattern;

@end

/**
 @class
 
 Validates a range
*/
@interface EFFormValidatorRange : NSObject<EFFormInputValidator>

/**
 Instantiate a range validator
*/
+ (instancetype)validatorWithRange:(NSRange)range;

/**
 @property
 Range property
 
 The validator uses inclusive range to validate a value
 
 @example
 Range between 1..300. Validate range >= 1 and <= 300
*/
@property(nonatomic,readonly) NSRange range;

@end

/**
 @class
 
 Validates an address
*/
@interface EFFormAddressValidator  : NSObject<EFFormInputValidator>

/**
 @method
 
 Intantiate a validator with a custom geolocator service
*/
+ (instancetype)validatorWithGeolocatorService:(EFGeoLocatorService*)service;

/**
 @property
 
 The geolocator service used for address verification. The default value is
 [EFGeoLocatorService sharedGeoLocator];
 
*/
@property(nonatomic,readonly) EFGeoLocatorService *service;

@end

/**
 @typedef
 
 Validating block
*/
typedef BOOL(^EFFormValidatorBlock)(id value, NSError** error);

/**
 @class

 uses a custom block to peform validation
*/
@interface EFFormBlockInputValidator : NSObject<EFFormInputValidator>

/**
 @method
 
 Instnatiate a validator with a block
*/
+ (instancetype)validatorWithBlock:(EFFormValidatorBlock)validatorBlock;

@property(nonatomic,readonly) EFFormValidatorBlock validatorBlock;

@end

