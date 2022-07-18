import 'package:cassiere/library/custom_text_field.dart';
import 'package:cassiere/model/product.dart';
import 'package:cassiere/utils/db_helper.dart';
import 'package:flutter/material.dart';

class UpdateStock extends StatefulWidget {
  final Product? product;

  const UpdateStock({super.key, this.product});

  @override
  State<UpdateStock> createState() => _UpdateStockState();
}

class _UpdateStockState extends State<UpdateStock> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isNewProduct = false;

  final OnlineDbHelper onlineDbHelper = OnlineDbHelper();
  List<Product> products = [];

  @override
  void initState() {
    _nameController.text = widget.product?.name ?? '';
    _priceController.text = widget.product?.price ?? '';
    _categoryController.text = widget.product?.category ?? '';
    _descriptionController.text = widget.product?.description ?? '';

    super.initState();
  }

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
                    CustomTextFormField(
                        label: 'Description',
                        controller: _descriptionController),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          LocalDbHelper dbHelper = LocalDbHelper();
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            onlineDbHelper
                                .insertProduct(Product(
                                  name: _nameController.text,
                                  price: _priceController.text,
                                  category: _categoryController.text,
                                  description: _descriptionController.text,
                                ))
                                .then((value) => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text('Success'),
                                          content: const Text(
                                              'Product added successfully'),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('OK'),
                                            )
                                          ],
                                        )));
                            // dbHelper
                            //     .insertProduct(
                            //         name: _nameController.text,
                            //         price: _priceController.text,
                            //         category: _categoryController.text,
                            //         note: _noteController.text)
                            //     .then((value) {
                            //   showDialog(
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return AlertDialog(
                            //           title: const Text('Success'),
                            //           content: const Text('Product added'),
                            //           actions: [
                            //             TextButton(
                            //               child: const Text('OK'),
                            //               onPressed: () {
                            //                 Navigator.pop(context);
                            //                 Navigator.pop(context);
                            //               },
                            //             ),
                            //           ],
                            //         );
                            //       });
                            //   dbHelper.readProducts();
                            // });
                          }
                        },
                        child: _nameController.text.isEmpty
                            ? const Text('Add')
                            : const Text('Update'),
                      ),
                    ),
                    _nameController.text.isNotEmpty
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                onlineDbHelper
                                    .deleteProduct('${widget.product!.id}');
                              },
                              child: const Text('Delete Product'),
                            ))
                        : const SizedBox(),
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
