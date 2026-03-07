<%-- 
    Document   : serviceactivity
    Author     : Based on bookactivity.jsp pattern
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Service Bookings · Ocean View Resort</title>
    <!-- Tailwind via CDN + Inter font -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <!-- Alpine.js for interactive components -->
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        
        /* Status badges */
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
        
        .status-completed {
            background-color: #d1fae5;
            color: #065f46;
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
            background-color: #f3e8ff;
            color: #6b21a8;
        }
        
        /* Category badges */
        .category-badge {
            padding: 0.2rem 0.5rem;
            border-radius: 9999px;
            font-size: 0.65rem;
            font-weight: 600;
            display: inline-block;
        }
        
        .category-spa {
            background-color: #e6f0fa;
            color: #2c5282;
        }
        
        .category-massage {
            background-color: #e6f7e6;
            color: #27632e;
        }
        
        .category-ayurveda {
            background-color: #f3e5f5;
            color: #6a1b9a;
        }
        
        .category-beauty {
            background-color: #fff3e0;
            color: #b85d1a;
        }
        
        .category-yoga {
            background-color: #ffe5e5;
            color: #b71c1c;
        }
        
        .category-fitness {
            background-color: #e0f2fe;
            color: #0369a1;
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
            background-color: #dbeafe;
            color: #2563eb;
        }
        
        .action-btn.view:hover {
            background-color: #bfdbfe;
        }
        
        .action-btn.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        /* Duration pill */
        .duration-pill {
            background-color: #f0f7fa;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.7rem;
            color: #0284a8;
            font-weight: 600;
            display: inline-block;
        }
        
        /* Free badge */
        .free-badge {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            display: inline-block;
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
            border-bottom: 2px solid #e2e8f0;
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
            background-color: #f8fafc;
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
            max-width: 550px;
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
        
        /* Service icon */
        .service-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #d4a373, #b85d1a);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
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
            background: linear-gradient(90deg, #f0f7fa 25%, #e2e8f0 50%, #f0f7fa 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
            border-radius: 0.5rem;
        }
        
        @keyframes loading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }
        
        [x-cloak] { display: none !important; }
    </style>
