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
  final bool? isAdmin;
  final int? id;

  const SignUpPage(
      {Key? key,
      this.name,
      this.email,
      this.phone,
      this.password,
      this.confirmPassword,
      this.title,
      this.id,
      this.isAdmin})
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
  TextEditingController? storeIdController = TextEditingController();
  TextEditingController? storeNameController = TextEditingController();
  TextEditingController? storeAddressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isAlreadyExist = false;
  bool isObscured = true;
  bool isChecked = false;
  bool isOwner = true;

  // Future<int> getId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getInt('id')!;
  // }

  Future getUserDetail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAdmin') ?? true;
  }

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _passwordController = TextEditingController(text: widget.password);
    _confirmPasswordController = TextEditingController(text: widget.password);
    if (widget.name != null && widget.name!.isNotEmpty) {
      getUserDetail().then((value) => isOwner = value);
    }
    // getId().then((value) {
    //   if (widget.id != value) {
    //     setState(() {
    //       isOwn = false;
    //     });
    //   }
    //   ;
    // });
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
                          widget.name == null
                              ? CustomTextFormField(
                                  label: 'Store ID',
                                  isExist: isAlreadyExist,
                                  controller: storeIdController!,
                                  maxLength: 11,
                                  onEditingComplete: () {
                                    OnlineDbHelper db = OnlineDbHelper();
                                    db
                                        .readStore(uid: storeIdController!.text)
                                        .then((value) {
                                      setState(() {
                                        if (value.isNotEmpty) {
                                          isAlreadyExist = true;
                                        } else {
                                          isAlreadyExist = false;
                                        }
                                      });
                                    });
                                  },
                                )
                              : const SizedBox(),
                          widget.name == null
                              ? const SizedBox(height: 20)
                              : const SizedBox(),
                          widget.name == null
                              ? CustomTextFormField(
                                  label: 'Store Name',
                                  controller: storeNameController!,
                                  maxLength: 45,
                                )
                              : const SizedBox(),
                          widget.name == null
                              ? const SizedBox(height: 20)
                              : const SizedBox(),
                          widget.name == null
                              ? CustomTextFormField(
                                  label: 'Store Address',
                                  controller: storeAddressController!,
                                  maxLength: 50,
                                )
                              : const SizedBox(),
                          widget.title == null
                              ? const SizedBox(height: 20)
                              : const SizedBox(),
                          CustomTextFormField(
                            label: 'Name',
                            controller: _nameController,
                            maxLength: 45,
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            label: 'email',
                            controller: _emailController,
                            inputType: TextInputType.emailAddress,
                            maxLength: 50,
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            label: 'phone number',
                            controller: _phoneController,
                            inputType: TextInputType.phone,
                            valueLength: 9,
                            maxLength: 20,
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            label: 'password',
                            controller: _passwordController,
                            inputType: TextInputType.visiblePassword,
                            valueLength: 6,
                            isObscure: isObscured,
                            maxLength: 255,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscured = !isObscured;
                                  });
                                },
                                icon: isObscured
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off)),
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            label: 'confirm password',
                            controller: _confirmPasswordController,
                            inputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            valueLength: 6,
                            isObscure: isObscured,
                            maxLength: 255,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscured = !isObscured;
                                  });
                                },
                                icon: isObscured
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off)),
                            confirmController: _passwordController,
                            onChanged: (value) {
                              if (_passwordController !=
                                  _confirmPasswordController) {}
                            },
                          ),
                          !isOwner
                              ? const SizedBox(height: 20)
                              : const SizedBox(),
                          isOwner
                              ? CheckboxListTile(
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
                                )
                              : const SizedBox(),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: widget.name == null
                                ? ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        /// online db version
                                        OnlineDbHelper db = OnlineDbHelper();
                                        db
                                            .readStore(
                                                uid: storeIdController!.text)
                                            .then((value) {
                                          print(value);
                                          if (value.isEmpty) {
                                            db
                                                .insertStore(
                                                    storeIdController!.text,
                                                    _nameController.text,
                                                    storeAddressController!
                                                        .text)
                                                .then(
                                                  (value) => db
                                                      .registerUser(
                                                          store:
                                                              storeIdController!
                                                                  .text,
                                                          name: _nameController
                                                              .text,
                                                          email:
                                                              _emailController
                                                                  .text,
                                                          phone:
                                                              _phoneController
                                                                  .text,
                                                          password:
                                                              _passwordController
                                                                  .text,
                                                          isOwner: isOwner)
                                                      .then(
                                                    (value) {
                                                      print(value);
                                                      return ScaffoldMessenger
                                                              .of(context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Success Register, please Login'),
                                                        ),
                                                      );
                                                    },
                                                  ).then(
                                                    (value) =>
                                                        Navigator.pop(context),
                                                  ),
                                                );

                                            // return Future.delayed(
                                            //         const Duration(seconds: 1))
                                            //     .then((value) =>
                                            //         Navigator.pop(context));
                                          } else if (value.isNotEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Store ID already exist'),
                                              ),
                                            );
                                          }
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(const SnackBar(
                                          //         content: Text(
                                          //             'An Error Happen, we will repair this')));

                                          // }
                                        });
                                        // .then((value) => db
                                        //     .registerUser(
                                        //         _storeIdController!.text,
                                        //         _nameController.text,
                                        //         _emailController.text,
                                        //         _phoneController.text,
                                        //         _passwordController.text,
                                        //         isChecked,
                                        //         isOwner)
                                        //     .then((value) => print(value)));

                                        /// local db helper
                                        // LocalDbHelper dbHelper =
                                        //     LocalDbHelper();
                                        // dbHelper
                                        //     .checkUser(_emailController.text)
                                        //     .then((value) {
                                        //   if (value == 0) {
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(
                                        //       const SnackBar(
                                        //         content: Text('Registering'),
                                        //       ),
                                        //     );
                                        //     primaryFocus!.unfocus();
                                        //     dbHelper.addUser(
                                        //         _nameController.text,
                                        //         _emailController.text,
                                        //         _phoneController.text,
                                        //         _passwordController.text,
                                        //         isChecked ? 1 : 0);
                                        //   } else {
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(
                                        //       const SnackBar(
                                        //         content: Text(
                                        //             'Email already registered'),
                                        //       ),
                                        //     );
                                        //   }
                                        // });
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
                            child:
                                // isOwn
                                //     ? null :
                                widget.name == null
                                    ? const SizedBox()

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
