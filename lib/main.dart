import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/app.dart';
import 'package:gsy_github_app_flutter/env/config_wrapper.dart';
import 'package:gsy_github_app_flutter/env/env_config.dart';
import 'package:gsy_github_app_flutter/page/error_page.dart';

import 'env/dev.dart';

void main() {
  runZoned(() {
    ErrorWidget.builder = (FlutterErrorDetails details) {/// 自定义builder方法，替换系统默认方法：framework#_defaultErrorWidgetBuilder
      Zone.current.handleUncaughtError(details.exception, details.stack);
      return ErrorPage(
          details.exception.toString() + "\n " + details.stack.toString(), details);
    };
    runApp(ConfigWrapper(
      child: FlutterReduxApp(),
      config: EnvConfig.fromJson(config),/// 'env/dev.dart'
    ));
  }, onError: (Object obj, StackTrace stack) {
    /**
     * onError：Zone中未捕获异常处理回调，
     * 如果开发者提供了onError回调或者通过ZoneSpecification.handleUncaughtError指定了错误处理回调，
     * 那么这个zone将会变成一个error-zone，
     * 该error-zone中发生 未捕获 异常(无论同步还是异步)时都会调用开发者提供的回调
     * 被捕获的异常要通过自定义{@link FlutterError#onError}
     */
    print(obj);
    print(stack);
  }/*, zoneSpecification : new ZoneSpecification(print: (Zone self, ZoneDelegate parent, Zone zone, String line) => {
      /// 添加这个，APP中所有调用print方法输出日志的行为都会被拦截
  })*/);
}
