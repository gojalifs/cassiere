import 'package:cassiere/model/user.dart';
import 'package:cassiere/library/custom_text_field.dart';
import 'package:cassiere/pages/signup_page.dart';
import 'package:cassiere/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({Key? key}) : super(key: key);

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  LocalDbHelper dbHelper = LocalDbHelper();
  List<User> users = [];
  Future getEmployees = LocalDbHelper().readEmployee();
  List employees = [];
  int id = 0;

  readActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getInt('id'));
    return id = prefs.getInt('id')!;
  }

  @override
  void initState() {
    dbHelper.readEmployee().then((value) {
      setState(() {
        users = value;
      });
    });
    readActiveUser().then((value) {
      setState(() {
        id = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List of Employees'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpPage(
                  title: 'Add Employee',
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: getEmployees,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (users.isEmpty) {
                  return const Text('Done');
                } else {
                  // print(employees
                  //     .where((element) => element['id'] == id)
                  //     .toList());
                  return ListView(
                    children: users
                        .map((e) => ListTile(
                              title: Text(e.name!),
                              subtitle: Text(e.email!),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpPage(
                                      name: e.name,
                                      email: e.email,
                                      phone: e.phone,
                                      password: e.password,
                                      confirmPassword: e.password,
                                      id: e.id,
                                    ),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                    // employees.map((e) {
                    //   return ListTile(
                    //     title:
                    //         e['id'] == id ? Text(e['name']) : Text(e['name']),
                    //     subtitle: Text(e['email']),
                    //     trailing: e['id'] == id
                    //         ? IconButton(
                    //             onPressed: () {
                    //               Navigator.of(context).push(MaterialPageRoute(
                    //                   builder: ((context) => SignUpPage(name: e[''],))));
                    //             },
                    //             icon: const Icon(Icons.edit))
                    //         : Wrap(
                    //             children: [
                    //               IconButton(
                    //                 onPressed: () {},
                    //                 icon: const Icon(Icons.edit),
                    //               ),
                    //               IconButton(
                    //                 icon: const Icon(Icons.delete),
                    //                 color: e['id'] == id
                    //                     ? Colors.grey
                    //                     : Colors.red,
                    //                 onPressed: () {
                    //                   dbHelper.deleteEmployee(e['id']);
                    //                   setState(() {
                    //                     employees.remove(e);
                    //                   });
                    //                 },
                    //               ),
                    //             ],
                    //           ),
                    //   );
                    // }).toList(),
                  );
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

class EditEmployee extends StatefulWidget {
  const EditEmployee({Key? key}) : super(key: key);

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            CustomTextFormField(
              label: 'Name',
              controller: _nameController,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: 'Email',
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: 'Phone',
              controller: _phoneController,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: 'Password',
              controller: _passwordController,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Cancel')),
                ElevatedButton(onPressed: () {}, child: const Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
