//
//  EFEventsViewController.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-22.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFEventsViewController.h"
#import "EFEventEntityCell.h"

static NSString *EFEventsViewControllerCellIdentifier = @"EFEventsViewControllerCellIdentifier";

@interface EFEventsViewController () <NITableViewModelDelegate>

@property(nonatomic,readwrite) NSArray *events;
@property(nonatomic,strong) NIMutableTableViewModel *tableModel;

@end

@implementation EFEventsViewController

- (id)initWithEvents:(NSArray *)events
{
    if ( self = [super initWithStyle:UITableViewStylePlain] ) {
        self.events = events;
        self.tableModel = [[NIMutableTableViewModel alloc] initWithDelegate:self];
    }    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.tableView.dataSource = self.tableModel;
    
    //register the cell nib file
    //not a big fan of using nib but rigth now it's the fastest method
    [self.tableView registerNib:
            [UINib nibWithNibName:@"EFEventEntityCell" bundle:[NSBundle mainBundle]]
    forCellReuseIdentifier:EFEventsViewControllerCellIdentifier];
    
    self.tableView.rowHeight = CGRectGetHeight([[self.tableView dequeueReusableCellWithIdentifier:EFEventsViewControllerCellIdentifier] frame]);
    
    for (EFEventEntity *entity in self.events) {
        [self.tableModel addObject:entity];
    }  
}

- (UITableViewCell*)tableViewModel:(NITableViewModel *)tableViewModel cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
  UITableViewCell* cell = nil;

  cell = [tableView dequeueReusableCellWithIdentifier:EFEventsViewControllerCellIdentifier forIndexPath:indexPath];
  // Allow the cell to configure itself with the object's information.
  if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
    [(id<NICell>)cell shouldUpdateCellWithObject:object];
  }

  return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
