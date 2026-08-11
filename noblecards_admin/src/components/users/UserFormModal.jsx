import React, { useState, useEffect } from 'react';

const UserFormModal = ({ isOpen, onClose, onSave, initialData }) => {
  const [formData, setFormData] = useState({
    fullName: '',
    username: '',
    email: '',
    phone: '',
    country: 'Nigeria',
    gender: 'Male',
    dateOfBirth: '',
    address: '',
    password: '',
    confirmPassword: '',
    kycStatus: 'Verified',
    status: 'Active',
    avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80',
  });

  const [errors, setErrors] = useState({});

  useEffect(() => {
    if (initialData) {
      setFormData({
        ...initialData,
        password: '',
        confirmPassword: '',
      });
    } else {
      setFormData({
        fullName: '',
        username: '',
        email: '',
        phone: '',
        country: 'Nigeria',
        gender: 'Male',
        dateOfBirth: '',
        address: '',
        password: '',
        confirmPassword: '',
        kycStatus: 'Verified',
        status: 'Active',
        avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80',
      });
    }
    setErrors({});
  }, [initialData, isOpen]);

  if (!isOpen) return null;

  const validate = () => {
    const errs = {};
    if (!formData.fullName.trim()) errs.fullName = 'Full Name is required';
    if (!formData.username.trim()) errs.username = 'Username is required';
    if (!formData.email.trim()) errs.email = 'Email is required';
    if (!formData.phone.trim()) errs.phone = 'Phone number is required';
    
    if (!initialData) {
      if (!formData.password) errs.password = 'Password is required';
      if (formData.password !== formData.confirmPassword) {
        errs.confirmPassword = 'Passwords do not match';
      }
    }

    setErrors(errs);
    return Object.keys(errs).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (validate()) {
      onSave(formData);
    }
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content-card" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header-row">
          <h3 className="modal-title-text">
            {initialData ? 'Edit User Profile' : 'Add New User'}
          </h3>
          <button className="modal-close-btn" onClick={onClose}>
            <i className="bx bx-x"></i>
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="modal-body-padding">
            <div className="form-grid-two-col">
              <div className="form-group-field">
                <label>Full Name</label>
                <input
                  type="text"
                  className="form-input-control"
                  value={formData.fullName}
                  onChange={(e) => setFormData({ ...formData, fullName: e.target.value })}
                />
                {errors.fullName && <span className="form-error-msg">{errors.fullName}</span>}
              </div>

              <div className="form-group-field">
                <label>Username</label>
                <input
                  type="text"
                  className="form-input-control"
                  value={formData.username}
                  onChange={(e) => setFormData({ ...formData, username: e.target.value })}
                />
                {errors.username && <span className="form-error-msg">{errors.username}</span>}
              </div>
            </div>

            <div className="form-grid-two-col">
              <div className="form-group-field">
                <label>Email Address</label>
                <input
                  type="email"
                  className="form-input-control"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                />
                {errors.email && <span className="form-error-msg">{errors.email}</span>}
              </div>

              <div className="form-group-field">
                <label>Phone Number</label>
                <input
                  type="text"
                  className="form-input-control"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                />
                {errors.phone && <span className="form-error-msg">{errors.phone}</span>}
              </div>
            </div>

            <div className="form-grid-two-col">
              <div className="form-group-field">
                <label>Country</label>
                <input
                  type="text"
                  className="form-input-control"
                  value={formData.country}
                  onChange={(e) => setFormData({ ...formData, country: e.target.value })}
                />
              </div>

              <div className="form-group-field">
                <label>Gender</label>
                <select
                  className="form-input-control"
                  value={formData.gender}
                  onChange={(e) => setFormData({ ...formData, gender: e.target.value })}
                >
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                  <option value="Other">Other</option>
                </select>
              </div>
            </div>

            {!initialData && (
              <div className="form-grid-two-col">
                <div className="form-group-field">
                  <label>Password</label>
                  <input
                    type="password"
                    className="form-input-control"
                    value={formData.password}
                    onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                  />
                  {errors.password && <span className="form-error-msg">{errors.password}</span>}
                </div>

                <div className="form-group-field">
                  <label>Confirm Password</label>
                  <input
                    type="password"
                    className="form-input-control"
                    value={formData.confirmPassword}
                    onChange={(e) => setFormData({ ...formData, confirmPassword: e.target.value })}
                  />
                  {errors.confirmPassword && (
                    <span className="form-error-msg">{errors.confirmPassword}</span>
                  )}
                </div>
              </div>
            )}

            <div className="form-grid-two-col">
              <div className="form-group-field">
                <label>KYC Status</label>
                <select
                  className="form-input-control"
                  value={formData.kycStatus}
                  onChange={(e) => setFormData({ ...formData, kycStatus: e.target.value })}
                >
                  <option value="Verified">Verified</option>
                  <option value="Pending">Pending</option>
                  <option value="Rejected">Rejected</option>
                  <option value="Not Submitted">Not Submitted</option>
                </select>
              </div>

              <div className="form-group-field">
                <label>Account Status</label>
                <select
                  className="form-input-control"
                  value={formData.status}
                  onChange={(e) => setFormData({ ...formData, status: e.target.value })}
                >
                  <option value="Active">Active</option>
                  <option value="Suspended">Suspended</option>
                  <option value="Banned">Banned</option>
                  <option value="Pending">Pending</option>
                </select>
              </div>
            </div>
          </div>

          <div className="modal-footer-row">
            <button type="button" className="btn-secondary-outline" onClick={onClose}>
              Cancel
            </button>
            <button type="submit" className="btn-primary-green">
              {initialData ? 'Save Changes' : 'Create User'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default UserFormModal;