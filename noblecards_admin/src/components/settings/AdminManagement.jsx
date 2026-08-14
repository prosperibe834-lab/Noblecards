import React, { useState } from "react";
import { initialAdmins } from "../../data/settingsData";
import { AdminConfirmationModal, AdminFormModal } from "./SettingsModals";

export const AdminManagement = ({ showToast }) => {
  const [admins, setAdmins] = useState(initialAdmins);
  const [searchQuery, setSearchQuery] = useState("");
  const [roleFilter, setRoleFilter] = useState("All");
  const [currentPage, setCurrentPage] = useState(1);
  const [itemsPerPage, setItemsPerPage] = useState(10);
  
  // Modal States
  const [confirmModal, setConfirmModal] = useState({ open: false, admin: null, action: "" });
  const [formModalOpen, setFormModalOpen] = useState(false);

  // Protected Super Admin Logic
  const handleActionClick = (admin, action) => {
    if (admin.role === "Super Admin") {
      showToast("error", "Super Admin is protected and cannot be modified.");
      return;
    }
    setConfirmModal({ open: true, admin, action });
  };

  const executeAction = (admin, action) => {
    // Backend simulation guard
    if (admin.role === "Super Admin") return;

    if (action === "delete") {
      setAdmins(admins.filter(a => a.id !== admin.id));
      showToast("success", `Administrator ${admin.fullName} deleted successfully.`);
    } else {
      setAdmins(admins.map(a => 
        a.id === admin.id ? { ...a, status: action === "suspend" ? "Suspended" : "Banned" } : a
      ));
      showToast("success", `Administrator status changed to ${action}.`);
    }
    setConfirmModal({ open: false, admin: null, action: "" });
  };

  const handleAddAdmin = (data) => {
    const newAdmin = {
      ...data,
      id: `ADM-00${admins.length + 1}`,
      status: "Active",
      lastLogin: "Never",
      joinedDate: new Date().toISOString().split("T")[0],
      avatar: `https://ui-avatars.com/api/?name=${data.fullName.replace(" ", "+")}&background=2563EB&color=fff`,
    };
    setAdmins([newAdmin, ...admins]);
    setFormModalOpen(false);
    showToast("success", "New administrator created successfully.");
  };

  // Filters & Pagination
  const filteredAdmins = admins.filter(admin => {
    const matchesSearch = admin.fullName.toLowerCase().includes(searchQuery.toLowerCase()) || 
                          admin.email.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesRole = roleFilter === "All" || admin.role === roleFilter;
    return matchesSearch && matchesRole;
  });

  return (
    <div className="settings-section-card animate-fade-in">
      <div className="settings-header-flex">
        <div>
          <h2>Admin Management</h2>
          <p className="settings-subtitle">Manage platform administrators and roles.</p>
        </div>
        <button className="settings-btn-primary" onClick={() => setFormModalOpen(true)}>
          <i className="bx bx-plus"></i> Add Admin
        </button>
      </div>

      <div className="settings-filters">
        <div className="search-box">
          <i className="bx bx-search"></i>
          <input 
            type="text" 
            placeholder="Search by name, email..." 
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>
        <select className="settings-input filter-select" value={roleFilter} onChange={(e) => setRoleFilter(e.target.value)}>
          <option value="All">All Roles</option>
          <option value="Super Admin">Super Admin</option>
          <option value="Finance Admin">Finance Admin</option>
          <option value="Support Admin">Support Admin</option>
          <option value="KYC Admin">KYC Admin</option>
        </select>
      </div>

      <div className="admin-table-container">
        <table className="settings-table">
          <thead>
            <tr>
              <th>Administrator</th>
              <th>Role</th>
              <th>Status</th>
              <th>Last Login</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {filteredAdmins.map(admin => (
              <tr key={admin.id}>
                <td>
                  <div className="admin-cell-profile">
                    <img src={admin.avatar} alt="avatar" className="admin-avatar" />
                    <div>
                      <strong>{admin.fullName}</strong>
                      <span>{admin.email}</span>
                      <span className="admin-id-badge">{admin.id}</span>
                    </div>
                  </div>
                </td>
                <td><span className="role-badge">{admin.role}</span></td>
                <td>
                  <span className={`status-badge ${admin.status.toLowerCase()}`}>
                    {admin.status}
                  </span>
                </td>
                <td><span className="date-text">{admin.lastLogin}</span></td>
                <td>
                  {admin.role === "Super Admin" ? (
                    <span className="protected-badge"><i className="bx bx-shield-quarter"></i> Protected</span>
                  ) : (
                    <div className="action-buttons">
                      <button onClick={() => handleActionClick(admin, "suspend")} className="btn-icon warn" title="Suspend"><i className="bx bx-pause-circle"></i></button>
                      <button onClick={() => handleActionClick(admin, "ban")} className="btn-icon danger" title="Ban"><i className="bx bx-block"></i></button>
                      <button onClick={() => handleActionClick(admin, "delete")} className="btn-icon delete" title="Delete"><i className="bx bx-trash"></i></button>
                    </div>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {filteredAdmins.length === 0 && (
          <div className="empty-state">
            <i className="bx bx-user-x"></i>
            <p>No administrators found matching your criteria.</p>
          </div>
        )}
      </div>

      <AdminConfirmationModal 
        isOpen={confirmModal.open} 
        onClose={() => setConfirmModal({ open: false, admin: null, action: "" })}
        onConfirm={executeAction}
        admin={confirmModal.admin}
        actionType={confirmModal.action}
      />
      <AdminFormModal 
        isOpen={formModalOpen}
        onClose={() => setFormModalOpen(false)}
        onSave={handleAddAdmin}
      />
    </div>
  );
};