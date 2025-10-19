import 'package:flutter/material.dart';
import '../components/cart_manager.dart';
import 'Home.dart';
import 'checkout.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  double _totalPrice = 0.0;
  List<bool> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _selectedItems = List<bool>.filled(CartManager.cartItems.length, false);
  }

  void _updateTotal() {
    double total = 0.0;
    for (int i = 0; i < CartManager.cartItems.length; i++) {
      if (_selectedItems[i]) {
        final item = CartManager.cartItems[i];
        total += (item['price'] ?? 0.0) * (item['quantity'] ?? 1);
      }
    }
    setState(() {
      _totalPrice = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: const Text("Cart"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeApp()),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: CartManager.cartItems.length,
        itemBuilder: (context, index) {
          final item = CartManager.cartItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Checkbox(
                value: _selectedItems[index],
                onChanged: (bool? value) {
                  setState(() {
                    _selectedItems[index] = value ?? false;
                    _updateTotal();
                  });
                },
              ),
              title: Text(item['name'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Price: \$${item['price']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20),
                        onPressed: item['quantity'] > 1
                            ? () {
                                setState(() {
                                  CartManager.updateQuantity(
                                    index,
                                    item['quantity'] - 1,
                                  );
                                  _updateTotal();
                                });
                              }
                            : null,
                      ),
                      Text(
                        item['quantity'].toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () {
                          setState(() {
                            CartManager.updateQuantity(
                              index,
                              item['quantity'] + 1,
                            );
                            _updateTotal();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  setState(() {
                    CartManager.removeItem(index);
                    _selectedItems.removeAt(index);
                    _updateTotal();
                  });
                },
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: const Text("Total: "),
                subtitle: Text(
                  "\$${_totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: MaterialButton(
                color: Colors.red,
                child: const Text(
                  "Checkout",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // Collect selected items from the cart
                  List<Map<String, dynamic>> selectedItems = [];
                  for (int i = 0; i < CartManager.cartItems.length; i++) {
                    if (_selectedItems[i]) {
                      // _selectedItems is a list of booleans for each cart item
                      selectedItems.add(CartManager.cartItems[i]);
                    }
                  }

                  if (selectedItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No items selected!")),
                    );
                    return;
                  }

                  // Navigate to Checkout screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CheckoutScreen(products: selectedItems),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
