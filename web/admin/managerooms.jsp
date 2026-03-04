<%-- 
    Document   : managerooms
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · Manage Rooms</title>
    <!-- Tailwind via CDN + Inter font + same subtle style -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <!-- Alpine.js for interactive components -->
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <!-- Include notification.jsp -->
    <jsp:include page="/component/notification.jsp" />
    <!-- Multi-select CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css">
    <!-- Multi-select JS -->
    <script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
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
        .type-badge {
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
        .room-preview {
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
        /* Type dropdown with counts */
        .type-dropdown {
            max-height: 200px;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: #0284a8 #b5e5e0;
        }
        .type-dropdown::-webkit-scrollbar {
            width: 6px;
        }
        .type-dropdown::-webkit-scrollbar-track {
            background: #b5e5e0;
            border-radius: 10px;
        }
        .type-dropdown::-webkit-scrollbar-thumb {
            background: #0284a8;
            border-radius: 10px;
        }
        .type-option {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 1rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        .type-option:hover {
            background-color: #f0f7fa;
        }
        .type-option.selected {
            background-color: #b5e5e0;
            color: #0284a8;
            font-weight: 500;
        }
        .type-count {
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
        .facilities-tag {
            display: inline-block;
            background-color: #e2e8f0;
            padding: 0.125rem 0.5rem;
            border-radius: 9999px;
            font-size: 0.7rem;
            margin-right: 0.25rem;
            margin-bottom: 0.25rem;
            color: #1e3c5c;
        }
        /* Choices.js custom styling */
        .choices__inner {
            background-color: white;
            border-color: #b5e5e0;
            border-radius: 0.75rem;
            min-height: 42px;
            padding: 4px 8px;
        }
        .choices__input {
            background-color: transparent;
            font-size: 0.875rem;
        }
        .choices__list--multiple .choices__item {
            background-color: #0284a8;
            border-color: #03738C;
            border-radius: 9999px;
            font-size: 0.75rem;
            padding: 2px 8px;
        }
        .choices__list--dropdown .choices__item--selectable.is-highlighted {
            background-color: #f0f7fa;
        }
    </style>
</head>
<body class="bg-[#f0f7fa] text-[#1e3c5c] antialiased flex">

    <!-- Include Sidebar -->
    <jsp:include page="/component/sidebar.jsp" />

    <!-- ===== MAIN DASHBOARD (right side) ===== -->
    <main class="flex-1 overflow-y-auto" x-data="roomManager()" x-init="init()">
        <!-- top bar -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#b5e5e0] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">🛏️</span>
                <span class="font-semibold">Room Management</span>
            </div>
            <div class="flex items-center gap-3">
                <span class="bg-[#0284a8] text-white text-xs px-3 py-1.5 rounded-full" x-text="`${filteredRooms.length} rooms`"></span>
            </div>
        </header>

        <!-- dashboard content -->
        <div class="p-4 md:p-6 lg:p-8 space-y-6 max-w-full">

            <!-- Header with title and new room button -->
            <div class="flex justify-between items-center">
                <div>
                    <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Manage Rooms 🛏️</h2>
                    <p class="text-[#3a5a78] text-base mt-1">Add, edit and manage room inventory</p>
                </div>
                <button @click="openNewRoomModal()" 
                        class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Add Room
                </button>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-4 gap-4">
                <!-- Total Rooms -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Total Rooms</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="rooms.length"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0]/30 flex items-center justify-center">
                            <span class="text-2xl">🛏️</span>
                        </div>
                    </div>
                </div>
                
                <!-- Available Rooms -->
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
                
                <!-- Maintenance Rooms -->
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
                
                <!-- Room Types with dropdown -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4 relative" x-data="{ showTypes: false }">
                    <div class="flex items-center justify-between cursor-pointer" @click="showTypes = !showTypes">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Room Types</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="roomTypes.length"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#9ac9c2] flex items-center justify-center">
                            <span class="text-2xl">🏷️</span>
                        </div>
                    </div>

                    <!-- Type dropdown with counts -->
                    <div x-show="showTypes" 
                         @click.away="showTypes = false"
                         class="absolute top-full left-0 right-0 mt-2 bg-white rounded-lg shadow-xl border border-[#b5e5e0] z-20 type-dropdown">
                        <div class="p-2">
                            <template x-if="roomTypeStats && roomTypeStats.length > 0">
                                <template x-for="type in roomTypeStats" :key="type.id">
                                    <div class="type-option">
                                        <span class="text-sm text-[#1e3c5c]" x-text="type.name"></span>
                                        <span class="type-count" x-text="type.count || type.roomCount || 0"></span>
                                    </div>
                                </template>
                            </template>
                            <template x-if="!roomTypeStats || roomTypeStats.length === 0">
                                <div class="text-center py-2 text-sm text-[#3a5a78]">No statistics available</div>
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
                           @input.debounce="performSearch()"
                           placeholder="Search by room prefix or room number..." 
                           class="w-full pl-10 pr-4 py-3 rounded-xl border border-[#b5e5e0] focus:outline-none focus:ring-2 focus:ring-[#0284a8] focus:border-transparent text-sm">
                    <span class="absolute left-3 top-3.5 text-[#3a5a78] text-lg">🔍</span>
                </div>

                <!-- Filter Row -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3">
                    <!-- Status Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Status</label>
                        <select x-model="statusFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Status</option>
                            <option value="available">Available</option>
                            <option value="maintenance">Maintenance</option>
                        </select>
                    </div>

                    <!-- Type Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Room Type</label>
                        <select x-model="typeFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Types</option>
                            <template x-for="type in roomTypes" :key="type.id">
                                <option :value="type.id" x-text="type.name"></option>
                            </template>
                        </select>
                    </div>

                    <!-- Facility Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Facilities</label>
                        <select x-model="facilityFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Facilities</option>
                            <template x-for="facility in facilities" :key="facility.id">
                                <option :value="facility.id" x-text="facility.name"></option>
                            </template>
                        </select>
                    </div>

                    <!-- Capacity Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Min Capacity</label>
                        <select x-model="capacityFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">Any</option>
                            <option value="1">1+ Person</option>
                            <option value="2">2+ Persons</option>
                            <option value="3">3+ Persons</option>
                            <option value="4">4+ Persons</option>
                        </select>
                    </div>

                    <!-- Price Range -->
                    <div class="flex gap-2">
                        <div class="flex-1">
                            <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Min $</label>
                            <input type="number" 
                                   x-model="priceFrom"
                                   @change="applyFilters()"
                                   min="0"
                                   placeholder="Min"
                                   class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                        </div>
                        <div class="flex-1">
                            <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Max $</label>
                            <input type="number" 
                                   x-model="priceTo"
                                   @change="applyFilters()"
                                   min="0"
                                   placeholder="Max"
                                   class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                        </div>
                    </div>
                </div>

                <!-- Filter Actions -->
                <div class="flex flex-wrap justify-end gap-2 pt-2">
                    <button @click="clearFilters()" class="px-4 py-2 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Clear Filters
                    </button>
                </div>
            </div>

            <!-- Rooms Table -->
            <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] overflow-hidden">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Room Prefix</th>
                                <th>Room No</th>
                                <th>Type</th>
                                <th>Facilities</th>
                                <th>Capacity</th>
                                <th>Price</th>
                                <th>Images</th>
                                <th>Status</th>
                                <th>Created Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template x-if="paginatedRooms && paginatedRooms.length > 0">
                                <template x-for="room in paginatedRooms" :key="room.id">
                                    <tr>
                                        <!-- Room Prefix -->
                                        <td>
                                            <div class="font-medium text-[#1e3c5c] text-sm" x-text="room.roomPrefix || ''"></div>
                                        </td>
                                        
                                        <!-- Room No -->
                                        <td>
                                            <div class="text-sm text-[#1e3c5c] font-medium" x-text="room.roomNo || ''"></div>
                                        </td>
                                        
                                        <!-- Type -->
                                        <td>
                                            <span class="type-badge text-xs"
                                                  :class="{
                                                      'bg-blue-100 text-blue-700': room.typeName === 'Standard',
                                                      'bg-green-100 text-green-700': room.typeName === 'Deluxe',
                                                      'bg-purple-100 text-purple-700': room.typeName === 'Suite',
                                                      'bg-yellow-100 text-yellow-700': room.typeName === 'Executive',
                                                      'bg-pink-100 text-pink-700': room.typeName === 'Presidential'
                                                  }">
                                                <span x-text="room.typeName || 'Unknown'"></span>
                                            </span>
                                        </td>
                                        
                                        <!-- Facilities -->
                                        <td>
                                            <div class="flex flex-wrap gap-1 max-w-[200px]">
                                                <template x-if="room.facilityNames && room.facilityNames.length > 0">
                                                    <template x-for="facility in room.facilityNames" :key="facility">
                                                        <span class="facilities-tag" x-text="facility"></span>
                                                    </template>
                                                </template>
                                                <span x-show="!room.facilityNames || room.facilityNames.length === 0" class="text-xs text-gray-400">No facilities</span>
                                            </div>
                                        </td>
                                        
                                        <!-- Capacity -->
                                        <td>
                                            <div class="text-sm text-[#1e3c5c]">
                                                <span x-text="room.capacity || 0"></span> <span class="text-xs">persons</span>
                                            </div>
                                        </td>
                                        
                                        <!-- Price -->
                                        <td>
                                            <div class="text-sm font-semibold text-[#0284a8]">$<span x-text="room.price || 0"></span></div>
                                        </td>
                                        
                                        <!-- Images -->
                                        <td>
                                            <div class="image-stack">
                                                <template x-if="room.images && room.images.length > 0">
                                                    <>
                                                        <img :src="room.images[0]" alt="Room" class="image-preview" 
                                                             onerror="this.src='https://via.placeholder.com/40?text=No+Image'">
                                                        <div x-show="room.images.length > 1" class="image-count">
                                                            +<span x-text="room.images.length - 1"></span>
                                                        </div>
                                                    </>
                                                </template>
                                                <template x-if="!room.images || room.images.length === 0">
                                                    <div class="image-preview bg-[#f0f7fa] flex items-center justify-center text-xs text-[#3a5a78]">No</div>
                                                </template>
                                            </div>
                                        </td>
                                        
                                        <!-- Status -->
                                        <td>
                                            <span class="status-badge text-xs"
                                                  :class="{
                                                      'bg-[#b5e5e0] text-[#0284a8]': room.status === 'available',
                                                      'bg-gray-200 text-gray-700': room.status === 'maintenance'
                                                  }">
                                                <span class="flex items-center justify-center gap-1">
                                                    <span x-text="room.status === 'available' ? '✅' : '🔧'"></span>
                                                    <span x-text="room.status === 'available' ? 'Available' : 'Maintenance'"></span>
                                                </span>
                                            </span>
                                        </td>
                                        
                                        <!-- Created Date -->
                                        <td>
                                            <div class="text-xs text-[#3a5a78]" x-text="formatShortDate(room.createdDate)"></div>
                                        </td>
                                        
                                        <!-- Actions -->
                                        <td>
                                            <div class="flex items-center gap-1">
                                                <!-- View Details -->
                                                <button @click="viewRoom(room)" 
                                                        class="action-btn w-7 h-7 bg-[#b5e5e0] text-[#0284a8] hover:bg-[#9ac9c2]"
                                                        title="View Details">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                                    </svg>
                                                </button>
                                                
                                                <!-- Edit Room -->
                                                <button @click="editRoom(room)" 
                                                        class="action-btn w-7 h-7 bg-yellow-100 text-yellow-600 hover:bg-yellow-200"
                                                        title="Edit Room">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                                    </svg>
                                                </button>
                                                
                                                <!-- Delete Room -->
                                                <button @click="confirmDelete(room)" 
                                                        class="action-btn w-7 h-7 bg-red-100 text-red-500 hover:bg-red-200"
                                                        title="Delete Room">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                                    </svg>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </template>
                            </template>
                            <template x-if="!paginatedRooms || paginatedRooms.length === 0">
                                <tr>
                                    <td colspan="10" class="text-center py-8 text-[#3a5a78]">
                                        No rooms to display
                                    </td>
                                </tr>
                            </template>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- No Results Message -->
            <div x-show="filteredRooms && filteredRooms.length === 0" class="text-center py-12">
                <span class="text-5xl mb-3 block">🛏️</span>
                <p class="text-lg text-[#3a5a78]">No rooms found matching your filters</p>
                <button @click="clearFilters()" class="mt-4 px-6 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                    Clear Filters
                </button>
            </div>

            <!-- Pagination with Items Per Page Selector -->
            <div x-show="filteredRooms && filteredRooms.length > 0" class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-6">
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
                    <template x-if="totalPages > 0">
                        <template x-for="page in totalPages" :key="page">
                            <button @click="goToPage(page)" 
                                    class="w-9 h-9 rounded-full border transition text-sm"
                                    :class="currentPage === page ? 'bg-[#0284a8] text-white border-[#0284a8]' : 'bg-white border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20'">
                                <span x-text="page"></span>
                            </button>
                        </template>
                    </template>
                    <button @click="nextPage" :disabled="currentPage === totalPages || totalPages === 0"
                            class="w-9 h-9 rounded-full bg-white border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition disabled:opacity-50 disabled:cursor-not-allowed text-sm">
                        →
                    </button>
                </div>
                
                <div class="text-sm text-[#3a5a78]">
                    <span x-show="filteredRooms && filteredRooms.length > 0">
                        Showing <span x-text="((currentPage - 1) * itemsPerPage) + 1"></span> - 
                        <span x-text="Math.min(currentPage * itemsPerPage, filteredRooms.length)"></span> 
                        of <span x-text="filteredRooms.length"></span>
                    </span>
                </div>
            </div>
        </div>

        <!-- Room Form Modal (New/Edit) -->
        <div x-show="showRoomFormModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="closeRoomFormModal()">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-2xl w-full p-6 transform transition-all max-h-[90vh] overflow-y-auto"
                 @click.stop>
                
                <div class="flex justify-between items-start mb-4">
                    <h3 class="text-xl font-bold text-[#1e3c5c]" x-text="formMode === 'new' ? 'Add New Room' : 'Edit Room'"></h3>
                    <button @click="closeRoomFormModal()" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <form @submit.prevent="saveRoom()" class="space-y-4">
                    <!-- Room Prefix (Read-only in edit mode) -->
                    <div x-show="formMode === 'edit'">
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Room Prefix</label>
                        <input type="text" 
                               x-model="formData.roomPrefix"
                               readonly
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm bg-gray-100 cursor-not-allowed">
                    </div>

                    <!-- Room No -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Room Number *</label>
                        <input type="text" 
                               x-model="formData.roomNo"
                               @blur="checkRoomNumberExists()"
                               required
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                        <p x-show="roomNumberError" class="text-xs text-red-500 mt-1" x-text="roomNumberError"></p>
                    </div>

                    <!-- Description -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Description *</label>
                        <textarea x-model="formData.description"
                                  required
                                  rows="3"
                                  class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]"></textarea>
                    </div>

                    <!-- Type -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Room Type *</label>
                        <select x-model="formData.typeId"
                                required
                                class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="">Select Type</option>
                            <template x-for="type in roomTypes" :key="type.id">
                                <option :value="type.id" x-text="type.name"></option>
                            </template>
                        </select>
                    </div>

                    <!-- Facilities (Multi-select) -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Facilities *</label>
                        <select x-ref="facilitySelect" 
                                id="facility-select"
                                multiple
                                class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <template x-for="facility in facilities" :key="facility.id">
                                <option :value="facility.id" x-text="facility.name" :selected="formData.facilityIds && formData.facilityIds.includes(facility.id)"></option>
                            </template>
                        </select>
                        <p class="text-xs text-[#3a5a78] mt-1">Select multiple facilities</p>
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

                    <!-- Price -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Price per Night ($) *</label>
                        <input type="number" 
                               x-model="formData.price"
                               required
                               min="0"
                               step="0.01"
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                    </div>

                    <!-- Multiple Images Upload -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Room Images</label>
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
                            <p class="text-sm text-[#3a5a78]">Click to upload room images</p>
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
                        <button type="button" @click="closeRoomFormModal()" 
                                class="px-4 py-2 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                            Cancel
                        </button>
                        <button type="submit" 
                                class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                            <span x-text="formMode === 'new' ? 'Add Room' : 'Update Room'"></span>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- View Room Modal with Image Gallery -->
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
                    <h3 class="text-xl font-bold text-[#1e3c5c]">Room Details</h3>
                    <button @click="showViewModal = false" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <div class="space-y-4" x-show="selectedRoom">
                    <!-- Image Gallery with Navigation -->
                    <div class="col-span-2" x-show="selectedRoom && selectedRoom.images && selectedRoom.images.length > 0">
                        <p class="text-sm text-[#3a5a78] mb-2">Room Images</p>
                        <div class="gallery-container">
                            <img :src="selectedRoom.images[currentImageIndex]" class="gallery-image" 
                                 onerror="this.src='https://via.placeholder.com/800x400?text=No+Image'">
                            
                            <!-- Navigation -->
                            <button class="gallery-nav prev" @click="prevImage" x-show="selectedRoom.images.length > 1">
                                ←
                            </button>
                            <button class="gallery-nav next" @click="nextImage" x-show="selectedRoom.images.length > 1">
                                →
                            </button>
                            
                            <!-- Dots -->
                            <div class="gallery-dots" x-show="selectedRoom.images.length > 1">
                                <template x-for="(_, index) in selectedRoom.images" :key="index">
                                    <div class="gallery-dot" :class="{ 'active': currentImageIndex === index }" 
                                         @click="currentImageIndex = index"></div>
                                </template>
                            </div>
                        </div>
                    </div>
                    
                    <!-- No Images -->
                    <div class="col-span-2" x-show="!selectedRoom || !selectedRoom.images || selectedRoom.images.length === 0">
                        <p class="text-sm text-[#3a5a78] mb-2">Room Images</p>
                        <div class="bg-[#f0f7fa] p-8 rounded-lg text-center text-[#3a5a78]">
                            No images available
                        </div>
                    </div>
                    
                    <!-- Details -->
                    <div class="grid grid-cols-2 gap-4 mt-4">
                        <!-- Room Prefix and No -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Room Prefix</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedRoom?.roomPrefix || ''"></p>
                        </div>
                        
                        <div>
                            <p class="text-sm text-[#3a5a78]">Room Number</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedRoom?.roomNo || ''"></p>
                        </div>
                        
                        <!-- Description (full width) -->
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Description</p>
                            <p class="text-[#1e3c5c] bg-[#f0f7fa] p-3 rounded-lg whitespace-pre-wrap" x-text="selectedRoom?.description || ''"></p>
                        </div>
                        
                        <!-- Type and Capacity -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Room Type</p>
                            <p class="font-medium">
                                <span class="type-badge"
                                      :class="{
                                          'bg-blue-100 text-blue-700': selectedRoom?.typeName === 'Standard',
                                          'bg-green-100 text-green-700': selectedRoom?.typeName === 'Deluxe',
                                          'bg-purple-100 text-purple-700': selectedRoom?.typeName === 'Suite',
                                          'bg-yellow-100 text-yellow-700': selectedRoom?.typeName === 'Executive',
                                          'bg-pink-100 text-pink-700': selectedRoom?.typeName === 'Presidential'
                                      }">
                                    <span x-text="selectedRoom?.typeName || 'Unknown'"></span>
                                </span>
                            </p>
                        </div>
                        
                        <div>
                            <p class="text-sm text-[#3a5a78]">Capacity</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedRoom?.capacity ? selectedRoom.capacity + ' persons' : ''"></p>
                        </div>
                        
                        <!-- Facilities -->
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Facilities</p>
                            <div class="flex flex-wrap gap-1 mt-1">
                                <template x-if="selectedRoom && selectedRoom.facilityNames && selectedRoom.facilityNames.length > 0">
                                    <template x-for="facility in selectedRoom.facilityNames" :key="facility">
                                        <span class="facilities-tag" x-text="facility"></span>
                                    </template>
                                </template>
                                <span x-show="!selectedRoom || !selectedRoom.facilityNames || selectedRoom.facilityNames.length === 0" class="text-xs text-gray-400">No facilities</span>
                            </div>
                        </div>
                        
                        <!-- Price and Status -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Price per Night</p>
                            <p class="font-semibold text-[#0284a8] text-lg">$<span x-text="selectedRoom?.price || '0'"></span></p>
                        </div>
                        
                        <div>
                            <p class="text-sm text-[#3a5a78]">Status</p>
                            <p class="font-medium">
                                <span class="status-badge"
                                      :class="{
                                          'bg-[#b5e5e0] text-[#0284a8]': selectedRoom?.status === 'available',
                                          'bg-gray-200 text-gray-700': selectedRoom?.status === 'maintenance'
                                      }">
                                    <span class="flex items-center gap-1">
                                        <span x-text="selectedRoom?.status === 'available' ? '✅' : selectedRoom?.status === 'maintenance' ? '🔧' : ''"></span>
                                        <span x-text="selectedRoom?.status === 'available' ? 'Available' : selectedRoom?.status === 'maintenance' ? 'Maintenance' : ''"></span>
                                    </span>
                                </span>
                            </p>
                        </div>
                        
                        <!-- Created Date -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Created Date</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedRoom ? formatDate(selectedRoom.createdDate) : ''"></p>
                        </div>
                    </div>
                </div>
                
                <!-- Loading or empty state when selectedRoom is null -->
                <div x-show="!selectedRoom" class="text-center py-8">
                    <p class="text-[#3a5a78]">No room selected</p>
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
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Delete Room</h3>
                <p class="text-[#3a5a78] text-center mb-6">
                    Are you sure you want to delete room "<span class="font-semibold" x-text="selectedRoom?.roomNo"></span>"? This action cannot be undone.
                </p>
                
                <div class="flex gap-3">
                    <button @click="showDeleteModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                    <button @click="deleteRoom()" 
                            class="flex-1 px-4 py-2.5 rounded-lg bg-red-500 text-white hover:bg-red-600 transition text-sm font-medium">
                        Delete
                    </button>
                </div>
            </div>
        </div>

    </main>

    <script>
        function roomManager() {
            return {
                // Data properties
                rooms: [],
                filteredRooms: [],
                roomTypes: [],
                facilities: [],
                roomTypeStats: [],
                stats: {
                    total: 0,
                    available: 0,
                    maintenance: 0
                },
                
                // Filter properties
                searchQuery: '',
                statusFilter: 'all',
                typeFilter: 'all',
                facilityFilter: 'all',
                capacityFilter: 'all',
                priceFrom: '',
                priceTo: '',
                
                // Pagination
                currentPage: 1,
                itemsPerPage: 10,
                currentImageIndex: 0,
                
                // Modal properties
                showRoomFormModal: false,
                showViewModal: false,
                showDeleteModal: false,
                
                // Form properties
                selectedRoom: null,
                formMode: 'new',
                formData: {
                    id: null,
                    roomPrefix: '',
                    roomNo: '',
                    description: '',
                    typeId: '',
                    facilityIds: [],
                    capacity: '',
                    price: '',
                    images: [],
                    status: 'available'
                },
                
                // Validation
                roomNumberError: '',
                facilitySelect: null,
                
                // Initialize
                init: function() {
                    this.loadRoomTypes();
                    this.loadFacilities();
                    this.loadRooms();
                    this.loadStats();
                    this.loadRoomTypeStats();
                    
                    // Reset to first page when filters change
                    this.$watch('filteredRooms', () => {
                        this.currentPage = 1;
                    });
                    
                    console.log('Room Manager initialized');
                },
                
                // API Calls
                loadRoomTypes: function() {
                    fetch('${pageContext.request.contextPath}/roomtypes/api/list')
                        .then(response => response.json())
                        .then(data => {
                            this.roomTypes = Array.isArray(data) ? data : [];
                        })
                        .catch(error => {
                            console.error('Error loading room types:', error);
                            if (window.showError) {
                                window.showError('Failed to load room types', 3000);
                            }
                            this.roomTypes = [];
                        });
                },
                
                loadFacilities: function() {
                    fetch('${pageContext.request.contextPath}/facility/api/list')
                        .then(response => response.json())
                        .then(data => {
                            this.facilities = Array.isArray(data) ? data : [];
                        })
                        .catch(error => {
                            console.error('Error loading facilities:', error);
                            if (window.showError) {
                                window.showError('Failed to load facilities', 3000);
                            }
                            this.facilities = [];
                        });
                },
                
                loadRooms: function() {
                    console.log('Loading rooms...');
                    fetch('${pageContext.request.contextPath}/managerooms/api/list')
                        .then(response => {
                            console.log('Response status:', response.status);
                            if (!response.ok) {
                                throw new Error('HTTP error ' + response.status);
                            }
                            return response.text();
                        })
                        .then(text => {
                            console.log('Raw response:', text.substring(0, 200));
                            try {
                                const data = JSON.parse(text);
                                console.log('Parsed data:', data);
                                // Ensure data is an array
                                this.rooms = Array.isArray(data) ? data : [];
                                this.applyFilters();
                                if (window.showSuccess) {
                                    window.showSuccess('Loaded ' + this.rooms.length + ' rooms', 2000);
                                }
                            } catch (e) {
                                console.error('JSON parse error:', e);
                                console.error('Response was:', text);
                                this.rooms = [];
                                this.filteredRooms = [];
                                if (window.showError) {
                                    window.showError('Invalid response from server', 3000);
                                }
                            }
                        })
                        .catch(error => {
                            console.error('Error loading rooms:', error);
                            this.rooms = [];
                            this.filteredRooms = [];
                            if (window.showError) {
                                window.showError('Failed to load rooms: ' + error.message, 3000);
                            }
                        });
                },
                
                loadStats: function() {
                    fetch('${pageContext.request.contextPath}/managerooms/api/stats')
                        .then(response => response.json())
                        .then(data => {
                            this.stats = data || { total: 0, available: 0, maintenance: 0 };
                        })
                        .catch(error => {
                            console.error('Error loading stats:', error);
                            this.stats = { total: 0, available: 0, maintenance: 0 };
                        });
                },
                
                loadRoomTypeStats: function() {
                    fetch('${pageContext.request.contextPath}/managerooms/api/room-types-with-counts')
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('HTTP error ' + response.status);
                            }
                            return response.text();
                        })
                        .then(text => {
                            try {
                                const data = JSON.parse(text);
                                this.roomTypeStats = Array.isArray(data) ? data : [];
                            } catch (e) {
                                console.error('Invalid JSON response:', text.substring(0, 200));
                                this.roomTypeStats = [];
                                if (window.showError) {
                                    window.showError('Failed to load room type statistics', 3000);
                                }
                            }
                        })
                        .catch(error => {
                            console.error('Error loading room type stats:', error);
                            this.roomTypeStats = [];
                        });
                },
                
                checkRoomNumberExists: function() {
                    if (!this.formData.roomNo) return;
                    
                    let url = '${pageContext.request.contextPath}/managerooms/api/exists?roomNo=' + encodeURIComponent(this.formData.roomNo);
                    if (this.formMode === 'edit' && this.formData.id) {
                        url += '&excludeId=' + this.formData.id;
                    }
                    
                    fetch(url)
                        .then(response => response.json())
                        .then(data => {
                            if (data.exists) {
                                this.roomNumberError = 'Room number already exists';
                            } else {
                                this.roomNumberError = '';
                            }
                        })
                        .catch(error => console.error('Error checking room number:', error));
                },
                
                performSearch: function() {
                    if (this.searchQuery) {
                        fetch('${pageContext.request.contextPath}/managerooms/api/search?q=' + encodeURIComponent(this.searchQuery))
                            .then(response => response.json())
                            .then(data => {
                                this.filteredRooms = Array.isArray(data) ? data : [];
                            })
                            .catch(error => {
                                console.error('Error searching rooms:', error);
                                this.filteredRooms = [];
                            });
                    } else {
                        this.applyFilters();
                    }
                },
                
                applyFilters: function() {
                    let params = new URLSearchParams();
                    
                    if (this.searchQuery) params.append('keyword', this.searchQuery);
                    if (this.typeFilter !== 'all') params.append('typeId', this.typeFilter);
                    if (this.statusFilter !== 'all') params.append('status', this.statusFilter);
                    if (this.capacityFilter !== 'all') params.append('minCapacity', this.capacityFilter);
                    if (this.priceFrom) params.append('minPrice', this.priceFrom);
                    if (this.priceTo) params.append('maxPrice', this.priceTo);
                    if (this.facilityFilter !== 'all') params.append('facilityIds', '[' + this.facilityFilter + ']');
                    
                    fetch('${pageContext.request.contextPath}/managerooms/api/advanced-search?' + params)
                        .then(response => response.json())
                        .then(data => {
                            this.filteredRooms = Array.isArray(data) ? data : [];
                        })
                        .catch(error => {
                            console.error('Error applying filters:', error);
                            this.filteredRooms = [];
                        });
                },
                
                clearFilters: function() {
                    this.searchQuery = '';
                    this.statusFilter = 'all';
                    this.typeFilter = 'all';
                    this.facilityFilter = 'all';
                    this.capacityFilter = 'all';
                    this.priceFrom = '';
                    this.priceTo = '';
                    this.currentPage = 1;
                    this.loadRooms();
                    
                    if (window.showInfo) {
                        window.showInfo('Filters cleared', 3000);
                    }
                },
                
                // Pagination methods
                get paginatedRooms() {
                    if (!Array.isArray(this.filteredRooms) || this.filteredRooms.length === 0) {
                        return [];
                    }
                    let start = (this.currentPage - 1) * this.itemsPerPage;
                    let end = start + this.itemsPerPage;
                    return this.filteredRooms.slice(start, end);
                },
                
                get totalPages() {
                    if (!Array.isArray(this.filteredRooms)) {
                        return 0;
                    }
                    return Math.ceil(this.filteredRooms.length / this.itemsPerPage);
                },
                
                prevPage: function() {
                    if (this.currentPage > 1) this.currentPage--;
                },
                
                nextPage: function() {
                    if (this.currentPage < this.totalPages) this.currentPage++;
                },
                
                goToPage: function(page) {
                    this.currentPage = page;
                },
                
                // Modal methods
                openNewRoomModal: function() {
                    this.resetFormData();
                    this.formMode = 'new';
                    this.showRoomFormModal = true;
                    
                    setTimeout(() => {
                        this.initFacilitySelect();
                    }, 100);
                },
                
                editRoom: function(room) {
                    this.formData = {
                        id: room.id,
                        roomPrefix: room.roomPrefix,
                        roomNo: room.roomNo,
                        description: room.description,
                        typeId: room.typeId,
                        facilityIds: room.facilityIds ? [...room.facilityIds] : [],
                        capacity: room.capacity,
                        price: room.price,
                        images: room.images ? [...room.images] : [],
                        status: room.status
                    };
                    this.formMode = 'edit';
                    this.showRoomFormModal = true;
                    
                    setTimeout(() => {
                        this.initFacilitySelect();
                    }, 100);
                },
                
                closeRoomFormModal: function() {
                    this.showRoomFormModal = false;
                    if (this.facilitySelect) {
                        this.facilitySelect.destroy();
                        this.facilitySelect = null;
                    }
                },
                
                initFacilitySelect: function() {
                    if (this.facilitySelect) {
                        this.facilitySelect.destroy();
                    }
                    
                    const element = document.getElementById('facility-select');
                    if (element) {
                        this.facilitySelect = new Choices(element, {
                            removeItemButton: true,
                            placeholder: true,
                            placeholderValue: 'Select facilities',
                            searchEnabled: true,
                            searchChoices: true,
                            shouldSort: false,
                            itemSelectText: ''
                        });
                        
                        if (this.formData.facilityIds && this.formData.facilityIds.length > 0) {
                            this.formData.facilityIds.forEach(id => {
                                this.facilitySelect.setChoiceByValue(id.toString());
                            });
                        }
                    }
                },
                
                saveRoom: function() {
                    if (this.facilitySelect) {
                        this.formData.facilityIds = this.facilitySelect.getValue(true).map(val => parseInt(val));
                    }
                    
                    if (!this.formData.roomNo || !this.formData.description || !this.formData.typeId || 
                        !this.formData.facilityIds || this.formData.facilityIds.length === 0 ||
                        !this.formData.capacity || !this.formData.price) {
                        if (window.showError) {
                            window.showError('Please fill in all required fields', 3000);
                        }
                        return;
                    }
                    
                    if (this.roomNumberError) {
                        if (window.showError) {
                            window.showError('Please fix the room number error', 3000);
                        }
                        return;
                    }
                    
                    let url = '${pageContext.request.contextPath}/managerooms/api/';
                    let method = 'POST';
                    
                    if (this.formMode === 'edit') {
                        url += this.formData.id;
                        method = 'PUT';
                    } else {
                        url += 'create';
                    }
                    
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
                            this.loadRooms();
                            this.loadStats();
                            this.loadRoomTypeStats();
                            this.closeRoomFormModal();
                        } else {
                            if (window.showError) {
                                window.showError(data.message, 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error saving room:', error);
                        if (window.showError) {
                            window.showError('Failed to save room', 3000);
                        }
                    });
                },
                
                viewRoom: function(room) {
                    this.selectedRoom = room;
                    this.currentImageIndex = 0;
                    this.showViewModal = true;
                },
                
                prevImage: function() {
                    if (this.selectedRoom && this.selectedRoom.images && this.currentImageIndex > 0) {
                        this.currentImageIndex--;
                    } else if (this.selectedRoom && this.selectedRoom.images) {
                        this.currentImageIndex = this.selectedRoom.images.length - 1;
                    }
                },
                
                nextImage: function() {
                    if (this.selectedRoom && this.selectedRoom.images && this.currentImageIndex < this.selectedRoom.images.length - 1) {
                        this.currentImageIndex++;
                    } else if (this.selectedRoom && this.selectedRoom.images) {
                        this.currentImageIndex = 0;
                    }
                },
                
                confirmDelete: function(room) {
                    this.selectedRoom = room;
                    this.showDeleteModal = true;
                },
                
                deleteRoom: function() {
                    fetch('${pageContext.request.contextPath}/managerooms/api/' + this.selectedRoom.id, {
                        method: 'DELETE'
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            if (window.showSuccess) {
                                window.showSuccess(data.message, 3000);
                            }
                            this.loadRooms();
                            this.loadStats();
                            this.loadRoomTypeStats();
                            this.showDeleteModal = false;
                            this.selectedRoom = null;
                        } else {
                            if (window.showError) {
                                window.showError(data.message, 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error deleting room:', error);
                        if (window.showError) {
                            window.showError('Failed to delete room', 3000);
                        }
                    });
                },
                
                handleImageUpload: function(event) {
                    let files = event.target.files;
                    let formData = new FormData();
                    
                    for (let i = 0; i < files.length; i++) {
                        formData.append('images', files[i]);
                    }
                    
                    fetch('${pageContext.request.contextPath}/managerooms/api/upload', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            this.formData.images = [...(this.formData.images || []), ...(data.images || [])];
                        } else {
                            if (window.showError) {
                                window.showError('Failed to upload images', 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error uploading images:', error);
                        if (window.showError) {
                            window.showError('Failed to upload images', 3000);
                        }
                    });
                },
                
                removeImage: function(index) {
                    if (this.formData.images) {
                        this.formData.images.splice(index, 1);
                    }
                },
                
                resetFormData: function() {
                    this.formData = {
                        id: null,
                        roomPrefix: '',
                        roomNo: '',
                        description: '',
                        typeId: '',
                        facilityIds: [],
                        capacity: '',
                        price: '',
                        images: [],
                        status: 'available'
                    };
                    this.roomNumberError = '';
                    
                    fetch('${pageContext.request.contextPath}/managerooms/api/next-prefix')
                        .then(response => response.json())
                        .then(data => {
                            this.formData.roomPrefix = data.prefix;
                        })
                        .catch(error => console.error('Error getting next prefix:', error));
                },
                
                formatDate: function(dateString) {
                    if (!dateString) return '';
                    try {
                        let options = { year: 'numeric', month: 'short', day: 'numeric' };
                        return new Date(dateString).toLocaleDateString('en-US', options);
                    } catch (e) {
                        return '';
                    }
                },
                
                formatShortDate: function(dateString) {
                    if (!dateString) return '';
                    try {
                        let options = { year: 'numeric', month: 'short', day: 'numeric' };
                        return new Date(dateString).toLocaleDateString('en-US', options);
                    } catch (e) {
                        return '';
                    }
                }
            }
        }
    </script>
</body>
</html>