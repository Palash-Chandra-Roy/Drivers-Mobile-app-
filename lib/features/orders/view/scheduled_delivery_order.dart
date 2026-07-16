// Local order payload for the Scheduled On Track delivery flow only.
import 'package:flutter/material.dart';

class ScheduledOrderItem {
  const ScheduledOrderItem({
    required this.quantity,
    required this.name,
  });

  final String quantity;
  final String name;
}

enum ScheduledPaymentType { prepaid, cash }

class ScheduledDeliveryOrder {
  const ScheduledDeliveryOrder({
    required this.orderId,
    required this.vendorName,
    required this.vendorAddress,
    required this.category,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.scheduledWindow,
    required this.pickupDeadlineNotice,
    required this.distance,
    required this.eta,
    required this.items,
    required this.isFragileHighValue,
    required this.paymentType,
    required this.earnings,
    required this.tip,
    required this.totalDeliveryTime,
    required this.deliveryDistance,
    required this.deliveryEta,
    required this.orderTypeLabel,
    required this.cardRouteLabel,
    required this.cardStatusLine,
    this.cashAmount,
  });

  final String orderId;
  final String vendorName;
  final String vendorAddress;
  final String category;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String scheduledWindow;
  final String pickupDeadlineNotice;
  final String distance;
  final String eta;
  final List<ScheduledOrderItem> items;
  final bool isFragileHighValue;
  final ScheduledPaymentType paymentType;
  final String? cashAmount;
  final String earnings;
  final String tip;
  final String totalDeliveryTime;
  final String deliveryDistance;
  final String deliveryEta;
  final String orderTypeLabel;
  final String cardRouteLabel;
  final String cardStatusLine;

  String get distanceEtaLabel => '$distance · $eta';
  String get deliveryDistanceEtaLabel => '$deliveryDistance · $deliveryEta';
  int get itemCount => items.length;

  String get paymentSummary {
    if (paymentType == ScheduledPaymentType.prepaid) {
      return 'Prepaid — Yjeek Wallet';
    }
    return 'Cash — ${cashAmount ?? ''}';
  }

  bool get isPrepaid => paymentType == ScheduledPaymentType.prepaid;
}

class ScheduledDeliveryScale {
  ScheduledDeliveryScale._();

  static const Size designSize = Size(390, 844);
  static Size screenSize = designSize;

  static void update(Size size) {
    if (size.width > 0 && size.height > 0) {
      screenSize = size;
    }
  }

  static double width(num value) =>
      value.toDouble() * (screenSize.width / designSize.width);

  static double height(num value) =>
      value.toDouble() * (screenSize.height / designSize.height);
}

extension ScheduledDeliveryUnits on num {
  double get sw => ScheduledDeliveryScale.width(this);

  double get sh => ScheduledDeliveryScale.height(this);

  double get ssp => ScheduledDeliveryScale.width(this);
}
