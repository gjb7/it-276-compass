//
//  CMPLayersViewController.m
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPLayersViewController.h"

#import "CMPMap.h"

@implementation CMPLayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (void)setMap:(CMPMap *)map {
    _map = map;
    
    if (self.isViewLoaded) {
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.map.layers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Layer %li", nil), (long)indexPath.row];
    
    return cell;
}

@end
