// ── Subscription Plan Model ───────────────────────────────────────────────────
class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.simulations,
    required this.staffSeats,
    required this.patients,
    this.isActive = false,
    this.isCustom = false,
  });

  final String id;
  final String name;
  final double price;
  final String simulations;
  final String staffSeats;
  final String patients;
  final bool isActive;
  final bool isCustom;
}

// ── Usage Stats Model ─────────────────────────────────────────────────────────
class UsageStat {
  const UsageStat({
    required this.label,
    required this.used,
    required this.total,
    required this.percentage,
  });

  final String label;
  final int used;
  final int total;
  final double percentage;
}

// ── Credit Pack Model ─────────────────────────────────────────────────────────
class CreditPack {
  const CreditPack({
    required this.credits,
    required this.pricePerCredit,
    required this.totalPrice,
  });

  final int credits;
  final double pricePerCredit;
  final double totalPrice;
}

// ── Dummy Data ────────────────────────────────────────────────────────────────
const availableSubscriptionPlans = [
  SubscriptionPlan(
    id: 'starter',
    name: 'Starter',
    price: 79,
    simulations: '100 simulations',
    staffSeats: '3 staff seats',
    patients: '500 patients',
  ),
  SubscriptionPlan(
    id: 'professional',
    name: 'Professional',
    price: 199,
    simulations: '500 simulations',
    staffSeats: '10 staff seats',
    patients: '2000 patients',
    isActive: true,
  ),
  SubscriptionPlan(
    id: 'clinic',
    name: 'Clinic',
    price: 399,
    simulations: '1500 simulations',
    staffSeats: '25 staff seats',
    patients: '10000 patients',
  ),
  SubscriptionPlan(
    id: 'enterprise',
    name: 'Enterprise',
    price: 0,
    simulations: 'Unlimited simulations',
    staffSeats: 'Unlimited staff seats',
    patients: 'Unlimited patients',
    isCustom: true,
  ),
];

const availableCreditPacks = [
  CreditPack(
    credits: 50,
    pricePerCredit: 0.50,
    totalPrice: 24.99,
  ),
  CreditPack(
    credits: 100,
    pricePerCredit: 0.45,
    totalPrice: 44.99,
  ),
  CreditPack(
    credits: 250,
    pricePerCredit: 0.40,
    totalPrice: 99.99,
  ),
];

const dummyUsageStats = [
  UsageStat(
    label: 'Simulation Limit',
    used: 342,
    total: 500,
    percentage: 0.68,
  ),
  UsageStat(
    label: 'Staff Seats',
    used: 5,
    total: 10,
    percentage: 0.50,
  ),
  UsageStat(
    label: 'Patient Record Capacity',
    used: 1284,
    total: 2000,
    percentage: 0.64,
  ),
];
