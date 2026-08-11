import React, { useState } from 'react';
import { Outlet } from 'react-router-dom';
import Sidebar from '../components/Sidebar';
import Topbar from '../components/Topbar';

const AdminLayout = () => {
  const [isMobileSidebarOpen, setIsMobileSidebarOpen] = useState(false);

  const toggleMobileSidebar = () => {
    setIsMobileSidebarOpen(!isMobileSidebarOpen);
  };

  return (
    <div style={{ display: 'flex', minHeight: '100vh', width: '100%' }}>
      {/* Sidebar handles its own desktop vs mobile behavior based on props */}
      <Sidebar 
        isMobileOpen={isMobileSidebarOpen} 
        closeMobileSidebar={() => setIsMobileSidebarOpen(false)} 
      />
      
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', width: '100%', overflow: 'hidden' }}>
        {/* Pass the toggle function to Topbar so a hamburger icon can open it on mobile */}
        <Topbar toggleSidebar={toggleMobileSidebar} />
        
        {/* The main page content loads here */}
        <main style={{ flex: 1, padding: '24px', overflowY: 'auto' }}>
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default AdminLayout;