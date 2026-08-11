import React from "react";
import { Routes, Route } from "react-router-dom";

import Dashboard from "../components/dashboard/Dashboard";
import Users from "../pages/Dashboard/Users";
import GiftCards from "../pages/Dashboard/GiftCards";
import Transactions from "../pages/Dashboard/Transactions";
import Withdrawals from "../pages/Dashboard/Withdrawals";
import Deposits from "../pages/Dashboard/Deposits";
import KYC from "../pages/Dashboard/KYC";
import Referrals from "../pages/Dashboard/Referrals";
import Notifications from "../pages/Dashboard/Notifications";
import Support from "../pages/Dashboard/Support";
import Reports from "../pages/Dashboard/Reports";
import SecurityLogs from "../pages/Dashboard/SecurityLogs";
import Settings from "../pages/Dashboard/Settings";

const AppRoutes = () => {
  return (
    <Routes>
      <Route path="/" element={<Dashboard />} />
      <Route path="/users" element={<Users />} />
      <Route path="/gift-cards" element={<GiftCards />} />
      <Route path="/transactions" element={<Transactions />} />
      <Route path="/withdrawals" element={<Withdrawals />} />
      <Route path="/deposits" element={<Deposits />} />
      <Route path="/kyc" element={<KYC />} />
      <Route path="/referrals" element={<Referrals />} />
      <Route path="/notifications" element={<Notifications />} />
      <Route path="/support" element={<Support />} />
      <Route path="/reports" element={<Reports />} />
      <Route path="/security-logs" element={<SecurityLogs />} />
      <Route path="/settings" element={<Settings />} />
    </Routes>
  );
};

export default AppRoutes;