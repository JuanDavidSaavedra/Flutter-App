import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/delivery_provider.dart';
import '../models/delivery_model.dart';
import '../theme/app_theme.dart';

class SupervisorScreen extends StatelessWidget {
  const SupervisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = Provider.of<DeliveryProvider>(context);

    if (deliveryProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        // PATRÓN DE FONDO INCORPORADO
        image: DecorationImage(
          image: AssetImage('assets/images/background_pattern.png'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Estadísticas
            _buildStatsHeader(deliveryProvider),
            
            // Tabs
            Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: AppColors.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primaryColor,
                tabs: [
                  Tab(text: 'Todas las Entregas'),
                  Tab(text: 'Por Repartidor'),
                ],
              ),
            ),
            
            // Contenido de los tabs
            Expanded(
              child: TabBarView(
                children: [
                  _buildAllDeliveriesView(deliveryProvider),
                  _buildByPersonView(deliveryProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader(DeliveryProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getHeaderColor(provider.completionPercentage),
            _getHeaderColor(provider.completionPercentage).withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: _getHeaderColor(provider.completionPercentage).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Resumen de Entregas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Estadísticas principales
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Total', provider.deliveries.length, Icons.inventory, Colors.white),
              _buildStatCard('Pendientes', provider.pendingDeliveries.length, Icons.pending_actions, Colors.orange[100]!),
              _buildStatCard('Completadas', provider.completedDeliveries.length, Icons.check_circle, Colors.green[100]!),
            ],
          ),
          const SizedBox(height: 16),
          
          // Barra de progreso
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progreso General',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${(provider.completionPercentage * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: provider.completionPercentage,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 12,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHeaderColor(double percentage) {
    if (percentage < 0.3) return Colors.red[400]!;
    if (percentage < 0.7) return Colors.orange[400]!;
    return Colors.green[400]!;
  }

  Widget _buildStatCard(String title, int value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildAllDeliveriesView(DeliveryProvider provider) {
    return ListView.builder(
      itemCount: provider.deliveries.length,
      itemBuilder: (context, index) {
        final delivery = provider.deliveries[index];
        return _buildDeliveryStatusCard(delivery);
      },
    );
  }

  Widget _buildByPersonView(DeliveryProvider provider) {
    final deliveriesByPerson = <String, List<Delivery>>{};
    
    for (final delivery in provider.deliveries) {
      deliveriesByPerson.putIfAbsent(delivery.deliveryPerson, () => []);
      deliveriesByPerson[delivery.deliveryPerson]!.add(delivery);
    }

    return ListView.builder(
      itemCount: deliveriesByPerson.length,
      itemBuilder: (context, index) {
        final person = deliveriesByPerson.keys.elementAt(index);
        final personDeliveries = deliveriesByPerson[person]!;
        final completedCount = personDeliveries.where((d) => d.isDelivered).length;
        final completionRate = personDeliveries.isEmpty ? 0.0 : completedCount / personDeliveries.length;
        
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header del repartidor
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            person,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${completedCount}/${personDeliveries.length} entregas completadas',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      label: Text(
                        '${(completionRate * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: _getCompletionColor(completionRate),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Barra de progreso individual
                LinearProgressIndicator(
                  value: completionRate,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getCompletionColor(completionRate),
                  ),
                  minHeight: 6,
                ),
                const SizedBox(height: 12),
                
                // Lista de entregas del repartidor
                ...personDeliveries.map((delivery) => ListTile(
                  leading: delivery.isDelivered
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.schedule, color: Colors.orange),
                  title: Text(
                    delivery.recipient,
                    style: TextStyle(
                      decoration: delivery.isDelivered ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(delivery.address),
                  trailing: Text(
                    delivery.isDelivered ? 'Entregado' : 'Pendiente',
                    style: TextStyle(
                      color: delivery.isDelivered ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getCompletionColor(double rate) {
    if (rate < 0.5) return Colors.red;
    if (rate < 0.8) return Colors.orange;
    return Colors.green;
  }

  // Widget para tarjeta de estado de entrega
  Widget _buildDeliveryStatusCard(Delivery delivery) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: delivery.isDelivered ? Colors.green[100] : Colors.orange[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            delivery.isDelivered ? Icons.check : Icons.pending,
            color: delivery.isDelivered ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(
          delivery.recipient,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: delivery.isDelivered ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(delivery.address),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.person, size: 12),
                const SizedBox(width: 4),
                Text(
                  delivery.deliveryPerson,
                  style: const TextStyle(fontSize: 12),
                ),
                const Spacer(),
                const Icon(Icons.inventory_2, size: 12),
                const SizedBox(width: 4),
                Text(
                  delivery.packageType,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: delivery.isDelivered ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                delivery.isDelivered ? 'ENTREGADO' : 'PENDIENTE',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(delivery.estimatedTime),
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}