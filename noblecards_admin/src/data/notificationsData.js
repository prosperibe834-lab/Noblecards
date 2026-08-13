export const notificationStats = {
  total: 124500,
  sentToday: 1240,
  delivered: '98.5%',
  read: '76.2%',
  failed: 45,
  scheduled: 12,
  activeCampaigns: 3
};

export const mockNotifications = [
  { id: 'NT-004829', type: 'Promotion', title: 'Weekend Flash Sale!', audience: 'Nigeria, Ghana', channels: ['Push', 'Email'], status: 'Sent', sent: '2026-08-12 10:00 AM', delivered: '99%', read: '65%', createdBy: 'Admin' },
  { id: 'NT-004830', type: 'System', title: 'Scheduled Maintenance', audience: 'Everyone', channels: ['In-App'], status: 'Scheduled', sent: '2026-08-15 02:00 AM', delivered: '-', read: '-', createdBy: 'Admin' },
  { id: 'NT-004831', type: 'Gift Card', title: 'New Steam Rates', audience: 'Everyone', channels: ['Push'], status: 'Delivered', sent: '2026-08-10 09:30 AM', delivered: '98%', read: '80%', createdBy: 'System (Auto)' },
  { id: 'NT-004832', type: 'Holiday', title: 'Happy New Month', audience: 'Everyone', channels: ['Push', 'Email', 'In-App'], status: 'Sent', sent: '2026-08-01 08:00 AM', delivered: '97%', read: '70%', createdBy: 'System (Auto)' },
  { id: 'NT-004833', type: 'Engagement', title: 'We Miss You!', audience: 'Inactive (>6m)', channels: ['Email'], status: 'Sending', sent: '2026-08-13 01:00 PM', delivered: '-', read: '-', createdBy: 'System (Auto)' },
  { id: 'NT-004834', type: 'Transaction', title: 'Deposit Successful', audience: 'Specific User', channels: ['Push', 'In-App'], status: 'Delivered', sent: '2026-08-13 12:45 PM', delivered: '100%', read: '100%', createdBy: 'System (Auto)' },
  { id: 'NT-004835', type: 'Birthday', title: 'Happy Birthday! 🎂', audience: 'Daily Matches', channels: ['Push', 'Email', 'In-App'], status: 'Sent', sent: '2026-08-13 07:00 AM', delivered: '99%', read: '85%', createdBy: 'System (Auto)' },
  { id: 'NT-004836', type: 'Security', title: 'New Login Detected', audience: 'Specific User', channels: ['Email', 'In-App'], status: 'Delivered', sent: '2026-08-13 11:20 AM', delivered: '98%', read: '72%', createdBy: 'Security Team' }
];

export const mockStats = {
  total: 15420,
  sentToday: 124,
  deliveredRate: 98.5,
  readRate: 64.2,
  failed: 12,
  scheduled: 5,
  activeCampaigns: 2
};

// Mock automated triggers used by the admin UI toggles
export const automatedTriggers = [
  { id: 'TR-1001', label: 'Large Deposit Alert', group: 'Transactions', active: true },
  { id: 'TR-1002', label: 'Low Balance Reminder', group: 'Transactions', active: false },
  { id: 'TR-2001', label: 'Birthday Greeting', group: 'User Engagement', active: true },
  { id: 'TR-3001', label: 'Weekly Digest', group: 'Campaigns', active: false }
];