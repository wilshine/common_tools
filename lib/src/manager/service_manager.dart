
abstract class IService {

  /// 启动前初始化
  void beforeLaunch(){}

  /// 启动后初始化操作
  Future<void> afterLaunch() async {}
}

/// 获取具体Service
T? byService<T extends IService>() {
  return ServiceManager().getService<T>();
}

// byService<IAuth>()!.ensureLogin();




class ServiceManager {

  factory ServiceManager() => _getInstance ?? ServiceManager._();

  ServiceManager._();

  static ServiceManager? _getInstance;

  static final Map<String, dynamic> _singl = {};

  String _getKey(Type type) {
    return type.toString();
  }

  bool registerService(dynamic dependency) {
    String key = dependency.runtimeType.toString();
    _singl[key] = dependency;
    return true;
  }

  T getService<T>() {
    String key = _getKey(T);
    if(_singl.containsKey(key)) {
      return _singl[key];
    }
    throw 'no ${T.toString()}';
  }
}