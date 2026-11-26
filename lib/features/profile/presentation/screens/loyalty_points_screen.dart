import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:nine_ui_app/nine_ui.dart';
import '../../../../core/theme/app_colors.dart';

/// SCR-25: Loyalty N-Coins & VIP Pass Screen (screen-profile-loyalty)
/// Replicates D:\Q4 Planning\design\src\modules\settings\settings.template.html (lines 459-522)
class LoyaltyPointsScreen extends StatelessWidget {
  const LoyaltyPointsScreen({super.key});

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
              'Nine VIP Pass & N-Coins',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF18191D)),
            ),
            Text(
              'Saldo poin loyalitas & riwayat penukaran',
              style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.black.withAlpha(12), height: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // VIP Gold Pass Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF231F20), Color(0xFF141715)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withAlpha(25)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8DC63F).withAlpha(45),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF8DC63F), width: 0.8),
                      ),
                      child: const Text(
                        'VIP GOLD PASS',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF8DC63F),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Icon(TablerIcons.crown, color: Color(0xFFBA983D), size: 22),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '2.450 N-Coins',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Setara dengan potongan tunai Rp 24.500 saat checkout',
                  style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(190)),
                ),
                const SizedBox(height: 16),
                NineSpringTap(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Poin siap digunakan saat checkout Nine Mall.')),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Gunakan Poin di Nine Mall',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF231F20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'RIWAYAT POIN TERBARU',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              color: Color(0xFF6B7280),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          Container(
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
              children: [
                _buildHistoryItem(
                  title: 'Instalasi BiLED Matrix Pro',
                  dateBranch: '04 Nov 2026 • Cabang Surabaya',
                  points: '+1.250',
                ),
                const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0x0F000000)),
                _buildHistoryItem(
                  title: 'Belanja Lampu Tembak Q5 PRO',
                  dateBranch: '19 Okt 2026 • Nine Mall',
                  points: '+1.400',
                ),
                const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0x0F000000)),
                _buildHistoryItem(
                  title: 'Penukaran Diskon Servis',
                  dateBranch: '01 Okt 2026 • Nine Garage',
                  points: '-200',
                  isPositive: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String dateBranch,
    required String points,
    bool isPositive = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF18191D)),
              ),
              const SizedBox(height: 2),
              Text(
                dateBranch,
                style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
              ),
            ],
          ),
          Text(
            points,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: isPositive ? const Color(0xFF047857) : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
