//
//  KSOProgressHUDTheme.h
//  KSOProgressHUD
//
//  Created by William Towe on 4/2/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>
#import <KSOProgressHUD/KSOProgressHUDDefines.h>

NS_ASSUME_NONNULL_BEGIN

/**
 KSOProgressHUDTheme controls the appearance of a KSOProgressHUDView while it is presented.
 */
@interface KSOProgressHUDTheme : NSObject <NSCopying>

/**
 Set and get the default chat theme.
 */
@property (class,strong,nonatomic,null_resettable) KSOProgressHUDTheme *defaultTheme;

/**
 The identifier of the theme.
 */
@property (readonly,copy,nonatomic) NSString *identifier;

/**
 The HUD style.
 
 The default is KSOProgressHUDStyleLight.
 
 @see KSOProgressHUDStyle
 */
@property (assign,nonatomic) KSOProgressHUDStyle style;
/**
 When using a HUD style that uses a UIVisualEffectView, use vibrancy in combination with that view.
 
 The default is YES.
 */
@property (assign,nonatomic) BOOL wantsVibrancyEffect;
/**
 The background style.
 
 The default is KSOProgressHUDBackgroundStyleNone.
 
 @see KSOProgressHUDBackgroundStyle
 */
@property (assign,nonatomic) KSOProgressHUDBackgroundStyle backgroundStyle;
/**
 The font used for text. This will be used if textStyle is nil.
 
 The default is [UIFont systemFontOfSize:15.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *textFont;
/**
 The text style used to support dynamic type.
 
 The default is UIFontTextStyleCallout.
 */
@property (copy,nonatomic,nullable) UIFontTextStyle textStyle;
/**
 The background view color to use when backgroundStyle is KSOProgressHUDBackgroundStyleColor.
 
 The default is nil.
 */
@property (strong,nonatomic,nullable) UIColor *backgroundViewColor;
/**
 The background view class to use when backgroundStyle is KSOProgressHUDBackgroundStyleCustom. This must be a subclass of UIView.
 
 The default is Nil.
 */
@property (strong,nonatomic,nullable) Class backgroundViewClass;
/**
 The corner radius of the HUD content view.
 
 The default is 5.0.
 */
@property (assign,nonatomic) CGFloat contentCornerRadius;
/**
 The edge insets that define how much the content is inset from each edge of the HUD content view.
 
 The default is UIEdgeInsetsZero, which means use the default system spacing.
 */
@property (assign,nonatomic) UIEdgeInsets contentEdgeInsets;

/**
 Whether haptic feedback is generated at appropriate times.
 
 The default is NO.
 */
@property (assign,nonatomic) BOOL hapticFeedbackEnabled;

/**
 The designated initializer.
 
 @param identifier The identifier of the receiver
 @return The initialized instance
 */
- (instancetype)initWithIdentifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
