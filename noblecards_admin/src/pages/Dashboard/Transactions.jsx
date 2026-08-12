import React, { useState, useMemo } from 'react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, BarChart, Bar } from 'recharts';
import TransactionStats from '../../components/transactions/TransactionStats';
import TransactionFilters from '../../components/transactions/TransactionFilters';
import TransactionTable from '../../components/transactions/TransactionTable';
import TransactionDetailModal from '../../components/transactions/TransactionDetailModal';
import RefundModal from '../../components/transactions/RefundModal';
import { initialTransactions, summaryMetrics, volumeChartData, typeDistributionData, exportTransactionsToCSV } from '../../data/transactionData';
import '../../styles/transactions.css';

const Transactions = () => {
  const [transactions, setTransactions] = useState(initialTransactions);
  const [searchQuery, setSearchQuery] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [selectedTxForDetail, setSelectedTxForDetail] = useState(null);
  const [selectedTxForRefund, setSelectedTxForRefund] = useState(null);

  // Pagination state
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  // Sort state
  const [sortField, setSortField] = useState('date');
  const [sortOrder, setSortOrder] = useState('desc');

  // Filter state
  const [filters, setFilters] = useState({
    status: 'All',
    type: 'All',
    category: 'All',
    currency: 'All',
    paymentMethod: 'All',
    dateRange: 'All',
    minAmount: '',
    maxAmount: '',
    customFrom: '',
    customTo: ''
  });

  const handleFilterChange = (field, value) => {
    setFilters(prev => ({ ...prev, [field]: value }));
    setCurrentPage(1);
  };

  const handleResetFilters = () => {
    setFilters({
      status: 'All',
      type: 'All',
      category: 'All',
      currency: 'All',
      paymentMethod: 'All',
      dateRange: 'All',
      minAmount: '',
      maxAmount: '',
      customFrom: '',
      customTo: ''
    });
    setSearchQuery('');
    setCurrentPage(1);
  };

  const handleRefresh = () => {
    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
    }, 600);
  };

  const handleSort = (field) => {
    if (sortField === field) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    } else {
      setSortField(field);
      setSortOrder('desc');
    }
  };

  // Filter & Search Execution
  const filteredTransactions = useMemo(() => {
    return transactions.filter(tx => {
      // Search
      if (searchQuery.trim()) {
        const q = searchQuery.toLowerCase();
        const matchesSearch = 
          tx.id.toLowerCase().includes(q) ||
          tx.userId.toLowerCase().includes(q) ||
          tx.userName.toLowerCase().includes(q) ||
          tx.userEmail.toLowerCase().includes(q) ||
          tx.paymentReference.toLowerCase().includes(q);
        if (!matchesSearch) return false;
      }

      // Dropdowns
      if (filters.status !== 'All' && tx.status !== filters.status) return false;
      if (filters.type !== 'All' && tx.type !== filters.type) return false;
      if (filters.category !== 'All' && tx.category !== filters.category) return false;
      if (filters.currency !== 'All' && tx.currency !== filters.currency) return false;
      if (filters.paymentMethod !== 'All' && tx.paymentMethod !== filters.paymentMethod) return false;

      // Min/Max
      if (filters.minAmount && tx.usdValue < parseFloat(filters.minAmount)) return false;
      if (filters.maxAmount && tx.usdValue > parseFloat(filters.maxAmount)) return false;

      return true;
    });
  }, [transactions, searchQuery, filters]);

  // Sort Execution
  const sortedTransactions = useMemo(() => {
    return [...filteredTransactions].sort((a, b) => {
      let aVal = a[sortField];
      let bVal = b[sortField];

      if (typeof aVal === 'string') {
        aVal = aVal.toLowerCase();
        bVal = bVal.toLowerCase();
      }

      if (aVal < bVal) return sortOrder === 'asc' ? -1 : 1;
      if (aVal > bVal) return sortOrder === 'asc' ? 1 : -1;
      return 0;
    });
  }, [filteredTransactions, sortField, sortOrder]);

  // Paginated Results
  const paginatedTransactions = useMemo(() => {
    const start = (currentPage - 1) * pageSize;
    return sortedTransactions.slice(start, start + pageSize);
  }, [sortedTransactions, currentPage, pageSize]);

  const totalPages = Math.ceil(sortedTransactions.length / pageSize) || 1;

  const handleNotesUpdate = (txId, newNotes) => {
    setTransactions(prev => prev.map(t => t.id === txId ? { ...t, internalNotes: newNotes } : t));
  };

  const handleConfirmRefund = (txId, refundDetails) => {
    setTransactions(prev => prev.map(t => {
      if (t.id === txId) {
        return {
          ...t,
          status: 'Refunded',
          internalNotes: `${t.internalNotes}\nRefund Issued (${refundDetails.reason}): ${refundDetails.customNotes}`
        };
      }
      return t;
    }));
  };

  return (
    <div className="tx-page-container">
      {/* Top Page Header */}
      <div className="tx-page-header">
        <div>
          <h1 className="tx-page-title">Transactions</h1>
          <p className="tx-page-subtitle">Monitor, review and manage all NobleCards financial transactions.</p>
        </div>
        <div className="tx-header-actions">
          <button className="gc-btn gc-btn-secondary" onClick={handleRefresh} disabled={isLoading}>
            <i className={`bx bx-refresh ${isLoading ? 'bx-spin' : ''}`}></i> Refresh
          </button>
          <button className="gc-btn gc-btn-primary" onClick={() => exportTransactionsToCSV(filteredTransactions)}>
            <i className="bx bx-export"></i> Export CSV
          </button>
        </div>
      </div>

      {/* KPI Stats */}
      <TransactionStats 
        metrics={summaryMetrics} 
        activeStatusFilter={filters.status}
        onSelectStatus={(status) => handleFilterChange('status', status)}
      />

      {/* Analytics Visualizations */}
      <div className="tx-charts-grid">
        <div className="tx-chart-card">
          <h3>Transaction Volume Trend</h3>
          <div style={{ width: '100%', height: 220 }}>
            <ResponsiveContainer>
              <AreaChart data={volumeChartData}>
                <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
                <XAxis dataKey="label" stroke="var(--secondary-text)" fontSize={12} />
                <YAxis stroke="var(--secondary-text)" fontSize={12} />
                <Tooltip contentStyle={{ background: 'var(--card)', borderColor: 'var(--border)', color: 'var(--primary-text)' }} />
                <Area type="monotone" dataKey="volume" stroke="var(--primary-green)" fill="var(--primary-green)" fillOpacity={0.15} />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="tx-chart-card">
          <h3>Volume by Category</h3>
          <div style={{ width: '100%', height: 220 }}>
            <ResponsiveContainer>
              <BarChart data={typeDistributionData}>
                <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
                <XAxis dataKey="name" stroke="var(--secondary-text)" fontSize={11} />
                <YAxis stroke="var(--secondary-text)" fontSize={12} />
                <Tooltip contentStyle={{ background: 'var(--card)', borderColor: 'var(--border)', color: 'var(--primary-text)' }} />
                <Bar dataKey="value" fill="var(--blue)" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>

      {/* Filter Toolbar */}
      <TransactionFilters 
        filters={filters}
        onFilterChange={handleFilterChange}
        onResetFilters={handleResetFilters}
        searchQuery={searchQuery}
        onSearchChange={setSearchQuery}
      />

      {/* Main Table or Shimmer State */}
      {isLoading ? (
        <div className="tx-shimmer-container">
          <div className="tx-shimmer-row"></div>
          <div className="tx-shimmer-row"></div>
          <div className="tx-shimmer-row"></div>
        </div>
      ) : sortedTransactions.length === 0 ? (
        <div className="tx-empty-state">
          <i className="bx bx-receipt tx-empty-icon"></i>
          <h3>No transactions found</h3>
          <p>No transaction records match your active search or filter criteria.</p>
          <button className="gc-btn gc-btn-secondary" onClick={handleResetFilters}>Clear Filters</button>
        </div>
      ) : (
        <>
          <TransactionTable 
            transactions={paginatedTransactions}
            onViewDetails={(tx) => setSelectedTxForDetail(tx)}
            onInitiateRefund={(tx) => setSelectedTxForRefund(tx)}
            sortField={sortField}
            sortOrder={sortOrder}
            onSort={handleSort}
          />

          {/* Pagination */}
          <div className="tx-pagination-container">
            <div className="tx-pagination-info">
              Showing {((currentPage - 1) * pageSize) + 1} to {Math.min(currentPage * pageSize, sortedTransactions.length)} of {sortedTransactions.length} transactions
            </div>
            <div className="tx-pagination-controls">
              <select value={pageSize} onChange={(e) => { setPageSize(Number(e.target.value)); setCurrentPage(1); }}>
                <option value={10}>10 per page</option>
                <option value={25}>25 per page</option>
                <option value={50}>50 per page</option>
              </select>
              <button 
                className="gc-btn gc-btn-secondary" 
                disabled={currentPage === 1}
                onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
              >
                Previous
              </button>
              <span style={{ fontSize: '13px', alignSelf: 'center' }}>Page {currentPage} of {totalPages}</span>
              <button 
                className="gc-btn gc-btn-secondary" 
                disabled={currentPage >= totalPages}
                onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
              >
                Next
              </button>
            </div>
          </div>
        </>
      )}

      {/* Modals & Drawers */}
      <TransactionDetailModal 
        isOpen={!!selectedTxForDetail}
        transaction={selectedTxForDetail}
        onClose={() => setSelectedTxForDetail(null)}
        onUpdateNotes={handleNotesUpdate}
      />

      <RefundModal 
        isOpen={!!selectedTxForRefund}
        transaction={selectedTxForRefund}
        onClose={() => setSelectedTxForRefund(null)}
        onConfirmRefund={handleConfirmRefund}
      />
    </div>
  );
};

export default Transactions;