//
//  CMPProjectsViewController.m
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPLevelsViewController.h"

#import "CMPLevelViewController.h"

#import "CMPLevelIconView.h"

#import "CMPMap.h"
#import "CMPTilesheet.h"

static NSString * const CMPShowEditorSegueIdentifier = @"CMPShowEditorSegue";

@interface CMPLevelsViewController ()

@property (nonatomic) NSArray *levels;

@end

@implementation CMPLevelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLevel:)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    CGSize itemSize = CGSizeMake(150.0, 150.0);
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = itemSize;
    
    [self.collectionView registerClass:[CMPLevelIconView class] forCellWithReuseIdentifier:NSStringFromClass([CMPLevelIconView class])];
    
    NSArray *documentDirectories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentDirectory = documentDirectories.firstObject;
    NSArray *levelFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:documentDirectory includingPropertiesForKeys:@[] options:0 error:nil];
    
    NSMutableArray *levels = [NSMutableArray array];
    [levelFiles enumerateObjectsUsingBlock:^(NSURL *mapURL, NSUInteger idx, BOOL *stop) {
        CMPMap *map = [CMPMap mapWithContentsOfURL:mapURL];
        [levels addObject:map];
    }];
    self.levels = levels;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addLevel:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"New Level", nil) message:NSLocalizedString(@"What do you want to call this level?", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"level.map";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    __weak __typeof(alertController) weakAlertController = alertController;
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Create", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = weakAlertController.textFields.firstObject;
        
        CMPMap *map = [[CMPMap alloc] init];
        map.filename = textField.text;
        map.size = CGSizeMake(10.0, 10.0);
        map.tilesheetPath = @"res/tilesheets/overworld.yaml";
        map.tilesheet.sprite = [UIImage imageNamed:@"overworld.png"];
        [self showEditorWithMap:map];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)showEditorWithMap:(CMPMap *)map {
    [self performSegueWithIdentifier:CMPShowEditorSegueIdentifier sender:map];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:CMPShowEditorSegueIdentifier]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        CMPLevelViewController *projectViewController = (CMPLevelViewController *)navController.viewControllers[0];
        projectViewController.map = (CMPMap *)sender;
    }
}

- (IBAction)unwindToLevels:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[CMPLevelViewController class]]) {
        CMPLevelViewController *levelViewController = (CMPLevelViewController *)segue.sourceViewController;
        CMPMap *map = levelViewController.map;
        
        NSArray *documentDirectories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *documentDirectory = documentDirectories.firstObject;
        
        [map saveToDirectory:documentDirectory error:nil];
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
