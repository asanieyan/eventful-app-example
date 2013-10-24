//
//  EFSearchViewController.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-20.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFSearchViewController.h"
#import "EFForm.h"
#import "EFEventsViewController.h"
#import "EFGeoLocatorService.h"
#import "ZAActivityBar/ZAActivityBar.h"

/**
 Form Elements
*/
enum EFSearchField {
  EFSearchFieldAddress = 100,
  EFSearchFieldRadius,
  EFSearchFieldStartDate,
  EFSearchFieldEndDate,
  EFSearchFieldCategory
};

@interface EFSearchViewController () <UITableViewDelegate, EFFormValidatorDelegate, EFGeoLocatorServiceDelegate>

@property(nonatomic,strong) EFForm *form;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) EFFormMessageDisplayer *messageDisplayer;
@property(nonatomic,strong) NSMutableDictionary *eventQuery;

@end

@implementation EFSearchViewController


- (id)init
{
    if ( self = [super init] ) {
        self.eventQuery = [NSMutableDictionary dictionary];
        [EFGeoLocatorService sharedGeoLocator].delegate = self;
    }    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    
    self.form = [[EFForm alloc] initWithTableView:self.tableView];
    self.form.formValidator.delegate = self;
    self.messageDisplayer = [[EFFormMessageDisplayer alloc] initWithForm:self.form];
    
    [self.view addSubview:_form.tableView];

    //listening to the found geolocation
    

    
    //create a table model
    [self.form addFormElement:
             [EFTextInputFormElement textInputElementWithID:EFSearchFieldAddress placeholderText:NSLocalizedString(@"Address", nil) value:@""]
    ];

    [self.form addFormElement:
            [EFTextInputFormElement textInputElementWithID:EFSearchFieldRadius  placeholderText:NSLocalizedString(@"Radius in KM", nil) value:@""]
    ];
    
    //validate the addresss when it's value is set
    
    //@todo better move these to the element validator
    //and use a validationOnBlur flag
    @weakify(self);
    [[RACObserve(self.form[@(EFSearchFieldAddress)],value) skip:1] subscribeNext:^(id x) {
            @strongify(self);
            [self.form.formValidator validateElement:self.form[@(EFSearchFieldAddress)]];
    }];
    
    [[RACObserve(self.form[@(EFSearchFieldRadius)],value) skip:1] subscribeNext:^(id x) {
            @strongify(self);
            [self.form.formValidator validateElement:self.form[@(EFSearchFieldRadius)]];
    }];
    
    ((EFTextInputFormElement*)self.form[@(EFSearchFieldRadius)]).keywordType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self.form addFormElement:
        [EFDatePickerFormElement datePickerElementWithID:EFSearchFieldStartDate labelText:NSLocalizedString(@"Start Date", nil) date:[NSDate new] datePickerMode:UIDatePickerModeDate]
    ];

    
    [self.form addFormElement:
        [EFDatePickerFormElement datePickerElementWithID:EFSearchFieldEndDate labelText:NSLocalizedString(@"End Date", nil) date:[NSDate new] datePickerMode:UIDatePickerModeDate]
    ];

    //now synchronize the two dates
    ((EFDatePickerFormElement*)self.form[@(EFSearchFieldEndDate)]).adjustDateUsingDatePickerElement
         =   (EFDatePickerFormElement*)self.form[@(EFSearchFieldStartDate)];

    //perhaps we should get this values from
    //the server
    EFSelectListFormElement *selectObject = [EFSelectListFormElement listWithElementWithID:EFSearchFieldCategory labelText:NSLocalizedString(@"Category", nil) keyValuePairs:@{
        @"music"             : NSLocalizedString(@"Music", nil),
        @"performing_arts"   : NSLocalizedString(@"Performing Arts", nil),
        @"sports"            : NSLocalizedString(@"Sports", nil),
    }];
    
    [self.form addFormElement:selectObject];
    
    [self.form addValidators:@[
            [EFFormAddressValidator new]
    ] forElementWithID:EFSearchFieldAddress];
    
    [self.form addValidators:@[
            //custom validator for radius. ignores empty value
            [EFFormBlockInputValidator validatorWithBlock:^BOOL(id value, NSError *__autoreleasing *error) {
                if ( [value length] == 0 ) return YES;
                return
                [[EFFormValidatorFormat validatorWithFormat:EFFormValidatorFormatNumber] validateValue:value error:error] &&
                [[EFFormValidatorRange validatorWithRange:NSMakeRange(1, 300)] validateValue:value error:error];
            }]     
    ] forElementWithID:EFSearchFieldRadius];
    
    
    [_form.tableModel addSectionWithTitle:@""];
    [_form.tableModel addObject:[NITitleCellObject objectWithTitle:NSLocalizedString(@"Search", nil)]];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NICellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.form.tableModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //check if the search button is pressed
    //there is only one button in the section 1
    if ( indexPath.section == 1 ) {
        [_form.formValidator validate];
    }
}



