//
//  EFForm.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-21.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIFormElement+EFFormElement.h"


/**
 @abstract
 
 A wrapper to connect a UITableView with NIMutableTableModel to create
 a form
*/
@interface EFForm : NSObject

/**
 @method
 
 @abstract
 
 Initializer
*/
- (id)initWithTableView:(UITableView*)tableView;

/**
 @class
 
 @abstract
 
 Form table view
*/
@property(nonatomic,readonly) UITableView *tableView;

/**
 @method
 
 @abstract
 
 Adds a form element to the form
*/
- (void)addFormElement:(NIFormElement<EFFormElement>*)formElement;

/**
 @method
 
 Gets an element from form
*/
- (NIFormElement<EFFormElement>*)elementWithID:(NSInteger)elementID;
- (NIFormElement<EFFormElement>*)objectForKeyedSubscript:(id)key;

/** @abstract return an array of form elements */
@property(nonatomic,readonly) NSArray *elements;

/**
 @class
 
 @abstract
 
 Form table view
*/
@property(nonatomic,readonly) NIMutableTableViewModel *tableModel;

@end

#import "EFFormValidator.h"
#import "EFFormMessageDisplayer.h"

/**
 @category
 
 @abstract
 This category adds a form validator to a form
*/
@interface EFForm(EFFormValidator)

/** @abstract return an array of form elements */
@property(nonatomic,readonly) EFFormValidator *formValidator;

/**
 @method
 
 @abstract
 Adds a validator to an element of the form with ID
*/
- (void)addValidator:(id)validator forElementWithID:(NSInteger)elementID;

/**
 @method
 
 @abstract
 Add a set of validators for an element
*/
- (void)addValidators:(id<NSFastEnumeration>)validators forElementWithID:(NSInteger)elementID;

@end
