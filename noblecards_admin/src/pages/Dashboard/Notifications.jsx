import React, { useState, useEffect } from 'react';
import '../../styles/notifications.css'; // fixed path to styles folder
import { mockNotifications } from '../../data/notificationsData';
import CreateNotification from '../../components/notifications/CreateNotification';
import AutomatedSettings from '../../components/notifications/AutomatedSettings';

export default function Notifications() {
  const [activeTab, setActiveTab] = useState('overview');
  const [isLoading, setIsLoading] = useState(true);
  
  // Table State
  const [search, setSearch] = useState('');
  const [filterType, setFilterType] = useState('All');
  const [notifications, setNotifications] = useState([]);

  // NEW: State for the viewing modal
  const [viewingNotification, setViewingNotification] = useState(null);

  // Simulate initial load
  useEffect(() => {
    setTimeout(() => {
      setNotifications(mockNotifications);
      setIsLoading(false);
    }, 800);
  }, []);

  // Filtering Logic
  const filteredData = notifications.filter(n => {
    const matchesSearch = n.title.toLowerCase().includes(search.toLowerCase()) || n.id.toLowerCase().includes(search.toLowerCase());
    const matchesType = filterType === 'All' ? true : n.type === filterType;
    return matchesSearch && matchesType;
  });

  const getStatusBadge = (status) => {
    switch(status) {
      case 'Delivered': return 'success';
      case 'Scheduled': return 'warning';
      case 'Sent': return 'info';
      default: return 'neutral';
    }
  };

  return (
    <div className="nc-notifications-container">
      {/* Header */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div>
          <h1 style={{ margin: '0 0 0.25rem', fontSize: '1.75rem' }}>Notification Center</h1>
          <p style={{ margin: 0, color: 'var(--text-secondary)' }}>Manage system alerts, broadcasts, and automated campaigns.</p>
        </div>
        <button className="nc-btn nc-btn-primary" onClick={() => setActiveTab('create')}>
          <i className='bx bx-plus'></i> Send Broadcast
        </button>
      </div>

      {/* Tabs */}
      <div className="nc-tabs">
        <button className={`nc-tab ${activeTab === 'overview' ? 'active' : ''}`} onClick={() => setActiveTab('overview')}>
          <i className='bx bx-bar-chart-alt-2' style={{ marginRight: '8px' }}></i> Overview & History
        </button>
        <button className={`nc-tab ${activeTab === 'create' ? 'active' : ''}`} onClick={() => setActiveTab('create')}>
          <i className='bx bx-broadcast' style={{ marginRight: '8px' }}></i> Manual Broadcast
        </button>
        <button className={`nc-tab ${activeTab === 'automated' ? 'active' : ''}`} onClick={() => setActiveTab('automated')}>
          <i className='bx bx-bot' style={{ marginRight: '8px' }}></i> Automated Settings
        </button>
      </div>

      {/* Content Rendering based on Tab */}
      {activeTab === 'overview' && (
        <>
          {/* STATS GRID */}
          <div className="nc-stats-grid">
            <div className="nc-stat-card">
              <div className="nc-stat-icon" style={{ background: 'rgba(37, 99, 235, 0.1)', color: 'var(--blue)' }}>
                <i className='bx bx-paper-plane'></i>
              </div>
              <div>
                <p style={{ margin: '0 0 4px', color: 'var(--text-secondary)', fontSize: '0.875rem' }}>Total Sent (30d)</p>
                <h3 style={{ margin: 0, fontSize: '1.5rem' }}>142,890</h3>
              </div>
            </div>
            <div className="nc-stat-card">
              <div className="nc-stat-icon" style={{ background: 'rgba(34, 197, 94, 0.1)', color: 'var(--success-color)' }}>
                <i className='bx bx-check-double'></i>
              </div>
              <div>
                <p style={{ margin: '0 0 4px', color: 'var(--text-secondary)', fontSize: '0.875rem' }}>Delivery Rate</p>
                <h3 style={{ margin: 0, fontSize: '1.5rem' }}>98.4%</h3>
              </div>
            </div>
            <div className="nc-stat-card">
              <div className="nc-stat-icon" style={{ background: 'rgba(245, 158, 11, 0.1)', color: 'var(--warning-color)' }}>
                <i className='bx bx-calendar-event'></i>
              </div>
              <div>
                <p style={{ margin: '0 0 4px', color: 'var(--text-secondary)', fontSize: '0.875rem' }}>Active Campaigns</p>
                <h3 style={{ margin: 0, fontSize: '1.5rem' }}>4</h3>
              </div>
            </div>
            <div className="nc-stat-card">
              <div className="nc-stat-icon" style={{ background: 'rgba(239, 68, 68, 0.1)', color: 'var(--danger-color)' }}>
                <i className='bx bx-error'></i>
              </div>
              <div>
                <p style={{ margin: '0 0 4px', color: 'var(--text-secondary)', fontSize: '0.875rem' }}>Failed Deliveries</p>
                <h3 style={{ margin: 0, fontSize: '1.5rem' }}>1,204</h3>
              </div>
            </div>
          </div>

          {/* TABLE SECTION */}
          <div className="nc-card fade-in">
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', flexWrap: 'wrap', gap: '1rem' }}>
              <h3 style={{ margin: 0 }}>Notification History</h3>
              <div style={{ display: 'flex', gap: '1rem' }}>
                <div style={{ position: 'relative' }}>
                  <i className='bx bx-search' style={{ position: 'absolute', left: '12px', top: '50%', transform: 'translateY(-50%)', color: 'var(--text-secondary)' }}></i>
                  <input type="text" className="nc-input" placeholder="Search by ID or Title..." style={{ margin: 0, paddingLeft: '35px', width: '250px' }} value={search} onChange={e => setSearch(e.target.value)} />
                </div>
                <select className="nc-select" style={{ margin: 0, width: '150px' }} value={filterType} onChange={e => setFilterType(e.target.value)}>
                  <option value="All">All Types</option>
                  <option>Announcement</option>
                  <option>Transaction</option>
                  <option>Marketing</option>
                  <option>System</option>
                </select>
                <button className="nc-btn nc-btn-outline"><i className='bx bx-export'></i> Export</button>
              </div>
            </div>

            <div style={{ overflowX: 'auto' }}>
              <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
                <thead>
                  <tr style={{ borderBottom: '1px solid var(--border-color)', color: 'var(--text-secondary)', fontSize: '0.875rem' }}>
                    <th style={{ padding: '1rem' }}>ID</th>
                    <th style={{ padding: '1rem' }}>Title & Type</th>
                    <th style={{ padding: '1rem' }}>Audience</th>
                    <th style={{ padding: '1rem' }}>Status</th>
                    <th style={{ padding: '1rem' }}>Date</th>
                    <th style={{ padding: '1rem' }}>Action</th>
                  </tr>
                </thead>
                <tbody>
                  {isLoading ? (
                    <tr>
                      <td colSpan="6" style={{ textAlign: 'center', padding: '2rem' }}>
                        <i className='bx bx-loader-alt bx-spin' style={{ fontSize: '2rem', color: 'var(--primary-color)' }}></i>
                      </td>
                    </tr>
                  ) : filteredData.length === 0 ? (
                    <tr>
                      <td colSpan="6" style={{ textAlign: 'center', padding: '3rem', color: 'var(--text-secondary)' }}>
                        <i className='bx bx-folder-open' style={{ fontSize: '3rem', marginBottom: '1rem', display: 'block' }}></i>
                        No notifications found matching your criteria.
                      </td>
                    </tr>
                  ) : (
                    filteredData.map(row => (
                      <tr key={row.id} style={{ borderBottom: '1px solid var(--border-color)', transition: 'background 0.2s' }} onMouseOver={e => e.currentTarget.style.background = 'var(--bg-hover)'} onMouseOut={e => e.currentTarget.style.background = 'transparent'}>
                        <td style={{ padding: '1rem', fontWeight: 600 }}>{row.id}</td>
                        <td style={{ padding: '1rem' }}>
                          <div style={{ fontWeight: 500, marginBottom: '4px' }}>{row.title}</div>
                          <div style={{ fontSize: '0.75rem', color: 'var(--text-secondary)' }}>{row.type}</div>
                        </td>
                        <td style={{ padding: '1rem', fontSize: '0.875rem' }}>{row.audience}</td>
                        <td style={{ padding: '1rem' }}>
                          <span className={`nc-badge ${getStatusBadge(row.status)}`}>{row.status}</span>
                        </td>
                        <td style={{ padding: '1rem', fontSize: '0.875rem', color: 'var(--text-secondary)' }}>
                          {row.sentDate ? new Date(row.sentDate).toLocaleDateString() : '—'}
                        </td>
                        <td style={{ padding: '1rem' }}>
                          <button 
                            className="nc-btn nc-btn-outline" 
                            style={{ padding: '0.4rem 0.8rem', fontSize: '0.875rem' }}
                            onClick={() => setViewingNotification(row)}
                          >
                            View
                          </button>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>

            {/* Pagination Mock */}
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: '1.5rem', color: 'var(--text-secondary)', fontSize: '0.875rem' }}>
              <span>Showing 1 to {filteredData.length} of {filteredData.length} entries</span>
              <div style={{ display: 'flex', gap: '0.5rem' }}>
                <button className="nc-btn nc-btn-outline" style={{ padding: '0.25rem 0.75rem' }} disabled>Prev</button>
                <button className="nc-btn nc-btn-primary" style={{ padding: '0.25rem 0.75rem' }}>1</button>
                <button className="nc-btn nc-btn-outline" style={{ padding: '0.25rem 0.75rem' }} disabled>Next</button>
              </div>
            </div>
          </div>
        </>
      )}

      {activeTab === 'create' && (
        <CreateNotification onSuccess={() => setActiveTab('overview')} />
      )}

      {activeTab === 'automated' && (
        <AutomatedSettings />
      )}

      {/* NEW: Notification Details Modal */}
      {viewingNotification && (
        <div className="nc-modal-overlay" onClick={() => setViewingNotification(null)}>
          <div className="nc-modal-content" onClick={e => e.stopPropagation()}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
              <h2 style={{ margin: 0, fontSize: '1.25rem' }}>Notification Details</h2>
              <button onClick={() => setViewingNotification(null)} style={{ background: 'transparent', border: 'none', cursor: 'pointer' }}>
                <i className='bx bx-x' style={{ fontSize: '1.5rem', color: 'var(--text-secondary)' }}></i>
              </button>
            </div>

            <div style={{ background: 'var(--bg-primary)', padding: '1rem', borderRadius: '8px', border: '1px solid var(--border-color)', marginBottom: '1.5rem' }}>
              <p style={{ margin: '0 0 0.75rem', fontSize: '0.9rem' }}>
                <strong style={{ color: 'var(--text-secondary)' }}>ID:</strong> {viewingNotification.id}
              </p>
              <p style={{ margin: '0 0 0.75rem', fontSize: '0.9rem' }}>
                <strong style={{ color: 'var(--text-secondary)' }}>Title:</strong> {viewingNotification.title}
              </p>
              <p style={{ margin: '0 0 0.75rem', fontSize: '0.9rem' }}>
                <strong style={{ color: 'var(--text-secondary)' }}>Type:</strong> {viewingNotification.type}
              </p>
              <p style={{ margin: '0 0 0.75rem', fontSize: '0.9rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                <strong style={{ color: 'var(--text-secondary)' }}>Status:</strong> 
                <span className={`nc-badge ${getStatusBadge(viewingNotification.status)}`}>{viewingNotification.status}</span>
              </p>
              <p style={{ margin: '0 0 0.75rem', fontSize: '0.9rem' }}>
                <strong style={{ color: 'var(--text-secondary)' }}>Audience:</strong> {viewingNotification.audience}
              </p>
              <p style={{ margin: '0 0 0.75rem', fontSize: '0.9rem' }}>
                <strong style={{ color: 'var(--text-secondary)' }}>Channels:</strong> {viewingNotification.channels?.join(', ')}
              </p>
              <p style={{ margin: '0', fontSize: '0.9rem' }}>
                <strong style={{ color: 'var(--text-secondary)' }}>Date:</strong> {viewingNotification.sentDate ? new Date(viewingNotification.sentDate).toLocaleString() : 'Not Sent Yet'}
              </p>
            </div>

            <div style={{ display: 'flex', gap: '1rem', justifyContent: 'flex-end' }}>
              <button className="nc-btn nc-btn-outline" onClick={() => setViewingNotification(null)}>Close</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}