//
//  EFTextInputFormElementCell.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-23.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "NIFormCellCatalog.h"

/**
 @class

 Changes the NITextInputFormElement. So it return EFTextInputFormElementCell
 as cellClass
*/
@interface EFTextInputFormElement : NITextInputFormElement

/**
 @property
 Provides a way to set the cell keyword type
*/
@property(nonatomic,assign) UIKeyboardType keywordType;

@end

/**
 @class

 Changes the NITextInputFormElementCell. It only sets the
 element value when the editing is finished
*/
@interface EFTextInputFormElementCell : NITextInputFormElementCell

@end
