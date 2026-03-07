<%-- 
    Document   : navbar
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- ===== NAVBAR COMPONENT ===== -->
<header class="fixed top-0 left-0 w-full bg-white/90 backdrop-blur-sm shadow-sm z-50 border-b border-[#b5e5e0]/30">
    <div class="max-w-7xl mx-auto px-6 md:px-10 py-4 flex items-center justify-between">
        <!-- Logo / name (left side) -->
        <a href="index.jsp" class="flex items-center gap-2">
            <div class="w-8 h-8 bg-gradient-to-br from-[#0284a8] to-[#9ac9c2] rounded-lg flex items-center justify-center text-white font-bold text-xl shadow-md">🌊</div>
            <span class="font-semibold text-xl tracking-tight text-[#1e3c5c]">Ocean View <span class="text-[#0284a8]">Resort</span></span>
        </a>
        
        <!-- desktop nav (center) -->
        <nav class="flex items-center gap-6 text-sm font-medium text-[#1e3c5c] relative z-50">
            <a href="index.jsp" class="hover:text-[#0284a8] transition px-2 py-1 rounded-lg hover:bg-[#b5e5e0]/20 font-semibold whitespace-nowrap">Home</a>
            
            <!-- Book Now Dropdown -->
            <div class="relative group">
                <button class="flex items-center gap-1 hover:text-[#0284a8] transition px-2 py-1 rounded-lg hover:bg-[#b5e5e0]/20 font-semibold whitespace-nowrap">
                    <span>📅 Book Now</span>
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                    </svg>
                </button>
                <!-- Dropdown menu -->
                <div class="absolute left-0 mt-2 w-64 bg-white rounded-xl shadow-xl border border-[#b5e5e0] opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 z-[100]">
                    <div class="py-2">
                        <a href="bookroom.jsp" class="flex items-center gap-3 px-4 py-3 hover:bg-[#f0f7fa] transition">
                            <span class="text-[#0284a8] text-xl">🏨</span>
                            <div>
                                <div class="font-semibold text-[#1e3c5c]">Room Reservation</div>
                                <div class="text-xs text-[#3a5a78]">Book your perfect stay</div>
                            </div>
                        </a>
                        <div class="border-t border-[#b5e5e0]/30 my-1"></div>
                        <a href="booktable.jsp" class="flex items-center gap-3 px-4 py-3 hover:bg-[#f0f7fa] transition">
                            <span class="text-[#d4a373] text-xl">🍽️</span>
                            <div>
                                <div class="font-semibold text-[#1e3c5c]">Dine In</div>
                                <div class="text-xs text-[#3a5a78]">Reserve your table</div>
                            </div>
                        </a>
                        <div class="border-t border-[#b5e5e0]/30 my-1"></div>
                        <a href="bookservice.jsp" class="flex items-center gap-3 px-4 py-3 hover:bg-[#f0f7fa] transition">
                            <span class="text-[#03738C] text-xl">💆</span>
                            <div>
                                <div class="font-semibold text-[#1e3c5c]">Book a Service</div>
                                <div class="text-xs text-[#3a5a78]">Spa, tours & activities</div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            
            <a href="service.jsp" class="hover:text-[#0284a8] transition px-2 py-1 rounded-lg hover:bg-[#b5e5e0]/20 font-semibold whitespace-nowrap">Services</a>
            
            <!-- Stories & Moments Dropdown -->
            <div class="relative group">
                <button class="flex items-center gap-1 hover:text-[#0284a8] transition px-2 py-1 rounded-lg hover:bg-[#b5e5e0]/20 font-semibold whitespace-nowrap">
                    <span>📸 Stories & Moments</span>
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                    </svg>
                </button>
                <!-- Dropdown menu -->
                <div class="absolute left-0 mt-2 w-56 bg-white rounded-xl shadow-xl border border-[#b5e5e0] opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 z-[100]">
                    <div class="py-2">
                        <a href="gallery.jsp" class="flex items-center gap-3 px-4 py-3 hover:bg-[#f0f7fa] transition">
                            <span class="text-[#0284a8] text-xl">🖼️</span>
                            <div>
                                <div class="font-semibold text-[#1e3c5c]">Gallery</div>
                                <div class="text-xs text-[#3a5a78]">Photos & memories</div>
                            </div>
                        </a>
                        <div class="border-t border-[#b5e5e0]/30 my-1"></div>
                        <a href="blog.jsp" class="flex items-center gap-3 px-4 py-3 hover:bg-[#f0f7fa] transition">
                            <span class="text-[#d4a373] text-xl">📝</span>
                            <div>
                                <div class="font-semibold text-[#1e3c5c]">Blogs</div>
                                <div class="text-xs text-[#3a5a78]">Stories & updates</div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            
            <a href="contact.jsp" class="hover:text-[#0284a8] transition px-2 py-1 rounded-lg hover:bg-[#b5e5e0]/20 font-semibold whitespace-nowrap">Contact</a>
        </nav>
        
        <!-- User Menu (right side) -->
        <div id="userMenu" class="relative">
            <!-- This will be populated by JavaScript -->
        </div>
    </div>
