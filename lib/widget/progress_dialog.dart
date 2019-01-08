import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _kTwoPI = math.pi * 2.0;
const int _kTickCount = 8;
const int _kHalfTickCount = _kTickCount ~/ 2;
const Color _kTickColor = CupertinoColors.lightBackgroundGray;
const Color _kActiveTickColor = Color(0xFF9D9D9D);
const double _kDefaultIndicatorRadius = 10.0;

/// 默认弹窗背景颜色 灰
const Color _kDefaultBgColor = Color(0xE6333333);

/// 默认Icon大小
const double kDefaultIconSize = 28.0;

/// 默认弹窗边长
const double _kDefaultSideLength = 91.0;

/// 默认加载文案
const String _kDefaultLoadingText = '正在加载';

/// 默认加载文案style
const TextStyle _kDefaultLoadingTextStyle =
    TextStyle(color: Colors.white, fontSize: 15.0);

class ProgressDialog {
  /// 显示正在加载弹窗
  static showProgressDialog({
    @required BuildContext context,
    @required Future future, // 可执行的异步事件处理 (Futura处理完毕后自动退出弹窗)
    String loadingText = _kDefaultLoadingText, // 加载文案
    TextStyle loadingTextStyle = _kDefaultLoadingTextStyle, // 加载文案style
  }) {
    showStateDialog(
        context: context,
        future: future,
        loadingText: loadingText,
        barrierDismissible: false,
        loadingTextStyle: loadingTextStyle);
  }

  static showSuccessDialog({
    @required BuildContext context,
    String loadingText = '加载成功',
  }) {
    showStateDialog(
        context: context,
        loadingText: loadingText,
        icon: Icon(
          Icons.check_circle_outline,
          size: kDefaultIconSize,
          color: Colors.white,
        ));
  }

  static showFailDialog({
    @required BuildContext context,
    String loadingText = '加载失败',
  }) {
    showStateDialog(
        context: context,
        loadingText: loadingText,
        icon: Icon(
          Icons.highlight_off,
          size: kDefaultIconSize,
          color: Colors.white,
        ));
  }

  /// 显示状态弹窗
  static showStateDialog({
    @required BuildContext context,
    Future future, // 可执行的异步事件处理 (Futura处理完毕后自动退出弹窗)
    Color bgColor = _kDefaultBgColor, // 弹窗的背景颜色
    String loadingText = _kDefaultLoadingText, // 加载文案
    TextStyle loadingTextStyle = _kDefaultLoadingTextStyle, // 加载文案style
    double iconSize = kDefaultIconSize, // 图标大小
    Widget icon, // 图标 (默认为菊花)
    double sideLength = _kDefaultSideLength, // 弹框边长
    bool barrierDismissible = true, // 点击空白区域是否消失
    Color barrierColor, // 阴影颜色
  }) {
    // 弹窗是否已经弹出过
    bool hasPopped = false;
    Route route = _DialogRoute(
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
        final Widget pageChild = Builder(builder: (BuildContext context) {
          return ProgressCenterContent(
            bgColor: bgColor,
            loadingText: loadingText,
            loadingTextStyle: loadingTextStyle,
            iconSize: iconSize,
            icon: icon,
            sideLength: sideLength,
          );
        });
        return WillPopScope(
          onWillPop: () {
            hasPopped = true;
            return Future.value(true);
          },
          child: SafeArea(
            child: Builder(builder: (BuildContext context) {
              return theme != null
                  ? Theme(data: theme, child: pageChild)
                  : pageChild;
            }),
          ),
        );
      },
    );
    Navigator.of(context, rootNavigator: true).push(route);
    (future ?? Future.delayed(Duration(seconds: 2))).whenComplete(() {
      if (!hasPopped) {
        Navigator.of(context).removeRoute(route);
      }
    });
  }

  static Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}

class ProgressCenterContent extends StatefulWidget {
  final Color bgColor;
  final String loadingText;
  final TextStyle loadingTextStyle;
  final double iconSize;
  final Widget icon;
  final double sideLength;

  const ProgressCenterContent({
    Key key,
    this.bgColor,
    this.loadingText,
    this.loadingTextStyle,
    this.iconSize,
    this.icon,
    this.sideLength,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProgressCenterContentState();
  }
}

class ProgressCenterContentState extends State<ProgressCenterContent>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: widget.sideLength,
        width: widget.sideLength,
        decoration: BoxDecoration(
            color: widget.bgColor, borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: widget.iconSize,
              width: widget.iconSize,
              child: widget.icon == null
                  ? CustomPaint(
                      painter: _CupertinoActivityIndicatorPainter(
                        position: _controller,
                        radius: widget.iconSize / 2,
                      ),
                    )
                  : widget.icon,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  widget.loadingText ?? _kDefaultLoadingText,
                  style: _kDefaultLoadingTextStyle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// 菊花画笔
class _CupertinoActivityIndicatorPainter extends CustomPainter {
  _CupertinoActivityIndicatorPainter({
    this.position,
    double radius,
  })  : tickFundamentalRRect = RRect.fromLTRBXY(
            -radius,
            1.0 * radius / _kDefaultIndicatorRadius,
            -radius / 2.0,
            -1.0 * radius / _kDefaultIndicatorRadius,
            1.0,
            1.0),
        super(repaint: position);

  final Animation<double> position;
  final RRect tickFundamentalRRect;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (_kTickCount * position.value).floor();

    for (int i = 0; i < _kTickCount; ++i) {
      final double t =
          (((i + activeTick) % _kTickCount) / _kHalfTickCount).clamp(0.0, 1.0);
      paint.color = Color.lerp(_kActiveTickColor, _kTickColor, t);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(-_kTwoPI / _kTickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CupertinoActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position;
  }
}

/// 弹窗Route
class _DialogRoute<T> extends PopupRoute<T> {
  _DialogRoute({
    @required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    String barrierLabel,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder transitionBuilder,
    RouteSettings settings,
  })  : assert(barrierDismissible != null),
        _pageBuilder = pageBuilder,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        _transitionBuilder = transitionBuilder,
        super(settings: settings);

  final RoutePageBuilder _pageBuilder;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String get barrierLabel => _barrierLabel;
  final String _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  final RouteTransitionsBuilder _transitionBuilder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
      child: _pageBuilder(context, animation, secondaryAnimation),
      scopesRoute: true,
      explicitChildNodes: true,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (_transitionBuilder == null) {
      return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.linear,
          ),
          child: child);
    } // Some default transition
    return _transitionBuilder(context, animation, secondaryAnimation, child);
  }
}
