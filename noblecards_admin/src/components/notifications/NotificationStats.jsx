import React from 'react';

const NotificationStats = ({ stats }) => {
  const statCards = [
    { title: 'Sent Today', value: stats.sentToday, icon: 'bx-send', color: 'var(--primary-color)' },
    { title: 'Delivered Rate', value: `${stats.deliveredRate}%`, icon: 'bx-check-double', color: 'var(--success-color)' },
    { title: 'Read Rate', value: `${stats.readRate}%`, icon: 'bx-envelope-open', color: 'var(--info-color)' },
    { title: 'Scheduled / Active', value: `${stats.scheduled} / ${stats.activeCampaigns}`, icon: 'bx-calendar-event', color: 'var(--warning-color)' }
  ];

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
      {statCards.map((stat, index) => (
        <div key={index} className="flex items-center p-5 rounded-xl border" style={{ backgroundColor: 'var(--bg-card)', borderColor: 'var(--border-color)' }}>
          <div className="w-12 h-12 rounded-full flex items-center justify-center mr-4" style={{ backgroundColor: `${stat.color}20`, color: stat.color }}>
            <i className={`bx ${stat.icon} text-2xl`}></i>
          </div>
          <div>
            <h4 className="text-sm font-medium mb-1" style={{ color: 'var(--text-secondary)' }}>{stat.title}</h4>
            <p className="text-xl font-bold" style={{ color: 'var(--text-primary)' }}>{stat.value}</p>
          </div>
        </div>
      ))}
    </div>
  );
};

export default NotificationStats;