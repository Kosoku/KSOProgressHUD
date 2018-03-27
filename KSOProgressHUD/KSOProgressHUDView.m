//
//  KSOProgressHUDView.m
//  KSOProgressHUD
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

#import "KSOProgressHUDView.h"

#import <Ditko/Ditko.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>
#import <Quicksilver/Quicksilver.h>
#import <Stanley/Stanley.h>

@interface KSOProgressHUDView ()

@property (strong,nonatomic) UIView *backgroundView;

@property (strong,nonatomic) UIVisualEffectView *blurEffectView;
@property (strong,nonatomic) UIVisualEffectView *vibrancyEffectView;

@property (strong,nonatomic) UIView *contentBackgroundView;
@property (strong,nonatomic) UIStackView *stackView;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UIProgressView *progressView;
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong,nonatomic) UILabel *label;

@property (readonly,nonatomic) BOOL wantsVibrancyEffect;
@property (readonly,nonatomic) UIColor *contentBackgroundColor;
@property (readonly,nonatomic) UIColor *contentForegroundColor;

@property (class,readonly,nonatomic) KSOProgressHUDView *currentProgressHUDView;
@property (class,readonly,nonatomic) KSOProgressHUDView *currentProgressHUDViewCreateIfNecessary;
@property (class,readonly,nonatomic) UIWindow *currentWindow;

- (void)_updateSubviewHierarchy;
@end

