//
//  EFFormMessageDisplayer.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-23.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFFormMessageDisplayer.h"
#import "EFForm.h"
#import "EFMessageCell.h"


@interface EFFormMessageDisplayer()
{
    NSMutableDictionary *_elementMessageObjects;
    NSMutableDictionary *_indexPaths;
}

@property(nonatomic,readwrite) EFForm *form;

@end

@implementation EFFormMessageDisplayer

- (id)initWithForm:(EFForm *)form
{
    if ( self = [super init] ) {
        self.form = form;
        _elementMessageObjects = [NSMutableDictionary dictionary];
        _indexPaths = [NSMutableDictionary dictionary];
    }    
    return self;
}

- (void)displayMessage:(NSString*)message forElement:(NIFormElement<EFFormElement>*)element
{
    NSString *key = [NSString stringWithFormat:@"%p", element];
    EFMessageCellObject *object = [_elementMessageObjects valueForKey:key];
    if ( !object ) {
        UITableViewCell *cell  = (UITableViewCell*)[self.form.tableView viewWithTag:element.elementID];
        NSIndexPath *indexPath = [self.form.tableView indexPathForCell:cell];
        object = [EFMessageCellObject new];
        object.message = message;
        [_elementMessageObjects setValue:object forKey:key];
        indexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        [_indexPaths setValue:indexPath forKey:key];
        [self.form.tableModel insertObject:object atRow:indexPath.row inSection:indexPath.section];
        [self.form.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        object.message = message;
        [self.form.tableView reloadData];
    }

}

- (void)hideMessageForElement:(NIFormElement<EFFormElement>*)element
{
    NSString *key = [NSString stringWithFormat:@"%p", element];
    if ( [_indexPaths valueForKey:key] )
    {
        NSIndexPath *indexPath = [_indexPaths valueForKey:key];
        [_indexPaths removeObjectForKey:key];
        [_elementMessageObjects removeObjectForKey:key];
        [self.form.tableModel removeObjectAtIndexPath:indexPath];
        [self.form.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
