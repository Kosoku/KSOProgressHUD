//
//  KSOProgressHUDTheme.h
//  KSOProgressHUD
//
//  Created by William Towe on 4/2/18.
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
