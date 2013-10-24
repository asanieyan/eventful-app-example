//
//  EFView.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-23.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFView.h"
#import "OCMock/OCMock.h"
#import "Nimbus/NimbusModels.h"
#import "EFForm.h"
#import "EFFormMessageDisplayer.h"


@implementation EFView

/**
 Verifies testing the EFFormMessageDisplayer
*/
- (void)testMessageDisplayerCalls
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *newRowIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    id formMock  = [OCMockObject mockForClass:[EFForm class]];
    id modelMock = [OCMockObject mockForClass:[NIMutableTableViewModel class]];
    id tableMock = [OCMockObject mockForClass:[UITableView class]];
    id cellMock  = [OCMockObject mockForClass:[UITableViewCell class]];
    id elementMock = [OCMockObject mockForClass:[NIFormElement class]];
    int elementId = 10;
    [[[formMock stub] andReturn:modelMock] tableModel];
    [[[formMock stub] andReturn:tableMock] tableView];
    [[[elementMock stub] andReturnValue:OCMOCK_VALUE(elementId)] elementID];
    [[[tableMock stub] andReturn:cellMock] viewWithTag:[elementMock elementID]];
    [[[tableMock stub] andReturn:indexPath] indexPathForCell:cellMock];

    
    [[tableMock expect] insertRowsAtIndexPaths:@[newRowIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[modelMock expect] insertObject:[OCMArg any] atRow:newRowIndexPath.row inSection:newRowIndexPath.section];

    EFFormMessageDisplayer *displayer = [[EFFormMessageDisplayer alloc] initWithForm:formMock];
    [displayer displayMessage:@"some message" forElement:elementMock];
    [tableMock verify];
    [modelMock verify];    
}

@end
