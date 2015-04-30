
(Macro) 这个目录下放了整个应用会用到的宏定义，里面大概是这样：

    Macro
    |- AppMacro.h               (APP相关的宏定义)
    |- AppServerMacro.h         (服务接口定义宏)
    |- Macro.h                  (统一入口宏)
    |- UtilsMacro.h             (通用宏)
    ...


(Models) 这个目录下放一些与数据相关的Model文件，里面大概是这样：

    Models
    |- BaseModel.h
    |- BaseModel.m
    |- CollectionModel.h
    |- CollectionModel.m
    ...


(General) 这个目录放会被重用的Views/Classes和Categories。里面大概是这样：

    General
    |- Views                    (自定义公共view)
    |- TPKScollView
    |- TPKPullToRefresh
    ...
    |- Classes                  (公共VC)
    |- BaseViewController
    |- BaseNavigationViewController
    ...
    | - Categories              (类别、类扩展)
    |- UIView+Utils
    |- NSString+Utils
    ...

(Networking) 网络请求基本封装

    Networking
    |-RequestManager            (请求管理对象)
    |-BaseRequestOperator       (基本请求，get,post,图片上传,多请求)

(Helpers) 这个目录放一些助手类，文件名与功能挂钩。里面大概是这样：

    Helpers
    |- BaseHelper               (基类)
    |- TPKShareHelper
    |- TPDBHelper
    |- TPKEmotionHelper
    ...
    助手类的主要作用是帮助Controller瘦身，也可以提供一定程度的复用。

(Vendors) 这个目录放第三方的类库/SDK，如UMeng、WeiboSDK、WeixinSDK等等。

(Sections) 这个目录下面的文件对应的是app的具体单元，如导航、瀑布流等等。里面大概是这样：

    Sections
    |- Menu
    |- Setting
    |- Collection
    ...

(Images.xcassets) 图片资源