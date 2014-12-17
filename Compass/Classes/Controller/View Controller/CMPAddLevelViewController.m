//
//  CMPAddLevelViewController.m
//  Compass
//
//  Created by Grant Butler on 12/17/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPAddLevelViewController.h"

#import "CMPMap.h"

@interface CMPAddLevelViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButtonItem;

@property (nonatomic) UITextField *levelNameTextField;

@property (nonatomic) UILabel *widthLabel;
@property (nonatomic) UILabel *heightLabel;

@property (nonatomic) UIStepper *widthStepper;
@property (nonatomic) UIStepper *heightStepper;

@end

@implementation CMPAddLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", nil) style:UIBarButtonItemStyleDone target:self action:@selector(addLevel:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    __weak __typeof(self) weakSelf = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = NSLocalizedString(@"Level Name", nil);
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            // Adding autolayout stuff only if we actually have a cell.
            if (cell) {
                [cell.contentView addSubview:weakSelf.levelNameTextField];
                
                NSDictionary *views = @{ @"textField": weakSelf.levelNameTextField };
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[textField]-20-|" options:0 metrics:nil views:views]];
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[textField]-10-|" options:0 metrics:nil views:views]];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = NSLocalizedString(@"Map Size", nil);
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
            cell.accessoryView = weakSelf.widthStepper;
            cell.textLabel.text = NSLocalizedString(@"Width", nil);
            
            weakSelf.widthLabel = cell.detailTextLabel;
            [weakSelf updateLabel:cell.detailTextLabel withValueFrom:weakSelf.widthStepper];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
            cell.accessoryView = weakSelf.heightStepper;
            cell.textLabel.text = NSLocalizedString(@"Height", nil);
            
            weakSelf.heightLabel = cell.detailTextLabel;
            [weakSelf updateLabel:cell.detailTextLabel withValueFrom:weakSelf.heightStepper];
        }];
    }];
    
    [self validateAddButton];
}

- (IBAction)addLevel:(id)sender {
    CMPMap *map = [[CMPMap alloc] init];
    map.filename = self.levelNameTextField.text;
    map.size = CGSizeMake(self.widthStepper.value, self.heightStepper.value);
    map.tilesheetPath = @"res/tilesheets/overworld.yaml";
    
    [self.delegate addLevelViewController:self didCompleteWithMap:map];
}

- (void)cancel:(id)sender {
    [self.delegate addLevelViewControllerDidCancel:self];
}

- (UITextField *)levelNameTextField {
    if (!_levelNameTextField) {
        _levelNameTextField = [[UITextField alloc] init];
        _levelNameTextField.borderStyle = UITextBorderStyleNone;
        _levelNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _levelNameTextField.placeholder = NSLocalizedString(@"level.map", nil);
        [_levelNameTextField addTarget:self action:@selector(levelNameChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _levelNameTextField;
}

- (UIStepper *)widthStepper {
    if (!_widthStepper) {
        _widthStepper = [[UIStepper alloc] init];
        _widthStepper.value = 10.0;
        [_widthStepper addTarget:self action:@selector(widthStepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _widthStepper;
}

- (UIStepper *)heightStepper {
    if (!_heightStepper) {
        _heightStepper = [[UIStepper alloc] init];
        _heightStepper.value = 10.0;
        [_heightStepper addTarget:self action:@selector(heightStepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _heightStepper;
}

- (IBAction)levelNameChanged:(id)sender {
    [self validateAddButton];
}

- (IBAction)widthStepperValueChanged:(id)sender {
    [self updateLabel:self.widthLabel withValueFrom:sender];
}

- (IBAction)heightStepperValueChanged:(id)sender {
    [self updateLabel:self.heightLabel withValueFrom:sender];
}

- (void)updateLabel:(UILabel *)label withValueFrom:(UIStepper *)stepper {
    label.text = [@(stepper.value) stringValue];
}

- (void)validateAddButton {
    self.addButtonItem.enabled = (self.levelNameTextField.text.length > 0);
}

@end
