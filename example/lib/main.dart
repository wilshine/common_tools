import 'dart:io';
import 'dart:math';

import 'package:example/permission_main.dart';
import 'package:flutter/material.dart';
import 'package:common_tools/common_tools.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  print('11  ${XPToolManager.instance.hashCode}');
  print('22  ${XPToolManager.instance.hashCode}');
  print('33  ${XPToolManager.instance.hashCode}');
  XPToolManager.instance.init(languageCode: 'en');
  TranslationUtil.init(Locale('en'), {});

  runApp(const MyApp());
}

Widget buildMenu(String title, Color clr, Function() onTap) {
  return GestureDetector(
    child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text(title),
        color: clr,
        alignment: Alignment.center),
    onTap: onTap,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Color color;
  int index = 0;

  @override
  void initState() {
    super.initState();
    color = Color.fromRGBO(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: buildBody()),
    );
  }

  Widget buildBody() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  children: [
                    buildMenu('基础工具', color, () {
                      setState(() {
                        index = 0;
                      });
                    }),
                    buildMenu('权限'.t, color, () {
                      setState(() {
                        index = 1;
                      });
                    }),
                    // buildMenu('Button展示', color, () {
                    //   setState(() {
                    //     index = 2;
                    //   });
                    // }),
                  ],
                ),
              )),
          Expanded(
            child: IndexedStack(
              sizing: StackFit.passthrough,
              index: index,
              children: [
                MyHomePage(),
                PermissionHandlerWidget(),
              ],
            ),
            flex: 8,
          )
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ElevatedButton(onPressed: test1, child: const Text('测试DateUtil')),
          ElevatedButton(onPressed: test2, child: const Text('测试EncryptUtil')),
          ElevatedButton(onPressed: test3, child: const Text('测试ScreenUtil')),
          ElevatedButton(onPressed: test4, child: const Text('测试ThrottleUtil')),
          ElevatedButton(onPressed: test5, child: const Text('测试ValidatorUtil')),
          ElevatedButton(onPressed: test6, child: const Text('测试Color')),
          ElevatedButton(onPressed: test7, child: const Text('测试扩展List')),
          ElevatedButton(onPressed: test8, child: const Text('测试MMKV')),
          ElevatedButton(onPressed: test9, child: const Text('测试安装APK')),
          ElevatedButton(onPressed: test10, child: const Text('测试日志')),

        ],
      ),
    );
  }

  void test1() async {
    // print('getNowDateString: ${DateUtil.getNowDateString()}');
    //
    // print("isToday: ${DateUtil.isToday(DateTime.now().millisecondsSinceEpoch)}");
    //
    // print('${DateTime.now()}  isYesterday:   ${DateUtil.isYesterday(DateTime.now())}');
    //
    // print('${DateTime.now()}  isThisWeek:   ${DateUtil.isThisWeek(DateTime.now())}');
    //
    // print('${DateTime.now()}  getIntegralPoint:   ${DateUtil.getIntegralPoint(DateTime.now())}');
    //
    //
    // DateTime date1 = DateTime.now();
    // DateTime date2 = DateTime(2022);
    // print('$date1  $date2  isSameDay=${DateUtil.isSameDay(date1, date2)}');
  }

  void test2() async {}

  void test3() async {
    print('getScreenW: ${ScreenUtils.getScreenW(context)}');
    print('getScreenH: ${ScreenUtils.getScreenH(context)}');

    print('screenWidth: ${ScreenUtils.getInstance().screenWidth}');
    print('screenHeight: ${ScreenUtils.getInstance().screenHeight}');
    print('appBarHeight: ${ScreenUtils.getInstance().appBarHeight}');
    print('bottomBarHeight: ${ScreenUtils.getInstance().bottomBarHeight}');
    print('screenDensity: ${ScreenUtils.getInstance().screenDensity}');

    print('getStatusBarH: ${ScreenUtils.getStatusBarH(context)}');
    print('getBottomBarH: ${ScreenUtils.getBottomBarH(context)}');
    print('getOrientation: ${ScreenUtils.getOrientation(context)}');
    print('getRatioCtx: ${ScreenUtils.getRatioCtx(context)}');
    print('getRatio: ${ScreenUtils.getInstance().getRatio()}');
  }

  void test4() async {
    ThrottleUtil.getInstance().throttle(() {
      print('1秒钟内只会执行一次');
    });
  }

  void test5() async {
    dynamic num = '123123213213';
    print('$num isAllNumber:   ${ValidatorUtil.isAllNumber(num)}');

    dynamic num1 = '123123213213adsfdsf';
    print('$num1 isAllNumber:   ${ValidatorUtil.isAllNumber(num1)}');

    dynamic num2 = '2dflkadjJJOIJOJO';
    print('$num2 isAllNumberLetter: ${ValidatorUtil.isAllNumberLetter(num2)}');

    dynamic email = '2dflkadjJJOIJOJO';
    print('$email isAllNumberLetter: ${ValidatorUtil.isEmailSameWithServerEx(email)}');
    print('$email isEmail: ${ValidatorUtil.isEmail(email)}');
    print('$email isEmailSameWithServer: ${ValidatorUtil.isEmailSameWithServer(email)}');

    dynamic email1 = '2dflkadjJJOIJOJO@djf.cojn';
    print('$email1 isAllNumberLetter: ${ValidatorUtil.isEmailSameWithServerEx(email1)}');
    print('$email1 isEmail: ${ValidatorUtil.isEmail(email1)}');
    print('$email1 isEmailSameWithServer: ${ValidatorUtil.isEmailSameWithServer(email1)}');
  }

  void test6() {
    print('#FFFF00  fromHex:  ${ColorEx.fromHex('#FFFF00')}');

    print('toHex:  ${Color.fromRGBO(250, 250, 250, 0.1).toHex()}');
  }

  void test7() async {
    var rows = {
      'LEGAL_INFOS': [
        {'LEGAL_RIGHT_NUMBER': 5000}
      ]
    };
    final legal = rows['LEGAL_INFOS'];
    List<Map<dynamic, dynamic>> refundRes = legal as List<Map<dynamic, dynamic>>;
    print('==>>$refundRes');
    return;

    Future<List<String>> getMetaTags() async {
      print('getMetaTags==start==${DateTime.now()}');
      await Future.delayed(Duration(seconds: 1));
      print('getMetaTags====${DateTime.now()}');
      return ['1', '2', '3'];
    }

    Future<Uri?> getUrl() async {
      print('getUrl==start==${DateTime.now()}');
      await Future.delayed(Duration(seconds: 1));
      print('getUrl====${DateTime.now()}');
      return null;
    }

    final List result = await Future.wait([
      getMetaTags(),
      getUrl(),
    ]);
    print('-->>> $result');
    Uri? url = result[2];

    Map deliveryTodoRuleRes = {'uiList': null};
    //print(deliveryTodoRuleRes['uiList']?[0]['paramList']);
    List deliveryTodoRule = [];
    print('<<<<');
//   deliveryTodoRule = deliveryTodoRuleRes['uiList']?[0]['paramList'] ?? [];
    print((deliveryTodoRuleRes['uiList'] ?? []) as List);
    // print((((deliveryTodoRuleRes['uiList'] ?? []) as List).elementAtOrElse(0, orElse: () => {}))['paramList'] ?? []);
    print('>>>> $deliveryTodoRule ');
  }

  void test8() async {
    // await MMKV.initialize();
    // var mmkv = MMKV.defaultMMKV();
    // mmkv.encodeString('test', jsonEncode([1,2,3]));
    // var xx = jsonDecode(mmkv.decodeString('test')!);
    // print('===>>>> ${xx.runtimeType} $xx');
    // MMkvUtil.test();
    await XpToolPlatform.instance.init();
    XpToolPlatform.instance.setValueWithKey('name', 'zhangsan');
    print(XpToolPlatform.instance.getValueWithKey('name'));
    XpToolPlatform.instance.deleteValueWithKey('name');
    print(XpToolPlatform.instance.getValueWithKey('name'));

    XpToolPlatform.instance.setValueWithKey('list1', ['zhangsan', 'lisi']);
    var list1 = XpToolPlatform.instance.getValueWithKey('list1');
    print('${list1.runtimeType}  $list1  ${list1[0]}');

    XpToolPlatform.instance.setValueWithKey('map1', {'name': 'zhangsan'});
    var map1 = XpToolPlatform.instance.getValueWithKey('map1');
    print('${map1.runtimeType}  $map1  ${map1['name']}');

    XpToolPlatform.instance.setValueWithKey('vo1', User('zhangsan', 20).toJson());
    var vo1 = XpToolPlatform.instance.getValueWithKey('vo1');
    print('${vo1.runtimeType}  $vo1  ');
  }

  void test9() async {
    if (await PermissionManager.instance.requestPermission(PermissionCode.manageExternalStorage)) {
      var file = File('/sdcard/test.apk');
      if (await FileUtil.exists(file.path)) {
        print('>>>>>  ${await file.exists()}   ${file.path}');
        var result = await FileUtil.openFile(file.path);
        print("type=${result.type}  message=${result.message}");
      }
    }
  }

  void test10() async {
    await LogManager.instance.init('test');
    LogManager.instance.debug('aaaa', 'asdfadsfd');
  }
}

class User {
  String name;
  int age;

  User(this.name, this.age);

  Map toJson() {
    return {
      'name': name,
      'age': age,
    };
  }
}
