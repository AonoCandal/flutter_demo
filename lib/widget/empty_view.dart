import 'package:flutter/material.dart';

const Color _kDefaultPlaceHolderColor = Color(0xfff5f5f5);
const IconData loading = IconData(0xe602, fontFamily: 'EmptyViewIcon');

typedef Future<T> FutureFunction<T>();
typedef Widget EmptyBuildBody(dynamic data);
typedef bool EmptyJudge(dynamic data);

class EmptyView<T> extends StatefulWidget {
  final FutureFunction<T> future;
  final EmptyController controller;
  final EmptyBuildBody buildBody;
  final EmptyJudge emptyJudge;
  final EmptyJudge netWorkErrorJudge;
  final bool usePlaceHolder;

  EmptyView({
    @required this.future,
    @required this.buildBody,
    this.controller,
    this.emptyJudge,
    this.usePlaceHolder = false,
    this.netWorkErrorJudge,
  });

  @override
  State<StatefulWidget> createState() {
    return EmptyViewState();
  }
}

class EmptyViewState<T> extends State<EmptyView<T>>
    implements EmptyStatusListener {
  bool ignoreSnapshot = false;
  Future<T> _future;

  EmptyController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? EmptyController();
    _controller.registerListener(this);
    _future = widget.future();
  }

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilder();
  }

  FutureBuilder buildFutureBuilder() {
    return FutureBuilder<T>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          if (!ignoreSnapshot) {
            if (snapshot.hasError) {
              if (widget.netWorkErrorJudge(snapshot.error)) {
                _controller.status = Status.netWorkError;
              } else {
                _controller.status = Status.error;
              }
            } else if (snapshot.hasData) {
              if ((widget.emptyJudge != null &&
                      widget.emptyJudge(snapshot.data)) ||
                  (snapshot.data is List &&
                      (snapshot.data as List).length == 0)) {
                _controller.status = Status.noData;
              } else {
                _controller.status = Status.complete;
              }
            } else if (widget.usePlaceHolder) {
              _controller.status = Status.placeHolder;
            } else {
              _controller.status = Status.loading;
            }
          }
          ignoreSnapshot = false;

          switch (_controller.status) {
            case Status.loading:
              return _loadingView();
            case Status.placeHolder:
              return _placeHolderView();
            case Status.netWorkError:
              return _netWorkErrorView();
            case Status.error:
              return _errorView();
            case Status.noData:
              return _emptyView();
            case Status.complete:
              return widget.buildBody(snapshot.data);
          }
        });
  }

  Widget _errorView() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(child: Container(), flex: 2),
          Image.asset(
            'images/icon_load_error.png',
            height: 125.0,
            width: 125.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 21.0),
            child: Text(
              '抱歉…页面加载失败',
              style: TextStyle(fontSize: 14.0, color: Color(0xff92979E)),
            ),
          ),
          Container(
            height: 28.0,
            width: 80.0,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffF6A500)),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: FlatButton(
                padding: EdgeInsets.all(0.0),
                onPressed: _retry,
                child: Text(
                  '刷新重试',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xffF6A500),
                  ),
                )),
          ),
          Expanded(child: Container(), flex: 5),
        ],
      ),
    );
  }

  Widget _netWorkErrorView() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(child: Container(), flex: 2),
          Image.asset(
            'images/icon_no_network.png',
            height: 125.0,
            width: 125.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 21.0),
            child: Text(
              '哎呀，网络出问题了...',
              style: TextStyle(fontSize: 14.0, color: Color(0xff92979E)),
            ),
          ),
          Container(
            height: 28.0,
            width: 80.0,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffF6A500)),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: FlatButton(
                padding: EdgeInsets.all(0.0),
                onPressed: _retry,
                child: Text(
                  '刷新重试',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xffF6A500),
                  ),
                )),
          ),
          Expanded(child: Container(), flex: 5),
        ],
      ),
    );
  }

  Widget _emptyView() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(child: Container(), flex: 2),
          Image.asset(
            'images/icon_no_data.png',
            height: 125.0,
            width: 125.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 21.0),
            child: Text(
              '哎呀，里面没有内容…',
              style: TextStyle(fontSize: 14.0, color: Color(0xff92979E)),
            ),
          ),
          Container(
            height: 28.0,
            width: 80.0,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffF6A500)),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: FlatButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  '返回上页',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xffF6A500),
                  ),
                )),
          ),
          Expanded(child: Container(), flex: 5),
        ],
      ),
    );
  }

  Widget _loadingView() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(child: Container(), flex: 2),
          Image.asset(
            'images/icon_loading.png',
            width: 60,
            height: 31,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              '正在疯狂加载...',
              style: TextStyle(fontSize: 16.0, color: Color(0xff333333)),
            ),
          ),
          Expanded(child: Container(), flex: 5),
        ],
      ),
    );
  }

  Widget _placeHolderView() {
    _controller.status = Status.loading;
    return new _PlaceHolderWidget();
  }

  @override
  notifyStatus() {
    setState(() {
      ignoreSnapshot = true;
    });
  }

  _retry() {
    _controller.changeStatus(
        widget.usePlaceHolder ? Status.placeHolder : Status.loading);
    widget.future();
  }
}

enum Status { loading, placeHolder, noData, error, netWorkError, complete }

class EmptyController {
  Status status = Status.loading;

  EmptyStatusListener listener;

  changeStatus(Status status) {
    if (status != null && status is Status) {
      this.status = status;
      if (listener != null) {
        listener.notifyStatus();
      }
    }
  }

  registerListener(EmptyStatusListener listener) {
    this.listener = listener;
  }
}

mixin EmptyStatusListener {
  notifyStatus();
}

class _PlaceHolderWidget extends StatelessWidget {
  const _PlaceHolderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 64.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 64.0,
                  width: 64.0,
                  decoration: BoxDecoration(
                      color: _kDefaultPlaceHolderColor,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                ),
                Container(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 16.0,
                        width: 150.0,
                        color: _kDefaultPlaceHolderColor,
                      ),
                      Container(height: 14.0),
                      Container(
                        height: 13.0,
                        width: 80.0,
                        color: _kDefaultPlaceHolderColor,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Expanded(child: Container()),
                    Container(
                      height: 20.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                          color: _kDefaultPlaceHolderColor,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 12.0),
            child: Container(
              color: _kDefaultPlaceHolderColor,
              height: 16.0,
            ),
          ),
          Container(
            color: _kDefaultPlaceHolderColor,
            height: 16.0,
            width: 64.0,
          ),
          Container(height: 64.0),
          Container(
            color: _kDefaultPlaceHolderColor,
            height: 14.0,
          ),
          Container(height: 12.0),
          Container(
            color: _kDefaultPlaceHolderColor,
            height: 14.0,
          ),
          Container(height: 12.0),
          Container(
            color: _kDefaultPlaceHolderColor,
            height: 14.0,
            width: 185.0,
          ),
          Container(height: 12.0),
          Container(
            color: _kDefaultPlaceHolderColor,
            height: 14.0,
          ),
          Container(height: 40.0),
          Expanded(
            child: Container(
              color: _kDefaultPlaceHolderColor,
            ),
          ),
          Container(height: 16.0),
          Expanded(
            child: Container(
              color: _kDefaultPlaceHolderColor,
            ),
          ),
        ],
      ),
    );
  }
}
