import 'package:flutter/material.dart';
import 'package:payment_app/services/api_service.dart';
import 'package:payment_app/utils/theme.dart';

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
      // Mock token for testing - replace with actual token
      const token = "test_token";
      final result = await fetchAllTransactions(token);
      if (mounted) {
        setState(() {
          transactions = List<Map<String, dynamic>>.from(result);
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
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 28,
        ),
      ),
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
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(24.0),
                    itemCount: transactions.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 32,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final isIncoming = transaction['type'] == 'incoming';
                      final amount = transaction['amount'] as double;
                      final date = DateTime.parse(transaction['date']);

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
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
                        title: Text(
                          isIncoming
                              ? 'Received from ${transaction['sender']}'
                              : 'Sent to ${transaction['receiver']}',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        trailing: Text(
                          '${isIncoming ? '+' : '-'}₹${amount.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            color: isIncoming 
                                ? (isDarkMode ? Colors.green.shade300 : Colors.green)
                                : (isDarkMode ? Colors.red.shade300 : Colors.red),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}