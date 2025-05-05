import 'package:flutter/material.dart';
import 'package:payment_app/services/api_service.dart';
import 'package:payment_app/utils/theme.dart';
import 'package:payment_app/utils/common_widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<Map<String, dynamic>> transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token') ?? "test_token";
      final userId = await storage.read(key: 'user_id') ?? "test-user-id";
      
      final result = await fetchAllTransactions(token);
      if (mounted) {
        setState(() {
          // Convert API transaction format to UI display format
          transactions = result.map((transaction) {
            final transactionId = transaction['transaction_id'] ?? transaction['id'] ?? '';
            final senderUserId = transaction['sender_user_id'] ?? transaction['sender'] ?? '';
            final receiverUserId = transaction['receiver_user_id'] ?? transaction['receiver'] ?? '';
            final amount = double.tryParse(transaction['amount'].toString()) ?? 0.0;
            
            // Determine if this is an incoming transaction (user is the receiver)
            final isIncoming = receiverUserId == userId;
            
            // Use server_timestamp as primary date, fallback to created_at or date
            final dateString = transaction['server_timestamp'] ?? 
                               transaction['created_at'] ?? 
                               transaction['date'] ??
                               DateTime.now().toIso8601String();
            
            // Get description if available
            final description = transaction['description'] ?? '';
            
            return {
              'id': transactionId,
              'amount': amount,
              'type': isIncoming ? 'incoming' : 'outgoing',
              'sender': senderUserId,
              'receiver': receiverUserId,
              'date': dateString,
              'status': transaction['status'] ?? 'completed',
              'description': description,
              'transaction_type': transaction['transaction_type'] ?? '',
              'currency': transaction['currency'] ?? 'INR',
            };
          }).toList().cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? AppTheme.darkBackgroundColor : null,
      appBar: commonAppBar(title: 'Transaction History', context: context),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : transactions.isEmpty
                ? Center(
                    child: Text(
                      'No transactions yet',
                      style: TextStyle(
                        color: Colors.white.withAlpha(204), // Replacing with explicit alpha channel
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(24.0),
                    itemCount: transactions.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 32,
                      color: Colors.white.withAlpha(26), // Replacing with explicit alpha channel
                    ),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final isIncoming = transaction['type'] == 'incoming';
                      final amount = transaction['amount'] as double;
                      final date = DateTime.parse(transaction['date']);
                      final description = transaction['description'] as String;
                      final status = transaction['status'] as String;
                      final currency = transaction['currency'] as String;
                      final transactionType = transaction['transaction_type'] as String;

                      return Card(
                        elevation: 0,
                        color: isDarkMode 
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isDarkMode 
                                          ? Colors.white.withOpacity(0.1)
                                          : AppTheme.greyColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      isIncoming
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: isIncoming 
                                          ? (isDarkMode ? Colors.green.shade300 : Colors.green) 
                                          : (isDarkMode ? Colors.red.shade300 : Colors.red),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isIncoming
                                              ? 'Received from ${transaction['sender']}'
                                              : 'Sent to ${transaction['receiver']}',
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.white : Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${DateFormat('dd/MM/yyyy HH:mm').format(date)} • $status',
                                          style: TextStyle(
                                            color: isDarkMode 
                                                ? Colors.white.withOpacity(0.7) 
                                                : Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${isIncoming ? '+' : '-'}$currency${amount.abs().toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: isIncoming 
                                          ? (isDarkMode ? Colors.green.shade300 : Colors.green)
                                          : (isDarkMode ? Colors.red.shade300 : Colors.red),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              
                              // Only show description if it's not empty
                              if (description.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.white.withOpacity(0.05)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white.withOpacity(0.9) : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                              
                              // Show transaction type if available
                              if (transactionType.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Chip(
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: isDarkMode 
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.blue.withOpacity(0.1),
                                  label: Text(
                                    transactionType,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDarkMode ? Colors.white70 : Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}