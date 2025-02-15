import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_project/utils/feedback_utils.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Future<void> _handleSignOut(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // ignore: use_build_context_synchronously
        FeedbackUtils.showLoading(context);
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        if (context.mounted) {
          FeedbackUtils.hideLoading(context);
          FeedbackUtils.showSuccess(context, 'Signed out successfully');
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (e) {
        if (context.mounted) {
          FeedbackUtils.hideLoading(context);
          FeedbackUtils.showError(
              context, 'Error signing out. Please try again.');
        }
      }
    }
  }

  Future<Map<String, String>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? 'User',
      'email': prefs.getString('email') ?? 'user@example.com',
      'profileImage': prefs.getString('profileImage') ?? 'default_image_url',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          final userData = snapshot.data ??
              {
                'name': 'Loading...',
                'email': 'Loading...',
                'profileImage': 'default_image_url'
              };
          // ignore: non_constant_identifier_names
          final ImageUrl =
              "https://static.toiimg.com/thumb/msid-100225970,imgsize-51152,width-400,resizemode-4/100225970.jpg";
          return Drawer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade800,
                    Colors.blue.shade200,
                  ],
                ),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: UserAccountsDrawerHeader(
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      accountName: Text(
                        userData['name']!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      accountEmail: Text(
                        userData['email']!,
                        style: TextStyle(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage:
                            NetworkImage(userData['profileImage']!),
                        backgroundColor: Colors.white,
                        radius: 50,
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    icon: CupertinoIcons.home,
                    title: "Home",
                    context: context,
                    onTap: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                  _buildDrawerItem(
                    icon: CupertinoIcons.doc_plaintext,
                    title: "Complaint Form",
                    context: context,
                    onTap: () {
                      Navigator.pushNamed(context, '/complaintForm');
                    },
                  ),
                  _buildDrawerItem(
                    icon: CupertinoIcons.phone_circle,
                    title: "Emergency Contact",
                    context: context,
                    onTap: () {
                      Navigator.pushNamed(context, '/emergencyContact');
                    },
                  ),
                  _buildDrawerItem(
                    icon: CupertinoIcons.chat_bubble_2,
                    title: "Chat Support",
                    context: context,
                    onTap: () {
                      Navigator.pushNamed(context, '/chatbot');
                    },
                  ),
                  _buildDrawerItem(
                    icon: CupertinoIcons.doc_text,
                    title: "Know Your Rights",
                    context: context,
                    onTap: () {
                      Navigator.pushNamed(context, '/rights');
                    },
                  ),
                  _buildDrawerItem(
                    icon: CupertinoIcons.heart,
                    title: "Support Services",
                    context: context,
                    onTap: () {
                      Navigator.pushNamed(context, '/support');
                    },
                  ),
                  _buildDrawerItem(
                    icon: CupertinoIcons.shield,
                    title: "Safety Guidelines",
                    context: context,
                    onTap: () {
                      Navigator.pushNamed(context, '/safety');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Color.fromARGB(255, 255, 255, 255)),
                    title: const Text(
                      'Sign Out',
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    onTap: () => _handleSignOut(context),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.1),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
          size: 25,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
