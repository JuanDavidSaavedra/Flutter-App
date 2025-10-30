import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/delivery_model.dart';

class DeliveryProvider with ChangeNotifier {
  List<Delivery> _deliveries = [];
  bool _isLoading = true;

  List<Delivery> get deliveries => _deliveries;
  bool get isLoading => _isLoading;

  DeliveryProvider() {
    _loadDeliveries();
  }

  List<Delivery> get pendingDeliveries =>
      _deliveries.where((delivery) => !delivery.isDelivered).toList();

  List<Delivery> get completedDeliveries =>
      _deliveries.where((delivery) => delivery.isDelivered).toList();

  double get completionPercentage {
    if (_deliveries.isEmpty) return 0.0;
    return completedDeliveries.length / _deliveries.length;
  }

  Map<String, List<Delivery>> get deliveriesByPerson {
    final Map<String, List<Delivery>> result = {};
    for (final delivery in _deliveries) {
      result.putIfAbsent(delivery.deliveryPerson, () => []);
      result[delivery.deliveryPerson]!.add(delivery);
    }
    return result;
  }

  Future<void> _loadDeliveries() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final deliveriesJson = prefs.getStringList('deliveries');

      if (deliveriesJson != null && deliveriesJson.isNotEmpty) {
        _deliveries = deliveriesJson
            .map((json) => Delivery.fromJson(_parseJsonString(json)))
            .toList();
      } else {
        // Datos iniciales
        _deliveries = _getInitialData();
        await _saveDeliveries();
      }
    } catch (error) {
      print('Error loading deliveries: $error');
      _deliveries = _getInitialData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _parseJsonString(String jsonString) {
    // Simple JSON parsing for our structure
    final cleaned = jsonString.replaceAll('{', '').replaceAll('}', '');
    final pairs = cleaned.split(',');
    final Map<String, dynamic> result = {};
    
    for (final pair in pairs) {
      final keyValue = pair.split(':');
      if (keyValue.length == 2) {
        final key = keyValue[0].trim();
        var value = keyValue[1].trim();
        
        // Convertir tipos
        if (key == 'isDelivered') {
          result[key] = value.toLowerCase() == 'true';
        } else if (key == 'estimatedTime') {
          result[key] = value;
        } else {
          result[key] = value;
        }
      }
    }
    return result;
  }

  List<Delivery> _getInitialData() {
    return [
      Delivery(
        id: '1',
        address: 'Calle Principal 123',
        recipient: 'María González',
        packageType: 'Documentos',
        isDelivered: false,
        deliveryPerson: 'Carlos Ruiz',
        estimatedTime: DateTime.now().add(const Duration(hours: 1)),
      ),
      Delivery(
        id: '2',
        address: 'Avenida Central 456',
        recipient: 'Juan Pérez',
        packageType: 'Paquete pequeño',
        isDelivered: false,
        deliveryPerson: 'Ana López',
        estimatedTime: DateTime.now().add(const Duration(hours: 2)),
      ),
      Delivery(
        id: '3',
        address: 'Plaza Mayor 789',
        recipient: 'Roberto Silva',
        packageType: 'Alimentos',
        isDelivered: true,
        deliveryPerson: 'Carlos Ruiz',
        estimatedTime: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Delivery(
        id: '4',
        address: 'Calle Norte 321',
        recipient: 'Laura Martínez',
        packageType: 'Electrónicos',
        isDelivered: false,
        deliveryPerson: 'Ana López',
        estimatedTime: DateTime.now().add(const Duration(hours: 3)),
      ),
      Delivery(
        id: '5',
        address: 'Avenida Sur 654',
        recipient: 'Pedro Rodríguez',
        packageType: 'Ropa',
        isDelivered: false,
        deliveryPerson: 'Carlos Ruiz',
        estimatedTime: DateTime.now().add(const Duration(hours: 4)),
      ),
    ];
  }

  Future<void> _saveDeliveries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deliveriesJson = _deliveries.map((delivery) {
        final json = delivery.toJson();
        return json.toString();
      }).toList();
      await prefs.setStringList('deliveries', deliveriesJson);
    } catch (error) {
      print('Error saving deliveries: $error');
    }
  }

  Future<void> markAsDelivered(String deliveryId) async {
    final index = _deliveries.indexWhere((delivery) => delivery.id == deliveryId);
    if (index != -1) {
      _deliveries[index] = _deliveries[index].copyWith(isDelivered: true);
      await _saveDeliveries();
      notifyListeners();
    }
  }

  Future<void> resetData() async {
    _deliveries = _getInitialData();
    await _saveDeliveries();
    notifyListeners();
  }

  Future<void> addDelivery(Delivery delivery) async {
    _deliveries.add(delivery);
    await _saveDeliveries();
    notifyListeners();
  }
}