import React, { useState, useEffect } from 'react';
import { dashboardMockData } from '../../data/dashboardData';
import DashboardHeader from '../../components/dashboard/DashboardHeader';
import StatCard from '../../components/dashboard/StatCard';
import RevenueChart from '../../components/dashboard/RevenueChart';
import SalesByCardChart from '../../components/dashboard/SalesByCardChart';
import TopCountries from '../../components/dashboard/TopCountries';
import RecentTransactions from '../../components/dashboard/RecentTransactions';
import SystemStatus from '../../components/dashboard/SystemStatus';
import QuickActions from '../../components/dashboard/QuickActions';
import PendingApprovals from '../../components/dashboard/PendingApprovals';
import { DashboardSkeleton, ErrorState } from '../../components/dashboard/DashboardStates';
import '../../styles/dashboard.css';

const Dashboard = () => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);
  const [data, setData] = useState(null);

  const fetchDashboardData = () => {
    setLoading(true);
    setError(false);
    // Simulate network fetch from API
    setTimeout(() => {
      try {
        setData(dashboardMockData);
        setLoading(false);
      } catch (err) {
        setError(true);
        setLoading(false);
      }
    }, 400);
  };

  useEffect(() => {
    fetchDashboardData();
  }, []);

  if (loading) return <DashboardSkeleton />;
  if (error) return <ErrorState onRetry={fetchDashboardData} />;

  return (
    <div className="dashboard-container">
      {/* Top Header */}
      <DashboardHeader
        headerData={data.header}
        onDateRangeChange={(range) => console.log('Date range updated:', range)}
      />

      {/* Main Grid Layout */}
      <div className="dashboard-grid-main">
        {/* Left Column (Primary Analytics) */}
        <div className="dashboard-left-column">
          {/* Overview Stat Cards Row */}
          <div className="stats-grid-row">
            {data.overviewStats.map((stat) => (
              <StatCard key={stat.id} stat={stat} />
            ))}
          </div>

          {/* Revenue Area Chart & Donut Pie Chart */}
          <div className="charts-grid-row">
            <RevenueChart revenueData={data.revenueOverview} />
            <SalesByCardChart salesData={data.salesByGiftCard} />
          </div>

          {/* Top Countries Map & Breakdown */}
          <TopCountries countries={data.topCountries} />

          {/* Quick Actions & Pending Approvals */}
          <div className="bottom-grid-row">
            <QuickActions actions={data.quickActions} />
            <PendingApprovals approvals={data.pendingApprovals} />
          </div>
        </div>

        {/* Right Column (Transactions & Health Monitoring) */}
        <div className="dashboard-right-column">
          <RecentTransactions transactions={data.recentTransactions} />
          <SystemStatus statusData={data.systemStatus} />
        </div>
      </div>
    </div>
  );
};

export default Dashboard;