import React, { useState, useEffect } from 'react';
import { referralService } from '../../services/referralService';
import ReferralStats from '../../components/referrals/ReferralStats';
import ReferralCharts from '../../components/referrals/ReferralCharts';
import ReferralFilters from '../../components/referrals/ReferralFilters';
import ReferralTable from '../../components/referrals/ReferralTable';
import ReferralDetailsDrawer from '../../components/referrals/ReferralDetailsDrawer';
import TopReferrers from '../../components/referrals/TopReferrers';
import ReferralSettings from '../../components/referrals/ReferralSettings';
import CommissionRateModal from '../../components/referrals/CommissionRateModal';
import '../../styles/referrals.css';

const Referrals = () => {
  // Data States
  const [loading, setLoading] = useState(true);
  const [referrals, setReferrals] = useState([]);
  const [summary, setSummary] = useState(null);
  const [pagination, setPagination] = useState({ currentPage: 1, totalPages: 1, totalItems: 0, limit: 10 });
  const [settings, setSettings] = useState(null);
  const [auditLogs, setAuditLogs] = useState([]);
  const [topReferrers, setTopReferrers] = useState([]);

  // Active UI States
  const [selectedReferral, setSelectedReferral] = useState(null);
  const [isRateModalOpen, setIsRateModalOpen] = useState(false);
  const [notification, setNotification] = useState(null);

  // Filter States
  const [search, setSearch] = useState('');
  const [status, setStatus] = useState('All');
  const [country, setCountry] = useState('All');
  const [rewardStatus, setRewardStatus] = useState('All');
  const [dateRange, setDateRange] = useState('All Time');
  const [customStart, setCustomStart] = useState('');
  const [customEnd, setCustomEnd] = useState('');
  const [currentPage, setCurrentPage] = useState(1);

  useEffect(() => {
    fetchSettings();
  }, []);

  useEffect(() => {
    fetchReferrals();
  }, [search, status, country, rewardStatus, dateRange, customStart, customEnd, currentPage]);

  const fetchSettings = async () => {
    const res = await referralService.getSettings();
    setSettings(res.settings);
    setAuditLogs(res.auditLogs);
    setTopReferrers(res.topReferrers);
  };

  const fetchReferrals = async () => {
    setLoading(true);
    const res = await referralService.getReferrals({
      search, status, country, rewardStatus, dateRange, customStart, customEnd, page: currentPage, limit: 10
    });
    setReferrals(res.data);
    setSummary(res.summary);
    setPagination(res.pagination);
    setLoading(false);
  };

  const showToast = (msg, type = 'success') => {
    setNotification({ msg, type });
    setTimeout(() => setNotification(null), 4000);
  };

  const handleClearFilters = () => {
    setSearch('');
    setStatus('All');
    setCountry('All');
    setRewardStatus('All');
    setDateRange('All Time');
    setCustomStart('');
    setCustomEnd('');
    setCurrentPage(1);
  };

  const handleSaveCommissionRate = async (newRate, reason) => {
    const res = await referralService.updateCommissionRate(newRate, reason, "LoggedAdmin");
    if (res.success) {
      setSettings(res.settings);
      setAuditLogs(res.auditLogs);
      setIsRateModalOpen(false);
      showToast(`Referral commission updated successfully to ${newRate}%`);
      fetchReferrals();
    }
  };

  const handleToggleProgramStatus = async (activeState) => {
    const res = await referralService.toggleProgramStatus(activeState);
    if (res.success) {
      setSettings(prev => ({ ...prev, programActive: activeState }));
      showToast(activeState ? "Referral program activated." : "Referral program paused.");
    }
  };

  const handleExport = () => {
    referralService.exportCSV(referrals);
    showToast("CSV report generated successfully.");
  };

  return (
    <div className="referrals-container">
      {/* Toast Notification */}
      {notification && (
        <div style={{
          position: 'fixed', top: '20px', right: '20px', zIndex: 1200,
          background: notification.type === 'success' ? '#22c55e' : '#ef4444',
          color: '#fff', padding: '12px 20px', borderRadius: '8px', boxShadow: '0 4px 12px rgba(0,0,0,0.15)',
          fontWeight: '600', fontSize: '13px', display: 'flex', alignItems: 'center', gap: '8px'
        }}>
          <i className='bx bx-check-circle' style={{ fontSize: '18px' }}></i>
          {notification.msg}
        </div>
      )}

      {/* Header */}
      <div className="referrals-header">
        <div>
          <h1>Referral Program</h1>
          <p>Monitor, configure, and review referral activity, commissions, and fraud security.</p>
        </div>
        <div className="referrals-header-actions">
          <button className="ref-btn ref-btn-outline" onClick={fetchReferrals}>
            <i className={`bx bx-refresh ${loading ? 'bx-spin' : ''}`}></i> Refresh
          </button>
          <button className="ref-btn ref-btn-primary" onClick={handleExport}>
            <i className='bx bx-export'></i> Export CSV
          </button>
        </div>
      </div>

      {/* Statistics Cards */}
      <ReferralStats summary={summary} />

      {/* Analytics Charts */}
      <ReferralCharts />

      {/* Filters Bar */}
      <ReferralFilters 
        search={search} setSearch={setSearch}
        status={status} setStatus={setStatus}
        country={country} setCountry={setCountry}
        rewardStatus={rewardStatus} setRewardStatus={setRewardStatus}
        dateRange={dateRange} setDateRange={setDateRange}
        customStart={customStart} setCustomStart={setCustomStart}
        customEnd={customEnd} setCustomEnd={setCustomEnd}
        onClear={handleClearFilters}
      />

      {/* Main Referrals Table */}
      <div className="ref-table-card">
        {loading ? (
          <div style={{ padding: '24px' }}>
            {[...Array(5)].map((_, i) => (
              <div key={i} className="shimmer-box" style={{ height: '40px', marginBottom: '12px' }} />
            ))}
          </div>
        ) : (
          <ReferralTable data={referrals} onSelectRow={setSelectedReferral} />
        )}

        {/* Pagination Footer */}
        {!loading && pagination.totalItems > 0 && (
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '16px 20px', borderTop: '1px solid var(--border-color)', fontSize: '13px' }}>
            <span style={{ color: 'var(--text-secondary)' }}>
              Showing {((pagination.currentPage - 1) * pagination.limit) + 1} to {Math.min(pagination.currentPage * pagination.limit, pagination.totalItems)} of {pagination.totalItems} entries
            </span>
            <div style={{ display: 'flex', gap: '8px' }}>
              <button 
                className="ref-btn ref-btn-outline" 
                style={{ padding: '6px 12px' }}
                disabled={pagination.currentPage === 1}
                onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
              >
                Previous
              </button>
              <button 
                className="ref-btn ref-btn-outline" 
                style={{ padding: '6px 12px' }}
                disabled={pagination.currentPage === pagination.totalPages}
                onClick={() => setCurrentPage(prev => Math.min(prev + 1, pagination.totalPages))}
              >
                Next
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Settings & Leaderboard Grid */}
      <div className="ref-bottom-grid">
        {settings && (
          <ReferralSettings 
            settings={settings} 
            auditLogs={auditLogs}
            onOpenRateModal={() => setIsRateModalOpen(true)}
            onTogglePause={handleToggleProgramStatus}
          />
        )}
        <TopReferrers referrers={topReferrers} />
      </div>

      {/* Detail Drawer */}
      {selectedReferral && (
        <ReferralDetailsDrawer 
          referral={selectedReferral} 
          onClose={() => setSelectedReferral(null)} 
        />
      )}

      {/* Rate Change Confirmation Modal */}
      {isRateModalOpen && settings && (
        <CommissionRateModal 
          currentRate={settings.commissionRate}
          onClose={() => setIsRateModalOpen(false)}
          onSave={handleSaveCommissionRate}
        />
      )}
    </div>
  );
};

export default Referrals;