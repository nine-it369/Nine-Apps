import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:nine_ui_app/nine_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../blocs/profile_bloc.dart';
import '../blocs/profile_event.dart';

/// SCR-26B: Edit Profil Screen (screen-profile-edit)
/// Replicates D:\Q4 Planning\design\src\modules\settings\settings.template.html (lines 523-583)
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileBloc>().state.user;
    _nameController = TextEditingController(text: user.name);
    _phoneController = TextEditingController(text: user.phone);
    _emailController = TextEditingController(text: user.email ?? 'aditya@nine.id');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    setState(() => _isSaving = true);
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    if (name.isEmpty) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama lengkap wajib diisi.')),
      );
      return;
    }
    context.read<ProfileBloc>().add(
          SubmitUpdateProfileEvent(
            name: name,
            email: email.isNotEmpty ? email : null,
          ),
        );
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: NineSpringTap(
          onTap: () => Navigator.pop(context),
          child: const Center(
            child: Icon(TablerIcons.chevron_left, color: Color(0xFF18191D)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Profil',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF18191D)),
            ),
            Text(
              'Perbarui identitas akun & kontak utama',
              style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.black.withAlpha(12), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withAlpha(15)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Nama Lengkap'),
              const SizedBox(height: 6),
              _buildTextField(_nameController, TextInputType.name),

              const SizedBox(height: 16),
              _buildFieldLabel('Nomor WhatsApp'),
              const SizedBox(height: 6),
              _buildTextField(_phoneController, TextInputType.phone),

              const SizedBox(height: 16),
              _buildFieldLabel('Alamat Email'),
              const SizedBox(height: 6),
              _buildTextField(_emailController, TextInputType.emailAddress),

              const SizedBox(height: 24),
              NineSpringTap(
                onTap: _isSaving ? null : _saveProfile,
                child: Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.obsidian),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.obsidian,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF231F20),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, TextInputType type) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withAlpha(15)),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: type,
        style: AppTextStyles.bodyMedium.copyWith(fontSize: 12.5),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
