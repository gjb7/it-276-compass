//
//  CMPLayersViewController.m
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPLayersViewController.h"

#import "CMPLayerFooterView.h"

@interface CMPLayersViewController ()

@property (nonatomic) NSMutableArray *mutableLayers;

@property (nonatomic) NSIndexPath *lastSelectedIndexPath;

@end

@implementation CMPLayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    CMPLayerFooterView *footerView = [[CMPLayerFooterView alloc] initWithFrame:CGRectZero];
    [footerView.button addTarget:self action:@selector(insertLayer:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;
    
    self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:self.lastSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)setLayers:(NSArray *)layers {
    self.mutableLayers = [layers mutableCopy];
    
    if (self.isViewLoaded) {
        [self.tableView reloadData];
    }
}

- (NSArray *)layers {
    return self.mutableLayers;
}

- (void)insertLayer:(id)sender {
    NSMutableData *lastLayerData = self.layers.lastObject;
    NSMutableData *newLayerData = [[NSMutableData alloc] initWithLength:lastLayerData.length];
    [self.mutableLayers addObject:newLayerData];

    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.mutableLayers.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

    [self.delegate layersViewController:self didInsertLayerAtIndex:self.layers.count - 1];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.layers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Layer %li", nil), (long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate layersViewController:self didSelectLayerAtIndex:indexPath.row];
    
    self.lastSelectedIndexPath = indexPath;
}

#pragma mark - Editing

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:self.lastSelectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.layers.count > 1);
}

@end
