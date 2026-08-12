import React, { useState } from 'react';

const KYCDocumentModal = ({ document, applicant, onClose }) => {
  const [zoom, setZoom] = useState(1);
  const [rotation, setRotation] = useState(0);

  if (!document) return null;

  const handleZoomIn = () => setZoom(prev => Math.min(prev + 0.25, 2.5));
  const handleZoomOut = () => setZoom(prev => Math.max(prev - 0.25, 0.75));
  const handleRotate = () => setRotation(prev => (prev + 90) % 360);
  const handleReset = () => {
    setZoom(1);
    setRotation(0);
  };

  return (
    <div className="drawer-overlay" style={{ zIndex: 1100 }} onClick={onClose}>
      <div className="doc-modal-content" onClick={e => e.stopPropagation()}>
        <div className="drawer-header">
          <div>
            <h3 style={{ fontSize: '18px', margin: 0 }}>Document Inspector</h3>
            <p style={{ color: 'var(--text-secondary)', fontSize: '12px', margin: 0 }}>
              {document.type} — {applicant.fullName} ({applicant.userId})
            </p>
          </div>
          <button className="close-btn" onClick={onClose}>
            <i className='bx bx-x'></i>
          </button>
        </div>

        <div className="doc-inspector-body">
          {/* Viewport Area */}
          <div className="doc-preview-area">
            <div className="doc-controls">
              <button className="btn btn-outline" title="Zoom In" onClick={handleZoomIn}>
                <i className='bx bx-zoom-in'></i>
              </button>
              <button className="btn btn-outline" title="Zoom Out" onClick={handleZoomOut}>
                <i className='bx bx-zoom-out'></i>
              </button>
              <button className="btn btn-outline" title="Rotate" onClick={handleRotate}>
                <i className='bx bx-refresh'></i>
              </button>
              <button className="btn btn-outline" title="Reset View" onClick={handleReset}>
                Reset
              </button>
            </div>

            <div className="doc-image-viewport">
              <div 
                className="doc-image-container"
                style={{
                  transform: `scale(${zoom}) rotate(${rotation}deg)`,
                  transition: 'transform 0.2s ease-in-out'
                }}
              >
                {/* Mock Visual Document Card */}
                <div className="mock-doc-card">
                  <div className="mock-doc-header">
                    <i className='bx bx-id-card' style={{ fontSize: '32px', color: 'var(--primary-color)' }}></i>
                    <div>
                      <strong>{document.type.toUpperCase()}</strong>
                      <p style={{ fontSize: '11px', margin: 0 }}>REPUBLIC OF {applicant.country.toUpperCase()}</p>
                    </div>
                  </div>
                  <div className="mock-doc-body">
                    <div className="mock-photo">
                      <i className='bx bx-user' style={{ fontSize: '48px', color: 'var(--text-secondary)' }}></i>
                    </div>
                    <div className="mock-details">
                      <p><strong>NAME:</strong> {applicant.fullName.toUpperCase()}</p>
                      <p><strong>ID NO:</strong> {applicant.userId.replace('NC', 'DOC')}</p>
                      <p><strong>ISSUED:</strong> 2022-01-15</p>
                      <p><strong>EXPIRY:</strong> 2028-01-15</p>
                    </div>
                  </div>
                  <div className="mock-doc-footer">
                    <span className="barcode-stub">||||||||||||||||||||||||||||||||||||||||||||||||||</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Metadata Breakdown */}
          <div className="doc-metadata-panel">
            <h4 className="section-title" style={{ marginTop: 0 }}>Verification Breakdown</h4>
            
            <div className="info-item" style={{ marginBottom: '12px' }}>
              <label>Document Type</label>
              <p>{document.type}</p>
            </div>

            <div className="info-item" style={{ marginBottom: '12px' }}>
              <label>Status</label>
              <span className={`badge badge-${document.status === 'Verified' ? 'approved' : 'rejected'}`}>
                {document.status}
              </span>
            </div>

            <div className="info-item" style={{ marginBottom: '12px' }}>
              <label>Provider Verification Result</label>
              <p>{document.result}</p>
            </div>

            <h4 className="section-title">Automated Checks</h4>
            <ul className="doc-checks-list">
              <li>
                <i className='bx bx-check-circle' style={{ color: 'var(--success-color)' }}></i>
                <span>OCR Identity Match</span>
              </li>
              <li>
                <i className='bx bx-check-circle' style={{ color: 'var(--success-color)' }}></i>
                <span>Expiration Check Pass</span>
              </li>
              <li>
                <i className='bx bx-check-circle' style={{ color: 'var(--success-color)' }}></i>
                <span>Tamper / Alteration Check</span>
              </li>
              <li>
                <i className='bx bx-check-circle' style={{ color: 'var(--success-color)' }}></i>
                <span>Facial Match Verification</span>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
};

export default KYCDocumentModal;