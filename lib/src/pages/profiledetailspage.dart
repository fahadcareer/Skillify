import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/widgets/cus_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Skillify/src/data/local/cache_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profiledetailspage extends StatefulWidget {
  const Profiledetailspage({super.key});

  @override
  State<Profiledetailspage> createState() => _ProfiledetailspageState();
}

class _ProfiledetailspageState extends State<Profiledetailspage> {
  bool isLoading = true;
  Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    String email = CacheHelper.getString(key: 'email');

    if (email.isEmpty) {
      setState(() {
        isLoading = false;
        user = {'name': 'User Not Found', 'email': 'No email available'};
      });
      return;
    }

    try {
      String token = CacheHelper.getString(key: 'token');
      final apiUrl = 'http://20.46.197.154:5075/profile/$email';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final profileData = json.decode(response.body);
        setState(() {
          user = profileData;
          isLoading = false;
        });
      } else {
        print('Failed to load profile: ${response.statusCode}');
        setState(() {
          isLoading = false;
          user = {'name': 'Error loading profile', 'email': email};
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
      setState(() {
        isLoading = false;
        user = {'name': 'Connection Error', 'email': email};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: CustomAppBar(
        c: context,
        title: "Profile",
        backButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'image',
                        child: ClipOval(
                          child: user.containsKey('profileImage') &&
                                  user['profileImage'] != null
                              ? Image.network(
                                  user['profileImage'],
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      'https://thinksport.com.au/wp-content/uploads/2020/01/avatar-.jpg',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.network(
                                  'https://thinksport.com.au/wp-content/uploads/2020/01/avatar-.jpg',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['name'] ?? 'No Name',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Space.y0!,
                            Text(
                              user['role'] == 1 ? 'Admin' : 'Assesment User',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Space.y0!,
                            Text(
                              user['email'] ?? 'No Email',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _buildListTile(context, "Account Settings"),
                      _divider(),
                      _buildListTile(
                        context,
                        "Language",
                        onTap: () => context.go('/home/profile/setting'),
                      ),
                      _divider(),
                      _buildListTile(context, "About Assessment App"),
                      _divider(),
                      _buildListTile(context, "Help"),
                      _divider(),
                      _buildListTile(context, "Terms & Conditions"),
                      _divider(),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await CacheHelper.saveData(key: 'isLogins', value: false);
                      await CacheHelper.removeData(key: 'token');
                      await CacheHelper.removeData(key: 'email');
                      await CacheHelper.removeData(key: 'role');

                      if (mounted) {
                        context.go('/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.red),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildListTile(BuildContext context, String title,
      {VoidCallback? onTap}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, size: 24, color: Colors.black),
      onTap: onTap ?? () {},
    );
  }

  Widget _divider() => const Divider(height: 1);
}
