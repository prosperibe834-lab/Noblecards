import React, { useState, useMemo, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { initialDeposits, depositStatsSummary, depositChartData } from '../../data/depositData';
import { exportDepositsToCSV } from '../../utils/exportCsv';
import { DepositStats } from '../../components/deposits/DepositStats';
import { DepositFilters } from '../../components/deposits/DepositFilters';
import { DepositTable } from '../../components/deposits/DepositTable';
import { DepositCharts } from '../../components/deposits/DepositCharts';
import { DepositDetailsModal } from '../../components/deposits/DepositDetailsModal';
import '../../styles/deposits.css';

export default function Deposits() {
  const navigate = useNavigate();

  // Primary Data State
  const [deposits, setDeposits] = useState(initialDeposits);
  const [stats, setStats] = useState(depositStatsSummary);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(false);

  // Selected Deposit Drawer State
  const [selectedDeposit, setSelectedDeposit] = useState(null);

  // Active Filters State
  const [filters, setFilters] = useState({
    search: '',
    status: 'All',
    method: 'All',
    currency: 'All',
    provider: 'All',
    datePreset: 'all',
    fromDate: '',
    toDate: '',
    minAmount: '',
    maxAmount: ''
  });

  // Table Sorting State
  const [sortConfig, setSortConfig] = useState({
    key: 'createdAt',
    direction: 'desc'
  });

  // Pagination State
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  // Extract unique providers for dropdown selection
  const providersList = useMemo(() => {
    const list = new Set(initialDeposits.map((d) => d.provider).filter(Boolean));
    return Array.from(list);
  }, []);

  // Filter Handler
  const handleFilterChange = (key, value) => {
    setFilters((prev) => ({ ...prev, [key]: value }));
    setCurrentPage(1); // Reset to page 1 on filter change
  };

  const handleResetFilters = () => {
    setFilters({
      search: '',
      status: 'All',
      method: 'All',
      currency: 'All',
      provider: 'All',
      datePreset: 'all',
      fromDate: '',
      toDate: '',
      minAmount: '',
      maxAmount: ''
    });
    setCurrentPage(1);
  };

  // Stat Card Click Handler
  const handleSelectStatusFilter = (statusKey) => {
    if (statusKey === 'All' || statusKey === 'Today' || statusKey === 'Revenue') {
      handleFilterChange('status', 'All');
    } else {
      handleFilterChange('status', statusKey);
    }
  };

  const handleSelectAttention = () => {
    // Filter for failed or reconciliation mismatches
    setFilters((prev) => ({
      ...prev,
      status: 'Failed'
    }));
  };

  // Sort Handler
  const handleSort = (columnKey) => {
    let direction = 'asc';
    if (sortConfig.key === columnKey && sortConfig.direction === 'asc') {
      direction = 'desc';
    }
    setSortConfig({ key: columnKey, direction });
  };

  // Refresh Trigger with Shimmer Loading Simulation
  const handleRefresh = () => {
    setLoading(true);
    setError(false);
    setTimeout(() => {
      setDeposits([...initialDeposits]);
      setLoading(false);
    }, 800);
  };

  // Export CSV Handler
  const handleExport = () => {
    exportDepositsToCSV(filteredDeposits);
  };

  // View User Navigation Handler
  const handleViewUser = (userId) => {
    navigate(`/users/${userId}`);
  };

  // Update Status Callback from Details Modal
  const handleActionSuccess = (depositId, newStatus) => {
    setDeposits((prev) =>
      prev.map((item) =>
        item.id === depositId ? { ...item, status: newStatus } : item
      )
    );
    if (selectedDeposit && selectedDeposit.id === depositId) {
      setSelectedDeposit((prev) => ({ ...prev, status: newStatus }));
    }
  };

  // Filtering Logic
  const filteredDeposits = useMemo(() => {
    return deposits.filter((item) => {
      // 1. Search Query
      if (filters.search) {
        const query = filters.search.toLowerCase();
        const matchesSearch =
          item.id.toLowerCase().includes(query) ||
          item.userId.toLowerCase().includes(query) ||
          item.userName.toLowerCase().includes(query) ||
          item.userTag.toLowerCase().includes(query) ||
          item.email.toLowerCase().includes(query) ||
          (item.providerRef && item.providerRef.toLowerCase().includes(query)) ||
          (item.paymentRef && item.paymentRef.toLowerCase().includes(query));

        if (!matchesSearch) return false;
      }

      // 2. Status Filter
      if (filters.status !== 'All' && item.status !== filters.status) {
        return false;
      }

      // 3. Method Filter
      if (filters.method !== 'All' && item.method !== filters.method) {
        return false;
      }

      // 4. Currency Filter
      if (filters.currency !== 'All' && item.currency !== filters.currency) {
        return false;
      }

      // 5. Provider Filter
      if (filters.provider !== 'All' && item.provider !== filters.provider) {
        return false;
      }

      // 6. Date Range Filtering
      if (filters.datePreset !== 'all') {
        const itemDate = new Date(item.createdAt);
        const now = new Date();

        if (filters.datePreset === 'today') {
          if (itemDate.toDateString() !== now.toDateString()) return false;
        } else if (filters.datePreset === 'yesterday') {
          const yesterday = new Date(now);
          yesterday.setDate(now.getDate() - 1);
          if (itemDate.toDateString() !== yesterday.toDateString()) return false;
        } else if (filters.datePreset === 'last7') {
          const sevenDaysAgo = new Date(now);
          sevenDaysAgo.setDate(now.getDate() - 7);
          if (itemDate < sevenDaysAgo) return false;
        } else if (filters.datePreset === 'last30') {
          const thirtyDaysAgo = new Date(now);
          thirtyDaysAgo.setDate(now.getDate() - 30);
          if (itemDate < thirtyDaysAgo) return false;
        } else if (filters.datePreset === 'custom') {
          if (filters.fromDate && itemDate < new Date(filters.fromDate)) return false;
          if (filters.toDate && itemDate > new Date(filters.toDate)) return false;
        }
      }

      // 7. Amount Range Filtering (in USD Value)
      if (filters.minAmount && item.usdValue < Number(filters.minAmount)) return false;
      if (filters.maxAmount && item.usdValue > Number(filters.maxAmount)) return false;

      return true;
    });
  }, [deposits, filters]);

  // Sorting Logic
  const sortedDeposits = useMemo(() => {
    const data = [...filteredDeposits];
    if (!sortConfig.key) return data;

    data.sort((a, b) => {
      let aVal = a[sortConfig.key];
      let bVal = b[sortConfig.key];

      if (sortConfig.key === 'createdAt') {
        aVal = new Date(aVal).getTime();
        bVal = new Date(bVal).getTime();
      }

      if (aVal < bVal) return sortConfig.direction === 'asc' ? -1 : 1;
      if (aVal > bVal) return sortConfig.direction === 'asc' ? 1 : -1;
      return 0;
    });

    return data;
  }, [filteredDeposits, sortConfig]);

  // Pagination Slicing
  const paginatedDeposits = useMemo(() => {
    const startIndex = (currentPage - 1) * pageSize;
    return sortedDeposits.slice(startIndex, startIndex + pageSize);
  }, [sortedDeposits, currentPage, pageSize]);

  return (
    <div className="deposits-page-container">
      {/* Page Header */}
      <div className="deposits-page-header">
        <div>
          <h1>Deposits</h1>
          <p className="subtitle">Monitor, review and manage all NobleCards deposit activity.</p>
        </div>
        <div className="header-actions">
          <button className="btn-header-action" onClick={handleRefresh} disabled={loading}>
            <i className={`bx bx-refresh ${loading ? 'bx-spin' : ''}`}></i>
            <span>{loading ? 'Refreshing...' : 'Refresh'}</span>
          </button>
          <button className="btn-header-action primary" onClick={handleExport}>
            <i className="bx bx-export"></i>
            <span>Export CSV</span>
          </button>
        </div>
      </div>

      {/* Summary Stat Cards */}
      <DepositStats
        stats={stats}
        activeStatusFilter={filters.status}
        onSelectStatusFilter={handleSelectStatusFilter}
        onSelectAttention={handleSelectAttention}
      />

      {/* Recharts Graphical Analytics */}
      <DepositCharts chartData={depositChartData} />

      {/* Search & Filter Controls */}
      <DepositFilters
        filters={filters}
        onFilterChange={handleFilterChange}
        onResetFilters={handleResetFilters}
        providersList={providersList}
      />

      {/* Main Content Area: Table / Loading / Error / Empty States */}
      {loading ? (
        <div className="state-box">
          <div className="skeleton-shimmer skeleton-table-row"></div>
          <div className="skeleton-shimmer skeleton-table-row"></div>
          <div className="skeleton-shimmer skeleton-table-row"></div>
          <p className="text-secondary">Fetching latest ledger state...</p>
        </div>
      ) : error ? (
        <div className="state-box">
          <i className="bx bx-error-circle text-danger"></i>
          <h3>Unable to load deposits</h3>
          <p>An unexpected network or server error occurred while retrieving deposits.</p>
          <button className="btn-header-action primary" onClick={handleRefresh}>
            Retry Loading
          </button>
        </div>
      ) : sortedDeposits.length === 0 ? (
        <div className="state-box">
          <i className="bx bx-search-alt"></i>
          <h3>No deposits found</h3>
          <p>No deposit records matched your active filter or search criteria.</p>
          <button className="reset-filters-btn" onClick={handleResetFilters}>
            Clear Filters
          </button>
        </div>
      ) : (
        <DepositTable
          deposits={paginatedDeposits}
          sortConfig={sortConfig}
          onSort={handleSort}
          onViewDetails={(deposit) => setSelectedDeposit(deposit)}
          onViewUser={handleViewUser}
          currentPage={currentPage}
          pageSize={pageSize}
          totalItems={sortedDeposits.length}
          onPageChange={(page) => setCurrentPage(page)}
          onPageSizeChange={(size) => {
            setPageSize(size);
            setCurrentPage(1);
          }}
        />
      )}

      {/* Deposit Details Modal / Drawer */}
      {selectedDeposit && (
        <DepositDetailsModal
          deposit={selectedDeposit}
          onClose={() => setSelectedDeposit(null)}
          onViewUser={handleViewUser}
          onActionSuccess={handleActionSuccess}
        />
      )}
    </div>
  );
}