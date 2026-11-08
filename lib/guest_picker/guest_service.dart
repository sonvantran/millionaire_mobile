import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';

class Viewer {
  final String uniqueId;
  final String nickname;
  Viewer(this.uniqueId, this.nickname);
}

class LiveGuestService {
  WebSocketChannel? _ch;
  final List<Viewer> entries = [];
  final _controller = StreamController<List<Viewer>>.broadcast();
  final _statusCtrl = StreamController<String>.broadcast();

  Stream<List<Viewer>> get onEntries => _controller.stream;
  Stream<String> get onStatus => _statusCtrl.stream;

  /// keyword: chỉ comment chứa từ này mới được vào danh sách (để rỗng = mọi comment)
  void connect(String username, {String keyword = 'tham gia'}) {
    _ch?.sink.close();
    _ch = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
    _ch!.stream.listen((raw) {
      final m = jsonDecode(raw as String) as Map<String, dynamic>;
      if (m['type'] == 'status') {
        _statusCtrl.add(m['ok'] == true ? 'Đã kết nối' : '${m['error']}');
      } else if (m['type'] == 'chat') {
        final comment = (m['comment'] as String? ?? '').toLowerCase();
        final id = m['uniqueId'] as String?;
        if (id == null) return;
        if (keyword.isNotEmpty && !comment.contains(keyword.toLowerCase())) return;
        if (entries.any((e) => e.uniqueId == id)) return; // mỗi người 1 suất
        entries.add(Viewer(id, m['nickname'] as String? ?? id));
        _controller.add(List.of(entries));
      }
    });
    _ch!.sink.add(jsonEncode({'type': 'connect', 'username': username}));
  }

  void clear() {
    entries.clear();
    _controller.add([]);
  }

  void removeEntry(Viewer v) {
    entries.removeWhere((e) => e.uniqueId == v.uniqueId);
    _controller.add(List.of(entries));
  }

  void dispose() {
    _ch?.sink.close();
    _controller.close();
    _statusCtrl.close();
  }
}