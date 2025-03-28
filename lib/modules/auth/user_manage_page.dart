import 'package:get/get.dart';
import 'package:pure_live/common/index.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pure_live/modules/auth/utils/constants.dart';

class UserManager extends StatefulWidget {
  const UserManager({super.key});

  @override
  State<UserManager> createState() => _UserManagerState();
}

class _UserManagerState extends State<UserManager> {
  final TextEditingController textEditingController = TextEditingController();
  final SettingsService settingsController = Get.find<SettingsService>();
  Color get themeColor => HexColor(settingsController.themeColorSwitch.value);
  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  Future onRefresh() async {
    refreshController.finishRefresh(IndicatorResult.success);
  }

  final users = [].obs;
  @override
  void initState() {
    super.initState();
  }

  Future<void> getCurrentUsers() async {}

  void addUser() {}

  removeUser(email, index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户管理'),
      ),
      body: Obx(() => EasyRefresh(
            controller: refreshController,
            onRefresh: onRefresh,
            onLoad: () {
              refreshController.finishLoad(IndicatorResult.success);
            },
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    contentPadding: const EdgeInsets.all(12.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: themeColor)),
                    hintText: "请输入邮箱",
                    suffixIcon: TextButton.icon(
                      onPressed: addUser,
                      icon: const Icon(Icons.add),
                      label: const Text("添加"),
                    ),
                  ),
                  onSubmitted: (e) {
                    addUser();
                  },
                ),
                spacer(12.0),
                Obx(
                  () => Text(
                    "已添加${users.length}个用户（点击移除）",
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                spacer(12.0),
                Obx(
                  () => Wrap(
                    runSpacing: 12,
                    spacing: 12,
                    children: users
                        .map(
                          (email) => InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            onTap: () {
                              var index = users
                                  .indexWhere((element) => element == email);
                              removeUser(email, index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                              ),
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 8, right: 8),
                              child: Text(
                                email,
                                style: Get.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
