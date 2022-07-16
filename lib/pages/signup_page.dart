import 'package:cassiere/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../library/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  final String? title;
  final String? name;
  final String? email;
  final String? phone;
  final String? password;
  final String? confirmPassword;
  final int? id;

  const SignUpPage(
      {Key? key,
      this.name,
      this.email,
      this.phone,
      this.password,
      this.confirmPassword,
      this.title,
      this.id})
      : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isObscured = true;
  bool isChecked = false;
  bool isOwn = true;

  Future<int> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id')!;
  }

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _passwordController = TextEditingController(text: widget.password);
    _confirmPasswordController = TextEditingController(text: widget.password);
    getId().then((value) {
      if (widget.id != value) {
        setState(() {
          isOwn = false;
        });
      }
      ;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: widget.title != null
                ? Text(widget.title!)
                : widget.name == null
                    ? const Text('Sign Up')
                    : const Text('Edit Profile'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
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
                          SizedBox(
                            width: double.infinity,
                            child: widget.name == null
                                ? ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        LocalDbHelper dbHelper =
                                            LocalDbHelper();
                                        dbHelper
                                            .checkUser(_emailController.text)
                                            .then((value) {
                                          if (value == 0) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text('Registering'),
                                              ),
                                            );
                                            primaryFocus!.unfocus();
                                            dbHelper.addUser(
                                                _nameController.text,
                                                _emailController.text,
                                                _phoneController.text,
                                                _passwordController.text,
                                                isChecked ? 1 : 0);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Email already registered'),
                                              ),
                                            );
                                          }
                                        });
                                      }
                                    },
                                    child: widget.title == null
                                        ? const Text('Sign Me Up')
                                        : const Text('Add Employee'),
                                  )

                                /// TODO : add update user button
                                : ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('Save Editing')),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: isOwn
                                ? null
                                : widget.name == null
                                    ? ElevatedButton(
                                        onPressed: () {
                                          LocalDbHelper dbHelper =
                                              LocalDbHelper();
                                          dbHelper
                                              .readUser()
                                              .then((value) => print(value));
                                          primaryFocus!.unfocus();
                                        },
                                        child: const Text('Back To Login'))

                                    /// TODO : add sign up button
                                    : ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('Delete User'),
                                      ),
                          )
                        ],
                      ),
                    )
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
