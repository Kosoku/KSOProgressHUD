//
//  ViewController.m
//  Demo-tvOS
//
//  Created by William Towe on 3/27/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "ViewController.h"

#import <KSOProgressHUD/KSOProgressHUD.h>
#import <Ditko/Ditko.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>

static CGSize const kBarButtonItemImageSize = {.width=25, .height=25};

@interface ViewController ()
@property (strong,nonatomic) UIScrollView *scrollView;
@property (copy,nonatomic) NSArray<NSNumber *> *styles;
@end

@implementation ViewController

- (NSString *)title {
    return @"KSOProgressHUD";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.styles = @[@(KSOProgressHUDViewStyleLight),
                    @(KSOProgressHUDViewStyleDark),
                    @(KSOProgressHUDViewStyleBlurExtraLight),
                    @(KSOProgressHUDViewStyleBlurLight),
                    @(KSOProgressHUDViewStyleBlurDark),
                    @(KSOProgressHUDViewStyleBlurRegular),
                    @(KSOProgressHUDViewStyleBlurProminent)];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.scrollView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.scrollView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.scrollView}]];
    
    KDIGradientView *backgroundView = [[KDIGradientView alloc] initWithFrame:CGRectZero];
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    for (NSUInteger i=0; i<10; i++) {
        [colors addObject:KDIColorRandomHSB()];
    }
    
    backgroundView.colors = colors;
    
    [self.scrollView addSubview:backgroundView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": backgroundView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(==height)]|" options:0 metrics:@{@"height": @(ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * 3))} views:@{@"view": backgroundView}]];
    [NSLayoutConstraint activateConstraints:@[[backgroundView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor]]];
    
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem KDI_barButtonItemWithImage:[UIImage KSO_fontAwesomeSolidImageWithString:@"\uf070" size:kBarButtonItemImageSize].KDI_templateImage style:UIBarButtonItemStylePlain block:^(__kindof UIBarButtonItem * _Nonnull barButtonItem) {
        [KSOProgressHUDView dismiss];
    }],[UIBarButtonItem KDI_barButtonItemWithImage:[UIImage KSO_fontAwesomeSolidImageWithString:@"\uf06e" size:kBarButtonItemImageSize].KDI_templateImage style:UIBarButtonItemStylePlain block:^(__kindof UIBarButtonItem * _Nonnull barButtonItem) {
        [KSOProgressHUDView present];
    }]];
}

@end
