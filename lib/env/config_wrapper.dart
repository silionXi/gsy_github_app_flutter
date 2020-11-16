import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/config/config.dart';
import 'package:gsy_github_app_flutter/env/env_config.dart';

///往下共享环境配置
class ConfigWrapper extends StatelessWidget {
  /**
   * Dart中，只能有一个非命名构造函数（默认构造函数），如果不声明构造函数，则提供默认的无参构造
   * 如果要申明多个构造函数，通过命名构造函数，例如：ConfigWrapper.name(this.config, this.child, {Key key})
   * 子类会默认调用（非继承）父类的无参构造（只有可选参数，按无参处理？），如果父类申明了带参构造，需要通过:super指定调用
   * 构造函数重定向: ConfigWrapper.withChild(EnvConfig config) : this(config: config, child: MaterialApp());
   * 工厂构造函数：实现构造函数时使用factory关键字（可以返回对象的构造函数）
   */
  ConfigWrapper({Key key, this.config, this.child});

//  ConfigWrapper(this.config, this.child);
//  ConfigWrapper.withConfig(EnvConfig config) : this(config: config, child: MaterialApp());

  @override
  Widget build(BuildContext context) {
    ///设置 Config.DEBUG 的静态变量
    Config.DEBUG = this.config.debug;
    print("ConfigWrapper build ${Config.DEBUG}");
    return new _InheritedConfig(config: this.config, child: this.child);
  }

  static EnvConfig of(BuildContext context) {
    final _InheritedConfig inheritedConfig =
    context.dependOnInheritedWidgetOfExactType<_InheritedConfig>();
    return inheritedConfig.config;
  }

  final EnvConfig config;

  final Widget child;
}


class _InheritedConfig extends InheritedWidget {
  const _InheritedConfig(
      {Key key, @required this.config, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  final EnvConfig config;

  @override
  bool updateShouldNotify(_InheritedConfig oldWidget) =>
      config != oldWidget.config;
}