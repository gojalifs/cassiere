import 'package:cassiere/model/product.dart';
import 'package:cassiere/pages/custom_text_field.dart';
import 'package:cassiere/utils/db_helper.dart';
import 'package:flutter/material.dart';

class UpdateStock extends StatefulWidget {
  const UpdateStock({Key? key}) : super(key: key);

  @override
  State<UpdateStock> createState() => _UpdateStockState();
}

class _UpdateStockState extends State<UpdateStock> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isNewProduct = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // DropdownSearch<String>(
                    //   onChanged: ((value) {
                    //     if (value == 'Add New') {
                    //       setState(() {
                    //         isNewProduct = true;
                    //       });
                    //     } else {
                    //       setState(() {
                    //         isNewProduct = false;
                    //       });
                    //     }
                    //   }),
                    //   dropdownDecoratorProps: DropDownDecoratorProps(
                    //     dropdownSearchDecoration: InputDecoration(
                    //       hintText: 'Select Product',
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //     ),
                    //   ),
                    //   validator: (value) {
                    //     if (value == null) {
                    //       return 'Please select';
                    //     }
                    //     return null;
                    //   },
                    //   autoValidateMode: AutovalidateMode.onUserInteraction,
                    //   items: const [
                    //     '1',
                    //     '2',
                    //     'Add New',
                    //   ],
                    // ),
                    const SizedBox(height: 20),

                    CustomTextFormField(
                      label: 'Product Name',
                      controller: _nameController,
                      inputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                        label: 'Price',
                        controller: _priceController,
                        inputType: TextInputType.number),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                        label: 'Category', controller: _categoryController),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          DbHelper dbHelper = DbHelper();
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            dbHelper
                                .insertProduct(
                                    name: _nameController.text,
                                    price: _priceController.text,
                                    category: _categoryController.text,
                                    note: _noteController.text)
                                .then((value) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Success'),
                                      content: const Text('Product added'),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              dbHelper.readProducts();
                            });
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        DbHelper dbHelper = DbHelper();
                        dbHelper.readProducts().then((value) {});
                      },
                      child: const Text('Check'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  DbHelper dbHelper = DbHelper();
  List<Product> products = [];

  @override
  void initState() {
    dbHelper.readProducts().then((value) {
      setState(() {
        products = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Product'),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              dbHelper.readProducts().then((value) {
                setState(() {
                  products = value;
                });
              });
            },
            backgroundColor: Colors.amber,
            child: const Icon(Icons.replay),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const UpdateStock();
              }));
            },
            backgroundColor: Colors.amber,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: products
            .map(
              (e) => Card(
                child: Text(e.name),
              ),
            )
            .toList(),
      ),
    );
  }
}
