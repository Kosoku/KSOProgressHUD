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

typedef NS_ENUM(NSInteger, KSOProgressHUDViewBlurEffectStyle) {
    KSOProgressHUDViewBlurEffectStyleNone = NSIntegerMin,
    KSOProgressHUDViewBlurEffectStyleExtraLight = UIBlurEffectStyleExtraLight,
    KSOProgressHUDViewBlurEffectStyleLight = UIBlurEffectStyleLight,
    KSOProgressHUDViewBlurEffectStyleDark = UIBlurEffectStyleDark,
#if (TARGET_OS_TV)
    KSOProgressHUDViewBlurEffectStyleExtraDark = UIBlurEffectStyleExtraDark,
#endif
    KSOProgressHUDViewBlurEffectStyleRegular = UIBlurEffectStyleRegular,
    KSOProgressHUDViewBlurEffectStyleProminent = UIBlurEffectStyleProminent
};

@interface KSOProgressHUDView : UIView

@property (class,readonly,nonatomic,nullable) __kindof KSOProgressHUDView *currentProgressHUDView;

@property (assign,nonatomic) KSOProgressHUDViewBlurEffectStyle blurEffectStyle UI_APPEARANCE_SELECTOR;
@property (assign,nonatomic) BOOL wantsVibrancyEffect UI_APPEARANCE_SELECTOR;

@property (assign,nonatomic) float progress;
- (void)setProgress:(float)progress animated:(BOOL)animated;

+ (instancetype)progressHUDView;

+ (__kindof KSOProgressHUDView *)present;
+ (void)dismiss;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
