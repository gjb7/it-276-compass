//
//  ViewController.m
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "GJBProjectsViewController.h"

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

- (IBAction)showEditor:(id)sender {
    [self performSegueWithIdentifier:CMPShowEditorSegueIdentifier sender:sender];
}

@end
