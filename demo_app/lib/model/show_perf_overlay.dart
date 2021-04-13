import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final Listenable showPerfOverlayListenable = _showPerfOverlay;

bool showPerfOverlayValue() => _showPerfOverlay.value;

class ShowPerfIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.speed_outlined),
      onPressed: () => _showPerfOverlay.value = !_showPerfOverlay.value,
    );
  }
}

final _showPerfOverlay = ValueNotifier(false);
