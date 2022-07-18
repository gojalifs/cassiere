import 'package:cassiere/model/product.dart';
import 'package:cassiere/pages/product/update_product.dart';
import 'package:cassiere/utils/db_helper.dart';
import 'package:flutter/material.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  LocalDbHelper dbHelper = LocalDbHelper();
  OnlineDbHelper onlineDbHelper = OnlineDbHelper();
  List<Product> products = [];

  @override
  void initState() {
    // dbHelper.readProducts().then((value) {
    //   setState(() {
    //     products = value;
    //   });
    // });
    onlineDbHelper.readProduct().then((value) {
      print(value);
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
              // dbHelper.readProducts().then((value) {
              //   setState(() {
              //     products = value;
              //   });
              // });
              onlineDbHelper.readProduct().then((value) {
                print(value);
                setState(() {
                  products = value;
                });
              });
              setState(() {});
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
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 1))
            .then((value) => onlineDbHelper.readProduct()),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GridView.count(
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
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
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
