//
//  NIFormElement+EFFormElement.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-21.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "NIFormCellCatalog.h"

#import "EFDatePickerCell.h"  
#import "EFSelectListCell.h"
#import "EFTextInputFormElementCell.h"

/**
 @protocol
  
 @abstract
 
 Creates an interface for the NIFormElement object to access its input value 
*/
@protocol EFFormElement <NICellObject>

/**
 @property
  
 @abstract
 
 Creates an interface for the NIFormElement object to access its input value 
*/
@property(nonatomic,readwrite) id value;

@end


/**
 Adding EFFormElement category to some of the existing form element
*/
@interface EFDatePickerFormElement(EFFormElement) <EFFormElement>
@end

@interface EFSelectListFormElement(EFFormElement) <EFFormElement>
@end

@interface EFTextInputFormElementCell(EFFormElement) <EFFormElement>
@end

