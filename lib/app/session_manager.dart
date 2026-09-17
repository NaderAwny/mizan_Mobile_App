import 'dart:async';
import 'package:injectable/injectable.dart';

@lazySingleton
class SessionManager {
  final _controller = StreamController<void>.broadcast();

  /// UI layer تسمع عليه وتعمل Navigator.pushNamedAndRemoveUntil(login).
  Stream<void> get onSessionExpired => _controller.stream;

  void notifySessionExpired() => _controller.add(null);

  void dispose() => _controller.close();
}
