<%-- 
    Document   : sidebar
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<aside class="w-72 bg-white/90 backdrop-blur-sm border-r border-[#b5e5e0] shadow-lg h-screen sticky top-0 flex flex-col">
    <!-- sidebar header with logo / resort name - fixed at top -->
    <div class="px-6 pt-8 pb-6 border-b border-[#cdeae5] flex-shrink-0">
        <h1 class="text-2xl font-bold text-[#1e3c5c] flex items-center gap-2">
            <span class="text-3xl">🌊</span> 
            <span>Ocean<span class="text-[#03738C]">View</span></span>
        </h1>
        <p class="text-xs text-[#3a5a78] mt-1 tracking-wide">Ocean View Resort</p>
    </div>
    
    <!-- navigation menu - scrollable area -->
    <nav class="flex-1 overflow-y-auto p-4 space-y-1 scrollbar-thin scrollbar-thumb-[#b5e5e0] scrollbar-track-transparent">
        <!-- Dashboard -->
        <a href="dashboard.jsp" class="flex items-center gap-4 px-4 py-3.5 rounded-xl bg-[#b5e5e0]/30 text-[#03738C] font-medium sidebar-hover border border-[#9ac9c2]/30">
            <img src="https://cdn-icons-png.flaticon.com/128/6820/6820955.png" alt="dashboard" class="w-5 h-5">
            <span>Dashboard</span>
        </a>

        <!-- Manage Booked Details Dropdown -->
        <div x-data="{ open: false }" class="relative">
            <button @click="open = !open" class="w-full flex items-center justify-between gap-4 px-4 py-3.5 rounded-xl text-[#1e3c5c]/80 hover:bg-[#b5e5e0]/20 sidebar-hover">
                <div class="flex items-center gap-4">
                    <img src="https://cdn-icons-png.flaticon.com/128/1150/1150592.png" alt="manage booked" class="w-5 h-5">
                    <span>Booked Details</span>
                </div>
                <svg class="w-4 h-4 transition-transform" :class="{ 'rotate-180': open }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                </svg>
            </button>
            <div x-show="open" @click.away="open = false" class="ml-12 mt-1 space-y-1">
                <a href="bookroomdetails.jsp" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/5140/5140130.png" alt="rooms" class="w-4 h-4">
                    <span>Rooms</span>
                </a>
                <a href="booktabledetails.jsp" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/1012/1012472.png" alt="tables" class="w-4 h-4">
                    <span>Tables</span>
                </a>
                <a href="bookservicedetails.jsp" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/10871/10871960.png" alt="services" class="w-4 h-4">
                    <span>Services</span>
                </a>
            </div>
        </div>

        <!-- Manage Dropdown -->
        <div x-data="{ open: false }" class="relative">
            <button @click="open = !open" class="w-full flex items-center justify-between gap-4 px-4 py-3.5 rounded-xl text-[#1e3c5c]/80 hover:bg-[#b5e5e0]/20 sidebar-hover">
                <div class="flex items-center gap-4">
                    <img src="https://cdn-icons-png.flaticon.com/128/1085/1085822.png" alt="manage" class="w-5 h-5">
                    <span>Manage</span>
                </div>
                <svg class="w-4 h-4 transition-transform" :class="{ 'rotate-180': open }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                </svg>
            </button>
            <div x-show="open" @click.away="open = false" class="ml-12 mt-1 space-y-1">
                <a href="managerooms.jsp" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/5140/5140130.png" alt="rooms" class="w-4 h-4">
                    <span>Rooms</span>
                </a>
                <a href="managetables.jsp" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/1012/1012472.png" alt="tables" class="w-4 h-4">
                    <span>Tables</span>
                </a>
                <a href="manageservices.jsp" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/10871/10871960.png" alt="services" class="w-4 h-4">
                    <span>Services</span>
                </a>
            </div>
        </div>
        
        <!-- Basic things Dropdown -->
        <div x-data="{ open: false }" class="relative">
            <button @click="open = !open" class="w-full flex items-center justify-between gap-4 px-4 py-3.5 rounded-xl text-[#1e3c5c]/80 hover:bg-[#b5e5e0]/20 sidebar-hover">
                <div class="flex items-center gap-4">
                    <img src="https://cdn-icons-png.flaticon.com/128/8215/8215543.png" alt="manage" class="w-5 h-5">
                    <span>Basic things</span>
                </div>
                <svg class="w-4 h-4 transition-transform" :class="{ 'rotate-180': open }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                </svg>
            </button>
            <div x-show="open" @click.away="open = false" class="ml-12 mt-1 space-y-1">
                <a href="servicecategory.jsp" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/10871/10871960.png" alt="rooms" class="w-4 h-4">
                    <span>Service Category</span>
                </a>
                
                <a href="tablelocation.jsp" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/149/149059.png" alt="services" class="w-4 h-4">
                    <span>Table Locations</span>
                </a>
                <a href="roomtypes.jsp" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/5140/5140130.png" alt="tables" class="w-4 h-4">
                    <span>Room Types</span>
                </a>
                <a href="roles.jsp" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/8964/8964949.png" alt="services" class="w-4 h-4">
                    <span>Roles</span>
                </a>
                <a href="facility.jsp" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/3511/3511371.png" alt="services" class="w-4 h-4">
                    <span>Facilities</span>
                </a>
                <a href="blogcategory.jsp" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/6114/6114045.png" alt="services" class="w-4 h-4">
                    <span>Category</span>
                </a>
            </div>
        </div>

        <!-- Guests -->
        <a href="manageguests.jsp" class="flex items-center gap-4 px-4 py-3.5 rounded-xl text-[#1e3c5c]/80 hover:bg-[#b5e5e0]/20 sidebar-hover">
            <img src="https://cdn-icons-png.flaticon.com/128/2453/2453409.png" alt="guests" class="w-5 h-5">
            <span>Guests</span>
        </a>

        <!-- Staffs -->
        <a href="managestaffs.jsp" class="flex items-center gap-4 px-4 py-3.5 rounded-xl text-[#1e3c5c]/80 hover:bg-[#b5e5e0]/20 sidebar-hover">
            <img src="https://cdn-icons-png.flaticon.com/128/12105/12105197.png" alt="staffs" class="w-5 h-5">
            <span>Staffs</span>
        </a>

        <!-- Feedbacks -->
        <a href="managefeedback.jsp" class="flex items-center gap-4 px-4 py-3.5 rounded-xl text-[#1e3c5c]/80 hover:bg-[#b5e5e0]/20 sidebar-hover">
            <img src="https://cdn-icons-png.flaticon.com/128/11871/11871051.png" alt="feedbacks" class="w-5 h-5">
            <span>Feedbacks</span>
        </a>
        
        <!-- Contact Message -->
        <a href="contactmessage.jsp" class="flex items-center gap-4 px-4 py-3.5 rounded-xl text-[#1e3c5c]/80 hover:bg-[#b5e5e0]/20 sidebar-hover">
            <img src="https://cdn-icons-png.flaticon.com/128/9374/9374883.png" alt="feedbacks" class="w-5 h-5">
            <span>Contact Message</span>
        </a>

        <!-- Gallery -->
        <a href="managegallery.jsp" class="flex items-center gap-4 px-4 py-3.5 rounded-xl text-[#1e3c5c]/80 hover:bg-[#b5e5e0]/20 sidebar-hover">
            <img src="https://cdn-icons-png.flaticon.com/128/1375/1375106.png" alt="gallery" class="w-5 h-5">
            <span>Gallery</span>
        </a>

        <!-- Blogs -->
        <a href="manageblogs.jsp" class="flex items-center gap-4 px-4 py-3.5 rounded-xl text-[#1e3c5c]/80 hover:bg-[#b5e5e0]/20 sidebar-hover">
            <img src="https://cdn-icons-png.flaticon.com/128/6114/6114045.png" alt="blogs" class="w-5 h-5">
            <span>Blogs</span>
        </a>
        
        <!-- Extra bottom padding for scroll -->
        <div class="h-4"></div>
    </nav>

    <!-- bottom part: profile with name & role (fixed at bottom) -->
    <div class="p-5 border-t border-[#b5e5e0] flex-shrink-0 bg-white/90 backdrop-blur-sm">
        <div id="staffProfileSection">
            <a href="profile.jsp" class="flex items-center gap-3 mb-4 hover:bg-[#b5e5e0]/20 p-2 rounded-lg transition" id="profileLink">
                <img src="https://cdn-icons-png.flaticon.com/128/17123/17123222.png" alt="profile" class="w-10 h-10">
                <div id="staffInfo">
                    <p class="font-medium text-[#1e3c5c] text-sm" id="staffName">Loading...</p>
                    <p class="text-xs text-[#3a5a78]" id="staffRole">Staff</p>
                </div>
            </a>
            <button onclick="confirmLogout()" class="w-full flex items-center gap-3 text-[#03738C] hover:text-[#025c73] text-sm font-medium px-2 py-2 rounded-lg hover:bg-[#b5e5e0]/20 transition">
                <img src="https://cdn-icons-png.flaticon.com/128/6568/6568413.png" alt="logout" class="w-5 h-5">
                <span>Log out</span>
            </button>
        </div>
    </div>
    
    <!-- Custom scrollbar styles -->
    <style>
        .sidebar-hover { transition: background 0.2s ease, transform 0.1s; }
        .sidebar-hover:hover { background: rgba(2, 132, 168, 0.08); }
        
        /* Custom scrollbar for the sidebar */
        .scrollbar-thin::-webkit-scrollbar {
            width: 4px;
        }
        
        .scrollbar-thin::-webkit-scrollbar-track {
            background: transparent;
        }
        
        .scrollbar-thin::-webkit-scrollbar-thumb {
            background: #b5e5e0;
            border-radius: 20px;
        }
        
        .scrollbar-thin::-webkit-scrollbar-thumb:hover {
            background: #9ac9c2;
        }
        
        /* Firefox scrollbar */
        .scrollbar-thin {
            scrollbar-width: thin;
            scrollbar-color: #b5e5e0 transparent;
        }
    </style>
    
    <!-- Alpine.js for dropdown functionality -->
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    
    <!-- Staff info and logout script -->
    <script>
        // Set context path
        if (typeof window.contextPath === 'undefined') {
            window.contextPath = '${pageContext.request.contextPath}';
        }
        
        // Function to load staff info
        function loadStaffInfo() {
            const staffName = document.getElementById('staffName');
            const staffRole = document.getElementById('staffRole');
            
            // Get staff info from storage using unified keys
            const userName = localStorage.getItem('userName') || sessionStorage.getItem('userName');
            const userRole = localStorage.getItem('userRole') || sessionStorage.getItem('userRole');
            const userType = localStorage.getItem('userType') || sessionStorage.getItem('userType');
            
            console.log('Staff info loaded:', { userName, userRole, userType });
            
            // Only show if user is staff
            if (userType === 'staff') {
                if (userName) {
                    staffName.textContent = userName;
                } else {
                    staffName.textContent = 'Staff Member';
                }
                
                if (userRole) {
                    // Format role name (remove underscores, capitalize)
                    const formattedRole = userRole.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
                    staffRole.textContent = formattedRole;
                } else {
                    staffRole.textContent = 'Staff';
                }
            } else {
                // Not a staff member, but still show something
                staffName.textContent = 'Not logged in';
                staffRole.textContent = 'Guest';
            }
        }
        
        // Show logout confirmation modal (create modal if it doesn't exist)
        function confirmLogout() {
            // Check if modal already exists
            let modal = document.getElementById('logoutModal');
            
            if (!modal) {
                // Create modal element
                modal = document.createElement('div');
                modal.id = 'logoutModal';
                modal.className = 'fixed inset-0 bg-black/50 backdrop-blur-sm z-[99999] hidden items-center justify-center';
                modal.style.display = 'none';
                
                // Modal content
                modal.innerHTML = `
                    <div class="bg-white rounded-2xl shadow-2xl max-w-md w-full mx-4 p-6 transform transition-all">
                        <div class="flex items-center gap-4 mb-4">
                            <div class="w-12 h-12 bg-red-100 rounded-full flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                                </svg>
                            </div>
                            <div>
                                <h3 class="text-xl font-bold text-[#1e3c5c]">Confirm Logout</h3>
                                <p class="text-[#3a5a78] text-sm">Are you sure you want to log out?</p>
                            </div>
                        </div>
                        <div class="flex gap-3">
                            <button onclick="hideLogoutModal()" class="flex-1 px-4 py-2.5 border-2 border-[#b5e5e0] rounded-xl text-[#1e3c5c] font-medium hover:bg-[#f0f7fa] transition">
                                Cancel
                            </button>
                            <button onclick="handleStaffLogout()" class="flex-1 px-4 py-2.5 bg-gradient-to-r from-red-500 to-red-600 text-white rounded-xl font-medium hover:from-red-600 hover:to-red-700 transition shadow-lg flex items-center justify-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                                </svg>
                                Logout
                            </button>
                        </div>
                    </div>
                `;
                
                // Add click outside to close
                modal.addEventListener('click', function(e) {
                    if (e.target === modal) {
                        hideLogoutModal();
                    }
                });
                
                // Append to body
                document.body.appendChild(modal);
            }
            
            // Show modal
            modal.style.display = 'flex';
        }
        
        // Hide logout confirmation modal
        function hideLogoutModal() {
            const modal = document.getElementById('logoutModal');
            if (modal) {
                modal.style.display = 'none';
            }
        }
        
        // Handle staff logout (similar to navbar)
        function handleStaffLogout() {
            const token = localStorage.getItem('authToken') || sessionStorage.getItem('authToken');
            const userType = localStorage.getItem('userType') || sessionStorage.getItem('userType');
            
            console.log('Logging out staff...');
            
            // Hide modal first
            hideLogoutModal();
            
            if (token && userType === 'staff') {
                fetch(window.contextPath + '/staff/api/logout', {
                    method: 'POST',
                    headers: {
                        'Authorization': 'Bearer ' + token
                    }
                })
                .finally(() => {
                    // Clear all storage using unified keys
                    localStorage.removeItem('authToken');
                    localStorage.removeItem('userId');
                    localStorage.removeItem('userName');
                    localStorage.removeItem('userEmail');
                    localStorage.removeItem('userRegNo');
                    localStorage.removeItem('userType');
                    localStorage.removeItem('userRole');
                    localStorage.removeItem('userRoleId');
                    
                    sessionStorage.removeItem('authToken');
                    sessionStorage.removeItem('userId');
                    sessionStorage.removeItem('userName');
                    sessionStorage.removeItem('userEmail');
                    sessionStorage.removeItem('userRegNo');
                    sessionStorage.removeItem('userType');
                    sessionStorage.removeItem('userRole');
                    sessionStorage.removeItem('userRoleId');
                    
                    // Show success message if notification component exists
                    if (window.showSuccess) {
                        window.showSuccess('Logged out successfully', 2000);
                    }
                    
                    // Redirect to login page
                    setTimeout(() => {
                        window.location.href = window.contextPath + '/login.jsp';
                    }, 1500);
                });
            } else {
                // No token, just clear and redirect
                localStorage.clear();
                sessionStorage.clear();
                window.location.href = window.contextPath + '/login.jsp';
            }
        }
        
        // Load staff info when page loads
        document.addEventListener('DOMContentLoaded', function() {
            loadStaffInfo();
        });
        
        // Also load when page becomes visible (in case of navigation)
        document.addEventListener('visibilitychange', function() {
            if (!document.hidden) {
                loadStaffInfo();
            }
        });
        
        // Listen for storage changes (if user logs in/out in another tab)
        window.addEventListener('storage', function(e) {
            if (e.key === 'userName' || e.key === 'userRole' || e.key === 'userType') {
                loadStaffInfo();
            }
        });
    </script>
</aside>