import 'package:cassiere/pages/home_page.dart';
import 'package:cassiere/pages/signup_page.dart';
import 'package:cassiere/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../library/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscured = true;
  final _formKey = GlobalKey<FormState>();
  final List<String> users = ['admin', 'employee'];

  LocalDbHelper dbHelper = LocalDbHelper();
  OnlineDbHelper onlineDbHelper = OnlineDbHelper();

  @override
  void initState() {
    dbHelper.initDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Please Login!',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 250,
                      width: 250,
                      child:
                          Image.asset('assets/images/login_illustration.png'),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            label: 'email',
                            inputType: TextInputType.emailAddress,
                            controller: _emailController,
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            label: 'password',
                            controller: _passwordController,
                            isObscure: isObscured ? true : false,
                            inputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isObscured = !isObscured;
                                });
                              },
                              icon: isObscured
                                  ? const Icon(Icons.visibility)
                                  : const Icon(
                                      Icons.visibility_off,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: const Text('Login'),
                              onPressed: () {
                                var navigator = Navigator.of(context);
                                if (_formKey.currentState!.validate()) {
                                  // dbHelper
                                  //     .doLogin(
                                  //   _emailController.text.trim(),
                                  //   _passwordController.text,
                                  //   context: context,
                                  // )
                                  onlineDbHelper
                                      .doLogin(_emailController.text,
                                          _passwordController.text)
                                      .then((value) {
                                    print(value);
                                    if (value == 1) {
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      navigator.pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return HomePage();
                                          },
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Login failed, email or password is wrong!'),
                                      ));
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text('or'),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: const Text('Sign Up as Admin'),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return const SignUpPage();
                                }));
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () {
                                var dt = DateTime.now();
                                var formatter =
                                    DateFormat('yyyy-MM-dd HH:mm:ss');
                                String formatted =
                                    formatter.format(dt); // Save this to DB
                                print(formatted); // Output: 2021-05-11 08:52:45
                                String a =
                                    formatter.parse(formatted).toString();
                                print(
                                    'formart $formatted'); // Convert back to DateTime object
                              },
                              child: const Text('Coba')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
