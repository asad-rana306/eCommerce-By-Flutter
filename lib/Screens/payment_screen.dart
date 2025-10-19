import 'package:flutter/material.dart';
import '../components/email_sender.dart'; // SMTP helper

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final double total;
  final String userEmail; // pass email from login/home

  const PaymentScreen({
    Key? key,
    required this.products,
    required this.total,
    required this.userEmail,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentMethod = 'home';
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  void handlePayNow() async {
    final userEmail = widget.userEmail;

    if (userEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No logged-in user email found!')),
      );
      return;
    }

    String productNames = widget.products.map((p) => p['name']).join(', ');
    String message =
        'Thank you for your order!\nProducts: $productNames\nTotal: \$${widget.total.toStringAsFixed(2)}';

    if (paymentMethod == 'card') {
      message += '\nPayment method: Card';
    } else {
      message += '\nPayment method: Home Delivery';
    }

    // Send email via SMTP
    try {
      await sendEmail(
        toEmail: userEmail,
        subject: 'Order Confirmation',
        body: message,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful! Confirmation sent.')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send email: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...widget.products.map(
                    (product) => ListTile(
                      title: Text(product['name']),
                      trailing: Text(
                        '\$${((product['price'] ?? 0.0) * (product['quantity'] ?? 1)).toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total: \$${widget.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Select Payment Method:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile(
                    title: const Text('Home Delivery'),
                    value: 'home',
                    groupValue: paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Card Payment'),
                    value: 'card',
                    groupValue: paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value.toString();
                      });
                    },
                  ),
                  if (paymentMethod == 'card')
                    Column(
                      children: [
                        TextField(
                          controller: cardNumberController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Card Number',
                          ),
                        ),
                        TextField(
                          controller: expiryController,
                          decoration: const InputDecoration(
                            labelText: 'Expiry Date',
                          ),
                        ),
                        TextField(
                          controller: cvvController,
                          decoration: const InputDecoration(labelText: 'CVV'),
                          obscureText: true,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: handlePayNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Pay Now',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
