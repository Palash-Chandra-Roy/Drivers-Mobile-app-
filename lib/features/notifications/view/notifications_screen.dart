import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yjeek_driver/routes/route_names.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _screenBg = Color(0xFFF4F6F3);
  static const Color _cardUnreadBg = Color(0xFFF3F8FF);
  static const Color _cardReadBg = Color(0xFFFFFFFF);
  static const Color _border = Color(0xFFE2E7E0);
  static const Color _textDark = Color(0xFF1A1F1A);
  static const Color _textMuted = Color(0xFF777E77);
  static const Color _sectionText = Color(0xFF8C918C);
  static const Color _timeText = Color(0xFF929993);
  static const Color _unreadBlue = Color(0xFF3682ED);
  static const Color _inactiveNav = Color(0xFF6B7C6B);
  static const Color _bottomBorder = Color(0xFFE8EEE8);

  static const String _homeIcon = 'assets/images/Home-icon.png';
  static const String _ordersIcon = 'assets/images/Order_icon.png';
  static const String _earningsIcon = 'assets/images/Earnings_icon.png';
  static const String _performanceIcon = 'assets/images/Performans_icon.png';
  static const String _accountIcon = 'assets/images/Account_icon.png';

  static const List<_NotifItem> _today = [
    _NotifItem(
      title: 'Account suspended',
      body:
          'Your account has been suspended. Tap to see why and how to reactivate.',
      time: 'now',
      unread: true,
      iconBg: Color(0xFFFFE4E4),
      iconAsset: 'assets/images/notif_account_suspended.png',
      iconSize: 27,
      detailsType: _NotificationDetailsType.accountSuspended,
    ),
    _NotifItem(
      title: 'Performance alert',
      body:
          'Your RPI dropped below 62. Improve acceptance & completion to avoid suspension.',
      time: '1h',
      unread: true,
      iconBg: Color(0xFFFFF2CF),
      iconAsset: 'assets/images/notif_performance.png',
      iconSize: 31,
      detailsType: _NotificationDetailsType.performanceAlert,
    ),
    _NotifItem(
      title: 'New scheduled order offered',
      body:
          'VEERA → Juffair · tomorrow 1–3 PM. Respond within 47 min or it’s reassigned.',
      time: '2m',
      unread: true,
      iconBg: Color(0xFFEAFBF0),
      iconAsset: 'assets/images/calendar_jul_17.png',
      iconSize: 27,
    ),
    _NotifItem(
      title: 'Double-confirm needed',
      body: 'Re-confirm order #YJK-...52 within 15 minutes to keep it.',
      time: '18m',
      unread: true,
      iconBg: Color(0xFFFFF1D8),
      iconAsset: 'assets/images/notif_alarm.png',
      iconSize: 31,
    ),
  ];

  static const List<_NotifItem> _earlier = [
    _NotifItem(
      title: 'Document expiring',
      body:
          'Your vehicle insurance expires in 14 days. Upload the renewal to stay online.',
      time: 'Yesterday',
      unread: false,
      iconBg: Color(0xFFFFF1D8),
      iconAsset: 'assets/images/notif_document.png',
      iconSize: 31,
    ),
    _NotifItem(
      title: 'Incident resolved',
      body: 'Your report RP-2026-10499 was resolved — no fault recorded.',
      time: '2d',
      unread: false,
      iconBg: Color(0xFFFFE8E8),
      iconAsset: 'assets/images/notif_incident.png',
      iconSize: 31,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    final showLocalBottomNav =
        routeName == null || routeName == RouteNames.notifications;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: _white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: _white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _screenBg,
        bottomNavigationBar:
            showLocalBottomNav ? const _NotificationsBottomNav() : null,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(onBack: _handleBack),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 22),
                  children: [
                    const _SectionLabel('TODAY'),
                    const SizedBox(height: 18),
                    _NotificationCard(item: _today[0]),
                    const SizedBox(height: 14),
                    _NotificationCard(item: _today[1]),
                    const SizedBox(height: 14),
                    _NotificationCard(item: _today[2]),
                    const SizedBox(height: 14),
                    _NotificationCard(item: _today[3]),
                    const SizedBox(height: 24),
                    const _SectionLabel('EARLIER'),
                    const SizedBox(height: 18),
                    _NotificationCard(item: _earlier[0]),
                    const SizedBox(height: 14),
                    _NotificationCard(item: _earlier[1]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}

enum _NotificationDetailsType {
  accountSuspended,
  performanceAlert,
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: double.infinity,
      color: _NotificationsScreenState._white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 30,
              height: 30,
              child: IconButton(
                onPressed: onBack,
                padding: EdgeInsets.zero,
                splashRadius: 22,
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 22,
                  color: _NotificationsScreenState._textDark,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 52),
            child: Text(
              'Notifications',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _NotificationsScreenState._textDark,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: _NotificationsScreenState._sectionText,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1,
      ),
    );
  }
}

