import React from 'react';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';

const data = [
  { name: 'W1', referrals: 35, qualified: 20 },
  { name: 'W2', referrals: 45, qualified: 30 },
  { name: 'W3', referrals: 30, qualified: 15 },
  { name: 'W4', referrals: 60, qualified: 40 },
  { name: 'W5', referrals: 75, qualified: 50 },
  { name: 'W6', referrals: 50, qualified: 35 },
  { name: 'W7', referrals: 90, qualified: 65 },
  { name: 'W8', referrals: 65, qualified: 45 },
  { name: 'W9', referrals: 80, qualified: 55 },
  { name: 'W10', referrals: 100, qualified: 75 },
  { name: 'W11', referrals: 85, qualified: 60 },
  { name: 'W12', referrals: 95, qualified: 70 },
];

const ReferralCharts = () => {
  return (
    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))', gap: '20px' }}>
      {/* Growth Trend Bar Chart */}
      <div style={{ background: 'var(--bg-card)', border: '1px solid var(--border-color)', borderRadius: '12px', padding: '20px' }}>
        <h3 style={{ fontSize: '16px', margin: '0 0 16px 0', color: 'var(--text-primary)' }}>Referral Growth & Conversions</h3>
        <div style={{ width: '100%', height: 220 }}>
          <ResponsiveContainer>
            <BarChart data={data}>
              <XAxis dataKey="name" stroke="var(--text-secondary)" fontSize={12} />
              <YAxis stroke="var(--text-secondary)" fontSize={12} />
              <Tooltip />
              <Bar dataKey="referrals" fill="var(--primary-color)" radius={[4, 4, 0, 0]} name="Total Referrals" />
              <Bar dataKey="qualified" fill="var(--success-color)" radius={[4, 4, 0, 0]} name="Qualified" />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Qualification Breakdown */}
      <div style={{ background: 'var(--bg-card)', border: '1px solid var(--border-color)', borderRadius: '12px', padding: '20px' }}>
        <h3 style={{ fontSize: '16px', margin: '0 0 20px 0', color: 'var(--text-primary)' }}>Qualification Breakdown</h3>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          {[
            { label: 'Qualified', value: '65%', colorVar: 'var(--success-color)' },
            { label: 'Qualification Pending', value: '25%', colorVar: 'var(--warning-color)' },
            { label: 'Flagged / Suspicious', value: '10%', colorVar: 'var(--danger-color)' },
          ].map((item, index) => (
            <div key={index}>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '13px', marginBottom: '6px' }}>
                <span>{item.label}</span>
                <strong>{item.value}</strong>
              </div>
              <div style={{ width: '100%', height: '8px', background: 'var(--bg-primary)', borderRadius: '4px', overflow: 'hidden' }}>
                <div style={{ width: item.value, height: '100%', background: item.colorVar }}></div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default ReferralCharts;