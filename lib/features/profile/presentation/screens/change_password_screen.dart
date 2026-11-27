import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:nine_ui_app/nine_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../blocs/profile_bloc.dart';
import '../blocs/profile_event.dart';

/// SCR-27: Ubah Password Screen (screen-auth-edit-password)
/// Replicates D:\Q4 Planning\design\src\modules\settings\settings.template.html (lines 1349-1440)
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _submitChange() async {
    if (_newPassController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password baru minimal 8 karakter.')),
      );
      return;
    }
    if (_newPassController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak cocok.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    context.read<ProfileBloc>().add(
          SubmitChangePasswordEvent(
            oldPassword: _oldPassController.text.trim(),
            newPassword: _newPassController.text.trim(),
          ),
        );
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kata sandi berhasil diperbarui.')),
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
              'Ubah Password',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF18191D)),
            ),
            Text(
              'Perbarui keamanan akun Nine Anda',
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
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black.withAlpha(15)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Keamanan Sandi Akun',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF231F20)),
              ),
              const SizedBox(height: 2),
              Text(
                'Minimal 8 karakter dengan kombinasi huruf dan angka.',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0x0F000000)),
              const SizedBox(height: 16),

              // 1. Password Lama
              _buildFieldLabel('Password Saat Ini'),
              const SizedBox(height: 6),
              _buildPasswordField(
                controller: _oldPassController,
                obscure: _obscureOld,
                onToggle: () => setState(() => _obscureOld = !_obscureOld),
                placeholder: 'Masukkan password saat ini',
              ),

              const SizedBox(height: 16),

              // 2. Password Baru
              _buildFieldLabel('Password Baru'),
              const SizedBox(height: 6),
              _buildPasswordField(
                controller: _newPassController,
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
                placeholder: 'Minimal 8 karakter',
              ),

              const SizedBox(height: 16),

              // 3. Konfirmasi Password Baru
              _buildFieldLabel('Konfirmasi Password Baru'),
              const SizedBox(height: 6),
              _buildPasswordField(
                controller: _confirmPassController,
                obscure: _obscureConfirm,
                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                placeholder: 'Ulangi password baru',
              ),

              const SizedBox(height: 26),

              NineSpringTap(
                onTap: _isSubmitting ? null : _submitChange,
                child: Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.obsidian),
                        )
                      : const Text(
                          'Perbarui Password',
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required String placeholder,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withAlpha(15)),
      ),
      child: Row(
        children: [
          const Icon(TablerIcons.key, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 12.5),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(fontSize: 11.5, color: Colors.grey.shade400),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          NineSpringTap(
            onTap: onToggle,
            child: Icon(
              obscure ? TablerIcons.eye : TablerIcons.eye_off,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
