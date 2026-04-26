import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmcom/features/auth/presentation/providers/auth_provider.dart';
import 'package:farmcom/features/settings/presentation/pages/settings_page.dart';
import 'package:farmcom/core/presentation/widgets/section_header_with_status.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _regionController;
  late List<String> _interests;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.name ?? 'Test Farmer');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _regionController = TextEditingController(text: user?.region ?? '');
    _interests = List.from(user?.interests ?? ['Coffee', 'Maize']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'My Profile',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: const Color(0xFF2E7D32), size: 28),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ),
            leading: null,
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Info Header (Non-Card Style)
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF2E7D32).withValues(alpha: 0.15),
                            border: Border.all(
                              color: const Color(0xFF2E7D32),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 45,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _nameController.text.isEmpty
                              ? 'Test Farmer'
                              : _nameController.text,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _phoneController.text,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: _isEditing ? _saveProfile : _toggleEditMode,
                              icon: Icon(
                                _isEditing ? Icons.check : Icons.edit,
                                size: 18,
                              ),
                              label: Text(
                                _isEditing ? 'Save' : 'Edit Profile',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32)
                                    .withValues(alpha: 0.1),
                                foregroundColor: const Color(0xFF2E7D32),
                              ),
                            ),
                            if (_isEditing) ...[
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Image picker coming soon'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.camera_alt, size: 18),
                                label: const Text('Change Photo'),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200,
                                  foregroundColor: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey.shade300, thickness: 1),
                  const SizedBox(height: 20),
                  // Profile Information Section
                  _buildProfileInfoSection(),
                  const SizedBox(height: 24),
                  // Settings and Logout
                  _buildActionTile(
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'App preferences and customization',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildActionTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help or report issues',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Help & Support coming soon'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildActionTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    isDestructive: true,
                    onTap: () {
                      _showLogoutDialog();
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About You',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        _buildProfileField(
          label: 'Full Name',
          controller: _nameController,
          isEditing: _isEditing,
          icon: Icons.person,
        ),
        const SizedBox(height: 12),
        _buildProfileField(
          label: 'Phone Number',
          controller: _phoneController,
          isEditing: false,
          icon: Icons.phone,
          enabled: false,
        ),
        const SizedBox(height: 12),
        _buildProfileField(
          label: 'Bio',
          controller: _bioController,
          isEditing: _isEditing,
          icon: Icons.info,
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        _buildProfileField(
          label: 'Region',
          controller: _regionController,
          isEditing: _isEditing,
          icon: Icons.location_on,
        ),
        const SizedBox(height: 24),
        // Interests Section
        Text(
          'Farming Interests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isEditing)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Interests',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Add interest feature coming soon'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_circle),
                        color: const Color(0xFF2E7D32),
                        iconSize: 24,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _interests
                    .map((interest) => _buildInterestChip(interest, _isEditing))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required IconData icon,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (isEditing && enabled)
            TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: 'Enter $label',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            )
          else
            Text(
              controller.text.isEmpty ? 'Not set' : controller.text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String interest, bool isEditing) {
    return Chip(
      label: Text(interest),
      backgroundColor: const Color(0xFF2E7D32).withValues(alpha: 0.1),
      labelStyle: const TextStyle(
        color: Color(0xFF2E7D32),
        fontWeight: FontWeight.w600,
      ),
      onDeleted: isEditing
          ? () {
              setState(() {
                _interests.remove(interest);
              });
            }
          : null,
      deleteIcon: isEditing ? const Icon(Icons.close, size: 18) : null,
      deleteIconColor: const Color(0xFF2E7D32),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive ? Colors.red.shade200 : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : const Color(0xFF2E7D32),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? Colors.red : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDestructive
                          ? Colors.red.shade600
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDestructive ? Colors.red : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
