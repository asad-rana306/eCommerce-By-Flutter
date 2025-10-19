import 'package:flutter/material.dart';
import 'package:mid_project/components/products_list.dart';
import 'package:mid_project/components/single_product.dart';

class Products extends StatefulWidget {
  final int? items;
  const Products({Key? key, this.items}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    final int itemCount = widget.items ?? product_list.length;

    return GridView.builder(
      itemCount: itemCount,
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        final product = product_list[index];
        return Product(
          name: product['name'] as String,
          image: product['image'] as String,
          oldPrice: product['oldPrice'] as double,
          price: product['price'] as double,
        );
      },
    );
  }
}
