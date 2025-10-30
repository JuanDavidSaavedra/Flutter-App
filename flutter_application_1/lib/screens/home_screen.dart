import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';
import '../theme/app_theme.dart';
import 'delivery_person_screen.dart';
import 'supervisor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const LogoWidget(
            size: 35, 
            useWhiteLogo: true, // CORREGIDO: sin parámetro 'color'
            withText: true, color: Colors.white,
          ),
          backgroundColor: AppColors.primaryColor,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: const Color(0xFFC8E6C9),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs: const [
              Tab(
                icon: Icon(Icons.delivery_dining, color: Colors.white),
                text: 'REPARTIDOR',
              ),
              Tab(
                icon: Icon(Icons.supervisor_account, color: Colors.white),
                text: 'SUPERVISOR',
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            // FONDO CON PATRÓN - MEJORADO
            image: DecorationImage(
              image: AssetImage('assets/images/background_pattern.png'),
              fit: BoxFit.cover,
              opacity: 0.15,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8FFF8),
                Color(0xFFE8F5E8),
              ],
            ),
          ),
          child: const TabBarView(
            children: [
              DeliveryPersonScreen(),
              SupervisorScreen(),
            ],
          ),
        ),
      ),
    );
  }
}