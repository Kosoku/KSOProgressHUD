//
//  KSOProgressHUDView.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Notification that is posted when touches begin on the HUD view. The object of the notification is the HUD view.
 */
FOUNDATION_EXTERN NSNotificationName const KSOProgressHUDViewNotificationTouchesBegan;
/**
 Notification that is posted when touches end on the HUD view. The object of the notification is the HUD view.
 */
FOUNDATION_EXTERN NSNotificationName const KSOProgressHUDViewNotificationTouchesEnded;

@class KSOProgressHUDTheme;

/**
 KSOProgressHUDView is intended as a replacement for the private UIProgressHUD class.
 */
@interface KSOProgressHUDView : UIView

/**
 Set and get the theme that controls the appearance of the HUD view.
 
 The default is KSOProgressHUDTheme.defaultTheme.
 */
@property (strong,nonatomic,null_resettable) KSOProgressHUDTheme *theme;

/**
 The image to display. It will be tinted appropriately.
 
 The default is nil.
 */
@property (strong,nonatomic,nullable) UIImage *image;

/**
 The progress to display.
 
 The default is FLT_MAX, which means do not display progress.
 */
@property (assign,nonatomic) float progress;
/**
 The progress to display with optional animation.
 
 @param progress The progress to display
 @param animated Whether to animate the display
 */
- (void)setProgress:(float)progress animated:(BOOL)animated;

/**
 The NSProgress instance that will be observed to display progress changes.
 
 The default is nil.
 */
@property (strong,nonatomic,nullable) NSProgress *observedProgress;

/**
 The text to display.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) NSString *text;

/**
 Start animating the indeterminate progress.
 */
- (void)startAnimating;
/**
 Stop animating the indeterminate progress.
 */
- (void)stopAnimating;

/**
 Present a HUD view using the default theme.
 */
+ (void)present;
/**
 Present a HUD view using a specific theme.
 
 @param theme The theme to use when presenting
 */
+ (void)presentWithTheme:(nullable KSOProgressHUDTheme *)theme;
/**
 Present a HUD view and display an image.
 
 @param image The image to display
 */
+ (void)presentWithImage:(UIImage *)image;
/**
 Present a HUD view with image and text.
 
 @param image The image to display
 @param text The text to display
 */
+ (void)presentWithImage:(UIImage *)image text:(NSString *)text;
/**
 Present the default success image (from Font Awesome) with text.
 
 @param text The text to display
 */
+ (void)presentSuccessImageWithText:(NSString *)text;
/**
 Present the default failure image (from Font Awesome) with text.
 
 @param text The text to display
 */
+ (void)presentFailureImageWithText:(NSString *)text;
/**
 Present the default info image (from Font Awesome) with text.
 
 @param text The text to display
 */
+ (void)presentInfoImageWithText:(NSString *)text;
/**
 Present a HUD view with a determinate progress view displaying progress and optionally animate the change.
 
 @param progress The progress to display
 @param animated Whether to animate the change
 */
+ (void)presentWithProgress:(float)progress animated:(BOOL)animated;
/**
 Present a HUD view with text.
 
 @param text The text to display
 */
+ (void)presentWithText:(NSString *)text;
/**
 Present a HUD view with optional image, progress, observedProgress, text, within a specific view, using a specific theme.
 
 @param image The image to display
 @param progress The progress to display
 @param observedProgress The NSProgress to observe for changes
 @param text The text to display
 @param view The view in which to display the HUD view
 @param theme The theme to use when presenting
 */
+ (void)presentWithImage:(nullable UIImage *)image progress:(float)progress observedProgress:(nullable NSProgress *)observedProgress text:(nullable NSString *)text view:(nullable UIView *)view theme:(nullable KSOProgressHUDTheme *)theme;

/**
 Dismiss the HUD view with animation.
 */
+ (void)dismiss;
/**
 Dismiss the HUD view with optional animation.
 
 @param animated Whether to animate the dismissal
 */
+ (void)dismissAnimated:(BOOL)animated;
/**
 Dismiss the HUD view after a delay with optional animation.
 
 @param animated Whether to animate the dismissal
 @param delay The dealy after which to dismiss the HUD view
 */
+ (void)dismissAnimated:(BOOL)animated delay:(NSTimeInterval)delay;
/**
 Dismiss the HUD view after a delay with optional animation that is contained in a specific view.
 
 @param animated Whether to animate the dismissal
 @param delay The dealy after which to dismiss the HUD view
 @param view The view which contains the HUD view that should be dismissed
 */
+ (void)dismissAnimated:(BOOL)animated delay:(NSTimeInterval)delay view:(nullable UIView *)view;

@end

NS_ASSUME_NONNULL_END
