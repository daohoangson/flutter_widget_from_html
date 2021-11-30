import 'package:flutter/material.dart';

final Listenable showPerfOverlayListenable = _showPerfOverlay;

bool showPerfOverlayValue() => _showPerfOverlay.value;

class ShowPerfIconButton extends StatelessWidget {
  const ShowPerfIconButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.speed_outlined),
      onPressed: () => _showPerfOverlay.value = !_showPerfOverlay.value,
    );
  }
}

final _showPerfOverlay = ValueNotifier(false);
