import 'package:flutter/material.dart';

import '../addresses.dart';
import 'help_support.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, dynamic>> _faqData = [
    {
      'question': 'How do I track my order?',
      'answer': 'You can track your order by going to "My Orders" in your profile and clicking on "Track Order" for the specific order you want to track. You will be able to see real-time updates on your order status.',
      'isExpanded': false,
    },
    {
      'question': 'What is your return policy?',
      'answer': 'Our return policy allows you to return items within 30 days of delivery. Items must be in their original condition with tags attached. Some products like personal care items and underwear cannot be returned due to hygiene reasons.',
      'isExpanded': false,
    },
    {
      'question': 'How can I change my delivery address?',
      'answer': 'You can change your delivery address before your order is shipped. Go to "My Orders," find the order you want to modify, and select "Change Address" if the option is available. If your order is already being processed, please contact our customer support immediately.',
      'isExpanded': false,
    },
    {
      'question': 'Do you offer international shipping?',
      'answer': 'Yes, we offer international shipping to select countries. Shipping costs and delivery times vary by location. You can check if we deliver to your country during checkout.',
      'isExpanded': false,
    },
    {
      'question': 'How do I apply a promo code?',
      'answer': 'You can apply a promo code during checkout. On the payment page, you will find a field labeled "Promo Code" or "Coupon Code" where you can enter your code and click "Apply" to receive the discount.',
      'isExpanded': false,
    },
    {
      'question': 'What payment methods do you accept?',
      'answer': 'We accept various payment methods including credit/debit cards (Visa, Mastercard, American Express), PayPal, Apple Pay, and bank transfers. You can also pay using store credit or gift cards.',
      'isExpanded': false,
    },
    {
      'question': 'How do I reset my password?',
      'answer': 'To reset your password, go to the login screen and click on "Forgot Password." Enter your registered email address, and we will send you a password reset link. Follow the instructions in the email to create a new password.',
      'isExpanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Frequently Asked Questions",
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
          _buildSearchBar(),
          Expanded(
            child: _buildFAQList(),
          ),
          _buildSupportSection(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for questions',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (value) {
          // Filter questions based on search
        },
      ),
    );
  }

  Widget _buildFAQList() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ExpansionPanelList(
          elevation: 1,
          expandedHeaderPadding: EdgeInsets.zero,
          dividerColor: Colors.grey[300],
          expansionCallback: (index, isExpanded) {
            setState(() {
              _faqData[index]['isExpanded'] = !isExpanded;
            });
          },
          children: _faqData.map<ExpansionPanel>((item) {
            return ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(
                    item['question'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                );
              },
              body: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Text(
                  item['answer'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ),
              isExpanded: item['isExpanded'],
              canTapOnHeader: true,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Couldn't find what you're looking for?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpSupportScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[800],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Contact Support'),
          ),
        ],
      ),
    );
  }
}