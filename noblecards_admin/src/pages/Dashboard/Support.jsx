import React, { useState, useEffect } from 'react';
import '../../styles/support.css';
import { mockTickets } from '../../data/supportData';
import SupportTicketDrawer from '../../components/support/SupportTicketDrawer';

export default function Support() {
  const [activeTab, setActiveTab] = useState('tickets');
  const [tickets, setTickets] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  // Filter States
  const [search, setSearch] = useState('');
  const [filterStatus, setFilterStatus] = useState('All');
  const [filterPriority, setFilterPriority] = useState('All');
  const [filterCategory, setFilterCategory] = useState('All');

  // Pagination
  const [currentPage, setCurrentPage] = useState(1);
  const [perPage, setPerPage] = useState(10);

  // Selected Ticket for Drawer
  const [selectedTicket, setSelectedTicket] = useState(null);

  // Simulate network load
  const loadTickets = () => {
    setIsLoading(true);
    setError(null);
    setTimeout(() => {
      try {
        setTickets(mockTickets);
        setIsLoading(false);
      } catch (err) {
        setError('Failed to load tickets. Please try again.');
        setIsLoading(false);
      }
    }, 800);
  };

  useEffect(() => {
    loadTickets();
  }, []);

  // Handlers
  const handleUpdateTicket = (id, updates) => {
    setTickets(prev => prev.map(t => t.id === id ? { ...t, ...updates } : t));
    if (selectedTicket && selectedTicket.id === id) {
      setSelectedTicket(prev => ({ ...prev, ...updates }));
    }
  };

  const handleExportCSV = () => {
    const headers = ['Ticket ID', 'Subject', 'Category', 'Priority', 'Status', 'Assigned To', 'Created Date'];
    const csvData = filteredData.map(t => [
      t.id, `"${t.subject}"`, t.category, t.priority, t.status, t.assignedTo, new Date(t.createdAt).toLocaleDateString()
    ]);
    
    let csvContent = "data:text/csv;charset=utf-8," + [headers, ...csvData].map(e => e.join(",")).join("\n");
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", `noblecards_support_tickets_${new Date().toISOString().split('T')[0]}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  // Filter Logic
  const filteredData = tickets.filter(t => {
    const s = search.toLowerCase();
    const matchSearch = t.id.toLowerCase().includes(s) || 
                        t.subject.toLowerCase().includes(s) || 
                        t.user.name.toLowerCase().includes(s) || 
                        t.user.email.toLowerCase().includes(s);
    const matchStatus = filterStatus === 'All' ? true : t.status === filterStatus;
    const matchPriority = filterPriority === 'All' ? true : t.priority === filterPriority;
    const matchCategory = filterCategory === 'All' ? true : t.category === filterCategory;

    return matchSearch && matchStatus && matchPriority && matchCategory;
  });

  // Pagination Logic
  const totalPages = Math.ceil(filteredData.length / perPage);
  const paginatedData = filteredData.slice((currentPage - 1) * perPage, currentPage * perPage);

  // Statistics Calculation
  const total = tickets.length;
  const openCount = tickets.filter(t => t.status === 'Open').length;
  const resolvedCount = tickets.filter(t => t.status === 'Resolved').length;
  const urgentCount = tickets.filter(t => t.priority === 'Urgent').length;

  return (
    <div className="nc-support-wrapper fade-in">
      <div className="nc-support-header">
        <div>
          <h1 style={{ margin: '0 0 0.25rem', fontSize: '1.75rem' }}>Messages & Support</h1>
          <p style={{ margin: 0, color: 'var(--text-secondary)' }}>Manage customer inquiries and internal tickets.</p>
        </div>
        <div style={{ display: 'flex', gap: '1rem' }}>
          <button className="nc-btn nc-btn-outline" onClick={loadTickets}>
            <i className={`bx bx-refresh ${isLoading ? 'bx-spin' : ''}`}></i> Refresh
          </button>
          <button className="nc-btn nc-btn-primary" onClick={handleExportCSV}>
            <i className='bx bx-export'></i> Export CSV
          </button>
        </div>
      </div>

      <div className="nc-support-tabs">
        <button className={`nc-support-tab ${activeTab === 'tickets' ? 'active' : ''}`} onClick={() => setActiveTab('tickets')}>
          <i className='bx bx-message-square-detail'></i> Tickets
        </button>
        <button className={`nc-support-tab ${activeTab === 'analytics' ? 'active' : ''}`} onClick={() => setActiveTab('analytics')}>
          <i className='bx bx-chart'></i> Analytics
        </button>
      </div>

      {error ? (
        <div style={{ textAlign: 'center', padding: '4rem', background: 'var(--bg-card)', borderRadius: '12px' }}>
          <i className='bx bx-error-circle' style={{ fontSize: '3rem', color: 'var(--danger-color)', marginBottom: '1rem' }}></i>
          <h3>{error}</h3>
          <button className="nc-btn nc-btn-primary" onClick={loadTickets} style={{ marginTop: '1rem' }}>Try Again</button>
        </div>
      ) : activeTab === 'tickets' ? (
        <>
          {/* Stats */}
          <div className="nc-support-stats">
            <div className="nc-stat-card">
              <div className="nc-stat-icon" style={{ background: 'rgba(37, 99, 235, 0.1)', color: 'var(--blue)' }}>
                <i className='bx bx-receipt'></i>
              </div>
              <div>
                <p style={{ margin: '0 0 4px', color: 'var(--text-secondary)', fontSize: '0.85rem' }}>Total Tickets</p>
                <h3 style={{ margin: 0, fontSize: '1.5rem' }}>{total}</h3>
              </div>
            </div>
            <div className="nc-stat-card">
              <div className="nc-stat-icon" style={{ background: 'rgba(245, 158, 11, 0.1)', color: 'var(--warning-color)' }}>
                <i className='bx bx-envelope-open'></i>
              </div>
              <div>
                <p style={{ margin: '0 0 4px', color: 'var(--text-secondary)', fontSize: '0.85rem' }}>Open</p>
                <h3 style={{ margin: 0, fontSize: '1.5rem' }}>{openCount}</h3>
              </div>
            </div>
            <div className="nc-stat-card">
              <div className="nc-stat-icon" style={{ background: 'rgba(34, 197, 94, 0.1)', color: 'var(--success-color)' }}>
                <i className='bx bx-check-double'></i>
              </div>
              <div>
                <p style={{ margin: '0 0 4px', color: 'var(--text-secondary)', fontSize: '0.85rem' }}>Resolved</p>
                <h3 style={{ margin: 0, fontSize: '1.5rem' }}>{resolvedCount}</h3>
              </div>
            </div>
            <div className="nc-stat-card">
              <div className="nc-stat-icon" style={{ background: 'rgba(239, 68, 68, 0.1)', color: 'var(--danger-color)' }}>
                <i className='bx bx-alarm-exclamation'></i>
              </div>
              <div>
                <p style={{ margin: '0 0 4px', color: 'var(--text-secondary)', fontSize: '0.85rem' }}>Urgent</p>
                <h3 style={{ margin: 0, fontSize: '1.5rem' }}>{urgentCount}</h3>
              </div>
            </div>
          </div>

          {/* Filters */}
          <div className="nc-filters-bar">
            <div className="nc-input-group">
              <i className='bx bx-search'></i>
              <input type="text" className="nc-support-input" placeholder="Search ID, Subject, Name..." value={search} onChange={e => { setSearch(e.target.value); setCurrentPage(1); }} />
            </div>
            <select className="nc-support-select" style={{ width: '150px' }} value={filterStatus} onChange={e => { setFilterStatus(e.target.value); setCurrentPage(1); }}>
              <option value="All">All Statuses</option>
              <option value="Open">Open</option>
              <option value="Pending">Pending</option>
              <option value="In Progress">In Progress</option>
              <option value="Resolved">Resolved</option>
              <option value="Closed">Closed</option>
            </select>
            <select className="nc-support-select" style={{ width: '150px' }} value={filterPriority} onChange={e => { setFilterPriority(e.target.value); setCurrentPage(1); }}>
              <option value="All">All Priorities</option>
              <option value="Low">Low</option>
              <option value="Normal">Normal</option>
              <option value="High">High</option>
              <option value="Urgent">Urgent</option>
            </select>
            <select className="nc-support-select" style={{ width: '180px' }} value={filterCategory} onChange={e => { setFilterCategory(e.target.value); setCurrentPage(1); }}>
              <option value="All">All Categories</option>
              <optgroup label="Gift Cards">
                <option value="Gift Card Verification">Gift Card Verification</option>
              </optgroup>
              <optgroup label="Withdrawals">
                <option value="Withdrawal Failed">Withdrawal Failed</option>
              </optgroup>
              <optgroup label="General">
                <option value="General Question">General Question</option>
              </optgroup>
            </select>
            {/* Clear Filters Button */}
            {(search || filterStatus !== 'All' || filterPriority !== 'All' || filterCategory !== 'All') && (
              <button className="nc-btn nc-btn-outline" onClick={() => { setSearch(''); setFilterStatus('All'); setFilterPriority('All'); setFilterCategory('All'); }}>
                Clear Filters
              </button>
            )}
          </div>

          {/* Table */}
          <div className="nc-support-table-container">
            <div style={{ overflowX: 'auto' }}>
              <table className="nc-support-table">
                <thead>
                  <tr>
                    <th>Ticket Details</th>
                    <th>User</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>Assigned To</th>
                    <th>Last Updated</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  {isLoading ? (
                    Array(5).fill().map((_, i) => (
                      <tr key={i}>
                        <td colSpan="7"><div className="nc-shimmer" style={{ height: '40px', borderRadius: '4px' }}></div></td>
                      </tr>
                    ))
                  ) : paginatedData.length === 0 ? (
                    <tr>
                      <td colSpan="7" style={{ textAlign: 'center', padding: '3rem', color: 'var(--text-secondary)' }}>
                        <i className='bx bx-folder-open' style={{ fontSize: '3rem', marginBottom: '1rem', display: 'block' }}></i>
                        No support tickets found matching your filters.
                      </td>
                    </tr>
                  ) : (
                    paginatedData.map(ticket => (
                      <tr key={ticket.id} className={ticket.unread ? 'unread' : ''} onClick={() => {
                        handleUpdateTicket(ticket.id, { unread: false });
                        setSelectedTicket(ticket);
                      }}>
                        <td>
                          <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                            {ticket.unread && <span style={{ width: '8px', height: '8px', background: 'var(--primary-color)', borderRadius: '50%', display: 'inline-block' }}></span>}
                            <div>
                              <div style={{ color: 'var(--primary-color)', fontSize: '0.85rem' }}>{ticket.id}</div>
                              <div>{ticket.subject}</div>
                              <div style={{ fontSize: '0.75rem', color: 'var(--text-secondary)' }}>{ticket.category}</div>
                            </div>
                          </div>
                        </td>
                        <td>
                          <div>{ticket.user.name}</div>
                          <div style={{ fontSize: '0.75rem', color: 'var(--text-secondary)' }}>{ticket.user.email}</div>
                        </td>
                        <td><span className={`nc-badge ${ticket.priority.toLowerCase()}`}>{ticket.priority}</span></td>
                        <td><span className={`nc-badge ${ticket.status.toLowerCase().replace(' ', '-')}`}>{ticket.status}</span></td>
                        <td>{ticket.assignedTo}</td>
                        <td style={{ fontSize: '0.85rem' }}>{new Date(ticket.lastReplyAt).toLocaleDateString()}</td>
                        <td>
                          <button className="nc-btn nc-btn-outline" style={{ padding: '0.3rem 0.6rem', fontSize: '0.85rem' }}>
                            View
                          </button>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
            
            {/* Pagination Controls */}
            {!isLoading && paginatedData.length > 0 && (
              <div style={{ padding: '1rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderTop: '1px solid var(--border-color)', fontSize: '0.85rem', color: 'var(--text-secondary)', flexWrap: 'wrap', gap: '1rem' }}>
                <div>
                  Showing {((currentPage - 1) * perPage) + 1} to {Math.min(currentPage * perPage, filteredData.length)} of {filteredData.length} records
                </div>
                <div style={{ display: 'flex', gap: '1rem', alignItems: 'center' }}>
                  <select className="nc-support-select" style={{ width: 'auto', padding: '0.3rem', fontSize: '0.85rem' }} value={perPage} onChange={e => { setPerPage(Number(e.target.value)); setCurrentPage(1); }}>
                    <option value="10">10 per page</option>
                    <option value="25">25 per page</option>
                    <option value="50">50 per page</option>
                  </select>
                  <div style={{ display: 'flex', gap: '0.5rem' }}>
                    <button className="nc-btn nc-btn-outline" style={{ padding: '0.3rem 0.6rem' }} disabled={currentPage === 1} onClick={() => setCurrentPage(p => p - 1)}>Prev</button>
                    <button className="nc-btn nc-btn-primary" style={{ padding: '0.3rem 0.6rem' }}>{currentPage}</button>
                    <button className="nc-btn nc-btn-outline" style={{ padding: '0.3rem 0.6rem' }} disabled={currentPage === totalPages} onClick={() => setCurrentPage(p => p + 1)}>Next</button>
                  </div>
                </div>
              </div>
            )}
          </div>
        </>
      ) : (
        /* Analytics Tab View */
        <div className="fade-in" style={{ background: 'var(--bg-card)', border: '1px solid var(--border-color)', borderRadius: '12px', padding: '2rem' }}>
          <h3 style={{ margin: '0 0 1.5rem' }}>Support Analytics & Performance</h3>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '2rem' }}>
            
            {/* Chart 1: Categories */}
            <div>
              <h4 style={{ marginBottom: '1rem', color: 'var(--text-secondary)' }}>Tickets by Category</h4>
              <div className="nc-chart-bar-container">
                <div className="nc-chart-label">Gift Cards</div>
                <div className="nc-chart-track"><div className="nc-chart-fill" style={{ width: '65%', background: 'var(--primary-color)' }}></div></div>
                <div className="nc-chart-value">65%</div>
              </div>
              <div className="nc-chart-bar-container">
                <div className="nc-chart-label">Withdrawals</div>
                <div className="nc-chart-track"><div className="nc-chart-fill" style={{ width: '20%', background: 'var(--warning-color)' }}></div></div>
                <div className="nc-chart-value">20%</div>
              </div>
              <div className="nc-chart-bar-container">
                <div className="nc-chart-label">KYC / Account</div>
                <div className="nc-chart-track"><div className="nc-chart-fill" style={{ width: '10%', background: 'var(--info-color)' }}></div></div>
                <div className="nc-chart-value">10%</div>
              </div>
              <div className="nc-chart-bar-container">
                <div className="nc-chart-label">General</div>
                <div className="nc-chart-track"><div className="nc-chart-fill" style={{ width: '5%', background: 'var(--text-secondary)' }}></div></div>
                <div className="nc-chart-value">5%</div>
              </div>
            </div>

            {/* Chart 2: Resolution Metrics */}
            <div>
              <h4 style={{ marginBottom: '1rem', color: 'var(--text-secondary)' }}>Performance Metrics</h4>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
                <div style={{ background: 'var(--bg-primary)', padding: '1rem', borderRadius: '8px', border: '1px solid var(--border-color)' }}>
                  <p style={{ margin: '0 0 0.5rem', fontSize: '0.85rem', color: 'var(--text-secondary)' }}>Avg Response Time</p>
                  <h2 style={{ margin: 0, color: 'var(--info-color)' }}>14 mins</h2>
                </div>
                <div style={{ background: 'var(--bg-primary)', padding: '1rem', borderRadius: '8px', border: '1px solid var(--border-color)' }}>
                  <p style={{ margin: '0 0 0.5rem', fontSize: '0.85rem', color: 'var(--text-secondary)' }}>Avg Resolution Time</p>
                  <h2 style={{ margin: 0, color: 'var(--success-color)' }}>2.4 hours</h2>
                </div>
              </div>
            </div>

          </div>
        </div>
      )}

      {/* Ticket Conversation Drawer */}
      {selectedTicket && (
        <SupportTicketDrawer 
          ticket={selectedTicket} 
          onClose={() => setSelectedTicket(null)} 
          onUpdateTicket={handleUpdateTicket}
        />
      )}
    </div>
  );
}