import 'package:flutter/material.dart';
import 'package:payment_app/utils/theme.dart'; // Import AppTheme
import './payment_screen.dart'; // Import PaymentScreen

class BillDetailsScreen extends StatefulWidget {
  final String billType;
  const BillDetailsScreen({super.key, required this.billType});

  @override
  State<BillDetailsScreen> createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<BillDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _accountNumber;
  double? _amount;

  String _getIdentifierLabel() {
    switch (widget.billType) {
      case 'Mobile Recharge':
        return 'Mobile Number';
      case 'Electricity': // Assuming billType from BillPaymentScreen is 'Electricity'
        return 'Consumer ID / Account Number';
      case 'Water': // Assuming billType from BillPaymentScreen is 'Water'
        return 'Connection ID / Consumer Number';
      case 'Internet': // Assuming billType from BillPaymentScreen is 'Internet'
        return 'Subscriber ID / Account Number';
      case 'Other':
        return 'Account / Reference Number';
      default:
        return 'Account/Consumer Number';
    }
  }

  String _getIdentifierHintText() {
    switch (widget.billType) {
      case 'Mobile Recharge':
        return 'Enter Mobile Number';
      case 'Electricity':
        return 'Enter Consumer ID / Account Number';
      case 'Water':
        return 'Enter Connection ID / Consumer Number';
      case 'Internet':
        return 'Enter Subscriber ID / Account Number';
      case 'Other':
        return 'Enter Account / Reference Number';
      default:
        return 'Enter Account/Consumer Number';
    }
  }

  TextInputType _getIdentifierKeyboardType() {
    switch (widget.billType) {
      case 'Mobile Recharge':
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }

  void _proceedToPayment() async { // Make async
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Navigate to the actual payment screen with bill details
      final paymentResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            amount: _amount!,
            description: '${widget.billType} Bill for $_accountNumber',
            // For bill payments, we might not have a specific recipient user ID.
            // The payment service might handle this based on the biller details.
            // We can pass a generic recipient or a biller identifier if the PaymentScreen supports it.
            // For now, let's assume PaymentScreen can handle payments without a specific user recipientId.
            // Or, we can define a convention for biller IDs.
            // prefilledIdentifier: "biller_${widget.billType.toLowerCase().replaceAll(' ', '_')}", 
            // identifierIsUserId: false, 
            isBillPayment: true, // Add a flag to indicate bill payment
            billType: widget.billType, // Pass bill type
            billAccountNumber: _accountNumber, // Pass account number
          ),
        ),
      );

      // After payment screen is popped, check result and navigate back if successful
      if (paymentResult == 'success' && mounted) {
        Navigator.pop(context, 'payment_successful'); // Pop BillDetailsScreen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.billType} Bill Details'),
        // Use theme colors
        backgroundColor: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
        foregroundColor: isDarkMode ? AppTheme.textPrimaryColorDark : AppTheme.textPrimaryColorLight,
      ),
      // Use theme background color
      backgroundColor: isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Enter details for ${widget.billType} Bill',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: isDarkMode ? AppTheme.textPrimaryColorDark : AppTheme.textPrimaryColorLight
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: TextStyle(color: isDarkMode ? AppTheme.textPrimaryColorDark : AppTheme.textPrimaryColorLight),
                decoration: AppTheme.inputDecoration(
                  labelText: _getIdentifierLabel(), // Use dynamic label
                  hintText: _getIdentifierHintText(), // Use dynamic hint
                  isDarkMode: isDarkMode,
                  prefixIcon: widget.billType == 'Mobile Recharge' ? Icons.phone_android : Icons.person_outline, // Dynamic icon
                ),
                keyboardType: _getIdentifierKeyboardType(), // Dynamic keyboard type
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ${_getIdentifierLabel().toLowerCase()}'; // Dynamic validation message
                  }
                  if (widget.billType == 'Mobile Recharge' && (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value))) {
                    return 'Please enter a valid 10-digit mobile number';
                  }
                  return null;
                },
                onSaved: (value) => _accountNumber = value,
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: TextStyle(color: isDarkMode ? AppTheme.textPrimaryColorDark : AppTheme.textPrimaryColorLight),
                decoration: AppTheme.inputDecoration(
                  labelText: 'Amount',
                  hintText: 'Enter Amount',
                  isDarkMode: isDarkMode,
                  prefixIcon: Icons.currency_rupee,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onSaved: (value) => _amount = double.tryParse(value!),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _proceedToPayment,
                // The style will now be primarily inherited from the ThemeData's elevatedButtonTheme.
                // Specific overrides can be done here if needed, for example, for padding.
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  // backgroundColor and foregroundColor will come from the theme if not specified here.
                ),
                child: const Text('Proceed to Payment'), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}
