# flutter_demo

Flutter 应用Demo

## Getting Started

#### 模块

- myhomePage
  
  无用小组件, 请无视

- lifeCycle

  生命周期组件, 其中有自定义的一种Dialog 弹窗
  
- calendar

  日历组件, 由网上大神改造的自定义Dialog
  
- ListinList

  List 嵌套组件
  
- ProgressDialog

  仿IOS加载控件, 可以转菊花, 或者转其他东西, 可以显示状态及文字
  
- EmptyView

  EmptyView实现
  实现六种状态:
  1. 加载(卡车)
  2. 加载(placeHolder)
  3. 空页面
  4. 无网络
  5. 报错
  6. 正常页面加载

  其中"空页面" & "无网络"的判断可以给使用者自己去定夺

  可以实现嵌套列表, 详情页等实现

  页面body构建逻辑解耦, 由页面提供, 不会造成接口重复加载

  满足页面刷新条件
