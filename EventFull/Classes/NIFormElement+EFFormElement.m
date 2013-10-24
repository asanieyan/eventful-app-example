//
//  NIFormElement+EFFormElement.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-21.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "NIFormElement+EFFormElement.h"
#import "Nimbus/NIRuntimeClassModifications.h"

@implementation EFDatePickerFormElement(EFFormElement)

/**
 Lets swap the setDate: method and add will/did change notification for the value  
 that way we can do KVO on the value properpty
*/
__attribute__((constructor))
static void EFDatePickerFormElement_EFFormElement()
{
    NISwapInstanceMethods([EFDatePickerFormElement class], @selector(setDate:), @selector(EFFormElement_setDate:));
}

- (void)EFFormElement_setDate:(NSDate*)date
{
    [self willChangeValueForKey:@"value"];
    [self EFFormElement_setDate:date];
    [self didChangeValueForKey:@"value"];
}

- (void)setValue:(id)value
{
    [self setDate:value];
}

- (id)value
{
    return self.date;
}

@end