import React, { useState, useEffect, useRef } from 'react';
import { cannedResponses } from '../../data/supportData';

export default function SupportTicketDrawer({ ticket, onClose, onUpdateTicket }) {
  const [message, setMessage] = useState('');
  const [isInternalNote, setIsInternalNote] = useState(false);
  const [isSending, setIsSending] = useState(false);
  const [attachment, setAttachment] = useState(null);
  
  // States for ticket details changes
  const [status, setStatus] = useState(ticket.status);
  const [priority, setPriority] = useState(ticket.priority);
  const [assignedTo, setAssignedTo] = useState(ticket.assignedTo);

  const messagesEndRef = useRef(null);

  // Auto-scroll to bottom of messages
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [ticket.messages]);

  const handleSend = () => {
    if (!message.trim() && !attachment) return;
    setIsSending(true);

    // Mock API delay
    setTimeout(() => {
      const newMessage = {
        id: `msg-${Date.now()}`,
        sender: 'Support',
        senderName: 'Admin Agent',
        text: message,
        timestamp: new Date().toISOString(),
        type: isInternalNote ? 'note' : 'support'
      };

      onUpdateTicket(ticket.id, {
        messages: [...ticket.messages, newMessage],
        lastReplyAt: newMessage.timestamp,
        status: status === 'Resolved' || status === 'Closed' ? 'Open' : status // Reopen if they reply to closed
      });

      setMessage('');
      setAttachment(null);
      setIsInternalNote(false);
      setIsSending(false);
    }, 600);
  };

  const handleStatusChange = (newStatus) => {
    if (window.confirm(`Are you sure you want to change status to ${newStatus}?`)) {
      setStatus(newStatus);
      onUpdateTicket(ticket.id, { status: newStatus });
    }
  };

  return (
    <div className="nc-drawer-overlay" onClick={onClose}>
      <div className="nc-drawer" onClick={e => e.stopPropagation()}>
        {/* Header */}
        <div className="nc-drawer-header">
          <div>
            <h2 style={{ margin: '0 0 0.25rem', fontSize: '1.25rem' }}>{ticket.subject}</h2>
            <div style={{ display: 'flex', gap: '1rem', fontSize: '0.85rem', color: 'var(--text-secondary)' }}>
              <span>ID: {ticket.id}</span>
              <span>Category: {ticket.category}</span>
            </div>
          </div>
          <div style={{ display: 'flex', gap: '1rem', alignItems: 'center' }}>
            <span className={`nc-badge ${ticket.status.toLowerCase().replace(' ', '-')}`}>{ticket.status}</span>
            <span className={`nc-badge ${ticket.priority.toLowerCase()}`}>{ticket.priority}</span>
            <button className="nc-btn nc-btn-outline" onClick={onClose} style={{ padding: '0.4rem' }}>
              <i className='bx bx-x' style={{ fontSize: '1.5rem' }}></i>
            </button>
          </div>
        </div>

        {/* Body */}
        <div className="nc-drawer-body">
          {/* Main Conversation Area */}
          <div className="nc-conversation-area">
            <div className="nc-messages-list">
              {ticket.messages.map((msg) => (
                <div key={msg.id} className={`nc-message ${msg.type}`}>
                  {msg.type === 'note' && <div style={{ fontSize: '0.75rem', fontWeight: 'bold', color: 'var(--warning-color)', marginBottom: '4px' }}><i className='bx bx-lock-alt'></i> INTERNAL NOTE</div>}
                  <div className="nc-message-bubble">
                    {msg.text}
                  </div>
                  <div className="nc-message-meta">
                    <span>{msg.senderName}</span>
                    <span>•</span>
                    <span>{new Date(msg.timestamp).toLocaleString()}</span>
                  </div>
                </div>
              ))}
              <div ref={messagesEndRef} />
            </div>

            {/* Composer */}
            <div className="nc-composer">
              {attachment && (
                <div style={{ display: 'inline-flex', alignItems: 'center', gap: '0.5rem', background: 'var(--bg-primary)', padding: '0.5rem', borderRadius: '4px', marginBottom: '1rem', fontSize: '0.85rem' }}>
                  <i className='bx bx-file'></i> {attachment.name}
                  <i className='bx bx-x' style={{ cursor: 'pointer', color: 'var(--danger-color)' }} onClick={() => setAttachment(null)}></i>
                </div>
              )}
              
              <textarea 
                className="nc-composer-textarea" 
                placeholder={isInternalNote ? "Type an internal note (users won't see this)..." : "Type your reply to the user..."}
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                style={{ borderColor: isInternalNote ? 'var(--warning-color)' : '' }}
              />
              
              <div className="nc-composer-actions">
                <div style={{ display: 'flex', gap: '1rem', alignItems: 'center' }}>
                  <label style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', cursor: 'pointer', fontSize: '0.9rem' }}>
                    <input type="file" style={{ display: 'none' }} onChange={(e) => setAttachment(e.target.files[0])} />
                    <i className='bx bx-paperclip' style={{ fontSize: '1.25rem', color: 'var(--text-secondary)' }}></i> Attach
                  </label>
                  
                  <select 
                    className="nc-support-select" 
                    style={{ width: '180px', padding: '0.4rem', fontSize: '0.85rem' }}
                    onChange={(e) => {
                      if(e.target.value) {
                        const canned = cannedResponses.find(r => r.id == e.target.value);
                        if(canned) setMessage(canned.text.replace('{{name}}', ticket.user.name));
                        e.target.value = '';
                      }
                    }}
                  >
                    <option value="">Canned Responses...</option>
                    {cannedResponses.map(r => <option key={r.id} value={r.id}>{r.title}</option>)}
                  </select>

                  <label style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', cursor: 'pointer', fontSize: '0.9rem', color: 'var(--warning-color)', fontWeight: '600' }}>
                    <input type="checkbox" checked={isInternalNote} onChange={(e) => setIsInternalNote(e.target.checked)} />
                    Internal Note
                  </label>
                </div>
                
                <button 
                  className="nc-btn nc-btn-primary" 
                  onClick={handleSend}
                  disabled={isSending || (!message.trim() && !attachment)}
                >
                  {isSending ? <><i className='bx bx-loader-alt bx-spin'></i> Sending...</> : <><i className='bx bx-send'></i> Send Reply</>}
                </button>
              </div>
            </div>
          </div>

          {/* Right Sidebar Details */}
          <div className="nc-details-area">
            {/* Ticket Management */}
            <div className="nc-side-card">
              <h4><i className='bx bx-slider'></i> Manage Ticket</h4>
              
              <div style={{ marginBottom: '1rem' }}>
                <label style={{ display: 'block', fontSize: '0.85rem', color: 'var(--text-secondary)', marginBottom: '0.5rem' }}>Status</label>
                <select className="nc-support-select" value={status} onChange={(e) => handleStatusChange(e.target.value)}>
                  <option value="Open">Open</option>
                  <option value="Pending">Pending</option>
                  <option value="In Progress">In Progress</option>
                  <option value="Waiting for User">Waiting for User</option>
                  <option value="Resolved">Resolved</option>
                  <option value="Closed">Closed</option>
                </select>
              </div>

              <div style={{ marginBottom: '1rem' }}>
                <label style={{ display: 'block', fontSize: '0.85rem', color: 'var(--text-secondary)', marginBottom: '0.5rem' }}>Priority</label>
                <select className="nc-support-select" value={priority} onChange={(e) => {
                  setPriority(e.target.value);
                  onUpdateTicket(ticket.id, { priority: e.target.value });
                }}>
                  <option value="Low">Low</option>
                  <option value="Normal">Normal</option>
                  <option value="High">High</option>
                  <option value="Urgent">Urgent</option>
                </select>
              </div>

              <div style={{ marginBottom: '1rem' }}>
                <label style={{ display: 'block', fontSize: '0.85rem', color: 'var(--text-secondary)', marginBottom: '0.5rem' }}>Assign To</label>
                <select className="nc-support-select" value={assignedTo} onChange={(e) => {
                  setAssignedTo(e.target.value);
                  onUpdateTicket(ticket.id, { assignedTo: e.target.value });
                }}>
                  <option value="Unassigned">Unassigned</option>
                  <option value="Support Agent">Support Agent</option>
                  <option value="Payments Team">Payments Team</option>
                  <option value="KYC Team">KYC Team</option>
                  <option value="Admin">Admin</option>
                </select>
              </div>

              {status !== 'Resolved' && status !== 'Closed' && (
                <button className="nc-btn nc-btn-outline" style={{ width: '100%', color: 'var(--success-color)', borderColor: 'var(--success-color)' }} onClick={() => handleStatusChange('Resolved')}>
                  <i className='bx bx-check-circle'></i> Mark as Resolved
                </button>
              )}
            </div>

            {/* User Info */}
            <div className="nc-side-card">
              <h4><i className='bx bx-user'></i> User Details</h4>
              <div className="nc-detail-row"><span>Name:</span> <span>{ticket.user.name}</span></div>
              <div className="nc-detail-row"><span>User ID:</span> <span>{ticket.userId}</span></div>
              <div className="nc-detail-row"><span>Email:</span> <span>{ticket.user.email}</span></div>
              <div className="nc-detail-row"><span>Phone:</span> <span>{ticket.user.phone}</span></div>
              <div className="nc-detail-row"><span>Country:</span> <span>{ticket.user.country}</span></div>
              <div className="nc-detail-row">
                <span>KYC:</span> 
                <span style={{ color: ticket.user.kycStatus === 'Verified' ? 'var(--success-color)' : 'var(--warning-color)' }}>{ticket.user.kycStatus}</span>
              </div>
              <div className="nc-detail-row"><span>Balance:</span> <span style={{ fontWeight: 'bold' }}>{ticket.user.balance}</span></div>
              <button className="nc-btn nc-btn-outline" style={{ width: '100%', marginTop: '1rem', fontSize: '0.85rem' }}>View Full Profile</button>
            </div>

            {/* Related Transaction */}
            <div className="nc-side-card">
              <h4><i className='bx bx-receipt'></i> Related Transaction</h4>
              {ticket.transaction ? (
                <>
                  <div className="nc-detail-row"><span>TXN ID:</span> <span>{ticket.transaction.id}</span></div>
                  <div className="nc-detail-row"><span>Amount:</span> <span>{ticket.transaction.amount}</span></div>
                  <div className="nc-detail-row"><span>Method:</span> <span>{ticket.transaction.method}</span></div>
                  <div className="nc-detail-row"><span>Date:</span> <span>{new Date(ticket.transaction.date).toLocaleDateString()}</span></div>
                  <div className="nc-detail-row">
                    <span>Status:</span> 
                    <span className={`nc-badge ${ticket.transaction.status.toLowerCase()}`}>{ticket.transaction.status}</span>
                  </div>
                  <button className="nc-btn nc-btn-outline" style={{ width: '100%', marginTop: '1rem', fontSize: '0.85rem' }}>View Transaction</button>
                </>
              ) : (
                <div style={{ textAlign: 'center', color: 'var(--text-secondary)', padding: '1rem 0', fontSize: '0.9rem' }}>
                  No related transaction linked to this ticket.
                </div>
              )}
            </div>

          </div>
        </div>
      </div>
    </div>
  );
}