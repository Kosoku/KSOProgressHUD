//
//  ViewController.m
//  Demo-tvOS
//
//  Created by William Towe on 3/27/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
