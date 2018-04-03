//
//  KSOProgressHUDTheme.m
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
