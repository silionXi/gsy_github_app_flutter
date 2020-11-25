import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/widget/gsy_tabs.dart' as GSYTab;

///支持顶部和顶部的TabBar控件
///配合AutomaticKeepAliveClientMixin可以keep住，dynamic_page.dart DynamicPageState
class GSYTabBarWidget extends StatefulWidget {
  final TabType type;

  final bool resizeToAvoidBottomPadding;

  final List<Widget> tabItems;

  final List<Widget> tabViews;

  final Color backgroundColor;

  final Color indicatorColor;

  final Widget title;

  final Widget drawer;

  final Widget floatingActionButton;

  final FloatingActionButtonLocation floatingActionButtonLocation;

  final Widget bottomBar;

  final List<Widget> footerButtons;

  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onDoublePress;
  final ValueChanged<int> onSinglePress;

  GSYTabBarWidget({
    Key key,
    this.type = TabType.top,
    this.tabItems,
    this.tabViews,
    this.backgroundColor,
    this.indicatorColor,
    this.title,
    this.drawer,
    this.bottomBar,
    this.onDoublePress,
    this.onSinglePress,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.resizeToAvoidBottomPadding = true,
    this.footerButtons,
    this.onPageChanged,
  }) : super(key: key);

  @override
  _GSYTabBarState createState() => new _GSYTabBarState();
}

class _GSYTabBarState extends State<GSYTabBarWidget>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  TabController _tabController;

  int _index = 0;

  @override
  void initState() {
    super.initState();
    ///初始化时创建控制器
    ///通过 with SingleTickerProviderStateMixin 实现动画效果。(TickerProvider vsync)
    _tabController = new TabController(vsync: this, length: widget.tabItems.length);
  }

  ///整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    ///页面销毁时，销毁控制器
    _tabController.dispose();
    super.dispose();
  }

  _navigationPageChanged(index) {
    if (_index == index) {
      return;
    }
    _index = index;
    //手动左右滑动 PageView 时，通过 onPageChanged 回调调用 _tabController.animateTo(index); 同步TabBar状态。
    _tabController.animateTo(index);
    widget.onPageChanged?.call(index);///回调？
  }

  _navigationTapClick(index) {
    if (_index == index) {
      return;
    }
    _index = index;
    widget.onPageChanged?.call(index);//回调？

    ///不想要动画
    _pageController.jumpTo(MediaQuery.of(context).size.width * index);
    widget.onSinglePress?.call(index);
  }

  _navigationDoubleTapClick(index) {
    _navigationTapClick(index);
    widget.onDoublePress?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == TabType.top) {
      ///顶部tab bar：顶部tab是放在 AppBar 的 bottom 中，也就是标题栏之下
      return new Scaffold(
        resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
        floatingActionButton:
            SafeArea(child: widget.floatingActionButton ?? Container()),//设置悬浮按键，不需要可以不设置
        floatingActionButtonLocation: widget.floatingActionButtonLocation,//悬浮按键位置？
        persistentFooterButtons: widget.footerButtons,
        appBar: new AppBar(//标题栏
          backgroundColor: Theme.of(context).primaryColor,
          title: widget.title,
          bottom: new TabBar(//tabBar控件
              isScrollable: true,//顶部时，tabBar为可以滑动的模式
              controller: _tabController,//必须有的控制器，与pageView的控制器同步
              tabs: widget.tabItems,//每一个tab item，是一个List<Widget>
              indicatorColor: widget.indicatorColor,//tab选中指示条颜色
              onTap: _navigationTapClick),
        ),
        body: new PageView(//页面主体，PageView，用于承载Tab对应的页面
          controller: _pageController,//必须有的控制器，与tabBar的控制器同步
          children: widget.tabViews,//每一个 tab 对应的页面主体，是一个List<Widget>
          onPageChanged: _navigationPageChanged,//页面滑动回调，用于同步tab选中状态
        ),
        bottomNavigationBar: widget.bottomBar,
      );
    }

    ///底部tab bar：底部tab是放在了 Scaffold 的 bottomNavigationBar 中
    return new Scaffold(
        drawer: widget.drawer,//设置侧边滑出 drawer，不需要可以不设置
        appBar: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: widget.title,
        ),
        body: new PageView(//页面主体，PageView，用于承载Tab对应的页面
          controller: _pageController,///页面控制器，必须有的，与tabBar的控制器_tabController实现同步
          children: widget.tabViews,//每一个 tab 对应的页面主体，是一个List<Widget>
          onPageChanged: _navigationPageChanged,//页面触摸作用滑动回调，用于同步tab选中状态等
        ),
        bottomNavigationBar: new Material(
          //为了适配主题风格，包一层Material实现风格套用
          color: Theme.of(context).primaryColor, //底部导航栏主题颜色
          child: new SafeArea(
            child: new GSYTab.TabBar(
              //TabBar导航标签，底部导航放到Scaffold的bottomNavigationBar中
              controller: _tabController,///tab控制器，必须有的，与PageView的控制器_pageController实现同步
              //配置控制器
              tabs: widget.tabItems,
              indicatorColor: widget.indicatorColor,
              onDoubleTap: _navigationDoubleTapClick,//双击
              onTap: _navigationTapClick, //点击，用于同步tab标签的下划线颜色
            ),
          ),
        ));
  }
}

enum TabType { top, bottom }
