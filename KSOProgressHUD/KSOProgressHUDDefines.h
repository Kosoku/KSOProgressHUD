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

typedef NS_ENUM(NSInteger, KSOProgressHUDStyle) {
    KSOProgressHUDStyleLight = NSIntegerMin,
    KSOProgressHUDStyleDark,
    KSOProgressHUDStyleBlurExtraLight = UIBlurEffectStyleExtraLight,
    KSOProgressHUDStyleBlurLight = UIBlurEffectStyleLight,
    KSOProgressHUDStyleBlurDark = UIBlurEffectStyleDark,
#if (TARGET_OS_TV)
    KSOProgressHUDStyleBlurExtraDark = UIBlurEffectStyleExtraDark,
#endif
    KSOProgressHUDStyleBlurRegular = UIBlurEffectStyleRegular,
    KSOProgressHUDStyleBlurProminent = UIBlurEffectStyleProminent
};

typedef NS_ENUM(NSInteger, KSOProgressHUDBackgroundStyle) {
    KSOProgressHUDBackgroundStyleNone = 0,
    KSOProgressHUDBackgroundStyleColor,
    KSOProgressHUDBackgroundStyleCustom
};

#endif
