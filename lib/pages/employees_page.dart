import 'package:cassiere/pages/custom_text_field.dart';
import 'package:cassiere/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class EmployeesPage extends StatefulWidget {
  EmployeesPage({Key? key}) : super(key: key);

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  DbHelper dbHelper = DbHelper();
  Future getEmployees = DbHelper().readEmployee();
  List employees = [];

  @override
  void initState() {
    dbHelper.readEmployee().then((value) {
      setState(() {
        employees = value;
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
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: getEmployees,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (employees.isEmpty) {
                  return const Text('Done');
                } else {
                  return Row(
                    children: [
                      const Expanded(
                        flex: 6,
                        child: ListTile(
                          title: Text('Jamal'),
                          subtitle: Text('Admin'),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return EditEmployee();
                            }));
                          },
                          icon: const Icon(Icons.edit_rounded),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete_rounded),
                        ),
                      ),
                    ],
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
  EditEmployee({Key? key}) : super(key: key);

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
                ElevatedButton(onPressed: () {}, child: Text('Cancel')),
                ElevatedButton(onPressed: () {}, child: Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
