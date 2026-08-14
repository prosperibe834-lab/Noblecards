export const platformSettings = {
  platformName: "NobleCards",
  supportEmail: "support@noblecards.com",
  defaultCurrency: "NGN",
  maintenanceMode: false,
  maintenanceMessage: "We are performing scheduled maintenance. Please try again in a few minutes.",
};

export const integrationsList = [
  { id: "flutterwave", name: "Flutterwave", icon: "bx-wallet", status: "Connected" },
  { id: "paystack", name: "Paystack", icon: "bx-credit-card", status: "Connected" },
  { id: "gmail", name: "Gmail SMTP", icon: "bx-envelope", status: "Connected" },
  { id: "sendgrid", name: "SendGrid", icon: "bx-send", status: "Warning" },
];

export const initialAdmins = [
  {
    id: "ADM-001",
    fullName: "Noble Master",
    email: "admin@noblecards.com",
    role: "Super Admin",
    status: "Active",
    lastLogin: "2 hours ago",
    avatar: "https://ui-avatars.com/api/?name=Noble+Master&background=10B981&color=fff",
  },
  {
    id: "ADM-002",
    fullName: "Aisha Bello",
    email: "aisha@noblecards.com",
    role: "Finance Admin",
    status: "Active",
    lastLogin: "1 day ago",
    avatar: "https://ui-avatars.com/api/?name=Aisha+Bello&background=2563EB&color=fff",
  },
  {
    id: "ADM-003",
    fullName: "Daniel Okafor",
    email: "daniel@noblecards.com",
    role: "Support Admin",
    status: "Suspended",
    lastLogin: "3 days ago",
    avatar: "https://ui-avatars.com/api/?name=Daniel+Okafor&background=F59E0B&color=fff",
  },
];
