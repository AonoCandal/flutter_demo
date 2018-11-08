abstract class NotifyListener {
  void onUpdate(String name, dynamic object);
}

class NotifyManager {
  static final NotifyManager _instance = new NotifyManager.internal();

  Map<String, List<NotifyListener>> _subscriberMap;

  factory NotifyManager() {
    return _instance;
  }

  NotifyManager.internal() {
    _subscriberMap = Map<String, List<NotifyListener>>();
  }

  static NotifyManager getInstance() {
    return _instance;
  }

  void addListener(String name, NotifyListener listener) {
    List<NotifyListener> list = _subscriberMap[name];
    if (list == null) {
      list = new List<NotifyListener>();
    }

    list.forEach((NotifyListener s) {
      if (s == listener) {
        return;
      }
    });

    list.add(listener);
    _subscriberMap[name] = list;
  }

  void removeListener(NotifyListener listener, {String name}) {
    if (name == null) {
      _subscriberMap.forEach((_, list) {
        _removeSpecifiedListener(listener, list);
      });
    } else {
      List<NotifyListener> list = _subscriberMap[name];
      if (list == null || list.length == 0) {
        return;
      }

      _removeSpecifiedListener(listener, list);
    }
  }

  void _removeSpecifiedListener(
      NotifyListener listener, List<NotifyListener> list) {
    for (var l in list) {
      if (l == listener) {
        list.remove(l);
        break;
      }
    }
  }

  void notifyChange(String name, {dynamic object}) {
    List<NotifyListener> list = _subscriberMap[name];
    if (list == null) {
      return;
    }

    list.forEach((listener) => listener.onUpdate(name, object));
  }
}
