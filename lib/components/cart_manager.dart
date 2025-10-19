class CartManager {
  // Shared cart items list
  static final List<Map<String, dynamic>> cartItems = [];

  /// Adds an item to the cart.
  /// If the item already exists, increases its quantity.
  static void addItem(Map<String, dynamic> product) {
    for (var item in cartItems) {
      if (item['name'] == product['name']) {
        item['quantity'] = (item['quantity'] ?? 1) + 1;
        return;
      }
    }
    product['quantity'] = 1;
    cartItems.add(product);
  }

  /// Removes an item at the specified index
  static void removeItem(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
    }
  }

  /// Updates the quantity of an item at the specified index
  static void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < cartItems.length) {
      cartItems[index]['quantity'] = quantity < 1 ? 1 : quantity;
    }
  }

  /// Calculates total price for all items in cart (considering quantity)
  static double get totalPrice {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + ((item['price'] ?? 0.0) * (item['quantity'] ?? 1)),
    );
  }
}
