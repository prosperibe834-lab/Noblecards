import React, { useState } from 'react';
import { automatedTriggers } from '../../data/notificationsData';

export default function AutomatedSettings() {
  const [triggers, setTriggers] = useState(automatedTriggers);

  const toggleTrigger = (id) => {
    setTriggers(triggers.map(t => t.id === id ? { ...t, active: !t.active } : t));
    // In production: Make API call to Laravel backend to update trigger status
  };

  const groupedTriggers = triggers.reduce((acc, curr) => {
    if (!acc[curr.group]) acc[curr.group] = [];
    acc[curr.group].push(curr);
    return acc;
  }, {});

  return (
    <div className="nc-card fade-in">
      <div style={{ marginBottom: '2rem' }}>
        <h2 style={{ margin: '0 0 0.5rem' }}>Automated System Notifications</h2>
        <p style={{ color: 'var(--text-secondary)', margin: 0 }}>
          Manage notifications triggered automatically by the backend system (e.g., Transactions, Birthdays).
        </p>
      </div>

      {Object.entries(groupedTriggers).map(([group, items]) => (
        <div key={group} style={{ marginBottom: '2rem' }}>
          <h3 style={{ fontSize: '1.1rem', color: 'var(--text-secondary)', borderBottom: '1px solid var(--border-color)', paddingBottom: '0.5rem' }}>
            <i className='bx bx-layer' style={{ marginRight: '8px' }}></i>
            {group}
          </h3>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))', gap: '1rem', marginTop: '1rem' }}>
            {items.map(item => (
              <div key={item.id} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '1rem', background: 'var(--bg-primary)', borderRadius: '8px', border: '1px solid var(--border-color)' }}>
                <div>
                  <h4 style={{ margin: '0 0 0.25rem', fontSize: '1rem' }}>{item.label}</h4>
                  <span style={{ fontSize: '0.8rem', color: 'var(--text-secondary)' }}>Automated by Laravel Queue</span>
                </div>
                {/* Custom Toggle Switch using theme variables */}
                <div 
                  onClick={() => toggleTrigger(item.id)}
                  style={{
                    width: '44px', height: '24px', borderRadius: '12px',
                    background: item.active ? 'var(--primary-green)' : 'var(--border-color)',
                    position: 'relative', cursor: 'pointer', transition: 'background 0.3s'
                  }}
                >
                  <div style={{
                    width: '18px', height: '18px', background: '#fff', borderRadius: '50%',
                    position: 'absolute', top: '3px', left: item.active ? '23px' : '3px',
                    transition: 'left 0.3s', boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
                  }} />
                </div>
              </div>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}