<%-- 
    Document   : manageguests
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · Manage Guests</title>
    <!-- Tailwind via CDN + Inter font + same subtle style -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <!-- Alpine.js for interactive components -->
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <!-- Include notification.jsp -->
    <jsp:include page="/component/notification.jsp" />
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        .card-dash { transition: all 0.2s; }
        .card-dash:hover { transform: translateY(-2px); box-shadow: 0 16px 24px -8px rgba(2, 116, 140, 0.12); }
        .stat-glow { text-shadow: 0 2px 5px rgba(2, 132, 168, 0.2); }
        .break-word {
            word-break: break-word;
            overflow-wrap: break-word;
        }
        /* Modal backdrop */
        .modal-overlay {
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
        }
        /* Table styles */
        .table-container {
            overflow-x: auto;
            border-radius: 1rem;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        th {
            background-color: #f8fafc;
            color: #1e3c5c;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 1rem 0.75rem;
            border-bottom: 2px solid #b5e5e0;
            white-space: nowrap;
        }
        td {
            padding: 1rem 0.75rem;
            border-bottom: 1px solid #e2e8f0;
            vertical-align: middle;
        }
        tr:last-child td {
            border-bottom: none;
        }
        tr:hover td {
            background-color: #f8fafc;
        }
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
            text-align: center;
            white-space: nowrap;
        }
        .action-btn {
            width: 2rem;
            height: 2rem;
            border-radius: 0.5rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
            cursor: pointer;
        }
        .action-btn:hover {
            transform: scale(1.1);
        }
        .action-btn.disabled, .action-btn:disabled {
            opacity: 0.3;
            cursor: not-allowed;
            pointer-events: none;
        }
        .guest-info-compact {
            max-width: 180px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        /* Status dropdown */
        .status-dropdown {
            max-height: 200px;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: #0284a8 #b5e5e0;
        }
        .status-dropdown::-webkit-scrollbar {
            width: 6px;
        }
        .status-dropdown::-webkit-scrollbar-track {
            background: #b5e5e0;
            border-radius: 10px;
        }
        .status-dropdown::-webkit-scrollbar-thumb {
            background: #0284a8;
            border-radius: 10px;
        }
        .status-option {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 1rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        .status-option:hover {
            background-color: #f0f7fa;
        }
        .status-option.selected {
            background-color: #b5e5e0;
            color: #0284a8;
            font-weight: 500;
        }
        .status-count {
            background-color: #0284a8;
            color: white;
            border-radius: 9999px;
            padding: 0.125rem 0.5rem;
            font-size: 0.7rem;
            font-weight: 600;
        }
        /* Notification animation */
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        .notification-slide {
            animation: slideIn 0.3s ease-out;
        }
        /* Compact table cells */
        .compact-cell {
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
</head>
<body class="bg-[#f0f7fa] text-[#1e3c5c] antialiased flex">

    <!-- Include Sidebar -->
    <jsp:include page="/component/sidebar.jsp" />

    <!-- ===== MAIN DASHBOARD (right side) ===== -->
    <main class="flex-1 overflow-y-auto" x-data="guestManager()" x-init="init()">
        <!-- top bar -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#b5e5e0] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">👤</span>
                <span class="font-semibold">Guest Management</span>
            </div>
            <div class="flex items-center gap-3">
                <span class="bg-[#0284a8] text-white text-xs px-3 py-1.5 rounded-full" x-text="`${filteredGuests.length} guests`"></span>
            </div>
        </header>

        <!-- dashboard content -->
        <div class="p-4 md:p-6 lg:p-8 space-y-6 max-w-full">

            <!-- Header with title -->
            <div class="flex justify-between items-center">
                <div>
                    <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Manage Guests 👤</h2>
                    <p class="text-[#3a5a78] text-base mt-1">View and manage guest accounts</p>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-4 gap-4">
                <!-- Total Guests -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Total Guests</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="guests.length"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0]/30 flex items-center justify-center">
                            <span class="text-2xl">👤</span>
                        </div>
                    </div>
                </div>
                
                <!-- Active Guests -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Active</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="getActiveCount()"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0] flex items-center justify-center">
                            <span class="text-2xl">✅</span>
                        </div>
                    </div>
                </div>
                
                <!-- Inactive Guests -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Inactive</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="getInactiveCount()"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#f8e4c3] flex items-center justify-center">
                            <span class="text-2xl">⏸️</span>
                        </div>
                    </div>
                </div>

                <!-- New This Month -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">New This Month</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="getNewThisMonthCount()"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#9ac9c2] flex items-center justify-center">
                            <span class="text-2xl">🆕</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search and Filter Section -->
            <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] p-4 md:p-6 space-y-4">
                <!-- Search Bar -->
                <div class="relative">
                    <input type="text" 
                           x-model="searchQuery"
                           placeholder="Search by Reg No, Full Name, Username or Email..." 
                           class="w-full pl-10 pr-4 py-3 rounded-xl border border-[#b5e5e0] focus:outline-none focus:ring-2 focus:ring-[#0284a8] focus:border-transparent text-sm">
                    <span class="absolute left-3 top-3.5 text-[#3a5a78] text-lg">🔍</span>
                </div>

                <!-- Filter Row -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
                    <!-- Status Filter (Active/Inactive) -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Status</label>
                        <select x-model="statusFilter" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Status</option>
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                        </select>
                    </div>

                    <!-- Joined Month Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Joined Month</label>
                        <select x-model="joinedMonthFilter" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Months</option>
                            <option value="01">January</option>
                            <option value="02">February</option>
                            <option value="03">March</option>
                            <option value="04">April</option>
                            <option value="05">May</option>
                            <option value="06">June</option>
                            <option value="07">July</option>
                            <option value="08">August</option>
                            <option value="09">September</option>
                            <option value="10">October</option>
                            <option value="11">November</option>
                            <option value="12">December</option>
                        </select>
                    </div>

                    <!-- Joined Year Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Joined Year</label>
                        <select x-model="joinedYearFilter" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Years</option>
                            <option value="2025">2025</option>
                            <option value="2024">2024</option>
                            <option value="2023">2023</option>
                            <option value="2022">2022</option>
                        </select>
                    </div>

                    <!-- Specific Joined Date -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Specific Joined Date</label>
                        <input type="date" 
                               x-model="joinedDateFilter"
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                    </div>
                </div>

                <!-- Filter Actions -->
                <div class="flex flex-wrap justify-end gap-2 pt-2">
                    <button @click="clearFilters()" class="px-4 py-2 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Clear Filters
                    </button>
                    <button @click="applyFilters()" class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                        Apply Filters
                    </button>
                </div>
            </div>

            <!-- Guests Table (Compact Design) -->
            <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] overflow-hidden">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Reg No</th>
                                <th>Full Name</th>
                                <th>Username</th>
                                <th>Email / Phone</th>
                                <th>Address</th>
                                <th>Status</th>
                                <th>Last Login</th>
                                <th>Joined</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template x-for="guest in paginatedGuests" :key="guest.id">
                                <tr>
                                    <!-- Reg No -->
                                    <td>
                                        <div class="font-medium text-[#1e3c5c] text-sm" x-text="guest.regNo"></div>
                                    </td>
                                    
                                    <!-- Full Name -->
                                    <td>
                                        <div class="text-sm text-[#1e3c5c] font-medium compact-cell" x-text="guest.fullName"></div>
                                    </td>
                                    
                                    <!-- Username -->
                                    <td>
                                        <div class="text-sm text-[#1e3c5c] compact-cell" x-text="guest.username"></div>
                                    </td>
                                    
                                    <!-- Email / Phone (combined) -->
                                    <td>
                                        <div class="text-sm text-[#1e3c5c] compact-cell" x-text="guest.email"></div>
                                        <div class="text-xs text-[#3a5a78]" x-text="guest.phone"></div>
                                    </td>
                                    
                                    <!-- Address -->
                                    <td>
                                        <div class="text-sm text-[#1e3c5c] compact-cell" x-text="guest.address"></div>
                                    </td>
                                    
                                    <!-- Status -->
                                    <td>
                                        <span class="status-badge text-xs"
                                              :class="{
                                                  'bg-[#b5e5e0] text-[#0284a8]': guest.status === 'active',
                                                  'bg-[#f8e4c3] text-[#d4a373]': guest.status === 'inactive'
                                              }">
                                            <span class="flex items-center justify-center gap-1">
                                                <span x-text="guest.status === 'active' ? '✅' : '⏸️'"></span>
                                                <span x-text="guest.status === 'active' ? 'Active' : 'Inactive'"></span>
                                            </span>
                                        </span>
                                    </td>
                                    
                                    <!-- Last Login -->
                                    <td>
                                        <div class="text-xs text-[#3a5a78]" x-text="guest.lastLogin ? formatShortDate(guest.lastLogin) : 'Never'"></div>
                                    </td>
                                    
                                    <!-- Joined Date -->
                                    <td>
                                        <div class="text-xs text-[#3a5a78]" x-text="formatShortDate(guest.createdDate)"></div>
                                    </td>
                                    
                                    <!-- Actions -->
                                    <td>
                                        <div class="flex items-center gap-1">
                                            <!-- Edit Status -->
                                            <button @click="confirmStatusChange(guest)" 
                                                    class="action-btn w-7 h-7 bg-green-100 text-green-600 hover:bg-green-200"
                                                    title="Change Status">
                                                <span class="text-sm">✅</span>
                                            </button>
                                            
                                            <!-- View Details -->
                                            <button @click="viewGuest(guest)" 
                                                    class="action-btn w-7 h-7 bg-[#b5e5e0] text-[#0284a8] hover:bg-[#9ac9c2]"
                                                    title="View Details">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                                </svg>
                                            </button>
                                            
                                            <!-- Delete Guest -->
                                            <button @click="confirmDelete(guest)" 
                                                    class="action-btn w-7 h-7 bg-red-100 text-red-500 hover:bg-red-200"
                                                    title="Delete Guest">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                                </svg>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </template>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- No Results Message -->
            <div x-show="filteredGuests.length === 0" class="text-center py-12">
                <span class="text-5xl mb-3 block">👤</span>
                <p class="text-lg text-[#3a5a78]">No guests found matching your filters</p>
                <button @click="clearFilters()" class="mt-4 px-6 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                    Clear Filters
                </button>
            </div>

            <!-- Pagination with Items Per Page Selector -->
            <div x-show="filteredGuests.length > 0" class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-6">
                <div class="flex items-center gap-2">
                    <span class="text-sm text-[#3a5a78]">Show:</span>
                    <select x-model="itemsPerPage" @change="currentPage = 1" 
                            class="border border-[#b5e5e0] rounded-lg px-3 py-1.5 text-sm text-[#1e3c5c] focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                        <option value="10">10 / page</option>
                        <option value="20">20 / page</option>
                        <option value="50">50 / page</option>
                        <option value="100">100 / page</option>
                    </select>
                </div>
                
                <div class="flex items-center gap-2">
                    <button @click="prevPage" :disabled="currentPage === 1" 
                            class="w-9 h-9 rounded-full bg-white border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition disabled:opacity-50 disabled:cursor-not-allowed text-sm">
                        ←
                    </button>
                    <template x-for="page in totalPages" :key="page">
                        <button @click="goToPage(page)" 
                                class="w-9 h-9 rounded-full border transition text-sm"
                                :class="currentPage === page ? 'bg-[#0284a8] text-white border-[#0284a8]' : 'bg-white border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20'">
                            <span x-text="page"></span>
                        </button>
                    </template>
                    <button @click="nextPage" :disabled="currentPage === totalPages"
                            class="w-9 h-9 rounded-full bg-white border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition disabled:opacity-50 disabled:cursor-not-allowed text-sm">
                        →
                    </button>
                </div>
                
                <div class="text-sm text-[#3a5a78]">
                    Showing <span x-text="((currentPage - 1) * itemsPerPage) + 1"></span> - 
                    <span x-text="Math.min(currentPage * itemsPerPage, filteredGuests.length)"></span> 
                    of <span x-text="filteredGuests.length"></span>
                </div>
            </div>
        </div>

        <!-- Status Change Confirmation Modal -->
        <div x-show="showStatusModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="showStatusModal = false">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-md w-full p-6 transform transition-all"
                 @click.stop>
                
                <div class="flex items-center justify-center w-16 h-16 mx-auto bg-green-100 rounded-full mb-4">
                    <span class="text-2xl">✅</span>
                </div>
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Change Guest Status</h3>
                <p class="text-[#3a5a78] text-center mb-2">
                    Guest: <span class="font-semibold" x-text="selectedGuest?.fullName"></span>
                </p>
                <p class="text-[#3a5a78] text-center mb-4">
                    Current Status: 
                    <span class="status-badge ml-1"
                          :class="{
                              'bg-[#b5e5e0] text-[#0284a8]': selectedGuest?.status === 'active',
                              'bg-[#f8e4c3] text-[#d4a373]': selectedGuest?.status === 'inactive'
                          }">
                        <span x-text="selectedGuest?.status === 'active' ? 'Active' : 'Inactive'"></span>
                    </span>
                </p>
                
                <div class="grid grid-cols-2 gap-3 mb-6">
                    <button @click="updateGuestStatus('active')" 
                            class="flex flex-col items-center p-4 border-2 rounded-xl transition-all"
                            :class="statusTarget === 'active' ? 'border-[#0284a8] bg-[#b5e5e0]/20' : 'border-[#b5e5e0] hover:border-[#0284a8]'"
                            @mouseenter="statusTarget = 'active'"
                            @mouseleave="statusTarget = null">
                        <span class="text-2xl mb-1">✅</span>
                        <span class="font-medium text-[#1e3c5c]">Active</span>
                    </button>
                    
                    <button @click="updateGuestStatus('inactive')" 
                            class="flex flex-col items-center p-4 border-2 rounded-xl transition-all"
                            :class="statusTarget === 'inactive' ? 'border-[#d4a373] bg-[#f8e4c3]' : 'border-[#b5e5e0] hover:border-[#d4a373]'"
                            @mouseenter="statusTarget = 'inactive'"
                            @mouseleave="statusTarget = null">
                        <span class="text-2xl mb-1">⏸️</span>
                        <span class="font-medium text-[#1e3c5c]">Inactive</span>
                    </button>
                </div>
                
                <div class="flex gap-3">
                    <button @click="showStatusModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                </div>
            </div>
        </div>

        <!-- View Guest Modal (Full Details) -->
        <div x-show="showViewModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="showViewModal = false">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-2xl w-full p-6 transform transition-all max-h-[90vh] overflow-y-auto"
                 @click.stop>
                
                <div class="flex justify-between items-start mb-4">
                    <h3 class="text-xl font-bold text-[#1e3c5c]">Guest Details</h3>
                    <button @click="showViewModal = false" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <div class="space-y-4" x-show="selectedGuest">
                    <div class="grid grid-cols-2 gap-4">
                        <!-- Reg No -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Registration No</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedGuest?.regNo"></p>
                        </div>
                        
                        <!-- Full Name -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Full Name</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedGuest?.fullName"></p>
                        </div>
                        
                        <!-- Username -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Username</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedGuest?.username"></p>
                        </div>
                        
                        <!-- Email -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Email</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedGuest?.email"></p>
                        </div>
                        
                        <!-- Phone -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Phone</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedGuest?.phone"></p>
                        </div>
                        
                        <!-- Password (masked) -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Password</p>
                            <p class="font-medium text-[#1e3c5c]">••••••••</p>
                        </div>
                        
                        <!-- Address (full width) -->
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Address</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedGuest?.address"></p>
                        </div>
                        
                        <!-- Status -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Status</p>
                            <p class="font-medium">
                                <span class="status-badge"
                                      :class="{
                                          'bg-[#b5e5e0] text-[#0284a8]': selectedGuest?.status === 'active',
                                          'bg-[#f8e4c3] text-[#d4a373]': selectedGuest?.status === 'inactive'
                                      }">
                                    <span class="flex items-center gap-1">
                                        <span x-text="selectedGuest?.status === 'active' ? '✅' : '⏸️'"></span>
                                        <span x-text="selectedGuest?.status === 'active' ? 'Active' : 'Inactive'"></span>
                                    </span>
                                </span>
                            </p>
                        </div>
                        
                        <!-- Dates -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Last Login</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedGuest?.lastLogin ? formatDate(selectedGuest.lastLogin) : 'Never'"></p>
                        </div>
                        
                        <div>
                            <p class="text-sm text-[#3a5a78]">Created Date</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="formatDate(selectedGuest?.createdDate)"></p>
                        </div>
                        
                        <div>
                            <p class="text-sm text-[#3a5a78]">Last Updated</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedGuest?.updatedDate ? formatDate(selectedGuest.updatedDate) : '-'"></p>
                        </div>
                    </div>
                </div>
                
                <div class="flex justify-end mt-6">
                    <button @click="showViewModal = false" 
                            class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div x-show="showDeleteModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="showDeleteModal = false">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-md w-full p-6 transform transition-all"
                 @click.stop>
                
                <div class="flex items-center justify-center w-16 h-16 mx-auto bg-red-100 rounded-full mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                </div>
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Delete Guest</h3>
                <p class="text-[#3a5a78] text-center mb-6">
                    Are you sure you want to delete guest "<span class="font-semibold" x-text="selectedGuest?.fullName"></span>"? This action cannot be undone.
                </p>
                
                <div class="flex gap-3">
                    <button @click="showDeleteModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                    <button @click="deleteGuest()" 
                            class="flex-1 px-4 py-2.5 rounded-lg bg-red-500 text-white hover:bg-red-600 transition text-sm font-medium">
                        Delete
                    </button>
                </div>
            </div>
        </div>

    </main>

    <script>
        function guestManager() {
            return {
                // Sample guest data
                guests: [
                    { 
                        id: 1, 
                        regNo: 'GST-00001',
                        fullName: 'Robert Johnson',
                        username: 'robertj',
                        email: 'robert.johnson@email.com',
                        phone: '+94 77 123 4567',
                        address: '123 Park Avenue, Colombo 05, Sri Lanka',
                        password: 'password123',
                        status: 'active',
                        lastLogin: '2025-06-15 09:30',
                        createdDate: '2024-01-15',
                        updatedDate: '2025-05-20'
                    },
                    { 
                        id: 2, 
                        regNo: 'GST-00002',
                        fullName: 'Maria Garcia',
                        username: 'mariag',
                        email: 'maria.garcia@email.com',
                        phone: '+94 77 234 5678',
                        address: '45 Beach Road, Mount Lavinia, Sri Lanka',
                        password: 'password123',
                        status: 'active',
                        lastLogin: '2025-06-14 14:15',
                        createdDate: '2024-03-20',
                        updatedDate: '2025-05-18'
                    },
                    { 
                        id: 3, 
                        regNo: 'GST-00003',
                        fullName: 'David Chen',
                        username: 'davidc',
                        email: 'david.chen@email.com',
                        phone: '+94 77 345 6789',
                        address: '78 Temple Road, Kandy, Sri Lanka',
                        password: 'password123',
                        status: 'active',
                        lastLogin: '2025-06-13 10:45',
                        createdDate: '2024-06-10',
                        updatedDate: '2025-05-15'
                    },
                    { 
                        id: 4, 
                        regNo: 'GST-00004',
                        fullName: 'Sarah Ahmed',
                        username: 'sarah',
                        email: 'sarah.ahmed@email.com',
                        phone: '+94 77 456 7890',
                        address: '23 Lake Drive, Nugegoda, Sri Lanka',
                        password: 'password123',
                        status: 'active',
                        lastLogin: '2025-06-15 08:30',
                        createdDate: '2024-09-05',
                        updatedDate: '2025-05-10'
                    },
                    { 
                        id: 5, 
                        regNo: 'GST-00005',
                        fullName: 'James Wilson',
                        username: 'jamesw',
                        email: 'james.wilson@email.com',
                        phone: '+94 77 567 8901',
                        address: '67 Hill Street, Galle, Sri Lanka',
                        password: 'password123',
                        status: 'inactive',
                        lastLogin: '2025-06-01 16:20',
                        createdDate: '2024-11-12',
                        updatedDate: '2025-06-01'
                    },
                    { 
                        id: 6, 
                        regNo: 'GST-00006',
                        fullName: 'Lisa Wong',
                        username: 'lisaw',
                        email: 'lisa.wong@email.com',
                        phone: '+94 77 678 9012',
                        address: '89 Ocean Drive, Bentota, Sri Lanka',
                        password: 'password123',
                        status: 'active',
                        lastLogin: '2025-06-14 11:30',
                        createdDate: '2025-02-18',
                        updatedDate: '2025-05-25'
                    },
                    { 
                        id: 7, 
                        regNo: 'GST-00007',
                        fullName: 'Michael Brown',
                        username: 'michaelb',
                        email: 'michael.brown@email.com',
                        phone: '+94 77 789 0123',
                        address: '34 Queen Street, Negombo, Sri Lanka',
                        password: 'password123',
                        status: 'active',
                        lastLogin: '2025-06-12 09:45',
                        createdDate: '2025-01-20',
                        updatedDate: '2025-05-28'
                    },
                    { 
                        id: 8, 
                        regNo: 'GST-00008',
                        fullName: 'Emily Taylor',
                        username: 'emilyt',
                        email: 'emily.taylor@email.com',
                        phone: '+94 77 890 1234',
                        address: '56 Beach Road, Trincomalee, Sri Lanka',
                        password: 'password123',
                        status: 'inactive',
                        lastLogin: '2025-05-28 15:20',
                        createdDate: '2024-08-14',
                        updatedDate: '2025-05-28'
                    }
                ],
                
                searchQuery: '',
                statusFilter: 'all',
                joinedMonthFilter: 'all',
                joinedYearFilter: 'all',
                joinedDateFilter: '',
                
                currentPage: 1,
                itemsPerPage: 10,
                
                // Modal properties
                showStatusModal: false,
                showViewModal: false,
                showDeleteModal: false,
                
                selectedGuest: null,
                statusTarget: null,
                
                // Get status counts
                getStatusCounts: function() {
                    var counts = {
                        active: 0,
                        inactive: 0
                    };
                    
                    this.guests.forEach(function(guest) {
                        if (guest.status === 'active') {
                            counts.active++;
                        } else {
                            counts.inactive++;
                        }
                    });
                    
                    return [
                        { name: 'Active', count: counts.active, value: 'active' },
                        { name: 'Inactive', count: counts.inactive, value: 'inactive' }
                    ];
                },
                
                get filteredGuests() {
                    return this.guests.filter(guest => {
                        // Search filter - only regno, fullName, username, email
                        if (this.searchQuery) {
                            var query = this.searchQuery.toLowerCase();
                            var matchesSearch = guest.regNo.toLowerCase().includes(query) ||
                                                guest.fullName.toLowerCase().includes(query) ||
                                                guest.username.toLowerCase().includes(query) ||
                                                guest.email.toLowerCase().includes(query);
                            if (!matchesSearch) return false;
                        }
                        
                        // Status filter
                        if (this.statusFilter !== 'all' && guest.status !== this.statusFilter) {
                            return false;
                        }
                        
                        // Joined date filters
                        var createdDate = new Date(guest.createdDate);
                        
                        // Month filter
                        if (this.joinedMonthFilter !== 'all') {
                            var month = (createdDate.getMonth() + 1).toString();
                            if (month.length === 1) month = '0' + month;
                            if (month !== this.joinedMonthFilter) return false;
                        }
                        
                        // Year filter
                        if (this.joinedYearFilter !== 'all') {
                            var year = createdDate.getFullYear().toString();
                            if (year !== this.joinedYearFilter) return false;
                        }
                        
                        // Specific date filter
                        if (this.joinedDateFilter && guest.createdDate !== this.joinedDateFilter) {
                            return false;
                        }
                        
                        return true;
                    });
                },
                
                get paginatedGuests() {
                    var start = (this.currentPage - 1) * this.itemsPerPage;
                    var end = start + this.itemsPerPage;
                    return this.filteredGuests.slice(start, end);
                },
                
                get totalPages() {
                    return Math.ceil(this.filteredGuests.length / this.itemsPerPage);
                },
                
                // Count methods
                getActiveCount: function() {
                    return this.guests.filter(function(g) { return g.status === 'active'; }).length;
                },
                
                getInactiveCount: function() {
                    return this.guests.filter(function(g) { return g.status === 'inactive'; }).length;
                },
                
                getNewThisMonthCount: function() {
                    var currentDate = new Date();
                    var currentMonth = currentDate.getMonth();
                    var currentYear = currentDate.getFullYear();
                    
                    return this.guests.filter(function(guest) {
                        var createdDate = new Date(guest.createdDate);
                        return createdDate.getMonth() === currentMonth && 
                               createdDate.getFullYear() === currentYear;
                    }).length;
                },
                
                init: function() {
                    var self = this;
                    
                    // Reset to first page when filters change
                    this.$watch('filteredGuests', function() {
                        self.currentPage = 1;
                    });
                    
                    console.log('Guest Manager initialized');
                },
                
                formatDate: function(dateString) {
                    if (!dateString) return '';
                    var options = { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' };
                    return new Date(dateString).toLocaleDateString('en-US', options);
                },
                
                formatShortDate: function(dateString) {
                    if (!dateString) return '';
                    var options = { year: 'numeric', month: 'short', day: 'numeric' };
                    return new Date(dateString).toLocaleDateString('en-US', options);
                },
                
                // Confirm status change
                confirmStatusChange: function(guest) {
                    this.selectedGuest = guest;
                    this.statusTarget = guest.status;
                    this.showStatusModal = true;
                },
                
                // Update guest status
                updateGuestStatus: function(newStatus) {
                    var self = this;
                    
                    if (this.selectedGuest.status === newStatus) {
                        // No change
                        this.showStatusModal = false;
                        this.selectedGuest = null;
                        return;
                    }
                    
                    var index = this.guests.findIndex(function(g) { return g.id === self.selectedGuest.id; });
                    if (index !== -1) {
                        this.guests[index].status = newStatus;
                        this.guests[index].updatedDate = new Date().toISOString().split('T')[0];
                        
                        if (window.showSuccess) {
                            window.showSuccess('Guest status updated successfully', 3000);
                        }
                    }
                    
                    this.showStatusModal = false;
                    this.selectedGuest = null;
                    this.statusTarget = null;
                },
                
                // View guest details
                viewGuest: function(guest) {
                    this.selectedGuest = guest;
                    this.showViewModal = true;
                },
                
                // Confirm delete
                confirmDelete: function(guest) {
                    this.selectedGuest = guest;
                    this.showDeleteModal = true;
                },
                
                // Delete guest
                deleteGuest: function() {
                    var self = this;
                    var index = this.guests.findIndex(function(g) { return g.id === self.selectedGuest.id; });
                    if (index !== -1) {
                        this.guests.splice(index, 1);
                        
                        if (window.showSuccess) {
                            window.showSuccess('Guest deleted successfully', 3000);
                        }
                    }
                    
                    this.showDeleteModal = false;
                    this.selectedGuest = null;
                    
                    // Adjust current page if necessary
                    if (this.paginatedGuests.length === 0 && this.currentPage > 1) {
                        this.currentPage--;
                    }
                },
                
                clearFilters: function() {
                    this.searchQuery = '';
                    this.statusFilter = 'all';
                    this.joinedMonthFilter = 'all';
                    this.joinedYearFilter = 'all';
                    this.joinedDateFilter = '';
                    this.currentPage = 1;
                    
                    if (window.showInfo) {
                        window.showInfo('Filters cleared', 3000);
                    }
                },
                
                applyFilters: function() {
                    this.currentPage = 1;
                    
                    if (window.showSuccess) {
                        window.showSuccess('Filters applied', 3000);
                    }
                },
                
                prevPage: function() {
                    if (this.currentPage > 1) {
                        this.currentPage--;
                    }
                },
                
                nextPage: function() {
                    if (this.currentPage < this.totalPages) {
                        this.currentPage++;
                    }
                },
                
                goToPage: function(page) {
                    this.currentPage = page;
                }
            }
        }
    </script>
</body>
</html>