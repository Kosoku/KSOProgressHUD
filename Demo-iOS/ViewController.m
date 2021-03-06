//
//  ViewController.m
//  Demo-iOS
//
//  Created by William Towe on 3/24/18.
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
#import <Stanley/Stanley.h>
#import <Quicksilver/Quicksilver.h>

static CGFloat const kCornerRadius = 5.0;
static CGSize const kBarButtonItemImageSize = {.width=25, .height=25};
static UIEdgeInsets const kContentEdgeInsets = {.top=8, .left=8, .bottom=8, .right=8};

@interface GradientBackgroundView : KDIGradientView
@property (strong,nonatomic) KDIButton *dismissButton;
@end

@implementation GradientBackgroundView
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    CGFloat alpha = 0.7;
    
    self.colors = @[[KDIColorRandomRGB() colorWithAlphaComponent:alpha],
                    [KDIColorRandomRGB() colorWithAlphaComponent:alpha],
                    [KDIColorRandomRGB() colorWithAlphaComponent:alpha]];
    
    return self;
}
@end

@interface ViewController () <KDIPickerViewButtonDataSource,KDIPickerViewButtonDelegate,UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) KDIPickerViewButton *stylePickerViewButton;
@property (copy,nonatomic) NSArray<NSNumber *> *styles;

@property (strong,nonatomic) KSOProgressHUDTheme *theme;

- (UIView *)_createVibrancyViews;
- (UIView *)_createCornerRadiusViews;
- (UIView *)_createProgressViews;
- (UIView *)_createTextViews;
- (UIView *)_createDefaultImageViews;
- (UIView *)_createImageViews;
- (NSString *)_stringForStyle:(KSOProgressHUDStyle)style;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kstWeakify(self);
    
    [NSNotificationCenter.defaultCenter addObserverForName:KSOProgressHUDViewNotificationTouchesEnded object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [KSOProgressHUDView dismiss];
    }];
    
    self.theme = [KSOProgressHUDTheme.defaultTheme copy];
    KSOProgressHUDTheme.defaultTheme = self.theme;
    
    self.styles = @[@(KSOProgressHUDStyleLight),
                    @(KSOProgressHUDStyleDark),
                    @(KSOProgressHUDStyleBlurExtraLight),
                    @(KSOProgressHUDStyleBlurLight),
                    @(KSOProgressHUDStyleBlurDark),
                    @(KSOProgressHUDStyleBlurRegular),
                    @(KSOProgressHUDStyleBlurProminent)];
    
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
    
    UIView *defaultImageView = [self _createDefaultImageViews];
    
    [self.scrollView addSubview:defaultImageView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": defaultImageView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top]-[view]" options:0 metrics:nil views:@{@"view": defaultImageView, @"top": textView}]];
    
    UIView *customImageView = [self _createImageViews];
    
    [self.scrollView addSubview:customImageView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": customImageView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top]-[view]" options:0 metrics:nil views:@{@"view": customImageView, @"top": defaultImageView}]];
    
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem KDI_barButtonItemWithImage:[UIImage KSO_fontAwesomeSolidImageWithString:@"\uf043" size:kBarButtonItemImageSize].KDI_templateImage style:UIBarButtonItemStylePlain block:^(__kindof UIBarButtonItem * _Nonnull barButtonItem) {
        kstStrongify(self);
        KSOProgressHUDTheme *theme = [self.theme copy];
        
        theme.backgroundStyle = KSOProgressHUDBackgroundStyleCustom;
        theme.backgroundViewClass = GradientBackgroundView.class;
        
        [KSOProgressHUDView presentWithTheme:theme];
    }],[UIBarButtonItem KDI_barButtonItemWithImage:[UIImage KSO_fontAwesomeSolidImageWithString:@"\uf042" size:kBarButtonItemImageSize].KDI_templateImage style:UIBarButtonItemStylePlain block:^(__kindof UIBarButtonItem * _Nonnull barButtonItem) {
        kstStrongify(self);
        KSOProgressHUDTheme *theme = [self.theme copy];
        
        theme.backgroundStyle = KSOProgressHUDBackgroundStyleColor;
        theme.backgroundViewColor = KDIColorWA(0.0, 0.5);
        
        [KSOProgressHUDView presentWithTheme:theme];
    }],[UIBarButtonItem KDI_barButtonItemWithImage:[UIImage KSO_fontAwesomeSolidImageWithString:@"\uf070" size:kBarButtonItemImageSize].KDI_templateImage style:UIBarButtonItemStylePlain block:^(__kindof UIBarButtonItem * _Nonnull barButtonItem) {
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
    self.theme.style = self.styles[row].integerValue;
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
        self.theme.wantsVibrancyEffect = switchControl.isOn;
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
        self.theme.contentCornerRadius = stepper.value;
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
    label.text = @"Progress";
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
- (UIView *)_createDefaultImageViews; {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundView.backgroundColor = [self.view.tintColor KDI_contrastingColor];
    backgroundView.KDI_cornerRadius = kCornerRadius;
    
    NSArray *strings = @[@"Success",
                         @"Failure",
                         @"Info"];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:strings];
    
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    segmentedControl.apportionsSegmentWidthsByContent = YES;
    segmentedControl.momentary = YES;
    [segmentedControl KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        switch (segmentedControl.selectedSegmentIndex) {
            case 0:
                [KSOProgressHUDView presentSuccessImageWithText:@"Success!"];
                break;
            case 1:
                [KSOProgressHUDView presentFailureImageWithText:@"Failure!"];
                break;
            case 2:
                [KSOProgressHUDView presentInfoImageWithText:@"Info!"];
                break;
            default:
                break;
        }
    } forControlEvents:UIControlEventValueChanged];
    
    [backgroundView addSubview:segmentedControl];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": segmentedControl}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": segmentedControl}]];
    
    return backgroundView;
}
- (UIView *)_createImageViews; {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundView.backgroundColor = [self.view.tintColor KDI_contrastingColor];
    backgroundView.KDI_cornerRadius = kCornerRadius;
    
    NSArray *strings = @[@"\uf2b9",
                         @"\uf042",
                         @"\uf0f9",
                         @"\uf13d",
                         @"\uf187"];
    NSArray *images = [strings KQS_map:^id _Nullable(id  _Nonnull object, NSInteger index) {
        return [UIImage KSO_fontAwesomeSolidImageWithString:object size:kBarButtonItemImageSize].KDI_templateImage;
    }];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:images];
    
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    segmentedControl.apportionsSegmentWidthsByContent = YES;
    segmentedControl.momentary = YES;
    [segmentedControl KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        [KSOProgressHUDView presentWithImage:images[segmentedControl.selectedSegmentIndex] text:@"Image!"];
    } forControlEvents:UIControlEventValueChanged];
    
    [backgroundView addSubview:segmentedControl];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": segmentedControl}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": segmentedControl}]];
    
    return backgroundView;
}
- (NSString *)_stringForStyle:(KSOProgressHUDStyle)style; {
    switch (style) {
        case KSOProgressHUDStyleBlurExtraLight:
            return @"Blur Extra Light";
        case KSOProgressHUDStyleLight:
            return @"Light";
        case KSOProgressHUDStyleDark:
            return @"Dark";
        case KSOProgressHUDStyleBlurDark:
            return @"Blur Dark";
        case KSOProgressHUDStyleBlurProminent:
            return @"Blur Prominent";
        case KSOProgressHUDStyleBlurLight:
            return @"Blur Light";
        case KSOProgressHUDStyleBlurRegular:
            return @"Blur Regular";
    }
}

@end
