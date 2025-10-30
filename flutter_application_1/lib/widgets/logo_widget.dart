import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final bool withText;
  final bool useWhiteLogo;

  const LogoWidget({
    super.key,
    this.size = 40,
    this.withText = true,
    this.useWhiteLogo = false, required Color color,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar qué imagen usar
    final String imagePath = useWhiteLogo 
        ? 'assets/images/logo_white.png'
        : 'assets/images/logo.png';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Usar Image.asset en lugar del icono
        Image.asset(
          imagePath,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) {
            // Fallback si la imagen no carga
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: useWhiteLogo ? Colors.white : const Color(0xFF00C853),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.pedal_bike,
                color: useWhiteLogo ? const Color(0xFF00C853) : Colors.white,
                size: size * 0.6,
              ),
            );
          },
        ),
        
        if (withText) ...[
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GreenGo',
                style: TextStyle(
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.w700,
                  color: useWhiteLogo ? Colors.white : const Color(0xFF00C853),
                ),
              ),
              Text(
                'LOGISTICS',
                style: TextStyle(
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.w500,
                  color: useWhiteLogo ? Colors.white70 : const Color(0xFF757575),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}