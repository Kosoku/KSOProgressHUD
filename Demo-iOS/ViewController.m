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

static CGFloat const kCornerRadius = 5.0;
static CGSize const kBarButtonItemImageSize = {.width=25, .height=25};
static UIEdgeInsets const kContentEdgeInsets = {.top=8, .left=8, .bottom=8, .right=8};

@interface ViewController () <KDIPickerViewButtonDataSource,KDIPickerViewButtonDelegate,UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) KDIPickerViewButton *stylePickerViewButton;
@property (copy,nonatomic) NSArray<NSNumber *> *styles;

- (UIView *)_createVibrancyViews;
- (UIView *)_createCornerRadiusViews;
- (UIView *)_createProgressViews;
- (UIView *)_createTextViews;
- (NSString *)_stringForStyle:(KSOProgressHUDViewStyle)style;
- (void)_updateProgressHUDWithBlock:(dispatch_block_t)block;
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
    self.scrollView.delegate = self;
    
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
    
    self.stylePickerViewButton = [KDIPickerViewButton buttonWithType:UIButtonTypeSystem];
    self.stylePickerViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.stylePickerViewButton.backgroundColor = [self.stylePickerViewButton.tintColor KDI_contrastingColor];
    self.stylePickerViewButton.titleLabel.KDI_dynamicTypeTextStyle = UIFontTextStyleCallout;
    self.stylePickerViewButton.contentEdgeInsets = kContentEdgeInsets;
    self.stylePickerViewButton.rounded = YES;
    self.stylePickerViewButton.dataSource = self;
    self.stylePickerViewButton.delegate = self;
    [self.scrollView addSubview:self.stylePickerViewButton];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": self.stylePickerViewButton}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]" options:0 metrics:nil views:@{@"view": self.stylePickerViewButton}]];
    
    UIView *vibrancyView = [self _createVibrancyViews];
    
    [self.scrollView addSubview:vibrancyView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": vibrancyView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top]-[view]" options:0 metrics:nil views:@{@"view": vibrancyView, @"top": self.stylePickerViewButton}]];
    
    UIView *cornerRadiusView = [self _createCornerRadiusViews];
    
    [self.scrollView addSubview:cornerRadiusView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": cornerRadiusView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top]-[view]" options:0 metrics:nil views:@{@"view": cornerRadiusView, @"top": vibrancyView}]];
    
    UIView *progressView = [self _createProgressViews];
    
    [self.scrollView addSubview:progressView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": progressView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top]-[view]" options:0 metrics:nil views:@{@"view": progressView, @"top": cornerRadiusView}]];
    
    UIView *textView = [self _createTextViews];
    
    [self.scrollView addSubview:textView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": textView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top]-[view]" options:0 metrics:nil views:@{@"view": textView, @"top": progressView}]];
    
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem KDI_barButtonItemWithImage:[UIImage KSO_fontAwesomeSolidImageWithString:@"\uf070" size:kBarButtonItemImageSize].KDI_templateImage style:UIBarButtonItemStylePlain block:^(__kindof UIBarButtonItem * _Nonnull barButtonItem) {
        [KSOProgressHUDView dismiss];
    }],[UIBarButtonItem KDI_barButtonItemWithImage:[UIImage KSO_fontAwesomeSolidImageWithString:@"\uf06e" size:kBarButtonItemImageSize].KDI_templateImage style:UIBarButtonItemStylePlain block:^(__kindof UIBarButtonItem * _Nonnull barButtonItem) {
        [KSOProgressHUDView present];
    }]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:NO];
}

- (NSInteger)pickerViewButton:(KDIPickerViewButton *)pickerViewButton numberOfRowsInComponent:(NSInteger)component {
    return self.styles.count;
}
- (NSString *)pickerViewButton:(KDIPickerViewButton *)pickerViewButton titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self _stringForStyle:self.styles[row].integerValue];
}

- (NSString *)pickerViewButton:(KDIPickerViewButton *)pickerViewButton titleForSelectedRows:(NSArray<NSNumber *> *)selectedRows {
    return [NSString stringWithFormat:@"Style: %@",[self _stringForStyle:self.styles[selectedRows.firstObject.integerValue].integerValue]];
}
- (void)pickerViewButton:(KDIPickerViewButton *)pickerViewButton didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self _updateProgressHUDWithBlock:^{
        KSOProgressHUDView.appearance.style = self.styles[row].integerValue;
    }];
}

