import 'package:cassiere/utils/db_helper.dart';
import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isObscured = true;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Register',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 20),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              label: 'Nama',
                              controller: _nameController,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              label: 'email',
                              controller: _emailController,
                              inputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              label: 'phone number',
                              controller: _phoneController,
                              inputType: TextInputType.phone,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              label: 'password',
                              controller: _passwordController,
                              inputType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              label: 'confirm password',
                              controller: _confirmPasswordController,
                              inputType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 20),
                            CheckboxListTile(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                                FocusScope.of(context).unfocus();
                              },
                              title: const Text(
                                'Mark as Admin',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    DbHelper dbHelper = DbHelper();
                                    dbHelper
                                        .addUser(
                                            _nameController.text,
                                            _emailController.text,
                                            _phoneController.text,
                                            _passwordController.text,
                                            isChecked.toString())
                                        .then((value) => print('sign up'));
                                    // dbHelper
                                    //     .readEmployee()
                                    //     .then((value) => print(value));
                                  }
                                },
                                child: Text('Sign Me Up'),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    DbHelper dbHelper = DbHelper();
                                    dbHelper
                                        .readUser()
                                        .then((value) => print('value'));
                                    // Navigator.pop(context);
                                  },
                                  child: Text('Back To Login')),
                            ),
                          ],
                        ))
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
