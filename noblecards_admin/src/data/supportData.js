export const mockTickets = [
  {
    id: 'NC-TKT-004829',
    userId: 'NC-U-8921',
    user: {
      name: 'John Doe',
      email: 'john.doe@email.com',
      phone: '+234 801 234 5678',
      country: 'Nigeria',
      gender: 'Male',
      kycStatus: 'Verified',
      balance: '$4,820.50',
      cards: 12,
      joined: '2026-05-12T10:30:00Z'
    },
    subject: 'Card verification pending for too long',
    category: 'Gift Card Verification',
    priority: 'Urgent',
    status: 'Open',
    assignedTo: 'Unassigned',
    createdAt: '2026-08-13T10:15:00Z',
    lastReplyAt: '2026-08-13T14:20:00Z',
    unread: true,
    transaction: {
      id: 'TXN-0092837',
      amount: '$1,200',
      method: 'Bank Transfer',
      status: 'Pending',
      date: '2026-08-13T09:00:00Z'
    },
    messages: [
      {
        id: 'msg-1',
        sender: 'User',
        senderName: 'John Doe',
        text: 'I purchased an Amazon gift card but my card has not been verified. The money has been deducted from my account.',
        timestamp: '2026-08-13T10:15:00Z',
        type: 'user'
      },
      {
        id: 'msg-2',
        sender: 'Support',
        senderName: 'System',
        text: 'Hello John, we have received your ticket and are checking this for you.',
        timestamp: '2026-08-13T10:20:00Z',
        type: 'support'
      },
      {
        id: 'msg-3',
        sender: 'Support',
        senderName: 'Admin',
        text: 'Checked the gateway logs. The transaction is stuck at the provider level. Escalating to payments team.',
        timestamp: '2026-08-13T10:25:00Z',
        type: 'note' // Internal Note
      },
      {
        id: 'msg-4',
        sender: 'User',
        senderName: 'John Doe',
        text: 'Any updates? I need this urgently for a purchase.',
        timestamp: '2026-08-13T14:20:00Z',
        type: 'user'
      }
    ]
  },
  {
    id: 'NC-TKT-004830',
    userId: 'NC-U-1120',
    user: {
      name: 'Sarah Smith',
      email: 'sarah.s@email.com',
      phone: '+234 812 345 6789',
      country: 'Nigeria',
      gender: 'Female',
      kycStatus: 'Pending',
      balance: '$150.00',
      cards: 2,
      joined: '2026-07-20T11:00:00Z'
    },
    subject: 'Withdrawal failed but balance reduced',
    category: 'Withdrawal Failed',
    priority: 'High',
    status: 'In Progress',
    assignedTo: 'Payments Team',
    createdAt: '2026-08-12T16:45:00Z',
    lastReplyAt: '2026-08-13T09:10:00Z',
    unread: false,
    transaction: {
      id: 'TXN-0092811',
      amount: '$300',
      method: 'Bank Transfer',
      status: 'Failed',
      date: '2026-08-12T16:00:00Z'
    },
    messages: [
      {
        id: 'msg-5',
        sender: 'User',
        senderName: 'Sarah Smith',
        text: 'My withdrawal failed but the money is gone from my wallet. Please help.',
        timestamp: '2026-08-12T16:45:00Z',
        type: 'user'
      },
      {
        id: 'msg-6',
        sender: 'Support',
        senderName: 'Admin',
        text: 'Hello Sarah, we apologize for the inconvenience. We have initiated a manual reversal. The funds should reflect in your wallet within 2-4 hours.',
        timestamp: '2026-08-13T09:10:00Z',
        type: 'support'
      }
    ]
  },
  {
    id: 'NC-TKT-004831',
    userId: 'NC-U-9943',
    user: {
      name: 'Michael Okonkwo',
      email: 'mike.o@email.com',
      phone: '+234 703 123 4567',
      country: 'Nigeria',
      gender: 'Male',
      kycStatus: 'Verified',
      balance: '$0.00',
      cards: 0,
      joined: '2026-08-10T14:00:00Z'
    },
    subject: 'How do I upgrade my account?',
    category: 'General Question',
    priority: 'Low',
    status: 'Resolved',
    assignedTo: 'Support Agent',
    createdAt: '2026-08-11T08:30:00Z',
    lastReplyAt: '2026-08-11T10:15:00Z',
    unread: false,
    transaction: null,
    messages: [
      {
        id: 'msg-7',
        sender: 'User',
        senderName: 'Michael Okonkwo',
        text: 'Hi, I want to increase my transaction limits. How do I do that?',
        timestamp: '2026-08-11T08:30:00Z',
        type: 'user'
      },
      {
        id: 'msg-8',
        sender: 'Support',
        senderName: 'Support Agent',
        text: 'Hello Michael, to increase your limits, please go to Settings > KYC Verification and upload your government-issued ID.',
        timestamp: '2026-08-11T09:00:00Z',
        type: 'support'
      },
      {
        id: 'msg-9',
        sender: 'User',
        senderName: 'Michael Okonkwo',
        text: 'Done! Thank you.',
        timestamp: '2026-08-11T10:15:00Z',
        type: 'user'
      }
    ]
  }
];

export const cannedResponses = [
  { id: 1, title: 'Withdrawal Pending', text: 'Hello {{name}}, your withdrawal is currently being processed. Depending on the banking network, it may take 2-24 hours to reflect. We will notify you once completed.' },
  { id: 2, title: 'Deposit Pending', text: 'Hello {{name}}, your deposit is currently being verified by our payment partners. This usually takes 5-15 minutes.' },
  { id: 3, title: 'KYC Under Review', text: 'Hello {{name}}, your KYC documents have been received and are currently under review by our compliance team.' },
  { id: 4, title: 'Gift Card Verification', text: 'Hello {{name}}, your gift card is currently being verified. Please ensure the card code is correct and the card is fully activated.' },
  { id: 5, title: 'General Greeting', text: 'Hello {{name}}, thank you for contacting NobleCards Support. How can we assist you today?' }
];