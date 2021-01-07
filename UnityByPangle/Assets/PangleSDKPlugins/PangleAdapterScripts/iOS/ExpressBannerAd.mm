//------------------------------------------------------------------------------
// Copyright (c) 2018-2019 Beijing Bytedance Technology Co., Ltd.
// All Right Reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited.
// Proprietary and confidential.
//------------------------------------------------------------------------------

#import <BUAdSDK/BUAdSDK.h>
#import "UnityAppController.h"

static const char* AutonomousStringCopy_Express(const char* string);

const char* AutonomousStringCopy_Express(const char* string)
{
    if (string == NULL) {
        return NULL;
    }

    char* res = (char*)malloc(strlen(string) + 1);
    strcpy(res, string);
    return res;
}


typedef void(*ExpressAd_OnLoad)(void* expressAd, int context);
typedef void(*ExpressAd_OnLoadError)(int errCode,const char* errMsg,int context);
typedef void(*ExpressAd_WillShow)(int context);
typedef void(*ExpressAd_DidClick)(int context);
typedef void(*ExpressAd_DidClose)(int context);

@interface ExpressBannerAd : NSObject<BUNativeExpressBannerViewDelegate>

@property(nonatomic, strong) BUNativeExpressBannerView *bannerView;
@property (nonatomic, assign) float adWidth;
@property (nonatomic, assign) float adHeight;

@property (nonatomic, assign) int loadContext;
@property (nonatomic, assign) int listenContext;

@property (nonatomic, assign) ExpressAd_OnLoad onLoad;
@property (nonatomic, assign) ExpressAd_OnLoadError onLoadError;
@property (nonatomic, assign) ExpressAd_WillShow willShow;
@property (nonatomic, assign) ExpressAd_DidClick didClick;
@property (nonatomic, assign) ExpressAd_DidClose didClose;
@end


@implementation ExpressBannerAd
- (void)dealloc {
    [_bannerView removeFromSuperview];
    _bannerView = nil;
}

#pragma BUNativeExpressBannerViewDelegate
- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *)error {
    if (self.onLoadError) {
        self.onLoadError((int)error.code,[[error localizedDescription] UTF8String],self.loadContext);
    }
}

- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView {
    if (self.onLoad) {
        self.onLoad((__bridge void*)self, self.loadContext);
    }
}

- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError *)error {
    if (self.onLoadError) {
        self.onLoadError((int)error.code,[[error localizedDescription] UTF8String],self.loadContext);
    }
}

- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView {
    if (self.willShow) {
        self.willShow(self.listenContext);
    }}

- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {
    if (self.didClick) {
        self.didClick(self.listenContext);
    }}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterwords {
    [UIView animateWithDuration:0.25 animations:^{
        bannerAdView.alpha = 0;
    } completion:^(BOOL finished) {
        [bannerAdView removeFromSuperview];
        if (self.didClose) {
            self.didClose(self.listenContext);
        }
    }];
}

@end

#if defined (__cplusplus)
extern "C" {
#endif
    void UnionPlatform_ExpressBannersAd_Load(
                                      const char* slotID,
                                      float width,
                                      float height,
                                      ExpressAd_OnLoad onLoad,
                                      ExpressAd_OnLoadError onLoadError,
                                      int context) {
        ExpressBannerAd *instance = [[ExpressBannerAd alloc] init];

        CGFloat newWidth = width/[UIScreen mainScreen].scale;
        CGFloat newHeight = height/[UIScreen mainScreen].scale;

        NSDecimalNumber *widthNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",width]];
        NSDecimalNumber *heightNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",height]];
        NSDecimalNumber *scale = [widthNumber decimalNumberByDividingBy:heightNumber];

        NSDecimalNumber *widthNumber600500 = [NSDecimalNumber decimalNumberWithString:@"600"];
        NSDecimalNumber *heightNumber600500 = [NSDecimalNumber decimalNumberWithString:@"500"];
        NSDecimalNumber *newscale600500 = [widthNumber600500 decimalNumberByDividingBy:heightNumber600500];

        if ([scale compare:newscale600500]==NSOrderedSame) {
             newWidth = 300;
             newHeight = 250;
        } else {
             NSDecimalNumber *widthNumber640100 = [NSDecimalNumber decimalNumberWithString:@"640"];
             NSDecimalNumber *heightNumber640100 = [NSDecimalNumber decimalNumberWithString:@"100"];
             NSDecimalNumber *newscale640100 = [widthNumber640100 decimalNumberByDividingBy:heightNumber640100];
             if ([scale compare:newscale640100]==NSOrderedSame) {
                 newWidth = 320;
                 newHeight = 50;
             }
        }

        if (0) {
            instance.bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:[[NSString alloc] initWithUTF8String:slotID?:""] rootViewController:GetAppController().rootViewController adSize:CGSizeMake(newWidth, newHeight) interval:30];
        } else {
            instance.bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:[[NSString alloc] initWithUTF8String:slotID?:""] rootViewController:GetAppController().rootViewController adSize:CGSizeMake(newWidth, newHeight)];
        }
        instance.bannerView.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-newHeight, newWidth, newHeight);
        instance.bannerView.delegate = instance;
        instance.onLoad = onLoad;
        instance.onLoadError = onLoadError;
        instance.loadContext = context;
        [instance.bannerView loadAdData];

        (__bridge_retained void*)instance;
    }

    void UnionPlatform_ExpressBannersAd_SetInteractionListener(
                                                        void* expressAdPtr,
                                                        ExpressAd_WillShow willShow,
                                                        ExpressAd_DidClick didClick,
                                                        ExpressAd_DidClose didClose,
                                                        int context) {

        ExpressBannerAd *expressBannerAd = (__bridge ExpressBannerAd*)expressAdPtr;
        expressBannerAd.willShow = willShow;
        expressBannerAd.didClick = didClick;
        expressBannerAd.didClose = didClose;
        expressBannerAd.listenContext = context;
    }

    void UnionPlatform_ExpressBannersAd_Show(void* expressAdPtr, float originX, float originY) {
        ExpressBannerAd *expressBannerAd = (__bridge ExpressBannerAd*)expressAdPtr;

        CGFloat newX = originX/[UIScreen mainScreen].scale;
        CGFloat newY = originY/[UIScreen mainScreen].scale;

        expressBannerAd.bannerView.frame = CGRectMake(newX, newY, expressBannerAd.bannerView.frame.size.width, expressBannerAd.bannerView.frame.size.height);

        [GetAppController().rootViewController.view addSubview:expressBannerAd.bannerView];
    }

    void UnionPlatform_ExpressBannerAd_Dispose(void* expressAdPtr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            (__bridge_transfer ExpressBannerAd*)expressAdPtr;
        });
    }

#if defined (__cplusplus)
}
#endif
