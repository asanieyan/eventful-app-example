//
//  EFEventEntityTests.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-19.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFEventEntityTests.h"
#import "EFEntityObjectMappings.h"
#import "RestKit/RestKit.h"
#import "Restkit/Testing.h"
#import "Helper.h"

@interface EFEventEntityTests()

@end

@implementation EFEventEntityTests

- (void)setUp
{
    [RKTestFixture setFixtureBundle:[NSBundle bundleWithIdentifier:@"com.developement.eventTests"]];
    [super setUp];
}

/**
 @abstract
 Uses the event.json fixture to test the mapping and some values
*/
- (void)testEvent
{ 
    //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"event.json"];
    RKObjectMapping *mapping = [EFEventEntity objectMapping];
    
    RKMappingTest *test = [RKMappingTest testForMapping:mapping sourceObject:parsedJSON destinationObject:nil];

    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"title" destinationKeyPath:@"title"]];
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"start_time" destinationKeyPath:@"startTime"]];
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:nil destinationKeyPath:@"venue" evaluationBlock:^BOOL(RKPropertyMappingTestExpectation *expectation, RKPropertyMapping *mapping, EFVenueEntity *entity, NSError *__autoreleasing *error) {
            //should be Brix.
            return [entity.name isEqualToString:@"Brix"];
    }]];
    
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"image" destinationKeyPath:@"image" evaluationBlock:^BOOL(RKPropertyMappingTestExpectation *expectation, RKPropertyMapping *mapping, EFEventImage *entity, NSError *__autoreleasing *error) {
            //the image url path extension should be jpeg
            NSLog(@"%@", entity.url);
            return [[entity.url pathExtension] isEqualToString:@"jpeg"];
    }]];
    STAssertTrue([test evaluate], @"The attributes are not set properly");
}

/**

 @abstract 
 Test retrieving a collection of events and mapping the entities
 
 This test requires using the localhost:8080 node.js server that provides the values
 For more information have a look at the server.coffee file included in the 
 package
*/
- (void)testEventCollection
{
    NSURL *URL = URLForFixuture(@"events");
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ [EFEventEntity responseDescriptor], [RKPaginator responseDescriptor] ]];
   [requestOperation start];
    [requestOperation waitUntilFinished];
    RKPaginator *paginator  = [requestOperation.mappingResult firstObject];
    NSMutableArray *events  = [NSMutableArray array];
    [[requestOperation.mappingResult array] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ( [obj isKindOfClass:[EFEventEntity class]] ) {
                [events addObject:obj];
            }
    }];
   STAssertTrue(events.count == paginator.perPage, @"There should be 10 events. There are 10 events in the events.json fixture");
}

@end