#pragma mark - EFFormValidatorDelegate

- (void)formValidator:(EFFormValidator *)formValidator inputValidator:(id<EFFormInputValidator>)inputValidator didFailValidating:(NIFormElement<EFFormElement> *)formElement error:(NSError *)error
{
    if ( formElement.elementID == EFSearchFieldRadius )
    {
        //check the error
        if ( error.code == EFFormInputValidatorInvalidFormatError ) {
            [self.messageDisplayer displayMessage:NSLocalizedString(@"Radius must be a number", nil) forElement:formElement];
        }
        else if (error.code == EFFormInputValidatorOutOfRangeError ) {
            [self.messageDisplayer displayMessage:NSLocalizedString(@"Radius must be between 1 and 300 km ", nil) forElement:formElement];
        }
    }
    else if ( formElement.elementID == EFSearchFieldAddress ) {
        if ( error.code == EFFormInputValidatorNotFoundError ) {
            [self.messageDisplayer displayMessage:NSLocalizedString(@"Address must be valid ", nil) forElement:formElement];
        }
        else if ( error.code == EFFormInputValidatorValueEmptyError ) {
            [self.messageDisplayer displayMessage:NSLocalizedString(@"Address can not be empty ", nil) forElement:formElement];
        }
    }
}

- (void)formValidator:(EFFormValidator *)formValidator formElementIsValid:(NIFormElement<EFFormElement> *)formElement
{
    [self.messageDisplayer hideMessageForElement:formElement];
}

- (void)formValidator:(EFFormValidator *)formValidator inputValidator:(id<EFFormInputValidator>)inputValidator didSucceedValidating:(NIFormElement<EFFormElement> *)formElement
{
    
}

- (void)formValidatorDidCompletetValidation:(EFFormValidator *)formValidator succeed:(BOOL)suceed
{
    if ( suceed ) {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"YYYYMMDD00";
        
        NSString *date = [NSString stringWithFormat:@"%@-%@",
            [dateFormatter stringFromDate:[self.form elementWithID:EFSearchFieldStartDate].value],
            [dateFormatter stringFromDate:[self.form elementWithID:EFSearchFieldEndDate].value]
        ];
        NSString *radius = [self.form elementWithID:EFSearchFieldRadius].value;
        NSString *cat    = [self.form elementWithID:EFSearchFieldCategory].value;
        [self.eventQuery addEntriesFromDictionary:@{
            @"page_size" : [NSString stringWithFormat:@"%d", INT_MAX],
            @"within"    : [radius length] == 0 ? @"1" : radius,
            @"units"     : @"km",
            @"date"      : date,
            @"category"  : cat
        }];
        //get events
        [ZAActivityBar showWithStatus:NSLocalizedString(@"Please Wait", nil)];
        [[EFObjectManager sharedManager] getObjectsAtPath:@"events/search" parameters:self.eventQuery success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSArray *events  = mappingResult.array;
            if ( events.count > 0 ) {
                [ZAActivityBar dismiss];
                EFEventsViewController *controller = [[EFEventsViewController alloc] initWithEvents:events];
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                [ZAActivityBar showErrorWithStatus:NSLocalizedString(@"No Events Found. Revise Search", nil)];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                //sometimes eventful.api returns a null which causes the
                //a failure
                [ZAActivityBar showErrorWithStatus:NSLocalizedString(@"No Events Found. Revise Search", nil)];
        }];
        
    }
}
- (void)formValidatorWillStartValidation:(EFFormValidator *)formValidator
{

}

#pragma mark - EFGeoLocatorServiceDelegate

- (void)geoLocatorService:(EFGeoLocatorService *)locatorService didGeoLocateAddress:(NSString *)address geoCooridnate:(EFLocationCoordinate)geoCooridnate
{
    if ( geoCooridnate.longitude != NSNotFound ) {
        [self.eventQuery
            setValue:[NSString stringWithFormat:@"%lf,%lf", geoCooridnate.latitude, geoCooridnate.longitude]
            forKey:@"location"];
    } else {
        [self.eventQuery removeObjectForKey:@"location"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
