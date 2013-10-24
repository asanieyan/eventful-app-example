//
//  EFDatePickerCell.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-20.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

@class EFDatePickerFormElement;

/**
 A Helper method to return an input view for a text that contains a 
 picker
*/
extern void EFTextFieldInputViewWithPickerView(UITextField *textField, UIView* pickerView);

/**
 @abstract
 
 A date picker form element.
 
 This form element uses EFDatePickerCell as it's cell class
*/
@interface EFDatePickerFormElement : NIDatePickerFormElement

/** 
 Adjust its date using another date element
 
 @abstract 
 The date is always adjusted by +1 day

 @todo provide option to set the adjustment value
*/

@property(nonatomic,assign) EFDatePickerFormElement *adjustDateUsingDatePickerElement;

@end

/**
 @abstract
 Date picker cell class
 
 It uses a EFDatePickerFormElement to create a cell. 
*/
@interface EFDatePickerCell : NIDatePickerFormElementCell

@end
