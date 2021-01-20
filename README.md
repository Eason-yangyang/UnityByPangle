![Pangle logo](https://sf16-scmcdn-sg.ibytedtos.com/obj/goofy-sg/ad/pangle/homepage/_next/static/assets/images/pangle-text.491fcc7f.svg)

# UnityByPangle  


# Tips:
* The example is for **iOS** only.   
* The example class for the SDK is  `public sealed class Example : MonoBehaviour`  

## Getting Started
* add **PangleSDK.unitypackage** to Unity project
* add **PangleAdapterScripts.unitypackage** to Unity project
* it was Pangle's SDK and Adapter files, so you must set them **import settings**->**Select platforms for plugin** to **Any platform** or **iOS**
* before get ads, you should call **`setAppID:`** method which in **BUAdSDKManager** class.
	* If you also need to set other Settings, you must set them before **`setAddId:	`**, such as **`setSpaidApp:`**
	* We recommend that you set it in the **`application:didFinishLaunchingWithOptions:`** method of the **custom AppController**. 
	
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [super application:application didFinishLaunchingWithOptions:launchOptions];

    [BUAdSDKManager setAppID: @"5000546"];
    return YES;
}
```
	

## CreatAdNative


```c#
private AdNative adNative;
```
```c#
private AdNative AdNative
{
    get
    {
        if (this.adNative == null)
        {
            this.adNative = SDK.CreateAdNative();
        }
        return this.adNative;
    }
}

```


## FullscreenVideo Ad 

### Load Advertisement

* `this` is Example class instance.  

```c#
private FullScreenVideoAd fullScreenVideoAd;
```
```c#
public void LoadFullScreenVideoAd()
{
    var rit = "900546299";
    
    var adSlot = new AdSlot.Builder()
        .SetCodeId(rit)
        .Build();
        
    this.AdNative.LoadFullScreenVideoAd(adSlot, new FullScreenVideoAdListener(this));
}
```

### FullScreenVideoAdListener

* you can get the load status With FullScreenVideoAdListener.  
* `this.example` is the sample object holding fullScreenVideoAd.  
* `OnFullScreenVideoAdLoad ` you can get fullScreenVideoAd object in this method.   

```c#
private sealed class FullScreenVideoAdListener : IFullScreenVideoAdListener
{
    private Example example;
    
    public FullScreenVideoAdListener(Example example)
    {
        this.example = example;
    }
    
    public void OnError(int code, string message) { }
    
    public void OnFullScreenVideoAdLoad(FullScreenVideoAd ad)
    {
	this.example.fullScreenVideoAd = ad;

	/// add FullScreenAdInteractionListener
	ad.SetFullScreenVideoAdInteractionListener(new FullScreenAdInteractionListener(this.example));
	/// show ad
	ad.ShowFullScreenVideoAd();
    }
    
    public void OnFullScreenVideoCached() { }
}
```


### FullScreenAdInteractionListener

* You can get a series of events about the user's action

```c#
private sealed class FullScreenAdInteractionListener : IFullScreenVideoAdInteractionListener
{
	private Example example;
	public FullScreenAdInteractionListener(Example example)
	{
	    this.example = example;
	}
	public void OnAdShow() {}
	public void OnAdVideoBarClick() {}
	public void OnAdClose() {}
	public void OnVideoComplete() {}
	public void OnVideoError() {}
	public void OnSkippedVideo() {}
}
```

### Destroy Object
```c#
	this.fullScreenVideoAd.Dispose();
	this.fullScreenVideoAd = null;
```

  

## RewardVideo Ad 

### Load Advertisement

* `this` is Example class instance. 

```c#
private RewardVideoAd rewardAd;
```
```c#
public void LoadRewardAd()
{
    var rit = "900546826";

    var adSlot = new AdSlot.Builder()
        .SetCodeId(rit)
        .SetMediaExtra("Optional - Example Extra Data")
        .Build();

    this.AdNative.LoadRewardVideoAd(adSlot, new RewardVideoAdListener(this));
}
```

### RewardVideoAdListener

* you can get the load status With RewardVideoAdListener.  
* `this.example` is the sample object holding rewardAd.  
* `OnRewardVideoAdLoad ` you can get rewardAd object in this method.   

```c#
private sealed class RewardVideoAdListener : IRewardVideoAdListener
{
    private Example example;
    public RewardVideoAdListener(Example example)
    {
    	this.example = example;
    }
    
    public void OnError(int code, string message){ }
    
    public void OnRewardVideoAdLoad(RewardVideoAd ad)
    {
	this.example.rewardAd = ad;
	///RewardAdInteractionListener
	ad.SetRewardAdInteractionListener(new RewardAdInteractionListener(this.example));
	///show ad
	this.rewardAd.ShowRewardVideoAd();
    }
    
    public void OnRewardVideoCached() {}
}
```


### RewardAdInteractionListener

* You can get a series of events about the user's action

```c#
private sealed class RewardAdInteractionListener : IRewardAdInteractionListener
{
    private Example example;
    public RewardAdInteractionListener(Example example)
    {
        this.example = example;
    }

