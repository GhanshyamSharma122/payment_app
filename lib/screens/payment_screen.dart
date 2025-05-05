import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payment_app/services/api_service.dart';
import 'package:payment_app/utils/theme.dart';
import 'package:payment_app/utils/common_widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _receiverController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingWallet = true;
  bool _isLoadingContacts = true;
  Map<String, dynamic>? _walletData;
  
  // Use a list that will be populated with real users from the API
  List<Map<String, dynamic>> _recentContacts = [];
  
  // Store the currently selected recipient ID
  String? _selectedRecipientId;

  @override
  void initState() {
    super.initState();
    _fetchWalletBalance();
    _fetchRecentContacts();
  }

  Future<void> _fetchWalletBalance() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token') ?? "test_token";
      
      final wallet = await getWalletBalance(token);
      
      if (mounted) {
        setState(() {
          _walletData = wallet;
          _isLoadingWallet = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingWallet = false);
      }
    }
  }

  Future<void> _fetchRecentContacts() async {
    setState(() {
      _isLoadingContacts = true;
    });
    
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token') ?? "test_token";
      
      // Fetch recent contacts from the API
      final contacts = await searchUsers(token, '');
      
      if (mounted) {
        setState(() {
          _recentContacts = contacts;
          _isLoadingContacts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingContacts = false);
      }
    }
  }

  Future<void> _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        const storage = FlutterSecureStorage();
        final token = await storage.read(key: 'auth_token') ?? "test_token";
        
        // Check if amount is parseable
        final amount = double.tryParse(_amountController.text);
        if (amount == null) {
          throw Exception('Please enter a valid amount');
        }

        // Check if recipient is specified
        if (_receiverController.text.trim().isEmpty) {
          throw Exception('Please specify a recipient');
        }
        
        // Find the recipient ID for the entered name
        String recipientId = _selectedRecipientId ?? '';
        
        // If no recipient ID is selected (user typed manually)
        if (recipientId.isEmpty) {
          final enteredName = _receiverController.text.trim().toLowerCase();
          
          // Try to find the recipient by first_name + last_name
          for (final contact in _recentContacts) {
            final firstName = (contact['first_name'] ?? '').toLowerCase();
            final lastName = (contact['last_name'] ?? '').toLowerCase();
            final fullName = '$firstName $lastName'.trim().toLowerCase();
            
            if (fullName == enteredName) {
              recipientId = contact['id'] ?? '';
              break;
            }
          }
          
          if (recipientId.isEmpty) {
            throw Exception('Recipient not found. Please select from the contacts list.');
          }
        }
        
        // Use fields exactly as specified in the API documentation
        final description = _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : "Payment from TapKaro app";
        
        final response = await initiateOnlinePayment(
          token,
          "", // Not needed as per the API specification
          recipientId,
          amount,
          description: description,
        );
        
        print('Payment successful: $response');

        if (mounted) {
          // Update the success dialog to show additional information from the response
          _showSuccessDialog(response);
        }
      } catch (e) {
        if (mounted) {
          // Extract just the error message without the Exception prefix
          String errorMsg = e.toString();
          if (errorMsg.startsWith('Exception: ')) {
            errorMsg = errorMsg.substring('Exception: '.length);
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.red.shade700,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showSuccessDialog(dynamic response) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Extract additional information from the response if available
    final transactionId = response['transaction_id'] ?? 'N/A';
    final recipientName = response['recipient_name'] ?? _receiverController.text;
    final amount = response['amount'] != null ? '₹${response['amount']}' : '₹${_amountController.text}';
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: isDarkMode ? AppTheme.darkSurfaceColor : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.green.withOpacity(0.2) : Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: isDarkMode ? Colors.green.shade300 : Colors.green.shade600,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You have sent $amount to $recipientName',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Transaction ID: $transactionId',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.white.withOpacity(0.15) : AppTheme.accentColor,
                    foregroundColor: isDarkMode ? Colors.white : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBalance(dynamic balance) {
    if (balance == null) return '0.00';
    
    // Handle both numeric and string representations
    if (balance is num) {
      return balance.toStringAsFixed(2);
    } else if (balance is String) {
      try {
        return double.parse(balance).toStringAsFixed(2);
      } catch (e) {
        print('Error formatting balance: $e');
        return balance.toString();
      }
    }
    
    return '0.00';
  }

  // Show contact picker dialog
  void _showContactPicker() async {
    try {
      setState(() => _isLoadingContacts = true);
      
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token') ?? "test_token";
      
      // Fetch contacts from API
      final contacts = await searchUsers(token, '');
      
      setState(() => _isLoadingContacts = false);
      
      if (!mounted) return;
      
      if (contacts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No contacts available'),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
      
      showDialog(
        context: context,
        builder: (context) {
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: isDarkMode ? AppTheme.darkSurfaceColor : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Select Contact',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        final firstName = contact['first_name'] ?? '';
                        final lastName = contact['last_name'] ?? '';
                        final fullName = '$firstName $lastName'.trim();
                        final contactId = contact['id'] ?? '';
                        final initial = firstName.isNotEmpty ? firstName[0] : '?';
                        
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                            child: Text(
                              initial,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : AppTheme.accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            fullName,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            contact['email'] ?? contact['phone_number'] ?? '',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _receiverController.text = fullName;
                              _selectedRecipientId = contactId;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: isDarkMode ? Colors.white70 : AppTheme.accentColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error fetching contacts: $e');
      setState(() => _isLoadingContacts = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load contacts: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      appBar: commonAppBar(title: 'Send Money', context: context),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode 
                ? AppTheme.darkGradientColors 
                : AppTheme.gradientColors,
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        
                        // Amount Input - Elevated to top for better focus
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Amount',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '₹',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: isDarkMode 
                                          ? Colors.white.withOpacity(0.15) 
                                          : Colors.white.withOpacity(0.85),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isDarkMode 
                                            ? Colors.white.withOpacity(0.25) 
                                            : Colors.grey.shade300,
                                        width: 1.5,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    child: TextFormField(
                                      controller: _amountController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black87,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '0.00',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          color: isDarkMode 
                                              ? Colors.white.withOpacity(0.5) 
                                              : Colors.grey.shade600,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        errorStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.red.shade300,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      validator: (value) {
                                        double? amount = double.tryParse(value ?? '');
                                        if (amount == null || amount <= 0) {
                                          return 'Enter valid amount';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              // Display wallet balance or loading indicator
                              _isLoadingWallet
                                  ? SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                                      ),
                                    )
                                  : Text(
                                      'Available Balance: ₹${_formatBalance(_walletData?['balance'])}',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Divider for visual separation
                        Divider(color: Colors.white.withOpacity(0.15)),
                        
                        const SizedBox(height: 30),
                        
                        // Send To Field with cleaner styling
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Send To',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _showContactPicker,
                              icon: Icon(
                                Icons.contacts,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              label: Text(
                                'Select Contact',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        Container(
                          decoration: BoxDecoration(
                            color: isDarkMode 
                              ? Colors.white.withOpacity(0.2) // More visible in dark mode
                              : Colors.white.withOpacity(0.9), // Nearly solid white in light mode
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDarkMode 
                                ? Colors.white.withOpacity(0.3) 
                                : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: _receiverController,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Recipient name will appear here',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: isDarkMode
                                  ? Colors.white.withOpacity(0.6) 
                                  : Colors.grey.shade600,
                                fontSize: 16,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              errorStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.red.shade300,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            readOnly: true,
                            onTap: _showContactPicker,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please select a recipient';
                              }
                              return null;
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Note Field with cleaner styling
                        Text(
                          'Add a Note',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        Container(
                          decoration: BoxDecoration(
                            color: isDarkMode 
                              ? Colors.white.withOpacity(0.2) 
                              : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDarkMode 
                                ? Colors.white.withOpacity(0.3) 
                                : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: _noteController,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 3,
                            minLines: 2,
                            decoration: InputDecoration(
                              hintText: 'What\'s this payment for?',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: isDarkMode
                                  ? Colors.white.withOpacity(0.6)
                                  : Colors.grey.shade600,
                                fontSize: 16,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: size.height * 0.08),
                      ],
                    ),
                  ),
                ),
                
                // Send Money Button - Cleaner design
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: isDarkMode ? 4 : 2,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.send, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Send Money',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}