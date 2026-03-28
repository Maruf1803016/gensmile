// ── Credit Usage Transaction Model ───────────────────────────────────────────
class CreditTransaction {
  const CreditTransaction({
    required this.id,
    required this.type,
    required this.patient,
    required this.credits,
    required this.date,
    required this.balanceAfter,
  });

  final String id;
  final String type;       // 'Simulation', 'Lab Link', 'Credits Purchased'
  final String patient;    // '—' for purchased
  final int credits;       // negative for used, positive for purchased
  final String date;
  final int balanceAfter;
}

// ── Billing Invoice Model ─────────────────────────────────────────────────────
class BillingInvoice {
  const BillingInvoice({
    required this.invoiceId,
    required this.date,
    required this.description,
    required this.amount,
    required this.status,
  });

  final String invoiceId;
  final String date;
  final String description;
  final double amount;
  final String status; // 'Paid', 'Pending', 'Failed'
}

// ── Dummy Data ────────────────────────────────────────────────────────────────
const dummyCreditTransactions = [
  CreditTransaction(
    id: 'UL001',
    type: 'Simulation',
    patient: 'Sarah Johnson',
    credits: -2,
    date: 'Mar 9, 2026',
    balanceAfter: 168,
  ),
  CreditTransaction(
    id: 'UL002',
    type: 'Simulation',
    patient: 'Michael Chen',
    credits: -2,
    date: 'Mar 8, 2026',
    balanceAfter: 170,
  ),
  CreditTransaction(
    id: 'UL003',
    type: 'Lab Link',
    patient: 'Emma Williams',
    credits: -1,
    date: 'Mar 8, 2026',
    balanceAfter: 172,
  ),
  CreditTransaction(
    id: 'UL004',
    type: 'Simulation',
    patient: 'David Martinez',
    credits: -2,
    date: 'Mar 7, 2026',
    balanceAfter: 173,
  ),
  CreditTransaction(
    id: 'UL005',
    type: 'Credits Purchased',
    patient: '—',
    credits: 50,
    date: 'Mar 5, 2026',
    balanceAfter: 175,
  ),
  CreditTransaction(
    id: 'UL006',
    type: 'Lab Link',
    patient: 'James Taylor',
    credits: -1,
    date: 'Mar 4, 2026',
    balanceAfter: 126,
  ),
];

const dummyBillingInvoices = [
  BillingInvoice(
    invoiceId: 'INV-2026-03',
    date: 'Mar 1, 2026',
    description: 'Professional Plan',
    amount: 199.00,
    status: 'Paid',
  ),
  BillingInvoice(
    invoiceId: 'INV-2026-02',
    date: 'Feb 1, 2026',
    description: 'Professional Plan',
    amount: 199.00,
    status: 'Paid',
  ),
  BillingInvoice(
    invoiceId: 'INV-2026-01',
    date: 'Jan 1, 2026',
    description: 'Professional Plan',
    amount: 199.00,
    status: 'Paid',
  ),
  BillingInvoice(
    invoiceId: 'CRD-2026-02',
    date: 'Mar 5, 2026',
    description: '50 Credits Pack',
    amount: 24.99,
    status: 'Paid',
  ),
  BillingInvoice(
    invoiceId: 'CRD-2026-01',
    date: 'Feb 12, 2026',
    description: '100 Credits Pack',
    amount: 49.99,
    status: 'Paid',
  ),
  BillingInvoice(
    invoiceId: 'INV-2025-12',
    date: 'Dec 1, 2025',
    description: 'Professional Plan',
    amount: 199.00,
    status: 'Paid',
  ),
];
