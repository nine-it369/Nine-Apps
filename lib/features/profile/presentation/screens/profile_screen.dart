import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nine_ui_app/nine_ui.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_event.dart';
import '../../../smart_lighting/presentation/blocs/smart_lighting_bloc.dart';
import '../../../smart_lighting/presentation/widgets/smart_lamp_modals.dart';
import '../../../../core/di/injection.dart';
import '../blocs/profile_bloc.dart';
import '../blocs/profile_event.dart';
import '../blocs/profile_state.dart';

/// SCR-24 Master Screen: Profile & Account (screen-profile-garage)
/// Matches D:\Q4 Planning\design\src\modules\settings\settings.template.html
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAF6),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Carbon Fiber Header Twill Weave
                _buildCarbonHeader(context),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Member VIP Identity Card & Wallet Bar
                      _buildMemberCard(context, profileState),

                      const SizedBox(height: 18),

                      // 3. Group: Pengaturan Akun
                      _buildSectionTitle('AKUN'),
                      _buildGroupCard([
                        _buildListTile(
                          icon: TablerIcons.user,
                          title: 'Edit Profil',
                          subtitle: 'Perbarui identitas akun & kontak utama',
                          onTap: () => context.push(RouteNames.editProfile),
                        ),
                        const Divider(height: 1, indent: 56, color: Color(0x0F000000)),
                        _buildListTile(
                          icon: TablerIcons.lock,
                          title: 'Ganti Password',
                          subtitle: 'Perbarui kata sandi keamanan login Anda',
                          onTap: () => context.push(RouteNames.changePassword),
                        ),
                        const Divider(height: 1, indent: 56, color: Color(0x0F000000)),
                        _buildListTile(
                          icon: TablerIcons.login,
                          title: 'Masuk / Beralih Akun (nine_try_db)',
                          subtitle: 'Login ke akun tersimpan di database',
                          onTap: () => context.push(RouteNames.login),
                        ),
                      ]),

                  const SizedBox(height: 18),

                  // 4. Group: Kendaraan
                  _buildSectionTitle('KENDARAAN'),
                  _buildGroupCard([
                    _buildListTile(
                      icon: TablerIcons.car,
                      hasActiveDot: true,
                      dotColor: const Color(0xFF8DC63F),
                      title: 'Honda HR-V RS Turbo (2022)',
                      subtitle: 'B 1999 NNE • 14.280 km • 4 Orang',
                      onTap: () => _showVehicleSwitcherSheet(context),
                    ),
                  ]),

                  const SizedBox(height: 18),

                  // 5. Group: Keluarga Saya
                  _buildSectionTitle('KELUARGA SAYA'),
                  _buildGroupCard([
                    _buildListTile(
                      icon: TablerIcons.users_group,
                      hasActiveDot: true,
                      dotColor: const Color(0xFF8DC63F),
                      title: 'Lingkaran Keluarga Pratama',
                      subtitle: '4 Anggota Terhubung',
                      onTap: () => _showFamilySheet(context),
                    ),
                  ]),

                  const SizedBox(height: 18),

                  // 6. Group: Aktivitas & Transaksi
                  _buildSectionTitle('AKTIVITAS'),
                  _buildGroupCard([
                    _buildListTile(
                      icon: TablerIcons.truck_delivery,
                      hasActiveDot: true,
                      dotColor: const Color(0xFF231F20),
                      title: 'Pesanan Nine Mall',
                      subtitle: 'BiLED Matrix Pro 3.0" • Dalam Pengiriman',
                      onTap: () => context.go(RouteNames.mall),
                    ),
                    const Divider(height: 1, indent: 56, color: Color(0x0F000000)),
                    _buildListTile(
                      icon: TablerIcons.tool,
                      hasActiveDot: true,
                      dotColor: const Color(0xFF3B82F6),
                      title: 'Booking Bengkel',
                      subtitle: 'Riwayat reservasi & E-SPK resmi',
                      onTap: () => context.push(RouteNames.ticketLookup),
                    ),
                    const Divider(height: 1, indent: 56, color: Color(0x0F000000)),
                    _buildListTile(
                      icon: TablerIcons.map_pin,
                      title: 'Daftar Alamat Pengiriman',
                      subtitle: '2 Alamat (Surabaya Barat & Jakarta)',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Daftar Alamat: Surabaya Barat (Utama) & Jakarta')),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 18),

                  // 7. Group: Perangkat & Aksesoris IoT
                  _buildSectionTitle('PERANGKAT'),
                  _buildGroupCard([
                    _buildListTile(
                      icon: TablerIcons.cpu,
                      hasActiveDot: true,
                      dotColor: const Color(0xFF8DC63F),
                      title: 'Hub Aksesoris IoT',
                      subtitle: 'Dashcam 4K, Smart Lamp, GPS Tracker',
                      onTap: () => context.go(RouteNames.accessories),
                    ),
                    const Divider(height: 1, indent: 56, color: Color(0x0F000000)),
                    _buildListTile(
                      icon: TablerIcons.plus,
                      title: 'Tautkan Aksesoris Baru',
                      subtitle: 'Pindai barcode atau hubungkan perangkat IoT baru',
                      onTap: () {
                        HapticFeedback.lightImpact();
                        showDeviceManagerSheet(context, sl<SmartLightingBloc>());
                      },
                    ),
                  ]),

                  const SizedBox(height: 18),

                  // 8. Group: Bantuan & Dukungan 24/7
                  _buildSectionTitle('BANTUAN'),
                  _buildGroupCard([
                    _buildSupportTile(
                      icon: TablerIcons.headset,
                      title: 'Nine Care Center 24/7',
                      subtitle: '021-5099-9999 (Bebas Pulsa)',
                      actionLabel: 'Panggil',
                      actionIcon: TablerIcons.phone_call,
                      isDarkAction: true,
                      onActionTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Menghubungkan ke Nine Care: 021-5099-9999')),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 56, color: Color(0x0F000000)),
                    _buildSupportTile(
                      icon: TablerIcons.brand_whatsapp,
                      title: 'WhatsApp Official Care',
                      subtitle: '+62 811-999-NINE',
                      actionLabel: 'Chat CS',
                      actionIcon: TablerIcons.message_circle,
                      isDarkAction: false,
                      onActionTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Membuka WhatsApp CS: +62 811-999-NINE')),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // App Version Footer
                  Center(
                    child: Text(
                      'Nine® AutoSeries v2.4.0 (Build 20261126)\nPT Sembilan Autoseries Indonesia',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10.5,
                        color: Colors.grey.shade500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  // --- Sub-widgets & Builders ---

  Widget _buildCarbonHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF14171A),
        border: const Border(
          bottom: BorderSide(color: Color(0x598DC63F), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Akun',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        TablerIcons.circle_check_filled,
                        color: Color(0xFF8DC63F),
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Gaspol terus!',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Logout Action Button
              NineSpringTap(
                onTap: () => _showLogoutConfirmDialog(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withAlpha(35)),
                  ),
                  child: const Icon(
                    TablerIcons.logout,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, ProfileState profileState) {
    final user = profileState.user;
    final initials = user.name.trim().isNotEmpty
        ? user.name.trim().split(' ').where((w) => w.isNotEmpty).map((w) => w[0]).take(2).join().toUpperCase()
        : 'AP';
    final contactText = '${user.phone}${user.email != null && user.email!.isNotEmpty ? ' • ${user.email}' : ''}';
    final coinFormatted = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(user.nineKoinBalance).trim();
    final coinText = '$coinFormatted Poin';
    final voucherCount = profileState.vouchers.isNotEmpty ? profileState.vouchers.length : 3;
    final voucherText = '$voucherCount Kupon';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withAlpha(15)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Row: Avatar + Name + Contact
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF231F20), Color(0xFF141715)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withAlpha(25)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Color(0xFF8DC63F),
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF047857),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.check, size: 8, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF18191D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contactText,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Enhanced Wallet Bar: N-Coins & Vouchers
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF141716), Color(0xFF1E2328), Color(0xFF141716)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withAlpha(25)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // N-Coins
                Expanded(
                  child: NineSpringTap(
                    onTap: () => context.push(RouteNames.loyalty),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(TablerIcons.coin, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'N-COINS',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFFBBF24),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                coinText,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(TablerIcons.chevron_right, size: 14, color: Colors.white38),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: 1,
                  height: 30,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white.withAlpha(35),
                ),

                // Voucher Kupon
                Expanded(
                  child: NineSpringTap(
                    onTap: () => context.push(RouteNames.vouchers),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8DC63F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(TablerIcons.ticket, color: Color(0xFF18191D), size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'VOUCHER',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF8DC63F),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                voucherText,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(TablerIcons.chevron_right, size: 14, color: Colors.white38),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
          color: Color(0xFF6B7280),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildGroupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withAlpha(15)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool hasActiveDot = false,
    Color dotColor = const Color(0xFF8DC63F),
  }) {
    return NineSpringTap(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 18, color: const Color(0xFF18191D)),
                ),
                if (hasActiveDot)
                  Positioned(
                    top: -1,
                    right: -1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF18191D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(TablerIcons.chevron_right, size: 15, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionLabel,
    required IconData actionIcon,
    required bool isDarkAction,
    required VoidCallback onActionTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF18191D)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF18191D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          NineSpringTap(
            onTap: onActionTap,
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isDarkAction ? const Color(0xFF18191D) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    actionIcon,
                    size: 13,
                    color: isDarkAction ? Colors.white : const Color(0xFF18191D),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    actionLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDarkAction ? Colors.white : const Color(0xFF18191D),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari Akun?'),
        content: const Text('Apakah Anda yakin ingin keluar dari sesi aplikasi Nine AutoSeries ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(const LogoutEvent());
              context.read<ProfileBloc>().add(const LoadProfileEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Anda telah keluar dari akun.')),
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showVehicleSwitcherSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kendaraan Terdaftar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            _buildVehicleOption('Honda HR-V RS Turbo (2022)', 'B 1999 NNE', true, () => Navigator.pop(ctx)),
            _buildVehicleOption('Toyota Innova Zenix Q Hybrid', 'B 8888 LIVE', false, () => Navigator.pop(ctx)),
            _buildVehicleOption('Honda PCX 160 e:HEV', 'B 3456 NNE', false, () => Navigator.pop(ctx)),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleOption(String name, String plate, bool isSelected, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(TablerIcons.car),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      subtitle: Text(plate, style: const TextStyle(fontSize: 11)),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF8DC63F)) : null,
    );
  }

  void _showFamilySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lingkaran Keluarga Pratama',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              '4 Anggota memiliki izin akses telemetri & IoT kendaraan utama.',
              style: TextStyle(fontSize: 11.5, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildFamilyMember('Aditya Pratama', 'Kepala Keluarga • Pemilik'),
            _buildFamilyMember('Sarah Putri', 'Istri • Akses Penuh'),
            _buildFamilyMember('Rafi Pratama', 'Anak • Akses Lokasi'),
            _buildFamilyMember('Budi Santoso', 'Sopir Pribadi • Akses Terbatas'),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyMember(String name, String role) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: const Color(0xFFF1F5F9),
        child: Text(name[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
      subtitle: Text(role, style: const TextStyle(fontSize: 10.5)),
    );
  }
}
