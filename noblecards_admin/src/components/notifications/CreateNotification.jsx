import React, { useState } from 'react';

export default function CreateNotification({ onSuccess }) {
  const [formData, setFormData] = useState({
    type: 'Announcement',
    title: '',
    message: '',
    audience: 'Everyone',
    country: '',
    channels: { inApp: true, push: false, email: false, sms: false },
    scheduleType: 'now',
    scheduleDate: ''
  });

  const [step, setStep] = useState(0); // 0: Form, 1: Confirm 1, 2: Confirm 2
  const [isSending, setIsSending] = useState(false);

  const mockAudienceCount = formData.audience === 'Everyone' ? 84291 : 
                            formData.audience === 'Nigeria' ? 42381 : 1240;

  const handleChannelToggle = (channel) => {
    setFormData(prev => ({
      ...prev, channels: { ...prev.channels, [channel]: !prev.channels[channel] }
    }));
  };

  const handleSend = () => {
    setIsSending(true);
    // Simulate backend API call to Laravel
    setTimeout(() => {
      setIsSending(false);
      setStep(0);
      setFormData({ type: 'Announcement', title: '', message: '', audience: 'Everyone', country: '', channels: { inApp: true, push: false, email: false, sms: false }, scheduleType: 'now', scheduleDate: '' });
      if(onSuccess) onSuccess();
    }, 1500);
  };

  return (
    <div className="nc-create-layout">
      {/* LEFT COL: Form */}
      <div className="nc-card">
        <h2 style={{ margin: '0 0 1.5rem' }}>Create Manual Campaign</h2>
        
        <div style={{ marginBottom: '1.5rem' }}>
          <label>Notification Type</label>
          <select className="nc-select" value={formData.type} onChange={(e) => setFormData({...formData, type: e.target.value})}>
            <option>Announcement</option>
            <option>Promotion</option>
            <option>Marketing</option>
            <option>System Update</option>
            <option>Maintenance</option>
          </select>
        </div>

        <div style={{ marginBottom: '1.5rem' }}>
          <label>Target Audience</label>
          <select className="nc-select" value={formData.audience} onChange={(e) => setFormData({...formData, audience: e.target.value})}>
            <option>Everyone</option>
            <option>Specific Users (CSV Upload)</option>
            <option value="Country">By Country</option>
          </select>
          {formData.audience === 'Country' && (
            <select className="nc-select" style={{ marginTop: '0.5rem' }} value={formData.country} onChange={(e) => setFormData({...formData, country: e.target.value})}>
              <option value="">Select Country...</option>
              <option>Nigeria</option>
              <option>Ghana</option>
              <option>Kenya</option>
              <option>United Kingdom</option>
            </select>
          )}
          <div style={{ marginTop: '0.5rem', fontSize: '0.875rem', color: 'var(--text-secondary)' }}>
            <i className='bx bx-user' style={{ marginRight: '4px' }}></i>
            Estimated Audience: <strong>{mockAudienceCount.toLocaleString()} users</strong>
          </div>
        </div>

        <div style={{ marginBottom: '1.5rem' }}>
          <label>Channels</label>
          <div style={{ display: 'flex', gap: '1rem', marginTop: '0.5rem', flexWrap: 'wrap' }}>
            {['inApp', 'push', 'email', 'sms'].map(ch => (
              <label key={ch} style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', cursor: 'pointer' }}>
                <input type="checkbox" checked={formData.channels[ch]} onChange={() => handleChannelToggle(ch)} />
                <span style={{ textTransform: 'capitalize' }}>{ch.replace(/([A-Z])/g, ' $1')}</span>
              </label>
            ))}
          </div>
        </div>

        <div style={{ marginBottom: '1.5rem' }}>
          <label>Title</label>
          <input className="nc-input" type="text" placeholder="E.g. Black Friday Sale!" value={formData.title} onChange={(e) => setFormData({...formData, title: e.target.value})} />
        </div>

        <div style={{ marginBottom: '1.5rem' }}>
          <label>Message</label>
          <textarea className="nc-textarea" rows="4" placeholder="Type your message here..." value={formData.message} onChange={(e) => setFormData({...formData, message: e.target.value})}></textarea>
        </div>

        <button className="nc-btn nc-btn-primary" style={{ width: '100%', justifyContent: 'center' }} onClick={() => setStep(1)} disabled={!formData.title || !formData.message}>
          <i className='bx bx-send'></i> Prepare Notification
        </button>
      </div>

      {/* RIGHT COL: Preview */}
      <div>
        <div className="nc-card" style={{ position: 'sticky', top: '2rem' }}>
          <h3 style={{ margin: '0 0 1.5rem', textAlign: 'center' }}>Live Preview</h3>
          <div className="nc-phone-preview">
            <div className="nc-phone-notch"></div>
            {/* The Notification Bubble */}
            {(formData.title || formData.message) && (
              <div className="nc-preview-toast">
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '8px' }}>
                  <div style={{ width: 24, height: 24, background: 'var(--primary-color)', borderRadius: 6, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                    <i className='bx bxs-bell-ring' style={{ color: '#fff', fontSize: '12px' }}></i>
                  </div>
                  <span style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', fontWeight: 600 }}>NobleCards</span>
                  <span style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', marginLeft: 'auto' }}>now</span>
                </div>
                <h4 style={{ margin: '0 0 4px', fontSize: '0.9rem' }}>{formData.title || 'Notification Title'}</h4>
                <p style={{ margin: 0, fontSize: '0.85rem', color: 'var(--text-secondary)', lineHeight: 1.4 }}>
                  {formData.message || 'Your message will appear here...'}
                </p>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* TWO-STEP CONFIRMATION MODALS */}
      {step > 0 && (
        <div className="nc-modal-overlay">
          <div className="nc-modal-content">
            {step === 1 ? (
              <>
                <h2 style={{ marginTop: 0 }}>Review Broadcast</h2>
                <p>You are about to send a <strong>{formData.type}</strong> notification to approximately <strong>{mockAudienceCount.toLocaleString()} users</strong>.</p>
                
                <div style={{ background: 'var(--bg-primary)', padding: '1rem', borderRadius: '8px', margin: '1.5rem 0' }}>
                  <p style={{ margin: '0 0 0.5rem' }}><strong>Title:</strong> {formData.title}</p>
                  <p style={{ margin: 0 }}><strong>Channels:</strong> {Object.keys(formData.channels).filter(k => formData.channels[k]).join(', ')}</p>
                </div>
                
                <div style={{ display: 'flex', gap: '1rem', justifyContent: 'flex-end' }}>
                  <button className="nc-btn nc-btn-outline" onClick={() => setStep(0)}>Cancel</button>
                  <button className="nc-btn nc-btn-primary" onClick={() => setStep(2)}>Continue to Confirm</button>
                </div>
              </>
            ) : (
              <>
                <div style={{ textAlign: 'center', color: 'var(--danger-color)', fontSize: '3rem', marginBottom: '1rem' }}>
                  <i className='bx bx-error-circle'></i>
                </div>
                <h2 style={{ marginTop: 0, textAlign: 'center' }}>Final Confirmation</h2>
                <p style={{ textAlign: 'center' }}>
                  This action <strong>cannot be undone</strong>. The message will be immediately queued for {mockAudienceCount.toLocaleString()} users.
                </p>
                
                <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', marginTop: '2rem' }}>
                  <button className="nc-btn nc-btn-outline" onClick={() => setStep(0)} disabled={isSending}>Cancel</button>
                  <button className="nc-btn nc-btn-primary" style={{ background: 'var(--danger-color)' }} onClick={handleSend} disabled={isSending}>
                    {isSending ? <><i className='bx bx-loader-alt bx-spin'></i> Sending...</> : 'Yes, Send Broadcast'}
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      )}
    </div>
  );
}