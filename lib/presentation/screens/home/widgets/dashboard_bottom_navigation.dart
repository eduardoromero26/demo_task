import 'package:demo_task/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DashboardBottomNavigation extends StatelessWidget {
  const DashboardBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (_) {},
      height: 78,
      indicatorColor: Colors.transparent,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontFamily: AppTheme.fontFamily,
          fontSize: 11,
          color: selected ? AppTheme.primary : const Color(0xFF8C8C8C),
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        );
      }),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.calendar_month_rounded, color: Color(0xFF8C8C8C)),
          selectedIcon: Icon(
            Icons.calendar_month_rounded,
            color: AppTheme.primary,
          ),
          label: 'Work Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_rounded, color: Color(0xFF8C8C8C)),
          selectedIcon: Icon(Icons.history_rounded, color: AppTheme.secondary),
          label: 'History',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_rounded, color: Color(0xFF8C8C8C)),
          selectedIcon: Icon(Icons.settings_rounded, color: AppTheme.secondary),
          label: 'Settings',
        ),
      ],
    );
  }
}
