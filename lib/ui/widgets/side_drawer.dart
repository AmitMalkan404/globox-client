import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:globox/ui/screens/settings_screen.dart'; // Import the SettingsScreen from the correct path

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User signed out successfully!");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 10),
                // Text("User Name",
                //     style: TextStyle(color: Colors.white, fontSize: 18)),
                Text(FirebaseAuth.instance.currentUser?.email ?? "user",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            text: tr.about,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Globox',
                applicationVersion: '1.0.0',
                applicationIcon: Icon(Icons.info_outline),
                children: [
                  Text('Globox app\n© 2025'),
                ],
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: tr.settings,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: tr.logout,
            onTap: signOutUser,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
