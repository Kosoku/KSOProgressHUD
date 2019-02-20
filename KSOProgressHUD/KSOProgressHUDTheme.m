//
//  KSOProgressHUDTheme.m
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

#import "KSOProgressHUDTheme.h"

#import <objc/runtime.h>

@interface KSOProgressHUDTheme ()
@property (readwrite,copy,nonatomic) NSString *identifier;

+ (UIFont *)_defaultTextFont;
+ (UIFontTextStyle)_defaultTextStyle;
@end

@implementation KSOProgressHUDTheme

- (NSUInteger)hash {
    return self.identifier.hash;
}
- (BOOL)isEqual:(id)object {
    return (self == object ||
            ([object isKindOfClass:KSOProgressHUDTheme.class] && [self.identifier isEqualToString:[object identifier]]));
}

- (id)copyWithZone:(NSZone *)zone {
    KSOProgressHUDTheme *retval = [[self.class alloc] initWithIdentifier:[NSString stringWithFormat:@"%@.copy",self.identifier]];
    
    retval->_style = _style;
    retval->_wantsVibrancyEffect = _wantsVibrancyEffect;
    retval->_backgroundStyle = _backgroundStyle;
    retval->_textFont = _textFont;
    retval->_textStyle = _textStyle;
    retval->_backgroundViewColor = _backgroundViewColor;
    retval->_backgroundViewClass = _backgroundViewClass;
    retval->_contentCornerRadius = _contentCornerRadius;
    retval->_contentEdgeInsets = _contentEdgeInsets;
    retval->_hapticFeedbackEnabled = _hapticFeedbackEnabled;
    
    return retval;
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (!(self = [super init]))
        return nil;
    
    _identifier = [identifier copy];
    _style = KSOProgressHUDStyleLight;
    _wantsVibrancyEffect = YES;
    _backgroundStyle = KSOProgressHUDBackgroundStyleNone;
    _textFont = [self.class _defaultTextFont];
    _textStyle = [self.class _defaultTextStyle];
    _contentCornerRadius = 5.0;
    _contentEdgeInsets = UIEdgeInsetsZero;
    
    return self;
}

static void const *kDefaultThemeKey = &kDefaultThemeKey;
+ (KSOProgressHUDTheme *)defaultTheme {
    return objc_getAssociatedObject(self, kDefaultThemeKey) ?: [[KSOProgressHUDTheme alloc] initWithIdentifier:@"com.kosoku.ksoprogresshud.theme.default"];
}
+ (void)setDefaultTheme:(KSOProgressHUDTheme *)defaultTheme {
    objc_setAssociatedObject(self, kDefaultThemeKey, defaultTheme, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont ?: [self.class _defaultTextFont];
}
- (void)setTextStyle:(UIFontTextStyle)textStyle {
    _textStyle = textStyle;
}

+ (UIFont *)_defaultTextFont; {
    return [UIFont systemFontOfSize:15.0];
}
+ (UIFontTextStyle)_defaultTextStyle; {
    return UIFontTextStyleCallout;
}

@end
