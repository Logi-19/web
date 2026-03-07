<%-- 
    Document   : tableactivity
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Table Bookings · Ocean View Resort</title>
    <!-- Tailwind via CDN + Inter font -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <!-- Alpine.js for interactive components -->
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        
        /* Status badges - warm colors for table booking */
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            white-space: nowrap;
        }
        
        .status-pending {
            background-color: #fef3c7;
            color: #92400e;
        }
        
        .status-confirmed {
            background-color: #dbeafe;
            color: #1e40af;
        }
        
        .status-seated {
            background-color: #d1fae5;
            color: #065f46;
        }
        
        .status-completed {
            background-color: #e5e7eb;
            color: #374151;
        }
        
        .status-cancelled {
            background-color: #fee2e2;
            color: #991b1b;
        }
        
        .status-rejected {
            background-color: #fee2e2;
            color: #991b1b;
        }
        
        .status-no_show {
            background-color: #f1f5f9;
            color: #475569;
        }
        
        /* Action buttons */
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
        
        .action-btn.cancel {
            background-color: #fee2e2;
            color: #dc2626;
        }
        
        .action-btn.cancel:hover {
            background-color: #fecaca;
        }
        
        .action-btn.view {
            background-color: #fef3c7;
            color: #d4a373;
        }
        
        .action-btn.view:hover {
            background-color: #fde68a;
        }
        
        .action-btn.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        /* Table styles */
        .table-container {
            overflow-x: auto;
            border-radius: 1rem;
            background: white;
            border: 1px solid #e2e8f0;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
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
            text-align: left;
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
        
        /* Modal styles */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }
        
        .modal-content {
            background: white;
            border-radius: 1.5rem;
            max-width: 500px;
            width: 100%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            animation: modalSlideIn 0.3s ease-out;
        }
        
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .modal-close {
            position: absolute;
            top: 1rem;
            right: 1rem;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            z-index: 10;
        }
        
        .modal-close:hover {
            background: #fee2e2;
            border-color: #ef4444;
            color: #ef4444;
            transform: rotate(90deg);
        }
        
        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 1.5rem;
            border: 1px solid #e2e8f0;
        }
        
        /* Loading skeleton */
        .skeleton {
            background: linear-gradient(90deg, #fff9f0 25%, #e2e8f0 50%, #fff9f0 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
            border-radius: 0.5rem;
        }
        
        @keyframes loading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }
        
        /* Location badge */
        .location-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 9999px;
            font-size: 0.7rem;
            font-weight: 500;
            display: inline-block;
        }
        
        .location-first-floor {
            background-color: #dbeafe;
            color: #1e3c5c;
        }
        
        .location-second-floor {
            background-color: #dcfce7;
            color: #166534;
        }
        
        .location-beachside {
            background-color: #f3e8ff;
            color: #6b21a8;
        }
        
        .location-poolside {
            background-color: #ffedd5;
            color: #9a3412;
        }
        
        .location-rooftop {
            background-color: #ffe4e6;
            color: #9f1239;
        }
        
        .location-garden {
            background-color: #ccfbf1;
            color: #115e59;
        }
        
        [x-cloak] { display: none !important; }
    </style>
