import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onChanged;
  const RoleSelector({super.key, required this.selectedRole, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Professional light palette
    const blue = Color(0xFF2979FF);
    const turquoise = Color(0xFF2DD4BF);
    const gray = Color(0xFF6B7280);
    const lightBlueBg = Color(0xFFE3F0FF);
    const lightTurquoiseBg = Color(0xFFE0FCF8);
    const lightGrayBg = Color(0xFFF3F4F6);
    const lightGrayBorder = Color(0xFFE5E7EB);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoleOption(
          icon: FontAwesomeIcons.user,
          label: 'User',
          selected: selectedRole == 'user',
          onTap: () => onChanged('user'),
          selectedColor: blue,
          selectedBg: lightBlueBg,
          unselectedColor: gray,
          unselectedBg: lightGrayBg,
          selectedBorder: blue,
          unselectedBorder: lightGrayBorder,
        ),
        const SizedBox(width: 28),
        _RoleOption(
          icon: FontAwesomeIcons.store,
          label: 'Shop Owner',
          selected: selectedRole == 'shop',
          onTap: () => onChanged('shop'),
          selectedColor: turquoise,
          selectedBg: lightTurquoiseBg,
          unselectedColor: gray,
          unselectedBg: lightGrayBg,
          selectedBorder: turquoise,
          unselectedBorder: lightGrayBorder,
        ),
      ],
    );
  }
}

class _RoleOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color selectedBg;
  final Color unselectedColor;
  final Color unselectedBg;
  final Color selectedBorder;
  final Color unselectedBorder;
  const _RoleOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectedColor,
    required this.selectedBg,
    required this.unselectedColor,
    required this.unselectedBg,
    required this.selectedBorder,
    required this.unselectedBorder,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? selectedBg : unselectedBg;
    final color = selected ? selectedColor : unselectedColor;
    final borderColor = selected ? selectedBorder : unselectedBorder;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            FaIcon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: color,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 