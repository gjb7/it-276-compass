//
//  CMPProjectsViewController.m
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPLevelsViewController.h"

#import "CMPLevelViewController.h"

#import "CMPMap.h"

static NSString * const CMPShowEditorSegueIdentifier = @"CMPShowEditorSegue";

@interface CMPLevelsViewController ()

@end

@implementation CMPLevelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLevel:)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addLevel:(id)sender {
    CMPMap *map = [[CMPMap alloc] init];
    map.size = CGSizeMake(10.0, 10.0);
    [self showEditorWithMap:map];
}

- (IBAction)showEditorWithMap:(CMPMap *)map {
    [self performSegueWithIdentifier:CMPShowEditorSegueIdentifier sender:map];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:CMPShowEditorSegueIdentifier]) {
        CMPLevelViewController *projectViewController = (CMPLevelViewController *)segue.destinationViewController;
        projectViewController.map = (CMPMap *)sender;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
