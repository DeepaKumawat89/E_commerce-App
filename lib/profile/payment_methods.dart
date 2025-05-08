import 'package:flutter/material.dart';

import '../addresses.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSavedCards(),
            SizedBox(height: 24),
            _buildAddPaymentButton(context),
            SizedBox(height: 24),
            _buildOtherPaymentOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedCards() {
    // Demo data - in real app would come from database
    final cards = [
      {
        'type': 'visa',
        'lastFour': '4242',
        'expiryDate': '04/25',
        'isDefault': true,
      },
      {
        'type': 'mastercard',
        'lastFour': '8765',
        'expiryDate': '12/24',
        'isDefault': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved Cards',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...cards.map((card) => _buildCardItem(
          card['type'] as String,
          card['lastFour'] as String,
          card['expiryDate'] as String,
          card['isDefault'] as bool,
        )).toList(),
      ],
    );
  }

  Widget _buildCardItem(String type, String lastFour, String expiryDate, bool isDefault) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 30,
          decoration: BoxDecoration(
            color: type == 'visa' ? Colors.blue[800] : Colors.red[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              type == 'visa' ? 'VISA' : 'MC',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        title: Text(
          '•••• •••• •••• $lastFour',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text('Expires $expiryDate'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDefault)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Default',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(width: 8),
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Set as default'),
                  value: 'default',
                ),
                PopupMenuItem(
                  child: Text('Edit'),
                  value: 'edit',
                ),
                PopupMenuItem(
                  child: Text('Remove'),
                  value: 'remove',
                ),
              ],
              onSelected: (value) {
                // Handle menu selection
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPaymentButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to add payment method screen
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.indigo[800]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: Colors.indigo[800],
            ),
            SizedBox(width: 8),
            Text(
              'Add Payment Method',
              style: TextStyle(
                color: Colors.indigo[800],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherPaymentOptions() {
    final paymentOptions = [
      {'icon': Icons.account_balance, 'name': 'Bank Transfer'},
      {'icon': Icons.payment, 'name': 'PayPal'},
      {'icon': Icons.account_balance_wallet, 'name': 'Store Credit'},
      {'icon': Icons.local_atm, 'name': 'Cash on Delivery'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Other Payment Options',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...paymentOptions.map((option) => ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              option['icon'] as IconData,
              color: Colors.indigo[800],
            ),
          ),
          title: Text(option['name'] as String),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navigate to specific payment option
          },
        )).toList(),
      ],
    );
  }
}