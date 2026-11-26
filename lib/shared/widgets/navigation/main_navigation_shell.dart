import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_ui_app/nine_ui.dart';

/// Master 4-Tab Navigation Shell
/// Houses the Floating Bottom Dock corresponding to D:\Q4 Planning\design\index.html (lines 362-396)
class MainNavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationShell({
    super.key,
    required this.navigationShell,
  });

  static const List<NineDockItem> _dockItems = [
    NineDockItem(
      id: 'home',
      label: 'Home',
      icon: TablerIcons.home_2,
    ),
    NineDockItem(
      id: 'accessories',
      label: 'Aksesoris',
      icon: TablerIcons.devices,
    ),
    NineDockItem(
      id: 'mall',
      label: 'Mall',
      icon: TablerIcons.shopping_bag,
      badgeCount: 2,
    ),
    NineDockItem(
      id: 'profile',
      label: 'Profile',
      icon: TablerIcons.user,
    ),
  ];

  static const List<String> _branchIds = ['home', 'accessories', 'mall', 'profile'];

  void _onTabSelected(String id) {
    HapticFeedback.lightImpact();
    final index = _branchIds.indexOf(id);
    if (index != -1) {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeId = _branchIds[navigationShell.currentIndex.clamp(0, _branchIds.length - 1)];

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Active Branch Page with bottom padding so content doesn't hide behind the floating dock
          Positioned.fill(
            child: navigationShell,
          ),

          // Floating Dock at Bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Center(
                  child: NineFloatingDock(
                    items: _dockItems,
                    activeId: activeId,
                    onSelect: _onTabSelected,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
