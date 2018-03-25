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

@interface KSOProgressHUDView ()

@property (strong,nonatomic) UIVisualEffectView *blurEffectView;
@property (strong,nonatomic) UIVisualEffectView *vibrancyEffectView;

@property (strong,nonatomic) UIStackView *stackView;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UIProgressView *progressView;
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong,nonatomic) UILabel *label;
@end

@implementation KSOProgressHUDView
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _blurEffectStyle = KSOProgressHUDViewBlurEffectStyleNone;
    
    self.userInteractionEnabled = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = UIColor.clearColor;
    
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    _blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    _blurEffectView.KDI_cornerRadius = 5.0;
    _blurEffectView.layer.masksToBounds = YES;
    [self addSubview:_blurEffectView];
    
    _vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)_blurEffectView.effect]];
    _vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [_blurEffectView.contentView addSubview:_vibrancyEffectView];
    
    _stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.alignment = UIStackViewAlignmentCenter;
    _stackView.spacing = 8.0;
    [_vibrancyEffectView.contentView addSubview:_stackView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.image = [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf00c" size:CGSizeMake(25, 25)].KDI_templateImage;
    [_stackView addArrangedSubview:_imageView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    _activityIndicatorView.hidesWhenStopped = YES;
    [_stackView addArrangedSubview:_activityIndicatorView];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    _progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [_stackView addArrangedSubview:_progressView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.KDI_dynamicTypeTextStyle = UIFontTextStyleCallout;
    _label.text = @"Loading…";
    [_stackView addArrangedSubview:_label];
    
    return self;
}
#pragma mark -
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (void)updateConstraints {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.progressView}]];
    
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": self.stackView}]];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": self.stackView}]];
    
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.vibrancyEffectView}]];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.vibrancyEffectView}]];
    
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=margin-[view]->=margin-|" options:0 metrics:@{@"margin": @0.0} views:@{@"view": self.blurEffectView}]];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=margin-[view]->=margin-|" options:0 metrics:@{@"margin": @0.0} views:@{@"view": self.blurEffectView}]];
    [temp addObjectsFromArray:@[[self.blurEffectView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],[self.blurEffectView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]]];
    
    self.KDI_customConstraints = temp;
    
    [super updateConstraints];
}
#pragma mark *** Public Methods ***
+ (instancetype)progressHUDView; {
    return [[self alloc] initWithFrame:CGRectZero];
}
#pragma mark -
+ (KSOProgressHUDView *)present; {
    KSOProgressHUDView *view = KSOProgressHUDView.currentProgressHUDView;
    
    if (view == nil) {
        UIWindow *window = UIApplication.sharedApplication.windows.lastObject;
        
        view = [KSOProgressHUDView progressHUDView];
        
        [window addSubview:view];
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
    }
    
    return view;
}
+ (void)dismiss; {
    [KSOProgressHUDView.currentProgressHUDView removeFromSuperview];
}
#pragma mark -
+ (KSOProgressHUDView *)currentProgressHUDView {
    UIWindow *window = UIApplication.sharedApplication.windows.lastObject;
    KSOProgressHUDView *view = [window.subviews KQS_find:^BOOL(__kindof UIView * _Nonnull object, NSInteger index) {
        return [object isKindOfClass:KSOProgressHUDView.class];
    }];
    
    return view;
}
#pragma mark -
- (void)startAnimating; {
    [self.activityIndicatorView startAnimating];
}
- (void)stopAnimating; {
    [self.activityIndicatorView stopAnimating];
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

@end
