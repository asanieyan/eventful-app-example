//
//  EFSelectListCell.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-23.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFSelectListCell.h"
#import "EFDatePickerCell.h"

@interface EFSelectListFormElement()

@property(nonatomic,strong) NSArray *keys;
@property(nonatomic,strong) NSArray *values;
@property(nonatomic,readonly) NSString *valueLabel;

@end

@implementation EFSelectListFormElement

+ (id)listWithElementWithID:(NSInteger)elementID labelText:(NSString *)labelText keyValuePairs:(NSDictionary*)keyValuePairs
{
    EFSelectListFormElement *list = [EFSelectListFormElement new];
    list.labelText = labelText;
    list.keyValuePairs = keyValuePairs;
    list.value = [[keyValuePairs allKeys] objectAtIndex:0];
    list.elementID = elementID;
    return list;
}

- (void)setKeyValuePairs:(NSDictionary *)keyValuePairs
{
    _keyValuePairs = keyValuePairs;
    self.keys   = _keyValuePairs.allKeys;
    self.values = _keyValuePairs.allValues;
    self.value  = [self.keys objectAtIndex:0];
}

- (NSString*)valueLabel
{
    NSUInteger index = 0;
    if ( self.value ) {
        index = [self.keys indexOfObject:self.value];
    }
    return [self.values objectAtIndex:index];
}

- (Class)cellClass
{
    return [EFSelectListCell class];
}

@end

@interface EFSelectListCell()

//prevents from seeing the cursor when
//editing the field
@property (nonatomic, readwrite) UITextField* dumbField;

@end

@implementation EFSelectListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _valuePicker = [[UIPickerView alloc] init];
    _valuePicker.showsSelectionIndicator = YES;
    _valuePicker.dataSource = self;
    _valuePicker.delegate   = self;

    _valueField = [[UITextField alloc] init];
    _valueField.delegate = self;
    _valueField.font = [UIFont systemFontOfSize:16.0f];
    _valueField.minimumFontSize = 10.0f;
    _valueField.backgroundColor = [UIColor clearColor];
    _valueField.adjustsFontSizeToFitWidth = YES;
    _valueField.textAlignment = NSTextAlignmentRight;
    
    EFTextFieldInputViewWithPickerView(_valueField, _valuePicker);
    [self.contentView addSubview:_valueField];

    _dumbField = [[UITextField alloc] init];
    _dumbField.hidden = YES;
    _dumbField.enabled = NO;
    [self.contentView addSubview:_dumbField];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  UIEdgeInsets contentPadding = NICellContentPadding();
  CGRect contentFrame = UIEdgeInsetsInsetRect(self.contentView.frame, contentPadding);
  
  [_valueField sizeToFit];
  CGRect frame = _valueField.frame;
  frame.origin.y = floorf((self.contentView.frame.size.height - frame.size.height) / 2);
  frame.origin.x = self.contentView.frame.size.width - frame.size.width - 5;
  _valueField.frame = frame;
  self.dumbField.frame = _valueField.frame;
  
  frame = self.textLabel.frame;
  CGFloat leftEdge = 0;
  
  frame.size.width = (self.contentView.frame.size.width
                      - contentFrame.origin.x
                      - _valueField.frame.size.width
                      - _valueField.frame.origin.y
                      - leftEdge);
  self.textLabel.frame = frame;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.textLabel.text = nil;
    self.valueField.text = nil;
}

- (BOOL)shouldUpdateCellWithObject:(EFSelectListFormElement *)listPickerElement
{
  if ([super shouldUpdateCellWithObject:listPickerElement]) {
    self.textLabel.text  = listPickerElement.labelText;
    _valueField.text     = listPickerElement.valueLabel;
    _dumbField.text  = self.valueField.text;
    _valueField.tag      = self.tag;
    _valuePicker.tag     = self.tag;
    [self setNeedsLayout];
    return YES;
  }
  return NO;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    EFSelectListFormElement *element = (EFSelectListFormElement*)self.element;
    return [element.values objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    EFSelectListFormElement *element = (EFSelectListFormElement*)self.element;
    return [element keyValuePairs].count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    EFSelectListFormElement *element = (EFSelectListFormElement*)self.element;
    self.valueField.text = [element.values objectAtIndex:row];
    element.value = [element.keys objectAtIndex:row];
    self.dumbField.text = self.valueField.text;
    [self setNeedsLayout];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.dumbField.delegate = self.valueField.delegate;
    self.dumbField.font = self.valueField.font;
    self.dumbField.minimumFontSize = self.valueField.minimumFontSize;
    self.dumbField.backgroundColor = self.valueField.backgroundColor;
    self.dumbField.adjustsFontSizeToFitWidth = self.valueField.adjustsFontSizeToFitWidth;
    self.dumbField.textAlignment = self.valueField.textAlignment;
    self.dumbField.textColor = self.valueField.textColor;
    textField.hidden = YES;
    self.dumbField.hidden = NO;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.hidden = NO;
    self.dumbField.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  return NO;
}

@end
