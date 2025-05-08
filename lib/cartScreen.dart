import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'OrderScreen.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isProcessingPayment = false;
  bool _showCaptcha = false;
  String _captchaText = '';
  String _userInput = '';
  final _captchaController = TextEditingController();

  // Format price to handle different data types
  String _formatPrice(dynamic price) {
    if (price is int) {
      return price.toString();
    } else if (price is double) {
      return price.toStringAsFixed(2);
    } else if (price is String) {
      return price;
    }
    return "0";
  }

  // Fetch cart items from Firestore
  Stream<QuerySnapshot> _fetchCartItems() {
    String userEmail = auth.currentUser?.email ?? "";
    return firestore
        .collection("users")
        .doc(userEmail)
        .collection("Cart")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  // Delete an item from Firestore
  void _deleteItem(String productName) async {
    String userEmail = auth.currentUser?.email ?? "";
    await firestore
        .collection("users")
        .doc(userEmail)
        .collection("Cart")
        .doc(productName)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName removed from cart'),
        backgroundColor: Colors.indigo[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            // Implement undo functionality if needed
          },
        ),
      ),
    );
  }

  // Calculate total price
  double _calculateTotal(List<DocumentSnapshot> items) {
    double total = 0;
    for (var item in items) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      // Handle both string and int/double price formats
      var price = data["price"];
      if (price is int) {
        total += price.toDouble();
      } else if (price is double) {
        total += price;
      } else if (price is String) {
        // Remove the currency symbol if present
        String priceString = price.replaceAll(RegExp(r'[^\d.]'), '');
        total += double.tryParse(priceString) ?? 0;
      }
    }
    return total;
  }

  // Generate CAPTCHA text
  String _generateCaptcha() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        6, // Length of CAPTCHA
            (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  // Show CAPTCHA dialog
  void _showCaptchaDialog(List<DocumentSnapshot> items) {
    setState(() {
      _captchaText = _generateCaptcha();
      _userInput = '';
      _captchaController.clear();
      _showCaptcha = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Verify to Continue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please enter the characters below:'),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/captcha_bg.png'), // Add a noisy background image
                  opacity: 0.1,
                ),
              ),
              child: Text(
                _captchaText,
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  color: Colors.indigo[800],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _captchaController,
              decoration: InputDecoration(
                hintText: 'Enter the text above',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              textAlign: TextAlign.center,
              style: TextStyle(letterSpacing: 5, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _showCaptcha = false;
              });
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_captchaController.text.toUpperCase() == _captchaText) {
                Navigator.pop(context);
                setState(() {
                  _showCaptcha = false;
                });
                _processCheckout(items);
              } else {
                // Show error and regenerate CAPTCHA
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Incorrect verification. Please try again.'),
                    backgroundColor: Colors.red[600],
                  ),
                );
                setState(() {
                  _captchaText = _generateCaptcha();
                  _captchaController.clear();
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[800],
            ),
            child: Text('Verify'),
          ),
        ],
      ),
    );
  }

  // Process checkout after CAPTCHA verification
  void _processCheckout(List<DocumentSnapshot> items) async {
    setState(() {
      _isProcessingPayment = true;
    });

    try {
      // Create an order in Firestore
      String userEmail = auth.currentUser?.email ?? "";
      String orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Extract order items
      List<Map<String, dynamic>> orderItems = [];
      double total = _calculateTotal(items);

      for (var item in items) {
        Map<String, dynamic> data = item.data() as Map<String, dynamic>;
        orderItems.add({
          'name': data['name'],
          'price': data['price'],
          'image': data['image'],
          'description': data['description'],
          'quantity': 1, // Default to 1, you can modify if needed
        });
      }

      // Save order to Firestore
      await firestore.collection("users").doc(userEmail).collection("Orders").doc(orderId).set({
        'orderId': orderId,
        'items': orderItems,
        'subtotal': total,
        'shipping': 40,
        'total': total + 40,
        'status': 'Processing',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear cart after successful order placement
      for (var item in items) {
        Map<String, dynamic> data = item.data() as Map<String, dynamic>;
        await firestore
            .collection("users")
            .doc(userEmail)
            .collection("Cart")
            .doc(data['name'])
            .delete();
      }

      // Simulate processing time
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Navigate to Orders screen
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrdersScreen())
        );
      }
    } catch (e) {
      setState(() {
        _isProcessingPayment = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error placing order. Please try again.'),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return _buildCartItem(item);
                  },
                ),
              ),
              _buildCheckoutSection(snapshot.data!.docs),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo[800]!),
          ),
          SizedBox(height: 16),
          Text(
            "Loading your cart...",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Looks like you haven't added anything to your cart yet.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to products page
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[800],
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Browse Products",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    String? imageUrl = item["image"];

    return Dismissible(
      key: Key(item["name"]),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red[400],
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
      ),
      onDismissed: (direction) {
        _deleteItem(item["name"]);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? imageUrl.startsWith("http")
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  )
                      : Icon(
                    Icons.image,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              SizedBox(width: 16),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["name"] ?? "No Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      item["description"] ?? "No Description",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${_formatPrice(item["price"])}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[800],
                          ),
                        ),
                        Row(
                          children: [
                            _buildQuantityButton(
                              icon: Icons.remove,
                              onPressed: () {
                                // Decrease quantity logic
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "1", // This would be dynamic in a real app
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildQuantityButton(
                              icon: Icons.add,
                              onPressed: () {
                                // Increase quantity logic
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 18,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(List<DocumentSnapshot> items) {
    double total = _calculateTotal(items);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtotal",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  "₹${total.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Shipping",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  "₹40",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
                Text(
                  "₹${(total + 40).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isProcessingPayment ? null : () => _showCaptchaDialog(items),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[800],
                  disabledBackgroundColor: Colors.indigo[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isProcessingPayment
                    ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    : Text(
                  "Checkout",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _captchaController.dispose();
    super.dispose();
  }
}

// NEW ORDERS SCREEN




