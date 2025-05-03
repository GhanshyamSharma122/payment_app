import 'package:flutter/material.dart';
import 'package:payment_app/utils/theme.dart';
import 'package:payment_app/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payment_app/screens/authentication_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
          size: 28, // Slightly larger icon
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode 
                ? AppTheme.darkGradientColors  // Use dark gradient in dark mode
                : AppTheme.gradientColors,     // Use purple gradient in light mode
          ),
        ),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _ProfileHeader(),
              const SizedBox(height: 24),
              const _QuickActions(),
              const SizedBox(height: 24),
              _MenuSection(
                title: 'Account',
                items: [
                  _MenuItem(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.security,
                    title: 'Security Settings',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _MenuSection(
                title: 'Preferences',
                items: [
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notification Settings',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.language,
                    title: 'Language',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.color_lens_outlined, // Changed from light/dark mode icon to color lens icon
                    title: 'Change Color Theme', // Fixed label regardless of theme state
                    onTap: () => themeProvider.toggleTheme(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _MenuSection(
                title: 'Support',
                items: [
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () async {
                      // Logout functionality
                      final storage = FlutterSecureStorage();
                      await storage.deleteAll(); // Clear all secure storage
                      
                      // Navigate to authentication screen
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const AuthenticationScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: isDarkMode 
                  ? [Colors.white24, Colors.white10] // Neutral colors for dark mode
                  : [Colors.purple.shade400, Colors.blue.shade400], // Purple gradient for light mode
            ),
          ),
          child: Center(
            child: Text(
              'T', // First letter of testuser
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'testuser', // Changed from Utkrisht to testuser
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.white, // Ensure visibility in both themes
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'testuser@example.com', // Changed the email address
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white70 : Colors.white.withOpacity(0.7), // Improved visibility
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickActionItem(
          icon: Icons.qr_code,
          label: 'QR Code',
          onTap: () {},
        ),
        _QuickActionItem(
          icon: Icons.share,
          label: 'Share',
          onTap: () {},
        ),
        _QuickActionItem(
          icon: Icons.edit,
          label: 'Edit',
          onTap: () {},
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon, 
              size: 28,
              color: Colors.white, // White icon color for better visibility
            ),
            const SizedBox(height:.8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white, // White text for better visibility
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.white, // Ensure visibility in both themes
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1) // Semi-transparent for dark mode
              : Colors.white.withOpacity(0.9), // More opaque for light mode
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive 
            ? Colors.red 
            : (isDarkMode ? Colors.white70 : Colors.black87),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive 
              ? Colors.red 
              : (isDarkMode ? Colors.white : Colors.black87),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDarkMode ? Colors.white54 : Colors.black54,
      ),
      onTap: onTap,
    );
  }
}