import 'package:flutter/material.dart';
import 'ProductDetails Page.dart';

// Product model remains the same
class Product {
  final String name;
  final int price;
  final String image;
  final int mrp;
  final String description;
  final String discount;
  final double rating;

  Product({
    required this.name,
    required this.mrp,
    required this.price,
    required this.image,
    required this.description,
    required this.discount,
    required this.rating,
  });
}

class ProductList extends StatelessWidget {
  final List<Product> products = [
    Product(
        name: "Smartphone",
        mrp: 20000,
        price: 15000,
        image: "assets/Laptop/img_4.png",
        description: "Advanced smartphone with high-speed performance.",
        discount: "30% OFF",
        rating: 4.3),
    Product(
        name: "Laptop",
        mrp: 65000,
        price: 55000,
        image: "assets/Laptop/img_1.png",
        description: "Powerful laptop for gaming and professional work.",
        discount: "20% OFF",
        rating: 4.5),
    Product(
        name: "Headphones",
        mrp: 4000,
        price: 2000,
        image: "assets/Laptop/img_3.png",
        description: "Noise-cancelling headphones with great sound quality.",
        discount: "50% OFF",
        rating: 3.8),
    Product(
        name: "Camera",
        price: 25000,
        mrp: 40000,
        image: "assets/Laptop/img_2.png",
        description: "High-resolution DSLR camera for professional photography.",
        discount: "40% OFF",
        rating: 4.7),
    Product(
        mrp: 2600,
        name: "SmartWatch",
        price: 1300,
        image: "assets/Laptop/item.webp",
        description: "High-resolution DSLR camera for professional photography.",
        discount: "50% OFF",
        rating: 4.7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Deals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303030),
                  ),
                ),

              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final discountPercentage = ((product.mrp - product.price) / product.mrp * 100).round();

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(product: product),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image with Discount Badge and Favorite Icon
                          Stack(
                            children: [
                              Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(product.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Discount tag
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5E72E4),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "$discountPercentage% OFF",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              // Favorite button
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.favorite_border,
                                      size: 16,
                                      color: Color(0xFF303030),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Product Details
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF303030),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),

                                // Rating and reviews
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4CAF50),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            product.rating.toString(),
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          const Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "(4.5K)",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),


                                // Price information
                                Row(
                                  children: [
                                    Text(
                                      "₹${product.price}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5E72E4),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "₹${product.mrp}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5E72E4),
        child: const Icon(Icons.filter_list),
        onPressed: () {},
      ),
    );
  }
}