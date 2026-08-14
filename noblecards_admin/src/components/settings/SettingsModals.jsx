import React, { useState } from "react";

// --- 2-STEP CONFIRMATION MODAL ---
export const AdminConfirmationModal = ({ isOpen, onClose, onConfirm, admin, actionType }) => {
  const [step, setStep] = useState(1);
  const [deleteConfirmText, setDeleteConfirmText] = useState("");

  if (!isOpen || !admin) return null;

  const handleNext = () => setStep(2);
  
  const handleConfirm = () => {
    if (actionType === "delete" && deleteConfirmText !== "DELETE") return;
    onConfirm(admin, actionType);
    setStep(1);
    setDeleteConfirmText("");
  };

  const closeModal = () => {
    setStep(1);
    setDeleteConfirmText("");
    onClose();
  };

  return (
    <div className="settings-modal-overlay">
      <div className="settings-modal-content warning-modal">
        <div className="modal-header">
          <h3><i className="bx bx-error-alt warning-icon"></i> Confirm Action</h3>
          <button onClick={closeModal} className="close-btn"><i className="bx bx-x"></i></button>
        </div>
        
        <div className="modal-body">
          {step === 1 ? (
            <>
              <p>Are you sure you want to <strong>{actionType}</strong> this administrator?</p>
              <div className="admin-summary-box">
                <p><strong>Name:</strong> {admin.fullName}</p>
                <p><strong>Role:</strong> {admin.role}</p>
                <p><strong>ID:</strong> {admin.id}</p>
              </div>
            </>
          ) : (
            <>
              <p className="danger-text">
                This action is severe. It will immediately restrict or remove <strong>{admin.fullName}</strong>'s access to the NobleCards Admin Panel.
              </p>
              {actionType === "delete" && (
                <div className="form-group mt-3">
                  <label>Type <strong>DELETE</strong> to confirm:</label>
                  <input 
                    type="text" 
                    className="settings-input" 
                    value={deleteConfirmText}
                    onChange={(e) => setDeleteConfirmText(e.target.value)}
                    placeholder="DELETE"
                  />
                </div>
              )}
            </>
          )}
        </div>

        <div className="modal-footer">
          <button className="settings-btn-outline" onClick={closeModal}>Cancel</button>
          {step === 1 ? (
            <button className="settings-btn-danger" onClick={handleNext}>Continue</button>
          ) : (
            <button 
              className="settings-btn-danger" 
              onClick={handleConfirm}
              disabled={actionType === "delete" && deleteConfirmText !== "DELETE"}
            >
              Yes, {actionType.charAt(0).toUpperCase() + actionType.slice(1)} Admin
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

// --- ADMIN FORM MODAL ---
export const AdminFormModal = ({ isOpen, onClose, onSave }) => {
  const [formData, setFormData] = useState({ fullName: "", username: "", email: "", role: "Finance Admin" });

  if (!isOpen) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    onSave(formData);
    setFormData({ fullName: "", username: "", email: "", role: "Finance Admin" });
  };

  return (
    <div className="settings-modal-overlay">
      <div className="settings-modal-content">
        <div className="modal-header">
          <h3>Add Administrator</h3>
          <button onClick={onClose} className="close-btn"><i className="bx bx-x"></i></button>
        </div>
        <form onSubmit={handleSubmit}>
          <div className="modal-body">
            <div className="form-group">
              <label>Full Name</label>
              <input required type="text" className="settings-input" value={formData.fullName} onChange={e => setFormData({...formData, fullName: e.target.value})} />
            </div>
            <div className="form-group">
              <label>Email Address</label>
              <input required type="email" className="settings-input" value={formData.email} onChange={e => setFormData({...formData, email: e.target.value})} />
            </div>
            <div className="form-group">
              <label>Role</label>
              <select className="settings-input" value={formData.role} onChange={e => setFormData({...formData, role: e.target.value})}>
                <option value="Finance Admin">Finance Admin</option>
                <option value="Support Admin">Support Admin</option>
                <option value="KYC Admin">KYC Admin</option>
                <option value="Security Admin">Security Admin</option>
              </select>
            </div>
          </div>
          <div className="modal-footer">
            <button type="button" className="settings-btn-outline" onClick={onClose}>Cancel</button>
            <button type="submit" className="settings-btn-primary">Create Admin</button>
          </div>
        </form>
      </div>
    </div>
  );
};