- (UIView *)_createVibrancyViews; {
    kstWeakify(self);
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundView.backgroundColor = [self.view.tintColor KDI_contrastingColor];
    backgroundView.KDI_cornerRadius = kCornerRadius;
    
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 8.0;
    
    [backgroundView addSubview:stackView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": stackView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": stackView}]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [backgroundView.backgroundColor KDI_contrastingColor];
    label.KDI_dynamicTypeTextStyle = UIFontTextStyleBody;
    label.text = @"Vibrancy";
    
    [stackView addArrangedSubview:label];
    
    UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    switchControl.translatesAutoresizingMaskIntoConstraints = NO;
    switchControl.on = YES;
    switchControl.onTintColor = self.view.tintColor;
    switchControl.tintColor = label.textColor;
    [switchControl KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self _updateProgressHUDWithBlock:^{
            KSOProgressHUDViewOptions options = KSOProgressHUDView.appearance.options;
            
            if (switchControl.isOn) {
                options |= KSOProgressHUDViewOptionsWantsVibrancyEffect;
            }
            else {
                options &= ~KSOProgressHUDViewOptionsWantsVibrancyEffect;
            }
            
            KSOProgressHUDView.appearance.options = options;
        }];
    } forControlEvents:UIControlEventValueChanged];
    
    [stackView addArrangedSubview:switchControl];
    
    return backgroundView;
}
- (UIView *)_createCornerRadiusViews; {
    kstWeakify(self);
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundView.backgroundColor = [self.view.tintColor KDI_contrastingColor];
    backgroundView.KDI_cornerRadius = kCornerRadius;
    
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 8.0;
    
    [backgroundView addSubview:stackView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": stackView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": stackView}]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [backgroundView.backgroundColor KDI_contrastingColor];
    label.KDI_dynamicTypeTextStyle = UIFontTextStyleBody;
    label.text = @"Corner Radius";
    
    [stackView addArrangedSubview:label];
    
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    
    stepper.translatesAutoresizingMaskIntoConstraints = NO;
    stepper.minimumValue = 0.0;
    stepper.maximumValue = 25.0;
    stepper.stepValue = 1.0;
    stepper.value = 5.0;
    [stepper KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self _updateProgressHUDWithBlock:^{
            KSOProgressHUDView.appearance.contentCornerRadius = stepper.value;
        }];
    } forControlEvents:UIControlEventValueChanged];
    
    [stackView addArrangedSubview:stepper];
    
    return backgroundView;
}
- (UIView *)_createProgressViews; {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundView.backgroundColor = [self.view.tintColor KDI_contrastingColor];
    backgroundView.KDI_cornerRadius = kCornerRadius;
    
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 8.0;
    
    [backgroundView addSubview:stackView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": stackView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": stackView}]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [backgroundView.backgroundColor KDI_contrastingColor];
    label.KDI_dynamicTypeTextStyle = UIFontTextStyleBody;
    label.text = @"Corner Radius";
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [stackView addArrangedSubview:label];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectZero];
    
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.value = 0.0;
    [slider setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [slider KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        [KSOProgressHUDView presentWithProgress:slider.value animated:YES];
    } forControlEvents:UIControlEventValueChanged];
    
    [stackView addArrangedSubview:slider];
    
    return backgroundView;
}
- (UIView *)_createTextViews; {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundView.backgroundColor = [self.view.tintColor KDI_contrastingColor];
    backgroundView.KDI_cornerRadius = kCornerRadius;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.placeholder = @"Enter text…";
    textField.KDI_dynamicTypeTextStyle = UIFontTextStyleBody;
    [textField KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        [KSOProgressHUDView presentWithText:textField.text];
    } forControlEvents:UIControlEventAllEditingEvents];
    
    [backgroundView addSubview:textField];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": textField}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": textField}]];
    
    return backgroundView;
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
- (void)_updateProgressHUDWithBlock:(dispatch_block_t)block; {
    [KSOProgressHUDView dismiss];
    
    block();
    
    [KSOProgressHUDView present];
}

@end
