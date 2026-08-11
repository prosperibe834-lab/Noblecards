import React, { useState, useEffect, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { initialUsersList, initialUserStats } from '../../data/usersData';
import UserStats from '../../components/users/UserStats';
import UserFilters from '../../components/users/UserFilters';
import UserDetailsModal from '../../components/users/UserDetailsModal';
import UserFormModal from '../../components/users/UserFormModal';
import UserConfirmModal from '../../components/users/UserConfirmModal';
import UserToast from '../../components/users/UserToast';
import UserSkeleton from '../../components/users/UserSkeleton';
import '../../styles/users.css';

const Users = () => {
  const navigate = useNavigate();

  // Primary State
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filters, setFilters] = useState({
    status: 'All',
    kycStatus: 'All',
    country: 'All Countries',
    joinedDate: 'All Time',
  });

  // Sorting & Pagination
  const [sortConfig, setSortConfig] = useState({ key: 'joinedDate', direction: 'desc' });
  const [currentPage, setCurrentPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);

  // Contextual Modals & Menus
  const [activeMenuId, setActiveMenuId] = useState(null);
  const [selectedUser, setSelectedUser] = useState(null);
  const [isViewModalOpen, setIsViewModalOpen] = useState(false);
  const [isFormModalOpen, setIsFormModalOpen] = useState(false);
  const [editingUser, setEditingUser] = useState(null);
  const [confirmAction, setConfirmAction] = useState(null); // 'suspend' | 'ban' | 'delete'
  const [toast, setToast] = useState(null);

  // Simulated Async Data Load
  useEffect(() => {
    const timer = setTimeout(() => {
      setUsers(initialUsersList);
      setLoading(false);
    }, 400);
    return () => clearTimeout(timer);
  }, []);

  // Reset pagination when filters or search change
  useEffect(() => {
    setCurrentPage(1);
  }, [searchTerm, filters]);

  // Combined Search and Filter Logic
  const filteredUsers = useMemo(() => {
    return users.filter((user) => {
      // Search Matching
      const matchesSearch =
        searchTerm === '' ||
        user.fullName.toLowerCase().includes(searchTerm.toLowerCase()) ||
        user.username.toLowerCase().includes(searchTerm.toLowerCase()) ||
        user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
        user.phone.toLowerCase().includes(searchTerm.toLowerCase()) ||
        user.userId.toLowerCase().includes(searchTerm.toLowerCase()) ||
        user.country.toLowerCase().includes(searchTerm.toLowerCase());

      // Filter Matching
      const matchesStatus = filters.status === 'All' || user.status === filters.status;
      const matchesKYC = filters.kycStatus === 'All' || user.kycStatus === filters.kycStatus;
      const matchesCountry =
        filters.country === 'All Countries' || user.country === filters.country;

      return matchesSearch && matchesStatus && matchesKYC && matchesCountry;
    });
  }, [users, searchTerm, filters]);

  // Multi-Column Sorting Logic
  const sortedUsers = useMemo(() => {
    const sortableUsers = [...filteredUsers];
    if (sortConfig.key) {
      sortableUsers.sort((a, b) => {
        let aVal = a[sortConfig.key];
        let bVal = b[sortConfig.key];

        if (typeof aVal === 'string') {
          aVal = aVal.toLowerCase();
          bVal = bVal.toLowerCase();
        }

        if (aVal < bVal) return sortConfig.direction === 'asc' ? -1 : 1;
        if (aVal > bVal) return sortConfig.direction === 'asc' ? 1 : -1;
        return 0;
      });
    }
    return sortableUsers;
  }, [filteredUsers, sortConfig]);

  // Pagination Slice
  const paginatedUsers = useMemo(() => {
    const startIndex = (currentPage - 1) * rowsPerPage;
    return sortedUsers.slice(startIndex, startIndex + rowsPerPage);
  }, [sortedUsers, currentPage, rowsPerPage]);

  const totalPages = Math.ceil(sortedUsers.length / rowsPerPage) || 1;

  // Sorting Handler
  const handleSort = (key) => {
    let direction = 'asc';
    if (sortConfig.key === key && sortConfig.direction === 'asc') {
      direction = 'desc';
    }
    setSortConfig({ key, direction });
  };

  // CSV Export Functionality (Dynamic Filename)
  const handleExportCSV = () => {
    const headers = [
      'Full Name',
      'Username',
      'User ID',
      'Email',
      'Phone Number',
      'Country',
      'Gender',
      'Date of Birth',
      'Address',
      'KYC Status',
      'Balance',
      'Cards',
      'Status',
      'Joined Date',
    ];

    const rows = sortedUsers.map((u) => [
      `"${u.fullName}"`,
      `"${u.username}"`,
      `"${u.userId}"`,
      `"${u.email}"`,
      `"${u.phone}"`,
      `"${u.country}"`,
      `"${u.gender}"`,
      `"${u.dateOfBirth}"`,
      `"${u.address}"`,
      `"${u.kycStatus}"`,
      u.balance.toFixed(2),
      u.cards,
      `"${u.status}"`,
      `"${u.joinedDate}"`,
    ]);

    const csvContent =
      'data:text/csv;charset=utf-8,' +
      [headers.join(','), ...rows.map((e) => e.join(','))].join('\n');

    const encodedUri = encodeURI(csvContent);
    const link = document.createElement('a');
    const today = new Date().toISOString().split('T')[0];
    link.setAttribute('href', encodedUri);
    link.setAttribute('download', `noblecards-users-${today}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    setToast({ type: 'success', message: 'User list exported successfully!' });
  };

  // User Action Handlers
  const handleCreateOrUpdateUser = (formData) => {
    if (editingUser) {
      setUsers((prev) =>
        prev.map((u) => (u.id === editingUser.id ? { ...u, ...formData } : u))
      );
      setToast({ type: 'success', message: 'User details updated successfully!' });
    } else {
      const newUser = {
        ...formData,
        id: `usr-${Date.now()}`,
        userId: `NC-00${Math.floor(1000 + Math.random() * 9000)}`,
        balance: 0.0,
        cards: 0,
        joinedDate: new Date().toISOString().split('T')[0],
      };
      setUsers((prev) => [newUser, ...prev]);
      setToast({ type: 'success', message: 'New user created successfully!' });
    }
    setIsFormModalOpen(false);
    setEditingUser(null);
  };

  const handleConfirmedAction = () => {
    if (!selectedUser || !confirmAction) return;

    if (confirmAction === 'suspend') {
      setUsers((prev) =>
        prev.map((u) => (u.id === selectedUser.id ? { ...u, status: 'Suspended' } : u))
      );
      setToast({ type: 'success', message: `${selectedUser.fullName} has been suspended.` });
    } else if (confirmAction === 'ban') {
      setUsers((prev) =>
        prev.map((u) => (u.id === selectedUser.id ? { ...u, status: 'Banned' } : u))
      );
      setToast({ type: 'success', message: `${selectedUser.fullName} has been banned.` });
    } else if (confirmAction === 'delete') {
      setUsers((prev) => prev.filter((u) => u.id !== selectedUser.id));
      setToast({ type: 'success', message: `${selectedUser.fullName} has been deleted.` });
    }

    setConfirmAction(null);
    setSelectedUser(null);
  };

  if (loading) return <UserSkeleton />;

  return (
    <div className="users-container">
      {/* Toast Banner Notification */}
      <UserToast toast={toast} onClose={() => setToast(null)} />

      {/* Header Section */}
      <div className="users-header">
        <div className="users-header-title">
          <h1>Users Management</h1>
          <p>Manage, monitor and review all NobleCards users.</p>
        </div>

        <div className="users-header-actions">
          <button className="btn-secondary-outline" onClick={handleExportCSV}>
            <i className="bx bx-export"></i>
            <span>Export CSV</span>
          </button>
          <button
            className="btn-primary-green"
            onClick={() => {
              setEditingUser(null);
              setIsFormModalOpen(true);
            }}
          >
            <i className="bx bx-plus"></i>
            <span>Add User</span>
          </button>
        </div>
      </div>

      {/* Metrics Cards */}
      <UserStats stats={initialUserStats} />

      {/* Filters Toolbar */}
      <UserFilters
        searchTerm={searchTerm}
        setSearchTerm={setSearchTerm}
        filters={filters}
        setFilters={setFilters}
        onResetFilters={() => {
          setSearchTerm('');
          setFilters({
            status: 'All',
            kycStatus: 'All',
            country: 'All Countries',
            joinedDate: 'All Time',
          });
        }}
      />

      {/* Main Users Table Card */}
      <div className="users-table-wrapper">
        <div className="table-responsive-container">
          <table className="users-table">
            <thead>
              <tr>
                <th
                  className="sortable-header"
                  onClick={() => handleSort('fullName')}
                >
                  User <i className="bx bx-sort-alt-2"></i>
                </th>
                <th>User ID</th>
                <th>Country</th>
                <th>Gender</th>
                <th>KYC Status</th>
                <th
                  className="sortable-header"
                  onClick={() => handleSort('balance')}
                >
                  Balance <i className="bx bx-sort-alt-2"></i>
                </th>
                <th
                  className="sortable-header"
                  onClick={() => handleSort('cards')}
                >
                  Cards <i className="bx bx-sort-alt-2"></i>
                </th>
                <th>Status</th>
                <th
                  className="sortable-header"
                  onClick={() => handleSort('joinedDate')}
                >
                  Joined <i className="bx bx-sort-alt-2"></i>
                </th>
                <th style={{ textAlign: 'right' }}>Action</th>
              </tr>
            </thead>

            <tbody>
              {paginatedUsers.length > 0 ? (
                paginatedUsers.map((user) => (
                  <tr key={user.id}>
                    <td>
                      <div className="user-info-cell">
                        <img
                          src={user.avatar}
                          alt={user.fullName}
                          className="user-avatar-img"
                        />
                        <div className="user-details-group">
                          <span className="user-name-text">{user.fullName}</span>
                          <span className="user-username-text">{user.username}</span>
                        </div>
                      </div>
                    </td>

                    <td>
                      <span className="user-id-code">{user.userId}</span>
                    </td>

                    <td>{user.country}</td>
                    <td>{user.gender}</td>

                    <td>
                      <span className={`kyc-pill ${user.kycStatus.toLowerCase().replace(' ', '-')}`}>
                        {user.kycStatus}
                      </span>
                    </td>

                    <td style={{ fontWeight: 700 }}>${user.balance.toFixed(2)}</td>
                    <td>{user.cards}</td>

                    <td>
                      <span className={`status-pill ${user.status.toLowerCase()}`}>
                        {user.status}
                      </span>
                    </td>

                    <td style={{ fontSize: '0.8rem', color: 'var(--secondary-text)' }}>
                      {user.joinedDate}
                    </td>

                    <td style={{ textAlign: 'right' }}>
                      <div className="action-menu-wrapper">
                        <button
                          className="action-menu-btn"
                          onClick={() =>
                            setActiveMenuId(activeMenuId === user.id ? null : user.id)
                          }
                        >
                          <i className="bx bx-dots-vertical-rounded"></i>
                        </button>

                        {/* Action Menu Popup */}
                        {activeMenuId === user.id && (
                          <div className="action-dropdown-popup">
                            <button
                              className="dropdown-item-btn"
                              onClick={() => {
                                setSelectedUser(user);
                                setIsViewModalOpen(true);
                                setActiveMenuId(null);
                              }}
                            >
                              <i className="bx bx-show"></i>
                              <span>View Profile</span>
                            </button>

                            <button
                              className="dropdown-item-btn"
                              onClick={() => {
                                navigate(`/transactions?userId=${user.userId}`);
                                setActiveMenuId(null);
                              }}
                            >
                              <i className="bx bx-transfer"></i>
                              <span>View Transactions</span>
                            </button>

                            <button
                              className="dropdown-item-btn"
                              onClick={() => {
                                setEditingUser(user);
                                setIsFormModalOpen(true);
                                setActiveMenuId(null);
                              }}
                            >
                              <i className="bx bx-edit"></i>
                              <span>Edit User</span>
                            </button>

                            <button
                              className="dropdown-item-btn"
                              onClick={() => {
                                setSelectedUser(user);
                                setConfirmAction('suspend');
                                setActiveMenuId(null);
                              }}
                            >
                              <i className="bx bx-pause-circle"></i>
                              <span>Suspend User</span>
                            </button>

                            <button
                              className="dropdown-item-btn"
                              onClick={() => {
                                setSelectedUser(user);
                                setConfirmAction('ban');
                                setActiveMenuId(null);
                              }}
                            >
                              <i className="bx bx-ban"></i>
                              <span>Ban User</span>
                            </button>

                            <button
                              className="dropdown-item-btn danger"
                              onClick={() => {
                                setSelectedUser(user);
                                setConfirmAction('delete');
                                setActiveMenuId(null);
                              }}
                            >
                              <i className="bx bx-trash"></i>
                              <span>Delete User</span>
                            </button>
                          </div>
                        )}
                      </div>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan="10" style={{ textAlign: 'center', padding: '40px' }}>
                    <i
                      className="bx bx-folder-open"
                      style={{ fontSize: '2.5rem', color: 'var(--secondary-text)' }}
                    ></i>
                    <p style={{ marginTop: '8px', color: 'var(--secondary-text)' }}>
                      No matching users found
                    </p>
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination Footer */}
        <div className="table-pagination-bar">
          <span className="pagination-info-text">
            Showing{' '}
            {paginatedUsers.length > 0 ? (currentPage - 1) * rowsPerPage + 1 : 0}–
            {Math.min(currentPage * rowsPerPage, sortedUsers.length)} of{' '}
            {sortedUsers.length} users
          </span>

          <div className="pagination-controls-group">
            <div className="rows-per-page-select">
              <span>Rows per page:</span>
              <select
                className="filter-select-control"
                style={{ padding: '4px 8px' }}
                value={rowsPerPage}
                onChange={(e) => {
                  setRowsPerPage(Number(e.target.value));
                  setCurrentPage(1);
                }}
              >
                <option value={5}>5</option>
                <option value={10}>10</option>
                <option value={20}>20</option>
                <option value={50}>50</option>
              </select>
            </div>

            <div className="page-nav-buttons">
              <button
                className="page-btn"
                disabled={currentPage === 1}
                onClick={() => setCurrentPage((p) => p - 1)}
              >
                <i className="bx bx-chevron-left"></i>
              </button>

              {Array.from({ length: totalPages }, (_, i) => i + 1).map((page) => (
                <button
                  key={page}
                  className={`page-btn ${currentPage === page ? 'active' : ''}`}
                  onClick={() => setCurrentPage(page)}
                >
                  {page}
                </button>
              ))}

              <button
                className="page-btn"
                disabled={currentPage === totalPages}
                onClick={() => setCurrentPage((p) => p + 1)}
              >
                <i className="bx bx-chevron-right"></i>
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Modal Dialogs */}
      <UserDetailsModal
        user={selectedUser}
        onClose={() => {
          setIsViewModalOpen(false);
          setSelectedUser(null);
        }}
      />

      <UserFormModal
        isOpen={isFormModalOpen}
        initialData={editingUser}
        onClose={() => {
          setIsFormModalOpen(false);
          setEditingUser(null);
        }}
        onSave={handleCreateOrUpdateUser}
      />

      <UserConfirmModal
        actionType={confirmAction}
        user={selectedUser}
        onClose={() => {
          setConfirmAction(null);
          setSelectedUser(null);
        }}
        onConfirm={handleConfirmedAction}
      />
    </div>
  );
};

export default Users;