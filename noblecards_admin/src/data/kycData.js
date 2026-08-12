export const kycData = [
  {
    id: 1,
    userId: "NC-004829",
    fullName: "John Doe",
    username: "@johndoe",
    email: "john@example.com",
    phone: "+234 801 234 5678",
    country: "Nigeria",
    level: "Level 2",
    documentType: "National ID",
    status: "Pending",
    risk: "Normal",
    submittedDate: "2026-08-12T10:30:00Z",
    updatedDate: "2026-08-12T10:30:00Z",
    provider: "SmileIdentity",
    reference: "SID-99283-JD",
    documents: [
      { type: "Front of Government ID", status: "Verified", result: "Match" },
      { type: "Back of Government ID", status: "Verified", result: "Match" },
      { type: "Selfie / Liveness", status: "Processing", result: "Pending" }
    ],
    timeline: [
      { event: "KYC Submitted", date: "2026-08-12T10:00:00Z" },
      { event: "Documents Uploaded", date: "2026-08-12T10:05:00Z" },
      { event: "Automated Verification Started", date: "2026-08-12T10:30:00Z" }
    ]
  },
  {
    id: 2,
    userId: "NC-009284",
    fullName: "Sarah Connor",
    username: "@sconnor",
    email: "sarah@example.com",
    phone: "+234 802 345 6789",
    country: "Ghana",
    level: "Level 3",
    documentType: "Passport",
    status: "Approved",
    risk: "Normal",
    submittedDate: "2026-08-10T14:20:00Z",
    updatedDate: "2026-08-11T09:15:00Z",
    provider: "Onfido",
    reference: "ONF-11223-SC",
    documents: [
      { type: "Passport", status: "Verified", result: "Clear" },
      { type: "Selfie / Liveness", status: "Verified", result: "Match" },
      { type: "Proof of Address", status: "Verified", result: "Accepted" }
    ],
    timeline: [
      { event: "KYC Submitted", date: "2026-08-10T14:20:00Z" },
      { event: "Automated Verification Completed", date: "2026-08-10T14:25:00Z" },
      { event: "Admin Review", date: "2026-08-11T09:10:00Z" },
      { event: "Approved", date: "2026-08-11T09:15:00Z" }
    ]
  },
  {
    id: 3,
    userId: "NC-001928",
    fullName: "Michael Smith",
    username: "@mikesmith",
    email: "mike@example.com",
    phone: "+1 555 123 4567",
    country: "USA",
    level: "Level 2",
    documentType: "Driver's License",
    status: "Needs Resubmission",
    risk: "Review",
    submittedDate: "2026-08-11T16:45:00Z",
    updatedDate: "2026-08-12T08:00:00Z",
    provider: "Jumio",
    reference: "JUM-77382-MS",
    documents: [
      { type: "Driver's License", status: "Failed", result: "Document unclear/blurred" },
      { type: "Selfie / Liveness", status: "Verified", result: "Match" }
    ],
    timeline: [
      { event: "KYC Submitted", date: "2026-08-11T16:45:00Z" },
      { event: "Automated Verification Failed", date: "2026-08-11T16:50:00Z" },
      { event: "Resubmission Requested", date: "2026-08-12T08:00:00Z" }
    ]
  },
  {
    id: 4,
    userId: "NC-008372",
    fullName: "David Osei",
    username: "@davidosei",
    email: "david.o@example.com",
    phone: "+233 24 123 4567",
    country: "Ghana",
    level: "Level 2",
    documentType: "National ID",
    status: "Under Review",
    risk: "High Risk",
    submittedDate: "2026-08-09T11:00:00Z",
    updatedDate: "2026-08-09T11:30:00Z",
    provider: "SmileIdentity",
    reference: "SID-88213-DO",
    documents: [
      { type: "Front of Government ID", status: "Verified", result: "Match" },
      { type: "Selfie / Liveness", status: "Failed", result: "Face Mismatch" }
    ],
    timeline: [
      { event: "KYC Submitted", date: "2026-08-09T11:00:00Z" },
      { event: "Flagged for High Risk", date: "2026-08-09T11:30:00Z" }
    ]
  },
  {
    id: 5,
    userId: "NC-005511",
    fullName: "Elena Rossi",
    username: "@elenar",
    email: "elena.rossi@example.com",
    phone: "+39 312 345 6789",
    country: "Italy",
    level: "Level 2",
    documentType: "Passport",
    status: "Processing",
    risk: "Normal",
    submittedDate: "2026-08-12T14:00:00Z",
    updatedDate: "2026-08-12T14:05:00Z",
    provider: "Onfido",
    reference: "ONF-99211-ER",
    documents: [
      { type: "Passport", status: "Processing", result: "Pending" },
      { type: "Selfie / Liveness", status: "Processing", result: "Pending" }
    ],
    timeline: [
      { event: "KYC Submitted", date: "2026-08-12T14:00:00Z" },
      { event: "Automated Verification Started", date: "2026-08-12T14:05:00Z" }
    ]
  },
  {
    id: 6,
    userId: "NC-007742",
    fullName: "Ahmed Ali",
    username: "@ahmeda",
    email: "ahmed@example.com",
    phone: "+254 712 345 678",
    country: "Kenya",
    level: "Level 1",
    documentType: "National ID",
    status: "Expired",
    risk: "Review",
    submittedDate: "2021-05-10T09:00:00Z",
    updatedDate: "2026-08-01T10:00:00Z",
    provider: "SmileIdentity",
    reference: "SID-11234-AA",
    documents: [
      { type: "National ID", status: "Expired", result: "Document Expired" }
    ],
    timeline: [
      { event: "KYC Approved", date: "2021-05-10T10:00:00Z" },
      { event: "Document Expired", date: "2026-08-01T10:00:00Z" }
    ]
  }
];