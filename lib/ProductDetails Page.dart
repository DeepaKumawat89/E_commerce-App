// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import 'HomePAge.dart';
//
// class ProductDetails extends StatefulWidget {
//   final Product product;
//
//   ProductDetails({required this.product});
//
//   @override
//   _ProductDetailsState createState() => _ProductDetailsState();
// }
//
// class _ProductDetailsState extends State<ProductDetails> {
//   bool isWishlisted = false;
//   int selectedQuantity = 1;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkWishlistStatus();
//   }
//
//   Future<String> _convertImageToBase64(String assetPath) async {
//     ByteData bytes = await rootBundle.load(assetPath);
//     Uint8List uint8List = bytes.buffer.asUint8List();
//     return base64Encode(uint8List);
//   }
//
//   void _checkWishlistStatus() async {
//     String userEmail = auth.currentUser?.email ?? "";
//     if (userEmail.isEmpty) return;
//
//     DocumentSnapshot wishlistItem = await firestore
//         .collection("users")
//         .doc(userEmail)
//         .collection("wishlist")
//         .doc(widget.product.name)
//         .get();
//
//     setState(() {
//       isWishlisted = wishlistItem.exists;
//     });
//   }
//
//   void _toggleWishlist() async {
//     String userEmail = auth.currentUser?.email ?? "";
//     if (userEmail.isEmpty) return;
//
//     DocumentReference wishlistRef = firestore
//         .collection("users")
//         .doc(userEmail)
//         .collection("wishlist")
//         .doc(widget.product.name);
//
//     if (isWishlisted) {
//       await wishlistRef.delete();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           behavior: SnackBarBehavior.floating,
//           margin: EdgeInsets.all(16),
//           backgroundColor: Color(0xFF5E72E4),
//           content: Text('${widget.product.name} removed from wishlist'),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );
//     } else {
//       await wishlistRef.set({
//         "name": widget.product.name,
//         "price": widget.product.price,
//         "image": widget.product.image,
//         "description": widget.product.description,
//         "rating": widget.product.rating,
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           behavior: SnackBarBehavior.floating,
//           margin: EdgeInsets.all(16),
//           backgroundColor: Color(0xFF5E72E4),
//           content: Text('${widget.product.name} added to wishlist'),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );
//     }
//
//     setState(() {
//       isWishlisted = !isWishlisted;
//     });
//   }
//
//   void _addToCart() async {
//     String userEmail = auth.currentUser?.email ?? "";
//     if (userEmail.isEmpty) return;
//
//     DocumentReference orderRef = firestore
//         .collection("users")
//         .doc(userEmail)
//         .collection("Cart")
//         .doc(widget.product.name);
//
//     await orderRef.set({
//       "name": widget.product.name,
//       "price": widget.product.price,
//       "mrp": widget.product.mrp,
//       "discount": widget.product.discount,
//       "image": widget.product.image,
//       "description": widget.product.description,
//       "rating": widget.product.rating,
//       "quantity": selectedQuantity,
//       "timestamp": FieldValue.serverTimestamp(),
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.all(16),
//         backgroundColor: Color(0xFF5E72E4),
//         content: Text('${widget.product.name} added to cart'),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Calculate discount percentage
//     final discountPercentage = ((widget.product.mrp - widget.product.price) / widget.product.mrp * 100).round();
//
//     return Scaffold(
//       backgroundColor: Color(0xFFF5F7FA),
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: Container(
//             margin: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.9),
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 4,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Icon(Icons.arrow_back, color: Color(0xFF303030)),
//           ),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: _toggleWishlist,
//             child: Container(
//               margin: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.9),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 isWishlisted ? Icons.favorite : Icons.favorite_border,
//                 color: isWishlisted ? Colors.red : Color(0xFF303030),
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.9),
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 4,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: IconButton(
//               icon: Icon(Icons.share, color: Color(0xFF303030)),
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     behavior: SnackBarBehavior.floating,
//                     margin: EdgeInsets.all(16),
//                     backgroundColor: Color(0xFF5E72E4),
//                     content: Text('Sharing ${widget.product.name}'),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: Offset(0, -5),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         child: Row(
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: _addToCart,
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   backgroundColor: Color(0xFF5E72E4),
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   "Add to Cart",
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 15),
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       behavior: SnackBarBehavior.floating,
//                       margin: EdgeInsets.all(16),
//                       backgroundColor: Color(0xFF4CAF50),
//                       content: Text('Proceeding to buy ${widget.product.name}'),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   backgroundColor: Color(0xFF4CAF50),
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   "Buy Now",
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hero Image
//             Container(
//               height: 350,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Stack(
//                 children: [
//                   Center(
//                     child: Image.asset(
//                       widget.product.image,
//                       height: 280,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       height: 40,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.white.withOpacity(0.0),
//                             Color(0xFFF5F7FA),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 20,
//                     left: 20,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                         color: Color(0xFF5E72E4),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         "$discountPercentage% OFF",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Product Details Section
//             Container(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Product Name
//                   Text(
//                     widget.product.name,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF303030),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//
//                   // Subtitle/short description
//                   Text(
//                     "Premium Quality Product",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//
//                   // Rating
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Color(0xFF4CAF50),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               widget.product.rating.toString(),
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(width: 4),
//                             Icon(
//                               Icons.star,
//                               color: Colors.white,
//                               size: 14,
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Text(
//                         "Based on 4,500+ reviews",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                       Spacer(),
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         size: 14,
//                         color: Colors.grey.shade600,
//                       ),
//                     ],
//                   ),
//
//                   Divider(height: 32),
//
//                   // Price section
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         "₹${widget.product.price}",
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF5E72E4),
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Text(
//                         "₹${widget.product.mrp}",
//                         style: TextStyle(
//                           fontSize: 16,
//                           decoration: TextDecoration.lineThrough,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         "$discountPercentage% off",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF4CAF50),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   SizedBox(height: 8),
//                   Text(
//                     "Inclusive of all taxes",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//
//                   Divider(height: 32),
//
//                   // Quantity selector
//                   Row(
//                     children: [
//                       Text(
//                         "Quantity",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF303030),
//                         ),
//                       ),
//                       Spacer(),
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             _buildQuantityButton(
//                               icon: Icons.remove,
//                               onPressed: () {
//                                 if (selectedQuantity > 1) {
//                                   setState(() {
//                                     selectedQuantity--;
//                                   });
//                                 }
//                               },
//                             ),
//                             Container(
//                               width: 40,
//                               alignment: Alignment.center,
//                               child: Text(
//                                 selectedQuantity.toString(),
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             _buildQuantityButton(
//                               icon: Icons.add,
//                               onPressed: () {
//                                 setState(() {
//                                   selectedQuantity++;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   SizedBox(height: 24),
//
//                   // Description header
//                   Text(
//                     "Description",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF303030),
//                     ),
//                   ),
//                   SizedBox(height: 12),
//
//                   // Description content
//                   Text(
//                     widget.product.description,
//                     style: TextStyle(
//                       fontSize: 16,
//                       height: 1.5,
//                       color: Color(0xFF303030),
//                     ),
//                   ),
//
//                   SizedBox(height: 24),
//
//                   // Features section
//                   _buildFeatureSection(),
//
//                   SizedBox(height: 24),
//
//                   // Delivery information
//                   _buildDeliveryInfo(),
//
//                   SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuantityButton({required IconData icon, required VoidCallback onPressed}) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         width: 36,
//         height: 36,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Icon(
//           icon,
//           size: 18,
//           color: Color(0xFF303030),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeatureSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Key Features",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF303030),
//           ),
//         ),
//         SizedBox(height: 16),
//         _buildFeatureItem(
//           icon: Icons.check_circle_outline,
//           text: "High quality materials",
//         ),
//         SizedBox(height: 10),
//         _buildFeatureItem(
//           icon: Icons.check_circle_outline,
//           text: "Premium build quality",
//         ),
//         SizedBox(height: 10),
//         _buildFeatureItem(
//           icon: Icons.check_circle_outline,
//           text: "1 year warranty",
//         ),
//         SizedBox(height: 10),
//         _buildFeatureItem(
//           icon: Icons.check_circle_outline,
//           text: "Fast shipping available",
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFeatureItem({required IconData icon, required String text}) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           color: Color(0xFF5E72E4),
//           size: 20,
//         ),
//         SizedBox(width: 10),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 16,
//             color: Color(0xFF303030),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDeliveryInfo() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.local_shipping_outlined,
//                 color: Color(0xFF5E72E4),
//               ),
//               SizedBox(width: 12),
//               Text(
//                 "Delivery Information",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF303030),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           Row(
//             children: [
//               Text(
//                 "Free delivery by",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               Spacer(),
//               Text(
//                 "Tomorrow",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF4CAF50),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'HomePAge.dart';
import 'OrderScreen.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  ProductDetails({required this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isWishlisted = false;
  int selectedQuantity = 1;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkWishlistStatus();
  }

  Future<String> _convertImageToBase64(String assetPath) async {
    ByteData bytes = await rootBundle.load(assetPath);
    Uint8List uint8List = bytes.buffer.asUint8List();
    return base64Encode(uint8List);
  }

  void _checkWishlistStatus() async {
    String userEmail = auth.currentUser?.email ?? "";
    if (userEmail.isEmpty) return;

    DocumentSnapshot wishlistItem = await firestore
        .collection("users")
        .doc(userEmail)
        .collection("wishlist")
        .doc(widget.product.name)
        .get();

    setState(() {
      isWishlisted = wishlistItem.exists;
    });
  }

  void _toggleWishlist() async {
    String userEmail = auth.currentUser?.email ?? "";
    if (userEmail.isEmpty) return;

    DocumentReference wishlistRef = firestore
        .collection("users")
        .doc(userEmail)
        .collection("wishlist")
        .doc(widget.product.name);

    if (isWishlisted) {
      await wishlistRef.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          backgroundColor: Color(0xFF5E72E4),
          content: Text('${widget.product.name} removed from wishlist'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      await wishlistRef.set({
        "name": widget.product.name,
        "price": widget.product.price,
        "image": widget.product.image,
        "description": widget.product.description,
        "rating": widget.product.rating,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          backgroundColor: Color(0xFF5E72E4),
          content: Text('${widget.product.name} added to wishlist'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    setState(() {
      isWishlisted = !isWishlisted;
    });
  }

  void _addToCart() async {
    String userEmail = auth.currentUser?.email ?? "";
    if (userEmail.isEmpty) return;

    DocumentReference orderRef = firestore
        .collection("users")
        .doc(userEmail)
        .collection("Cart")
        .doc(widget.product.name);

    await orderRef.set({
      "name": widget.product.name,
      "price": widget.product.price,
      "mrp": widget.product.mrp,
      "discount": widget.product.discount,
      "image": widget.product.image,
      "description": widget.product.description,
      "rating": widget.product.rating,
      "quantity": selectedQuantity,
      "timestamp": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        backgroundColor: Color(0xFF5E72E4),
        content: Text('${widget.product.name} added to cart'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showCaptchaDialog() {
    // Generate a random CAPTCHA
    String captchaText = _generateCaptchaText();
    String userInput = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Verify to Complete Order',
                style: TextStyle(
                  color: Color(0xFF303030),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          // Random lines for CAPTCHA noise
                          CustomPaint(
                            size: Size(double.infinity, 80),
                          ),
                          // CAPTCHA text
                          Center(
                            child: Text(
                              captchaText,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Courier',
                                letterSpacing: 8,
                                color: Color(0xFF303030),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (value) {
                        userInput = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter CAPTCHA text',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFF5E72E4), width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Generate a new CAPTCHA if refresh is pressed
                    _showCaptchaDialog();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, size: 16, color: Color(0xFF5E72E4)),
                      SizedBox(width: 4),
                      Text(
                        'Refresh',
                        style: TextStyle(
                          color: Color(0xFF5E72E4),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (userInput.toUpperCase() == captchaText) {
                      Navigator.of(context).pop();
                      _processOrder();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(16),
                          backgroundColor: Colors.red,
                          content: Text('Invalid CAPTCHA. Please try again.'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                      Navigator.of(context).pop();
                      _showCaptchaDialog(); // Show a new CAPTCHA
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5E72E4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Verify',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _generateCaptchaText() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    Random random = Random();
    String captcha = '';

    for (int i = 0; i < 6; i++) {
      captcha += chars[random.nextInt(chars.length)];
    }

    return captcha;
  }

  void _processOrder() async {
    try {
      String userEmail = auth.currentUser?.email ?? "";
      if (userEmail.isEmpty) return;

      // Generate order ID
      String orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';

      // Calculate total amount
      double totalAmount = (widget.product.price * selectedQuantity) as double;

      // Add to orders collection
      await firestore
          .collection("users")
          .doc(userEmail)
          .collection("orders")
          .doc(orderId)
          .set({
        "orderId": orderId,
        "products": [
          {
            "name": widget.product.name,
            "price": widget.product.price,
            "mrp": widget.product.mrp,
            "discount": widget.product.discount,
            "image": widget.product.image,
            "quantity": selectedQuantity,
          }
        ],
        "totalAmount": totalAmount,
        "orderDate": FieldValue.serverTimestamp(),
        "status": "Confirmed",
        "deliveryEstimate": DateTime.now().add(Duration(days: 5)).millisecondsSinceEpoch,
        "paymentMethod": "Cash on Delivery",
      });

      // Show order confirmation dialog
      _showOrderConfirmationDialog(orderId);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          backgroundColor: Colors.red,
          content: Text('Error processing order: ${e.toString()}'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showOrderConfirmationDialog(String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 70,
                ),
                SizedBox(height: 20),
                Text(
                  'Order Confirmed!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303030),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Your order has been placed successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Order ID:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Spacer(),
                      Text(
                        orderId,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF303030),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _navigateToOrdersScreen();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5E72E4),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'View My Orders',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context); // Go back to previous screen
                  },
                  child: Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5E72E4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToOrdersScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrdersScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate discount percentage
    final discountPercentage = ((widget.product.mrp - widget.product.price) / widget.product.mrp * 100).round();

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.arrow_back, color: Color(0xFF303030)),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _toggleWishlist,
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: isWishlisted ? Colors.red : Color(0xFF303030),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.share, color: Color(0xFF303030)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(16),
                    backgroundColor: Color(0xFF5E72E4),
                    content: Text('Sharing ${widget.product.name}'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xFF5E72E4),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Add to Cart",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: _showCaptchaDialog, // Changed to show CAPTCHA dialog
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xFF4CAF50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Buy Now",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      widget.product.image,
                      height: 280,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Color(0xFFF5F7FA),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color(0xFF5E72E4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "$discountPercentage% OFF",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details Section
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF303030),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Subtitle/short description
                  Text(
                    "Premium Quality Product",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Rating
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.product.rating.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Based on 4,500+ reviews",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),

                  Divider(height: 32),

                  // Price section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${widget.product.price}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E72E4),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "₹${widget.product.mrp}",
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "$discountPercentage% off",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),
                  Text(
                    "Inclusive of all taxes",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  Divider(height: 32),

                  // Quantity selector
                  Row(
                    children: [
                      Text(
                        "Quantity",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF303030),
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            _buildQuantityButton(
                              icon: Icons.remove,
                              onPressed: () {
                                if (selectedQuantity > 1) {
                                  setState(() {
                                    selectedQuantity--;
                                  });
                                }
                              },
                            ),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text(
                                selectedQuantity.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildQuantityButton(
                              icon: Icons.add,
                              onPressed: () {
                                setState(() {
                                  selectedQuantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Description header
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF303030),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Description content
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Color(0xFF303030),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Features section
                  _buildFeatureSection(),

                  SizedBox(height: 24),

                  // Delivery information
                  _buildDeliveryInfo(),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Color(0xFF303030),
        ),
      ),
    );
  }

  Widget _buildFeatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Key Features",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF303030),
          ),
        ),
        SizedBox(height: 16),
        _buildFeatureItem(
          icon: Icons.check_circle_outline,
          text: "High quality materials",
        ),
        SizedBox(height: 10),
        _buildFeatureItem(
          icon: Icons.check_circle_outline,
          text: "Premium build quality",
        ),
        SizedBox(height: 10),
        _buildFeatureItem(
          icon: Icons.check_circle_outline,
          text: "1 year warranty",
        ),
        SizedBox(height: 10),
        _buildFeatureItem(
          icon: Icons.check_circle_outline,
          text: "Fast shipping available",
        ),
      ],
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xFF5E72E4),
          size: 20,
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF303030),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                color: Color(0xFF5E72E4),
              ),
              SizedBox(width: 12),
              Text(
                "Delivery Information",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF303030),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text(
                "Free delivery by",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Spacer(),
              Text(
                "Tomorrow",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}