import 'package:flutter/material.dart';

class ImageTestScreen extends StatelessWidget {
  const ImageTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de Imágenes')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildImageTest('Logo Principal', 'assets/images/logo.png'),
          _buildImageTest('Logo Blanco', 'assets/images/logo_white.png'),
          _buildImageTest('Bicicleta', 'assets/images/delivery_bike.png'),
          _buildImageTest('Patrón', 'assets/images/background_pattern.png'),
        ],
      ),
    );
  }

  Widget _buildImageTest(String title, String path) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Image.asset(
              path,
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 50),
                    Text('Error: $error'),
                    Text('Path: $path'),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            Text('Ruta: $path'),
          ],
        ),
      ),
    );
  }
}