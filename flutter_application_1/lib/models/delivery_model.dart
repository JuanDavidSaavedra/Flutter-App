class Delivery {
  final String id;
  final String address;
  final String recipient;
  final String packageType;
  final bool isDelivered;
  final String deliveryPerson;
  final DateTime estimatedTime;

  const Delivery({
    required this.id,
    required this.address,
    required this.recipient,
    required this.packageType,
    required this.isDelivered,
    required this.deliveryPerson,
    required this.estimatedTime,
  });

  Delivery copyWith({
    bool? isDelivered,
  }) {
    return Delivery(
      id: id,
      address: address,
      recipient: recipient,
      packageType: packageType,
      isDelivered: isDelivered ?? this.isDelivered,
      deliveryPerson: deliveryPerson,
      estimatedTime: estimatedTime,
    );
  }

  // Métodos para serialización/deserialización
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'recipient': recipient,
      'packageType': packageType,
      'isDelivered': isDelivered,
      'deliveryPerson': deliveryPerson,
      'estimatedTime': estimatedTime.toIso8601String(),
    };
  }

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'],
      address: json['address'],
      recipient: json['recipient'],
      packageType: json['packageType'],
      isDelivered: json['isDelivered'],
      deliveryPerson: json['deliveryPerson'],
      estimatedTime: DateTime.parse(json['estimatedTime']),
    );
  }
}