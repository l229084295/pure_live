import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:pure_live/common/index.dart';
import 'package:pure_live/modules/auth/components/supa_email_auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).supabase_sign_in),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
