import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                  backgroundImage: NetworkImage(
                      "https://files.oaiusercontent.com/file-3vN4vUCcv8tepr8ubW4Bnv?se=2025-02-14T22%3A47%3A41Z&sp=r&sv=2024-08-04&sr=b&rscc=max-age%3D604800%2C%20immutable%2C%20private&rscd=attachment%3B%20filename%3D0166a693-2259-4c39-8fdc-6e17eba70e6d.webp&sig=GWMIiTB5fYiLdqDrr4Hgj9sd3dC/XDGaOaZ3Vh1XBpk%3D"),
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
            icon: Icons.logout,
            text: "Logout",
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
