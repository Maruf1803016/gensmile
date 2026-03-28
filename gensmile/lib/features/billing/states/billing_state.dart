import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Active tab index (0=Overview, 1=History, 2=Manage) ───────────────────────
final billingTabProvider = StateProvider<int>((ref) => 0);

// ── Selected plan for expansion on mobile ────────────────────────────────────
final expandedPlanProvider = StateProvider<String?>((ref) => null);

// ── Selected credit pack index ────────────────────────────────────────────────
final selectedCreditPackProvider = StateProvider<int?>((ref) => null);

// ── Add card sheet visibility ─────────────────────────────────────────────────
final showAddCardProvider = StateProvider<bool>((ref) => false);
