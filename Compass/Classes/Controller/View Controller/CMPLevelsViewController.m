//
//  CMPProjectsViewController.m
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPLevelsViewController.h"

#import "CMPLevelViewController.h"
#import "CMPAddLevelViewController.h"

#import "CMPLevelIconCell.h"

#import "CMPMapThumbnailManager.h"

#import "CMPMap.h"
#import "CMPTilesheet.h"

static NSString * const CMPShowEditorSegueIdentifier = @"CMPShowEditorSegue";
static NSString * const CMPLevelsViewControllerShowAddLevelSegueIdentifier = @"CMPLevelsViewControllerShowAddLevelSegue";

@interface CMPLevelsViewController () <CMPAddLevelViewControllerDelegate>

@property (nonatomic) NSMutableArray *levels;

@end

@implementation CMPLevelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Compass";
    
    self.navigationItem.leftBarButtonItems = @[
                                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLevel:)],
//                                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(exportLevels:)]
                                               ];
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    CGSize itemSize = CGSizeMake(150.0, 150.0);
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = itemSize;
    
    [self.collectionView registerClass:[CMPLevelIconCell class] forCellWithReuseIdentifier:NSStringFromClass([CMPLevelIconCell class])];
    
    NSArray *documentDirectories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentDirectory = documentDirectories.firstObject;
    NSArray *levelFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:documentDirectory includingPropertiesForKeys:@[] options:0 error:nil];
    
    NSMutableArray *levels = [NSMutableArray array];
    [levelFiles enumerateObjectsUsingBlock:^(NSURL *mapURL, NSUInteger idx, BOOL *stop) {
        if (![mapURL.pathExtension isEqualToString:@"map"]) {
            return;
        }
        
        CMPMap *map = [CMPMap mapWithContentsOfURL:mapURL];
        [levels addObject:map];
    }];
    self.levels = levels;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exportLevels:(id)sender {
    
}

- (IBAction)addLevel:(id)sender {
    // Things are stupid and I can't use storyboards for this. :(
    
    CMPAddLevelViewController *addLevelViewController = [[CMPAddLevelViewController alloc] initWithStyle:UITableViewStyleGrouped];
    addLevelViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addLevelViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:nil];
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
        
        [self saveMap:map];
        
        [[CMPMapThumbnailManager sharedManager] refreshThumbnailForMap:map context:nil completion:^(UIImage *image, id context) {
            NSInteger mapIndex = [self.levels indexOfObject:map];
            if (mapIndex == NSNotFound) {
                return;
            }
            
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:mapIndex inSection:0]]];
        }];
    }
}

- (void)saveMap:(CMPMap *)map {
    NSArray *documentDirectories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentDirectory = documentDirectories.firstObject;
    
    [map saveToDirectory:documentDirectory error:nil];
}

#pragma mark - CMPAddLevelViewControllerDelegate

- (void)addLevelViewControllerDidCancel:(CMPAddLevelViewController *)addLevelViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addLevelViewController:(CMPAddLevelViewController *)addLevelViewController didCompleteWithMap:(CMPMap *)map {
    [self.levels insertObject:map atIndex:0];
    [self saveMap:map];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self showEditorWithMap:map];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.levels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMPLevelIconCell *cell = (CMPLevelIconCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CMPLevelIconCell class]) forIndexPath:indexPath];
    
    cell.map = self.levels[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(20.0, 20.0);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CMPMap *map = self.levels[indexPath.row];
    
    [self showEditorWithMap:map];
}

@end
