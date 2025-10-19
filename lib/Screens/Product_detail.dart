import 'package:flutter/material.dart';
import 'package:mid_project/components/products.dart';
import 'Home.dart';

class ProductDetails extends StatefulWidget {
  final String name;
  final String image;
  final double oldPrice;
  final double price;

  const ProductDetails({
    Key? key,
    required this.name,
    required this.image,
    required this.oldPrice,
    required this.price,
  }) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Text(widget.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeApp()),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.asset(widget.image, fit: BoxFit.cover),
              ),
              footer: Container(
                color: Colors.white,
                child: ListTile(
                  leading: Text(widget.name),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "\$${widget.oldPrice}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "\$${widget.price}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey,
                    elevation: 0.2,
                  ),
                  onPressed: () {
                    _showSelectionDialog(context, "Size", "Choose size");
                  },
                  child: Row(
                    children: const [
                      Expanded(child: Text("Size")),
                      Expanded(
                        child: Icon(Icons.arrow_drop_down, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey,
                    elevation: 0.2,
                  ),
                  onPressed: () {
                    _showSelectionDialog(context, "Color", "Choose color");
                  },
                  child: Row(
                    children: const [
                      Expanded(child: Text("Color")),
                      Expanded(
                        child: Icon(Icons.arrow_drop_down, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey,
                    elevation: 0.2,
                  ),
                  onPressed: () {
                    _showSelectionDialog(
                      context,
                      "Quantity",
                      "Choose quantity",
                    );
                  },
                  child: Row(
                    children: const [
                      Expanded(child: Text("Qty")),
                      Expanded(
                        child: Icon(Icons.arrow_drop_down, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 0.2,
                  ),
                  onPressed: () {},
                  child: const Text("Buy Now"),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                color: Colors.red,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                color: Colors.red,
                onPressed: () {},
              ),
            ],
          ),

          const Divider(),
          const ListTile(
            title: Text("Details"),
            subtitle: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
              "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
            ),
          ),

          const Divider(),
          _infoRow("Name", widget.name),
          _infoRow("Brand", "Brand X"),
          _infoRow("Condition", "Available"),

          const Divider(),

          const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text("Similar Products"),
          ),
          const Divider(),
          SizedBox(height: 320.0, child: Products(items: 4)),
        ],
      ),
    );
  }

  void _showSelectionDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(message, style: const TextStyle(color: Colors.blue)),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 5, 5, 5),
          child: Text(label, style: const TextStyle(color: Colors.grey)),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(value, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
