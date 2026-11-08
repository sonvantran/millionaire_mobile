import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'guest_service.dart';

const _gold = Color(0xFFFFC83D);
const _bgTop = Color(0xFF0B1033);
const _bgBottom = Color(0xFF2A1260);
const _card = Color(0xFF141A44);

class GuestPickerPage extends StatefulWidget {
  const GuestPickerPage({super.key});
  @override
  State<GuestPickerPage> createState() => _GuestPickerPageState();
}

class _GuestPickerPageState extends State<GuestPickerPage> {
  final service = LiveGuestService();
  final userCtrl = TextEditingController();
  final keywordCtrl = TextEditingController(text: 'tham gia');
  final selected = StreamController<int>.broadcast();

  List<Viewer> entries = [];
  Viewer? winner;
  Viewer? pending;
  bool spinning = false;
  String status = 'Chưa kết nối';

  @override
  void initState() {
    super.initState();
    service.onEntries.listen((e) {
      if (mounted) setState(() => entries = e);
    });
    service.onStatus.listen((s) {
      if (mounted) setState(() => status = s);
    });
  }

  @override
  void dispose() {
    service.dispose();
    selected.close();
    userCtrl.dispose();
    keywordCtrl.dispose();
    super.dispose();
  }

  void connect() {
    final id = userCtrl.text.trim().replaceAll('@', '');
    if (id.isEmpty) {
      setState(() => status = 'Hãy nhập TikTok ID');
      return;
    }
    setState(() => status = 'Đang kết nối...');
    service.connect(id, keyword: keywordCtrl.text.trim());
  }

  void spin() {
    if (entries.length < 2 || spinning) return;
    final idx = Random.secure().nextInt(entries.length);
    setState(() {
      winner = null;
      pending = entries[idx];
      spinning = true;
    });
    selected.add(idx);
  }

  void onSpinEnd() {
    if (!mounted) return;
    setState(() {
      winner = pending;
      spinning = false;
    });
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth >= 900;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                _header(),
                const SizedBox(height: 14),
                Expanded(
                  child: wide
                      ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(
                            flex: 4,
                            child: Column(children: [
                              _connectCard(),
                              const SizedBox(height: 14),
                              Expanded(child: _listCard(wide: true)),
                            ]),
                          ),
                          const SizedBox(width: 16),
                          Expanded(flex: 5, child: _wheelCard(wide: true)),
                        ])
                      : SingleChildScrollView(
                          child: Column(children: [
                            _connectCard(),
                            const SizedBox(height: 14),
                            _wheelCard(wide: false),
                            const SizedBox(height: 14),
                            _listCard(wide: false),
                          ]),
                        ),
                ),
              ]),
            );
          }),
        ),
      ),
    );
  }

  Widget _header() => const Row(children: [
        Icon(Icons.emoji_events, color: _gold, size: 30),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'CHỌN KHÁCH MỜI TỪ TIKTOK LIVE',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _gold,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
      ]);

  BoxDecoration get _cardDeco => BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _gold.withAlpha(90), width: 1.2),
      );

  Widget _connectCard() {
    final connected = status == 'Đã kết nối';
    final connecting = status == 'Đang kết nối...';
    final dot = connected
        ? Colors.greenAccent
        : (connecting || status == 'Chưa kết nối')
            ? Colors.grey
            : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: TextField(
              controller: userCtrl,
              decoration: _input('TikTok ID', Icons.person),
              onSubmitted: (_) => connect(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: keywordCtrl,
              decoration: _input('Từ khóa tham gia', Icons.key),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: connect,
              style: FilledButton.styleFrom(
                  backgroundColor: _gold, foregroundColor: Colors.black),
              icon: const Icon(Icons.wifi_tethering),
              label: const Text('Kết nối'),
            ),
            OutlinedButton.icon(
              onPressed: entries.isEmpty ? null : service.clear,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Xóa danh sách'),
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.circle, size: 12, color: dot),
              const SizedBox(width: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: Text(status,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70)),
              ),
            ]),
          ],
        ),
      ]),
    );
  }

  InputDecoration _input(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        isDense: true,
        filled: true,
        fillColor: Colors.white.withAlpha(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      );

  Widget _listCard({required bool wide}) {
    final list = entries.isEmpty
        ? const Center(
            child: Text('Chưa có ai.\nNgười xem comment từ khóa để vào đây.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54)))
        : ListView.separated(
            itemCount: entries.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.white.withAlpha(20)),
            itemBuilder: (_, i) {
              final v = entries[i];
              final initial =
                  v.nickname.isEmpty ? '?' : v.nickname.characters.first;
              return ListTile(
                dense: true,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: _gold,
                  child: Text(initial.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                title: Text(v.nickname,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('@${v.uniqueId}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white54)),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => service.removeEntry(v),
                ),
              );
            },
          );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco,
      child: Column(children: [
        Row(children: [
          const Icon(Icons.groups, color: _gold),
          const SizedBox(width: 8),
          Text('Danh sách tham gia (${entries.length})',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 8),
        if (wide) Expanded(child: list) else SizedBox(height: 260, child: list),
      ]),
    );
  }

  Widget _wheelCard({required bool wide}) {
    final canSpin = entries.length >= 2 && !spinning;

    final wheel = entries.length < 2
        ? const Center(
            child: Text('Cần ít nhất 2 người để quay',
                style: TextStyle(color: Colors.white54, fontSize: 16)))
        : Padding(
            padding: const EdgeInsets.all(8),
            child: FortuneWheel(
              selected: selected.stream,
              animateFirst: false,
              duration: const Duration(seconds: 5),
              onAnimationEnd: onSpinEnd,
              items: [
                for (var i = 0; i < entries.length; i++)
                  FortuneItem(
                    child: Text(entries[i].nickname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                    style: FortuneItemStyle(
                      color: i.isEven
                          ? const Color(0xFF2B3A9E)
                          : const Color(0xFF6A2BA8),
                      borderColor: _gold,
                      borderWidth: 2,
                    ),
                  ),
              ],
            ),
          );

    final winnerBox = AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: winner == null
          ? SizedBox(
              key: const ValueKey('none'),
              height: 70,
              child: Center(
                child: Text(
                  spinning ? 'Đang quay...' : 'Bấm QUAY để chọn khách mời',
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
            )
          : Container(
              key: ValueKey(winner!.uniqueId),
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _gold,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(children: [
                const Text('KHÁCH MỜI MAY MẮN',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(winner!.nickname,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w900)),
                Text('@${winner!.uniqueId}',
                    style: const TextStyle(color: Colors.black87)),
                TextButton.icon(
                  onPressed: () {
                    service.removeEntry(winner!);
                    setState(() => winner = null);
                  },
                  icon: const Icon(Icons.person_remove, color: Colors.black87),
                  label: const Text('Loại khỏi danh sách',
                      style: TextStyle(color: Colors.black87)),
                ),
              ]),
            ),
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco,
      child: Column(children: [
        if (wide) Expanded(child: wheel) else SizedBox(height: 340, child: wheel),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: canSpin ? spin : null,
            style: FilledButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: Colors.black,
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            child: const Text('QUAY!'),
          ),
        ),
        const SizedBox(height: 12),
        winnerBox,
      ]),
    );
  }
}