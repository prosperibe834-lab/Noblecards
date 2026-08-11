import React from 'react';

const UserSkeleton = () => {
  return (
    <div className="users-container">
      <div className="skeleton-box" style={{ height: '60px', width: '100%' }}></div>
      <div className="users-stats-grid">
        {[1, 2, 3, 4, 5].map((i) => (
          <div key={i} className="skeleton-box" style={{ height: '120px' }}></div>
        ))}
      </div>
      <div className="skeleton-box" style={{ height: '70px', width: '100%' }}></div>
      <div className="skeleton-box" style={{ height: '400px', width: '100%' }}></div>
    </div>
  );
};

export default UserSkeleton;