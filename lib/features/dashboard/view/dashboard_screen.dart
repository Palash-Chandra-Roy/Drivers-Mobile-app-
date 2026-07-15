import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yjeek_driver/features/dashboard/provider/dashboard_provider.dart';
import 'package:yjeek_driver/navigation/orders_nav_signal.dart';
import 'package:yjeek_driver/routes/route_names.dart';

/// Home UI matched to Figma references.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Figma palette (local to this screen only)
  static const Color _textDark = Color(0xFF1A1A1A);
  static const Color _subtitleColor = Color(0xFF757575);
  static const Color _nameChipBg = Color(0xFFE8F5E9);
  static const Color _nameChipText = Color(0xFF2E7D32);
  static const Color _offlineChipBg = Color(0xFFF2F2F2);
  static const Color _offlineDot = Color(0xFF9E9E9E);
  static const Color _offlineText = Color(0xFF757575);
  static const Color _buttonGreen = Color(0xFF4CAF50);
  static const Color _viewGreen = Color(0xFF4CAF50);
  static const Color _cardBorder = Color(0xFFE0E0E0);
  static const String _scheduledCalendarIcon =
      'assets/images/calendar_jul_17.png';
  static const String _earningsStatIcon = 'assets/images/earnings.png';

  // Online Home colors sampled from the supplied Figma screenshot.
  static const Color _onlineBg = Color(0xFFFFFFFF);
  static const Color _onlineText = Color(0xFF1A1A1A);
  static const Color _onlineMuted = Color(0xFF6F7B6F);
  static const Color _onlineGreen = Color(0xFF4CAF50);
  static const Color _onlineGreenDark = Color(0xFF2E7D32);
  static const Color _onlineGreenPill = Color(0xFFE8F4DF);
  static const Color _onlineBalanceBg = Color(0xFF1A1A1A);
  static const Color _onlineNotificationRed = Color(0xFFFF3737);
  static const Color _onlineAutoAcceptBg = Color(0xFFFFF2D9);
  static const Color _onlineAutoAcceptBorder = Color(0xFFFFD47D);
  static const Color _onlineEnableOrange = Color(0xFFD45100);
  static const Color _onlineBoltFill = Color(0xFFFFC400);
  static const Color _onlineBoltStroke = Color(0xFFFF9800);
  static const Color _onlineScheduledBorder = Color(0xFFE2E8E1);
  static const Color _onlineScheduledIconBg = Color(0xFFEAF9EF);
  static const Color _onlineMapBase = Color(0xFFE6EFE3);
  static const Color _onlineMapBlock = Color(0xFFDDE8D8);
  static const Color _onlineMapBlockSoft = Color(0xFFEAF1E7);
  static const Color _onlineMapRoad = Color(0xFFFFFFFF);
  static const Color _onlineStatBg = Color(0xFFF3F7F2);

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

    if (dashboard.isOnline) {
      return _buildOnlineHome(context, dashboard);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            color: _buttonGreen,
            onRefresh: () => context.read<DashboardProvider>().loadDashboard(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Fit content to viewport — map absorbs remaining height.
                const headerBlock = 52.0;
                const bannerBlock = 60.0;
                const bottomBlock = 248.0;
                final mapHeight = (constraints.maxHeight -
                        headerBlock -
                        bannerBlock -
                        bottomBlock)
                    .clamp(200.0, 480.0);

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 12),
                        _buildScheduledBanner(context),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: mapHeight,
                          width: double.infinity,
                          child: const _MapPlaceholder(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "You're offline",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: _textDark,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Go online to start receiving delivery requests near you.',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: _subtitleColor,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _buildStatsRow(),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: dashboard.isLoading
                                      ? null
                                      : () async {
                                          await context
                                              .read<DashboardProvider>()
                                              .toggleOnlineStatus();
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _buttonGreen,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    disabledBackgroundColor:
                                        _buttonGreen.withValues(alpha: 0.6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.bolt_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Go online',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineHome(
    BuildContext context,
    DashboardProvider dashboard,
  ) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: _onlineBg,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _onlineBg,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              const headerBlock = 68.0;
              const autoAcceptBlock = 66.0;
              const scheduledBlock = 48.0;
              const summaryBlock = 200.0;
              final mapHeight = (constraints.maxHeight -
                      headerBlock -
                      autoAcceptBlock -
                      scheduledBlock -
                      summaryBlock)
                  .clamp(300.0, 410.0);

              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOnlineHeader(context),
                      const SizedBox(height: 18),
                      _buildOnlineAutoAcceptCard(context),
                      const SizedBox(height: 10),
                      _buildOnlineScheduledCard(context),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: mapHeight,
                        child: const _OnlineMapPlaceholder(),
                      ),
                      _buildOnlineSummary(context, dashboard),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 0),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const _OnlinePill(
                      color: _onlineGreenPill,
                      horizontalPadding: 12,
                      child: Text(
                        'Ahmed Ali',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _onlineGreenDark,
                          height: 1.05,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const _OnlinePill(
                      color: _onlineGreenPill,
                      horizontalPadding: 12,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 8,
                            height: 8,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: _onlineGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "You're online",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: _onlineGreenDark,
                              height: 1.05,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _OnlinePill(
                      color: _onlineBalanceBg,
                      horizontalPadding: 11,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 13,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _onlineBg,
                                width: 1.8,
                              ),
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                            child: Container(
                              width: 4.5,
                              height: 4.5,
                              decoration: const BoxDecoration(
                                color: _onlineBg,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'BHD 12.500',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: _onlineBg,
                              height: 1.05,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, RouteNames.notifications),
              behavior: HitTestBehavior.opaque,
              child: const SizedBox(
                width: 32,
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 30,
                      color: Color(0xFF2D211B),
                    ),
                    Positioned(
                      right: 1,
                      top: 7,
                      child: SizedBox(
                        width: 9,
                        height: 9,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: _onlineNotificationRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineAutoAcceptCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 55,
        padding: const EdgeInsets.fromLTRB(13, 8, 12, 8),
        decoration: BoxDecoration(
          color: _onlineAutoAcceptBg,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: _onlineAutoAcceptBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 17,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _onlineBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Center(
                child: _OnlineBoltIcon(
                  width: 15,
                  height: 17,
                ),
              ),
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto-Accept is off',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _onlineText,
                      height: 1.05,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Turn it on to get orders automatically',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: _onlineMuted,
                      height: 1.05,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: _onlineEnableOrange,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.newRequest),
                borderRadius: BorderRadius.circular(16),
                child: const SizedBox(
                  width: 70,
                  height: 32,
                  child: Center(
                    child: Text(
                      'Enable',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _onlineBg,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineScheduledCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: _onlineBg,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => OrdersNavSignal.openScheduled(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 40,
            padding: const EdgeInsets.fromLTRB(13, 0, 12, 0),
            decoration: BoxDecoration(
              color: _onlineBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _onlineScheduledBorder, width: 1),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 35,
                  height: 17,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: _onlineScheduledIconBg,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Image.asset(
                      _scheduledCalendarIcon,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.calendar_today,
                        size: 13,
                        color: _onlineText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Text(
                    '2 scheduled orders today',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _onlineText,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'View',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5BC970),
                    height: 1,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF5BC970),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineSummary(
    BuildContext context,
    DashboardProvider dashboard,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  "Today's summary",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _onlineText,
                    height: 1,
                  ),
                ),
              ),
              Text(
                'Fri 12 Jun',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _onlineMuted,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 62,
                  child: _OnlineHomeStatCard(
                    icon: Icon(
                      Icons.arrow_upward_rounded,
                      size: 21,
                      color: _onlineGreenDark,
                    ),
                    value: '4',
                    label: 'Orders',
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 62,
                  child: _OnlineHomeStatCard(
                    icon: _HomeAssetIcon(
                      assetPath: _earningsStatIcon,
                      width: 20,
                      height: 14,
                      color: _onlineGreenDark,
                    ),
                    value: 'BHD 12.50',
                    label: 'Earnings',
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 62,
                  child: _OnlineHomeStatCard(
                    icon: Icon(
                      Icons.access_time_rounded,
                      size: 19,
                      color: _onlineGreenDark,
                    ),
                    value: '3h 20m',
                    label: 'Online',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: dashboard.isLoading
                  ? null
                  : () async {
                      await context
                          .read<DashboardProvider>()
                          .toggleOnlineStatus();
                    },
              style: OutlinedButton.styleFrom(
                backgroundColor: _onlineBg,
                foregroundColor: _onlineGreenDark,
                disabledForegroundColor:
                    _onlineGreenDark.withValues(alpha: 0.6),
                side: const BorderSide(color: _onlineGreen, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text(
                'Go offline',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _onlineGreenDark,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: _offlineChipBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 7,
                  height: 7,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _offlineDot,
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  'Offline',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _offlineText,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, RouteNames.notifications),
            behavior: HitTestBehavior.opaque,
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 26,
                    color: _textDark,
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: SizedBox(
                      width: 8,
                      height: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
          onTap: () => OrdersNavSignal.openScheduled(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder, width: 1),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 34,
                  height: 16,
                  child: Image.asset(
                    _scheduledCalendarIcon,
                    width: 34,
                    height: 16,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => Container(
                      width: 34,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.calendar_today,
                        size: 10,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    '2 scheduled orders today',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: _viewGreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return const Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 72,
            child: _HomeStatCard(
              icon: Icon(
                Icons.arrow_upward_rounded,
                size: 16,
                color: Color(0xFF4CAF50),
              ),
              value: '0',
              label: 'Trips today',
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 72,
            child: _HomeStatCard(
              icon: _HomeAssetIcon(
                assetPath: _earningsStatIcon,
                width: 18,
                height: 13,
                color: Color(0xFF4CAF50),
              ),
              value: 'BHD 0.000',
              label: 'Earnings',
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 72,
            child: _HomeStatCard(
              icon: Icon(
                Icons.access_time_rounded,
                size: 16,
                color: Color(0xFF4CAF50),
              ),
              value: '0h 00m',
              label: 'Online',
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeAssetIcon extends StatelessWidget {
  const _HomeAssetIcon({
    required this.assetPath,
    required this.width,
    required this.height,
    this.color,
  });

  final String assetPath;
  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: color != null ? BlendMode.srcIn : null,
      errorBuilder: (_, __, ___) => Icon(
        Icons.payments_outlined,
        size: width,
        color: const Color(0xFF4CAF50),
      ),
    );
  }
}

class _OnlinePill extends StatelessWidget {
  const _OnlinePill({
    required this.color,
    required this.child,
    this.horizontalPadding = 12,
  });

  final Color color;
  final Widget child;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 27),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class _OnlineHomeStatCard extends StatelessWidget {
  const _OnlineHomeStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final Widget icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 8),
      decoration: BoxDecoration(
        color: _DashboardScreenState._onlineStatBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _DashboardScreenState._onlineText,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _DashboardScreenState._onlineMuted,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnlineBoltIcon extends StatelessWidget {
  const _OnlineBoltIcon({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: const CustomPaint(painter: _OnlineBoltPainter()),
    );
  }
}

class _OnlineBoltPainter extends CustomPainter {
  const _OnlineBoltPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.68, size.height * 0.02)
      ..lineTo(size.width * 0.12, size.height * 0.56)
      ..lineTo(size.width * 0.47, size.height * 0.56)
      ..lineTo(size.width * 0.32, size.height * 0.98)
      ..lineTo(size.width * 0.90, size.height * 0.39)
      ..lineTo(size.width * 0.54, size.height * 0.39)
      ..close();

    final strokePaint = Paint()
      ..color = _DashboardScreenState._onlineBoltStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeJoin = StrokeJoin.miter
      ..strokeCap = StrokeCap.square;
    final fillPaint = Paint()
      ..color = _DashboardScreenState._onlineBoltFill
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HomeStatCard extends StatelessWidget {
  const _HomeStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final Widget icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 5),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnlineMapPlaceholder extends StatelessWidget {
  const _OnlineMapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        Widget zone({
          required double x,
          required double y,
          required double size,
          required Color color,
        }) {
          return Positioned(
            left: width * x - size / 2,
            top: height * y - size / 2,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          );
        }

        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            const CustomPaint(painter: _OnlineHomeMapPainter()),
            zone(
              x: 0.37,
              y: 0.44,
              size: 49,
              color: const Color(0x294CAF50),
            ),
            zone(
              x: 0.70,
              y: 0.55,
              size: 49,
              color: const Color(0x33E5A93A),
            ),
            zone(
              x: 0.27,
              y: 0.87,
              size: 49,
              color: const Color(0x33E5A93A),
            ),
            zone(
              x: 0.83,
              y: 0.87,
              size: 49,
              color: const Color(0x294CAF50),
            ),
            Positioned(
              left: width * 0.50 - 43,
              top: height * 0.53 - 43,
              child: const _OnlineLocationMarker(),
            ),
            Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: Container(
                height: 51,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  color: _DashboardScreenState._onlineBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                        child: _OnlineBoltIcon(
                          width: 14,
                          height: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Waiting for requests...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: _DashboardScreenState._onlineText,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Stay near busy (orange) areas for more orders',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: _DashboardScreenState._onlineMuted,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OnlineLocationMarker extends StatelessWidget {
  const _OnlineLocationMarker();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 86,
      height: 86,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0x294CAF50),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            width: 44,
            height: 52,
            child: CustomPaint(painter: _OnlineLocationPinPainter()),
          ),
        ],
      ),
    );
  }
}

class _OnlineLocationPinPainter extends CustomPainter {
  const _OnlineLocationPinPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _DashboardScreenState._onlineGreen
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 5;

    final path = Path()
      ..moveTo(size.width * 0.50, size.height * 0.92)
      ..cubicTo(
        size.width * 0.36,
        size.height * 0.76,
        size.width * 0.15,
        size.height * 0.58,
        size.width * 0.15,
        size.height * 0.36,
      )
      ..cubicTo(
        size.width * 0.15,
        size.height * 0.16,
        size.width * 0.31,
        size.height * 0.05,
        size.width * 0.50,
        size.height * 0.05,
      )
      ..cubicTo(
        size.width * 0.69,
        size.height * 0.05,
        size.width * 0.85,
        size.height * 0.16,
        size.width * 0.85,
        size.height * 0.36,
      )
      ..cubicTo(
        size.width * 0.85,
        size.height * 0.58,
        size.width * 0.64,
        size.height * 0.76,
        size.width * 0.50,
        size.height * 0.92,
      );

    canvas.drawPath(path, paint);
    canvas.drawCircle(
      Offset(size.width * 0.50, size.height * 0.36),
      size.width * 0.12,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OnlineHomeMapPainter extends CustomPainter {
  const _OnlineHomeMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = _DashboardScreenState._onlineMapBase;
    final block = Paint()..color = _DashboardScreenState._onlineMapBlock;
    final softBlock = Paint()
      ..color = _DashboardScreenState._onlineMapBlockSoft;
    final road = Paint()..color = _DashboardScreenState._onlineMapRoad;

    canvas.drawRect(Offset.zero & size, base);

    void drawBlock(
      double left,
      double top,
      double width,
      double height,
      Paint paint,
    ) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * left,
            size.height * top,
            size.width * width,
            size.height * height,
          ),
          const Radius.circular(8),
        ),
        paint,
      );
    }

    drawBlock(0.05, 0.03, 0.18, 0.22, block);
    drawBlock(0.51, 0.04, 0.18, 0.25, block);
    drawBlock(0.00, 0.42, 0.16, 0.36, softBlock);
    drawBlock(0.19, 0.42, 0.20, 0.36, softBlock);
    drawBlock(0.43, 0.42, 0.26, 0.36, softBlock);
    drawBlock(0.73, 0.42, 0.27, 0.36, softBlock);
    drawBlock(0.26, 0.72, 0.18, 0.23, block);
    drawBlock(0.74, 0.78, 0.18, 0.19, block);

    void drawVerticalRoad(double x, double width) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * x - width / 2,
          0,
          width,
          size.height,
        ),
        road,
      );
    }

    void drawHorizontalRoad(double y, double height) {
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          size.height * y - height / 2,
          size.width,
          height,
        ),
        road,
      );
    }

    drawVerticalRoad(0.17, 14);
    drawVerticalRoad(0.405, 16);
    drawVerticalRoad(0.71, 15);
    drawHorizontalRoad(0.255, 17);
    drawHorizontalRoad(0.625, 16);
    drawHorizontalRoad(0.895, 14);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const CustomPaint(painter: _HomeMapPainter()),
        Center(
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: const Color(0xFF6B736B).withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SizedBox(
              width: 26,
              height: 30,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 30,
                    color: Color(0xFF6B736B),
                  ),
                  Positioned(
                    top: 7,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeMapPainter extends CustomPainter {
  const _HomeMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFEEF2EA);
    canvas.drawRect(Offset.zero & size, bg);

    final a = Paint()..color = const Color(0xFFD9E4D4);
    final b = Paint()..color = const Color(0xFFE3EBE0);
    final c = Paint()..color = const Color(0xFFD2DED0);
    final park = Paint()..color = const Color(0xFFDCE8D8);

    final road = Paint()
      ..color = const Color(0xFFF7F9F5)
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadThin = Paint()
      ..color = const Color(0xFFF4F7F2)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final blocks = <(RRect, Paint)>[
      (
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.03, size.height * 0.04,
              size.width * 0.28, size.height * 0.22),
          const Radius.circular(8),
        ),
        a,
      ),
      (
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.38, size.height * 0.02,
              size.width * 0.26, size.height * 0.20),
          const Radius.circular(8),
        ),
        b,
      ),
      (
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.72, size.height * 0.05,
              size.width * 0.25, size.height * 0.24),
          const Radius.circular(8),
        ),
        c,
      ),
      (
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.04, size.height * 0.38,
              size.width * 0.22, size.height * 0.28),
          const Radius.circular(8),
        ),
        b,
      ),
      (
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.38, size.height * 0.36,
              size.width * 0.24, size.height * 0.22),
          const Radius.circular(8),
        ),
        park,
      ),
      (
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.70, size.height * 0.42,
              size.width * 0.26, size.height * 0.32),
          const Radius.circular(8),
        ),
        a,
      ),
      (
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.04, size.height * 0.74,
              size.width * 0.28, size.height * 0.20),
          const Radius.circular(8),
        ),
        c,
      ),
      (
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.40, size.height * 0.70,
              size.width * 0.22, size.height * 0.26),
          const Radius.circular(8),
        ),
        b,
      ),
      (
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.70, size.height * 0.80,
              size.width * 0.24, size.height * 0.16),
          const Radius.circular(8),
        ),
        park,
      ),
    ];

    for (final (rrect, paint) in blocks) {
      canvas.drawRRect(rrect, paint);
    }

    canvas.drawLine(
      Offset(0, size.height * 0.30),
      Offset(size.width, size.height * 0.30),
      road,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.66),
      Offset(size.width, size.height * 0.66),
      roadThin,
    );
    canvas.drawLine(
      Offset(size.width * 0.34, 0),
      Offset(size.width * 0.34, size.height),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.66, 0),
      Offset(size.width * 0.66, size.height),
      roadThin,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
