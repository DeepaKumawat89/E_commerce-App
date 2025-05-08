
import 'package:e_com/profile/Orders.dart';
import 'package:e_com/profile/faq.dart';
import 'package:e_com/profile/help_support.dart';
import 'package:e_com/profile/payment_methods.dart';
import 'package:e_com/profile/wallet.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login.dart';
import 'OrderScreen.dart';
import 'Wishlist.dart';
import 'addresses.dart';
// Add these new imports

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildUserProfile(context),
            const SizedBox(height: 16),
            _buildSections(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.indigo[800],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Profile",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Edit profile action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    final User? user = _auth.currentUser;

    if (user == null) {
      return _buildErrorState("User not logged in");
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user.email).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        } else if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return _buildErrorState("User data not found");
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return _buildUserInfo(userData, context);
        }
      },
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> userData, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      transform: Matrix4.translationValues(0, -30, 0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: userData['profilePic'] != null
                    ? NetworkImage(userData['profilePic'])
                    : null,
                child: userData['profilePic'] == null
                    ? Icon(Icons.person, size: 50, color: Colors.indigo[800])
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                userData['username'] ?? "Unknown",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                userData['email'] ?? "No email",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickAction(Icons.shopping_bag, "Orders", context, onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(builder: (context) => Orders()),
                    );
                  }),
                  _buildQuickAction(Icons.favorite, "Wishlist", context, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WishlistScreen()),
                    );
                  }),
                  _buildQuickAction(Icons.location_on, "Address", context, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddressesScreen()),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, BuildContext context, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.indigo[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.indigo[800], size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSections(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSection(
            "Account",
            [
              _buildMenuItem(Icons.assignment_return, "Returns", () {}),
              _buildMenuItem(Icons.payment, "Payment Methods", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentMethodsScreen()),
                );
              }),
              _buildMenuItem(Icons.account_balance_wallet, "Wallet", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WalletScreen()),
                );
              }),
            ],
            context,
          ),
          const SizedBox(height: 16),
          _buildSection(
            "Settings",
            [
              _buildMenuItem(Icons.notifications, "Notifications", () {}),
              _buildMenuItem(Icons.tune, "Preferences", () {}),
              _buildMenuItem(Icons.language, "Language", () {}),
              _buildMenuItem(Icons.location_on_outlined, "Location", () {}),
            ],
            context,
          ),
          const SizedBox(height: 16),
          _buildSection(
            "Help & Support",
            [
              _buildMenuItem(Icons.help_outline, "Get Help", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpSupportScreen()),
                );
              }),
              _buildMenuItem(Icons.question_answer_outlined, "FAQ", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQScreen()),
                );
              }),
            ],
            context,
          ),
          const SizedBox(height: 20),
          _buildLogoutButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items, BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 12),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[800],
                ),
              ),
            ),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.indigo[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.indigo[800], size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        icon: Icon(Icons.logout, color: Colors.white),
        label: Text(
          "Log Out",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Login2()),
                  (route) => false,
            );
          } catch (e) {
            print("Logout Error: $e");
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(color: Colors.red[400], fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}