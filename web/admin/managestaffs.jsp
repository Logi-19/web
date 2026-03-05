<%-- 
    Document   : managestaffs
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · Manage Staff</title>
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
        .role-badge {
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
        .staff-info-compact {
            max-width: 180px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        /* Role dropdown */
        .role-dropdown {
            max-height: 200px;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: #0284a8 #b5e5e0;
        }
        .role-dropdown::-webkit-scrollbar {
            width: 6px;
        }
        .role-dropdown::-webkit-scrollbar-track {
            background: #b5e5e0;
            border-radius: 10px;
        }
        .role-dropdown::-webkit-scrollbar-thumb {
            background: #0284a8;
            border-radius: 10px;
        }
        .role-option {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 1rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        .role-option:hover {
            background-color: #f0f7fa;
        }
        .role-option.selected {
            background-color: #b5e5e0;
            color: #0284a8;
            font-weight: 500;
        }
        .role-count {
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
        /* Loading spinner */
        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #0284a8;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body class="bg-[#f0f7fa] text-[#1e3c5c] antialiased flex">

    <!-- Include Sidebar -->
    <jsp:include page="/component/sidebar.jsp" />

    <!-- ===== MAIN DASHBOARD (right side) ===== -->
    <main class="flex-1 overflow-y-auto" x-data="staffManager()" x-init="init()">
        <!-- top bar -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#b5e5e0] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">👥</span>
                <span class="font-semibold">Staff Management</span>
            </div>
            <div class="flex items-center gap-3">
                <span class="bg-[#0284a8] text-white text-xs px-3 py-1.5 rounded-full" x-text="`${filteredStaff.length} staff`"></span>
                <button @click="loadStaff()" class="bg-[#b5e5e0] p-2 rounded-lg hover:bg-[#9ac9c2] transition" title="Refresh">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-[#1e3c5c]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                    </svg>
                </button>
            </div>
        </header>

        <!-- dashboard content -->
        <div class="p-4 md:p-6 lg:p-8 space-y-6 max-w-full">

            <!-- Header with title -->
            <div>
                <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Manage Staff 👥</h2>
                <p class="text-[#3a5a78] text-base mt-1">View and manage staff roles and account status</p>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-4 gap-4">
                <!-- Total Staff -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Total Staff</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="staff.length"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0]/30 flex items-center justify-center">
                            <span class="text-2xl">👥</span>
                        </div>
                    </div>
                </div>
                
                <!-- Active Staff -->
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
                
                <!-- Inactive Staff -->
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

                <!-- Roles with dropdown -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4 relative" x-data="{ showRoles: false }">
                    <div class="flex items-center justify-between cursor-pointer" @click="showRoles = !showRoles">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Roles</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="getRolesCount()"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#9ac9c2] flex items-center justify-center">
                            <span class="text-2xl">👔</span>
                        </div>
                    </div>
                    
                    <!-- Role dropdown with counts -->
                    <div x-show="showRoles" 
                         @click.away="showRoles = false"
                         class="absolute top-full left-0 right-0 mt-2 bg-white rounded-lg shadow-xl border border-[#b5e5e0] z-20 role-dropdown">
                        <div class="p-2">
                            <template x-for="role in getRoleCounts()" :key="role.name">
                                <div class="role-option">
                                    <span class="text-sm text-[#1e3c5c]" x-text="role.name"></span>
                                    <span class="role-count" x-text="role.count"></span>
                                </div>
                            </template>
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
                           placeholder="Search by Reg No, Name, Username or Email..." 
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

                    <!-- Role Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Role</label>
                        <select x-model="roleFilter" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Roles</option>
                            <template x-for="role in roles" :key="role.id">
                                <option :value="role.name" x-text="role.name"></option>
                            </template>
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

            <!-- Loading Indicator -->
            <div x-show="loading" class="text-center py-8">
                <div class="loading-spinner"></div>
                <p class="text-[#3a5a78] mt-2">Loading staff data...</p>
            </div>

            <!-- Staff Table (Compact Design) -->
            <div x-show="!loading" class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] overflow-hidden">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Reg No</th>
                                <th>Name</th>
                                <th>Username</th>
                                <th>Email / Phone</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Last Login</th>
                                <th>Joined</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template x-for="staff in paginatedStaff" :key="staff.id">
                                <tr>
                                    <!-- Reg No -->
                                    <td>
                                        <div class="font-medium text-[#1e3c5c] text-sm" x-text="staff.regNo"></div>
                                    </td>
                                    
                                    <!-- Name -->
                                    <td>
                                        <div class="text-sm text-[#1e3c5c] font-medium compact-cell" x-text="staff.fullname"></div>
                                    </td>
                                    
                                    <!-- Username -->
                                    <td>
                                        <div class="text-sm text-[#1e3c5c] compact-cell" x-text="staff.username"></div>
                                    </td>
                                    
                                    <!-- Email / Phone (combined) -->
                                    <td>
                                        <div class="text-sm text-[#1e3c5c] compact-cell" x-text="staff.email"></div>
                                        <div class="text-xs text-[#3a5a78]" x-text="staff.phone"></div>
                                    </td>
                                    
                                    <!-- Role -->
                                    <td>
                                        <span class="role-badge text-xs"
                                              :class="{
                                                  'bg-purple-100 text-purple-700': getRoleNameFromId(staff.roleId) === 'Admin',
                                                  'bg-blue-100 text-blue-700': getRoleNameFromId(staff.roleId) === 'Manager',
                                                  'bg-green-100 text-green-700': getRoleNameFromId(staff.roleId) === 'Supervisor',
                                                  'bg-orange-100 text-orange-700': getRoleNameFromId(staff.roleId) === 'Staff'
                                              }">
                                            <span x-text="getRoleNameFromId(staff.roleId)"></span>
                                        </span>
                                    </td>
                                    
                                    <!-- Status -->
                                    <td>
                                        <span class="status-badge text-xs"
                                              :class="{
                                                  'bg-[#b5e5e0] text-[#0284a8]': staff.status === 'active',
                                                  'bg-[#f8e4c3] text-[#d4a373]': staff.status === 'inactive'
                                              }">
                                            <span class="flex items-center justify-center gap-1">
                                                <span x-text="staff.status === 'active' ? '✅' : '⏸️'"></span>
                                                <span x-text="staff.status === 'active' ? 'Active' : 'Inactive'"></span>
                                            </span>
                                        </span>
                                    </td>
                                    
                                    <!-- Last Login -->
                                    <td>
                                        <div class="text-xs text-[#3a5a78]" x-text="staff.lastLogin ? formatShortDate(staff.lastLogin) : 'Never'"></div>
                                    </td>
                                    
                                    <!-- Joined Date -->
                                    <td>
                                        <div class="text-xs text-[#3a5a78]" x-text="formatShortDate(staff.joinedDate)"></div>
                                    </td>
                                    
                                    <!-- Actions (Status, Role, View, Delete) -->
                                    <td>
                                        <div class="flex items-center gap-1">
                                            <!-- Edit Status -->
                                            <button @click="editStatus(staff)" 
                                                    class="action-btn w-7 h-7 bg-green-100 text-green-600 hover:bg-green-200"
                                                    title="Change Status">
                                                <span class="text-sm">✅</span>
                                            </button>
                                            
                                            <!-- Edit Role - Hide for Admin users -->
                                            <button @click="editRole(staff)" 
                                                   x-show="getRoleNameFromId(staff.roleId) !== 'Admin'"
                                                    class="action-btn w-7 h-7 bg-blue-100 text-blue-600 hover:bg-blue-200"
                                                    title="Change Role">
                                                <span class="text-sm">👔</span>
                                            </button>
                                            
                                            <!-- View Details -->
                                            <button @click="viewStaff(staff)" 
                                                    class="action-btn w-7 h-7 bg-[#b5e5e0] text-[#0284a8] hover:bg-[#9ac9c2]"
                                                    title="View Details">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                                </svg>
                                            </button>
                                            
                                            <!-- Delete Staff - Hide for Admin users -->
                                            <button @click="confirmDelete(staff)" 
                                                   x-show="getRoleNameFromId(staff.roleId) !== 'Admin'"
                                                    class="action-btn w-7 h-7 bg-red-100 text-red-500 hover:bg-red-200"
                                                    title="Delete Staff">
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
            <div x-show="!loading && filteredStaff.length === 0" class="text-center py-12">
                <span class="text-5xl mb-3 block">👥</span>
                <p class="text-lg text-[#3a5a78]">No staff found matching your filters</p>
                <button @click="clearFilters()" class="mt-4 px-6 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                    Clear Filters
                </button>
            </div>

            <!-- Pagination with Items Per Page Selector -->
            <div x-show="!loading && filteredStaff.length > 0" class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-6">
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
                    <span x-text="Math.min(currentPage * itemsPerPage, filteredStaff.length)"></span> 
                    of <span x-text="filteredStaff.length"></span>
                </div>
            </div>
        </div>

        <!-- Edit Status Modal -->
        <div x-show="showEditStatusModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="showEditStatusModal = false">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-md w-full p-6 transform transition-all"
                 @click.stop>
                
                <div class="flex justify-between items-start mb-4">
                    <h3 class="text-xl font-bold text-[#1e3c5c]">Change Status: <span class="text-sm font-normal text-[#3a5a78] block" x-text="selectedStaff?.fullname"></span></h3>
                    <button @click="showEditStatusModal = false" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <form @submit.prevent="updateStaffStatus()" class="space-y-4">
                    <!-- Status -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-2">Select Status</label>
                        <div class="grid grid-cols-2 gap-3">
                            <label class="flex items-center p-3 border rounded-lg cursor-pointer"
                                   :class="editStatusData === 'active' ? 'border-[#0284a8] bg-[#b5e5e0]/20' : 'border-[#b5e5e0]'">
                                <input type="radio" value="active" x-model="editStatusData" class="mr-2">
                                <span>✅ Active</span>
                            </label>
                            <label class="flex items-center p-3 border rounded-lg cursor-pointer"
                                   :class="editStatusData === 'inactive' ? 'border-[#0284a8] bg-[#b5e5e0]/20' : 'border-[#b5e5e0]'">
                                <input type="radio" value="inactive" x-model="editStatusData" class="mr-2">
                                <span>⏸️ Inactive</span>
                            </label>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex justify-end gap-2 pt-4">
                        <button type="button" @click="showEditStatusModal = false" 
                                class="px-4 py-2 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                            Cancel
                        </button>
                        <button type="submit" 
                                class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                            Update Status
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Edit Role Modal -->
        <div x-show="showEditRoleModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="showEditRoleModal = false">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-md w-full p-6 transform transition-all"
                 @click.stop>
                
                <div class="flex justify-between items-start mb-4">
                    <h3 class="text-xl font-bold text-[#1e3c5c]">Change Role: <span class="text-sm font-normal text-[#3a5a78] block" x-text="selectedStaff?.fullname"></span></h3>
                    <button @click="showEditRoleModal = false" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <form @submit.prevent="updateStaffRole()" class="space-y-4">
                    <!-- Role - Hide Admin option -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-2">Select Role</label>
                        <div class="grid grid-cols-2 gap-3">
                            <template x-for="role in roles" :key="role.id">
                                <!-- Skip Admin role (assuming Admin has name 'Admin') -->
                                <label x-show="role.name !== 'Admin'" 
                                       class="flex items-center p-3 border rounded-lg cursor-pointer"
                                       :class="editRoleData === role.id.toString() ? 'border-[#0284a8] ' + 
                                               (role.name === 'Admin' ? 'bg-purple-100' : 
                                                role.name === 'Manager' ? 'bg-blue-100' : 
                                                role.name === 'Supervisor' ? 'bg-green-100' : 'bg-orange-100') : 
                                               'border-[#b5e5e0]'">
                                    <input type="radio" :value="role.id" x-model="editRoleData" class="mr-2">
                                    <span :class="{
                                        'text-purple-700': role.name === 'Admin',
                                        'text-blue-700': role.name === 'Manager',
                                        'text-green-700': role.name === 'Supervisor',
                                        'text-orange-700': role.name === 'Staff'
                                    }" x-text="role.name"></span>
                                </label>
                            </template>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex justify-end gap-2 pt-4">
                        <button type="button" @click="showEditRoleModal = false" 
                                class="px-4 py-2 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                            Cancel
                        </button>
                        <button type="submit" 
                                class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                            Update Role
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- View Staff Modal (Full Details) -->
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
                    <h3 class="text-xl font-bold text-[#1e3c5c]">Staff Details</h3>
                    <button @click="showViewModal = false" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <div class="space-y-4" x-show="selectedStaff">
                    <div class="grid grid-cols-2 gap-4">
                        <!-- Reg No -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Registration No</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedStaff?.regNo"></p>
                        </div>
                        
                        <!-- Name -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Full Name</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedStaff?.fullname"></p>
                        </div>
                        
                        <!-- Username -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Username</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedStaff?.username"></p>
                        </div>
                        
                        <!-- Email -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Email</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedStaff?.email"></p>
                        </div>
                        
                        <!-- Phone -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Phone</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedStaff?.phone"></p>
                        </div>
                        
                        <!-- Password (masked) -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Password</p>
                            <p class="font-medium text-[#1e3c5c]">••••••••</p>
                        </div>
                        
                        <!-- Address (full width) -->
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Address</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedStaff?.address"></p>
                        </div>
                        
                        <!-- Role and Status -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Role</p>
                            <p class="font-medium">
                                <span class="role-badge"
                                      :class="{
                                          'bg-purple-100 text-purple-700': getRoleNameFromId(selectedStaff?.roleId) === 'Admin',
                                          'bg-blue-100 text-blue-700': getRoleNameFromId(selectedStaff?.roleId) === 'Manager',
                                          'bg-green-100 text-green-700': getRoleNameFromId(selectedStaff?.roleId) === 'Supervisor',
                                          'bg-orange-100 text-orange-700': getRoleNameFromId(selectedStaff?.roleId) === 'Staff'
                                      }">
                                    <span x-text="getRoleNameFromId(selectedStaff?.roleId)"></span>
                                </span>
                            </p>
                        </div>
                        
                        <div>
                            <p class="text-sm text-[#3a5a78]">Status</p>
                            <p class="font-medium">
                                <span class="status-badge"
                                      :class="{
                                          'bg-[#b5e5e0] text-[#0284a8]': selectedStaff?.status === 'active',
                                          'bg-[#f8e4c3] text-[#d4a373]': selectedStaff?.status === 'inactive'
                                      }">
                                    <span class="flex items-center gap-1">
                                        <span x-text="selectedStaff?.status === 'active' ? '✅' : '⏸️'"></span>
                                        <span x-text="selectedStaff?.status === 'active' ? 'Active' : 'Inactive'"></span>
                                    </span>
                                </span>
                            </p>
                        </div>
                        
                        <!-- Dates -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Last Login</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedStaff?.lastLogin ? formatDate(selectedStaff.lastLogin) : 'Never'"></p>
                        </div>
                        
                        <div>
                            <p class="text-sm text-[#3a5a78]">Joined Date</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="formatDate(selectedStaff?.joinedDate)"></p>
                        </div>
                        
                        <div>
                            <p class="text-sm text-[#3a5a78]">Last Updated</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedStaff?.updatedDate ? formatDate(selectedStaff.updatedDate) : '-'"></p>
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
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Delete Staff</h3>
                <p class="text-[#3a5a78] text-center mb-6">
                    Are you sure you want to delete staff "<span class="font-semibold" x-text="selectedStaff?.fullname"></span>"? This action cannot be undone.
                </p>
                
                <div class="flex gap-3">
                    <button @click="showDeleteModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                    <button @click="deleteStaff()" 
                            class="flex-1 px-4 py-2.5 rounded-lg bg-red-500 text-white hover:bg-red-600 transition text-sm font-medium">
                        Delete
                    </button>
                </div>
            </div>
        </div>

    </main>

    <script>
        function staffManager() {
            return {
                // Staff data (will be loaded from server)
                staff: [],
                roles: [],
                
                searchQuery: '',
                statusFilter: 'all',
                roleFilter: 'all',
                joinedMonthFilter: 'all',
                joinedYearFilter: 'all',
                
                currentPage: 1,
                itemsPerPage: 10,
                
                // Modal properties
                showEditStatusModal: false,
                showEditRoleModal: false,
                showViewModal: false,
                showDeleteModal: false,
                
                selectedStaff: null,
                editStatusData: 'active',
                editRoleData: '2', // Default role ID (Staff)
                
                // Loading state
                loading: false,
                
                // Initialize component
                init: function() {
                    var self = this;
                    
                    // Reset to first page when filters change
                    this.$watch('filteredStaff', function() {
                        self.currentPage = 1;
                    });
                    
                    // Load data
                    this.loadStaff();
                    this.loadRoles();
                },
                
                // Load staff from server
                loadStaff: function() {
                    var self = this;
                    this.loading = true;
                    
                    fetch(contextPath + '/staff/api/list')
                        .then(response => response.json())
                        .then(data => {
                            self.staff = data;
                            self.loading = false;
                            console.log('Staff loaded:', data);
                        })
                        .catch(error => {
                            console.error('Error loading staff:', error);
                            if (window.showError) {
                                window.showError('Failed to load staff data', 3000);
                            }
                            self.loading = false;
                        });
                },
                
                // Load roles from server
                loadRoles: function() {
                    var self = this;
                    
                    fetch(contextPath + '/roles/api/list')
                        .then(response => response.json())
                        .then(data => {
                            self.roles = data;
                            console.log('Roles loaded:', data);
                        })
                        .catch(error => {
                            console.error('Error loading roles:', error);
                        });
                },
                
                // Get role counts for dropdown
                getRoleCounts: function() {
                    var counts = {};
                    
                    // Initialize with all roles from roles array
                    this.roles.forEach(function(role) {
                        counts[role.name] = 0;
                    });
                    
                    // Count staff by role
                    this.staff.forEach(function(staff) {
                        var roleName = this.getRoleNameFromId(staff.roleId);
                        if (counts[roleName]) {
                            counts[roleName]++;
                        } else {
                            counts[roleName] = 1;
                        }
                    }.bind(this));
                    
                    // Convert to array and sort by count
                    var result = [];
                    for (var role in counts) {
                        result.push({
                            name: role,
                            count: counts[role]
                        });
                    }
                    return result.sort(function(a, b) { return b.count - a.count; });
                },
                
                // Get role ID from role name
                getRoleIdFromName: function(roleName) {
                    var role = this.roles.find(r => r.name === roleName);
                    return role ? role.id : 2; // Default to 2 (Staff)
                },
                
                // Get role name from role ID
                getRoleNameFromId: function(roleId) {
                    var role = this.roles.find(r => r.id === roleId);
                    return role ? role.name : 'Staff';
                },
                
                // Filtered staff based on search and filters
                get filteredStaff() {
                    var self = this;
                    return this.staff.filter(staff => {
                        // Search filter - regno, name, username, email
                        if (this.searchQuery) {
                            var query = this.searchQuery.toLowerCase();
                            var matchesSearch = (staff.regNo && staff.regNo.toLowerCase().includes(query)) ||
                                                (staff.fullname && staff.fullname.toLowerCase().includes(query)) ||
                                                (staff.username && staff.username.toLowerCase().includes(query)) ||
                                                (staff.email && staff.email.toLowerCase().includes(query));
                            if (!matchesSearch) return false;
                        }
                        
                        // Status filter
                        if (this.statusFilter !== 'all' && staff.status !== this.statusFilter) {
                            return false;
                        }
                        
                        // Role filter - compare role name
                        if (this.roleFilter !== 'all') {
                            var roleName = this.getRoleNameFromId(staff.roleId);
                            if (roleName !== this.roleFilter) return false;
                        }
                        
                        // Joined date filters
                        if (staff.joinedDate) {
                            var joinedDate = new Date(staff.joinedDate);
                            
                            // Month filter
                            if (this.joinedMonthFilter !== 'all') {
                                var month = (joinedDate.getMonth() + 1).toString();
                                if (month.length === 1) month = '0' + month;
                                if (month !== this.joinedMonthFilter) return false;
                            }
                            
                            // Year filter
                            if (this.joinedYearFilter !== 'all') {
                                var year = joinedDate.getFullYear().toString();
                                if (year !== this.joinedYearFilter) return false;
                            }
                        }
                        
                        return true;
                    });
                },
                
                // Add role name to staff objects for display
                get staffWithRoleName() {
                    var self = this;
                    return this.staff.map(staff => {
                        return {
                            ...staff,
                            roleName: self.getRoleNameFromId(staff.roleId)
                        };
                    });
                },
                
                get paginatedStaff() {
                    var staffWithRoles = this.staffWithRoleName;
                    var filtered = staffWithRoles.filter(staff => {
                        // Apply filters again to ensure role name filter works
                        if (this.roleFilter !== 'all' && staff.roleName !== this.roleFilter) {
                            return false;
                        }
                        return true;
                    });
                    
                    var start = (this.currentPage - 1) * this.itemsPerPage;
                    var end = start + this.itemsPerPage;
                    return filtered.slice(start, end);
                },
                
                get totalPages() {
                    var staffWithRoles = this.staffWithRoleName;
                    var filtered = staffWithRoles.filter(staff => {
                        if (this.roleFilter !== 'all' && staff.roleName !== this.roleFilter) {
                            return false;
                        }
                        return true;
                    });
                    return Math.ceil(filtered.length / this.itemsPerPage);
                },
                
                // Count methods
                getActiveCount: function() {
                    return this.staff.filter(function(s) { return s.status === 'active'; }).length;
                },
                
                getInactiveCount: function() {
                    return this.staff.filter(function(s) { return s.status === 'inactive'; }).length;
                },
                
                getRolesCount: function() {
                    return this.roles.length;
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
                
                // Edit status
                editStatus: function(staff) {
                    this.selectedStaff = staff;
                    this.editStatusData = staff.status;
                    this.showEditStatusModal = true;
                },
                
                // Update status via API
                updateStaffStatus: function() {
                    var self = this;
                    var staffId = this.selectedStaff.id; // Store ID before any potential null
                    var newStatus = this.editStatusData;
                    
                    fetch(contextPath + '/staff/api/' + staffId + '?action=status', {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            status: newStatus
                        })
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Update local data
                            var index = self.staff.findIndex(s => s.id === staffId);
                            if (index !== -1) {
                                self.staff[index].status = newStatus;
                            }
                            
                            if (window.showSuccess) {
                                window.showSuccess(data.message, 3000);
                            }
                        } else {
                            if (window.showError) {
                                window.showError(data.message, 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error updating status:', error);
                        if (window.showError) {
                            window.showError('Failed to update status', 3000);
                        }
                    })
                    .finally(() => {
                        // Close modal only after API call completes
                        self.showEditStatusModal = false;
                        self.selectedStaff = null;
                    });
                },
                
                // Edit role
                editRole: function(staff) {
                    this.selectedStaff = staff;
                    this.editRoleData = staff.roleId.toString();
                    this.showEditRoleModal = true;
                },
                
                // Update role via API
                updateStaffRole: function() {
                    var self = this;
                    var staffId = this.selectedStaff.id; // Store ID before any potential null
                    var newRoleId = parseInt(this.editRoleData);
                    
                    fetch(contextPath + '/staff/api/' + staffId + '?action=role', {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            roleId: newRoleId
                        })
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Update local data
                            var index = self.staff.findIndex(s => s.id === staffId);
                            if (index !== -1) {
                                self.staff[index].roleId = newRoleId;
                            }
                            
                            if (window.showSuccess) {
                                window.showSuccess(data.message, 3000);
                            }
                        } else {
                            if (window.showError) {
                                window.showError(data.message, 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error updating role:', error);
                        if (window.showError) {
                            window.showError('Failed to update role', 3000);
                        }
                    })
                    .finally(() => {
                        // Close modal only after API call completes
                        self.showEditRoleModal = false;
                        self.selectedStaff = null;
                    });
                },
                
                // View staff details
                viewStaff: function(staff) {
                    this.selectedStaff = staff;
                    this.showViewModal = true;
                },
                
                // Confirm delete
                confirmDelete: function(staff) {
                    this.selectedStaff = staff;
                    this.showDeleteModal = true;
                },
                
                // Delete staff via API
                deleteStaff: function() {
                    var self = this;
                    var staffId = this.selectedStaff.id; // Store ID before any potential null
                    var staffName = this.selectedStaff.fullname; // Store name for message
                    
                    fetch(contextPath + '/staff/api/' + staffId, {
                        method: 'DELETE'
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Remove from local data
                            var index = self.staff.findIndex(s => s.id === staffId);
                            if (index !== -1) {
                                self.staff.splice(index, 1);
                            }
                            
                            if (window.showSuccess) {
                                window.showSuccess(data.message, 3000);
                            }
                            
                            // Adjust current page if necessary
                            if (self.paginatedStaff.length === 0 && self.currentPage > 1) {
                                self.currentPage--;
                            }
                        } else {
                            if (window.showError) {
                                window.showError(data.message, 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error deleting staff:', error);
                        if (window.showError) {
                            window.showError('Failed to delete staff', 3000);
                        }
                    })
                    .finally(() => {
                        // Close modal only after API call completes
                        self.showDeleteModal = false;
                        self.selectedStaff = null;
                    });
                },
                
                clearFilters: function() {
                    this.searchQuery = '';
                    this.statusFilter = 'all';
                    this.roleFilter = 'all';
                    this.joinedMonthFilter = 'all';
                    this.joinedYearFilter = 'all';
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
        
        // Get context path for API calls
        var contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 2));
        if (contextPath === '') contextPath = '';
    </script>
</body>
</html>