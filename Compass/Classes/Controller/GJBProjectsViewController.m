//
//  ViewController.m
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "GJBProjectsViewController.h"

#import "CMPMap.h"

static NSString * const CMPShowEditorSegueIdentifier = @"CMPShowEditorSegue";

@interface GJBProjectsViewController ()

@end

@implementation GJBProjectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editProject:(id)sender {
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *projectURL = [temporaryDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%lu.map", (unsigned long)[[NSDate date] timeIntervalSinceNow]]];
    CMPMap *map = [[CMPMap alloc] initWithFileURL:projectURL];
    [self showEditorWithMap:map];
}

- (IBAction)showEditorWithMap:(CMPMap *)map {
    [self performSegueWithIdentifier:CMPShowEditorSegueIdentifier sender:map];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:CMPShowEditorSegueIdentifier]) {
        
    }
}

@end