</header>
<!-- Spacer for fixed navbar -->
<div class="h-20"></div>

<style>
    /* Cover effect integration */
    nav a, nav button {
        position: relative;
        overflow: hidden;
    }
    
    nav a::after, nav button::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 0;
        height: 2px;
        background: linear-gradient(to right, #0284a8, #9ac9c2);
        transition: width 0.3s ease;
    }
    
    nav a:hover::after, nav button:hover::after {
        width: 70%;
    }
    
    /* Dropdown animation */
    .group:hover .group-hover\:opacity-100 {
        animation: slideDown 0.3s ease;
    }
    
    @keyframes slideDown {
        0% {
            opacity: 0;
            transform: translateY(-10px);
        }
        100% {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    /* Cover effect for dropdown items */
    .hover\:bg-\[\#f0f7fa\] {
        position: relative;
        overflow: hidden;
    }
    
    .hover\:bg-\[\#f0f7fa\]::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(181, 229, 224, 0.3), transparent);
        transition: left 0.5s ease;
    }
    
    .hover\:bg-\[\#f0f7fa\]:hover::before {
        left: 100%;
    }

    /* Ensure navbar stays on top */
    header {
        z-index: 9999 !important;
    }
    
    nav {
        z-index: 10000 !important;
        display: flex !important;
    }
    
    .group .absolute {
        z-index: 10001 !important;
    }

    nav a, nav button {
        color: #1e3c5c !important;
        font-weight: 600 !important;
    }
    
    nav a:hover, nav button:hover {
        color: #0284a8 !important;
    }

    @media (min-width: 768px) {
        nav {
            display: flex !important;
        }
    }

    /* User menu styles */
    .user-menu-button {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        background: linear-gradient(to right, #0284a8, #03738C);
        color: white;
        font-weight: 600;
        padding: 0.5rem 1rem 0.5rem 1.5rem;
        border-radius: 9999px;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        transition: all 0.2s;
        cursor: pointer;
        border: none;
    }
    
    .user-menu-button:hover {
        background: linear-gradient(to right, #03738C, #025c73);
        transform: scale(1.02);
    }
    
    .user-dropdown {
        position: absolute;
        right: 0;
        top: calc(100% + 0.5rem);
        width: 200px;
        background: white;
        border-radius: 0.75rem;
        box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
        border: 1px solid #b5e5e0;
        opacity: 0;
        visibility: hidden;
        transform: translateY(-10px);
        transition: all 0.3s ease;
        z-index: 10001;
    }
    
    .user-dropdown.show {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }
    
    .user-dropdown a, .user-dropdown button {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.75rem 1rem;
        color: #1e3c5c;
        font-size: 0.875rem;
        transition: all 0.2s;
        width: 100%;
        text-align: left;
        border: none;
        background: none;
        cursor: pointer;
    }
    
    .user-dropdown a:hover, .user-dropdown button:hover {
        background-color: #f0f7fa;
        color: #0284a8;
    }
    
    .user-dropdown .dropdown-divider {
        height: 1px;
        background-color: #b5e5e0;
        margin: 0.25rem 0;
    }
</style>

<script>
(function() {
    if (window.innerWidth >= 768) {
        const nav = document.querySelector('nav');
        if (nav) {
            nav.style.display = 'flex';
        }
    }
})();

if (typeof window.contextPath === 'undefined') {
    window.contextPath = '${pageContext.request.contextPath}';
}

// Function to update user menu
function updateUserMenu() {
    const userMenu = document.getElementById('userMenu');
    if (!userMenu) return;
    
    // Debug: Log all storage items using the unified keys from login.jsp
    console.log('=== Storage Debug ===');
    console.log('localStorage:', {
        authToken: localStorage.getItem('authToken'),
        userId: localStorage.getItem('userId'),
        userName: localStorage.getItem('userName'),
        userEmail: localStorage.getItem('userEmail'),
        userRegNo: localStorage.getItem('userRegNo'),
        userType: localStorage.getItem('userType')
    });
    console.log('sessionStorage:', {
        authToken: sessionStorage.getItem('authToken'),
        userId: sessionStorage.getItem('userId'),
        userName: sessionStorage.getItem('userName'),
        userEmail: sessionStorage.getItem('userEmail'),
        userRegNo: sessionStorage.getItem('userRegNo'),
        userType: sessionStorage.getItem('userType')
    });
    
    // Check both localStorage and sessionStorage using unified keys
    const token = localStorage.getItem('authToken') || sessionStorage.getItem('authToken');
    let userName = localStorage.getItem('userName') || sessionStorage.getItem('userName');
    const userId = localStorage.getItem('userId') || sessionStorage.getItem('userId');
    const userType = localStorage.getItem('userType') || sessionStorage.getItem('userType');
    
    console.log('Token exists:', !!token);
    console.log('User Name:', userName);
    console.log('User ID:', userId);
    console.log('User Type:', userType);
    
    // Only show guest menu, not staff
    if (token && userId && userType === 'guest') {
        // Guest is logged in - show user menu
        const firstName = userName ? userName.split(' ')[0] : 'Guest';
        userMenu.innerHTML = `
            <div class="relative" id="userMenuContainer">
                <button onclick="toggleUserDropdown()" class="user-menu-button" id="userMenuBtn">
                    <span>👋 Welcome, ${firstName}</span>
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                    </svg>
                </button>
                <div class="user-dropdown" id="userDropdown">
                    <a href="profile.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                        My Profile
                    </a>
                    <a href="roomactivity.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                        </svg>
                        My Activity
                    </a>
                    <a href="tableactivity.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                        </svg>
                        My Activity
                    </a>
                    <a href="serviceactivity.jsp">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                        </svg>
                        My Activity
                    </a>
                    <div class="dropdown-divider"></div>
                    <button onclick="handleLogout()">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                        </svg>
                        Logout
                    </button>
                </div>
            </div>
        `;
        
        const dropdown = document.getElementById('userDropdown');
        if (dropdown) {
            dropdown.classList.remove('show');
        }
    } else {
        // Guest is not logged in - show login button
        userMenu.innerHTML = `
            <a href="login.jsp" class="bg-[#0284a8] hover:bg-[#03738C] text-white text-sm font-semibold px-5 py-2.5 rounded-full shadow-md transition flex items-center gap-1 whitespace-nowrap">
                <span>🔑</span> Login
            </a>
        `;
    }
}

// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(updateUserMenu, 100);
        
        document.addEventListener('click', function(event) {
            const dropdown = document.getElementById('userDropdown');
            const button = document.getElementById('userMenuBtn');
            
            if (dropdown && button && !button.contains(event.target) && !dropdown.contains(event.target)) {
                dropdown.classList.remove('show');
            }
        });
    });
} else {
    setTimeout(updateUserMenu, 100);
    
    document.addEventListener('click', function(event) {
        const dropdown = document.getElementById('userDropdown');
        const button = document.getElementById('userMenuBtn');
        
        if (dropdown && button && !button.contains(event.target) && !dropdown.contains(event.target)) {
            dropdown.classList.remove('show');
        }
    });
}

// Run multiple times to ensure it catches
setTimeout(updateUserMenu, 500);
setTimeout(updateUserMenu, 1000);

function toggleUserDropdown() {
    const dropdown = document.getElementById('userDropdown');
    if (dropdown) {
        dropdown.classList.toggle('show');
    }
}

function handleLogout() {
    const token = localStorage.getItem('authToken') || sessionStorage.getItem('authToken');
    
    console.log('Logging out guest...');
    
    if (token) {
        fetch(window.contextPath + '/guests/api/logout', {
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
            
            if (window.showSuccess) {
                window.showSuccess('Logged out successfully', 2000);
            }
            
            updateUserMenu();
            
            setTimeout(() => {
                window.location.reload();
            }, 1500);
        });
    } else {
        localStorage.clear();
        sessionStorage.clear();
        updateUserMenu();
    }
}

// Listen for storage changes
window.addEventListener('storage', function(e) {
    if (e.key === 'authToken' || e.key === 'userName' || e.key === 'userId' || e.key === 'userType') {
        console.log('Storage changed:', e.key, e.newValue);
        updateUserMenu();
    }
});
</script>