<%-- 
    Document   : booktabledetails
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · Table Booking Details</title>
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
        .card-dash:hover { transform: translateY(-2px); box-shadow: 0 16px 24px -8px rgba(212, 163, 115, 0.12); }
        .stat-glow { text-shadow: 0 2px 5px rgba(212, 163, 115, 0.2); }
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
            border-bottom: 2px solid #d4a373;
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
            background-color: #fff9f0;
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
        /* Guest info styles */
        .guest-info-card {
            background-color: #fff9f0;
            border-radius: 1rem;
            padding: 1rem;
            border: 1px solid #d4a373;
        }
        .guest-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #d4a373, #b88b4a);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            font-weight: 600;
        }
        /* Table info styles */
        .table-info-card {
            background-color: #fff9f0;
            border-radius: 1rem;
            padding: 1rem;
            border: 1px solid #d4a373;
        }
        /* Date time styles */
        .datetime-box {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.75rem;
            background-color: #fff9f0;
            border-radius: 1rem;
        }
        .date-box {
            flex: 1;
            text-align: center;
            padding: 0.5rem;
            background-color: white;
            border-radius: 0.75rem;
            border: 1px solid #d4a373;
        }
        .date-box .label {
            font-size: 0.7rem;
            color: #3a5a78;
            text-transform: uppercase;
        }
        .date-box .value {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1e3c5c;
        }
        .date-box .time {
            font-size: 0.8rem;
            color: #d4a373;
        }
        .date-arrow {
            color: #d4a373;
            font-size: 1.2rem;
        }
        /* Price highlight */
        .price-highlight {
            background: linear-gradient(135deg, #d4a373, #b88b4a);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-weight: 600;
            display: inline-block;
        }
        /* Party size indicator */
        .party-size {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .party-size i {
            color: #d4a373;
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
        /* Status select */
        .status-select {
            padding: 0.25rem 0.5rem;
            border-radius: 0.5rem;
            border: 1px solid #d4a373;
            font-size: 0.75rem;
            font-weight: 600;
            background-color: white;
            cursor: pointer;
        }
        .status-select:focus {
            outline: none;
            border-color: #d4a373;
            ring: 2px solid #d4a373;
        }
        [x-cloak] { display: none !important; }
    </style>
</head>
<body class="bg-[#fff9f0] text-[#1e3c5c] antialiased flex">

    <!-- Include Sidebar -->
    <jsp:include page="/component/sidebar.jsp" />

    <!-- ===== MAIN DASHBOARD (right side) ===== -->
    <main class="flex-1 overflow-y-auto" x-data="tableBookingDetailsManager()" x-init="init()">
        <!-- top bar -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#d4a373] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">🍽️</span>
                <span class="font-semibold">Table Booking Details</span>
            </div>
            <div class="flex items-center gap-3">
                <span class="bg-[#d4a373] text-white text-xs px-3 py-1.5 rounded-full" x-text="`${filteredBookings.length} bookings`"></span>
            </div>
        </header>

        <!-- dashboard content -->
        <div class="p-4 md:p-6 lg:p-8 space-y-6 max-w-full">

            <!-- Header with title -->
            <div class="flex justify-between items-center">
                <div>
                    <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Table Booking Details 🍽️</h2>
                    <p class="text-[#3a5a78] text-base mt-1">View and manage all table reservations</p>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
                <!-- Total Bookings -->
                <div class="bg-white rounded-xl shadow-md border border-[#d4a373] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Total Bookings</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="stats.total || 0"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#d4a373]/30 flex items-center justify-center">
                            <span class="text-2xl">📋</span>
                        </div>
                    </div>
                </div>
                
                <!-- Pending -->
                <div class="bg-white rounded-xl shadow-md border border-[#d4a373] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Pending</p>
                            <p class="text-3xl font-bold text-yellow-600" x-text="stats.pending || 0"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-yellow-100 flex items-center justify-center">
                            <span class="text-2xl">⏳</span>
                        </div>
                    </div>
                </div>
                
                <!-- Confirmed -->
                <div class="bg-white rounded-xl shadow-md border border-[#d4a373] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Confirmed</p>
                            <p class="text-3xl font-bold text-blue-600" x-text="stats.confirmed || 0"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                            <span class="text-2xl">✅</span>
                        </div>
                    </div>
                </div>
                
                <!-- Seated -->
                <div class="bg-white rounded-xl shadow-md border border-[#d4a373] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Seated</p>
                            <p class="text-3xl font-bold text-green-600" x-text="stats.seated || 0"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center">
                            <span class="text-2xl">🪑</span>
                        </div>
                    </div>
                </div>
                
                <!-- Cancelled -->
                <div class="bg-white rounded-xl shadow-md border border-[#d4a373] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Cancelled</p>
                            <p class="text-3xl font-bold text-red-600" x-text="stats.cancelled || 0"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center">
                            <span class="text-2xl">❌</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Today's Overview -->
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div class="bg-white rounded-xl shadow-md border border-[#d4a373] p-4">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-full bg-[#d4a373] flex items-center justify-center text-white">
                            <span>📅</span>
                        </div>
                        <div>
                            <p class="text-sm text-[#3a5a78]">Today's Bookings</p>
                            <p class="text-2xl font-bold text-[#1e3c5c]" x-text="stats.todayBookings || 0"></p>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-xl shadow-md border border-[#d4a373] p-4">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-full bg-yellow-100 flex items-center justify-center text-yellow-600">
                            <span>⏳</span>
                        </div>
                        <div>
                            <p class="text-sm text-[#3a5a78]">Active Bookings</p>
                            <p class="text-2xl font-bold text-[#1e3c5c]" x-text="stats.active || 0"></p>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-xl shadow-md border border-[#d4a373] p-4">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center text-gray-600">
                            <span>🚫</span>
                        </div>
                        <div>
                            <p class="text-sm text-[#3a5a78]">No Show</p>
                            <p class="text-2xl font-bold text-[#1e3c5c]" x-text="stats.noShow || 0"></p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search and Filter Section -->
            <div class="bg-white rounded-2xl shadow-md border border-[#d4a373] p-4 md:p-6 space-y-4">
                <!-- Search Bar -->
                <div class="relative">
                    <input type="text" 
                           x-model="searchQuery"
                           @input.debounce="performSearch()"
                           placeholder="Search by reservation number, guest name, email, or table number..." 
                           class="w-full pl-10 pr-4 py-3 rounded-xl border border-[#d4a373] focus:outline-none focus:ring-2 focus:ring-[#d4a373] focus:border-transparent text-sm">
                    <span class="absolute left-3 top-3.5 text-[#3a5a78] text-lg">🔍</span>
                </div>

                <!-- Filter Row -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3">
                    <!-- Status Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Status</label>
                        <select x-model="statusFilter" @change="applyFilters()" class="w-full border border-[#d4a373] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                            <option value="all">All Status</option>
                            <option value="pending">Pending</option>
                            <option value="confirmed">Confirmed</option>
                            <option value="seated">Seated</option>
                            <option value="completed">Completed</option>
                            <option value="cancelled">Cancelled</option>
                            <option value="rejected">Rejected</option>
                            <option value="no_show">No Show</option>
                        </select>
                    </div>

                    <!-- Guest Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Guest</label>
                        <input type="text" 
                               x-model="guestFilter"
                               @change="applyFilters()"
                               placeholder="Guest name or email"
                               class="w-full border border-[#d4a373] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                    </div>

                    <!-- Table Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Table</label>
                        <input type="text" 
                               x-model="tableFilter"
                               @change="applyFilters()"
                               placeholder="Table number"
                               class="w-full border border-[#d4a373] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                    </div>

                    <!-- Location Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Location</label>
                        <select x-model="locationFilter" @change="applyFilters()" class="w-full border border-[#d4a373] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                            <option value="all">All Locations</option>
                            <template x-for="location in locations" :key="location.id">
                                <option :value="location.name" x-text="location.name"></option>
                            </template>
                        </select>
                    </div>

                    <!-- Party Size Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Party Size</label>
                        <select x-model="partySizeFilter" @change="applyFilters()" class="w-full border border-[#d4a373] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                            <option value="all">Any Size</option>
                            <option value="2">2+ Persons</option>
                            <option value="4">4+ Persons</option>
                            <option value="6">6+ Persons</option>
                            <option value="8">8+ Persons</option>
                        </select>
                    </div>
                </div>

                <!-- Date Range Filter -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Date From</label>
                        <input type="date" 
                               x-model="dateFrom"
                               @change="applyFilters()"
                               class="w-full border border-[#d4a373] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Date To</label>
                        <input type="date" 
                               x-model="dateTo"
                               @change="applyFilters()"
                               class="w-full border border-[#d4a373] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                    </div>
                </div>

                <!-- Filter Actions -->
                <div class="flex flex-wrap justify-end gap-2 pt-2">
                    <button @click="clearFilters()" class="px-4 py-2 rounded-lg border border-[#d4a373] text-[#1e3c5c] hover:bg-[#d4a373]/20 transition text-sm font-medium">
                        Clear Filters
                    </button>
                </div>
            </div>

            <!-- Bookings Table -->
            <div class="bg-white rounded-2xl shadow-md border border-[#d4a373] overflow-hidden">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Reservation No</th>
                                <th>Guest</th>
                                <th>Table</th>
                                <th>Location</th>
                                <th>Date & Time</th>
                                <th>Party</th>
                                <th>Status</th>
                                <th>Booked On</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template x-if="paginatedBookings && paginatedBookings.length > 0">
                                <template x-for="booking in paginatedBookings" :key="booking.id">
                                    <tr>
                                        <!-- Reservation No -->
                                        <td>
                                            <div class="font-medium text-[#d4a373] text-sm" x-text="booking.reservationNo || ''"></div>
                                        </td>
                                        
                                        <!-- Guest -->
                                        <td>
                                            <div class="text-sm font-medium text-[#1e3c5c]" x-text="booking.guestName || 'Guest #' + booking.guestId"></div>
                                            <div class="text-xs text-[#3a5a78]" x-text="booking.guestEmail || ''"></div>
                                        </td>
                                        
                                        <!-- Table -->
                                        <td>
                                            <div class="text-sm text-[#1e3c5c]" x-text="booking.tableNo ? (booking.tablePrefix + ' - ' + booking.tableNo) : 'Table #' + booking.tableId"></div>
                                            <div class="text-xs text-[#3a5a78]" x-text="'Capacity: ' + (booking.tableCapacity || booking.capacity || '?')"></div>
                                        </td>
                                        
                                        <!-- Location -->
                                        <td>
                                            <span class="px-2 py-1 rounded-full text-xs font-medium"
                                                  :class="{
                                                      'bg-blue-100 text-blue-700': booking.locationName === '1st Floor',
                                                      'bg-green-100 text-green-700': booking.locationName === '2nd Floor',
                                                      'bg-purple-100 text-purple-700': booking.locationName === 'Beachside',
                                                      'bg-yellow-100 text-yellow-700': booking.locationName === 'Poolside',
                                                      'bg-pink-100 text-pink-700': booking.locationName === 'Rooftop',
                                                      'bg-orange-100 text-orange-700': booking.locationName === 'Garden',
                                                      'bg-gray-100 text-gray-700': !booking.locationName
                                                  }">
                                                <span x-text="booking.locationName || 'N/A'"></span>
                                            </span>
                                        </td>
                                        
                                        <!-- Date & Time -->
                                        <td>
                                            <div class="text-sm font-medium text-[#1e3c5c]" x-text="formatDate(booking.bookingDate)"></div>
                                            <div class="text-xs text-[#d4a373]" x-text="booking.bookingTime || ''"></div>
                                        </td>
                                        
                                        <!-- Party Size -->
                                        <td>
                                            <div class="party-size">
                                                <i class="fas fa-user"></i>
                                                <span class="text-sm font-medium" x-text="booking.partySize || '1'"></span>
                                            </div>
                                        </td>
                                        
                                        <!-- Status -->
                                        <td>
                                            <span class="status-badge text-xs"
                                                  :class="{
                                                      'bg-yellow-100 text-yellow-700': booking.status === 'pending',
                                                      'bg-blue-100 text-blue-700': booking.status === 'confirmed',
                                                      'bg-green-100 text-green-700': booking.status === 'seated',
                                                      'bg-gray-100 text-gray-700': booking.status === 'completed',
                                                      'bg-red-100 text-red-700': booking.status === 'cancelled' || booking.status === 'rejected',
                                                      'bg-gray-200 text-gray-800': booking.status === 'no_show'
                                                  }">
                                                <span class="flex items-center justify-center gap-1">
                                                    <span x-text="getStatusIcon(booking.status)"></span>
                                                    <span x-text="formatStatus(booking.status)"></span>
                                                </span>
                                            </span>
                                        </td>
                                        
                                        <!-- Booked On -->
                                        <td>
                                            <div class="text-xs text-[#3a5a78]" x-text="formatShortDate(booking.createdDate)"></div>
                                        </td>
                                        
                                        <!-- Actions -->
                                        <td>
                                            <div class="flex items-center gap-1">
                                                <!-- View Details -->
                                                <button @click="viewBooking(booking)" 
                                                        class="action-btn w-7 h-7 bg-[#d4a373] text-white hover:bg-[#b88b4a]"
                                                        title="View Details">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                                    </svg>
                                                </button>
                                                
                                                <!-- Edit Status -->
                                                <button @click="editBookingStatus(booking)" 
                                                        class="action-btn w-7 h-7 bg-yellow-100 text-yellow-600 hover:bg-yellow-200"
                                                        title="Change Status">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                                    </svg>
                                                </button>
                                                
                                                <!-- Delete Booking -->
                                                <button @click="confirmDelete(booking)" 
                                                        class="action-btn w-7 h-7 bg-red-100 text-red-500 hover:bg-red-200"
                                                        title="Delete Booking"
                                                        :disabled="!canDelete(booking)">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                                    </svg>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </template>
                            </template>
                            <template x-if="!paginatedBookings || paginatedBookings.length === 0">
                                <tr>
                                    <td colspan="9" class="text-center py-8 text-[#3a5a78]">
                                        No table bookings to display
                                    </td>
                                </tr>
                            </template>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- No Results Message -->
            <div x-show="filteredBookings && filteredBookings.length === 0" class="text-center py-12" x-cloak>
                <span class="text-5xl mb-3 block">🍽️</span>
                <p class="text-lg text-[#3a5a78]">No table bookings found matching your filters</p>
                <button @click="clearFilters()" class="mt-4 px-6 py-2 rounded-lg bg-[#d4a373] text-white hover:bg-[#b88b4a] transition text-sm font-medium">
                    Clear Filters
                </button>
            </div>

            <!-- Pagination with Items Per Page Selector -->
            <div x-show="filteredBookings && filteredBookings.length > 0" class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-6" x-cloak>
                <div class="flex items-center gap-2">
                    <span class="text-sm text-[#3a5a78]">Show:</span>
                    <select x-model="itemsPerPage" @change="currentPage = 1" 
                            class="border border-[#d4a373] rounded-lg px-3 py-1.5 text-sm text-[#1e3c5c] focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                        <option value="10">10 / page</option>
                        <option value="20">20 / page</option>
                        <option value="50">50 / page</option>
                        <option value="100">100 / page</option>
                    </select>
                </div>
                
                <div class="flex items-center gap-2">
                    <button @click="prevPage" :disabled="currentPage === 1" 
                            class="w-9 h-9 rounded-full bg-white border border-[#d4a373] text-[#1e3c5c] hover:bg-[#d4a373]/20 transition disabled:opacity-50 disabled:cursor-not-allowed text-sm">
                        ←
                    </button>
                    <template x-if="totalPages > 0">
                        <template x-for="page in totalPages" :key="page">
                            <button @click="goToPage(page)" 
                                    class="w-9 h-9 rounded-full border transition text-sm"
                                    :class="currentPage === page ? 'bg-[#d4a373] text-white border-[#d4a373]' : 'bg-white border-[#d4a373] text-[#1e3c5c] hover:bg-[#d4a373]/20'">
                                <span x-text="page"></span>
                            </button>
                        </template>
                    </template>
                    <button @click="nextPage" :disabled="currentPage === totalPages || totalPages === 0"
                            class="w-9 h-9 rounded-full bg-white border border-[#d4a373] text-[#1e3c5c] hover:bg-[#d4a373]/20 transition disabled:opacity-50 disabled:cursor-not-allowed text-sm">
                        →
                    </button>
                </div>
                
                <div class="text-sm text-[#3a5a78]">
                    <span x-show="filteredBookings && filteredBookings.length > 0">
                        Showing <span x-text="((currentPage - 1) * itemsPerPage) + 1"></span> - 
                        <span x-text="Math.min(currentPage * itemsPerPage, filteredBookings.length)"></span> 
                        of <span x-text="filteredBookings.length"></span>
                    </span>
                </div>
            </div>
        </div>

        <!-- View Booking Modal -->
        <div x-show="showViewModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="showViewModal = false"
             x-cloak>
            
            <div class="bg-white rounded-2xl shadow-xl max-w-3xl w-full p-6 transform transition-all max-h-[90vh] overflow-y-auto"
                 @click.stop>
                
                <div class="flex justify-between items-start mb-4">
                    <h3 class="text-xl font-bold text-[#1e3c5c]">Table Booking Details</h3>
                    <button @click="showViewModal = false" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <div class="space-y-6" x-show="selectedBooking">
                    <!-- Reservation Number and Status -->
                    <div class="flex justify-between items-center">
                        <div>
                            <p class="text-sm text-[#3a5a78]">Reservation Number</p>
                            <p class="text-xl font-bold text-[#d4a373]" x-text="selectedBooking?.reservationNo || ''"></p>
                        </div>
                        <div>
                            <span class="status-badge text-sm px-4 py-2"
                                  :class="{
                                      'bg-yellow-100 text-yellow-700': selectedBooking?.status === 'pending',
                                      'bg-blue-100 text-blue-700': selectedBooking?.status === 'confirmed',
                                      'bg-green-100 text-green-700': selectedBooking?.status === 'seated',
                                      'bg-gray-100 text-gray-700': selectedBooking?.status === 'completed',
                                      'bg-red-100 text-red-700': selectedBooking?.status === 'cancelled' || selectedBooking?.status === 'rejected',
                                      'bg-gray-200 text-gray-800': selectedBooking?.status === 'no_show'
                                  }">
                                <span class="flex items-center gap-1">
                                    <span x-text="getStatusIcon(selectedBooking?.status)"></span>
                                    <span x-text="formatStatus(selectedBooking?.status)"></span>
                                </span>
                            </span>
                        </div>
                    </div>
                    
                    <!-- Guest Information -->
                    <div class="guest-info-card">
                        <h4 class="font-semibold text-[#1e3c5c] mb-3 flex items-center gap-2">
                            <span>👤</span> Guest Information
                        </h4>
                        <div class="flex items-start gap-4">
                            <div class="guest-avatar">
                                <span x-text="getInitials(selectedBooking?.guestName)"></span>
                            </div>
                            <div class="flex-1 grid grid-cols-2 gap-3">
                                <div>
                                    <p class="text-xs text-[#3a5a78]">Full Name</p>
                                    <p class="font-medium" x-text="selectedBooking?.guestName || 'N/A'"></p>
                                </div>
                                <div>
                                    <p class="text-xs text-[#3a5a78]">Email</p>
                                    <p class="font-medium" x-text="selectedBooking?.guestEmail || 'N/A'"></p>
                                </div>
                                <div>
                                    <p class="text-xs text-[#3a5a78]">Phone</p>
                                    <p class="font-medium" x-text="selectedBooking?.guestPhone || 'N/A'"></p>
                                </div>
                                <div>
                                    <p class="text-xs text-[#3a5a78]">Guest ID</p>
                                    <p class="font-medium" x-text="'#' + selectedBooking?.guestId"></p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Table Information -->
                    <div class="table-info-card">
                        <h4 class="font-semibold text-[#1e3c5c] mb-3 flex items-center gap-2">
                            <span>🍽️</span> Table Information
                        </h4>
                        <div class="grid grid-cols-2 gap-3">
                            <div>
                                <p class="text-xs text-[#3a5a78]">Table</p>
                                <p class="font-medium" x-text="selectedBooking?.tableNo ? (selectedBooking?.tablePrefix + ' - ' + selectedBooking?.tableNo) : 'Table #' + selectedBooking?.tableId"></p>
                            </div>
                            <div>
                                <p class="text-xs text-[#3a5a78]">Location</p>
                                <p class="font-medium" x-text="selectedBooking?.locationName || 'N/A'"></p>
                            </div>
                            <div>
                                <p class="text-xs text-[#3a5a78]">Capacity</p>
                                <p class="font-medium" x-text="selectedBooking?.tableCapacity || selectedBooking?.capacity || '?' + ' persons'"></p>
                            </div>
                            <div>
                                <p class="text-xs text-[#3a5a78]">Min. Spend</p>
                                <p class="font-medium">$<span x-text="selectedBooking?.minimumSpend || '0'"></span></p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Booking Date & Time -->
                    <div>
                        <h4 class="font-semibold text-[#1e3c5c] mb-3 flex items-center gap-2">
                            <span>📅</span> Booking Date & Time
                        </h4>
                        <div class="datetime-box">
                            <div class="date-box">
                                <div class="label">DATE</div>
                                <div class="value" x-text="formatDate(selectedBooking?.bookingDate)"></div>
                            </div>
                            <div class="date-arrow">→</div>
                            <div class="date-box">
                                <div class="label">TIME</div>
                                <div class="value" x-text="selectedBooking?.bookingTime || ''"></div>
                                <div class="time">(2 hours dining)</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Party Size -->
                    <div>
                        <h4 class="font-semibold text-[#1e3c5c] mb-2">Party Size</h4>
                        <div class="bg-[#fff9f0] p-3 rounded-lg flex items-center gap-2">
                            <span class="text-2xl">👥</span>
                            <span class="text-xl font-bold" x-text="selectedBooking?.partySize || '1'"></span>
                            <span class="text-[#3a5a78]" x-text="selectedBooking?.partySize === 1 ? 'person' : 'persons'"></span>
                        </div>
                    </div>
                    
                    <!-- Special Requests -->
                    <div x-show="selectedBooking?.specialRequests">
                        <h4 class="font-semibold text-[#1e3c5c] mb-2">Special Requests</h4>
                        <div class="bg-[#fff9f0] p-3 rounded-lg">
                            <p class="text-[#1e3c5c]" x-text="selectedBooking?.specialRequests"></p>
                        </div>
                    </div>
                    
                    <!-- Booking Metadata -->
                    <div class="grid grid-cols-2 gap-3 text-xs text-[#3a5a78] border-t border-[#d4a373] pt-4">
                        <div>
                            <span class="font-medium">Booking ID:</span> <span x-text="'#' + selectedBooking?.id"></span>
                        </div>
                        <div>
                            <span class="font-medium">Created:</span> <span x-text="formatDateTime(selectedBooking?.createdDate)"></span>
                        </div>
                        <div>
                            <span class="font-medium">Last Updated:</span> <span x-text="formatDateTime(selectedBooking?.updatedDate)"></span>
                        </div>
                    </div>
                </div>
                
                <!-- Loading or empty state when selectedBooking is null -->
                <div x-show="!selectedBooking" class="text-center py-8">
                    <p class="text-[#3a5a78]">No booking selected</p>
                </div>
                
                <div class="flex justify-end gap-2 mt-6">
                    <button @click="showViewModal = false" 
                            class="px-4 py-2 rounded-lg bg-[#d4a373] text-white hover:bg-[#b88b4a] transition text-sm font-medium">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!-- Edit Status Modal -->
        <div x-show="showStatusModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="showStatusModal = false"
             x-cloak>
            
            <div class="bg-white rounded-2xl shadow-xl max-w-md w-full p-6 transform transition-all"
                 @click.stop>
                
                <div class="flex items-center justify-center w-16 h-16 mx-auto bg-yellow-100 rounded-full mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-yellow-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                </div>
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Change Booking Status</h3>
                <p class="text-[#3a5a78] text-center mb-4">
                    Update status for reservation <span class="font-semibold" x-text="selectedBooking?.reservationNo"></span>
                </p>
                
                <div class="mb-4">
                    <label class="block text-sm font-medium text-[#1e3c5c] mb-2">Current Status</label>
                    <div class="p-3 bg-[#fff9f0] rounded-lg text-center">
                        <span class="status-badge px-4 py-2"
                              :class="{
                                  'bg-yellow-100 text-yellow-700': selectedBooking?.status === 'pending',
                                  'bg-blue-100 text-blue-700': selectedBooking?.status === 'confirmed',
                                  'bg-green-100 text-green-700': selectedBooking?.status === 'seated',
                                  'bg-gray-100 text-gray-700': selectedBooking?.status === 'completed',
                                  'bg-red-100 text-red-700': selectedBooking?.status === 'cancelled' || selectedBooking?.status === 'rejected',
                                  'bg-gray-200 text-gray-800': selectedBooking?.status === 'no_show'
                              }">
                            <span class="flex items-center gap-1">
                                <span x-text="getStatusIcon(selectedBooking?.status)"></span>
                                <span x-text="formatStatus(selectedBooking?.status)"></span>
                            </span>
                        </span>
                    </div>
                </div>
                
                <div class="mb-6">
                    <label class="block text-sm font-medium text-[#1e3c5c] mb-2">New Status</label>
                    <select x-model="newStatus" class="w-full border border-[#d4a373] rounded-xl px-3 py-3 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                        <option value="">Select new status</option>
                        <option value="pending">Pending</option>
                        <option value="confirmed">Confirmed</option>
                        <option value="seated">Seated</option>
                        <option value="completed">Completed</option>
                        <option value="cancelled">Cancelled</option>
                        <option value="rejected">Rejected</option>
                        <option value="no_show">No Show</option>
                    </select>
                </div>
                
                <div class="flex gap-3">
                    <button @click="showStatusModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#d4a373] text-[#1e3c5c] hover:bg-[#d4a373]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                    <button @click="updateBookingStatus()" 
                            class="flex-1 px-4 py-2.5 rounded-lg bg-[#d4a373] text-white hover:bg-[#b88b4a] transition text-sm font-medium"
                            :disabled="!newStatus">
                        Update Status
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
             @click.away="showDeleteModal = false"
             x-cloak>
            
            <div class="bg-white rounded-2xl shadow-xl max-w-md w-full p-6 transform transition-all"
                 @click.stop>
                
                <div class="flex items-center justify-center w-16 h-16 mx-auto bg-red-100 rounded-full mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                </div>
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Delete Booking</h3>
                <p class="text-[#3a5a78] text-center mb-6">
                    Are you sure you want to delete booking "<span class="font-semibold" x-text="selectedBooking?.reservationNo"></span>"? 
                    <span class="block mt-2 text-xs">Note: Only cancelled or rejected bookings can be deleted.</span>
                </p>
                
                <div class="flex gap-3">
                    <button @click="showDeleteModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#d4a373] text-[#1e3c5c] hover:bg-[#d4a373]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                    <button @click="deleteBooking()" 
                            class="flex-1 px-4 py-2.5 rounded-lg bg-red-500 text-white hover:bg-red-600 transition text-sm font-medium">
                        Delete
                    </button>
                </div>
            </div>
        </div>

    </main>

    <script>
        function tableBookingDetailsManager() {
            return {
                // Data properties
                bookings: [],
                filteredBookings: [],
                locations: [],
                stats: {
                    total: 0,
                    pending: 0,
                    confirmed: 0,
                    seated: 0,
                    completed: 0,
                    cancelled: 0,
                    rejected: 0,
                    noShow: 0,
                    active: 0,
                    todayBookings: 0
                },
                
                // Filter properties
                searchQuery: '',
                statusFilter: 'all',
                guestFilter: '',
                tableFilter: '',
                locationFilter: 'all',
                partySizeFilter: 'all',
                dateFrom: '',
                dateTo: '',
                
                // Pagination
                currentPage: 1,
                itemsPerPage: 10,
                
                // Modal properties
                showViewModal: false,
                showStatusModal: false,
                showDeleteModal: false,
                
                // Form properties
                selectedBooking: null,
                newStatus: '',
                
                // Initialize
                init: function() {
                    this.loadLocations();
                    this.loadBookings();
                    this.loadStats();
                    
                    // Reset to first page when filters change
                    this.$watch('filteredBookings', () => {
                        this.currentPage = 1;
                    });
                    
                    console.log('Table Booking Details Manager initialized');
                },
                
                // API Calls
                loadBookings: function() {
                    console.log('Loading table bookings...');
                    fetch('${pageContext.request.contextPath}/tablebookings/api/list')
                        .then(response => {
                            console.log('Response status:', response.status);
                            if (!response.ok) {
                                throw new Error('HTTP error ' + response.status);
                            }
                            return response.json();
                        })
                        .then(data => {
                            console.log('Table bookings data:', data);
                            // Ensure data is an array
                            this.bookings = Array.isArray(data) ? data : [];
                            this.applyFilters();
                        })
                        .catch(error => {
                            console.error('Error loading table bookings:', error);
                            this.bookings = [];
                            this.filteredBookings = [];
                            if (window.showError) {
                                window.showError('Failed to load table bookings: ' + error.message, 3000);
                            }
                        });
                },
                
                loadLocations: function() {
                    fetch('${pageContext.request.contextPath}/tablelocation/api/list')
                        .then(response => response.json())
                        .then(data => {
                            this.locations = Array.isArray(data) ? data : [];
                        })
                        .catch(error => {
                            console.error('Error loading locations:', error);
                            this.locations = [];
                        });
                },
                
                loadStats: function() {
                    fetch('${pageContext.request.contextPath}/tablebookings/api/stats')
                        .then(response => response.json())
                        .then(data => {
                            this.stats = data || {
                                total: 0,
                                pending: 0,
                                confirmed: 0,
                                seated: 0,
                                completed: 0,
                                cancelled: 0,
                                rejected: 0,
                                noShow: 0,
                                active: 0,
                                todayBookings: 0
                            };
                        })
                        .catch(error => {
                            console.error('Error loading stats:', error);
                        });
                },
                
                performSearch: function() {
                    this.applyFilters();
                },
                
                applyFilters: function() {
                    let filtered = [...this.bookings];
                    
                    // Search query filter (reservation no, guest name, email, table no)
                    if (this.searchQuery) {
                        const query = this.searchQuery.toLowerCase();
                        filtered = filtered.filter(booking => 
                            (booking.reservationNo && booking.reservationNo.toLowerCase().includes(query)) ||
                            (booking.guestName && booking.guestName.toLowerCase().includes(query)) ||
                            (booking.guestEmail && booking.guestEmail.toLowerCase().includes(query)) ||
                            (booking.tableNo && booking.tableNo.toLowerCase().includes(query)) ||
                            (booking.guestId && booking.guestId.toString().includes(query))
                        );
                    }
                    
                    // Status filter
                    if (this.statusFilter && this.statusFilter !== 'all') {
                        filtered = filtered.filter(booking => booking.status === this.statusFilter);
                    }
                    
                    // Guest filter
                    if (this.guestFilter) {
                        const guest = this.guestFilter.toLowerCase();
                        filtered = filtered.filter(booking => 
                            (booking.guestName && booking.guestName.toLowerCase().includes(guest)) ||
                            (booking.guestEmail && booking.guestEmail.toLowerCase().includes(guest))
                        );
                    }
                    
                    // Table filter
                    if (this.tableFilter) {
                        const table = this.tableFilter.toLowerCase();
                        filtered = filtered.filter(booking => 
                            (booking.tableNo && booking.tableNo.toLowerCase().includes(table))
                        );
                    }
                    
                    // Location filter
                    if (this.locationFilter && this.locationFilter !== 'all') {
                        filtered = filtered.filter(booking => 
                            booking.locationName === this.locationFilter
                        );
                    }
                    
                    // Party size filter
                    if (this.partySizeFilter && this.partySizeFilter !== 'all') {
                        const minPartySize = parseInt(this.partySizeFilter);
                        filtered = filtered.filter(booking => 
                            (booking.partySize || 0) >= minPartySize
                        );
                    }
                    
                    // Date range filter
                    if (this.dateFrom) {
                        const fromDate = new Date(this.dateFrom);
                        fromDate.setHours(0, 0, 0, 0);
                        filtered = filtered.filter(booking => {
                            if (!booking.bookingDate) return true;
                            const bookingDate = new Date(booking.bookingDate);
                            bookingDate.setHours(0, 0, 0, 0);
                            return bookingDate >= fromDate;
                        });
                    }
                    
                    if (this.dateTo) {
                        const toDate = new Date(this.dateTo);
                        toDate.setHours(23, 59, 59, 999);
                        filtered = filtered.filter(booking => {
                            if (!booking.bookingDate) return true;
                            const bookingDate = new Date(booking.bookingDate);
                            bookingDate.setHours(0, 0, 0, 0);
                            return bookingDate <= toDate;
                        });
                    }
                    
                    this.filteredBookings = filtered;
                },
                
                clearFilters: function() {
                    this.searchQuery = '';
                    this.statusFilter = 'all';
                    this.guestFilter = '';
                    this.tableFilter = '';
                    this.locationFilter = 'all';
                    this.partySizeFilter = 'all';
                    this.dateFrom = '';
                    this.dateTo = '';
                    this.currentPage = 1;
                    this.filteredBookings = [...this.bookings];
                    
                    if (window.showInfo) {
                        window.showInfo('Filters cleared', 3000);
                    }
                },
                
                // Pagination methods
                get paginatedBookings() {
                    if (!Array.isArray(this.filteredBookings) || this.filteredBookings.length === 0) {
                        return [];
                    }
                    let start = (this.currentPage - 1) * this.itemsPerPage;
                    let end = start + this.itemsPerPage;
                    return this.filteredBookings.slice(start, end);
                },
                
                get totalPages() {
                    if (!Array.isArray(this.filteredBookings)) {
                        return 0;
                    }
                    return Math.ceil(this.filteredBookings.length / this.itemsPerPage);
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
                viewBooking: function(booking) {
                    this.selectedBooking = booking;
                    this.showViewModal = true;
                },
                
                editBookingStatus: function(booking) {
                    this.selectedBooking = booking;
                    this.newStatus = '';
                    this.showStatusModal = true;
                },
                
                updateBookingStatus: function() {
                    if (!this.newStatus) {
                        if (window.showError) {
                            window.showError('Please select a status', 3000);
                        }
                        return;
                    }
                    
                    // Show loading
                    if (window.showInfo) {
                        window.showInfo('Updating status...', 0);
                    }
                    
                    fetch('${pageContext.request.contextPath}/tablebookings/api/update-status?bookingId=' + this.selectedBooking.id + '&status=' + this.newStatus, {
                        method: 'PUT'
                    })
                    .then(response => {
                        if (!response.ok) {
                            return response.json().then(errorData => {
                                throw new Error(errorData.message || `Server error: ${response.status}`);
                            }).catch(() => {
                                throw new Error(`Server error: ${response.status}`);
                            });
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            if (window.showSuccess) {
                                window.showSuccess(data.message, 3000);
                            }
                            this.loadBookings();
                            this.loadStats();
                            this.showStatusModal = false;
                            this.selectedBooking = null;
                        } else {
                            if (window.showError) {
                                window.showError(data.message, 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error updating booking status:', error);
                        if (window.showError) {
                            window.showError(error.message || 'Failed to update booking status', 3000);
                        }
                    });
                },
                
                confirmDelete: function(booking) {
                    this.selectedBooking = booking;
                    this.showDeleteModal = true;
                },
                
                canDelete: function(booking) {
                    return booking && (booking.status === 'cancelled' || booking.status === 'rejected');
                },
                
                deleteBooking: function() {
                    // Show loading
                    if (window.showInfo) {
                        window.showInfo('Deleting booking...', 0);
                    }
                    
                    fetch('${pageContext.request.contextPath}/tablebookings/api/' + this.selectedBooking.id, {
                        method: 'DELETE'
                    })
                    .then(response => {
                        if (!response.ok) {
                            return response.json().then(errorData => {
                                throw new Error(errorData.message || `Server error: ${response.status}`);
                            }).catch(() => {
                                throw new Error(`Server error: ${response.status}`);
                            });
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            if (window.showSuccess) {
                                window.showSuccess(data.message, 3000);
                            }
                            this.loadBookings();
                            this.loadStats();
                            this.showDeleteModal = false;
                            this.selectedBooking = null;
                        } else {
                            if (window.showError) {
                                window.showError(data.message, 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error deleting booking:', error);
                        if (window.showError) {
                            window.showError(error.message || 'Failed to delete booking', 3000);
                        }
                    });
                },
                
                // Helper methods
                getStatusIcon: function(status) {
                    switch(status) {
                        case 'pending': return '⏳';
                        case 'confirmed': return '✅';
                        case 'seated': return '🪑';
                        case 'completed': return '✔️';
                        case 'cancelled': return '❌';
                        case 'rejected': return '⛔';
                        case 'no_show': return '🚫';
                        default: return '🍽️';
                    }
                },
                
                formatStatus: function(status) {
                    if (!status) return '';
                    return status.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase());
                },
                
                getInitials: function(name) {
                    if (!name) return 'G';
                    return name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase();
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
                },
                
                formatDateTime: function(dateTimeString) {
                    if (!dateTimeString) return '';
                    try {
                        let options = { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' };
                        return new Date(dateTimeString).toLocaleDateString('en-US', options);
                    } catch (e) {
                        return '';
                    }
                }
            }
        }
    </script>
</body>
</html>