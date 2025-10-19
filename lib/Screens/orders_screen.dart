import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/order_service.dart';

class MyOrders extends StatelessWidget {
  final orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.redAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orderService.getUserOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final products = List<Map<String, dynamic>>.from(
                order['products'],
              );
              final total = order['total'];
              final status = order['status'];

              return ListTile(
                title: Text('Order #${order.id}'),
                subtitle: Text(
                  'Total: \$${total.toStringAsFixed(2)}\nStatus: $status',
                ),
                onTap: () {
                  // Show products in order
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Products'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: products
                            .map((p) => Text('${p['name']} x ${p['quantity']}'))
                            .toList(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
