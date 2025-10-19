import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save order
  Future<void> saveOrder(
    List<Map<String, dynamic>> products,
    double total,
    String payment,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('orders').add({
      'userId': user.uid,
      'userEmail': user.email,
      'products': products,
      'total': total,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending',
      'method of payment': payment,
    });
  }

  Stream<QuerySnapshot> getUserOrders() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
