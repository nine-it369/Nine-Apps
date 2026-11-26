import 'package:flutter/material.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/controls/nine_text_field.dart';
import '../../../../core/theme/app_text_styles.dart';

class ContactSectionWidget extends StatelessWidget {
  final String initialName;
  final String initialPhone;
  final String initialEmail;
  final String initialAddress;
  final String initialNotes;
  final Function(String name, String phone, String email, String address, String notes) onUpdated;

  const ContactSectionWidget({
    super.key,
    required this.initialName,
    required this.initialPhone,
    required this.initialEmail,
    required this.initialAddress,
    required this.initialNotes,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Kontak Pelanggan', style: AppTextStyles.h2),
          const SizedBox(height: 6),
          Text(
            'Pastikan nomor WhatsApp aktif untuk konfirmasi reservasi & Digital SPK.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          BentoCard(
            child: Column(
              children: [
                NineTextField(
                  label: 'Nama Lengkap *',
                  hint: 'Masukkan nama Anda',
                  initialValue: initialName,
                  prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                  onChanged: (val) => onUpdated(val, initialPhone, initialEmail, initialAddress, initialNotes),
                ),
                const SizedBox(height: 14),
                NineTextField(
                  label: 'Nomor WhatsApp *',
                  hint: 'Contoh: 081234567890',
                  initialValue: initialPhone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_iphone_rounded, size: 20),
                  onChanged: (val) => onUpdated(initialName, val, initialEmail, initialAddress, initialNotes),
                ),
                const SizedBox(height: 14),
                NineTextField(
                  label: 'Email (Opsional)',
                  hint: 'Untuk tanda terima faktur',
                  initialValue: initialEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                  onChanged: (val) => onUpdated(initialName, initialPhone, val, initialAddress, initialNotes),
                ),
                const SizedBox(height: 14),
                NineTextField(
                  label: 'Alamat Domisili',
                  hint: 'Kota / Wilayah tempat tinggal',
                  initialValue: initialAddress,
                  prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                  onChanged: (val) => onUpdated(initialName, initialPhone, initialEmail, val, initialNotes),
                ),
                const SizedBox(height: 14),
                NineTextField(
                  label: 'Catatan Keluhan / Permintaan Khusus',
                  hint: 'Misal: Lampu biled redup, suara klakson putus-putus',
                  initialValue: initialNotes,
                  maxLines: 3,
                  prefixIcon: const Icon(Icons.edit_note_rounded, size: 20),
                  onChanged: (val) => onUpdated(initialName, initialPhone, initialEmail, initialAddress, val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
