import 'package:flutter/material.dart';
import 'package:yjeek_driver/features/incidents_safety/view/incident_ui.dart';

enum _BubbleKind { system, dispatch, driver }

class _ChatBubble {
  const _ChatBubble({
    required this.kind,
    required this.text,
    this.quickReplies,
    this.actions,
  });

  final _BubbleKind kind;
  final String text;
  final List<String>? quickReplies;
  final List<_ChatAction>? actions;
}

class _ChatAction {
  const _ChatAction(this.label, {this.primary = false});
  final String label;
  final bool primary;
}

/// DR1b-Chat · Dispatch — can’t reach customer
class DispatchCantReachChatScreen extends StatefulWidget {
  const DispatchCantReachChatScreen({
    super.key,
    this.args = const IncidentContextArgs(),
  });

  final IncidentContextArgs args;

  @override
  State<DispatchCantReachChatScreen> createState() =>
      _DispatchCantReachChatScreenState();
}

class _DispatchCantReachChatScreenState
    extends State<DispatchCantReachChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  late final List<_ChatBubble> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      const _ChatBubble(
        kind: _BubbleKind.system,
        text: 'Drop-off · 2 attempts made',
      ),
      const _ChatBubble(
        kind: _BubbleKind.dispatch,
        text:
            'Hi Sara — I see you’ve tried the customer twice. Please make a 3rd attempt now, then wait the 5-minute window. I’m calling them too.',
        quickReplies: [
          'Attempt 3 done',
          'Left voicemail',
          'Still no answer',
        ],
      ),
      const _ChatBubble(
        kind: _BubbleKind.driver,
        text: '3rd attempt done — still no answer.',
      ),
      const _ChatBubble(
        kind: _BubbleKind.dispatch,
        text:
            'Thanks. This order is non-food, sealed, with a confirmed address — so you’re eligible to leave it at the door with a photo, or return it. You’re not penalized either way.',
      ),
      const _ChatBubble(
        kind: _BubbleKind.system,
        text: '5-minute window elapsed · 3 attempts logged',
      ),
      const _ChatBubble(
        kind: _BubbleKind.dispatch,
        text: 'Choose how you’d like to close this delivery:',
        actions: [
          _ChatAction('📷 Leave at door + photo', primary: true),
          _ChatAction('↩ Return order'),
        ],
      ),
      const _ChatBubble(
        kind: _BubbleKind.driver,
        text: 'I’ll leave it at the door and upload a photo.',
      ),
      const _ChatBubble(
        kind: _BubbleKind.dispatch,
        text:
            'Perfect — marked “Left at door”. All 3 attempts are timestamped and you’re protected. You’re clear to continue 🙌',
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send([String? preset]) {
    final text = (preset ?? _controller.text).trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatBubble(kind: _BubbleKind.driver, text: text));
      _controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IncidentColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            IncidentHeader(
              title: 'Dispatch chat',
              subtitle: widget.args.dropoffSubtitle,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: IncidentColors.white,
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: IncidentColors.headerGreen,
                    child: Icon(Icons.headset_mic, size: 14, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Dispatch · usually replies in ~30 sec',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: IncidentColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildMessage(msg),
                  );
                },
              ),
            ),
            _buildComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(_ChatBubble msg) {
    switch (msg.kind) {
      case _BubbleKind.system:
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFDDE5DD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              msg.text,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5B6B58),
              ),
            ),
          ),
        );
      case _BubbleKind.dispatch:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: IncidentColors.headerGreen,
                  child: Icon(Icons.support_agent, size: 14, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: IncidentColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE3E8E0)),
                    ),
                    child: Text(
                      msg.text,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Color(0xFF25302B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (msg.quickReplies != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: msg.quickReplies!
                    .map(
                      (r) => IncidentChip(
                        label: r,
                        selected: false,
                        onTap: () => _send(r),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (msg.actions != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: msg.actions!.map((a) {
                  if (a.primary) {
                    return Material(
                      color: IncidentColors.headerGreen,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: () => _send(a.label),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Text(
                            a.label,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return IncidentChip(
                    label: a.label,
                    selected: false,
                    onTap: () => _send(a.label),
                  );
                }).toList(),
              ),
            ],
          ],
        );
      case _BubbleKind.driver:
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: IncidentColors.headerGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              msg.text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Colors.white,
              ),
            ),
          ),
        );
    }
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      color: IncidentColors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F5F1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Message dispatch…',
                  hintStyle: TextStyle(color: Color(0xFF9AA09B), fontSize: 14),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: IncidentColors.headerGreen,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _send,
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
