import 'package:json_annotation/json_annotation.dart';

part 'dev.g.dart';

/**
 * @see https://flutterchina.club/json/
 *
 * json_annotation 插件实现json序列化和反序列化
 * 复制创建 dev.dart 和 env_config.dart 文件（忽略报错）
 * 运行命令：flutter packages pub run build_runner build
 * 自动生成 dev.g.dart 和 env_config.g.dart
 * part 'dev.g.dart'; 和 part of 'dev.dart'; 表示 dev.g 是 dev 的一部分？
 */
@JsonLiteral('env_json_dev.json', asConst: true)
Map<String, dynamic> get config => _$configJsonLiteral;