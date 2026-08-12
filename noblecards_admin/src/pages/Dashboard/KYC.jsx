import React, { useState, useEffect } from 'react';
import { kycData as mockData } from '../../data/kycData';
import KYCStats from '../../components/kyc/KYCStats';
import KYCReviewDrawer from '../../components/kyc/KYCReviewDrawer';
import '../../styles/kyc.css';

const KYC = () => {
  const [data, setData] = useState([]);
  const [filteredData, setFilteredData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedApp, setSelectedApp] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;

  // Filters state
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('All');
  const [levelFilter, setLevelFilter] = useState('All');
  const [riskFilter, setRiskFilter] = useState('All');

  useEffect(() => {
    // Simulate API fetch on mount
    loadData();
  }, []);

  useEffect(() => {
    applyFilters();
  }, [data, searchTerm, statusFilter, levelFilter, riskFilter]);

  const loadData = () => {
    setLoading(true);
    setTimeout(() => {
      setData(mockData);
      setLoading(false);
    }, 800);
  };

  const applyFilters = () => {
    let result = [...data];

    if (searchTerm) {
      const lowerSearch = searchTerm.toLowerCase();
      result = result.filter(item => 
        item.fullName.toLowerCase().includes(lowerSearch) ||
        item.userId.toLowerCase().includes(lowerSearch) ||
        item.email.toLowerCase().includes(lowerSearch)
      );
    }
    
    // Using string matching for 'All' vs actual status
    if (statusFilter !== 'All') {
      if (statusFilter === 'High Risk') {
        result = result.filter(item => item.risk === 'High Risk');
      } else {
        result = result.filter(item => item.status === statusFilter);
      }
    }

    if (levelFilter !== 'All') {
      result = result.filter(item => item.level === levelFilter);
    }

    if (riskFilter !== 'All') {
      result = result.filter(item => item.risk === riskFilter);
    }

    setFilteredData(result);
    setCurrentPage(1); // reset pagination on filter change
  };

  const clearFilters = () => {
    setSearchTerm('');
    setStatusFilter('All');
    setLevelFilter('All');
    setRiskFilter('All');
  };

  const handleExportCSV = () => {
    const headers = ['Full Name', 'User ID', 'Email', 'Country', 'Level', 'Status', 'Risk', 'Provider'];
    const csvRows = [headers.join(',')];

    filteredData.forEach(row => {
      csvRows.push([
        row.fullName, row.userId, row.email, row.country, row.level, row.status, row.risk, row.provider
      ].join(','));
    });

    const blob = new Blob([csvRows.join('\n')], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `noblecards_kyc_export_${new Date().getTime()}.csv`;
    a.click();
  };

  // Mock Actions updating State
  const updateStatus = (id, newStatus) => {
    const updated = data.map(item => {
      if (item.id === id) {
        return { 
          ...item, 
          status: newStatus, 
          timeline: [...item.timeline, { event: `Admin Action: ${newStatus}`, date: new Date().toISOString() }] 
        };
      }
      return item;
    });
    setData(updated);
  };

  // Pagination logic
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentItems = filteredData.slice(indexOfFirstItem, indexOfLastItem);
  const totalPages = Math.ceil(filteredData.length / itemsPerPage);

  const getStatusIcon = (status) => {
    switch(status) {
      case 'Approved': return 'bx-check-circle';
      case 'Rejected': return 'bx-x-circle';
      case 'Pending':
      case 'Processing': return 'bx-loader-circle';
      case 'Expired': return 'bx-time-five';
      default: return 'bx-info-circle';
    }
  };

  return (
    <div className="kyc-container">
      <div className="kyc-header">
        <div>
          <h1>KYC & Verification</h1>
          <p>Review and manage identity verification for NobleCards users.</p>
        </div>
        <div className="kyc-header-actions">
          <button className="btn btn-outline" onClick={loadData}>
            <i className={`bx bx-refresh ${loading ? 'bx-spin' : ''}`}></i> Refresh
          </button>
          <button className="btn btn-primary" onClick={handleExportCSV}>
            <i className='bx bx-export'></i> Export CSV
          </button>
        </div>
      </div>

      {!loading && <KYCStats data={data} onFilterStatus={setStatusFilter} />}

      <div className="kyc-filters">
        <div className="search-wrapper">
          <i className='bx bx-search'></i>
          <input 
            type="text" 
            className="filter-input" 
            placeholder="Search Name, User ID, Email..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        <select className="filter-select" value={statusFilter} onChange={e => setStatusFilter(e.target.value)}>
          <option value="All">All Statuses</option>
          <option value="Pending">Pending</option>
          <option value="Processing">Processing</option>
          <option value="Under Review">Under Review</option>
          <option value="Approved">Approved</option>
          <option value="Rejected">Rejected</option>
          <option value="Needs Resubmission">Needs Resubmission</option>
        </select>
        <select className="filter-select" value={levelFilter} onChange={e => setLevelFilter(e.target.value)}>
          <option value="All">All Levels</option>
          <option value="Level 1">Level 1</option>
          <option value="Level 2">Level 2</option>
          <option value="Level 3">Level 3</option>
        </select>
        <select className="filter-select" value={riskFilter} onChange={e => setRiskFilter(e.target.value)}>
          <option value="All">All Risk</option>
          <option value="Normal">Normal</option>
          <option value="Review">Review</option>
          <option value="High Risk">High Risk</option>
        </select>
        <button className="btn btn-outline" onClick={clearFilters}>
          Clear Filters
        </button>
      </div>

      <div className="kyc-table-wrapper">
        <table className="kyc-table">
          <thead>
            <tr>
              <th>Applicant</th>
              <th>User ID</th>
              <th>Document</th>
              <th>Level</th>
              <th>Status</th>
              <th>Risk</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              [...Array(5)].map((_, i) => (
                <tr key={i}>
                  <td colSpan="7"><div className="shimmer" style={{ height: '40px', width: '100%' }}></div></td>
                </tr>
              ))
            ) : currentItems.length === 0 ? (
              <tr>
                <td colSpan="7" style={{ textAlign: 'center', padding: '40px' }}>
                  <i className='bx bx-folder-open' style={{ fontSize: '48px', color: 'var(--text-secondary)' }}></i>
                  <p style={{ marginTop: '12px' }}>No KYC applications found.</p>
                </td>
              </tr>
            ) : (
              currentItems.map(item => (
                <tr key={item.id}>
                  <td>
                    <div className="user-cell">
                      <div className="avatar">{item.fullName.charAt(0)}</div>
                      <div className="user-info">
                        <h4>{item.fullName}</h4>
                        <span>{item.email}</span>
                      </div>
                    </div>
                  </td>
                  <td><span style={{ fontFamily: 'monospace' }}>{item.userId}</span></td>
                  <td>{item.documentType}</td>
                  <td>{item.level}</td>
                  <td>
                    <span className={`badge badge-${item.status.toLowerCase().replace(' ', '-')}`}>
                      <i className={`bx ${getStatusIcon(item.status)}`}></i> {item.status}
                    </span>
                  </td>
                  <td>
                    <span className={`badge badge-${item.risk === 'Normal' ? 'approved' : 'rejected'}`}>
                      {item.risk}
                    </span>
                  </td>
                  <td>
                    <button className="btn btn-outline" style={{ padding: '6px 12px' }} onClick={() => setSelectedApp(item)}>
                      Review <i className='bx bx-right-arrow-alt'></i>
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Pagination Controls */}
      {!loading && filteredData.length > 0 && (
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <span style={{ fontSize: '14px', color: 'var(--text-secondary)' }}>
            Showing {indexOfFirstItem + 1}–{Math.min(indexOfLastItem, filteredData.length)} of {filteredData.length} applications
          </span>
          <div style={{ display: 'flex', gap: '8px' }}>
            <button className="btn btn-outline" disabled={currentPage === 1} onClick={() => setCurrentPage(prev => prev - 1)}>
              <i className='bx bx-chevron-left'></i> Prev
            </button>
            <button className="btn btn-outline" disabled={currentPage === totalPages} onClick={() => setCurrentPage(prev => prev + 1)}>
              Next <i className='bx bx-chevron-right'></i>
            </button>
          </div>
        </div>
      )}

      {selectedApp && (
        <KYCReviewDrawer 
          application={selectedApp} 
          onClose={() => setSelectedApp(null)} 
          onApprove={(id) => updateStatus(id, 'Approved')}
          onReject={(id) => updateStatus(id, 'Rejected')}
          onResubmit={(id) => updateStatus(id, 'Needs Resubmission')}
        />
      )}
    </div>
  );
};

export default KYC;