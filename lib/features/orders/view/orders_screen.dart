import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/orders/view/reject_scheduled_order_screen.dart';
import 'package:yjeek_driver/features/orders/view/release_scheduled_order_screen.dart';
import 'package:yjeek_driver/navigation/orders_nav_signal.dart';
import 'package:yjeek_driver/routes/route_names.dart';

/// Orders screen — Instant + Scheduled tabs (UI-only, static data).
/// Instant design preserved; Scheduled matches Figma DOR2.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
    this.initialSegment = 0,
  });

  /// 0 = Instant, 1 = Scheduled
  final int initialSegment;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Shared palette for Instant (existing) + Scheduled (Figma)
  static const Color _screenBg = Color(0xFFF9F9F9);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textSecondary = Color(0xFF6B756E);
  static const Color _textMuted = Color(0xFF9E9E9E);
  static const Color _green = Color(0xFF4DB04F);
  static const Color _greenDark = Color(0xFF2E7D32);
  static const Color _greenPillBg = Color(0xFFE8F5E9);
  static const Color _red = Color(0xFFD32F2F);
  static const Color _redPillBg = Color(0xFFFFEBEE);
  static const Color _cardBorder = Color(0xFFE0E0E0);
  static const Color _segmentBg = Color(0xFFF0F0F0);
  static const Color _progressTrack = Color(0xFFE8F0E9);
  static const Color _chipBorder = Color(0xFFE0E0E0);
  static const Color _rejectRed = Color(0xFFFF3B30);
  static const Color _onTrackBadgeBg = Color(0xFFE3F0FD);
  static const Color _onTrackBadgeText = Color(0xFF4A90E2);
  static const Color _trackLinkBlue = Color(0xFF1976D2);
  static const Color _releaseText = Color(0xFF424242);

  static const double _hPad = 16;

  late int _segment; // 0 Instant, 1 Scheduled
  int _scheduledFilter =
      0; // 0 New, 1 Require confirmation, 2 On track, 3 Completed
  bool _showReleaseScreen = false;
  bool _showRejectScreen = false;
  String _releaseOrderId = '#YJK-...52';
  String _rejectOrderId = '#YJK-...50';

  late List<_NewScheduledOrder> _newOrdersList;
  late List<_ConfirmScheduledOrder> _confirmOrdersList;

  static const _initialNewOrders = [
    _NewScheduledOrder(
      id: '#YJK-...50',
      route: 'VEERA → Juffair',
      window: 'Tomorrow · 1–3 PM',
      respondIn: 'Respond within 47 min',
    ),
    _NewScheduledOrder(
      id: '#YJK-...49',
      route: 'Sharaf DG → Riffa',
      window: 'Tomorrow · 4–6 PM',
      respondIn: 'Respond within 1 hr 12 min',
    ),
  ];

  static const _initialConfirmOrders = [
    _ConfirmScheduledOrder(
      id: '#YJK-...52',
      route: 'Lulu Express → Seef',
      window: 'Today · 6–8 PM',
      respondIn: 'Respond within 19 min',
    ),
  ];

  static const _onTrackOrders = [
    _OnTrackScheduledOrder(
      id: '#YJK-...51',
      route: 'Sharaf DG → Adliya',
      window: 'Today · 6–8 PM',
      statusLine: 'Picked up · on the way · ETA 6:35 PM',
    ),
    _OnTrackScheduledOrder(
      id: '#YJK-...48',
      route: 'VEERA → Juffair',
      window: 'Today · 7–9 PM',
      statusLine: 'Heading to vendor · pickup by 7:10 PM',
    ),
  ];

  static const _completedOrders = [
    _CompletedScheduledOrder(
      id: '#YJK-...41',
      route: 'The Green Kitchen → Adliya',
      window: 'Today · 1–3 PM',
      deliveredAt: 'Delivered 1:48 PM ·',
    ),
    _CompletedScheduledOrder(
      id: '#YJK-...39',
      route: 'Lulu Express → Seef',
      window: 'Yesterday · 6–8 PM',
      deliveredAt: 'Delivered 7:42 PM ·',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _segment = widget.initialSegment.clamp(0, 1);
    _newOrdersList = List<_NewScheduledOrder>.from(_initialNewOrders);
    _confirmOrdersList =
        List<_ConfirmScheduledOrder>.from(_initialConfirmOrders);
    OrdersNavSignal.pendingSegment.addListener(_onNavSignal);
    WidgetsBinding.instance.addPostFrameCallback((_) => _consumeNavSignal());
  }

  List<String> get _filters => [
        'New (${_newOrdersList.length})',
        'Require confirmation (${_confirmOrdersList.length})',
        'On track (2)',
        'Completed (2)',
      ];

  void _onDoubleConfirm() {
    setState(() {
      _scheduledFilter = 2; // On track
      _segment = 1;
    });
  }

  void _acceptNewOrder(_NewScheduledOrder order) {
    setState(() {
      _newOrdersList.removeWhere((o) => o.id == order.id);
      _confirmOrdersList.insert(
        0,
        _ConfirmScheduledOrder(
          id: order.id,
          route: order.route,
          window: order.window,
          respondIn: order.respondIn,
        ),
      );
      _scheduledFilter = 1; // Require confirmation
      _segment = 1;
      _showRejectScreen = false;
      _showReleaseScreen = false;
    });
  }

  void _openReject(String orderId) {
    setState(() {
      _rejectOrderId = orderId;
      _showRejectScreen = true;
      _showReleaseScreen = false;
      _scheduledFilter = 0;
      _segment = 1;
    });
  }

  void _closeReject() {
    setState(() {
      _showRejectScreen = false;
      _scheduledFilter = 0; // Back to New
      _segment = 1;
    });
  }

  void _submitReject(String reason, String note) {
    setState(() {
      _newOrdersList.removeWhere((order) => order.id == _rejectOrderId);
      _showRejectScreen = false;
      _scheduledFilter = 0; // Stay on New
      _segment = 1;
    });
  }

  void _openRelease(String orderId) {
    setState(() {
      _releaseOrderId = orderId;
      _showReleaseScreen = true;
      _showRejectScreen = false;
      _scheduledFilter = 1;
      _segment = 1;
    });
  }

  void _closeRelease() {
    setState(() => _showReleaseScreen = false);
  }

  void _submitRelease(String reason, String note) {
    setState(() {
      _confirmOrdersList.removeWhere((order) => order.id == _releaseOrderId);
      _showReleaseScreen = false;
      _scheduledFilter = 1; // Stay on Require confirmation
      _segment = 1;
    });
  }

  @override
  void dispose() {
    OrdersNavSignal.pendingSegment.removeListener(_onNavSignal);
    super.dispose();
  }

  void _onNavSignal() => _consumeNavSignal();

  void _consumeNavSignal() {
    final pending = OrdersNavSignal.pendingSegment.value;
    if (pending == null || !mounted) return;
    setState(() {
      _segment = pending.clamp(0, 1);
      if (_segment == 1) _scheduledFilter = 0;
      _showRejectScreen = false;
      _showReleaseScreen = false;
    });
    OrdersNavSignal.clear();
  }

  void selectSegment(int index) {
    setState(() => _segment = index.clamp(0, 1));
  }

  @override
  Widget build(BuildContext context) {
    if (_showRejectScreen) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: RejectScheduledOrderScreen(
          orderId: _rejectOrderId,
          onBack: _closeReject,
          onKeepOrder: _closeReject,
          onSubmitDecline: _submitReject,
        ),
      );
    }

    if (_showReleaseScreen) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: ReleaseScheduledOrderScreen(
          orderId: _releaseOrderId,
          onBack: _closeRelease,
          onKeepOrder: _closeRelease,
          onSubmitRelease: _submitRelease,
        ),
      );
    }

    return Scaffold(
      backgroundColor: _screenBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(_hPad, 8, _hPad, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                      height: 1.15,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SegmentedTabs(
                    selectedIndex: _segment,
                    onChanged: selectSegment,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _segment == 0
                  ? _InstantOrdersBody(
                      onContinue: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.orderDetails,
                          arguments: 'YJK-...43',
                        );
                      },
                    )
                  : _ScheduledOrdersBody(
                      filters: _filters,
                      selectedFilter: _scheduledFilter,
                      onFilterChanged: (i) =>
                          setState(() => _scheduledFilter = i),
                      newOrders: _newOrdersList,
                      confirmOrders: _confirmOrdersList,
                      onTrackOrders: _onTrackOrders,
                      completedOrders: _completedOrders,
                      onDoubleConfirm: _onDoubleConfirm,
                      onRelease: _openRelease,
                      onAcceptNew: _acceptNewOrder,
                      onRejectNew: _openReject,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Instant (unchanged design) ─────────────────────────────────────────────

class _InstantOrdersBody extends StatelessWidget {
  const _InstantOrdersBody({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        const Text(
          'Active',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _OrdersScreenState._textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        _ActiveOrderCard(onContinue: onContinue),
        const SizedBox(height: 22),
        const Text(
          'Completed',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _OrdersScreenState._textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        const _CompletedOrderCard(
          isDelivered: true,
          route: 'Lulu Express → Seef, Bldg 428, Road 2825, Flat 14',
          amount: 'BHD 2.3',
          meta: '13:48 · BHD 2.300',
        ),
        const SizedBox(height: 10),
        const _CompletedOrderCard(
          isDelivered: true,
          route: 'VEERA → Adliya, Bldg 23, Flat 82',
          amount: 'BHD 1.9',
          meta: '12:30 · BHD 1.900',
        ),
        const SizedBox(height: 10),
        const _CompletedOrderCard(
          isDelivered: false,
          route: 'Marine & Co. → Juffair, Bldg 120, Road 4012, Flat 5',
          meta: '11:10 · customer cancelled',
        ),
      ],
    );
  }
}

// ── Scheduled filters (New / Require confirmation / On track) ───────────────

class _NewScheduledOrder {
  const _NewScheduledOrder({
    required this.id,
    required this.route,
    required this.window,
    required this.respondIn,
  });

  final String id;
  final String route;
  final String window;
  final String respondIn;
}

class _ConfirmScheduledOrder {
  const _ConfirmScheduledOrder({
    required this.id,
    required this.route,
    required this.window,
    required this.respondIn,
  });

  final String id;
  final String route;
  final String window;
  final String respondIn;
}

class _OnTrackScheduledOrder {
  const _OnTrackScheduledOrder({
    required this.id,
    required this.route,
    required this.window,
    required this.statusLine,
  });

  final String id;
  final String route;
  final String window;
  final String statusLine;
}

class _CompletedScheduledOrder {
  const _CompletedScheduledOrder({
    required this.id,
    required this.route,
    required this.window,
    required this.deliveredAt,
  });

  final String id;
  final String route;
  final String window;
  final String deliveredAt;
}

class _ScheduledOrdersBody extends StatelessWidget {
  const _ScheduledOrdersBody({
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.newOrders,
    required this.confirmOrders,
    required this.onTrackOrders,
    required this.completedOrders,
    required this.onDoubleConfirm,
    required this.onRelease,
    required this.onAcceptNew,
    required this.onRejectNew,
  });

  final List<String> filters;
  final int selectedFilter;
  final ValueChanged<int> onFilterChanged;
  final List<_NewScheduledOrder> newOrders;
  final List<_ConfirmScheduledOrder> confirmOrders;
  final List<_OnTrackScheduledOrder> onTrackOrders;
  final List<_CompletedScheduledOrder> completedOrders;
  final VoidCallback onDoubleConfirm;
  final ValueChanged<String> onRelease;
  final ValueChanged<_NewScheduledOrder> onAcceptNew;
  final ValueChanged<String> onRejectNew;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final selected = selectedFilter == index;
              return GestureDetector(
                onTap: () => onFilterChanged(index),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? _OrdersScreenState._green
                        : _OrdersScreenState._surface,
                    borderRadius: BorderRadius.circular(20),
                    border: selected
                        ? null
                        : Border.all(color: _OrdersScreenState._chipBorder),
                  ),
                  child: Text(
                    filters[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? Colors.white
                          : _OrdersScreenState._textPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Expanded(child: _buildFilterList()),
      ],
    );
  }

  Widget _buildFilterList() {
    switch (selectedFilter) {
      case 1:
        if (confirmOrders.isEmpty) {
          return const Center(
            child: Text(
              'No orders needing confirmation',
              style: TextStyle(
                fontSize: 14,
                color: _OrdersScreenState._textMuted,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: confirmOrders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _RequireConfirmCard(
            data: confirmOrders[index],
            onDoubleConfirm: onDoubleConfirm,
            onRelease: () => onRelease(confirmOrders[index].id),
          ),
        );
      case 2:
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: onTrackOrders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _OnTrackCard(data: onTrackOrders[index]),
        );
      case 3:
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: completedOrders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _CompletedScheduledCard(data: completedOrders[index]),
        );
      case 0:
      default:
        if (newOrders.isEmpty) {
          return const Center(
            child: Text(
              'No new scheduled orders',
              style: TextStyle(
                fontSize: 14,
                color: _OrdersScreenState._textMuted,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: newOrders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _NewScheduledCard(
            data: newOrders[index],
            onAccept: () => onAcceptNew(newOrders[index]),
            onReject: () => onRejectNew(newOrders[index].id),
          ),
        );
    }
  }
}

class _NewScheduledCard extends StatelessWidget {
  const _NewScheduledCard({
    required this.data,
    required this.onAccept,
    required this.onReject,
  });

  final _NewScheduledOrder data;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: _OrdersScreenState._surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _OrdersScreenState._cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.id,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _OrdersScreenState._textPrimary,
                  ),
                ),
              ),
              const _StatusPill(
                label: 'NEW',
                background: _OrdersScreenState._greenPillBg,
                foreground: _OrdersScreenState._greenDark,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            data.route,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _OrdersScreenState._textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Window',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _OrdersScreenState._textMuted,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  data.window,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _OrdersScreenState._green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.respondIn,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: _OrdersScreenState._textMuted,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: Material(
                    color: _OrdersScreenState._green,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: onAccept,
                      borderRadius: BorderRadius.circular(12),
                      child: const Center(
                        child: Text(
                          'Accept',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: Material(
                    color: _OrdersScreenState._surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: _OrdersScreenState._cardBorder,
                      ),
                    ),
                    child: InkWell(
                      onTap: onReject,
                      borderRadius: BorderRadius.circular(12),
                      child: const Center(
                        child: Text(
                          'Reject',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _OrdersScreenState._rejectRed,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequireConfirmCard extends StatelessWidget {
  const _RequireConfirmCard({
    required this.data,
    required this.onDoubleConfirm,
    required this.onRelease,
  });

  final _ConfirmScheduledOrder data;
  final VoidCallback onDoubleConfirm;
  final VoidCallback onRelease;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: _OrdersScreenState._surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _OrdersScreenState._cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.id,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _OrdersScreenState._textPrimary,
                  ),
                ),
              ),
              const _StatusPill(
                label: 'ACCEPTED',
                background: _OrdersScreenState._greenPillBg,
                foreground: _OrdersScreenState._greenDark,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            data.route,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _OrdersScreenState._textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Window',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _OrdersScreenState._textMuted,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  data.window,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _OrdersScreenState._green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.respondIn,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: _OrdersScreenState._textMuted,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: Material(
                    color: _OrdersScreenState._green,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: onDoubleConfirm,
                      borderRadius: BorderRadius.circular(12),
                      child: const Center(
                        child: Text(
                          'Double-confirm',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: Material(
                    color: _OrdersScreenState._surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: _OrdersScreenState._cardBorder,
                      ),
                    ),
                    child: InkWell(
                      onTap: onRelease,
                      borderRadius: BorderRadius.circular(12),
                      child: const Center(
                        child: Text(
                          'Release',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _OrdersScreenState._releaseText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnTrackCard extends StatelessWidget {
  const _OnTrackCard({required this.data});

  final _OnTrackScheduledOrder data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: _OrdersScreenState._surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _OrdersScreenState._cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.id,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _OrdersScreenState._textPrimary,
                  ),
                ),
              ),
              const _StatusPill(
                label: 'ON TRACK',
                background: _OrdersScreenState._onTrackBadgeBg,
                foreground: _OrdersScreenState._onTrackBadgeText,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            data.route,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _OrdersScreenState._textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Window',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _OrdersScreenState._textMuted,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  data.window,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _OrdersScreenState._green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.statusLine,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: _OrdersScreenState._textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tap to track delivery',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _OrdersScreenState._trackLinkBlue,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 22,
                      color: _OrdersScreenState._trackLinkBlue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedScheduledCard extends StatelessWidget {
  const _CompletedScheduledCard({required this.data});

  final _CompletedScheduledOrder data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: _OrdersScreenState._surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _OrdersScreenState._cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.id,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _OrdersScreenState._textPrimary,
                  ),
                ),
              ),
              const _StatusPill(
                label: 'DELIVERED',
                background: _OrdersScreenState._greenPillBg,
                foreground: _OrdersScreenState._greenDark,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            data.route,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _OrdersScreenState._textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Window',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _OrdersScreenState._textMuted,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  data.window,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _OrdersScreenState._green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.deliveredAt,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: _OrdersScreenState._textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared Instant widgets (unchanged visuals) ─────────────────────────────

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: _OrdersScreenState._segmentBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentTab(
              label: 'Instant',
              selected: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _SegmentTab(
              label: 'Scheduled',
              selected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentTab extends StatelessWidget {
  const _SegmentTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _OrdersScreenState._surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected
                ? _OrdersScreenState._textPrimary
                : _OrdersScreenState._textMuted,
          ),
        ),
      ),
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _OrdersScreenState._surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _OrdersScreenState._green, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              _StatusPill(
                label: 'ON THE WAY',
                background: _OrdersScreenState._greenPillBg,
                foreground: _OrdersScreenState._greenDark,
              ),
              Spacer(),
              Text(
                '12 min',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _OrdersScreenState._green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'The Green Kitchen → Adliya',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _OrdersScreenState._textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '#YJK-...43 · cash BHD 8.500',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _OrdersScreenState._textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.58,
              minHeight: 6,
              backgroundColor: _OrdersScreenState._progressTrack,
              color: _OrdersScreenState._green,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Arriving in 12 min',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _OrdersScreenState._textPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: 36,
                child: Material(
                  color: _OrdersScreenState._green,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: onContinue,
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompletedOrderCard extends StatelessWidget {
  const _CompletedOrderCard({
    required this.isDelivered,
    required this.route,
    required this.meta,
    this.amount,
  });

  final bool isDelivered;
  final String route;
  final String meta;
  final String? amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _OrdersScreenState._surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _OrdersScreenState._cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusPill(
            label: isDelivered ? 'DELIVERED' : 'CANCELLED',
            background: isDelivered
                ? _OrdersScreenState._greenPillBg
                : _OrdersScreenState._redPillBg,
            foreground: isDelivered
                ? _OrdersScreenState._greenDark
                : _OrdersScreenState._red,
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  route,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _OrdersScreenState._textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
              if (amount != null) ...[
                const SizedBox(width: 8),
                Text(
                  amount!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _OrdersScreenState._green,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meta,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: _OrdersScreenState._textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: foreground,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
