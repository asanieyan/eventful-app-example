//
//  EFFormInputValidator.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-22.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFFormInputValidator.h"
#import "EFGeoLocatorService.h"

static NSString *EFFormInputValidatorErrorDomain = @"com.inputvalidator.errors";

@implementation EFFormValidatorRequired

- (BOOL)validateValue:(id)value error:(NSError *__autoreleasing *)error
{
    BOOL valid = value != nil || [value length] > 0  ;
    if ( !valid ) {
        *error = [NSError errorWithDomain:EFFormInputValidatorErrorDomain code:EFFormInputValidatorValueEmptyError userInfo:nil];
    }
    return valid;
}

@end

@interface EFFormValidatorFormat()

@property(nonatomic,strong) NSRegularExpression *regexp;

@end

@implementation EFFormValidatorFormat

+ (id)validatorWithFormat:(EFFormValidatorFormatType)format
{
    NSString *pattern = nil;
    if ( format == EFFormValidatorFormatNumber) {
        pattern = @"^-?\\d+\\.?\\d*$";
    } else {
        pattern = @"^\\w+$";
    }
    return [self validatorWithRegexPattern:pattern];
}

+ (id)validatorWithRegexPattern:(NSString *)pattern
{
    EFFormValidatorFormat *instance = [EFFormValidatorFormat new];
    NSError *error = NULL;
    instance.regexp = [NSRegularExpression regularExpressionWithPattern:pattern
                                options:NSRegularExpressionCaseInsensitive
                        error:&error];
    NSAssert(!error, @"Bad Regular Exp. Pattern %@", pattern);
    return instance;
}

- (BOOL)validateValue:(id)value error:(NSError *__autoreleasing *)error
{
    NSArray *matches = [self.regexp matchesInString:value options:0 range:NSMakeRange(0, [value length])];
    if ( matches.count == 0 ) {
        *error = [NSError errorWithDomain:EFFormInputValidatorErrorDomain code:EFFormInputValidatorInvalidFormatError userInfo:nil];
        return NO;
    }
    return YES;
}

@end

@interface EFFormValidatorRange()

@property(nonatomic,readwrite,assign) NSRange range;

@end

@implementation EFFormValidatorRange

+ (id)validatorWithRange:(NSRange)range
{
    EFFormValidatorRange *instance = [EFFormValidatorRange new];
    instance.range = range;
    return instance;    
}

- (BOOL)validateValue:(id)value error:(NSError *__autoreleasing *)error
{
    BOOL valid = [value integerValue] >= _range.location &&
            [value integerValue] < _range.location + _range.length;
    if ( !valid ) {
        *error = [NSError errorWithDomain:EFFormInputValidatorErrorDomain code:EFFormInputValidatorOutOfRangeError userInfo:nil];        
    }
    return valid;
}

@end

@interface EFFormAddressValidator()

@property(nonatomic,readwrite) EFGeoLocatorService *service;

@end

@implementation EFFormAddressValidator

+ (id)validatorWithGeolocatorService:(EFGeoLocatorService *)service
{
    EFFormAddressValidator *address = [EFFormAddressValidator new];
    address.service = service;
    return address;
}

- (id)init
{
    if ( self = [super init] ) {
        self.service = [EFGeoLocatorService sharedGeoLocator];
    }
    return self;
}

- (BOOL)validateValue:(id)value error:(NSError *__autoreleasing *)error
{
    if ( [value length] == 0) {    
        *error = [NSError errorWithDomain:EFFormInputValidatorErrorDomain code:EFFormInputValidatorValueEmptyError userInfo:nil];        
        return NO;
    }
    
    EFLocationCoordinate coord = [self.service geoLocateAddress:value];
    if ( coord.longitude == NSNotFound ) {
        *error = [NSError errorWithDomain:EFFormInputValidatorErrorDomain code:EFFormInputValidatorNotFoundError userInfo:nil];        
        return NO;
    }
    return YES;
}

@end

@interface EFFormBlockInputValidator()

@property(nonatomic,readwrite) EFFormValidatorBlock validatorBlock;

@end

@implementation EFFormBlockInputValidator

+ (instancetype)validatorWithBlock:(EFFormValidatorBlock)validatorBlock
{
    EFFormBlockInputValidator *instance = [EFFormBlockInputValidator new];
    instance.validatorBlock = validatorBlock;
    return instance;
}

- (BOOL)validateValue:(id)value error:(NSError *__autoreleasing *)error
{
    return self.validatorBlock(value, error);
}

@end