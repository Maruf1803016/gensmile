import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalNavigatorKey =
    Provider((ref) => GlobalKey<NavigatorState>());

final navigatorState =
    StateNotifierProvider<NavigatorNotifier, void>(
  (ref) => NavigatorNotifier(ref, ref.watch(globalNavigatorKey)),
);

class NavigatorNotifier extends StateNotifier<void> {
  final Ref ref;
  final GlobalKey<NavigatorState> navigatoryKey;
  NavigatorNotifier(this.ref, this.navigatoryKey) : super(null);

  void push(Widget page) {
    navigatoryKey.currentState
        ?.push(MaterialPageRoute(builder: (_) => page));
  }

  void pushReplacement(Widget page) {
    navigatoryKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void pushReplacementAll(Widget page) {
    navigatoryKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (_) => false,
    );
  }

  void pop() {
    if (navigatoryKey.currentState?.canPop() ?? false) {
      navigatoryKey.currentState?.pop();
    }
  }
}
