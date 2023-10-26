import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pure_live/common/index.dart';
import 'package:pure_live/modules/areas/areas_page.dart';
import 'package:pure_live/modules/favorite/favorite_page.dart';
import 'package:pure_live/modules/home/mobile_view.dart';
import 'package:pure_live/modules/home/tablet_view.dart';
import 'package:pure_live/modules/about/widgets/version_dialog.dart';
import 'package:pure_live/modules/popular/popular_page.dart';
import '../search/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    // check update overlay ui
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        // Android statusbar and navigationbar
        if (Platform.isAndroid) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor:
                Theme.of(context).navigationBarTheme.backgroundColor,
          ));
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }
      },
    );
    addToOverlay();
  }

  int _selectedIndex = 0;
  final List<Widget> bodys = const [
    FavoritePage(),
    PopularPage(),
    AreasPage(),
    SearchPage(),
  ];

  void onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> addToOverlay() async {
    final overlay = Overlay.maybeOf(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Container(
        alignment: Alignment.center,
        color: Colors.black54,
        child: NewVersionDialog(entry: entry),
      ),
    );

    await VersionUtil.checkUpdate();
    bool isHasNerVersion =
        Get.find<SettingsService>().enableAutoCheckUpdate.value &&
            VersionUtil.hasNewVersion();
    if (mounted) {
      if (overlay != null && isHasNerVersion) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => overlay.insert(entry));
      } else {
        if (overlay != null && isHasNerVersion) {
          overlay.insert(entry);
        }
      }
    }
  }

  Future<bool> _onBackPressed() async {
    bool confirmExit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).exit_app),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(S.of(context).exit_yes),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // 取消退出
            },
            child: Text(S.of(context).exit_no),
          ),
        ],
      ),
    );
    return confirmExit;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: LayoutBuilder(
        builder: (context, constraint) => constraint.maxWidth <= 680
            ? HomeMobileView(
                body: bodys[_selectedIndex],
                index: _selectedIndex,
                onDestinationSelected: onDestinationSelected,
              )
            : HomeTabletView(
                body: bodys[_selectedIndex],
                index: _selectedIndex,
                onDestinationSelected: onDestinationSelected,
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
