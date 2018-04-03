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

static CGSize const kDefaultImageSize = {.width=25, .height=25};
static NSTimeInterval const kDefaultDismissDelay = 1.5;

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

@property (assign,nonatomic) BOOL hasPerformedPresentAnimation;

@property (strong,nonatomic) KSTTimer *dismissTimer;

@property (class,readonly,nonatomic) UIWindow *currentWindow;

- (void)_updateSubviewHierarchy;
+ (KSOProgressHUDView *)_progressHUDViewInView:(UIView *)view create:(BOOL)create;
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
    
    UIView *contentBackgroundView = nil;
    
    if (self.blurEffectView != nil) {
        contentBackgroundView = self.blurEffectView;
        
        if (self.vibrancyEffectView != nil) {
            [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.vibrancyEffectView}]];
            [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.vibrancyEffectView}]];
        }
    }
    else if (self.contentBackgroundView != nil) {
        contentBackgroundView = self.contentBackgroundView;
    }
    
    [temp addObjectsFromArray:@[[contentBackgroundView.centerXAnchor constraintEqualToAnchor:self.backgroundView.centerXAnchor],[contentBackgroundView.centerYAnchor constraintEqualToAnchor:self.backgroundView.centerYAnchor]]];
    
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.backgroundView}]];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.backgroundView}]];
    
    self.KDI_customConstraints = temp;
    
    [super updateConstraints];
}
#pragma mark *** Public Methods ***
- (void)startAnimating; {
    [self.activityIndicatorView startAnimating];
}
- (void)stopAnimating; {
    [self.activityIndicatorView stopAnimating];
}
#pragma mark -
+ (void)present; {
    [self presentWithImage:nil progress:FLT_MAX observedProgress:nil text:nil view:nil];
}
+ (void)presentWithImage:(UIImage *)image; {
    [self presentWithImage:image progress:FLT_MAX observedProgress:nil text:nil view:nil];
}
+ (void)presentWithImage:(UIImage *)image text:(NSString *)text; {
    [self presentWithImage:image progress:FLT_MAX observedProgress:nil text:text view:nil];
}
+ (void)presentSuccessImageWithText:(NSString *)text; {
    UIImage *image = [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf00c" size:kDefaultImageSize].KDI_templateImage;
    
    [self presentWithImage:image progress:FLT_MAX observedProgress:nil text:text view:nil];
    [self dismissAnimated:YES delay:kDefaultDismissDelay];
}
+ (void)presentFailureImageWithText:(NSString *)text; {
    UIImage *image = [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf12a" size:kDefaultImageSize].KDI_templateImage;
    
    [self presentWithImage:image progress:FLT_MAX observedProgress:nil text:text view:nil];
    [self dismissAnimated:YES delay:kDefaultDismissDelay];
}
+ (void)presentInfoImageWithText:(NSString *)text; {
    UIImage *image = [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf129" size:kDefaultImageSize].KDI_templateImage;
    
    [self presentWithImage:image progress:FLT_MAX observedProgress:nil text:text view:nil];
    [self dismissAnimated:YES delay:kDefaultDismissDelay];
}
+ (void)presentWithProgress:(float)progress animated:(BOOL)animated; {
    [self presentWithImage:nil progress:progress observedProgress:nil text:nil view:nil];
}
+ (void)presentWithText:(NSString *)text; {
    [self presentWithImage:nil progress:FLT_MAX observedProgress:nil text:text view:nil];
}
+ (void)presentWithImage:(UIImage *)image progress:(float)progress observedProgress:(NSProgress *)observedProgress text:(NSString *)text view:(UIView *)view; {
    KSOProgressHUDView *progressHUDView = [KSOProgressHUDView _progressHUDViewInView:view create:YES];
    
    [progressHUDView.dismissTimer invalidate];
    progressHUDView.dismissTimer = nil;
    
    progressHUDView.image = image;
    progressHUDView.text = text;
    
    progressHUDView.observedProgress = observedProgress;
    
    if (observedProgress == nil &&
        image == nil) {
        
        if (progress == FLT_MAX) {
            [progressHUDView startAnimating];
            
            progressHUDView.progressView.hidden = YES;
        }
        else {
            [progressHUDView stopAnimating];
            
            progressHUDView.progressView.hidden = NO;
            [progressHUDView setProgress:progress animated:YES];
        }
    }
    else if (observedProgress != nil) {
        progressHUDView.progressView.hidden = NO;
    }
    else {
        [progressHUDView stopAnimating];
    }
    
    if (!progressHUDView.hasPerformedPresentAnimation) {
        progressHUDView.hasPerformedPresentAnimation = YES;
        
        progressHUDView.alpha = 0.0;
        progressHUDView.transform = CGAffineTransformMakeScale(2.0, 2.0);
        
        [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            progressHUDView.alpha = 1.0;
            progressHUDView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}
#pragma mark -
+ (void)dismiss; {
    [self dismissAnimated:YES delay:0.0 view:nil];
}
+ (void)dismissAnimated:(BOOL)animated; {
    [self dismissAnimated:animated delay:0.0 view:nil];
}
+ (void)dismissAnimated:(BOOL)animated delay:(NSTimeInterval)delay; {
    [self dismissAnimated:animated delay:delay view:nil];
}
+ (void)dismissAnimated:(BOOL)animated delay:(NSTimeInterval)delay view:(UIView *)view; {
    KSOProgressHUDView *progressHUDView = [KSOProgressHUDView _progressHUDViewInView:view create:NO];
    
    if (progressHUDView == nil) {
        return;
    }
    
    void(^completion)(void) = ^{
        [progressHUDView removeFromSuperview];
    };
    void(^block)(KSTTimer *) = ^(KSTTimer *timer){
        if (animated) {
            [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                progressHUDView.alpha = 0.0;
                progressHUDView.transform = CGAffineTransformMakeScale(2.0, 2.0);
            } completion:^(BOOL finished) {
                if (finished) {
                    completion();
                }
            }];
        }
        else {
            completion();
        }
    };
    
    if (delay > 0.0) {
        progressHUDView.dismissTimer = [KSTTimer scheduledTimerWithTimeInterval:delay block:block userInfo:nil repeats:NO queue:nil];
    }
    else {
        block(nil);
    }
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
- (void)setBackgroundStyle:(KSOProgressHUDViewBackgroundStyle)backgroundStyle {
    if (_backgroundStyle == backgroundStyle) {
        return;
    }
    
    _backgroundStyle = backgroundStyle;
    
    switch (_backgroundStyle) {
        case KSOProgressHUDViewBackgroundStyleNone:
            self.userInteractionEnabled = NO;
            break;
        case KSOProgressHUDViewBackgroundStyleColor:
        case KSOProgressHUDViewBackgroundStyleCustom:
            self.userInteractionEnabled = YES;
            break;
        default:
            break;
    }
    
    [self _updateSubviewHierarchy];
}
- (void)setBackgroundViewColor:(UIColor *)backgroundViewColor {
    _backgroundViewColor = backgroundViewColor;
    
    if (self.backgroundStyle == KSOProgressHUDViewBackgroundStyleColor) {
        self.backgroundView.backgroundColor = _backgroundViewColor;
    }
}
- (void)setBackgroundViewClassName:(NSString *)backgroundViewClassName {
    _backgroundViewClassName = [backgroundViewClassName copy];
    
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
@dynamic progress;
- (float)progress {
    return self.progressView.progress;
}
- (void)setProgress:(float)progress {
    [self setProgress:progress animated:NO];
}
- (void)setProgress:(float)progress animated:(BOOL)animated; {
    [self.progressView setProgress:progress animated:animated];
}
#pragma mark -
@dynamic observedProgress;
- (NSProgress *)observedProgress {
    return self.progressView.observedProgress;
}
- (void)setObservedProgress:(NSProgress *)observedProgress {
    self.progressView.observedProgress = observedProgress;
}
#pragma mark -
@dynamic text;
- (NSString *)text {
    return self.label.text;
}
- (void)setText:(NSString *)text {
    self.label.text = text;
    self.label.hidden = text.length == 0;
}
#pragma mark -
@dynamic image;
- (UIImage *)image {
    return self.imageView.image;
}
- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    self.imageView.hidden = image == nil;
}
#pragma mark *** Private Methods ***
- (void)_updateSubviewHierarchy; {
    switch (self.backgroundStyle) {
        case KSOProgressHUDViewBackgroundStyleCustom:
            if (self.backgroundViewClassName.length > 0) {
                self.backgroundView = [[NSClassFromString(self.backgroundViewClassName) alloc] initWithFrame:CGRectZero];
            }
            break;
        case KSOProgressHUDViewBackgroundStyleColor:
            self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            self.backgroundView.backgroundColor = self.backgroundViewColor;
            break;
        case KSOProgressHUDViewBackgroundStyleNone:
            self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            self.backgroundView.backgroundColor = UIColor.clearColor;
            break;
    }

    if (self.backgroundView == nil) {
        return;
    }
    
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
+ (KSOProgressHUDView *)_progressHUDViewInView:(UIView *)view create:(BOOL)create; {
    if (view == nil) {
        view = KSOProgressHUDView.currentWindow;
    }
    
    KSOProgressHUDView *retval = [view.subviews.KST_reversedArray KQS_find:^BOOL(__kindof UIView * _Nonnull object, NSInteger index) {
        return [object isKindOfClass:KSOProgressHUDView.class];
    }];
    
    if (retval == nil) {
        retval = [[KSOProgressHUDView alloc] initWithFrame:CGRectZero];
        
        [view addSubview:retval];
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": retval}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": retval}]];
    }
    else {
        [retval.superview bringSubviewToFront:retval];
    }
    
    return retval;
}
#pragma mark Properties
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
