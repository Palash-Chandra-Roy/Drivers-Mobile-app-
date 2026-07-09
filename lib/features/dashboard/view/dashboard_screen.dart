import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/features/dashboard/provider/dashboard_provider.dart';
import 'package:yjeek_driver/features/notifications/provider/notification_provider.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color _textDark = Color(0xFF1E1E1E);
  static const Color _subtitleColor = Color(0xFF6B7C6B);
  static const Color _nameChipBg = Color(0xFFE8F5E9);
  static const Color _nameChipText = Color(0xFF2E7D32);
  static const Color _offlineChipBg = Color(0xFFF0F2F0);
  static const Color _buttonGreen = Color(0xFF4CAF50);
  static const Color _viewGreen = Color(0xFF4CAF50);
  static const Color _cardBorder = Color(0xFFE8EEE8);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();
    final unread = context.watch<NotificationProvider>().unreadCount;
    final isOnline = dashboard.isOnline;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      context.read<DashboardProvider>().loadDashboard(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, isOnline, unread),
                        const SizedBox(height: 12),
                        _buildScheduledBanner(context),
                        const SizedBox(height: 12),
                        _buildMapSection(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isOnline ? "You're online" : "You're offline",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: _textDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isOnline
                                    ? 'You are receiving delivery requests near you.'
                                    : 'Go online to start receiving delivery requests near you.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: _subtitleColor,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 18),
                              _buildStatsRow(dashboard),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: dashboard.isLoading
                                      ? null
                                      : () async {
                                          if (!isOnline) {
                                            await context
                                                .read<DashboardProvider>()
                                                .toggleOnlineStatus();
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              RouteNames.goOnline,
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _buttonGreen,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    disabledBackgroundColor:
                                        _buttonGreen.withValues(alpha: 0.6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isOnline
                                            ? Icons.flash_on
                                            : Icons.bolt,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isOnline ? 'Stay online' : 'Go online',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isOnline, int unread) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _nameChipBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Ahmed Ali',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _nameChipText,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _offlineChipBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnline ? _buttonGreen : const Color(0xFF9AA09A),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, RouteNames.notifications),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 28,
                  color: _textDark,
                ),
                if (unread > 0)
                  Positioned(
                    right: 1,
                    top: 1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, RouteNames.scheduledOrders),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: _textDark,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    '2 scheduled orders today',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                ),
                const Text(
                  'View',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _viewGreen,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: _viewGreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _MapPlaceholderPainter()),
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                size: 32,
                color: Color(0xFF5A5A5A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(DashboardProvider dashboard) {
    final trips = dashboard.isOnline ? dashboard.completedOrders : 0;
    final earnings = dashboard.isOnline ? dashboard.todayEarnings : 0.0;
    final onlineLabel = dashboard.isOnline ? 'Online' : 'Online';

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.north_east,
            value: '$trips',
            label: 'Trips today',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.payments_outlined,
            value: 'BHD ${earnings.toStringAsFixed(3)}',
            label: 'Earnings',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.schedule,
            value: dashboard.isOnline ? '0h 00m' : '0h 00m',
            label: onlineLabel,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  static const Color _textDark = Color(0xFF1E1E1E);
  static const Color _subtitleColor = Color(0xFF6B7C6B);
  static const Color _statCardBg = Color(0xFFF5F7F5);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: _statCardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: _subtitleColor),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFF4F1E8);
    canvas.drawRect(Offset.zero & size, bg);

    final blockPaint = Paint()..color = const Color(0xFFE5E1D4);
    final roadPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final blocks = <Rect>[
      Rect.fromLTWH(size.width * 0.05, size.height * 0.08, size.width * 0.28, size.height * 0.28),
      Rect.fromLTWH(size.width * 0.40, size.height * 0.05, size.width * 0.35, size.height * 0.22),
      Rect.fromLTWH(size.width * 0.78, size.height * 0.12, size.width * 0.18, size.height * 0.30),
      Rect.fromLTWH(size.width * 0.08, size.height * 0.48, size.width * 0.22, size.height * 0.35),
      Rect.fromLTWH(size.width * 0.38, size.height * 0.42, size.width * 0.30, size.height * 0.28),
      Rect.fromLTWH(size.width * 0.72, size.height * 0.55, size.width * 0.22, size.height * 0.32),
    ];

    for (final rect in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        blockPaint,
      );
    }

    canvas.drawLine(
      Offset(0, size.height * 0.38),
      Offset(size.width, size.height * 0.38),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.34, 0),
      Offset(size.width * 0.34, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.68, 0),
      Offset(size.width * 0.68, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
