import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:pure_live/common/index.dart';
import 'package:pure_live/plugins/global.dart';
import 'package:pure_live/plugins/file_recover_utils.dart';
import 'package:pure_live/common/services/bilibili_account_service.dart';

const kWindowsScheme = 'purelive://signin';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  PrefUtil.prefs = await SharedPreferences.getInstance();
  // MediaKit.ensureInitialized();
  if (Platform.isWindows) {
    register(kWindowsScheme);
    await WindowsSingleInstance.ensureSingleInstance(
        args, "pure_live_instance_checker");
    await windowManager.ensureInitialized();
    await WindowUtil.init(width: 1280, height: 720);
  }
  // 先初始化supdatabase
  // await SupaBaseManager.getInstance().initial();
  // 初始化服务
  initService();
  initRefresh();
  // runApp(const MyAppTest());
  runApp(const MyApp());
}

void initService() {
  Get.put(SettingsService());
  Get.put(FavoriteController());
  Get.put(PopularController());
  Get.put(AreasController());
  Get.put(BiliBiliAccountService());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  final settings = Get.find<SettingsService>();
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
    initShareM3uState();
  }

  String getName(String fullName) {
    return fullName.split(Platform.pathSeparator).last;
  }

  bool isDataSourceM3u(String url) => url.contains('.m3u');
  String getUUid() {
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    var randomValue = Random().nextInt(4294967295);
    var result = (currentTime % 10000000000 * 1000 + randomValue) % 4294967295;
    return result.toString();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initShareM3uState() async {
    if (Platform.isAndroid) {
      final handler = ShareHandler.instance;
      await handler.getInitialSharedMedia();
      handler.sharedMediaStream.listen((SharedMedia media) async {
        if (isDataSourceM3u(media.content!)) {
          FileRecoverUtils().recoverM3u8BackupByShare(media);
        }
      });
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {
    setState(() {});
    super.onWindowFocus();
  }

  @override
  void onWindowEvent(String eventName) {
    WindowUtil.setPosition();
  }

  void _init() async {
    if (Platform.isWindows) {
      // Add this line to override the default close handler
      await WindowUtil.setTitle();
      await WindowUtil.setWindowsPort();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          return Obx(() {
            var themeColor = HexColor(settings.themeColorSwitch.value);
            ThemeData lightTheme =
                MyTheme(primaryColor: themeColor).lightThemeData;
            ThemeData darkTheme =
                MyTheme(primaryColor: themeColor).darkThemeData;
            if (settings.enableDynamicTheme.value) {
              lightTheme = MyTheme(colorScheme: lightDynamic).lightThemeData;
              darkTheme = MyTheme(colorScheme: darkDynamic).darkThemeData;
            }
            return GetMaterialApp(
              title: '纯粹直播',
              themeMode:
                  SettingsService.themeModes[settings.themeModeName.value]!,
              theme: lightTheme.copyWith(
                  appBarTheme:
                      AppBarTheme(surfaceTintColor: Colors.transparent)),
              darkTheme: darkTheme.copyWith(
                  appBarTheme:
                      AppBarTheme(surfaceTintColor: Colors.transparent)),
              locale: SettingsService.languages[settings.languageName.value]!,
              navigatorObservers: [FlutterSmartDialog.observer],
              builder: FlutterSmartDialog.init(),
              supportedLocales: S.delegate.supportedLocales,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              initialRoute: RoutePath.kInitial,
              defaultTransition: Transition.native,
              getPages: AppPages.routes,
            );
          });
        },
      ),
    );
  }
}

// 以下代码用于调试
class MyAppTest extends StatelessWidget {
  const MyAppTest({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
