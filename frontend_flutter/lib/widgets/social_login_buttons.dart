import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.google, color: Color(0xFFEA4335)),
                label: Text('Google', style: GoogleFonts.poppins(color: Color(0xFF232136), fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF2979FF), width: 1.5),
                  foregroundColor: Color(0xFF232136),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.apple, color: Color(0xFF232136)),
                label: Text('Apple', style: GoogleFonts.poppins(color: Color(0xFF232136), fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF2979FF), width: 1.5),
                  foregroundColor: Color(0xFF232136),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 