//
//  KSOProgressHUDDefines.h
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

#ifndef __KSO_PROGRESS_HUD_DEFINES__
#define __KSO_PROGRESS_HUD_DEFINES__

#import <UIKit/UIKit.h>

/**
 Enum describing the HUD style.
 */
typedef NS_ENUM(NSInteger, KSOProgressHUDStyle) {
    /**
     Light background with dark UI elements.
     */
    KSOProgressHUDStyleLight = NSIntegerMin,
    /**
     Dark background with light UI elements.
     */
    KSOProgressHUDStyleDark,
    /**
     UIVisualEffectView using UIBlurEffectStyleExtraLight style and dark UI elements.
     */
    KSOProgressHUDStyleBlurExtraLight = UIBlurEffectStyleExtraLight,
    /**
     UIVisualEffectView using UIBlurEffectStyleLight style and dark UI elements.
     */
    KSOProgressHUDStyleBlurLight = UIBlurEffectStyleLight,
    /**
     UIVisualEffectView using UIBlurEffectStyleDark style and light UI elements.
     */
    KSOProgressHUDStyleBlurDark = UIBlurEffectStyleDark,
#if (TARGET_OS_TV)
    /**
     UIVisualEffectView using UIBlurEffectStyleExtraDark style and light UI elements.
     */
    KSOProgressHUDStyleBlurExtraDark = UIBlurEffectStyleExtraDark,
#endif
    /**
     UIVisualEffectView using UIBlurEffectStyleRegular style and dark UI elements.
     */
    KSOProgressHUDStyleBlurRegular = UIBlurEffectStyleRegular,
    /**
     UIVisualEffectView using UIBlurEffectStyleProminent style and dark UI elements.
     */
    KSOProgressHUDStyleBlurProminent = UIBlurEffectStyleProminent
};

/**
 Enum describing the style of background covering the remainder of the window.
 */
typedef NS_ENUM(NSInteger, KSOProgressHUDBackgroundStyle) {
    /**
     No background, user can interact with UI behind the HUD.
     */
    KSOProgressHUDBackgroundStyleNone = 0,
    /**
     Solid color background (optional transparency), user cannot interact with UI behind the HUD.
     */
    KSOProgressHUDBackgroundStyleColor,
    /**
     A custom background view class is provided (e.g. a gradient view), user cannot interact with UI behind the HUD.
     */
    KSOProgressHUDBackgroundStyleCustom
};

#endif
