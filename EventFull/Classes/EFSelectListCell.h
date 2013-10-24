//
//  EFSelectListCell.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-23.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFSelectListFormElement : NIFormElement

/**
 @method
 
 Instantiate a list
*/
+ (id)listWithElementWithID:(NSInteger)elementID labelText:(NSString *)labelText keyValuePairs:(NSDictionary*)keyValuePairs;

/** The selected value */
@property (nonatomic,strong) id value;
@property (nonatomic, copy) NSString *labelText;
@property (nonatomic, strong) NSDictionary *keyValuePairs;

@end

@interface EFSelectListCell : NIFormElementCell <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, readonly) UITextField *valueField;
@property (nonatomic, readonly) UIPickerView *valuePicker;

@end
