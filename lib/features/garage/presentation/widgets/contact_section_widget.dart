import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/controls/nine_text_field.dart';
import '../../domain/entities/regency_entity.dart';

class ContactSectionWidget extends StatefulWidget {
  final String initialName;
  final String initialPhone;
  final String initialEmail;
  final String initialAddress;
  final String initialCityName;
  final int initialCityId;
  final String initialReferralSource;
  final bool initialHasVisited;
  final String initialNotes;
  final List<RegencyEntity> regencyResults;
  final Function({
    String? name,
    String? phone,
    String? email,
    String? address,
    String? referralSource,
    bool? hasVisited,
    String? notes,
  }) onUpdated;
  final ValueChanged<String> onSearchRegency;
  final ValueChanged<RegencyEntity> onSelectRegency;

  const ContactSectionWidget({
    super.key,
    required this.initialName,
    required this.initialPhone,
    required this.initialEmail,
    required this.initialAddress,
    required this.initialCityName,
    required this.initialCityId,
    required this.initialReferralSource,
    required this.initialHasVisited,
    required this.initialNotes,
    required this.regencyResults,
    required this.onUpdated,
    required this.onSearchRegency,
    required this.onSelectRegency,
  });

  @override
  State<ContactSectionWidget> createState() => _ContactSectionWidgetState();
}

class _ContactSectionWidgetState extends State<ContactSectionWidget> {
  late final TextEditingController _cityController;

  static const List<String> _referralSources = [
    'Google Search',
    'Instagram',
    'Facebook',
    'TikTok',
    'YouTube',
    'Teman/Keluarga',
    'Billboard/Spanduk',
    'Event/Otomotif',
    'Dealer/Mobil',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController(text: widget.initialCityName);
  }

  @override
  void didUpdateWidget(covariant ContactSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCityName != oldWidget.initialCityName &&
        widget.initialCityName.isNotEmpty &&
        _cityController.text != widget.initialCityName) {
      _cityController.text = widget.initialCityName;
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Kontak & Domisili', style: AppTextStyles.h2),
          const SizedBox(height: 4),
          Text(
            'Data digunakan untuk penerbitan tiket SPK dan pengingat WhatsApp otomatis.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NineTextField(
                  label: 'Nama Lengkap *',
                  hint: 'Minimal 3 karakter',
                  initialValue: widget.initialName,
                  prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                  onChanged: (val) => widget.onUpdated(name: val),
                ),
                const SizedBox(height: 14),
                NineTextField(
                  label: 'Nomor WhatsApp *',
                  hint: 'Contoh: 081234567890',
                  initialValue: widget.initialPhone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_iphone_rounded, size: 20),
                  onChanged: (val) => widget.onUpdated(phone: val),
                ),
                const SizedBox(height: 14),
                NineTextField(
                  label: 'Email (Opsional)',
                  hint: 'email@contoh.com',
                  initialValue: widget.initialEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                  onChanged: (val) => widget.onUpdated(email: val),
                ),
                const SizedBox(height: 14),
                Text(
                  'Tahu Nine Garage dari mana? *',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: _referralSources.contains(widget.initialReferralSource)
                      ? widget.initialReferralSource
                      : _referralSources.first,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surfaceMuted,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.buttonRadius,
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.buttonRadius,
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                  items: _referralSources
                      .map((src) => DropdownMenuItem(value: src, child: Text(src)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      widget.onUpdated(referralSource: val);
                    }
                  },
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  value: widget.initialHasVisited,
                  onChanged: (val) => widget.onUpdated(hasVisited: val ?? false),
                  title: Text(
                    'Saya sudah pernah berkunjung ke Nine Garage sebelumnya',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  ),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.obsidian,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alamat Domisili (Untuk Klaim Garansi)', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                NineTextField(
                  label: 'Kota / Kabupaten *',
                  hint: 'Ketik minimal 2 huruf (misal: Jakarta, Tangerang)',
                  controller: _cityController,
                  prefixIcon: const Icon(Icons.location_city_rounded, size: 20),
                  suffixIcon: widget.initialCityId > 0
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryDark, size: 20)
                      : null,
                  onChanged: widget.onSearchRegency,
                ),
                if (widget.regencyResults.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 180),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.buttonRadius,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: widget.regencyResults.length,
                      separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.borderSubtle),
                      itemBuilder: (ctx, idx) {
                        final regency = widget.regencyResults[idx];
                        return ListTile(
                          dense: true,
                          title: Text(regency.name, style: AppTextStyles.bodyMedium),
                          onTap: () {
                            _cityController.text = regency.name;
                            widget.onSelectRegency(regency);
                          },
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                NineTextField(
                  label: 'Alamat Lengkap *',
                  hint: 'Minimal 5 karakter (Nama jalan, blok, kecamatan)',
                  initialValue: widget.initialAddress,
                  maxLines: 2,
                  prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                  onChanged: (val) => widget.onUpdated(address: val),
                ),
                const SizedBox(height: 14),
                NineTextField(
                  label: 'Catatan Keluhan / Permintaan Khusus',
                  hint: 'Contoh: Lampu biled kanan redup, pasang klakson relay',
                  initialValue: widget.initialNotes,
                  maxLines: 2,
                  prefixIcon: const Icon(Icons.edit_note_rounded, size: 20),
                  onChanged: (val) => widget.onUpdated(notes: val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
