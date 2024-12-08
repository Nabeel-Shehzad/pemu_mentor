import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';
class Profile extends StatefulWidget {
  final UserModel user;

  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;

  late UserModel currentUser;

  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    _authService = Provider.of<AuthService>(context, listen: false);
    _nameController = TextEditingController(text: currentUser.name);
    _emailController = TextEditingController(text: currentUser.email);
    _usernameController = TextEditingController(text: currentUser.username);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                //refresh button
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _nameController.text = currentUser.name;
                    _emailController.text = currentUser.email;
                    _usernameController.text = currentUser.username;
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Academic Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Role: ${currentUser.role}'),
                    const SizedBox(height: 8),
                    Text(
                        'Status: ${currentUser.isActive ? "Active" : "Inactive"}'),
                    // Add additional mentee-specific fields here
                  ],
                ),
              ),
            ),
            //update profile button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Update user profile
                    final updatedUser = UserModel(
                      id: widget.user.id,
                      name: _nameController.text,
                      email: _emailController.text,
                      username: _usernameController.text,
                      role: widget.user.role,
                      isActive: widget.user.isActive,
                    );
                    // Update user in firebase
                    _authService.updateUserInfo(updatedUser);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated')),
                    );
                    setState(() {
                      currentUser = updatedUser;
                      _nameController.text = updatedUser.name;
                      _emailController.text = updatedUser.email;
                      _usernameController.text = updatedUser.username;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Update Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
