// ==========================================
// UPDATE EXISTING FILE
// File: src/pages/Dashboard/SecurityLogs.jsx
// Purpose: Main Page connecting Security Stats, Alerts, Multi-Filters, Audit Table, Pagination, Details Modal & CSV Export
// ==========================================

import React, { useState, useEffect, useCallback } from "react";
import { SecurityLogService } from "../../services/securityLogService";
import { SecurityStats } from "../../components/security/SecurityStats";
import { SecurityAlerts } from "../../components/security/SecurityAlerts";
import { SecurityFilters } from "../../components/security/SecurityFilters";
import { SecurityLogTable } from "../../components/security/SecurityLogTable";
import { SecurityLogDetailsModal } from "../../components/security/SecurityLogDetailsModal";
import { SecuritySkeleton } from "../../components/security/SecuritySkeleton";

const DEFAULT_FILTERS = {
  search: "",
  eventType: "ALL",
  status: "ALL",
  risk: "ALL",
  actor: "ALL",
  country: "ALL",
  device: "ALL",
  dateRange: "ALL",
  startDate: "",
  endDate: ""
};

export default function SecurityLogs() {
  const [stats, setStats] = useState(null);
  const [alerts, setAlerts] = useState([]);
  const [logs, setLogs] = useState([]);
  const [pagination, setPagination] = useState({ totalRecords: 0, totalPages: 1, currentPage: 1, pageSize: 10 });
  const [filters, setFilters] = useState(DEFAULT_FILTERS);

  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState(null);

  const [selectedLog, setSelectedLog] = useState(null);
  const [isLive] = useState(true);

  // Fetch Stats & Alerts on Mount
  const loadInitialData = async () => {
    try {
      const [statsData, alertsData] = await Promise.all([
        SecurityLogService.getStatistics(),
        SecurityLogService.getAlerts()
      ]);
      setStats(statsData);
      setAlerts(alertsData);
    } catch (err) {
      console.error("Failed loading security metadata", err);
    }
  };

  // Fetch Audit Logs with current filters & pagination
  const fetchLogs = useCallback(async (page = 1) => {
    setLoading(true);
    setError(null);
    try {
      const response = await SecurityLogService.getLogs({
        ...filters,
        page,
        pageSize: pagination.pageSize
      });
      setLogs(response.data);
      setPagination(response.pagination);
    } catch (err) {
      setError("Unable to load security audit records. Please try again.");
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, [filters, pagination.pageSize]);

  useEffect(() => {
    loadInitialData();
  }, []);

  useEffect(() => {
    fetchLogs(1);
  }, [filters, pagination.pageSize, fetchLogs]);

  // Handle Filter Changes
  const handleFilterChange = (key, value) => {
    setFilters((prev) => ({ ...prev, [key]: value }));
  };

  // Handle Manual Refresh
  const handleRefresh = () => {
    setRefreshing(true);
    loadInitialData();
    fetchLogs(pagination.currentPage);
  };

  // Reset Filters
  const handleResetFilters = () => {
    setFilters(DEFAULT_FILTERS);
  };

  // Handle Modal Inspection
  const handleInspectLogById = (logId) => {
    const found = logs.find((l) => l.id === logId);
    if (found) {
      setSelectedLog(found);
    } else {
      // Fallback search in entire dataset if not on current page
      SecurityLogService.getLogs({ search: logId }).then((res) => {
        if (res.data.length > 0) setSelectedLog(res.data[0]);
      });
    }
  };

  // CSV Export Trigger
  const handleExportCSV = () => {
    SecurityLogService.exportToCSV(logs);
  };

  return (
    <div className="security-logs-page">
      {/* Page Header */}
      <div className="security-header">
        <div className="security-header-title">
          <div className="title-with-icon">
            <i className="bx bx-shield-quarter text-primary"></i>
            <h2>Security Audit Logs</h2>
          </div>
          <p>NobleCards enterprise security operations center and immutable audit trail.</p>
        </div>

        <div className="security-header-actions">
          <button className="export-csv-btn" onClick={handleExportCSV} disabled={!logs.length}>
            <i className="bx bx-export"></i> Export CSV
          </button>
        </div>
      </div>

      {/* Top Security Summary Stat Cards */}
      <SecurityStats stats={stats} loading={loading} />

      {/* Security Alerts Section */}
      <SecurityAlerts alerts={alerts} onViewDetails={handleInspectLogById} />

      {/* Filter Toolbar */}
      <SecurityFilters
        filters={filters}
        onFilterChange={handleFilterChange}
        onRefresh={handleRefresh}
        onReset={handleResetFilters}
        isRefreshing={refreshing}
        isLive={isLive}
      />

      {/* Main Audit Content Section */}
      {loading && !refreshing ? (
        <SecuritySkeleton />
      ) : error ? (
        <div className="security-error-state">
          <i className="bx bx-error-alt error-icon"></i>
          <h3>Error Loading Audit Logs</h3>
          <p>{error}</p>
          <button className="security-btn secondary" onClick={handleRefresh}>
            Retry Request
          </button>
        </div>
      ) : logs.length === 0 ? (
        <div className="security-empty-state">
          <i className="bx bx-shield-x empty-icon"></i>
          <h3>No Security Events Found</h3>
          <p>No audit records match your current filter criteria.</p>
          <button className="security-btn secondary" onClick={handleResetFilters}>
            Clear Filters
          </button>
        </div>
      ) : (
        <>
          <SecurityLogTable logs={logs} onViewDetails={(log) => setSelectedLog(log)} />

          {/* Pagination Controls */}
          <div className="security-pagination">
            <div className="pagination-info">
              Showing <strong>{logs.length}</strong> of <strong>{pagination.totalRecords}</strong> security events
            </div>

            <div className="pagination-controls">
              <label>Rows per page:</label>
              <select
                value={pagination.pageSize}
                onChange={(e) => setPagination((prev) => ({ ...prev, pageSize: Number(e.target.value) }))}
              >
                <option value={10}>10</option>
                <option value={25}>25</option>
                <option value={50}>50</option>
                <option value={100}>100</option>
              </select>

              <button
                className="page-btn"
                disabled={pagination.currentPage <= 1}
                onClick={() => fetchLogs(pagination.currentPage - 1)}
              >
                <i className="bx bx-chevron-left"></i>
              </button>

              <span className="page-indicator">
                Page {pagination.currentPage} of {pagination.totalPages}
              </span>

              <button
                className="page-btn"
                disabled={pagination.currentPage >= pagination.totalPages}
                onClick={() => fetchLogs(pagination.currentPage + 1)}
              >
                <i className="bx bx-chevron-right"></i>
              </button>
            </div>
          </div>
        </>
      )}

      {/* Event Details Modal */}
      {selectedLog && <SecurityLogDetailsModal log={selectedLog} onClose={() => setSelectedLog(null)} />}

      <style>{`
        .security-logs-page {
          padding: 1.5rem;
          background-color: var(--bg-primary);
          min-height: 100vh;
          color: var(--text-primary);
        }

        .security-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 1.5rem;
          flex-wrap: wrap;
          gap: 1rem;
        }

        .title-with-icon {
          display: flex;
          align-items: center;
          gap: 0.6rem;
        }

        .title-with-icon i {
          font-size: 2rem;
          color: var(--primary-color);
        }

        .security-header-title h2 {
          margin: 0;
          font-size: 1.6rem;
          font-weight: 700;
          color: var(--text-primary);
        }

        .security-header-title p {
          margin: 0.2rem 0 0 0;
          font-size: 0.875rem;
          color: var(--text-secondary);
        }

        .export-csv-btn {
          display: flex;
          align-items: center;
          gap: 0.4rem;
          background-color: var(--primary-color);
          color: #ffffff;
          border: none;
          padding: 0.65rem 1.25rem;
          border-radius: 8px;
          font-weight: 600;
          font-size: 0.875rem;
          cursor: pointer;
          transition: opacity 0.2s ease;
        }

        .export-csv-btn:hover {
          opacity: 0.9;
        }

        .export-csv-btn:disabled {
          opacity: 0.5;
          cursor: not-allowed;
        }

        .security-empty-state, .security-error-state {
          background-color: var(--bg-card);
          border: 1px solid var(--border-color);
          border-radius: 12px;
          padding: 3rem 1.5rem;
          text-align: center;
          display: flex;
          flex-direction: column;
          align-items: center;
          gap: 0.75rem;
        }

        .empty-icon, .error-icon {
          font-size: 3.5rem;
          color: var(--text-secondary);
        }

        .error-icon { color: var(--danger-color); }

        .security-empty-state h3, .security-error-state h3 {
          margin: 0;
          font-size: 1.2rem;
          color: var(--text-primary);
        }

        .security-empty-state p, .security-error-state p {
          margin: 0;
          font-size: 0.875rem;
          color: var(--text-secondary);
        }

        .security-pagination {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-top: 1.25rem;
          padding: 1rem;
          background-color: var(--bg-card);
          border: 1px solid var(--border-color);
          border-radius: 10px;
          flex-wrap: wrap;
          gap: 1rem;
        }

        .pagination-info {
          font-size: 0.85rem;
          color: var(--text-secondary);
        }

        .pagination-controls {
          display: flex;
          align-items: center;
          gap: 0.75rem;
          font-size: 0.85rem;
          color: var(--text-secondary);
        }

        .pagination-controls select {
          padding: 0.3rem 0.5rem;
          background-color: var(--bg-primary);
          border: 1px solid var(--border-color);
          border-radius: 6px;
          color: var(--text-primary);
        }

        .page-btn {
          background-color: var(--bg-primary);
          border: 1px solid var(--border-color);
          color: var(--text-primary);
          width: 32px;
          height: 32px;
          border-radius: 6px;
          display: flex;
          align-items: center;
          justify-content: center;
          cursor: pointer;
        }

        .page-btn:disabled {
          opacity: 0.4;
          cursor: not-allowed;
        }

        .page-indicator {
          font-weight: 600;
          color: var(--text-primary);
        }
      `}</style>
    </div>
  );
}