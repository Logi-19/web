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
        
        <!-- desktop nav (center) - FIXED: Force desktop navigation to show -->
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
                        <a href="#" class="flex items-center gap-3 px-4 py-3 hover:bg-[#f0f7fa] transition">
                            <span class="text-[#0284a8] text-xl">🏨</span>
                            <div>
                                <div class="font-semibold text-[#1e3c5c]">Room Reservation</div>
                                <div class="text-xs text-[#3a5a78]">Book your perfect stay</div>
                            </div>
                        </a>
                        <div class="border-t border-[#b5e5e0]/30 my-1"></div>
                        <a href="#" class="flex items-center gap-3 px-4 py-3 hover:bg-[#f0f7fa] transition">
                            <span class="text-[#d4a373] text-xl">🍽️</span>
                            <div>
                                <div class="font-semibold text-[#1e3c5c]">Dine In</div>
                                <div class="text-xs text-[#3a5a78]">Reserve your table</div>
                            </div>
                        </a>
                        <div class="border-t border-[#b5e5e0]/30 my-1"></div>
                        <a href="service.jsp" class="flex items-center gap-3 px-4 py-3 hover:bg-[#f0f7fa] transition">
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
            
            <!-- Stories & Moments Dropdown (Gallery + Blogs) -->
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
                        <a href="#" class="flex items-center gap-3 px-4 py-3 hover:bg-[#f0f7fa] transition">
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
        
        <!-- Login button (right side) -->
        <a href="login.jsp" class="bg-[#0284a8] hover:bg-[#03738C] text-white text-sm font-semibold px-5 py-2.5 rounded-full shadow-md transition flex items-center gap-1 whitespace-nowrap">
            <span>🔑</span> Login
        </a>
    </div>
</header>
<!-- Spacer for fixed navbar -->
<div class="h-20"></div>

<style>
    /* Cover effect integration - subtle highlight on center nav items */
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
        display: flex !important; /* Force flex display */
    }
    
    /* Ensure dropdowns appear above everything */
    .group .absolute {
        z-index: 10001 !important;
    }

    /* Better text visibility */
    nav a, nav button {
        color: #1e3c5c !important;
        font-weight: 600 !important;
    }
    
    nav a:hover, nav button:hover {
        color: #0284a8 !important;
    }

    /* FIX: Force desktop layout */
    @media (min-width: 768px) {
        nav {
            display: flex !important;
        }
    }
</style>

<!-- FIX: Add viewport check and force desktop mode -->
<script>
(function() {
    // Ensure navbar is in desktop mode on page load
    if (window.innerWidth >= 768) {
        const nav = document.querySelector('nav');
        if (nav) {
            nav.style.display = 'flex';
        }
    }
})();
</script>