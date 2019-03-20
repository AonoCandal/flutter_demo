import 'package:flutter_demo/bloc/provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class PullToRefreshBloc extends BlocBase {
  PullToRefreshBloc() {
    _subject.listen((List<String> data) {});
    sink.add(_getDetail());
  }

  final PublishSubject<List<String>> _subject = PublishSubject<List<String>>();

  Observable<List<String>> get stream => _subject.stream;

  Sink<List<String>> get sink => _subject.sink;

  @override
  void dispose() {
    _subject.close();
  }

  List<String> _getDetail() {
    return [];
  }
}