    public void OnAdShow() {}
    public void OnAdVideoBarClick() {}
    public void OnAdClose() {}
    public void OnVideoComplete() {}
    public void OnVideoError() {}
    public void OnRewardVerify(bool rewardVerify, int rewardAmount, string rewardName) {}
}
```

### Destroy Object
```c#
	this.rewardAd.Dispose();
	this.rewardAd = null;
```


## PangleTools

`PangleTools` allows you to get the screen `scale` `height`, `width`, and **safeAreaInsets** `up`, `down`, `left` and `right` of **window**. (  the unit of value is **pixel**. )
### PangleTools method list
* `getScreenScale()`
* `getScreenWidth()` 
* `getScreenHeight()`
* `getWindowSafeAreaInsetsTop()`
* `getWindowSafeAreaInsetsLeft()`
* `getWindowSafeAreaInsetsBottom()`
* `getWindowSafeAreaInsetsRight()`


## Banner Ad

### Load Advertisement

* `this` is Example class instance.   

```c#
private ExpressBannerAd bannerAd;
```

```c#
public void LoadBannerAd()
{
    var rit = "900546833";
    float expressWidth = 320;
    float expressHeight = 250;

    var adSlot = new AdSlot.Builder()
                             .SetCodeId(ritID)
                             .SetExpressViewAcceptedSize(expressWidth, expressHeight)
                             .Build();
    this.AdNative.LoadExpressBannerAd(adSlot, new ExpressAdListener(this, 1));
}
```

### ExpressAdListener

* you can get the load status With ExpressAdListener.  
* `this.example` is the sample object holding bannerAd.  
* `OnExpressAdLoad ` you can get bannerAd object in this method.   

```c#
private sealed class ExpressAdListener : IExpressAdListener
{
	private Example example;
	private int type;//0:feed   1:banner  2:interstitial

	public ExpressAdListener(Example example, int type)
	{
		this.example = example;
		this.type = type;
	}

	public void OnExpressBannerAdLoad(ExpressBannerAd ad)
	{
		this.example.bannerAd = ad;
		ad.SetExpressInteractionListener(new ExpressAdInteractionListener(this.example,1));

		///show ad
		float x = PangleTools. getWindowSafeAreaInsetsLeft();
		float y = PangleTools. getWindowSafeAreaInsetsTop();
		this.bannerAd.ShowExpressAd(x, y);
	}

	public void OnError(int code, string message) { }
}
```


### ExpressAdInteractionListener

* You can get a series of events about the user's action

```c#
private sealed class ExpressAdInteractionListener : IExpressAdInteractionListener
{
	private Example example;
	int type;//0:feed   1:banner  2:interstitial
	
	public ExpressAdInteractionListener(Example example, int type)
	{
		this.example = example;
		this.type = type;
	}
	
	public void OnAdClicked(ExpressAd ad) { }
	public void OnAdShow(ExpressAd ad) { }
	public void OnAdClose(ExpressAd ad) { }
}
```

### Destroy Object
```c#
	this.bannerAd.Dispose();
	this.bannerAd = null;
```

## Native Ad

### Load Advertisement

* `this` is Example class instance.   

```c#
private NativeAd nativeFeedAd;
```

```c#
public void LoadNativeAd()
{

    var adSlot = new AdSlot.Builder()
        .SetCodeId("900546910")
        .SetNativeAdType(AdSlotType.Feed)
        .SetImageAcceptedSize(600, 400)
        .SetAdCount(1)
        .Build();
    this.AdNative.LoadNativeAd(adSlot, new NativeAdListener(this));
}
```

### NativeAdListener

* you can get the load status With NativeAdListener.  
* `this.example` is the sample object holding nativeAd.  
* `OnNativeAdLoad ` you can get nativeAd object in this method. 
* you can customize the view in NativeAd.mm file at`buildupViewFeed` method

```c#
 private sealed class NativeAdListener : INativeAdListener
{
	private Example example;
	
	public NativeAdListener(Example example)
	{
	    this.example = example;
	}
	
	public void OnError(int code, string message) { }
	
	public void OnNativeAdLoad(AndroidJavaObject list,NativeAd ad)
	{
	    if (ad.GetAdType() == AdSlotType.Feed)
	    {
	        this.example.nativeFeedAd = ad;
	        ad.SetNativeAdInteractionListener(new NativeAdInteractionListener(this.example));
	        this.nativeFeedAd.ShowNativeAd(AdSlotType.Feed);
	    }
	}
}
```


### NativeAdInteractionListener

* You can get a series of events about the user's action

```c#
private sealed class NativeAdInteractionListener : IInteractionAdInteractionListener
{
    private Example example;

    public NativeAdInteractionListener(Example example)
    {
        this.example = example;
    }

    public void OnAdShow() { } 
    public void OnAdClicked() { } 
    public void OnAdDismiss() { }
}
```

### Destroy Object
```c#
	this.nativeFeedAd.Dispose();
	this.nativeFeedAd = null;
```

