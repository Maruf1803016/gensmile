class PlanModel {
  const PlanModel({
    required this.id,
    required this.name,
    required this.price,
    required this.features,
    this.isPopular = false,
  });

  final String id;
  final String name;
  final int price;
  final List<String> features;
  final bool isPopular;
}

const availablePlans = [
  PlanModel(
    id: 'starter',
    name: 'Starter',
    price: 99,
    features: [
      '50 simulations/month',
      'Basic analytics',
      'Email support',
      '1 clinic location',
    ],
  ),
  PlanModel(
    id: 'growth',
    name: 'Growth',
    price: 249,
    isPopular: true,
    features: [
      '200 simulations/month',
      'Advanced analytics',
      'Priority support',
      '3 clinic locations',
      'Custom branding',
    ],
  ),
  PlanModel(
    id: 'enterprise',
    name: 'Enterprise',
    price: 599,
    features: [
      'Unlimited simulations',
      'Enterprise analytics',
      '24/7 dedicated support',
      'Unlimited locations',
      'API access',
    ],
  ),
];
