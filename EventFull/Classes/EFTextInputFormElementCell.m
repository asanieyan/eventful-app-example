//
//  EFTextInputFormElementCell.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-23.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFTextInputFormElementCell.h"

@implementation EFTextInputFormElement

- (Class)cellClass {
    return [EFTextInputFormElementCell class];
}

@end

@interface EFTextInputFormElementCell() <UITextFieldDelegate>
@end

@implementation EFTextInputFormElementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
  {
    [self.textField removeTarget:self action:@selector(textFieldDidChangeValue) forControlEvents:UIControlEventAllEditingEvents];
    [self.textField addTarget:self action:@selector(textFieldDidChangeValue:event:) forControlEvents:UIControlEventEditingDidEndOnExit];
  }
  return self;
}

- (BOOL)shouldUpdateCellWithObject:(EFTextInputFormElement*)object
{
    BOOL update = [super shouldUpdateCellWithObject:object];
    if ( update ) {
        self.textField.keyboardType = object.keywordType;
    }
    return update;
}

- (void)textFieldDidChangeValue:(id)sender event:(UIEvent*)event
{
    NITextInputFormElement* textInputElement = (NITextInputFormElement *)self.element;
    textInputElement.value = self.textField.text;
}

@end
