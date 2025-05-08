import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Main app theme colors
class AppTheme {
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color accentColor = Color(0xFF03A9F4);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF757575);
  static const Color success = Color(0xFF4CAF50);
  static const Color textDark = Color(0xFF424242);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8F94FB), Color(0xFF4E54C8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AddressesScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String userEmail = auth.currentUser?.email ?? "";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "My Addresses",
          style: TextStyle(
            color: AppTheme.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
        ),
        iconTheme: IconThemeData(color: AppTheme.white),
      ),
      body: Column(
        children: [
          // Add Address Button with gradient background
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAddressScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                  color: AppTheme.primaryColor.withOpacity(0.05),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_circle, color: AppTheme.primaryColor, size: 24),
                    SizedBox(width: 12),
                    Text(
                      "Add a New Address",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: AppTheme.lightGrey.withOpacity(0.3),
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection("users")
                    .doc(userEmail)
                    .collection("Address")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                        )
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 70,
                            color: AppTheme.darkGrey.withOpacity(0.5),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No saved addresses",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.darkGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Add a new address to get started",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.darkGrey.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: snapshot.data!.docs.map((doc) {
                      var address = doc.data() as Map<String, dynamic>;
                      return AddressCard(
                        address: address,
                        docId: doc.id,
                        userEmail: userEmail,
                        firestore: firestore,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final Map<String, dynamic> address;
  final String docId;
  final String userEmail;
  final FirebaseFirestore firestore;

  const AddressCard({
    required this.address,
    required this.docId,
    required this.userEmail,
    required this.firestore,
  });

  @override
  Widget build(BuildContext context) {
    // Determine icon based on address type
    IconData addressIcon = address["addressType"] == "Home"
        ? Icons.home_rounded
        : Icons.business_center_rounded;

    Color typeColor = address["addressType"] == "Home"
        ? AppTheme.primaryColor
        : AppTheme.accentColor;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Address header with type indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(addressIcon, color: typeColor),
                SizedBox(width: 8),
                Text(
                  address["addressType"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: typeColor,
                  ),
                ),
                Spacer(),
                // Edit and Delete options
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: AppTheme.darkGrey),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: AppTheme.darkGrey, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Delete Address'),
                          content: Text('Are you sure you want to delete this address?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                            TextButton(
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                firestore
                                    .collection("users")
                                    .doc(userEmail)
                                    .collection("Address")
                                    .doc(docId)
                                    .delete();
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    } else if (value == 'edit') {
                      // Navigate to edit screen (you can implement this)
                      // For now just show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Edit feature coming soon!'))
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // Address content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address["fullname"],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                SizedBox(height: 8),
                AddressInfoRow(
                  icon: Icons.location_on_outlined,
                  text: "${address["houseNo"]}, ${address["roadName"]}, ${address["area"]}",
                ),
                AddressInfoRow(
                  icon: Icons.location_city_outlined,
                  text: "${address["city"]}, ${address["state"]} - ${address["pincode"]}",
                ),
                Divider(height: 24),
                AddressInfoRow(
                  icon: Icons.phone_outlined,
                  text: "${address["phoneNumber"]}",
                ),
                if (address["altPhoneNumber"].toString().isNotEmpty)
                  AddressInfoRow(
                    icon: Icons.phone_android_outlined,
                    text: "${address["altPhoneNumber"]}",
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddressInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const AddressInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppTheme.darkGrey),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textDark.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController altPhoneController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController houseNoController = TextEditingController();
  final TextEditingController roadNameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  String addressType = "Home"; // Default selection

  void saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      // Show a snackbar for validation error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      ),
    );

    String userEmail = auth.currentUser?.email ?? "";
    if (userEmail.isEmpty) {
      Navigator.pop(context); // Close loading dialog
      return;
    }

    String newAddressId = DateTime.now().millisecondsSinceEpoch.toString(); // Unique ID

    try {
      await firestore.collection("users").doc(userEmail).collection("Address").doc(newAddressId).set({
        "fullname": fullnameController.text,
        "phoneNumber": phoneController.text,
        "altPhoneNumber": altPhoneController.text,
        "pincode": pincodeController.text,
        "state": stateController.text,
        "city": cityController.text,
        "houseNo": houseNoController.text,
        "roadName": roadNameController.text,
        "area": areaController.text,
        "addressType": addressType,
      });

      Navigator.pop(context); // Close loading dialog
      Navigator.pop(context); // Go back after saving

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Address saved successfully'),
          backgroundColor: AppTheme.success,
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving address: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Add Delivery Address",
          style: TextStyle(
            color: AppTheme.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
        ),
        iconTheme: IconThemeData(color: AppTheme.white),
      ),
      body: Container(
        color: AppTheme.lightGrey.withOpacity(0.3),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Section header card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_outline, color: AppTheme.primaryColor),
                          SizedBox(width: 8),
                          Text(
                            "Contact Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildTextField("Full Name", fullnameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        prefixIcon: Icons.account_circle_outlined,
                      ),
                      SizedBox(height: 12),
                      _buildTextField("Phone Number", phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 12),
                      _buildTextField("Alternate Phone Number", altPhoneController,
                        prefixIcon: Icons.phone_android_outlined,
                        keyboardType: TextInputType.phone,
                        isRequired: false,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Address details card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: AppTheme.primaryColor),
                          SizedBox(width: 8),
                          Text(
                            "Address Details",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField("Pincode", pincodeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                              prefixIcon: Icons.pin_drop_outlined,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField("City", cityController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                              prefixIcon: Icons.location_city_outlined,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      _buildTextField("State", stateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter state';
                          }
                          return null;
                        },
                        prefixIcon: Icons.map_outlined,
                      ),
                      SizedBox(height: 12),
                      _buildTextField("House No/Building Name", houseNoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        prefixIcon: Icons.home_outlined,
                      ),
                      SizedBox(height: 12),
                      _buildTextField("Road Name/Street", roadNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        prefixIcon: Icons.add_road_outlined,
                      ),
                      SizedBox(height: 12),
                      _buildTextField("Area/Locality", areaController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        prefixIcon: Icons.apartment_outlined,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Address Type Selection Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Address Type",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildAddressTypeButton("Home", Icons.home_rounded)),
                          SizedBox(width: 12),
                          Expanded(child: _buildAddressTypeButton("Work", Icons.business_center_rounded)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Save Address Button
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: Text(
                  "Save Address",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hint,
      TextEditingController controller, {
        String? Function(String?)? validator,
        IconData? prefixIcon,
        TextInputType keyboardType = TextInputType.text,
        bool isRequired = true,
      }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        labelText: hint + (isRequired ? " *" : ""),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppTheme.darkGrey) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.darkGrey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.darkGrey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        filled: true,
        fillColor: AppTheme.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildAddressTypeButton(String type, IconData icon) {
    bool isSelected = addressType == type;
    return GestureDetector(
      onTap: () => setState(() => addressType = type),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.white : AppTheme.darkGrey,
            ),
            SizedBox(width: 8),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? AppTheme.white : AppTheme.darkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}