// ==========================================
// NEW FILE
// File: src/components/security/SecuritySkeleton.jsx
// Purpose: Shimmer loading skeleton for smooth refresh state
// ==========================================

import React from "react";

export const SecuritySkeleton = () => {
  return (
    <div className="security-skeleton-wrapper">
      <div className="skeleton-grid">
        {[1, 2, 3, 4].map((n) => (
          <div key={n} className="skeleton-card shimmer"></div>
        ))}
      </div>

      <div className="skeleton-table-box shimmer"></div>

      <style>{`
        .security-skeleton-wrapper {
          display: flex;
          flex-direction: column;
          gap: 1.5rem;
        }

        .skeleton-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
          gap: 1rem;
        }

        .skeleton-card {
          height: 100px;
          border-radius: 12px;
          background-color: var(--bg-card);
          border: 1px solid var(--border-color);
        }

        .skeleton-table-box {
          height: 350px;
          border-radius: 12px;
          background-color: var(--bg-card);
          border: 1px solid var(--border-color);
        }

        .shimmer {
          background: linear-gradient(
            90deg,
            var(--bg-card) 0%,
            var(--bg-hover) 50%,
            var(--bg-card) 100%
          );
          background-size: 200% 100%;
          animation: shimmerAnim 1.5s infinite;
        }

        @keyframes shimmerAnim {
          0% { background-position: -200% 0; }
          100% { background-position: 200% 0; }
        }
      `}</style>
    </div>
  );
};