</head>
<body class="bg-[#fff9f0] text-[#1e3c5c] antialiased">

    <!-- Include Navbar -->
    <jsp:include page="component/navbar.jsp" />
    
    <!-- Include Notification -->
    <jsp:include page="component/notification.jsp" />

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 mt-16" x-data="tableActivity()" x-init="init()">
        
        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl md:text-4xl font-bold text-[#1e3c5c] flex items-center gap-3">
                <i class="fas fa-utensils text-[#d4a373]"></i>
                My Table Bookings
            </h1>
            <p class="text-[#3a5a78] mt-2">View and manage your restaurant reservations</p>
        </div>

        <!-- Filters -->
        <div class="bg-white rounded-xl shadow-sm border border-[#e2e8f0] p-4 mb-6">
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                <!-- Status Filter -->
                <div>
                    <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Filter by Status</label>
                    <select x-model="statusFilter" @change="applyFilters()" class="w-full border border-[#e2e8f0] rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                        <option value="all">All Bookings</option>
                        <option value="pending">Pending</option>
                        <option value="confirmed">Confirmed</option>
                        <option value="seated">Seated</option>
                        <option value="completed">Completed</option>
                        <option value="cancelled">Cancelled</option>
                        <option value="rejected">Rejected</option>
                        <option value="no_show">No Show</option>
                    </select>
                </div>

                <!-- Date Range Filter -->
                <div>
                    <label class="block text-sm font-medium text-[#1e3c5c] mb-1">From Date</label>
                    <input type="date" 
                           x-model="dateFrom"
                           @change="applyFilters()"
                           class="w-full border border-[#e2e8f0] rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                </div>

                <div>
                    <label class="block text-sm font-medium text-[#1e3c5c] mb-1">To Date</label>
                    <input type="date" 
                           x-model="dateTo"
                           @change="applyFilters()"
                           class="w-full border border-[#e2e8f0] rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                </div>

                <!-- Search -->
                <div>
                    <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Search</label>
                    <input type="text" 
                           x-model="searchQuery"
                           @input.debounce="applyFilters()"
                           placeholder="Reservation # or Table No"
                           class="w-full border border-[#e2e8f0] rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                </div>
            </div>

            <!-- Filter Actions -->
            <div class="flex justify-end mt-4">
                <button @click="clearFilters()" class="text-sm text-[#64748b] hover:text-[#1e3c5c] flex items-center gap-1">
                    <i class="fas fa-times"></i>
                    Clear Filters
                </button>
            </div>
        </div>

        <!-- Bookings Table -->
        <div class="table-container" x-show="!loading">
            <table>
                <thead>
                    <tr>
                        <th>Reservation No</th>
                        <th>Table</th>
                        <th>Location</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Party Size</th>
                        <th>Status</th>
                        <th>Booked On</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Loading State -->
                    <template x-if="loading">
                        <tr>
                            <td colspan="9" class="text-center py-8">
                                <div class="flex justify-center">
                                    <i class="fas fa-spinner fa-spin text-2xl text-[#d4a373]"></i>
                                </div>
                            </td>
                        </tr>
                    </template>

                    <!-- No Bookings -->
                    <template x-if="!loading && filteredBookings.length === 0">
                        <tr>
                            <td colspan="9" class="text-center py-12">
                                <div class="flex flex-col items-center">
                                    <i class="fas fa-utensils text-5xl text-[#94a3b8] mb-3"></i>
                                    <p class="text-[#64748b]">No table bookings found</p>
                                    <p class="text-sm text-[#94a3b8] mt-1">Try adjusting your filters</p>
                                    <a href="${pageContext.request.contextPath}/booktable.jsp" 
                                       class="mt-4 px-4 py-2 bg-[#d4a373] text-white rounded-lg hover:bg-[#b88b4a] transition text-sm">
                                        Book a Table
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </template>

                    <!-- Bookings List -->
                    <template x-if="!loading && filteredBookings.length > 0">
                        <template x-for="booking in paginatedBookings" :key="booking.id">
                            <tr>
                                <!-- Reservation No -->
                                <td>
                                    <span class="font-medium text-[#d4a373]" x-text="booking.reservationNo"></span>
                                </td>
                                
                                <!-- Table -->
                                <td>
                                    <div class="font-medium" x-text="booking.tableNo ? (booking.tablePrefix + ' - ' + booking.tableNo) : 'Table #' + booking.tableId"></div>
                                    <div class="text-xs text-[#64748b]" x-text="'Capacity: ' + (booking.tableCapacity || booking.capacity || '?')"></div>
                                </td>
                                
                                <!-- Location -->
                                <td>
                                    <span class="location-badge" 
                                          :class="{
                                              'location-first-floor': booking.locationName === '1st Floor',
                                              'location-second-floor': booking.locationName === '2nd Floor',
                                              'location-beachside': booking.locationName === 'Beachside',
                                              'location-poolside': booking.locationName === 'Poolside',
                                              'location-rooftop': booking.locationName === 'Rooftop',
                                              'location-garden': booking.locationName === 'Garden'
                                          }">
                                        <span x-text="booking.locationName || 'Standard'"></span>
                                    </span>
                                </td>
                                
                                <!-- Date -->
                                <td x-text="formatDate(booking.bookingDate)"></td>
                                
                                <!-- Time -->
                                <td>
                                    <span class="font-medium" x-text="booking.bookingTime || ''"></span>
                                    <div class="text-xs text-[#64748b]">2 hrs dining</div>
                                </td>
                                
                                <!-- Party Size -->
                                <td class="text-center">
                                    <span class="flex items-center gap-1">
                                        <i class="fas fa-user text-[#d4a373] text-xs"></i>
                                        <span x-text="booking.partySize || '1'"></span>
                                    </span>
                                </td>
                                
                                <!-- Status -->
                                <td>
                                    <span class="status-badge" :class="'status-' + (booking.status || 'pending')">
                                        <i class="fas" :class="getStatusIcon(booking.status)"></i>
                                        <span x-text="formatStatus(booking.status)"></span>
                                    </span>
                                </td>
                                
                                <!-- Booked On -->
                                <td x-text="formatShortDate(booking.createdDate)"></td>
                                
                                <!-- Actions -->
                                <td>
                                    <div class="flex items-center gap-2">
                                        <!-- View Details -->
                                        <button @click="viewBooking(booking)" 
                                                class="action-btn view"
                                                title="View Details">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        
                                        <!-- Cancel Booking (only for pending or confirmed) -->
                                        <button @click="confirmCancel(booking)" 
                                                class="action-btn cancel"
                                                :class="{ 'disabled': !canCancel(booking) }"
                                                :disabled="!canCancel(booking)"
                                                title="Cancel Booking">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </template>
                    </template>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div x-show="!loading && filteredBookings.length > 0" class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-6" x-cloak>
            <div class="flex items-center gap-2">
                <span class="text-sm text-[#64748b]">Show:</span>
                <select x-model="itemsPerPage" @change="currentPage = 1" 
                        class="border border-[#e2e8f0] rounded-lg px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-[#d4a373]">
                    <option value="10">10 / page</option>
                    <option value="20">20 / page</option>
                    <option value="50">50 / page</option>
                </select>
            </div>
            
            <div class="flex items-center gap-2">
                <button @click="prevPage" :disabled="currentPage === 1" 
                        class="w-8 h-8 rounded-full border border-[#e2e8f0] hover:bg-[#fff9f0] transition disabled:opacity-50 disabled:cursor-not-allowed">
                    <i class="fas fa-chevron-left text-xs"></i>
                </button>
                <span class="text-sm text-[#1e3c5c]">
                    Page <span x-text="currentPage"></span> of <span x-text="totalPages"></span>
                </span>
                <button @click="nextPage" :disabled="currentPage === totalPages" 
                        class="w-8 h-8 rounded-full border border-[#e2e8f0] hover:bg-[#fff9f0] transition disabled:opacity-50 disabled:cursor-not-allowed">
                    <i class="fas fa-chevron-right text-xs"></i>
                </button>
            </div>
            
            <div class="text-sm text-[#64748b]">
                Showing <span x-text="((currentPage - 1) * itemsPerPage) + 1"></span> - 
                <span x-text="Math.min(currentPage * itemsPerPage, filteredBookings.length)"></span> 
                of <span x-text="filteredBookings.length"></span>
            </div>
        </div>

        <!-- View Booking Modal -->
        <div x-show="showViewModal" class="modal-overlay" x-cloak>
            <div class="modal-content relative p-6">
                <!-- Close Button -->
                <button @click="showViewModal = false" class="modal-close">
                    <i class="fas fa-times"></i>
                </button>
                
                <div x-show="selectedBooking">
                    <h2 class="text-2xl font-bold text-[#1e3c5c] mb-4">Table Booking Details</h2>
                    
                    <!-- Reservation Info -->
                    <div class="bg-[#fff9f0] p-4 rounded-xl mb-4">
                        <div class="flex justify-between items-start">
                            <div>
                                <p class="text-xs text-[#64748b]">Reservation Number</p>
                                <p class="text-lg font-bold text-[#d4a373]" x-text="selectedBooking?.reservationNo"></p>
                            </div>
                            <span class="status-badge" :class="'status-' + (selectedBooking?.status || 'pending')">
                                <i class="fas" :class="getStatusIcon(selectedBooking?.status)"></i>
                                <span x-text="formatStatus(selectedBooking?.status)"></span>
                            </span>
                        </div>
                    </div>
                    
                    <!-- Table Details -->
                    <div class="bg-[#fff9f0] p-4 rounded-xl mb-4">
                        <h3 class="font-semibold mb-3 flex items-center gap-2">
                            <i class="fas fa-utensils text-[#d4a373]"></i>
                            Table Information
                        </h3>
                        <div class="grid grid-cols-2 gap-3">
                            <div>
                                <p class="text-xs text-[#64748b]">Table</p>
                                <p class="font-medium" x-text="selectedBooking?.tableNo ? (selectedBooking?.tablePrefix + ' - ' + selectedBooking?.tableNo) : 'Table #' + selectedBooking?.tableId"></p>
                            </div>
                            <div>
                                <p class="text-xs text-[#64748b]">Location</p>
                                <p class="font-medium" x-text="selectedBooking?.locationName || 'Standard'"></p>
                            </div>
                            <div>
                                <p class="text-xs text-[#64748b]">Capacity</p>
                                <p class="font-medium" x-text="(selectedBooking?.tableCapacity || selectedBooking?.capacity || '?') + ' persons'"></p>
                            </div>
                            <div>
                                <p class="text-xs text-[#64748b]">Minimum Spend</p>
                                <p class="font-medium">$<span x-text="selectedBooking?.minimumSpend || '0'"></span></p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Guest Details -->
                    <div class="bg-[#fff9f0] p-4 rounded-xl mb-4">
                        <h3 class="font-semibold mb-3 flex items-center gap-2">
                            <i class="fas fa-user text-[#d4a373]"></i>
                            Guest Information
                        </h3>
                        <div class="grid grid-cols-2 gap-3">
                            <div>
                                <p class="text-xs text-[#64748b]">Name</p>
                                <p class="font-medium" x-text="selectedBooking?.guestName || 'N/A'"></p>
                            </div>
                            <div>
                                <p class="text-xs text-[#64748b]">Email</p>
                                <p class="font-medium" x-text="selectedBooking?.guestEmail || 'N/A'"></p>
                            </div>
                            <div>
                                <p class="text-xs text-[#64748b]">Phone</p>
                                <p class="font-medium" x-text="selectedBooking?.guestPhone || 'N/A'"></p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Booking Date & Time -->
                    <div class="bg-[#fff9f0] p-4 rounded-xl mb-4">
                        <h3 class="font-semibold mb-3 flex items-center gap-2">
                            <i class="fas fa-calendar-alt text-[#d4a373]"></i>
                            Booking Details
                        </h3>
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <p class="text-xs text-[#64748b]">Date</p>
                                <p class="font-medium" x-text="formatDate(selectedBooking?.bookingDate)"></p>
                            </div>
                            <div>
                                <p class="text-xs text-[#64748b]">Time</p>
                                <p class="font-medium" x-text="selectedBooking?.bookingTime"></p>
                                <p class="text-xs text-[#64748b]">(2 hours dining)</p>
                            </div>
                        </div>
                        <div class="mt-2 text-sm">
                            <span class="text-[#64748b]">Party Size:</span>
                            <span class="font-semibold ml-2 flex items-center gap-1">
                                <i class="fas fa-user text-[#d4a373]"></i>
                                <span x-text="selectedBooking?.partySize || '1'"></span>
                            </span>
                        </div>
                    </div>
                    
                    <!-- Special Requests -->
                    <div x-show="selectedBooking?.specialRequests" class="bg-[#fff9f0] p-4 rounded-xl mb-4">
                        <h3 class="font-semibold mb-2 flex items-center gap-2">
                            <i class="fas fa-comment text-[#d4a373]"></i>
                            Special Requests
                        </h3>
                        <p class="text-sm" x-text="selectedBooking?.specialRequests"></p>
                    </div>
                    
                    <!-- Metadata -->
                    <div class="text-xs text-[#64748b] border-t border-[#d4a373] pt-4">
                        <p>Booking ID: #<span x-text="selectedBooking?.id"></span></p>
                        <p>Created: <span x-text="formatDateTime(selectedBooking?.createdDate)"></span></p>
                        <p>Last Updated: <span x-text="formatDateTime(selectedBooking?.updatedDate)"></span></p>
                    </div>
                </div>
                
                <div class="flex justify-end mt-6">
                    <button @click="showViewModal = false" 
                            class="px-4 py-2 rounded-lg bg-[#d4a373] text-white hover:bg-[#b88b4a] transition text-sm font-medium">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!-- Cancel Confirmation Modal -->
        <div x-show="showCancelModal" class="modal-overlay" x-cloak>
            <div class="modal-content relative p-6">
                <div class="text-center">
                    <div class="flex items-center justify-center w-16 h-16 mx-auto bg-red-100 rounded-full mb-4">
                        <i class="fas fa-exclamation-triangle text-2xl text-red-500"></i>
                    </div>
                    
                    <h3 class="text-xl font-bold text-[#1e3c5c] mb-2">Cancel Table Booking</h3>
                    <p class="text-[#64748b] mb-2">
                        Are you sure you want to cancel booking 
                        <span class="font-semibold" x-text="selectedBooking?.reservationNo"></span>?
                    </p>
                    <p class="text-sm text-red-500 mb-6">
                        <i class="fas fa-info-circle mr-1"></i>
                        This action cannot be undone.
                    </p>
                    
                    <div class="flex gap-3">
                        <button @click="showCancelModal = false" 
                                class="flex-1 px-4 py-2 rounded-lg border border-[#e2e8f0] text-[#64748b] hover:bg-[#f8fafc] transition text-sm font-medium">
                            Keep Booking
                        </button>
                        <button @click="cancelBooking()" 
                                class="flex-1 px-4 py-2 rounded-lg bg-red-500 text-white hover:bg-red-600 transition text-sm font-medium">
                            Yes, Cancel
                        </button>
                    </div>
                </div>
            </div>
        </div>

    </main>

    <!-- Include Footer -->
    <jsp:include page="component/footer.jsp" />

    <script>
        function tableActivity() {
            return {
                // User data
                userId: null,
                
                // Data properties
                bookings: [],
                filteredBookings: [],
                loading: true,
                
                // Filters
                statusFilter: 'all',
                dateFrom: '',
                dateTo: '',
                searchQuery: '',
                
                // Pagination
                currentPage: 1,
                itemsPerPage: 10,
                
                // Modals
                showViewModal: false,
                showCancelModal: false,
                selectedBooking: null,
                
                init() {
                    // Get user ID from storage
                    this.userId = localStorage.getItem('userId') || sessionStorage.getItem('userId');
                    
                    if (!this.userId) {
                        // Redirect to login if not logged in
                        window.location.href = '${pageContext.request.contextPath}/login.jsp?redirect=tableactivity';
                        return;
                    }
                    
                    this.loadBookings();
                    
                    // Watch for filter changes
                    this.$watch('filteredBookings', () => {
                        this.currentPage = 1;
                    });
                },
                
                loadBookings() {
                    this.loading = true;
                    
                    fetch('${pageContext.request.contextPath}/tablebookings/api/guest?guestId=' + this.userId)
                        .then(response => {
                            if (!response.ok) throw new Error('Failed to load table bookings');
                            return response.json();
                        })
                        .then(data => {
                            this.bookings = Array.isArray(data) ? data : [];
                            this.applyFilters();
                            this.loading = false;
                        })
                        .catch(error => {
                            console.error('Error loading table bookings:', error);
                            this.bookings = [];
                            this.filteredBookings = [];
                            this.loading = false;
                            
                            if (window.showError) {
                                window.showError('Failed to load table bookings', 3000);
                            }
                        });
                },
                
                applyFilters() {
                    let filtered = [...this.bookings];
                    
                    // Status filter
                    if (this.statusFilter && this.statusFilter !== 'all') {
                        filtered = filtered.filter(b => b.status === this.statusFilter);
                    }
                    
                    // Date range filter
                    if (this.dateFrom) {
                        const fromDate = new Date(this.dateFrom);
                        fromDate.setHours(0, 0, 0, 0);
                        filtered = filtered.filter(b => {
                            if (!b.bookingDate) return true;
                            const bookingDate = new Date(b.bookingDate);
                            bookingDate.setHours(0, 0, 0, 0);
                            return bookingDate >= fromDate;
                        });
                    }
                    
                    if (this.dateTo) {
                        const toDate = new Date(this.dateTo);
                        toDate.setHours(23, 59, 59, 999);
                        filtered = filtered.filter(b => {
                            if (!b.bookingDate) return true;
                            const bookingDate = new Date(b.bookingDate);
                            bookingDate.setHours(0, 0, 0, 0);
                            return bookingDate <= toDate;
                        });
                    }
                    
                    // Search filter
                    if (this.searchQuery) {
                        const query = this.searchQuery.toLowerCase();
                        filtered = filtered.filter(b => 
                            (b.reservationNo && b.reservationNo.toLowerCase().includes(query)) ||
                            (b.tableNo && b.tableNo.toLowerCase().includes(query)) ||
                            (b.tableId && b.tableId.toString().includes(query))
                        );
                    }
                    
                    // Sort by date (newest first)
                    filtered.sort((a, b) => {
                        return new Date(b.bookingDate || b.createdDate) - new Date(a.bookingDate || a.createdDate);
                    });
                    
                    this.filteredBookings = filtered;
                },
                
                clearFilters() {
                    this.statusFilter = 'all';
                    this.dateFrom = '';
                    this.dateTo = '';
                    this.searchQuery = '';
                    this.applyFilters();
                    
                    if (window.showInfo) {
                        window.showInfo('Filters cleared', 2000);
                    }
                },
                
                // Pagination methods
                get paginatedBookings() {
                    let start = (this.currentPage - 1) * this.itemsPerPage;
                    let end = start + this.itemsPerPage;
                    return this.filteredBookings.slice(start, end);
                },
                
                get totalPages() {
                    return Math.ceil(this.filteredBookings.length / this.itemsPerPage);
                },
                
                prevPage() {
                    if (this.currentPage > 1) this.currentPage--;
                },
                
                nextPage() {
                    if (this.currentPage < this.totalPages) this.currentPage++;
                },
                
                // Modal methods
                viewBooking(booking) {
                    this.selectedBooking = booking;
                    this.showViewModal = true;
                },
                
                confirmCancel(booking) {
                    this.selectedBooking = booking;
                    this.showCancelModal = true;
                },
                
                canCancel(booking) {
                    // Guest can only cancel pending or confirmed bookings
                    return booking && (booking.status === 'pending' || booking.status === 'confirmed');
                },
                
                cancelBooking() {
                    if (!this.selectedBooking) return;
                    
                    // Show loading
                    if (window.showInfo) {
                        window.showInfo('Cancelling booking...', 0);
                    }
                    
                    fetch('${pageContext.request.contextPath}/tablebookings/api/cancel?bookingId=' + this.selectedBooking.id + '&guestId=' + this.userId, {
                        method: 'PUT'
                    })
                    .then(response => {
                        if (!response.ok) {
                            return response.json().then(errorData => {
                                throw new Error(errorData.message || `Server error: ${response.status}`);
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
                            this.showCancelModal = false;
                            this.selectedBooking = null;
                        } else {
                            if (window.showError) {
                                window.showError(data.message, 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error cancelling booking:', error);
                        if (window.showError) {
                            window.showError(error.message || 'Failed to cancel booking', 3000);
                        }
                    });
                },
                
                // Helper methods
                getStatusIcon(status) {
                    switch(status) {
                        case 'pending': return 'fa-clock';
                        case 'confirmed': return 'fa-check-circle';
                        case 'seated': return 'fa-chair';
                        case 'completed': return 'fa-check-double';
                        case 'cancelled': return 'fa-times-circle';
                        case 'rejected': return 'fa-ban';
                        case 'no_show': return 'fa-user-slash';
                        default: return 'fa-calendar';
                    }
                },
                
                formatStatus(status) {
                    if (!status) return '';
                    return status.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase());
                },
                
                formatDate(dateString) {
                    if (!dateString) return '';
                    try {
                        const options = { year: 'numeric', month: 'short', day: 'numeric' };
                        return new Date(dateString).toLocaleDateString('en-US', options);
                    } catch (e) {
                        return '';
                    }
                },
                
                formatShortDate(dateTimeString) {
                    if (!dateTimeString) return '';
                    try {
                        const options = { year: 'numeric', month: 'short', day: 'numeric' };
                        return new Date(dateTimeString).toLocaleDateString('en-US', options);
                    } catch (e) {
                        return '';
                    }
                },
                
                formatDateTime(dateTimeString) {
                    if (!dateTimeString) return '';
                    try {
                        const options = { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' };
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