</head>
<body class="bg-[#f0f7fa] text-[#1e3c5c] antialiased">

    <!-- Include Navbar -->
    <jsp:include page="component/navbar.jsp" />
    
    <!-- Include Notification -->
    <jsp:include page="component/notification.jsp" />

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 mt-16" x-data="serviceActivity()" x-init="init()">
        
        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl md:text-4xl font-bold text-[#1e3c5c] flex items-center gap-3">
                <i class="fas fa-spa text-[#0284a8]"></i>
                My Service Bookings
            </h1>
            <p class="text-[#3a5a78] mt-2">View and manage your spa & wellness reservations</p>
        </div>

        <!-- Quick Stats -->
        <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-6">
            <div class="bg-white rounded-xl shadow-sm border border-[#e2e8f0] p-4">
                <div class="text-2xl font-bold text-[#0284a8]" x-text="stats.upcoming"></div>
                <div class="text-sm text-[#64748b]">Upcoming</div>
            </div>
            <div class="bg-white rounded-xl shadow-sm border border-[#e2e8f0] p-4">
                <div class="text-2xl font-bold text-yellow-600" x-text="stats.pending"></div>
                <div class="text-sm text-[#64748b]">Pending</div>
            </div>
            <div class="bg-white rounded-xl shadow-sm border border-[#e2e8f0] p-4">
                <div class="text-2xl font-bold text-green-600" x-text="stats.completed"></div>
                <div class="text-sm text-[#64748b]">Completed</div>
            </div>
            <div class="bg-white rounded-xl shadow-sm border border-[#e2e8f0] p-4">
                <div class="text-2xl font-bold text-[#1e3c5c]" x-text="'LKR ' + formatPrice(stats.totalSpent)"></div>
                <div class="text-sm text-[#64748b]">Total Spent</div>
            </div>
        </div>

        <!-- Filters -->
        <div class="bg-white rounded-xl shadow-sm border border-[#e2e8f0] p-4 mb-6">
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                <!-- Status Filter -->
                <div>
                    <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Filter by Status</label>
                    <select x-model="statusFilter" @change="applyFilters()" class="w-full border border-[#e2e8f0] rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                        <option value="all">All Bookings</option>
                        <option value="pending">Pending</option>
                        <option value="confirmed">Confirmed</option>
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
                           class="w-full border border-[#e2e8f0] rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                </div>

                <div>
                    <label class="block text-sm font-medium text-[#1e3c5c] mb-1">To Date</label>
                    <input type="date" 
                           x-model="dateTo"
                           @change="applyFilters()"
                           class="w-full border border-[#e2e8f0] rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                </div>

                <!-- Search -->
                <div>
                    <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Search</label>
                    <input type="text" 
                           x-model="searchQuery"
                           @input.debounce="applyFilters()"
                           placeholder="Booking # or Service"
                           class="w-full border border-[#e2e8f0] rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
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
                        <th>Booking No</th>
                        <th>Service</th>
                        <th>Category</th>
                        <th>Date & Time</th>
                        <th>Guests</th>
                        <th>Duration</th>
                        <th>Total Price</th>
                        <th>Status</th>
                        <th>Booked On</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Loading State -->
                    <template x-if="loading">
                        <tr>
                            <td colspan="10" class="text-center py-8">
                                <div class="flex justify-center">
                                    <i class="fas fa-spinner fa-spin text-2xl text-[#0284a8]"></i>
                                </div>
                            </td>
                        </tr>
                    </template>

                    <!-- No Bookings -->
                    <template x-if="!loading && filteredBookings.length === 0">
                        <tr>
                            <td colspan="10" class="text-center py-12">
                                <div class="flex flex-col items-center">
                                    <i class="fas fa-spa text-5xl text-[#94a3b8] mb-3"></i>
                                    <p class="text-[#64748b]">No service bookings found</p>
                                    <p class="text-sm text-[#94a3b8] mt-1">Try adjusting your filters</p>
                                    <a href="${pageContext.request.contextPath}/bookservice.jsp" 
                                       class="mt-4 px-4 py-2 bg-[#0284a8] text-white rounded-lg hover:bg-[#03738C] transition text-sm">
                                        Book a Service
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </template>

                    <!-- Bookings List -->
                    <template x-if="!loading && filteredBookings.length > 0">
                        <template x-for="booking in paginatedBookings" :key="booking.id">
                            <tr>
                                <!-- Booking No -->
                                <td>
                                    <span class="font-medium text-[#0284a8]" x-text="booking.bookingNo"></span>
                                </td>
                                
                                <!-- Service -->
                                <td>
                                    <div class="font-medium" x-text="booking.serviceTitle || 'Service #' + booking.serviceId"></div>
                                </td>
                                
                                <!-- Category -->
                                <td>
                                    <span class="category-badge" 
                                          :class="'category-' + getCategoryClass(booking.serviceCategoryName)">
                                        <span x-text="booking.serviceCategoryName || 'Wellness'"></span>
                                    </span>
                                </td>
                                
                                <!-- Date & Time -->
                                <td>
                                    <div x-text="formatDate(booking.bookingDate)"></div>
                                    <div class="text-xs text-[#64748b]" x-text="booking.bookingTime || ''"></div>
                                </td>
                                
                                <!-- Guests -->
                                <td class="text-center">
                                    <span x-text="booking.numberOfGuests || 1"></span>
                                    <span class="text-xs text-[#64748b]" x-text="booking.numberOfGuests === 1 ? 'person' : 'persons'"></span>
                                </td>
                                
                                <!-- Duration -->
                                <td>
                                    <span class="duration-pill">
                                        <span x-text="booking.serviceDuration ? (booking.serviceDuration === 0 ? 'Unlimited' : booking.serviceDuration + ' min') : '—'"></span>
                                    </span>
                                </td>
                                
                                <!-- Total Price -->
                                <td>
                                    <div class="font-semibold">
                                        <span x-show="booking.totalPrice === 0" class="free-badge">Free</span>
                                        <span x-show="booking.totalPrice > 0">LKR <span x-text="formatPrice(booking.totalPrice)"></span></span>
                                    </div>
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
                        class="border border-[#e2e8f0] rounded-lg px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                    <option value="10">10 / page</option>
                    <option value="20">20 / page</option>
                    <option value="50">50 / page</option>
                </select>
            </div>
            
            <div class="flex items-center gap-2">
                <button @click="prevPage" :disabled="currentPage === 1" 
                        class="w-8 h-8 rounded-full border border-[#e2e8f0] hover:bg-[#f0f7fa] transition disabled:opacity-50 disabled:cursor-not-allowed">
                    <i class="fas fa-chevron-left text-xs"></i>
                </button>
                <span class="text-sm text-[#1e3c5c]">
                    Page <span x-text="currentPage"></span> of <span x-text="totalPages"></span>
                </span>
                <button @click="nextPage" :disabled="currentPage === totalPages" 
                        class="w-8 h-8 rounded-full border border-[#e2e8f0] hover:bg-[#f0f7fa] transition disabled:opacity-50 disabled:cursor-not-allowed">
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
                    <h2 class="text-2xl font-bold text-[#1e3c5c] mb-4">Service Booking Details</h2>
                    
                    <!-- Booking Info -->
                    <div class="bg-[#f8fafc] p-4 rounded-xl mb-4">
                        <div class="flex justify-between items-start">
                            <div>
                                <p class="text-xs text-[#64748b]">Booking Number</p>
                                <p class="text-lg font-bold text-[#0284a8]" x-text="selectedBooking?.bookingNo"></p>
                            </div>
                            <span class="status-badge" :class="'status-' + (selectedBooking?.status || 'pending')">
                                <i class="fas" :class="getStatusIcon(selectedBooking?.status)"></i>
                                <span x-text="formatStatus(selectedBooking?.status)"></span>
                            </span>
                        </div>
                    </div>
                    
                    <!-- Service Details -->
                    <div class="bg-[#f8fafc] p-4 rounded-xl mb-4">
                        <h3 class="font-semibold mb-3 flex items-center gap-2">
                            <i class="fas fa-spa text-[#0284a8]"></i>
                            Service Information
                        </h3>
                        <div class="flex items-start gap-4">
                            <div class="service-icon">
                                <i class="fas fa-spa"></i>
                            </div>
                            <div class="flex-1 grid grid-cols-2 gap-3">
                                <div class="col-span-2">
                                    <p class="text-xs text-[#64748b]">Service</p>
                                    <p class="font-medium" x-text="selectedBooking?.serviceTitle || 'N/A'"></p>
                                </div>
                                <div>
                                    <p class="text-xs text-[#64748b]">Category</p>
                                    <p class="font-medium">
                                        <span class="category-badge" 
                                              :class="'category-' + getCategoryClass(selectedBooking?.serviceCategoryName)">
                                            <span x-text="selectedBooking?.serviceCategoryName || 'Wellness'"></span>
                                        </span>
                                    </p>
                                </div>
                                <div>
                                    <p class="text-xs text-[#64748b]">Duration</p>
                                    <p class="font-medium">
                                        <span class="duration-pill">
                                            <span x-text="selectedBooking?.serviceDuration ? (selectedBooking.serviceDuration === 0 ? 'Unlimited' : selectedBooking.serviceDuration + ' minutes') : 'N/A'"></span>
                                        </span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Guest Details -->
                    <div class="bg-[#f8fafc] p-4 rounded-xl mb-4">
                        <h3 class="font-semibold mb-3 flex items-center gap-2">
                            <i class="fas fa-user text-[#0284a8]"></i>
                            Your Information
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
                            <div>
                                <p class="text-xs text-[#64748b]">Guest ID</p>
                                <p class="font-medium" x-text="'#' + selectedBooking?.guestId"></p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Booking Schedule -->
                    <div class="bg-[#f8fafc] p-4 rounded-xl mb-4">
                        <h3 class="font-semibold mb-3 flex items-center gap-2">
                            <i class="fas fa-calendar-alt text-[#0284a8]"></i>
                            Booking Schedule
                        </h3>
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <p class="text-xs text-[#64748b]">Date</p>
                                <p class="font-medium" x-text="formatDate(selectedBooking?.bookingDate)"></p>
                                <p class="text-xs text-[#0284a8]" x-text="selectedBooking?.bookingTime"></p>
                            </div>
                            <div>
                                <p class="text-xs text-[#64748b]">End Time</p>
                                <p class="font-medium" x-text="calculateEndTime(selectedBooking?.bookingTime, selectedBooking?.serviceDuration)"></p>
                                <p class="text-xs text-[#0284a8]" x-text="'Duration: ' + (selectedBooking?.serviceDuration === 0 ? 'Unlimited' : selectedBooking?.serviceDuration + ' min')"></p>
                            </div>
                        </div>
                        <div class="mt-2 text-sm">
                            <span class="text-[#64748b]">Number of Guests:</span>
                            <span class="font-semibold ml-2" x-text="selectedBooking?.numberOfGuests || 1"></span>
                        </div>
                    </div>
                    
                    <!-- Special Requests -->
                    <div x-show="selectedBooking?.specialRequests" class="bg-[#f8fafc] p-4 rounded-xl mb-4">
                        <h3 class="font-semibold mb-2 flex items-center gap-2">
                            <i class="fas fa-comment text-[#0284a8]"></i>
                            Special Requests
                        </h3>
                        <p class="text-sm" x-text="selectedBooking?.specialRequests"></p>
                    </div>
                    
                    <!-- Payment Info -->
                    <div class="bg-[#f8fafc] p-4 rounded-xl mb-4">
                        <h3 class="font-semibold mb-2 flex items-center gap-2">
                            <i class="fas fa-credit-card text-[#0284a8]"></i>
                            Payment Information
                        </h3>
                        <div class="space-y-2">
                            <div class="flex justify-between items-center">
                                <span class="text-[#64748b]">Price per person</span>
                                <span class="font-medium" x-text="selectedBooking?.serviceFee ? 'LKR ' + formatPrice(selectedBooking.serviceFee) : 'N/A'"></span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-[#64748b]">Number of guests</span>
                                <span class="font-medium" x-text="selectedBooking?.numberOfGuests || 1"></span>
                            </div>
                            <div class="border-t border-[#e2e8f0] pt-2 mt-2">
                                <div class="flex justify-between items-center">
                                    <span class="font-semibold">Total Amount</span>
                                    <span class="text-xl font-bold text-[#0284a8]">
                                        <span x-show="selectedBooking?.totalPrice === 0" class="free-badge text-base">Free</span>
                                        <span x-show="selectedBooking?.totalPrice > 0">LKR <span x-text="formatPrice(selectedBooking?.totalPrice)"></span></span>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Metadata -->
                    <div class="text-xs text-[#64748b] border-t border-[#e2e8f0] pt-4">
                        <p>Booking ID: #<span x-text="selectedBooking?.id"></span></p>
                        <p>Created: <span x-text="formatDateTime(selectedBooking?.createdDate)"></span></p>
                        <p>Last Updated: <span x-text="formatDateTime(selectedBooking?.updatedDate)"></span></p>
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

        <!-- Cancel Confirmation Modal -->
        <div x-show="showCancelModal" class="modal-overlay" x-cloak>
            <div class="modal-content relative p-6">
                <div class="text-center">
                    <div class="flex items-center justify-center w-16 h-16 mx-auto bg-red-100 rounded-full mb-4">
                        <i class="fas fa-exclamation-triangle text-2xl text-red-500"></i>
                    </div>
                    
                    <h3 class="text-xl font-bold text-[#1e3c5c] mb-2">Cancel Service Booking</h3>
                    <p class="text-[#64748b] mb-2">
                        Are you sure you want to cancel booking 
                        <span class="font-semibold" x-text="selectedBooking?.bookingNo"></span>?
                    </p>
                    <p class="text-xs text-[#64748b] mb-4">
                        Service: <span x-text="selectedBooking?.serviceTitle"></span><br>
                        Date: <span x-text="formatDate(selectedBooking?.bookingDate) + ' at ' + selectedBooking?.bookingTime"></span>
                    </p>
                    <p class="text-sm text-red-500 mb-6">
                        <i class="fas fa-info-circle mr-1"></i>
                        This action cannot be undone. Bookings can only be cancelled up to 2 hours before the scheduled time.
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
        function serviceActivity() {
            return {
                // User data
                userId: null,
                
                // Data properties
                bookings: [],
                filteredBookings: [],
                loading: true,
                
                // Stats
                stats: {
                    upcoming: 0,
                    pending: 0,
                    completed: 0,
                    totalSpent: 0
                },
                
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
                        window.location.href = '${pageContext.request.contextPath}/login.jsp?redirect=serviceactivity';
                        return;
                    }
                    
                    this.loadBookings();
                    
                    // Watch for filter changes
                    this.$watch('filteredBookings', () => {
                        this.currentPage = 1;
                        this.calculateStats();
                    });
                },
                
                loadBookings() {
                    this.loading = true;
                    
                    fetch('${pageContext.request.contextPath}/bookservice/api/guest?guestId=' + this.userId)
                        .then(response => {
                            if (!response.ok) throw new Error('Failed to load bookings');
                            return response.json();
                        })
                        .then(data => {
                            this.bookings = Array.isArray(data) ? data : [];
                            this.applyFilters();
                            this.calculateStats();
                            this.loading = false;
                        })
                        .catch(error => {
                            console.error('Error loading bookings:', error);
                            this.bookings = [];
                            this.filteredBookings = [];
                            this.loading = false;
                            
                            if (window.showError) {
                                window.showError('Failed to load service bookings', 3000);
                            }
                        });
                },
                
                calculateStats() {
                    const now = new Date();
                    const today = now.toISOString().split('T')[0];
                    
                    this.stats = {
                        upcoming: this.bookings.filter(b => 
                            (b.status === 'confirmed' || b.status === 'pending') && 
                            b.bookingDate >= today
                        ).length,
                        pending: this.bookings.filter(b => b.status === 'pending').length,
                        completed: this.bookings.filter(b => b.status === 'completed').length,
                        totalSpent: this.bookings
                            .filter(b => b.status === 'completed' && b.totalPrice)
                            .reduce((sum, b) => sum + (b.totalPrice || 0), 0)
                    };
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
                            (b.bookingNo && b.bookingNo.toLowerCase().includes(query)) ||
                            (b.serviceTitle && b.serviceTitle.toLowerCase().includes(query)) ||
                            (b.serviceCategoryName && b.serviceCategoryName.toLowerCase().includes(query))
                        );
                    }
                    
                    // Sort by date (newest first)
                    filtered.sort((a, b) => {
                        return new Date(b.bookingDate + 'T' + (b.bookingTime || '00:00')) - 
                               new Date(a.bookingDate + 'T' + (a.bookingTime || '00:00'));
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
                    // Business logic: can cancel up to 2 hours before
                    if (!booking || (booking.status !== 'pending' && booking.status !== 'confirmed')) {
                        return false;
                    }
                    
                    // Check if booking is at least 2 hours in the future
                    const now = new Date();
                    const bookingDateTime = new Date(booking.bookingDate + 'T' + booking.bookingTime);
                    const twoHoursFromNow = new Date(now.getTime() + 2 * 60 * 60 * 1000);
                    
                    return bookingDateTime > twoHoursFromNow;
                },
                
                cancelBooking() {
                    if (!this.selectedBooking) return;
                    
                    // Show loading
                    if (window.showInfo) {
                        window.showInfo('Cancelling booking...', 0);
                    }
                    
                    fetch('${pageContext.request.contextPath}/bookservice/api/cancel?bookingId=' + this.selectedBooking.id + '&guestId=' + this.userId, {
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
                getCategoryClass(categoryName) {
                    if (!categoryName) return 'spa';
                    const name = categoryName.toLowerCase();
                    if (name.includes('massage')) return 'massage';
                    if (name.includes('ayurveda')) return 'ayurveda';
                    if (name.includes('beauty')) return 'beauty';
                    if (name.includes('yoga')) return 'yoga';
                    if (name.includes('fitness')) return 'fitness';
                    return 'spa';
                },
                
                calculateEndTime(timeString, duration) {
                    if (!timeString || !duration || duration === 0) return '—';
                    try {
                        const [hours, minutes] = timeString.split(':').map(Number);
                        const startTime = new Date();
                        startTime.setHours(hours, minutes, 0);
                        const endTime = new Date(startTime.getTime() + duration * 60000);
                        return endTime.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true });
                    } catch (e) {
                        return '—';
                    }
                },
                
                getStatusIcon(status) {
                    switch(status) {
                        case 'pending': return 'fa-clock';
                        case 'confirmed': return 'fa-check-circle';
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
                
                formatPrice(price) {
                    if (!price && price !== 0) return '0';
                    return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
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