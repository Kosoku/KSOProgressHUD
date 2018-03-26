//
//  ViewController.m
//  Demo-iOS
//
//  Created by William Towe on 3/24/18.
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
#import <Stanley/Stanley.h>

static CGSize const kBarButtonItemImageSize = {.width=25, .height=25};
static UIEdgeInsets const kContentEdgeInsets = {.top=8, .left=8, .bottom=8, .right=8};

@interface ViewController () <KDIPickerViewButtonDataSource,KDIPickerViewButtonDelegate>
@property (strong,nonatomic) KDIPickerViewButton *stylePickerViewButton;
@property (copy,nonatomic) NSArray<NSNumber *> *styles;

- (NSString *)_stringForStyle:(KSOProgressHUDViewStyle)style;
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
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:scrollView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": scrollView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": scrollView}]];
    
    KDIGradientView *backgroundView = [[KDIGradientView alloc] initWithFrame:CGRectZero];
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    for (NSUInteger i=0; i<10; i++) {
        [colors addObject:KDIColorRandomHSB()];
    }
    
    backgroundView.colors = colors;
    
    [scrollView addSubview:backgroundView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": backgroundView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(==height)]|" options:0 metrics:@{@"height": @(ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * 3))} views:@{@"view": backgroundView}]];
    [NSLayoutConstraint activateConstraints:@[[backgroundView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor]]];
    
    self.stylePickerViewButton = [KDIPickerViewButton buttonWithType:UIButtonTypeSystem];
    self.stylePickerViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.stylePickerViewButton.backgroundColor = [self.stylePickerViewButton.tintColor KDI_contrastingColor];
    self.stylePickerViewButton.titleLabel.KDI_dynamicTypeTextStyle = UIFontTextStyleCallout;
    self.stylePickerViewButton.contentEdgeInsets = kContentEdgeInsets;
    self.stylePickerViewButton.rounded = YES;
    self.stylePickerViewButton.dataSource = self;
    self.stylePickerViewButton.delegate = self;
    [scrollView addSubview:self.stylePickerViewButton];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": self.stylePickerViewButton}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]" options:0 metrics:nil views:@{@"view": self.stylePickerViewButton}]];
    
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem KDI_barButtonItemWithImage:[UIImage KSO_fontAwesomeSolidImageWithString:@"\uf070" size:kBarButtonItemImageSize].KDI_templateImage style:UIBarButtonItemStylePlain block:^(__kindof UIBarButtonItem * _Nonnull barButtonItem) {
        [KSOProgressHUDView dismiss];
    }],[UIBarButtonItem KDI_barButtonItemWithImage:[UIImage KSO_fontAwesomeSolidImageWithString:@"\uf06e" size:kBarButtonItemImageSize].KDI_templateImage style:UIBarButtonItemStylePlain block:^(__kindof UIBarButtonItem * _Nonnull barButtonItem) {
        [KSOProgressHUDView present];
    }]];
}

- (NSInteger)pickerViewButton:(KDIPickerViewButton *)pickerViewButton numberOfRowsInComponent:(NSInteger)component {
    return self.styles.count;
}
- (NSString *)pickerViewButton:(KDIPickerViewButton *)pickerViewButton titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self _stringForStyle:self.styles[row].integerValue];
}

- (void)pickerViewButton:(KDIPickerViewButton *)pickerViewButton didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [KSOProgressHUDView dismiss];
    
    KSOProgressHUDView.appearance.style = self.styles[row].integerValue;
    
    [KSOProgressHUDView present];
}

- (NSString *)_stringForStyle:(KSOProgressHUDViewStyle)style; {
    switch (style) {
        case KSOProgressHUDViewStyleBlurExtraLight:
            return @"Blur Extra Light";
        case KSOProgressHUDViewStyleLight:
            return @"Light";
        case KSOProgressHUDViewStyleDark:
            return @"Dark";
        case KSOProgressHUDViewStyleBlurDark:
            return @"Blur Dark";
        case KSOProgressHUDViewStyleBlurProminent:
            return @"Blur Prominent";
        case KSOProgressHUDViewStyleBlurLight:
            return @"Blur Light";
        case KSOProgressHUDViewStyleBlurRegular:
            return @"Blur Regular";
    }
}

@end