@implementation KSOProgressHUDView
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _options = KSOProgressHUDViewOptionsAll;
    _style = KSOProgressHUDViewStyleLight;
    _contentCornerRadius = 5.0;
    
    self.userInteractionEnabled = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = UIColor.clearColor;
    
    [self _updateSubviewHierarchy];
    
    return self;
}
#pragma mark -
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (void)updateConstraints {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    if (!self.progressView.isHidden) {
        [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view(>=width)]|" options:0 metrics:@{@"width": @75.0} views:@{@"view": self.progressView}]];
    }
    
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": self.stackView}]];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": self.stackView}]];
    
    if (self.blurEffectView != nil) {
        [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.blurEffectView}]];
        [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.blurEffectView}]];
        
        if (self.vibrancyEffectView != nil) {
            [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.vibrancyEffectView}]];
            [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.vibrancyEffectView}]];
        }
    }
    else if (self.contentBackgroundView != nil) {
        [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.contentBackgroundView}]];
        [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.contentBackgroundView}]];
    }
    
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=margin-[view]->=margin-|" options:0 metrics:@{@"margin": @0.0} views:@{@"view": self.backgroundView}]];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=margin-[view]->=margin-|" options:0 metrics:@{@"margin": @0.0} views:@{@"view": self.backgroundView}]];
    [temp addObjectsFromArray:@[[self.backgroundView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],[self.backgroundView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]]];
    
    self.KDI_customConstraints = temp;
    
    [super updateConstraints];
}
#pragma mark *** Public Methods ***
+ (void)present; {
    KSOProgressHUDView *view = KSOProgressHUDView.currentProgressHUDViewCreateIfNecessary;
    
    view.progressView.hidden = YES;
    
    [view setNeedsUpdateConstraints];
    
    [view startAnimating];
}
+ (void)dismiss; {
    [KSOProgressHUDView.currentProgressHUDView removeFromSuperview];
}
+ (void)presentWithProgress:(float)progress animated:(BOOL)animated; {
    KSOProgressHUDView *view = KSOProgressHUDView.currentProgressHUDViewCreateIfNecessary;
    
    view.progressView.hidden = NO;
    
    [view stopAnimating];
    
    [view setNeedsUpdateConstraints];
    
    [view setProgress:progress animated:animated];
}
#pragma mark -
- (void)setOptions:(KSOProgressHUDViewOptions)options {
    if (_options == options) {
        return;
    }
    
    _options = options;
    
    [self _updateSubviewHierarchy];
}
- (void)setStyle:(KSOProgressHUDViewStyle)style {
    if (_style == style) {
        return;
    }
    
    _style = style;
    
    [self _updateSubviewHierarchy];
}
- (void)setContentCornerRadius:(CGFloat)contentCornerRadius {
    if (_contentCornerRadius == contentCornerRadius) {
        return;
    }
    
    _contentCornerRadius = contentCornerRadius;
    
    [self.blurEffectView ?: self.contentBackgroundView setKDI_cornerRadius:_contentCornerRadius];
}
#pragma mark -
- (void)startAnimating; {
    [self.activityIndicatorView startAnimating];
}
- (void)stopAnimating; {
    [self.activityIndicatorView stopAnimating];
}
#pragma mark -
- (float)progress {
    return self.progressView.progress;
}
- (void)setProgress:(float)progress {
    [self setProgress:progress animated:NO];
}
- (void)setProgress:(float)progress animated:(BOOL)animated; {
    [self.progressView setProgress:progress animated:animated];
}
#pragma mark *** Private Methods ***
- (void)_updateSubviewHierarchy; {
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    switch (self.style) {
        case KSOProgressHUDViewStyleDark:
        case KSOProgressHUDViewStyleLight:
            self.vibrancyEffectView = nil;
            self.blurEffectView = nil;
            
            self.contentBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            break;
        default:
            self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:(UIBlurEffectStyle)self.style]];
            
            if (self.wantsVibrancyEffect) {
                self.vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)self.blurEffectView.effect]];
            }
            else {
                self.vibrancyEffectView = nil;
            }
            break;
    }
    
    self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
}
#pragma mark Properties
+ (KSOProgressHUDView *)currentProgressHUDView {
    return [KSOProgressHUDView.currentWindow.subviews.KST_reversedArray KQS_find:^BOOL(__kindof UIView * _Nonnull object, NSInteger index) {
        return [object isKindOfClass:KSOProgressHUDView.class];
    }];
}
+ (KSOProgressHUDView *)currentProgressHUDViewCreateIfNecessary {
    KSOProgressHUDView *retval = KSOProgressHUDView.currentProgressHUDView;
    
    if (retval == nil) {
        retval = [[KSOProgressHUDView alloc] initWithFrame:CGRectZero];
        
        [KSOProgressHUDView.currentWindow addSubview:retval];
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": retval}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": retval}]];
    }
    else {
        [retval.superview bringSubviewToFront:retval];
    }
    
    return retval;
}
+ (UIWindow *)currentWindow {
    return [UIApplication.sharedApplication.windows KQS_find:^BOOL(__kindof UIWindow * _Nonnull object, NSInteger index) {
        return ([object.screen isEqual:UIScreen.mainScreen] &&
                !object.isHidden &&
                object.alpha > 0.0 &&
                object.windowLevel >= UIWindowLevelNormal &&
                object.windowLevel <= UIWindowLevelNormal &&
                object.isKeyWindow);
    }];
}
#pragma mark -
- (void)setBackgroundView:(UIView *)backgroundView {
    [_backgroundView removeFromSuperview];
    
    _backgroundView = backgroundView;
    
    if (_backgroundView != nil) {
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundView.backgroundColor = UIColor.clearColor;
        
        [self addSubview:_backgroundView];
    }
}
- (void)setContentBackgroundView:(UIView *)contentBackgroundView {
    [_contentBackgroundView removeFromSuperview];
    
    _contentBackgroundView = contentBackgroundView;
    
    if (_contentBackgroundView != nil) {
        _contentBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentBackgroundView.backgroundColor = self.contentBackgroundColor;
        _contentBackgroundView.KDI_cornerRadius = self.contentCornerRadius;
        
        [self.backgroundView addSubview:_contentBackgroundView];
    }
}
- (void)setBlurEffectView:(UIVisualEffectView *)blurEffectView {
    [_blurEffectView removeFromSuperview];
    
    _blurEffectView = blurEffectView;
    
    if (_blurEffectView != nil) {
        _blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
        _blurEffectView.layer.masksToBounds = YES;
        _blurEffectView.KDI_cornerRadius = self.contentCornerRadius;
        
        [self.backgroundView addSubview:_blurEffectView];
    }
}
- (void)setVibrancyEffectView:(UIVisualEffectView *)vibrancyEffectView {
    [_vibrancyEffectView removeFromSuperview];
    
    _vibrancyEffectView = vibrancyEffectView;
    
    if (_vibrancyEffectView != nil) {
        _vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.blurEffectView.contentView addSubview:_vibrancyEffectView];
    }
}
- (void)setStackView:(UIStackView *)stackView {
    [_stackView removeFromSuperview];
    
    _stackView = stackView;
    
    if (_stackView != nil) {
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.spacing = 8.0;
        
        [self.vibrancyEffectView.contentView ?: self.blurEffectView.contentView ?: self.contentBackgroundView addSubview:_stackView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    }
}
- (void)setImageView:(UIImageView *)imageView {
    [_imageView removeFromSuperview];
    
    _imageView = imageView;
    
    if (_imageView != nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.hidden = YES;
        _imageView.tintColor = self.contentForegroundColor;
        
        [self.stackView addArrangedSubview:_imageView];
    }
}
- (void)setActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView {
    [_activityIndicatorView removeFromSuperview];
    
    _activityIndicatorView = activityIndicatorView;
    
    if (_activityIndicatorView != nil) {
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.color = self.contentForegroundColor;
        
        [self.stackView addArrangedSubview:_activityIndicatorView];
    }
}
- (void)setProgressView:(UIProgressView *)progressView {
    [_progressView removeFromSuperview];
    
    _progressView = progressView;
    
    if (_progressView != nil) {
        _progressView.translatesAutoresizingMaskIntoConstraints = NO;
        _progressView.hidden = YES;
        _progressView.progressTintColor = self.contentForegroundColor;
        
        [self.stackView addArrangedSubview:_progressView];
    }
}
- (void)setLabel:(UILabel *)label {
    [_label removeFromSuperview];
    
    _label = label;
    
    if (_label != nil) {
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.hidden = YES;
        _label.KDI_dynamicTypeTextStyle = UIFontTextStyleCallout;
        _label.textColor = self.contentForegroundColor;
        
        [self.stackView addArrangedSubview:_label];
    }
}
#pragma mark -
- (BOOL)wantsVibrancyEffect {
    return self.options & KSOProgressHUDViewOptionsWantsVibrancyEffect;
}
- (UIColor *)contentBackgroundColor {
    switch (self.style) {
        case KSOProgressHUDViewStyleLight:
            return UIColor.whiteColor;
        case KSOProgressHUDViewStyleDark:
            return UIColor.blackColor;
        default:
            return UIColor.clearColor;
    }
}
- (UIColor *)contentForegroundColor {
    switch (self.style) {
        case KSOProgressHUDViewStyleLight:
        case KSOProgressHUDViewStyleDark:
            return [self.contentBackgroundColor KDI_contrastingColor];
        case KSOProgressHUDViewStyleBlurDark:
#if (TARGET_OS_TV)
        case KSOProgressHUDViewStyleBlurExtraDark:
#endif
            return self.wantsVibrancyEffect ? nil : UIColor.whiteColor;
        case KSOProgressHUDViewStyleBlurLight:
        case KSOProgressHUDViewStyleBlurRegular:
        case KSOProgressHUDViewStyleBlurProminent:
        case KSOProgressHUDViewStyleBlurExtraLight:
            return self.wantsVibrancyEffect ? nil : UIColor.blackColor;
    }
}

@end
