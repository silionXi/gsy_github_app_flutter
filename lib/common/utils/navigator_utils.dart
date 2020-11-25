import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/router/anima_route.dart';
import 'package:gsy_github_app_flutter/page/code_detail_page_web.dart';
import 'package:gsy_github_app_flutter/page/common_list_page.dart';
import 'package:gsy_github_app_flutter/page/debug/debug_data_page.dart';
import 'package:gsy_github_app_flutter/page/gsy_webview.dart';
import 'package:gsy_github_app_flutter/page/home/home_page.dart';
import 'package:gsy_github_app_flutter/page/honor_list_page.dart';
import 'package:gsy_github_app_flutter/page/issue/issue_detail_page.dart';
import 'package:gsy_github_app_flutter/page/login/login_page.dart';
import 'package:gsy_github_app_flutter/page/login/login_webview.dart';
import 'package:gsy_github_app_flutter/page/notify_page.dart';
import 'package:gsy_github_app_flutter/page/trend/trend_user_page.dart';
import 'package:gsy_github_app_flutter/page/user/person_page.dart';
import 'package:gsy_github_app_flutter/page/photoview_page.dart';
import 'package:gsy_github_app_flutter/page/push/push_detail_page.dart';
import 'package:gsy_github_app_flutter/page/release/release_page.dart';
import 'package:gsy_github_app_flutter/page/repos/repository_detail_page.dart';
import 'package:gsy_github_app_flutter/page/search/search_page.dart';
import 'package:gsy_github_app_flutter/page/user_profile_page.dart';

/**
 * 导航栏
 * Created by guoshuyu
 * Date: 2018-07-16
 */
