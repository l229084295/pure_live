import 'package:get/get.dart';
import 'package:pure_live/common/index.dart';
import 'package:pure_live/modules/auth/components/supa_reset_password.dart';

class UpdatePassword extends StatelessWidget {
  const UpdatePassword({super.key});

  AppBar appBar(String title) => AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('更新密码'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
