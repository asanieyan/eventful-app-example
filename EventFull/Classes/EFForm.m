//
//  EFForm.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-21.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFForm.h"
#import "NIFormElement+EFFormElement.h"

@interface EFForm()
{
    EFFormValidator *_formValidator;
}
@property(nonatomic,readwrite) UITableView *tableView;
@property(nonatomic,readwrite) NIMutableTableViewModel *tableModel;
@property(nonatomic,readwrite) NSMutableArray *formElements;

@end

@implementation EFForm

- (id)initWithTableView:(UITableView *)tableView
{
    if ( self = [super init] ) {
        self.tableView = tableView;
        self.tableModel = [[NIMutableTableViewModel alloc] initWithDelegate:(id)[NICellFactory class]];
        self.tableView.dataSource = self.tableModel;
        self.formElements = [NSMutableArray array];
        @weakify(self);
        [RACObserve(self.tableView, dataSource) subscribeNext:^(id x) {
            @strongify(self);
            NSAssert(x == self.tableModel, @"%@ data source is immutable", self.tableView);
        }];
        _formValidator = [EFFormValidator new];
    }    
    return self;
}

- (void)addFormElement:(NIFormElement *)formElement
{
    [self.formElements addObject:formElement];
    [self.tableModel addObject:formElement];
}

- (NIFormElement<EFFormElement>*)elementWithID:(NSInteger)elementID
{
    __block NIFormElement<EFFormElement> *element = nil;
    [self.formElements enumerateObjectsUsingBlock:^(NIFormElement<EFFormElement> *obj, NSUInteger idx, BOOL *stop) {
            *stop = obj.elementID == elementID;
            if ( *stop ) {
                element = obj;
            }
                
    }];
    return element;    
}

- (NIFormElement<EFFormElement>*)objectForKeyedSubscript:(id)key
{
    return [self elementWithID:[key integerValue]];
}

- (NSArray*)elements
{
    return self.formElements;
}

- (EFFormValidator*)formValidator
{
    return _formValidator;
}

- (void)addValidator:(id)validator forElementWithID:(NSInteger)elementID
{
    NIFormElement<EFFormElement> *element = [self elementWithID:elementID];
    [self.formValidator addValidator:validator forElement:element];    
}

- (void)addValidators:(id<NSFastEnumeration>)validators forElementWithID:(NSInteger)elementID
{
   [self.formValidator addValidators:validators forElement:[self elementWithID:elementID]];
}

@end

