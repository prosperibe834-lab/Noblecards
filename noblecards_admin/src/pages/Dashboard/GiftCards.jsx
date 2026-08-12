import React, { useState, useMemo, useEffect, useRef } from 'react';
import '../../styles/giftCards.css';
import { initialGiftCards, filterOptions } from '../../data/giftCardData';
import ManageRatesModal from '../../components/giftCards/ManageRatesModal';
import ActionModal from '../../components/giftCards/ActionModal';
import AddGiftCardModal from '../../components/giftCards/AddGiftCardModal';
import GiftCardDetailsModal from '../../components/giftCards/GiftCardDetailsModal';
import UserListingsModal from '../../components/giftCards/UserListingsModal';


const GiftCards = () => {
  // State
  const [cards, setCards] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [filters, setFilters] = useState({
    category: 'All',
    country: 'All',
    status: 'All',
    currency: 'All'
  });
  const [sortConfig, setSortConfig] = useState({ key: 'updatedAt', direction: 'desc' });
  const [currentPage, setCurrentPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [openDropdownId, setOpenDropdownId] = useState(null);

  // Modals state
  const [ratesModalData, setRatesModalData] = useState({ isOpen: false, card: null });
  const [actionModalData, setActionModalData] = useState({ isOpen: false, type: '', card: null });
  const [detailsModalData, setDetailsModalData] = useState({ isOpen: false, card: null });
  const [listingsModalData, setListingsModalData] = useState({ isOpen: false, card: null });

  // Ref to handle clicking outside dropdowns
  const dropdownRef = useRef(null);

  // Simulate initial API load
  useEffect(() => {
    const fetchCards = async () => {
      setIsLoading(true);
      // Future Laravel call: const res = await axios.get('/api/v1/admin/giftcards');
      setTimeout(() => {
        setCards(initialGiftCards);
        setIsLoading(false);
      }, 800);
    };
    fetchCards();
  }, []);

  // Handle clicking outside dropdown
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setOpenDropdownId(null);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Handlers
  const handleFilterChange = (e) => {
    const { name, value } = e.target;
    setFilters(prev => ({ ...prev, [name]: value }));
    setCurrentPage(1);
  };

  const clearFilters = () => {
    setSearch('');
    setFilters({ category: 'All', country: 'All', status: 'All', currency: 'All' });
    setCurrentPage(1);
  };

  const handleSort = (key) => {
    let direction = 'asc';
    if (sortConfig.key === key && sortConfig.direction === 'asc') direction = 'desc';
    setSortConfig({ key, direction });
  };

  // Memoized computations
  const filteredAndSortedCards = useMemo(() => {
    let result = cards;

    // Search
    if (search) {
      const q = search.toLowerCase();
      result = result.filter(c => 
        c.name.toLowerCase().includes(q) || 
        c.cardId.toLowerCase().includes(q) ||
        c.brand.toLowerCase().includes(q)
      );
    }

    // Filters
    if (filters.category !== 'All') result = result.filter(c => c.category === filters.category);
    if (filters.country !== 'All') result = result.filter(c => c.country === filters.country);
    if (filters.status !== 'All') result = result.filter(c => c.status === filters.status);
    if (filters.currency !== 'All') result = result.filter(c => c.currency === filters.currency);

    // Sort
    result.sort((a, b) => {
      if (a[sortConfig.key] < b[sortConfig.key]) return sortConfig.direction === 'asc' ? -1 : 1;
      if (a[sortConfig.key] > b[sortConfig.key]) return sortConfig.direction === 'asc' ? 1 : -1;
      return 0;
    });

    return result;
  }, [cards, search, filters, sortConfig]);

  // Pagination bounds
  const totalPages = Math.ceil(filteredAndSortedCards.length / rowsPerPage);
  const currentCards = filteredAndSortedCards.slice(
    (currentPage - 1) * rowsPerPage,
    currentPage * rowsPerPage
  );

  // Actions
  const handleUpdateRates = (cardId, newBuyRate, newSaleRate) => {
    setCards(prev => prev.map(c => 
      c.id === cardId ? { ...c, buyRate: newBuyRate, saleRate: newSaleRate, updatedAt: new Date().toISOString().split('T')[0] } : c
    ));
    setRatesModalData({ isOpen: false, card: null });
    // Alert replacement for Toast (use your existing toast here)
    alert('Rates updated successfully.');
  };

  const handleConfirmAction = (cardId, actionType) => {
    setCards(prev => {
      if (actionType === 'Delete') {
        return prev.filter(c => c.id !== cardId);
      }
      let newStatus = actionType;
      if (actionType === 'Activate') newStatus = 'Active';
      return prev.map(c => c.id === cardId ? { ...c, status: newStatus } : c);
    });
    setActionModalData({ isOpen: false, type: '', card: null });
  };

  const handleAddGiftCard = (newCard) => {
    setCards(prev => [newCard, ...prev]);
    alert(`Gift Card "${newCard.name}" created successfully with ID: ${newCard.cardId}`);
  };

  const exportCSV = () => {
    const headers = ['Card ID', 'Name', 'Brand', 'Category', 'Country', 'Currency', 'Buy Rate', 'Sale Rate', 'Available', 'Status', 'Updated At'];
    const rows = filteredAndSortedCards.map(c => [
      c.cardId, c.name, c.brand, c.category, c.country, c.currency, c.buyRate, c.saleRate, c.available, c.status, c.updatedAt
    ]);
    
    let csvContent = "data:text/csv;charset=utf-8," + [headers.join(","), ...rows.map(e => e.join(","))].join("\n");
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", `noblecards-giftcards-${new Date().toISOString().split('T')[0]}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  // Stats calculation
  const totalCards = cards.length;
  const activeCards = cards.filter(c => c.status === 'Active').length;
  const totalValue = cards.reduce((acc, c) => acc + c.totalValue, 0);
  const revenue = cards.reduce((acc, c) => acc + c.revenue, 0);

  if (isLoading) {
    return <div className="gc-container">Loading Gift Cards securely...</div>; // Replace with your Skeleton
  }

  return (
    <div className="gc-container">
      {/* Header */}
      <div className="gc-header">
        <div className="gc-title-section">
          <h1>Gift Cards</h1>
          <p>Manage gift card brands, inventory, listings, rates, verification and card activity.</p>
        </div>
        <div className="gc-actions">
          <button className="gc-btn gc-btn-secondary" onClick={() => setCards([...initialGiftCards])}>
            <i className='bx bx-refresh'></i> Refresh
          </button>
          <button className="gc-btn gc-btn-secondary" onClick={exportCSV}>
            <i className='bx bx-download'></i> Export CSV
          </button>
          <button className="gc-btn gc-btn-primary" onClick={() => setIsAddModalOpen(true)}>
            <i className='bx bx-plus'></i> Add Gift Card
          </button>
        </div>
      </div>

      {/* Stats */}
      <div className="gc-stats-grid">
        <div className="gc-stat-card">
          <div className="gc-stat-header">
            <span className="gc-stat-title">Total Gift Cards</span>
            <div className="gc-stat-icon"><i className='bx bx-gift'></i></div>
          </div>
          <div className="gc-stat-value">{totalCards}</div>
          <div className="gc-stat-change positive"><i className='bx bx-up-arrow-alt'></i> Updated</div>
        </div>
        <div className="gc-stat-card">
          <div className="gc-stat-header">
            <span className="gc-stat-title">Active Cards</span>
            <div className="gc-stat-icon"><i className='bx bx-check-circle'></i></div>
          </div>
          <div className="gc-stat-value">{activeCards}</div>
          <div className="gc-stat-change positive"><i className='bx bx-up-arrow-alt'></i> Market ready</div>
        </div>
        <div className="gc-stat-card">
          <div className="gc-stat-header">
            <span className="gc-stat-title">Total Card Value</span>
            <div className="gc-stat-icon"><i className='bx bx-dollar-circle'></i></div>
          </div>
          <div className="gc-stat-value">${totalValue.toLocaleString()}</div>
          <div className="gc-stat-change neutral"><i className='bx bx-minus'></i> In inventory</div>
        </div>
        <div className="gc-stat-card">
          <div className="gc-stat-header">
            <span className="gc-stat-title">Revenue Generated</span>
            <div className="gc-stat-icon"><i className='bx bx-bar-chart'></i></div>
          </div>
          <div className="gc-stat-value">${revenue.toLocaleString()}</div>
          <div className="gc-stat-change positive"><i className='bx bx-up-arrow-alt'></i> +12.8% this month</div>
        </div>
      </div>

      {/* Filters */}
      <div className="gc-filters-section">
        <div className="gc-search-bar">
          <i className='bx bx-search'></i>
          <input 
            type="text" 
            placeholder="Search gift cards by name, brand, Card ID, country..." 
            value={search}
            onChange={(e) => { setSearch(e.target.value); setCurrentPage(1); }}
          />
        </div>
        <div className="gc-filter-grid">
          <select name="category" className="gc-filter-select" value={filters.category} onChange={handleFilterChange}>
            <option value="All">All Categories</option>
            {filterOptions.categories.map(c => <option key={c} value={c}>{c}</option>)}
          </select>
          <select name="country" className="gc-filter-select" value={filters.country} onChange={handleFilterChange}>
            <option value="All">All Countries</option>
            {filterOptions.countries.map(c => <option key={c} value={c}>{c}</option>)}
          </select>
          <select name="status" className="gc-filter-select" value={filters.status} onChange={handleFilterChange}>
            <option value="All">All Statuses</option>
            {filterOptions.statuses.map(c => <option key={c} value={c}>{c}</option>)}
          </select>
          <select name="currency" className="gc-filter-select" value={filters.currency} onChange={handleFilterChange}>
            <option value="All">All Currencies</option>
            {filterOptions.currencies.map(c => <option key={c} value={c}>{c}</option>)}
          </select>
          <button className="gc-btn gc-btn-secondary" onClick={clearFilters} style={{ justifyContent: 'center' }}>
            <i className='bx bx-filter'></i> Clear Filters
          </button>
        </div>
      </div>

      {/* Table */}
      <div className="gc-table-container">
        <table className="gc-table">
          <thead>
            <tr>
              <th onClick={() => handleSort('name')}>Gift Card <i className='bx bx-sort'></i></th>
              <th onClick={() => handleSort('cardId')}>Card ID <i className='bx bx-sort'></i></th>
              <th onClick={() => handleSort('country')}>Country <i className='bx bx-sort'></i></th>
              <th>Rates (Buy/Sale)</th>
              <th onClick={() => handleSort('available')}>Available <i className='bx bx-sort'></i></th>
              <th onClick={() => handleSort('status')}>Status <i className='bx bx-sort'></i></th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {currentCards.length > 0 ? (
              currentCards.map(card => (
                <tr key={card.id}>
                  <td>
                    <div className="gc-card-identity">
                      <div className="gc-card-icon"><i className='bx bx-credit-card'></i></div>
                      <div className="gc-card-info">
                        <strong>{card.name}</strong>
                        <span>{card.category}</span>
                      </div>
                    </div>
                  </td>
                  <td>{card.cardId}</td>
                  <td>
                    <div className="gc-card-info">
                      <strong>{card.country}</strong>
                      <span>{card.currency}</span>
                    </div>
                  </td>
                  <td>
                    <div className="gc-card-info">
                      <strong>Buy: {card.buyRate}%</strong>
                      <span>Sale: {card.saleRate}%</span>
                    </div>
                  </td>
                  <td>{card.available.toLocaleString()}</td>
                  <td>
                    <span className={`gc-badge status-${card.status}`}>
                      <i className={`bx ${card.status === 'Active' ? 'bx-check-circle' : card.status === 'Pending' ? 'bx-time' : card.status === 'Suspended' ? 'bx-pause-circle' : 'bx-x-circle'}`}></i>
                      {card.status}
                    </span>
                  </td>
                  <td>
                    <div className="gc-action-menu" ref={openDropdownId === card.id ? dropdownRef : null}>
                      <button className="gc-action-btn" onClick={() => setOpenDropdownId(openDropdownId === card.id ? null : card.id)}>
                        <i className='bx bx-dots-vertical-rounded'></i>
                      </button>
                      {openDropdownId === card.id && (
                        <div className="gc-dropdown-content">
                          <button className="gc-dropdown-item" onClick={() => { setRatesModalData({ isOpen: true, card }); setOpenDropdownId(null); }}>
                            <i className='bx bx-transfer'></i> Manage Rates
                          </button>
                          <button 
                            className="gc-dropdown-item" 
                            onClick={() => { setListingsModalData({ isOpen: true, card }); setOpenDropdownId(null); }}
                          >
                            <i className='bx bx-list-check'></i> Verify User Trades
                          </button>
                          <button className="gc-dropdown-item" onClick={() => { setDetailsModalData({ isOpen: true, card }); setOpenDropdownId(null); }}>
                            <i className='bx bx-show'></i> View Details
                          </button>
                          {card.status !== 'Active' && (
                            <button className="gc-dropdown-item" onClick={() => { setActionModalData({ isOpen: true, type: 'Activate', card }); setOpenDropdownId(null); }}>
                              <i className='bx bx-check-circle'></i> Activate
                            </button>
                          )}
                          {card.status !== 'Suspended' && (
                            <button className="gc-dropdown-item danger" onClick={() => { setActionModalData({ isOpen: true, type: 'Suspend', card }); setOpenDropdownId(null); }}>
                              <i className='bx bx-pause-circle'></i> Suspend
                            </button>
                          )}
                          <button className="gc-dropdown-item danger" onClick={() => { setActionModalData({ isOpen: true, type: 'Delete', card }); setOpenDropdownId(null); }}>
                            <i className='bx bx-trash'></i> Delete
                          </button>
                        </div>
                      )}
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="7" style={{ textAlign: 'center', padding: '40px' }}>
                  <p style={{ color: 'var(--secondary-text)', marginBottom: '12px' }}>No Gift Cards Found</p>
                  <button className="gc-btn gc-btn-secondary" onClick={clearFilters}>Clear Filters</button>
                </td>
              </tr>
            )}
          </tbody>
        </table>

        {/* Pagination */}
        <div className="gc-pagination">
          <div style={{ color: 'var(--secondary-text)', fontSize: '14px' }}>
            Showing {((currentPage - 1) * rowsPerPage) + 1}–{Math.min(currentPage * rowsPerPage, filteredAndSortedCards.length)} of {filteredAndSortedCards.length}
          </div>
          <div className="gc-page-controls">
            <button className="gc-page-btn" disabled={currentPage === 1} onClick={() => setCurrentPage(p => p - 1)}>
              <i className='bx bx-chevron-left'></i>
            </button>
            <button className="gc-page-btn active">{currentPage}</button>
            <button className="gc-page-btn" disabled={currentPage === totalPages || totalPages === 0} onClick={() => setCurrentPage(p => p + 1)}>
              <i className='bx bx-chevron-right'></i>
            </button>
          </div>
        </div>
      </div>

      {/* Render Modals */}
      <ManageRatesModal 
        isOpen={ratesModalData.isOpen} 
        card={ratesModalData.card} 
        onClose={() => setRatesModalData({ isOpen: false, card: null })} 
        onSave={handleUpdateRates}
      />
      
      <ActionModal 
        isOpen={actionModalData.isOpen} 
        card={actionModalData.card} 
        actionType={actionModalData.type}
        onClose={() => setActionModalData({ isOpen: false, type: '', card: null })} 
        onConfirm={handleConfirmAction}
      />
      <AddGiftCardModal 
        isOpen={isAddModalOpen} 
        onClose={() => setIsAddModalOpen(false)} 
        onAdd={handleAddGiftCard} 
      />
      <GiftCardDetailsModal 
        isOpen={detailsModalData.isOpen} 
        card={detailsModalData.card} 
        onClose={() => setDetailsModalData({ isOpen: false, card: null })} 
      />
      <UserListingsModal 
        isOpen={listingsModalData.isOpen} 
        card={listingsModalData.card} 
        onClose={() => setListingsModalData({ isOpen: false, card: null })} 
      />
    </div>
  );
};

export default GiftCards;