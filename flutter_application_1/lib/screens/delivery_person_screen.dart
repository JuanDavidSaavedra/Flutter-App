import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/delivery_model.dart';
import '../providers/delivery_provider.dart';

class DeliveryPersonScreen extends StatelessWidget {
  const DeliveryPersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = Provider.of<DeliveryProvider>(context);
    final pendingDeliveries = deliveryProvider.pendingDeliveries;

    if (deliveryProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Header con imagen de bicicleta - MEJORADO
          _buildHeader(pendingDeliveries.isEmpty, pendingDeliveries.length),
          
          // Barra de progreso animada
          if (pendingDeliveries.isNotEmpty) ...[
            _buildProgressBar(deliveryProvider),
          ],
          
          // Lista de entregas
          Expanded(
            child: _buildDeliveryContent(pendingDeliveries),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showResetDialog(context),
        child: const Icon(Icons.refresh),
        mini: true,
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Widget para el header con imagen de bicicleta
  Widget _buildHeader(bool isEmpty, int pendingCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isEmpty
              ? [Color(0xFF4CAF50), Color(0xFF66BB6A)] // Verde cuando está completo
              : [Color(0xFFFF9800), Color(0xFFFFB74D)], // Naranja cuando hay pendientes
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // IMAGEN DE BICICLETA - IMPLEMENTADA
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/delivery_bike.png',
              width: 80,
              height: 80,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) {
                // Fallback si la imagen no carga
                return const Icon(
                  Icons.electric_bike,
                  size: 50,
                  color: Colors.white,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isEmpty ? '¡Misión Cumplida!' : 'Entregas Pendientes',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEmpty ? 'Todas las entregas completadas 🎉' : '$pendingCount paquetes por entregar',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(DeliveryProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              height: 12,
              child: LinearProgressIndicator(
                value: provider.completionPercentage,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(provider.completionPercentage),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(provider.completionPercentage * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage < 0.3) return Colors.red;
    if (percentage < 0.7) return Colors.orange;
    return Colors.green;
  }

  Widget _buildDeliveryContent(List<Delivery> pendingDeliveries) {
    if (pendingDeliveries.isEmpty) {
      return _buildEmptyState();
    } else {
      return _buildDeliveryList(pendingDeliveries);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '¡Misión Cumplida!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Todas las entregas han sido completadas',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryList(List<Delivery> deliveries) {
    return ListView.builder(
      itemCount: deliveries.length,
      itemBuilder: (context, index) {
        if (index < 0 || index >= deliveries.length) {
          return const SizedBox();
        }
        
        final delivery = deliveries[index];
        return AnimatedDeliveryCard(delivery: delivery);
      },
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resetear Datos'),
        content: const Text('¿Restablecer todas las entregas a su estado inicial?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<DeliveryProvider>(context, listen: false).resetData();
              Navigator.pop(context);
            },
            child: const Text('Resetear'),
          ),
        ],
      ),
    );
  }
}

class AnimatedDeliveryCard extends StatefulWidget {
  final Delivery delivery;

  const AnimatedDeliveryCard({super.key, required this.delivery});

  @override
  State<AnimatedDeliveryCard> createState() => _AnimatedDeliveryCardState();
}

class _AnimatedDeliveryCardState extends State<AnimatedDeliveryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = Provider.of<DeliveryProvider>(context, listen: false);

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(_animation),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Ícono del tipo de paquete
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getPackageColor(widget.delivery.packageType),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getPackageIcon(widget.delivery.packageType),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Información de la entrega
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.delivery.recipient,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.delivery.address,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.delivery.deliveryPerson,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTime(widget.delivery.estimatedTime),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Botón de entrega
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => _showDeliveryConfirmation(context, deliveryProvider, widget.delivery),
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getPackageColor(String packageType) {
    switch (packageType) {
      case 'Documentos': return Colors.blue;
      case 'Alimentos': return Colors.orange;
      case 'Electrónicos': return Colors.purple;
      case 'Ropa': return Colors.pink;
      default: return Colors.green;
    }
  }

  IconData _getPackageIcon(String packageType) {
    switch (packageType) {
      case 'Documentos': return Icons.description;
      case 'Alimentos': return Icons.restaurant;
      case 'Electrónicos': return Icons.electrical_services;
      case 'Ropa': return Icons.checkroom;
      default: return Icons.inventory_2;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showDeliveryConfirmation(BuildContext context, DeliveryProvider provider, Delivery delivery) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Entrega'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Marcar entrega como completada?'),
            const SizedBox(height: 8),
            Text(
              '${delivery.recipient} - ${delivery.packageType}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.markAsDelivered(delivery.id);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('¡Entrega a ${delivery.recipient} completada!'),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: const Text('Confirmar Entrega'),
          ),
        ],
      ),
    );
  }
}