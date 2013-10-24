//
//  EFFormTests.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-21.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFFormTests.h"
#import "EFForm.h"
#import "EFFormValidator.h"
#import "Helper.h"
#import "EFGeoLocatorService.h"
#import "OCMock/OCMock.h"

@implementation EFFormTests

- (void)testImmutableDataSource
{
    UITableView *tablView = [UITableView new];    
    EFForm *form = [[EFForm alloc] initWithTableView:tablView];
    STAssertThrows(tablView.dataSource = nil, @"Tableview data source is mutable");
}

- (void)testGeolocator
{
    EFGeoLocatorService *service      = [[EFGeoLocatorService alloc] initWithServiceURL:URLForFixuture(@"goodgeo")];
    NSString *addr = @"some good address";
    id mock =[OCMockObject mockForProtocol:@protocol(EFGeoLocatorServiceDelegate)];
    [[[mock expect] ignoringNonObjectArgs]
        geoLocatorService:service
        didGeoLocateAddress:addr geoCooridnate:(EFLocationCoordinate){0,0}];
    service.delegate = mock;
    EFLocationCoordinate coordinate = [service geoLocateAddress:addr];
    [mock verify];
    STAssertTrue(coordinate.latitude == 49.261226, @"Incorrect latitude");
}

/**
 Requires the fixture server
 Read server.coffee for more information
*/
- (void)testAddressValidator
{
    NSError *error;
    EFGeoLocatorService *service      = [[EFGeoLocatorService alloc] initWithServiceURL:URLForFixuture(@"goodgeo")];
    EFFormAddressValidator *validator = [EFFormAddressValidator validatorWithGeolocatorService:service];
    
    STAssertTrue([validator validateValue:@"1250 commox st. , vancouver, BC" error:&error], @"Adress should be valid");

    service      = [[EFGeoLocatorService alloc] initWithServiceURL:URLForFixuture(@"badgeo")];
    validator = [EFFormAddressValidator validatorWithGeolocatorService:service];        
    
    STAssertFalse([validator validateValue:@"1250 fake st, fakecity, fakeprov" error:&error], @"Address should be invalid");
}

/**
Test ranges
*/
- (void)testRadiusValidator
{
    NSError *error;
    EFFormValidatorRange *validator = [EFFormValidatorRange validatorWithRange:NSMakeRange(1, 300)];
    STAssertTrue([validator validateValue:@300 error:&error], @"should be true");
    STAssertFalse([validator validateValue:@301 error:&error], @"should be false");
}


@end
