import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_turf/flutterlogo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_turf/Authstorage.dart';

class CoolSidebar extends StatefulWidget {
  const CoolSidebar({Key? key}) : super(key: key);

  @override
  State<CoolSidebar> createState() => _CoolSidebarState();
}

class _CoolSidebarState extends State<CoolSidebar> {
  String userName = "";
  String email = "";
  String phoneNumber = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final loginData = await AuthStorage.getLoginData();
      if (loginData != null && mounted) {
        setState(() {
          userName = loginData['name'] ?? '';
          email = loginData['email'] ?? '';
          phoneNumber = loginData['phone_number'] ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00C853),
              Color(0xFF00A845),
              Color(0xFF008F37),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            isLoading ? _buildLoadingProfile() : _buildUserProfile(),
            const Divider(
              color: Colors.white24,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: _buildMenuItems(context),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120,
      padding: const EdgeInsets.only(top: 40, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MyTurfLogo(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLoadingProfile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName.isNotEmpty ? userName : 'Guest User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (email.isNotEmpty) ...[
            _buildProfileInfo(Icons.email_outlined, email),
            const SizedBox(height: 6),
          ],
          if (phoneNumber.isNotEmpty) ...[
            _buildProfileInfo(Icons.phone_outlined, phoneNumber),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildCoolListTile(
          icon: Icons.dashboard_outlined,
          title: 'Dashboard',
          onTap: () => _handleMenuTap(context, 'Dashboard'),
        ),
        _buildCoolListTile(
          icon: Icons.sports_soccer_outlined,
          title: 'Book Turf',
          onTap: () => _handleMenuTap(context, 'Book Turf'),
        ),
        _buildCoolListTile(
          icon: Icons.history_outlined,
          title: 'My Bookings',
          onTap: () => _handleMenuTap(context, 'My Bookings'),
        ),
        _buildCoolListTile(
          icon: Icons.account_circle_outlined,
          title: 'Profile',
          onTap: () => _handleMenuTap(context, 'Profile'),
        ),
        _buildCoolListTile(
          icon: Icons.payment_outlined,
          title: 'Payment History',
          onTap: () => _handleMenuTap(context, 'Payment History'),
        ),
        _buildCoolListTile(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () => _handleMenuTap(context, 'Notifications'),
        ),
        const Divider(
          color: Colors.white24,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        _buildCoolListTile(
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () => _handleMenuTap(context, 'Settings'),
        ),
        _buildCoolListTile(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () => _handleMenuTap(context, 'Help & Support'),
        ),
        _buildCoolListTile(
          icon: Icons.info_outline,
          title: 'About',
          onTap: () => _handleMenuTap(context, 'About'),
        ),
      ],
    );
  }

  Widget _buildCoolListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.6),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Divider(
            color: Colors.white24,
            thickness: 1,
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _handleSignOut(context),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.white.withOpacity(0.8),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuTap(BuildContext context, String menuItem) {
    // Close the drawer first
    Navigator.of(context).pop();

    // Add a small delay to ensure drawer is closed before showing snackbar

  }

  void _handleSignOut(BuildContext context) async {
    // Show confirmation dialog
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sign Out'),
              ),
            ],
          ),
    );


    void _showSnackBar(BuildContext context, String message) {
      if (!context.mounted) return;

      try {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF00C853),
          ),
        );
      } catch (e) {
        print('Error showing snackbar: $e');
        // Fallback: try to show a simple dialog instead
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  content: Text(message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
      }
    }
  }
}