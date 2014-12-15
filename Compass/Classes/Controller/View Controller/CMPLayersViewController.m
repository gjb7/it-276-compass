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
    return nil;
}

@end
