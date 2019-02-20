//
//  KSOProgressHUDDefines.h
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
