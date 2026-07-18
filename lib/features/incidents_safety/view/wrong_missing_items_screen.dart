import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/incidents_safety/view/incident_ui.dart';

class _LineItem {
  _LineItem({
    required this.name,
    required this.qty,
    this.selected = false,
    this.issue,
  });

  final String name;
  final int qty;
  bool selected;
  String? issue;
}

/// DR1a-W · Wrong / missing items
class WrongMissingItemsScreen extends StatefulWidget {
  const WrongMissingItemsScreen({
    super.key,
    this.args = const IncidentContextArgs(),
  });

  final IncidentContextArgs args;

  @override
  State<WrongMissingItemsScreen> createState() =>
      _WrongMissingItemsScreenState();
}

class _WrongMissingItemsScreenState extends State<WrongMissingItemsScreen> {
  late final List<_LineItem> _items;
  Uint8List? _photoBytes;

  @override
  void initState() {
    super.initState();
    _items = [
      _LineItem(
        name: 'Gourmet Mezze Platter',
        qty: 1,
        selected: true,
        issue: 'Missing',
      ),
      _LineItem(name: 'Lamb Ouzi', qty: 1),
      _LineItem(
        name: 'Fresh Juice — Large',
        qty: 1,
        selected: true,
        issue: 'Wrong item',
      ),
    ];
  }

  Future<void> _pickPhoto() async {
    final bytes = await pickIncidentPhoto(context);
    if (!mounted || bytes == null) return;
    setState(() => _photoBytes = bytes);
  }

  void _report() {
    final flagged = _items.where((i) => i.selected && i.issue != null).toList();
    if (flagged.isEmpty) {
      showIncidentSnack(context, 'Mark at least one wrong or missing item');
      return;
    }
    showIncidentSnack(context, 'Reported to dispatch');
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IncidentColors.screenBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            IncidentHeader(
              title: 'Wrong / missing items',
              subtitle: widget.args.pickupSubtitle,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  const Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: IncidentColors.headerGreen,
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                        child: SizedBox(width: 4, height: 15),
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Mark what’s wrong or missing',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: IncidentColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ItemCard(
                        item: item,
                        onToggle: () {
                          setState(() {
                            item.selected = !item.selected;
                            if (!item.selected) item.issue = null;
                          });
                        },
                        onIssue: (issue) {
                          setState(() {
                            item.selected = true;
                            item.issue = issue;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  _OptionalPhotoUpload(
                    hasPhoto: _photoBytes != null,
                    photoBytes: _photoBytes,
                    onTap: _pickPhoto,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: IncidentColors.infoBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Dispatch is alerted and the vendor gets a 5-minute window to fix it. Don’t accept the order until it’s corrected — reporting before departure keeps you protected.',
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 14 / 11.5,
                        color: IncidentColors.infoText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  IncidentPrimaryButton(
                    label: 'Report to dispatch',
                    color: IncidentColors.headerGreen,
                    onPressed: _report,
                  ),
                  const SizedBox(height: 10),
                  IncidentOutlinedButton(
                    label: 'Items are correct',
                    textColor: const Color(0xFF3D4842),
                    borderColor: const Color(0xFFCDD5CD),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.onToggle,
    required this.onIssue,
  });

  final _LineItem item;
  final VoidCallback onToggle;
  final ValueChanged<String> onIssue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: IncidentColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E8E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: item.selected
                        ? IncidentColors.headerGreen
                        : IncidentColors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: item.selected
                          ? IncidentColors.headerGreen
                          : const Color(0xFFCFD4CF),
                      width: 1.5,
                    ),
                  ),
                  child: item.selected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: IncidentColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Qty ${item.qty}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: IncidentColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              IncidentChip(
                label: 'Missing',
                selected: item.issue == 'Missing',
                filledSelected: true,
                onTap: () => onIssue('Missing'),
              ),
              const SizedBox(width: 8),
              IncidentChip(
                label: 'Wrong item',
                selected: item.issue == 'Wrong item',
                filledSelected: true,
                onTap: () => onIssue('Wrong item'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionalPhotoUpload extends StatelessWidget {
  const _OptionalPhotoUpload({
    required this.hasPhoto,
    required this.onTap,
    this.photoBytes,
  });

  final bool hasPhoto;
  final Uint8List? photoBytes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFBFCFB),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: CustomPaint(
          painter: const _OptionalDashedBorderPainter(),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 68),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            alignment: Alignment.center,
            child: hasPhoto && photoBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      photoBytes!,
                      height: 56,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '＋ Add a photo',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: IncidentColors.headerGreen,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Optional · helps dispatch resolve faster',
                        style: TextStyle(
                          fontSize: 11,
                          color: IncidentColors.textMuted,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _OptionalDashedBorderPainter extends CustomPainter {
  const _OptionalDashedBorderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCFD4CF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(14)),
      );

    const dashWidth = 5.0;
    const dashGap = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _OptionalDashedBorderPainter oldDelegate) =>
      false;
}
