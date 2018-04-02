//
//  KSOProgressHUDViewController.m
//  KSOProgressHUD
//
//  Created by William Towe on 4/1/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOProgressHUDViewController.h"
#import "KSOProgressHUDView.h"
#import "KSOProgressHUDAnimationController.h"

#import <Stanley/Stanley.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>
#import <Ditko/Ditko.h>

static CGSize const kDefaultImageSize = {.width=25, .height=25};
static NSTimeInterval const kDefaultDismissDelay = 1.5;

@interface KSOProgressHUDViewController () <UIViewControllerTransitioningDelegate>
@property (readwrite,strong,nonatomic) KSOProgressHUDView *progressHUDView;
@property (strong,nonatomic) KSTTimer *dismissTimer;

@property (class,readonly,nonatomic) KSOProgressHUDViewController *currentProgressHUDViewControllerCreateIfNecessary;
@property (class,readonly,nonatomic) KSOProgressHUDViewController *currentProgressHUDViewController;
@end

@implementation KSOProgressHUDViewController
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.transitioningDelegate = self;
    
    return self;
}

- (void)loadView {
    self.progressHUDView = [[KSOProgressHUDView alloc] initWithFrame:CGRectZero];
    self.view = self.progressHUDView;
}
#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[KSOProgressHUDAnimationController alloc] initForPresenting:YES];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[KSOProgressHUDAnimationController alloc] initForPresenting:NO];
}
#pragma mark *** Public Methods ***
+ (void)present; {
    [self presentWithImage:nil progress:FLT_MAX observedProgress:nil text:nil];
}
+ (void)presentWithImage:(UIImage *)image; {
    [self presentWithImage:image progress:FLT_MAX observedProgress:nil text:nil];
}
+ (void)presentWithImage:(UIImage *)image text:(NSString *)text; {
    [self presentWithImage:image progress:FLT_MAX observedProgress:nil text:text];
}
+ (void)presentSuccessImageWithText:(NSString *)text; {
    UIImage *image = [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf00c" size:kDefaultImageSize].KDI_templateImage;
    
    [self presentWithImage:image progress:FLT_MAX observedProgress:nil text:text];
    [self dismissWithDelay:kDefaultDismissDelay];
}
+ (void)presentFailureImageWithText:(NSString *)text; {
    UIImage *image = [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf12a" size:kDefaultImageSize].KDI_templateImage;
    
    [self presentWithImage:image progress:FLT_MAX observedProgress:nil text:text];
    [self dismissWithDelay:kDefaultDismissDelay];
}
+ (void)presentInfoImageWithText:(NSString *)text; {
    UIImage *image = [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf129" size:kDefaultImageSize].KDI_templateImage;
    
    [self presentWithImage:image progress:FLT_MAX observedProgress:nil text:text];
    [self dismissWithDelay:kDefaultDismissDelay];
}
+ (void)presentWithProgress:(float)progress animated:(BOOL)animated; {
    [self presentWithImage:nil progress:progress observedProgress:nil text:nil];
}
+ (void)presentWithText:(NSString *)text; {
    [self presentWithImage:nil progress:FLT_MAX observedProgress:nil text:text];
}
+ (void)presentWithImage:(nullable UIImage *)image progress:(float)progress observedProgress:(nullable NSProgress *)observedProgress text:(nullable NSString *)text; {
    KSOProgressHUDViewController *viewController = KSOProgressHUDViewController.currentProgressHUDViewControllerCreateIfNecessary;
    KSOProgressHUDView *view = viewController.progressHUDView;
    
    [viewController.dismissTimer invalidate];
    viewController.dismissTimer = nil;
    
    view.image = image;
    view.text = text;
    
    view.observedProgress = observedProgress;
    
    if (observedProgress == nil &&
        image == nil) {
        
        if (progress == FLT_MAX) {
            [view startAnimating];
        }
        else {
            [view setProgress:progress animated:YES];
        }
    }
}
#pragma mark -
+ (void)dismiss; {
    [self dismissWithDelay:0.0];
}
+ (void)dismissWithDelay:(NSTimeInterval)delay; {
    KSOProgressHUDViewController *viewController = KSOProgressHUDViewController.currentProgressHUDViewController;
    
    void(^block)(KSTTimer *) = ^(KSTTimer *timer){
        [viewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    };
    
    if (delay > 0.0) {
        viewController.dismissTimer = [KSTTimer scheduledTimerWithTimeInterval:delay block:block userInfo:nil repeats:NO queue:nil];
    }
    else {
        block(nil);
    }
}
#pragma mark *** Private Methods ***
+ (KSOProgressHUDViewController *)currentProgressHUDViewControllerCreateIfNecessary {
    KSOProgressHUDViewController *viewController = KSOProgressHUDViewController.currentProgressHUDViewController;
    
    if (viewController == nil) {
        viewController = [[KSOProgressHUDViewController alloc] initWithNibName:nil bundle:nil];
        
        [[UIViewController KDI_viewControllerForPresenting] presentViewController:viewController animated:YES completion:nil];
    }
    
    return viewController;
}
+ (KSOProgressHUDViewController *)currentProgressHUDViewController {
    UIViewController *viewController = [UIViewController KDI_viewControllerForPresenting];
    
    return [viewController isKindOfClass:KSOProgressHUDViewController.class] ? (KSOProgressHUDViewController *)viewController : nil;
}

@end
