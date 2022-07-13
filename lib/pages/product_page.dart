import 'package:cassiere/model/product.dart';
import 'package:cassiere/library/custom_text_field.dart';
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
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isNewProduct = false;

  @override
  void initState() {
    _nameController.text = widget.product?.name ?? '';
    _priceController.text = widget.product?.price ?? '';
    _categoryController.text = widget.product?.category ?? '';
    _noteController.text = widget.product?.note ?? '';
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
              (e) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateStock(product: e),
                    ),
                  );
                },
                child: ProductCard(
                  product: e,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/products.png',
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
                begin: Alignment.topCenter,
                stops: const [0.5, 0.9],
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                product.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
