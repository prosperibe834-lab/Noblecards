import React, { useState } from 'react';
import KYCDocumentModal from './KYCDocumentModal';

const KYCReviewDrawer = ({ application, onClose, onApprove, onReject, onResubmit }) => {
  const [loadingAction, setLoadingAction] = useState(null);
  const [selectedDoc, setSelectedDoc] = useState(null);

  if (!application) return null;

  const handleAction = (type) => {
    if(window.confirm(`Are you sure you want to ${type} this KYC application?`)) {
      setLoadingAction(type);
      setTimeout(() => {
        if(type === 'Approve') onApprove(application.id);
        if(type === 'Reject') onReject(application.id);
        if(type === 'Request Resubmission') onResubmit(application.id);
        setLoadingAction(null);
        onClose();
      }, 800);
    }
  };

  return (
    <>
      <div className="drawer-overlay" onClick={onClose}>
        <div className="drawer-content" onClick={e => e.stopPropagation()}>
          <div className="drawer-header">
            <div>
              <h2 style={{ fontSize: '20px', marginBottom: '4px' }}>KYC Review</h2>
              <p style={{ color: 'var(--text-secondary)', fontSize: '13px' }}>ID: {application.userId}</p>
            </div>
            <button className="close-btn" onClick={onClose}>
              <i className='bx bx-x'></i>
            </button>
          </div>

          <h3 className="section-title">Applicant Information</h3>
          <div className="info-grid">
            <div className="info-item">
              <label>Full Name</label>
              <p>{application.fullName}</p>
            </div>
            <div className="info-item">
              <label>Username</label>
              <p>{application.username}</p>
            </div>
            <div className="info-item">
              <label>Email Address</label>
              <p>{application.email}</p>
            </div>
            <div className="info-item">
              <label>Phone Number</label>
              <p>{application.phone}</p>
            </div>
            <div className="info-item">
              <label>Country</label>
              <p>{application.country}</p>
            </div>
            <div className="info-item">
              <label>Verification Level</label>
              <p>{application.level}</p>
            </div>
          </div>

          <h3 className="section-title">Verification Details</h3>
          <div className="info-grid">
            <div className="info-item">
              <label>Provider</label>
              <p>{application.provider}</p>
            </div>
            <div className="info-item">
              <label>Reference</label>
              <p>{application.reference}</p>
            </div>
            <div className="info-item">
              <label>Status</label>
              <span className={`badge badge-${application.status.toLowerCase().replace(' ', '-')}`}>
                {application.status}
              </span>
            </div>
            <div className="info-item">
              <label>Risk Indicator</label>
              <span className={`badge badge-${application.risk === 'Normal' ? 'approved' : 'rejected'}`}>
                {application.risk}
              </span>
            </div>
          </div>

          <h3 className="section-title">Documents Provided</h3>
          {application.documents.map((doc, idx) => (
            <div key={idx} className="doc-preview">
              <div className="doc-info">
                <h5>{doc.type}</h5>
                <p>Status: {doc.status} | Result: {doc.result}</p>
              </div>
              <button 
                className="btn btn-outline" 
                style={{ padding: '6px 12px', fontSize: '12px' }}
                onClick={() => setSelectedDoc(doc)}
              >
                <i className='bx bx-search-alt-2'></i> Inspect
              </button>
            </div>
          ))}

          <h3 className="section-title">Audit Trail & Timeline</h3>
          <div className="timeline">
            {application.timeline.map((event, idx) => (
              <div key={idx} className="timeline-item">
                <h5>{event.event}</h5>
                <p>{new Date(event.date).toLocaleString()}</p>
              </div>
            ))}
          </div>

          <div className="drawer-actions">
            <button className="btn btn-success" onClick={() => handleAction('Approve')} disabled={loadingAction}>
              <i className='bx bx-check-circle'></i> 
              {loadingAction === 'Approve' ? 'Processing...' : 'Approve KYC'}
            </button>
            <button className="btn btn-danger" onClick={() => handleAction('Reject')} disabled={loadingAction}>
              <i className='bx bx-x-circle'></i> 
              {loadingAction === 'Reject' ? 'Processing...' : 'Reject'}
            </button>
            <button className="btn btn-outline" onClick={() => handleAction('Request Resubmission')} disabled={loadingAction}>
              <i className='bx bx-refresh'></i> 
              {loadingAction === 'Request Resubmission' ? 'Processing...' : 'Request Resubmission'}
            </button>
          </div>
        </div>
      </div>

      {/* Inspect Document Modal */}
      {selectedDoc && (
        <KYCDocumentModal 
          document={selectedDoc} 
          applicant={application} 
          onClose={() => setSelectedDoc(null)} 
        />
      )}
    </>
  );
};

export default KYCReviewDrawer;