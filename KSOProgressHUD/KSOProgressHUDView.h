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

typedef NS_OPTIONS(NSUInteger, KSOProgressHUDViewOptions) {
    KSOProgressHUDViewOptionsNone = 0,
    KSOProgressHUDViewOptionsWantsVibrancyEffect = 1 << 0,
    KSOProgressHUDViewOptionsAll = KSOProgressHUDViewOptionsWantsVibrancyEffect
};

typedef NS_ENUM(NSInteger, KSOProgressHUDViewStyle) {
    KSOProgressHUDViewStyleLight = NSIntegerMin,
    KSOProgressHUDViewStyleDark,
    KSOProgressHUDViewStyleBlurExtraLight = UIBlurEffectStyleExtraLight,
    KSOProgressHUDViewStyleBlurLight = UIBlurEffectStyleLight,
    KSOProgressHUDViewStyleBlurDark = UIBlurEffectStyleDark,
#if (TARGET_OS_TV)
    KSOProgressHUDViewStyleBlurExtraDark = UIBlurEffectStyleExtraDark,
#endif
    KSOProgressHUDViewStyleBlurRegular = UIBlurEffectStyleRegular,
    KSOProgressHUDViewStyleBlurProminent = UIBlurEffectStyleProminent
};

@interface KSOProgressHUDView : UIView

@property (assign,nonatomic) KSOProgressHUDViewOptions options UI_APPEARANCE_SELECTOR;
@property (assign,nonatomic) KSOProgressHUDViewStyle style UI_APPEARANCE_SELECTOR;
@property (assign,nonatomic) CGFloat contentCornerRadius UI_APPEARANCE_SELECTOR;

@property (assign,nonatomic) float progress;
- (void)setProgress:(float)progress animated:(BOOL)animated;

+ (void)present;
+ (void)dismiss;
+ (void)presentWithProgress:(float)progress animated:(BOOL)animated;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