class _NotifItem {
  const _NotifItem({
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
    required this.iconBg,
    required this.iconAsset,
    required this.iconSize,
    this.detailsType,
  });

  final String title;
  final String body;
  final String time;
  final bool unread;
  final Color iconBg;
  final String iconAsset;
  final double iconSize;
  final _NotificationDetailsType? detailsType;
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final _NotifItem item;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: item.unread
            ? _NotificationsScreenState._cardUnreadBg
            : _NotificationsScreenState._cardReadBg,
        border: Border.all(
          color: _NotificationsScreenState._border,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: _IconBadge(item: item),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _NotificationsScreenState._textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.body,
                    softWrap: true,
                    style: const TextStyle(
                      color: _NotificationsScreenState._textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.time,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: _NotificationsScreenState._timeText,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
                if (item.unread) ...[
                  const SizedBox(height: 18),
                  Container(
                    width: 11,
                    height: 11,
                    decoration: const BoxDecoration(
                      color: _NotificationsScreenState._unreadBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (item.detailsType == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openDetails(context),
        child: card,
      ),
    );
  }

  void _openDetails(BuildContext context) {
    final type = item.detailsType;
    if (type == _NotificationDetailsType.accountSuspended) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const _AccountSuspendedDetailsScreen(),
        ),
      );
      return;
    }
    if (type == _NotificationDetailsType.performanceAlert) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const _PerformanceAlertDetailsScreen(),
        ),
      );
    }
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.item});

  final _NotifItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 43,
      height: 20,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: item.iconBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Image.asset(
            item.iconAsset,
            width: item.iconSize,
            height: item.iconSize,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.notifications_outlined,
              color: _NotificationsScreenState._textMuted,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationDetailsColors {
  const _NotificationDetailsColors._();

  static const Color white = Color(0xFFFFFFFF);
  static const Color pageBg = Color(0xFFF4F6F3);
  static const Color red = Color(0xFFD70B1C);
  static const Color green = Color(0xFF4CAF50);
  static const Color darkText = Color(0xFF1A1F1A);
  static const Color mutedText = Color(0xFF6F766F);
  static const Color border = Color(0xFFE0E6DF);
  static const Color shadow = Color(0x10000000);
  static const Color lightGreen = Color(0xFFE7F7E9);
  static const Color lightRed = Color(0xFFFFE6EA);
  static const Color lightOrange = Color(0xFFFFF0D9);
  static const Color orange = Color(0xFFE07813);
}

class _AccountSuspendedDetailsScreen extends StatelessWidget {
  const _AccountSuspendedDetailsScreen();

  @override
  Widget build(BuildContext context) {
    return const _NotificationDetailsScaffold(
      title: 'Account suspended',
      subtitle: 'You can’t go online',
      child: _AccountSuspendedDetailsBody(),
    );
  }
}

class _PerformanceAlertDetailsScreen extends StatelessWidget {
  const _PerformanceAlertDetailsScreen();

  @override
  Widget build(BuildContext context) {
    return const _NotificationDetailsScaffold(
      title: 'Performance alert',
      subtitle: 'Action needed',
      child: _PerformanceAlertDetailsBody(),
    );
  }
}

class _NotificationDetailsScaffold extends StatelessWidget {
  const _NotificationDetailsScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: _NotificationDetailsColors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: _NotificationDetailsColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _NotificationDetailsColors.pageBg,
        bottomNavigationBar: const _NotificationsBottomNav(),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _NotificationDetailsHeader(
                title: title,
                subtitle: subtitle,
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationDetailsHeader extends StatelessWidget {
  const _NotificationDetailsHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      width: double.infinity,
      color: _NotificationDetailsColors.red,
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 9),
      child: Row(
        children: [
          SizedBox(
            width: 25,
            height: 36,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              splashRadius: 20,
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: _NotificationDetailsColors.white,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _NotificationDetailsColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _NotificationDetailsColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceAlertDetailsBody extends StatelessWidget {
  const _PerformanceAlertDetailsBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
      children: [
        const Center(
          child: _DetailsIconPill(
            backgroundColor: _NotificationDetailsColors.lightOrange,
            child: SizedBox(
              width: 27,
              height: 18,
              child: CustomPaint(painter: _PerformanceDeclinePainter()),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          height: 84,
          decoration: BoxDecoration(
            color: _NotificationDetailsColors.white,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: _NotificationDetailsColors.border,
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: _NotificationDetailsColors.shadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'RPI 58',
                style: TextStyle(
                  color: _NotificationDetailsColors.red,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Below the 62 minimum',
                style: TextStyle(
                  color: _NotificationDetailsColors.mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 13, 12, 14),
          decoration: BoxDecoration(
            color: _NotificationDetailsColors.lightGreen,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: const Color(0xFFD9EEDD),
              width: 1,
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to recover',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Keep acceptance ≥ 92%, completion ≥ 98%, on-time ≥ 95% and rating ≥ 4.7★.',
                style: TextStyle(
                  color: _NotificationDetailsColors.mutedText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 42,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _NotificationDetailsColors.green,
              foregroundColor: _NotificationDetailsColors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Text(
              'View my performance',
              style: TextStyle(
                color: _NotificationDetailsColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AccountSuspendedDetailsBody extends StatelessWidget {
  const _AccountSuspendedDetailsBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 19, 14, 24),
      children: [
        const Center(
          child: _DetailsIconPill(
            backgroundColor: _NotificationDetailsColors.lightRed,
            child: Icon(
              Icons.gpp_bad_outlined,
              color: _NotificationDetailsColors.red,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 26),
        const Text(
          'Account Suspended — contact Champ Ops.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _NotificationDetailsColors.darkText,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'You can’t go online while suspended. The investigation or penalty process must be resolved first.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _NotificationDetailsColors.mutedText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          height: 42,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _NotificationDetailsColors.red,
              foregroundColor: _NotificationDetailsColors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Text(
              'Contact Champ Ops',
              style: TextStyle(
                color: _NotificationDetailsColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailsIconPill extends StatelessWidget {
  const _DetailsIconPill({
    required this.backgroundColor,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 51,
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}

class _PerformanceDeclinePainter extends CustomPainter {
  const _PerformanceDeclinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _NotificationDetailsColors.orange
      ..strokeWidth = 2.1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.24)
      ..lineTo(size.width * 0.36, size.height * 0.50)
      ..lineTo(size.width * 0.55, size.height * 0.34)
      ..lineTo(size.width * 0.84, size.height * 0.66);
    canvas.drawPath(path, paint);

    final arrow = Path()
      ..moveTo(size.width * 0.84, size.height * 0.66)
      ..lineTo(size.width * 0.84, size.height * 0.39)
      ..moveTo(size.width * 0.84, size.height * 0.66)
      ..lineTo(size.width * 0.57, size.height * 0.66);
    canvas.drawPath(arrow, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NotificationsBottomNav extends StatelessWidget {
  const _NotificationsBottomNav();

  static const TextStyle _labelStyle = TextStyle(fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _NotificationsScreenState._white,
        border: Border(
          top: BorderSide(
            color: _NotificationsScreenState._bottomBorder,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) => _handleTap(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: _NotificationsScreenState._white,
        elevation: 0,
        selectedItemColor: _NotificationsScreenState._inactiveNav,
        unselectedItemColor: _NotificationsScreenState._inactiveNav,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: _labelStyle,
        unselectedLabelStyle: _labelStyle,
        items: [
          BottomNavigationBarItem(
            icon: _navIcon(_NotificationsScreenState._homeIcon),
            activeIcon: _navIcon(_NotificationsScreenState._homeIcon),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _navIcon(_NotificationsScreenState._ordersIcon),
            activeIcon: _navIcon(_NotificationsScreenState._ordersIcon),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: _navIcon(_NotificationsScreenState._earningsIcon),
            activeIcon: _navIcon(_NotificationsScreenState._earningsIcon),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: _navIcon(_NotificationsScreenState._performanceIcon),
            activeIcon: _navIcon(_NotificationsScreenState._performanceIcon),
            label: 'Performance',
          ),
          BottomNavigationBarItem(
            icon: _navIcon(_NotificationsScreenState._accountIcon),
            activeIcon: _navIcon(_NotificationsScreenState._accountIcon),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  static Widget _navIcon(String assetPath) {
    const color = _NotificationsScreenState._inactiveNav;

    return Image.asset(
      assetPath,
      width: 24,
      height: 24,
      color: color,
      colorBlendMode: BlendMode.srcIn,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.circle_outlined,
        size: 24,
        color: color,
      ),
    );
  }

  void _handleTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.mainNavigation,
          (route) => false,
        );
        return;
      case 1:
        Navigator.pushNamed(context, RouteNames.orders);
        return;
      case 2:
        Navigator.pushNamed(context, RouteNames.earnings);
        return;
      case 4:
        Navigator.pushNamed(context, RouteNames.profile);
        return;
    }
  }
}
