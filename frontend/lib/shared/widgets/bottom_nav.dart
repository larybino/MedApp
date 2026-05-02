import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final navHeight = height * 0.09 < 56 ? 56.0 : (height * 0.09 > 80 ? 80.0 : height * 0.09);
    final iconSize = width * 0.07 < 22 ? 22.0 : (width * 0.07 > 32 ? 32.0 : width * 0.07);
    final fontSize = width * 0.025 < 10 ? 10.0 : (width * 0.025 > 14 ? 14.0 : width * 0.025);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: navHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
                iconSize: iconSize,
                fontSize: fontSize,
              ),
              _NavItem(
                icon: Icons.medication_outlined,
                activeIcon: Icons.medication_rounded,
                label: 'Remédios',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
                iconSize: iconSize,
                fontSize: fontSize,
              ),
              _NavItem(
                icon: Icons.add_rounded,
                activeIcon: Icons.add_rounded,
                label: 'Novo',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
                iconSize: iconSize,
                fontSize: fontSize,
              ),
              _NavItem(
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month_rounded,
                label: 'Agenda',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
                iconSize: iconSize,
                fontSize: fontSize,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Config',
                isActive: currentIndex == 4,
                onTap: () => onTap(4),
                iconSize: iconSize,
                fontSize: fontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.white : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: iconSize * 2.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? activeIcon : icon, color: color, size: iconSize),
            SizedBox(height: fontSize * 0.3),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

