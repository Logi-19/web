<%-- 
    Document   : managetable
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · Manage Tables</title>
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
        .location-badge {
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
        .table-preview {
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        /* Image preview */
        .image-stack {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }
        .image-preview {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 0.5rem;
            border: 1px solid #e2e8f0;
        }
        .image-count {
            width: 40px;
            height: 40px;
            border-radius: 0.5rem;
            background-color: #f0f7fa;
            border: 1px solid #b5e5e0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 600;
            color: #0284a8;
        }
        /* Image gallery */
        .gallery-container {
            position: relative;
            width: 100%;
            height: 300px;
            overflow: hidden;
            border-radius: 0.75rem;
        }
        .gallery-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .gallery-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
            border: 1px solid #b5e5e0;
        }
        .gallery-nav:hover {
            background: white;
            transform: translateY(-50%) scale(1.1);
        }
        .gallery-nav.prev {
            left: 10px;
        }
        .gallery-nav.next {
            right: 10px;
        }
        .gallery-dots {
            position: absolute;
            bottom: 10px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 0.5rem;
        }
        .gallery-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.5);
            cursor: pointer;
            transition: all 0.2s;
        }
        .gallery-dot.active {
            background: #0284a8;
            transform: scale(1.2);
        }
        /* File upload */
        .file-upload-area {
            border: 2px dashed #b5e5e0;
            border-radius: 0.75rem;
            padding: 1rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
        }
        .file-upload-area:hover {
            border-color: #0284a8;
            background-color: #f0f7fa;
        }
        .image-previews {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-top: 1rem;
        }
        .preview-item {
            position: relative;
            width: 80px;
            height: 80px;
        }
        .preview-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 0.5rem;
            border: 1px solid #b5e5e0;
        }
        .remove-image {
            position: absolute;
            top: -5px;
            right: -5px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: #ef4444;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            cursor: pointer;
            border: 2px solid white;
        }
        /* Location dropdown with counts */
        .location-dropdown {
            max-height: 200px;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: #0284a8 #b5e5e0;
        }
        .location-dropdown::-webkit-scrollbar {
            width: 6px;
        }
        .location-dropdown::-webkit-scrollbar-track {
            background: #b5e5e0;
            border-radius: 10px;
        }
        .location-dropdown::-webkit-scrollbar-thumb {
            background: #0284a8;
            border-radius: 10px;
        }
        .location-option {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 1rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        .location-option:hover {
            background-color: #f0f7fa;
        }
        .location-option.selected {
            background-color: #b5e5e0;
            color: #0284a8;
            font-weight: 500;
        }
        .location-count {
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
    <main class="flex-1 overflow-y-auto" x-data="tableManager()" x-init="init()">
        <!-- top bar -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#b5e5e0] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">🍽️</span>
                <span class="font-semibold">Table Management</span>
            </div>
            <div class="flex items-center gap-3">
                <span class="bg-[#0284a8] text-white text-xs px-3 py-1.5 rounded-full" x-text="`${filteredTables.length} tables`"></span>
            </div>
        </header>

        <!-- dashboard content -->
        <div class="p-4 md:p-6 lg:p-8 space-y-6 max-w-full">

            <!-- Header with title and new table button -->
            <div class="flex justify-between items-center">
                <div>
                    <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Manage Tables 🍽️</h2>
                    <p class="text-[#3a5a78] text-base mt-1">Add, edit and manage restaurant tables</p>
                </div>
                <button @click="openNewTableModal()" 
                        class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Add Table
                </button>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-4 gap-4">
                <!-- Total Tables -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Total Tables</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="stats.total"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0]/30 flex items-center justify-center">
                            <span class="text-2xl">🍽️</span>
                        </div>
                    </div>
                </div>
                
                <!-- Available Tables -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Available</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="stats.available"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0] flex items-center justify-center">
                            <span class="text-2xl">✅</span>
                        </div>
                    </div>
                </div>
                
                <!-- Maintenance Tables -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Maintenance</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="stats.maintenance"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center">
                            <span class="text-2xl">🔧</span>
                        </div>
                    </div>
                </div>
                
                <!-- Locations with dropdown -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4 relative" x-data="{ showLocations: false }">
                    <div class="flex items-center justify-between cursor-pointer" @click="showLocations = !showLocations">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Locations</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="locationStats.length"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#9ac9c2] flex items-center justify-center">
                            <span class="text-2xl">📍</span>
                        </div>
                    </div>

                    <!-- Location dropdown with counts -->
                    <div x-show="showLocations" 
                         @click.away="showLocations = false"
                         class="absolute top-full left-0 right-0 mt-2 bg-white rounded-lg shadow-xl border border-[#b5e5e0] z-20 location-dropdown">
                        <div class="p-2">
                            <template x-for="location in locationStats" :key="location.name">
                                <div class="location-option">
                                    <span class="text-sm text-[#1e3c5c]" x-text="location.name"></span>
                                    <span class="location-count" x-text="location.count"></span>
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
                           @input.debounce.300ms="performSearch()"
                           placeholder="Search by table prefix or table number..." 
                           class="w-full pl-10 pr-4 py-3 rounded-xl border border-[#b5e5e0] focus:outline-none focus:ring-2 focus:ring-[#0284a8] focus:border-transparent text-sm">
                    <span class="absolute left-3 top-3.5 text-[#3a5a78] text-lg">🔍</span>
                </div>

                <!-- Filter Row -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
                    <!-- Status Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Status</label>
                        <select x-model="statusFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Status</option>
                            <option value="available">Available</option>
                            <option value="maintenance">Maintenance</option>
                        </select>
                    </div>

                    <!-- Location Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Location</label>
                        <select x-model="locationFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Locations</option>
                            <template x-for="location in locations" :key="location.id">
                                <option :value="location.id" x-text="location.name"></option>
                            </template>
                        </select>
                    </div>

                    <!-- Capacity Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Min Capacity</label>
                        <select x-model="capacityFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">Any</option>
                            <option value="2">2+ Persons</option>
                            <option value="4">4+ Persons</option>
                            <option value="6">6+ Persons</option>
                            <option value="8">8+ Persons</option>
                        </select>
                    </div>
                </div>

                <!-- Filter Actions -->
                <div class="flex flex-wrap justify-end gap-2 pt-2">
                    <button @click="clearFilters()" class="px-4 py-2 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Clear Filters
                    </button>
                    <button @click="refreshData()" class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                        Refresh
                    </button>
                </div>
            </div>

            <!-- Loading Indicator -->
            <div x-show="loading" class="text-center py-12">
                <div class="loading-spinner"></div>
                <p class="text-[#3a5a78] mt-4">Loading tables...</p>
            </div>

            <!-- Tables Table -->
            <div x-show="!loading" class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] overflow-hidden">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Table Prefix</th>
                                <th>Table No</th>
                                <th>Location</th>
                                <th>Capacity</th>
                                <th>Images</th>
                                <th>Status</th>
                                <th>Created Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template x-for="table in paginatedTables" :key="table.id">
                                <tr>
                                    <!-- Table Prefix -->
                                    <td>
                                        <div class="font-medium text-[#1e3c5c] text-sm" x-text="table.tablePrefix"></div>
                                    </td>
                                    
                                    <!-- Table No -->
                                    <td>
                                        <div class="text-sm text-[#1e3c5c] font-medium" x-text="table.tableNo"></div>
                                    </td>
                                    
                                    <!-- Location -->
                                    <td>
                                        <span class="location-badge text-xs"
                                              :class="{
                                                  'bg-blue-100 text-blue-700': table.locationName === '1st Floor',
                                                  'bg-green-100 text-green-700': table.locationName === '2nd Floor',
                                                  'bg-purple-100 text-purple-700': table.locationName === 'Beachside',
                                                  'bg-yellow-100 text-yellow-700': table.locationName === 'Poolside',
                                                  'bg-pink-100 text-pink-700': table.locationName === 'Rooftop',
                                                  'bg-orange-100 text-orange-700': table.locationName === 'Garden'
                                              }">
                                            <span x-text="table.locationName"></span>
                                        </span>
                                    </td>
                                    
                                    <!-- Capacity -->
                                    <td>
                                        <div class="text-sm text-[#1e3c5c]">
                                            <span x-text="table.capacity"></span> <span class="text-xs">persons</span>
                                        </div>
                                    </td>
                                    
                                    <!-- Images -->
                                    <td>
                                        <div class="image-stack">
                                            <template x-if="table.images && table.images.length > 0">
                                                <>
                                                    <img :src="table.images[0]" alt="Table" class="image-preview" 
                                                         onerror="this.src='https://via.placeholder.com/40?text=No+Image'">
                                                    <div x-show="table.images.length > 1" class="image-count">
                                                        +<span x-text="table.images.length - 1"></span>
                                                    </div>
                                                </>
                                            </template>
                                            <template x-if="!table.images || table.images.length === 0">
                                                <div class="image-preview bg-[#f0f7fa] flex items-center justify-center text-xs text-[#3a5a78]">No</div>
                                            </template>
                                        </div>
                                    </td>
                                    
                                    <!-- Status -->
                                    <td>
                                        <span class="status-badge text-xs"
                                              :class="{
                                                  'bg-[#b5e5e0] text-[#0284a8]': table.status === 'available',
                                                  'bg-gray-200 text-gray-700': table.status === 'maintenance'
                                              }">
                                            <span class="flex items-center justify-center gap-1">
                                                <span x-text="table.status === 'available' ? '✅' : '🔧'"></span>
                                                <span x-text="table.status === 'available' ? 'Available' : 'Maintenance'"></span>
                                            </span>
                                        </span>
                                    </td>
                                    
                                    <!-- Created Date -->
                                    <td>
                                        <div class="text-xs text-[#3a5a78]" x-text="formatShortDate(table.createdDate)"></div>
                                    </td>
                                    
                                    <!-- Actions -->
                                    <td>
                                        <div class="flex items-center gap-1">
                                            <!-- View Details -->
                                            <button @click="viewTable(table)" 
                                                    class="action-btn w-7 h-7 bg-[#b5e5e0] text-[#0284a8] hover:bg-[#9ac9c2]"
                                                    title="View Details">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                                </svg>
                                            </button>
                                            
                                            <!-- Edit Table -->
                                            <button @click="editTable(table)" 
                                                    class="action-btn w-7 h-7 bg-yellow-100 text-yellow-600 hover:bg-yellow-200"
                                                    title="Edit Table">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                                </svg>
                                            </button>
                                            
                                            <!-- Delete Table -->
                                            <button @click="confirmDelete(table)" 
                                                    class="action-btn w-7 h-7 bg-red-100 text-red-500 hover:bg-red-200"
                                                    title="Delete Table">
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
            <div x-show="!loading && filteredTables.length === 0" class="text-center py-12">
                <span class="text-5xl mb-3 block">🍽️</span>
                <p class="text-lg text-[#3a5a78]">No tables found matching your filters</p>
                <button @click="clearFilters()" class="mt-4 px-6 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                    Clear Filters
                </button>
            </div>

            <!-- Pagination with Items Per Page Selector -->
            <div x-show="!loading && filteredTables.length > 0" class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-6">
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
                    <span x-text="Math.min(currentPage * itemsPerPage, filteredTables.length)"></span> 
                    of <span x-text="filteredTables.length"></span>
                </div>
            </div>
        </div>

        <!-- Table Form Modal (New/Edit) -->
        <div x-show="showTableFormModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="closeTableFormModal()">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-2xl w-full p-6 transform transition-all max-h-[90vh] overflow-y-auto"
                 @click.stop>
                
                <div class="flex justify-between items-start mb-4">
                    <h3 class="text-xl font-bold text-[#1e3c5c]" x-text="formMode === 'new' ? 'Add New Table' : 'Edit Table'"></h3>
                    <button @click="closeTableFormModal()" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <form @submit.prevent="saveTable()" class="space-y-4">
                    <!-- Table Prefix (Read-only in edit mode) -->
                    <div x-show="formMode === 'edit'">
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Table Prefix</label>
                        <input type="text" 
                               x-model="formData.tablePrefix"
                               readonly
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm bg-gray-100 cursor-not-allowed">
                    </div>

                    <!-- Table No -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Table Number *</label>
                        <input type="text" 
                               x-model="formData.tableNo"
                               @blur="checkTableNumberExists"
                               required
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                        <div x-show="tableNumberExists" class="text-red-500 text-xs mt-1">Table number already exists</div>
                    </div>

                    <!-- Description -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Description *</label>
                        <textarea x-model="formData.description"
                                  required
                                  rows="3"
                                  class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]"></textarea>
                    </div>

                    <!-- Location (from TableLocation) -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Location *</label>
                        <select x-model="formData.locationId"
                                required
                                class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="">Select Location</option>
                            <template x-for="location in locations" :key="location.id">
                                <option :value="location.id" x-text="location.name"></option>
                            </template>
                        </select>
                    </div>

                    <!-- Capacity -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Capacity (persons) *</label>
                        <input type="number" 
                               x-model="formData.capacity"
                               required
                               min="1"
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                    </div>

                    <!-- Multiple Images Upload -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Table Images</label>
                        <div class="file-upload-area" @click="document.getElementById('image-upload').click()">
                            <input type="file" 
                                   id="image-upload"
                                   multiple
                                   accept="image/*"
                                   class="hidden"
                                   @change="handleImageUpload">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 mx-auto text-[#0284a8] mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            <p class="text-sm text-[#3a5a78]">Click to upload table images</p>
                            <p class="text-xs text-[#3a5a78] mt-1">You can select multiple images</p>
                        </div>
                        
                        <!-- Image Previews -->
                        <div class="image-previews" x-show="formData.images && formData.images.length > 0">
                            <template x-for="(image, index) in formData.images" :key="index">
                                <div class="preview-item">
                                    <img :src="image" class="preview-image" alt="Preview">
                                    <div class="remove-image" @click="removeImage(index)">×</div>
                                </div>
                            </template>
                        </div>
                    </div>

                    <!-- Status -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Status *</label>
                        <select x-model="formData.status"
                                required
                                class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="available">Available</option>
                            <option value="maintenance">Maintenance</option>
                        </select>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex justify-end gap-2 pt-4">
                        <button type="button" @click="closeTableFormModal()" 
                                class="px-4 py-2 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                            Cancel
                        </button>
                        <button type="submit" 
                                :disabled="tableNumberExists && formMode === 'new'"
                                class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium disabled:opacity-50 disabled:cursor-not-allowed">
                            <span x-text="formMode === 'new' ? 'Add Table' : 'Update Table'"></span>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- View Table Modal with Image Gallery -->
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
                    <h3 class="text-xl font-bold text-[#1e3c5c]">Table Details</h3>
                    <button @click="showViewModal = false" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <div class="space-y-4" x-show="selectedTable">
                    <!-- Image Gallery with Navigation -->
                    <div class="col-span-2" x-show="selectedTable?.images && selectedTable.images.length > 0">
                        <p class="text-sm text-[#3a5a78] mb-2">Table Images</p>
                        <div class="gallery-container">
                            <img :src="selectedTable.images[currentImageIndex]" class="gallery-image" 
                                 onerror="this.src='https://via.placeholder.com/800x400?text=No+Image'">
                            
                            <!-- Navigation -->
                            <button class="gallery-nav prev" @click="prevImage" x-show="selectedTable.images.length > 1">
                                ←
                            </button>
                            <button class="gallery-nav next" @click="nextImage" x-show="selectedTable.images.length > 1">
                                →
                            </button>
                            
                            <!-- Dots -->
                            <div class="gallery-dots" x-show="selectedTable.images.length > 1">
                                <template x-for="(_, index) in selectedTable.images" :key="index">
                                    <div class="gallery-dot" :class="{ 'active': currentImageIndex === index }" 
                                         @click="currentImageIndex = index"></div>
                                </template>
                            </div>
                        </div>
                    </div>
                    
                    <!-- No Images -->
                    <div class="col-span-2" x-show="!selectedTable?.images || selectedTable.images.length === 0">
                        <p class="text-sm text-[#3a5a78] mb-2">Table Images</p>
                        <div class="bg-[#f0f7fa] p-8 rounded-lg text-center text-[#3a5a78]">
                            No images available
                        </div>
                    </div>
                    
                    <!-- Details -->
                    <div class="grid grid-cols-2 gap-4 mt-4">
                        <!-- Table Prefix and No -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Table Prefix</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedTable?.tablePrefix"></p>
                        </div>
                        
                        <div>
                            <p class="text-sm text-[#3a5a78]">Table Number</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedTable?.tableNo"></p>
                        </div>
                        
                        <!-- Description (full width) -->
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Description</p>
                            <p class="text-[#1e3c5c] bg-[#f0f7fa] p-3 rounded-lg whitespace-pre-wrap" x-text="selectedTable?.description"></p>
                        </div>
                        
                        <!-- Location and Capacity -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Location</p>
                            <p class="font-medium">
                                <span class="location-badge"
                                      :class="{
                                          'bg-blue-100 text-blue-700': selectedTable?.locationName === '1st Floor',
                                          'bg-green-100 text-green-700': selectedTable?.locationName === '2nd Floor',
                                          'bg-purple-100 text-purple-700': selectedTable?.locationName === 'Beachside',
                                          'bg-yellow-100 text-yellow-700': selectedTable?.locationName === 'Poolside',
                                          'bg-pink-100 text-pink-700': selectedTable?.locationName === 'Rooftop',
                                          'bg-orange-100 text-orange-700': selectedTable?.locationName === 'Garden'
                                      }">
                                    <span x-text="selectedTable?.locationName"></span>
                                </span>
                            </p>
                        </div>
                        
                        <div>
                            <p class="text-sm text-[#3a5a78]">Capacity</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedTable?.capacity + ' persons'"></p>
                        </div>
                        
                        <!-- Status -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Status</p>
                            <p class="font-medium">
                                <span class="status-badge"
                                      :class="{
                                          'bg-[#b5e5e0] text-[#0284a8]': selectedTable?.status === 'available',
                                          'bg-gray-200 text-gray-700': selectedTable?.status === 'maintenance'
                                      }">
                                    <span class="flex items-center gap-1">
                                        <span x-text="selectedTable?.status === 'available' ? '✅' : '🔧'"></span>
                                        <span x-text="selectedTable?.status === 'available' ? 'Available' : 'Maintenance'"></span>
                                    </span>
                                </span>
                            </p>
                        </div>
                        
                        <!-- Created Date -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Created Date</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="formatDate(selectedTable?.createdDate)"></p>
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
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Delete Table</h3>
                <p class="text-[#3a5a78] text-center mb-6">
                    Are you sure you want to delete table "<span class="font-semibold" x-text="selectedTable?.tableNo"></span>"? This action cannot be undone.
                </p>
                
                <div class="flex gap-3">
                    <button @click="showDeleteModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                    <button @click="deleteTable()" 
                            class="flex-1 px-4 py-2.5 rounded-lg bg-red-500 text-white hover:bg-red-600 transition text-sm font-medium">
                        Delete
                    </button>
                </div>
            </div>
        </div>

    </main>

    <script>
        function tableManager() {
            return {
                // Data properties
                tables: [],
                locations: [],
                locationStats: [],
                stats: {
                    total: 0,
                    available: 0,
                    maintenance: 0
                },
                
                searchQuery: '',
                statusFilter: 'all',
                locationFilter: 'all',
                capacityFilter: 'all',
                
                currentPage: 1,
                itemsPerPage: 10,
                currentImageIndex: 0,
                loading: false,
                tableNumberExists: false,
                
                // Modal properties
                showTableFormModal: false,
                showViewModal: false,
                showDeleteModal: false,
                
                selectedTable: null,
                formMode: 'new', // 'new' or 'edit'
                
                formData: {
                    id: null,
                    tablePrefix: '',
                    tableNo: '',
                    description: '',
                    locationId: '',
                    capacity: '',
                    images: [],
                    status: 'available'
                },
                
                get filteredTables() {
                    let filtered = this.tables;
                    
                    // Search filter
                    if (this.searchQuery) {
                        var query = this.searchQuery.toLowerCase();
                        filtered = filtered.filter(table => 
                            table.tablePrefix.toLowerCase().includes(query) ||
                            table.tableNo.toLowerCase().includes(query)
                        );
                    }
                    
                    // Status filter
                    if (this.statusFilter !== 'all') {
                        filtered = filtered.filter(table => table.status === this.statusFilter);
                    }
                    
                    // Location filter
                    if (this.locationFilter !== 'all') {
                        filtered = filtered.filter(table => table.locationId == this.locationFilter);
                    }
                    
                    // Capacity filter
                    if (this.capacityFilter !== 'all') {
                        var minCapacity = parseInt(this.capacityFilter);
                        filtered = filtered.filter(table => table.capacity >= minCapacity);
                    }
                    
                    return filtered;
                },
                
                get paginatedTables() {
                    var start = (this.currentPage - 1) * this.itemsPerPage;
                    var end = start + this.itemsPerPage;
                    return this.filteredTables.slice(start, end);
                },
                
                get totalPages() {
                    return Math.ceil(this.filteredTables.length / this.itemsPerPage);
                },
                
                init: function() {
                    this.refreshData();
                    this.loadLocations();
                    
                    var self = this;
                    this.$watch('filteredTables', function() {
                        self.currentPage = 1;
                    });
                },
                
                // API Calls
                refreshData: function() {
                    this.loading = true;
                    var self = this;
                    
                    // Load tables
                    fetch('${pageContext.request.contextPath}/managetables/api/list')
                        .then(response => response.json())
                        .then(data => {
                            self.tables = data;
                            self.loading = false;
                        })
                        .catch(error => {
                            console.error('Error loading tables:', error);
                            self.loading = false;
                            if (window.showError) {
                                window.showError('Failed to load tables', 3000);
                            }
                        });
                    
                    // Load stats
                    fetch('${pageContext.request.contextPath}/managetables/api/stats')
                        .then(response => response.json())
                        .then(data => {
                            self.stats = data;
                        })
                        .catch(error => console.error('Error loading stats:', error));
                    
                    // Load location stats
                    fetch('${pageContext.request.contextPath}/managetables/api/location-stats')
                        .then(response => response.json())
                        .then(data => {
                            self.locationStats = data;
                        })
                        .catch(error => console.error('Error loading location stats:', error));
                },
                
                loadLocations: function() {
                    var self = this;
                    fetch('${pageContext.request.contextPath}/tablelocation/api/list')
                        .then(response => response.json())
                        .then(data => {
                            self.locations = data;
                        })
                        .catch(error => console.error('Error loading locations:', error));
                },
                
                performSearch: function() {
                    if (this.searchQuery.length > 0) {
                        this.loading = true;
                        var self = this;
                        
                        fetch('${pageContext.request.contextPath}/managetables/api/search?q=' + encodeURIComponent(this.searchQuery))
                            .then(response => response.json())
                            .then(data => {
                                self.tables = data;
                                self.loading = false;
                            })
                            .catch(error => {
                                console.error('Error searching tables:', error);
                                self.loading = false;
                            });
                    } else {
                        this.refreshData();
                    }
                },
                
                checkTableNumberExists: function() {
                    if (this.formData.tableNo && this.formMode === 'new') {
                        var self = this;
                        fetch('${pageContext.request.contextPath}/managetables/api/exists?tableNo=' + encodeURIComponent(this.formData.tableNo))
                            .then(response => response.json())
                            .then(data => {
                                self.tableNumberExists = data.exists;
                            })
                            .catch(error => console.error('Error checking table number:', error));
                    }
                },
                
                formatDate: function(dateString) {
                    if (!dateString) return '';
                    var options = { year: 'numeric', month: 'short', day: 'numeric' };
                    return new Date(dateString).toLocaleDateString('en-US', options);
                },
                
                formatShortDate: function(dateString) {
                    if (!dateString) return '';
                    var options = { year: 'numeric', month: 'short', day: 'numeric' };
                    return new Date(dateString).toLocaleDateString('en-US', options);
                },
                
                // Generate table prefix (for new tables)
                generateTablePrefix: function() {
                    fetch('${pageContext.request.contextPath}/managetables/api/next-prefix')
                        .then(response => response.json())
                        .then(data => {
                            this.formData.tablePrefix = data.prefix;
                        })
                        .catch(error => console.error('Error getting next prefix:', error));
                },
                
                // Handle multiple image upload
                handleImageUpload: function(event) {
                    var files = event.target.files;
                    var self = this;
                    
                    // Create FormData
                    var formData = new FormData();
                    for (var i = 0; i < files.length; i++) {
                        formData.append('images', files[i]);
                    }
                    
                    // Upload images
                    fetch('${pageContext.request.contextPath}/managetables/api/upload', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            data.images.forEach(function(imageUrl) {
                                self.formData.images.push(imageUrl);
                            });
                        } else {
                            if (window.showError) {
                                window.showError('Failed to upload images', 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error uploading images:', error);
                        if (window.showError) {
                            window.showError('Error uploading images', 3000);
                        }
                    });
                },
                
                // Remove image
                removeImage: function(index) {
                    this.formData.images.splice(index, 1);
                },
                
                // Reset form data
                resetFormData: function() {
                    this.formData = {
                        id: null,
                        tablePrefix: '',
                        tableNo: '',
                        description: '',
                        locationId: '',
                        capacity: '',
                        images: [],
                        status: 'available'
                    };
                    this.generateTablePrefix();
                },
                
                // Open new table modal
                openNewTableModal: function() {
                    this.resetFormData();
                    this.formMode = 'new';
                    this.tableNumberExists = false;
                    this.showTableFormModal = true;
                },
                
                // Edit table
                editTable: function(table) {
                    this.formData = {
                        id: table.id,
                        tablePrefix: table.tablePrefix,
                        tableNo: table.tableNo,
                        description: table.description,
                        locationId: table.locationId,
                        capacity: table.capacity,
                        images: table.images ? [...table.images] : [],
                        status: table.status
                    };
                    this.formMode = 'edit';
                    this.tableNumberExists = false;
                    this.showTableFormModal = true;
                },
                
                // Close table form modal
                closeTableFormModal: function() {
                    this.showTableFormModal = false;
                },
                
                // Save table (new or edit)
                saveTable: function() {
                    var self = this;
                    var url = this.formMode === 'new' 
                        ? '${pageContext.request.contextPath}/managetables/api/create'
                        : '${pageContext.request.contextPath}/managetables/api/' + this.formData.id;
                    
                    var method = this.formMode === 'new' ? 'POST' : 'PUT';
                    
                    fetch(url, {
                        method: method,
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(this.formData)
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            if (window.showSuccess) {
                                window.showSuccess(data.message, 3000);
                            }
                            self.closeTableFormModal();
                            self.refreshData();
                        } else {
                            if (window.showError) {
                                window.showError(data.message, 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error saving table:', error);
                        if (window.showError) {
                            window.showError('Error saving table', 3000);
                        }
                    });
                },
                
                // View table details
                viewTable: function(table) {
                    this.selectedTable = table;
                    this.currentImageIndex = 0;
                    this.showViewModal = true;
                },
                
                // Image navigation
                prevImage: function() {
                    if (this.currentImageIndex > 0) {
                        this.currentImageIndex--;
                    } else {
                        this.currentImageIndex = this.selectedTable.images.length - 1;
                    }
                },
                
                nextImage: function() {
                    if (this.currentImageIndex < this.selectedTable.images.length - 1) {
                        this.currentImageIndex++;
                    } else {
                        this.currentImageIndex = 0;
                    }
                },
                
                // Confirm delete
                confirmDelete: function(table) {
                    this.selectedTable = table;
                    this.showDeleteModal = true;
                },
                
                // Delete table
                deleteTable: function() {
                    var self = this;
                    
                    fetch('${pageContext.request.contextPath}/managetables/api/' + this.selectedTable.id, {
                        method: 'DELETE'
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            if (window.showSuccess) {
                                window.showSuccess(data.message, 3000);
                            }
                            self.showDeleteModal = false;
                            self.selectedTable = null;
                            self.refreshData();
                        } else {
                            if (window.showError) {
                                window.showError(data.message, 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error deleting table:', error);
                        if (window.showError) {
                            window.showError('Error deleting table', 3000);
                        }
                    });
                },
                
                clearFilters: function() {
                    this.searchQuery = '';
                    this.statusFilter = 'all';
                    this.locationFilter = 'all';
                    this.capacityFilter = 'all';
                    this.currentPage = 1;
                    this.refreshData();
                    
                    if (window.showInfo) {
                        window.showInfo('Filters cleared', 3000);
                    }
                },
                
                applyFilters: function() {
                    this.currentPage = 1;
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