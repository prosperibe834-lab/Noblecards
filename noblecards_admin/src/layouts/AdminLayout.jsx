import React, { useState } from 'react';
import { Outlet } from 'react-router-dom';
import Sidebar from '../components/Sidebar';
import Topbar from '../components/Topbar';
import '../styles/layout.css';

const AdminLayout = () => {
  const [isMobileSidebarOpen, setIsMobileSidebarOpen] = useState(false);

  const toggleMobileSidebar = () => {
    setIsMobileSidebarOpen(!isMobileSidebarOpen);
  };

  return (
    <div className="admin-layout">
      <Sidebar 
        isMobileOpen={isMobileSidebarOpen} 
        closeMobileSidebar={() => setIsMobileSidebarOpen(false)} 
      />
      
      <div className="admin-layout-main">
        <Topbar toggleSidebar={toggleMobileSidebar} />
        
        <main className="admin-layout-content">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default AdminLayout;