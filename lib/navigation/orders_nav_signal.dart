import 'package:flutter/material.dart';

/// Local signal so Dashboard can open Orders → Scheduled
/// while keeping BottomNavigation on the Orders tab.
/// Does not use / change app-wide state management.
class OrdersNavSignal {
  OrdersNavSignal._();

  /// 0 = Instant, 1 = Scheduled. Null = no pending request.
  static final ValueNotifier<int?> pendingSegment = ValueNotifier<int?>(null);

  static void openScheduled() => pendingSegment.value = 1;

  static void openInstant() => pendingSegment.value = 0;

  static void clear() => pendingSegment.value = null;
}
