<%-- 
    Document   : sidebar
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<aside class="w-72 bg-white/90 backdrop-blur-sm border-r border-[#b5e5e0] shadow-lg h-screen sticky top-0 flex flex-col justify-between">
    <!-- sidebar header with logo / resort name -->
    <div>
        <div class="px-6 pt-8 pb-6 border-b border-[#cdeae5]">
            <h1 class="text-2xl font-bold text-[#1e3c5c] flex items-center gap-2">
                <span class="text-3xl">🌊</span> 
                <span>Ocean<span class="text-[#03738C]">View</span></span>
            </h1>
            <p class="text-xs text-[#3a5a78] mt-1 tracking-wide">Ocean View Resort</p>
        </div>
        <!-- navigation menu -->
        <nav class="p-4 space-y-1">
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
                    <a href="#" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/5140/5140130.png" alt="rooms" class="w-4 h-4">
                        <span>Rooms</span>
                    </a>
                    <a href="#" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/1012/1012472.png" alt="tables" class="w-4 h-4">
                        <span>Tables</span>
                    </a>
                    <a href="#" class="flex items-center gap-4 px-4 py-2.5 rounded-lg text-[#1e3c5c]/70 hover:bg-[#b5e5e0]/20 text-sm">
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
        </nav>
    </div>

    <!-- bottom part: profile with name & role (clickable) -->
    <div class="p-5 border-t border-[#b5e5e0]">
        <a href="profile.jsp" class="flex items-center gap-3 mb-4 hover:bg-[#b5e5e0]/20 p-2 rounded-lg transition">
            <img src="https://cdn-icons-png.flaticon.com/128/17123/17123222.png" alt="profile" class="w-10 h-10">
            <div>
                <p class="font-medium text-[#1e3c5c] text-sm">Tharushi</p>
                <p class="text-xs text-[#3a5a78]">front desk</p>
            </div>
        </a>
        <a href="#" class="flex items-center gap-3 text-[#03738C] hover:text-[#025c73] text-sm font-medium px-2 py-2 rounded-lg hover:bg-[#b5e5e0]/20">
            <img src="https://cdn-icons-png.flaticon.com/128/6568/6568413.png" alt="logout" class="w-5 h-5">
            <span>Log out</span>
        </a>
    </div>
    
    <style>
        .sidebar-hover { transition: background 0.2s ease, transform 0.1s; }
        .sidebar-hover:hover { background: rgba(2, 132, 168, 0.08); }
    </style>
    
    <!-- Alpine.js for dropdown functionality -->
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
</aside>