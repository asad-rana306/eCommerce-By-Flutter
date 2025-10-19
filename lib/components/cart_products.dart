import 'package:flutter/material.dart';
import 'cart_manager.dart';

class CartProducts extends StatefulWidget {
  final Function(double) onTotalChanged;

  const CartProducts({Key? key, required this.onTotalChanged})
    : super(key: key);

  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  @override
  void initState() {
    super.initState();
    _updateTotal();
  }

  void _updateTotal() {
    double total = 0;
    for (var item in CartManager.cartItems) {
      total += item['price'] * item['quantity'];
    }

    // ✅ Schedule the total update after the current frame to avoid build-time errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTotalChanged(total);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager.cartItems;

    if (cartItems.isEmpty) {
      // ✅ Safely update total when cart is empty
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onTotalChanged(0);
      });

      return const Center(
        child: Text(
          "Your cart is empty 🛒",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return SingleCartProduct(
          name: item['name'],
          image: item['image'],
          price: item['price'],
          oldPrice: item['oldPrice'],
          quantity: item['quantity'],
          onRemove: () {
            setState(() {
              CartManager.removeItem(index);
              _updateTotal();
            });
          },
          onQuantityChanged: (newQuantity) {
            setState(() {
              CartManager.updateQuantity(index, newQuantity);
              _updateTotal();
            });
          },
        );
      },
    );
  }
}

class SingleCartProduct extends StatelessWidget {
  final String name;
  final String image;
  final double oldPrice;
  final double price;
  final int quantity;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const SingleCartProduct({
    Key? key,
    required this.name,
    required this.image,
    required this.oldPrice,
    required this.price,
    required this.quantity,
    required this.onRemove,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: ListTile(
        leading: Image.asset(
          image,
          width: 80.0,
          height: 80.0,
          fit: BoxFit.cover,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "\$${price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 20),
                  onPressed: quantity > 1
                      ? () => onQuantityChanged(quantity - 1)
                      : null,
                ),
                Text(
                  quantity.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () => onQuantityChanged(quantity + 1),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
