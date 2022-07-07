import 'package:cassiere/pages/home_page.dart';
import 'package:cassiere/pages/signup_page.dart';
import 'package:cassiere/utils/db_helper.dart';
import 'package:flutter/material.dart';

import 'custom_text_field.dart';

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

  DbHelper dbHelper = DbHelper();

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
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 50),
                      height: 100,
                      width: 100,
                      child: Image.asset('assets/images/cassiere_logo.png'),
                    ),
                    Text(
                      'Please Login!',
                      style: Theme.of(context).textTheme.headlineLarge,
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
                                  dbHelper
                                      .doLogin(
                                    _emailController.text.trim(),
                                    _passwordController.text,
                                    context: context,
                                  )
                                      .then((value) {
                                    value == '0'
                                        ? print(value)
                                        : navigator.pushReplacement(
                                            MaterialPageRoute(
                                              builder: (_) {
                                                print(value);
                                                return HomePage(
                                                  users: value,
                                                );
                                              },
                                            ),
                                          );
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
