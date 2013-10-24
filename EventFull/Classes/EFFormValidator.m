//
//  EFFormValueValidator.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-21.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFFormValidator.h"
#import "NIFormElement+EFFormElement.h"
#import <objc/runtime.h>


#pragma mark

@interface EFFormValidator()
{
    dispatch_queue_t _validatorQueue;
    NSMapTable *_elementValidators;
    BOOL _running;
}

@end

@implementation EFFormValidator

- (id)init
{
    if ( self = [super init] ) {
        _elementValidators = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory];
        _validatorQueue    =  dispatch_queue_create("EFFormValidatorQueue", NULL);
        _running = NO;
    }    
    return self;
}

- (void)validate
{
    if ( !_running ) {
        dispatch_async(_validatorQueue, ^{
            [self validateInBackground];
        });
    }
}

- (void)validateElement:(NIFormElement<EFFormElement>*)element
{
    dispatch_async(_validatorQueue, ^{
        [self validateElementInBackGround:element];
    });
}

- (void)validateInBackground
{
    _running = YES;
    @weakify(self);
    BOOL allValid = YES;
    if ( [self.delegate respondsToSelector:@selector(formValidatorWillStartValidation:)] ) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.delegate formValidatorWillStartValidation:self];
        });
    }
    for( NIFormElement<EFFormElement> *element in _elementValidators.keyEnumerator ) {
        allValid = [self validateElementInBackGround:element] && allValid;
    }
    
    if ( [self.delegate respondsToSelector:@selector(formValidatorDidCompletetValidation:succeed:)] ) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.delegate formValidatorDidCompletetValidation:self succeed:allValid];
        });
    }    
    _running = NO;
}

- (BOOL)validateElementInBackGround:(NIFormElement<EFFormElement>*)element
{    
    @weakify(self);    
    BOOL elementValid = YES;
    for(id<EFFormInputValidator> validator in  [_elementValidators objectForKey:element])
    {
       __block NSError *error = nil;
       BOOL valid = [validator validateValue:element.value error:&error];
       if ( !valid ) {
            if ([self.delegate respondsToSelector:@selector(formValidator:inputValidator:didFailValidating:error:)]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self.delegate formValidator:self inputValidator:validator didFailValidating:element error:error];
                });
            }
            elementValid = NO;
            break;
       }
    }
    if ( elementValid ) {
            if ([self.delegate respondsToSelector:@selector(formValidator:formElementIsValid:)]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self.delegate formValidator:self formElementIsValid:element];
                });
            }        
    }
    return elementValid;
}

- (NSMutableArray*)validatorsForElement:(NIFormElement<EFFormElement> *)element
{
    if ( ![_elementValidators objectForKey:element] ) {
        [_elementValidators setObject:[NSMutableArray array] forKey:element];
    }
    return (NSMutableArray*)[_elementValidators objectForKey:element];
}

- (void)addValidators:(id<NSFastEnumeration>)validators forElement:(NIFormElement<EFFormElement> *)element
{
    for ( EFFormValidator *validator in validators ) {
        [self addValidator:validator forElement:element];
    }
}

- (void)addValidator:(id)validator forElement:(NIFormElement<EFFormElement> *)element
{
    [[self validatorsForElement:element] addObject:validator];
}

@end