class NavigatorUtils {
  ///替换
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
//    if (navigator == null) {
//      try {
//        navigator = Navigator.of(context);
//      } catch (e) {
//        error = true;
//      }
//    }
//
//    if (replace) {
//      ///如果可以返回，清空开始，然后塞入
//      if (!error && navigator.canPop()) {
//        navigator.pushAndRemoveUntil(
//          router,
//          ModalRoute.withName('/'),
//        );
//      } else {
//        ///如果不可返回，直接替换当前
//        navigator.pushReplacement(router);
//      }
//    } else {
//      navigator.push(router);
//    }
  }

  ///切换无参数页面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName).then((value) => null);
  }

  /**
   * Flutter 中的页面跳转是通过 Navigator 实现的，且会返回一个 Future
   * 这个Future 的作用是在页面返回时被调用的。
   * 也就是你可以通过 Navigator 的 pop 时返回参数，
   * 之后在 Future 中可以的监听中处理页面的返回结果。
   *
   * 不带参数的路由表跳转：gotoPhotoViewPage(BuildContext context, String url)
   * Navigator.pushNamed(context, routeName);
   *
   * 跳转新页面并且替换，比如登录页跳转主页：goHome(BuildContext context)
   * Navigator.pushReplacementNamed(context, routeName);
   *
   * 跳转到新的路由，并且关闭给定路由的之前的所有页面：
   * Navigator.pushNamedAndRemoveUntil(context, '/calendar', ModalRoute.withName('/'));
   *
   * 带参数的路由跳转，并且监听返回：
   * Navigator.push(context, new MaterialPageRoute(builder: (context) => new NotifyPage())).then((res) {
   *     ///获取返回处理
   * });
   *
   * 新版本开始可以给 pushNamed 设置 arguments 参数，然后在新页面通过 ModalRoute.of(context).settings.arguments 获取。
   */
  ///主页
  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.sName);
  }

  ///登录页
  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.sName);
  }

  ///图片预览
  static gotoPhotoViewPage(BuildContext context, String url) {
    Navigator.pushNamed(context, PhotoViewPage.sName, arguments: url);
  }

  ///个人中心
  static goPerson(BuildContext context, String userName) {
    NavigatorRouter(context, new PersonPage(userName));
  }

  ///请求数据调试页面
  static goDebugDataPage(BuildContext context) {
    return NavigatorRouter(context, new DebugDataPage());
  }

  ///仓库详情
  static Future goReposDetail(
      BuildContext context, String userName, String reposName) {
    ///利用 SizeRoute 动画大小打开
    return Navigator.push(
        context,
        new SizeRoute(
            widget: pageContainer(
                RepositoryDetailPage(userName, reposName), context)));
  }

  ///荣耀列表
  static Future goHonorListPage(BuildContext context, List list) {
    return Navigator.push(context,
        new SizeRoute(widget: pageContainer(HonorListPage(list), context)));
  }

  ///仓库版本列表
  static Future goReleasePage(BuildContext context, String userName,
      String reposName, String releaseUrl, String tagUrl) {
    return NavigatorRouter(
        context,
        new ReleasePage(
          userName,
          reposName,
          releaseUrl,
          tagUrl,
        ));
  }

  ///issue详情
  static Future goIssueDetail(
      BuildContext context, String userName, String reposName, String num,
      {bool needRightLocalIcon = false}) {
    return NavigatorRouter(
        context,
        new IssueDetailPage(
          userName,
          reposName,
          num,
          needHomeIcon: needRightLocalIcon,
        ));
  }

  ///通用列表
  static gotoCommonList(
      BuildContext context, String title, String showType, String dataType,
      {String userName, String reposName}) {
    NavigatorRouter(
        context,
        new CommonListPage(
          title,
          showType,
          dataType,
          userName: userName,
          reposName: reposName,
        ));
  }

  ///仓库详情通知
  static Future goNotifyPage(BuildContext context) {
    return NavigatorRouter(context, new NotifyPage());
  }

  ///用户趋势
  static Future goTrendUserPage(BuildContext context) {
    return NavigatorRouter(context, new TrendUserPage());
  }

  ///搜索
  static Future goSearchPage(BuildContext context, Offset centerPosition) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Builder(builder: (BuildContext context) {
          return pageContainer(SearchPage(centerPosition), context);
        });
      },
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Color(0x01000000),
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
    );
  }

  ///提交详情
  static Future goPushDetailPage(BuildContext context, String userName,
      String reposName, String sha, bool needHomeIcon) {
    return NavigatorRouter(
        context,
        new PushDetailPage(
          sha,
          userName,
          reposName,
          needHomeIcon: needHomeIcon,
        ));
  }

  ///全屏Web页面
  static Future goGSYWebView(BuildContext context, String url, String title) {
    return NavigatorRouter(context, new GSYWebView(url, title));
  }

  ///登陆Web页面
  static Future goLoginWebView(BuildContext context, String url, String title) {
    return NavigatorRouter(context, new LoginWebView(url, title));
  }

  ///文件代码详情Web
  static gotoCodeDetailPageWeb(BuildContext context,
      {String title,
      String userName,
      String reposName,
      String path,
      String data,
      String branch,
      String htmlUrl}) {
    NavigatorRouter(
        context,
        new CodeDetailPageWeb(
          title: title,
          userName: userName,
          reposName: reposName,
          path: path,
          data: data,
          branch: branch,
          htmlUrl: htmlUrl,
        ));
  }

  ///根据平台跳转文件代码详情Web
  static gotoCodeDetailPlatform(BuildContext context,
      {String title,
      String userName,
      String reposName,
      String path,
      String data,
      String branch,
      String htmlUrl}) {
    NavigatorUtils.gotoCodeDetailPageWeb(
      context,
      title: title,
      reposName: reposName,
      userName: userName,
      data: data,
      path: path,
      branch: branch,
    );
  }

  ///用户配置
  static gotoUserProfileInfo(BuildContext context) {
    NavigatorRouter(context, new UserProfileInfo());
  }

  ///公共打开方式
  static NavigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => pageContainer(widget, context)));
  }

  ///Page页面的容器，做一次通用自定义
  static Widget pageContainer(widget, BuildContext context) {
    return MediaQuery(

        ///不受系统字体缩放影响
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: widget);
  }

  ///弹出 dialog
  static Future<T> showGSYDialog<T>({
    @required BuildContext context,
    bool barrierDismissible = true,
    WidgetBuilder builder,
  }) {
    return showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return MediaQuery(

              ///不受系统字体缩放影响
              data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .copyWith(textScaleFactor: 1),
              child: new SafeArea(child: builder(context)));
        });
  }
}
