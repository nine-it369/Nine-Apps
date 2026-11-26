import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../smart_lighting/presentation/blocs/smart_lighting_bloc.dart';
import '../../../smart_lighting/presentation/widgets/home_hero_led_card.dart';
import '../../../smart_lighting/presentation/widgets/smart_lamp_modals.dart';

/// SCR-15: Aksesoris Terpasang (IoT Hub)
/// Faithfully replicates D:\Q4 Planning\design\src\modules\iot\iot.template.html (#screen-iot-hub)
class AccessoriesScreen extends StatefulWidget {
  const AccessoriesScreen({super.key});

  @override
  State<AccessoriesScreen> createState() => _AccessoriesScreenState();
}

class _AccessoriesScreenState extends State<AccessoriesScreen> {
  String _selectedCategory = 'all'; // 'all', 'gps', 'dashcam', 'led', 'components'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14171A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Aksesoris Terpasang',
          style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 17),
        ),
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              showDeviceManagerSheet(context, sl<SmartLightingBloc>());
            },
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withAlpha(35)),
              ),
              child: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
            ),
            tooltip: 'Tambah Aksesoris Baru',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Solid Automotive Carbon Fiber Header Hero Stage
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
              decoration: BoxDecoration(
                color: const Color(0xFF14171A),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withAlpha(90),
                    width: 1.5,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kendalikan perangkat real-time kendaraaan Anda.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white70,
                            fontSize: 11.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Membuka katalog Nine Mall...'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Beli di Nine Mall',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Chips + Vehicle Dropdown Bar
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withAlpha(15)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Scrollable Category Chips
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCategoryChip('all', 'Semua (4)'),
                                const SizedBox(width: 6),
                                _buildCategoryChip('led', 'Smart LED (2)'),
                                const SizedBox(width: 6),
                                _buildCategoryChip('gps', 'GPS 4G (1)'),
                                const SizedBox(width: 6),
                                _buildCategoryChip('dashcam', 'Kamera 4K (1)'),
                                const SizedBox(width: 6),
                                _buildCategoryChip('components', 'Suku Cadang (3)'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Vehicle Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black.withAlpha(15)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.directions_car_rounded, size: 14, color: AppColors.primaryDark),
                              const SizedBox(width: 4),
                              Text(
                                'Honda HR-V',
                                style: AppTextStyles.mono.copyWith(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.obsidian,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Pilar 3: Smart Custom LED Matrix / Universal Lamp Hero Card
                  if (_selectedCategory == 'all' || _selectedCategory == 'led') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'SMART LIGHTING IOT',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Khusus Nine & Universal',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    BlocProvider.value(
                      value: sl<SmartLightingBloc>(),
                      child: const HomeHeroLedCard(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Pilar 1: Nine GPS (Clean C7 Card Anatomy)
                  if (_selectedCategory == 'all' || _selectedCategory == 'gps') ...[
                    _buildGpsCard(),
                    const SizedBox(height: 12),
                  ],

                  // Pilar 2: Nine Dashcam (Clean C7 Card Anatomy)
                  if (_selectedCategory == 'all' || _selectedCategory == 'dashcam') ...[
                    _buildDashcamCard(),
                    const SizedBox(height: 12),
                  ],

                  // Pilar 4: Pemeliharaan Suku Cadang & Jarak Tempuh GPS
                  if (_selectedCategory == 'all' || _selectedCategory == 'components') ...[
                    _buildComponentsCard(),
                    const SizedBox(height: 12),
                  ],

                  // Explicit Pairing Card: Tautkan Aksesoris Baru
                  _buildPairingAccessoryCard(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String id, String label) {
    final isSelected = _selectedCategory == id;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedCategory = id);
      },
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF231F20) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF231F20),
          ),
        ),
      ),
    );
  }

  Widget _buildGpsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(15)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.location_on_rounded, size: 24, color: Color(0xFF231F20)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Nine GPS', style: AppTextStyles.h3.copyWith(fontSize: 13)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'UUID: 9F4A-99812',
                              style: AppTextStyles.mono.copyWith(fontSize: 10, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Baterai 92% • Sisa Kuota 18.4 MB',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Online',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF047857)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Jl. Mayjen Sungkono 178, Surabaya Barat',
            style: AppTextStyles.h3.copyWith(fontSize: 12.5),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'Diperbarui 3 dtk lalu',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Buka Peta',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.obsidian,
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.obsidian),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashcamCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(15)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.videocam_rounded, size: 24, color: Color(0xFF231F20)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Nine Dashcam 4K', style: AppTextStyles.h3.copyWith(fontSize: 13)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'UUID: 4C-9902',
                              style: AppTextStyles.mono.copyWith(fontSize: 10, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Baterai 85% • Sisa Kuota 1.2 GB',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Online',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF047857)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.sd_card_rounded, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'Penyimpanan 86.4 / 128 GB',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Streaming & Galeri',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.obsidian,
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.obsidian),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComponentsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(15)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.speed_rounded, size: 24, color: Color(0xFF231F20)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Suku Cadang & Jarak Tempuh GPS', style: AppTextStyles.h3.copyWith(fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(
                        'Total Odometer: 14.820 km',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Aktif',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF047857)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPartItem('V-Belt', 0.59, '59%', 'Sisa 10.180 km', 'Baik', true),
                const SizedBox(width: 8),
                _buildPartItem('Oli Mesin', 0.96, '96%', 'Sisa 180 km', 'Servis', false),
                const SizedBox(width: 8),
                _buildPartItem('Kampas Rem', 0.49, '49%', 'Sisa 15.180 km', 'Baik', true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartItem(String name, double progress, String pct, String sisa, String status, bool isGood) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withAlpha(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyles.h3.copyWith(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Text(pct, style: AppTextStyles.mono.copyWith(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                isGood ? AppColors.primaryDark : AppColors.warning,
              ),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  sisa,
                  style: TextStyle(fontSize: 9.5, color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                status,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  color: isGood ? const Color(0xFF047857) : AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPairingAccessoryCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        showDeviceManagerSheet(context, sl<SmartLightingBloc>());
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFCBD5E1),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.add_rounded, size: 24, color: Color(0xFF231F20)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tautkan Aksesoris Baru',
                    style: AppTextStyles.h3.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tambahkan Dashcam, Smart LED (Khusus Nine / Universal), atau GPS Tracker Nine',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
