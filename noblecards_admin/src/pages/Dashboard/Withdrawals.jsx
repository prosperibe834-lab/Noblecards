import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import '../../styles/withdrawals.css';
import { initialWithdrawalData } from '../../data/withdrawalData';
import WithdrawalStats from '../../components/withdrawals/WithdrawalStats';
import WithdrawalFilters from '../../components/withdrawals/WithdrawalFilters';
import WithdrawalCharts from '../../components/withdrawals/WithdrawalCharts';
import WithdrawalTable from '../../components/withdrawals/WithdrawalTable';
import WithdrawalDetails from '../../components/withdrawals/WithdrawalDetails';
import WithdrawalActions from '../../components/withdrawals/WithdrawalActions';
import { WithdrawalShimmer, WithdrawalEmptyState, WithdrawalErrorState } from '../../components/withdrawals/WithdrawalStates';

const Withdrawals = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [error, setError] = useState(false);

  // Core Data
  const [withdrawals, setWithdrawals] = useState([]);

  // Filter States
  const [filters, setFilters] = useState({
    search: '',
    status: 'All',
    method: 'All',
    currency: 'All',
    risk: 'All',
    dateRange: 'All',
    startDate: '',
    endDate: '',
    minAmount: '',
    maxAmount: ''
  });

  // Sorting and Pagination
  const [sortField, setSortField] = useState('date');
  const [sortDirection, setSortDirection] = useState('desc');
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  // Modals & Drawers
  const [selectedWithdrawal, setSelectedWithdrawal] = useState(null);
  const [actionModal, setActionModal] = useState(null);

  // Initial Load Simulation
  useEffect(() => {
    const timer = setTimeout(() => {
      setWithdrawals(initialWithdrawalData);
      setLoading(false);
    }, 600);
    return () => clearTimeout(timer);
  }, []);

  // Handle Refresh Action
  const handleRefresh = () => {
    setIsRefreshing(true);
    setTimeout(() => {
      setWithdrawals([...initialWithdrawalData]);
      setIsRefreshing(false);
    }, 800);
  };

  // Filter Handling
  const handleFilterChange = (key, value) => {
    setFilters(prev => ({ ...prev, [key]: value }));
    setCurrentPage(1);
  };

  const handleResetFilters = () => {
    setFilters({
      search: '',
      status: 'All',
      method: 'All',
      currency: 'All',
      risk: 'All',
      dateRange: 'All',
      startDate: '',
      endDate: '',
      minAmount: '',
      maxAmount: ''
    });
    setCurrentPage(1);
  };

  // Sorting
  const handleSort = (field) => {
    if (sortField === field) {
      setSortDirection(prev => prev === 'asc' ? 'desc' : 'asc');
    } else {
      setSortField(field);
      setSortDirection('asc');
    }
  };

  // CSV Export
  const handleExportCSV = () => {
    const headers = ["Withdrawal ID", "User ID", "User Name", "Email", "Original Amount", "Currency", "USD Value", "Method", "Provider", "Status", "Risk", "Date"];
    const rows = filteredData.map(w => [
      w.id, w.userId, `"${w.userName}"`, w.userEmail, w.originalAmount, w.currency, w.usdValue, w.method, w.provider, w.status, w.risk, w.date
    ]);

    const csvContent = "data:text/csv;charset=utf-8," + [headers.join(','), ...rows.map(e => e.join(','))].join("\n");
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", `NobleCards_Withdrawals_${new Date().toISOString().slice(0,10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  // Action Confirmation (Reject/Retry)
  const handleConfirmAction = (withdrawalId, actionType) => {
    setWithdrawals(prev => prev.map(w => {
      if (w.id === withdrawalId) {
        const updatedStatus = actionType === 'Reject' ? 'Rejected' : 'Processing';
        return { ...w, status: updatedStatus };
      }
      return w;
    }));
    setActionModal(null);
  };

  // Navigate to User Details Page
  const handleViewUser = (userId) => {
    navigate(`/users/${userId}`);
  };

  // Filter Computation Pipeline
  const filteredData = withdrawals.filter(item => {
    const query = filters.search.toLowerCase();
    const matchesSearch = !query || 
      item.id.toLowerCase().includes(query) ||
      item.userId.toLowerCase().includes(query) ||
      item.userName.toLowerCase().includes(query) ||
      item.userEmail.toLowerCase().includes(query) ||
      (item.providerReference && item.providerReference.toLowerCase().includes(query));

    const matchesStatus = filters.status === 'All' || item.status === filters.status;
    const matchesMethod = filters.method === 'All' || item.method === filters.method;
    const matchesCurrency = filters.currency === 'All' || item.currency === filters.currency;
    const matchesRisk = filters.risk === 'All' || item.risk === filters.risk;

    const matchesMinAmount = !filters.minAmount || item.usdValue >= parseFloat(filters.minAmount);
    const matchesMaxAmount = !filters.maxAmount || item.usdValue <= parseFloat(filters.maxAmount);

    return matchesSearch && matchesStatus && matchesMethod && matchesCurrency && matchesRisk && matchesMinAmount && matchesMaxAmount;
  }).sort((a, b) => {
    let aVal = a[sortField];
    let bVal = b[sortField];
    if (typeof aVal === 'string') {
      aVal = aVal.toLowerCase();
      bVal = bVal.toLowerCase();
    }
    if (aVal < bVal) return sortDirection === 'asc' ? -1 : 1;
    if (aVal > bVal) return sortDirection === 'asc' ? 1 : -1;
    return 0;
  });

  if (loading) {
    return (
      <div className="nc-withdrawals-container">
        <WithdrawalShimmer />
      </div>
    );
  }

  if (error) {
    return (
      <div className="nc-withdrawals-container">
        <WithdrawalErrorState onRetry={() => { setError(false); setLoading(true); setTimeout(() => setLoading(false), 500); }} />
      </div>
    );
  }

  return (
    <div className="nc-withdrawals-container">
      {/* Header */}
      <div className="nc-page-header">
        <div>
          <h1 className="nc-header-title">Withdrawals</h1>
          <p className="nc-header-subtitle">Monitor, review and manage all NobleCards withdrawal requests.</p>
        </div>
        <div className="nc-header-actions">
          <button className={`nc-btn ${isRefreshing ? 'nc-spinning' : ''}`} onClick={handleRefresh}>
            <i className='bx bx-refresh'></i> Refresh
          </button>
          <button className="nc-btn nc-btn-primary" onClick={handleExportCSV}>
            <i className='bx bx-download'></i> Export CSV
          </button>
        </div>
      </div>

      {/* Summary Cards */}
      <WithdrawalStats 
        data={withdrawals}
        currentStatusFilter={filters.status}
        onSelectStatusFilter={(status) => handleFilterChange('status', status)}
      />

      {/* Analytics Charts */}
      <WithdrawalCharts data={withdrawals} />

      {/* Search & Multi-Filters */}
      <WithdrawalFilters 
        filters={filters}
        onFilterChange={handleFilterChange}
        onResetFilters={handleResetFilters}
      />

      {/* Table / Empty State */}
      {filteredData.length === 0 ? (
        <div className="nc-table-card">
          <WithdrawalEmptyState onReset={handleResetFilters} />
        </div>
      ) : (
        <WithdrawalTable 
          data={filteredData}
          sortField={sortField}
          sortDirection={sortDirection}
          onSort={handleSort}
          onSelectWithdrawal={(w) => setSelectedWithdrawal(w)}
          onOpenActionModal={(w, type) => setActionModal({ withdrawal: w, type })}
          currentPage={currentPage}
          pageSize={pageSize}
          onPageChange={(page) => setCurrentPage(page)}
          onPageSizeChange={(size) => { setPageSize(size); setCurrentPage(1); }}
        />
      )}

      {/* Details Side Modal Drawer */}
      <WithdrawalDetails 
        withdrawal={selectedWithdrawal}
        onClose={() => setSelectedWithdrawal(null)}
        onViewUser={handleViewUser}
      />

      {/* Action Modal (Reject/Retry Confirmation) */}
      <WithdrawalActions 
        actionData={actionModal}
        onClose={() => setActionModal(null)}
        onConfirm={handleConfirmAction}
      />
    </div>
  );
};

export default Withdrawals;