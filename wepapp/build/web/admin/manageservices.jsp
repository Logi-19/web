<%-- 
    Document   : manageservices
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · Manage Services</title>
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
        .category-badge {
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
        .service-preview {
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
        /* Category dropdown with counts */
        .category-dropdown {
            max-height: 200px;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: #0284a8 #b5e5e0;
        }
        .category-dropdown::-webkit-scrollbar {
            width: 6px;
        }
        .category-dropdown::-webkit-scrollbar-track {
            background: #b5e5e0;
            border-radius: 10px;
        }
        .category-dropdown::-webkit-scrollbar-thumb {
            background: #0284a8;
            border-radius: 10px;
        }
        .category-option {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 1rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        .category-option:hover {
            background-color: #f0f7fa;
        }
        .category-option.selected {
            background-color: #b5e5e0;
            color: #0284a8;
            font-weight: 500;
        }
        .category-count {
            background-color: #0284a8;
            color: white;
            border-radius: 9999px;
            padding: 0.125rem 0.5rem;
            font-size: 0.7rem;
            font-weight: 600;
        }
        /* Duration pill */
        .duration-pill {
            background-color: #f0f7fa;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            color: #0284a8;
            font-weight: 600;
            display: inline-block;
        }
        /* Price styling */
        .price-amount {
            font-weight: 600;
            color: #1e3c5c;
        }
        /* Price range inputs */
        .price-range-input {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #b5e5e0;
            border-radius: 0.75rem;
            font-size: 0.875rem;
        }
        .price-range-input:focus {
            outline: none;
            ring: 2px solid #0284a8;
            border-color: transparent;
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
    <main class="flex-1 overflow-y-auto" x-data="serviceManager()" x-init="init()">
        <!-- top bar -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#b5e5e0] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">💆‍♀️</span>
                <span class="font-semibold">Service Management</span>
            </div>
            <div class="flex items-center gap-3">
                <span class="bg-[#0284a8] text-white text-xs px-3 py-1.5 rounded-full" x-text="`${filteredServices.length} services`"></span>
            </div>
        </header>

        <!-- dashboard content -->
        <div class="p-4 md:p-6 lg:p-8 space-y-6 max-w-full">

            <!-- Header with title and new service button -->
            <div class="flex justify-between items-center">
                <div>
                    <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Manage Services 💆‍♀️</h2>
                    <p class="text-[#3a5a78] text-base mt-1">Add, edit and manage spa & wellness services</p>
                </div>
                <button @click="openNewServiceModal()" 
                        class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Add Service
                </button>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-4 gap-4">
                <!-- Total Services -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Total Services</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="services.length"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0]/30 flex items-center justify-center">
                            <span class="text-2xl">💆‍♀️</span>
                        </div>
                    </div>
                </div>
                
                <!-- Available Services -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Available</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="getAvailableCount()"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0] flex items-center justify-center">
                            <span class="text-2xl">✅</span>
                        </div>
                    </div>
                </div>
                
                <!-- Unavailable Services -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Unavailable</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="getUnavailableCount()"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center">
                            <span class="text-2xl">⏸️</span>
                        </div>
                    </div>
                </div>
                
                <!-- Categories with dropdown -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4 relative" x-data="{ showCategories: false }">
                    <div class="flex items-center justify-between cursor-pointer" @click="showCategories = !showCategories">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Categories</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="getCategoriesCount()"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#9ac9c2] flex items-center justify-center">
                            <span class="text-2xl">📋</span>
                        </div>
                    </div>

                    <!-- Category dropdown with counts -->
                    <div x-show="showCategories" 
                         @click.away="showCategories = false"
                         class="absolute top-full left-0 right-0 mt-2 bg-white rounded-lg shadow-xl border border-[#b5e5e0] z-20 category-dropdown">
                        <div class="p-2">
                            <template x-for="category in getCategoryCounts()" :key="category.name">
                                <div class="category-option">
                                    <span class="text-sm text-[#1e3c5c]" x-text="category.name"></span>
                                    <span class="category-count" x-text="category.count"></span>
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
                           placeholder="Search by service title or description..." 
                           class="w-full pl-10 pr-4 py-3 rounded-xl border border-[#b5e5e0] focus:outline-none focus:ring-2 focus:ring-[#0284a8] focus:border-transparent text-sm">
                    <span class="absolute left-3 top-3.5 text-[#3a5a78] text-lg">🔍</span>
                </div>

                <!-- Filter Row -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
                    <!-- Status Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Status</label>
                        <select x-model="statusFilter" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Status</option>
                            <option value="available">Available</option>
                            <option value="unavailable">Unavailable</option>
                        </select>
                    </div>

                    <!-- Category Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Category</label>
                        <select x-model="categoryFilter" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Categories</option>
                            <template x-for="category in getCategoryCounts()" :key="category.name">
                                <option :value="category.name" x-text="category.name"></option>
                            </template>
                        </select>
                    </div>

                    <!-- Duration Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Duration</label>
                        <select x-model="durationFilter" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">Any Duration</option>
                            <option value="0">Unlimited</option>
                            <option value="30">30 min</option>
                            <option value="60">60 min</option>
                            <option value="90">90 min</option>
                            <option value="120">120 min</option>
                        </select>
                    </div>

                    <!-- Price Range Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Price Range (LKR)</label>
                        <div class="flex items-center gap-2">
                            <input type="number" 
                                   x-model="priceMin"
                                   placeholder="Min"
                                   min="0"
                                   class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <span class="text-[#3a5a78]">-</span>
                            <input type="number" 
                                   x-model="priceMax"
                                   placeholder="Max"
                                   min="0"
                                   class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                        </div>
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

            <!-- Services Table -->
            <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] overflow-hidden">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Service Title</th>
                                <th>Description</th>
                                <th>Category</th>
                                <th>Duration</th>
                                <th>Fees (LKR)</th>
                                <th>Images</th>
                                <th>Status</th>
                                <th>Created Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template x-for="service in paginatedServices" :key="service.id">
                                <tr>
                                    <!-- Service Title -->
                                    <td>
                                        <div class="font-medium text-[#1e3c5c] text-sm" x-text="service.title"></div>
                                    </td>
                                    
                                    <!-- Description -->
                                    <td>
                                        <div class="text-xs text-[#3a5a78] max-w-[200px] truncate" x-text="service.description"></div>
                                    </td>
                                    
                                    <!-- Category -->
                                    <td>
                                        <span class="category-badge text-xs"
                                              :class="{
                                                  'bg-purple-100 text-purple-700': service.category === 'Spa & Wellness',
                                                  'bg-blue-100 text-blue-700': service.category === 'Massage Therapy',
                                                  'bg-green-100 text-green-700': service.category === 'Ayurveda',
                                                  'bg-pink-100 text-pink-700': service.category === 'Beauty Treatments',
                                                  'bg-orange-100 text-orange-700': service.category === 'Yoga & Meditation',
                                                  'bg-yellow-100 text-yellow-700': service.category === 'Fitness'
                                              }">
                                            <span x-text="service.category"></span>
                                        </span>
                                    </td>
                                    
                                    <!-- Duration -->
                                    <td>
                                        <div class="duration-pill">
                                            <template x-if="service.duration === 0">
                                                <span>Unlimited</span>
                                            </template>
                                            <template x-if="service.duration > 0">
                                                <span x-text="service.duration + ' min'"></span>
                                            </template>
                                        </div>
                                    </td>
                                    
                                    <!-- Fees -->
                                    <td>
                                        <div class="price-amount">
                                            <template x-if="service.fees === 0">
                                                <span>Free</span>
                                            </template>
                                            <template x-if="service.fees > 0">
                                                <span>LKR <span x-text="formatPrice(service.fees)"></span></span>
                                            </template>
                                        </div>
                                    </td>
                                    
                                    <!-- Images -->
                                    <td>
                                        <div class="image-stack">
                                            <template x-if="service.images && service.images.length > 0">
                                                <>
                                                    <img :src="service.images[0]" alt="Service" class="image-preview" 
                                                         onerror="this.src='https://via.placeholder.com/40?text=No+Image'">
                                                    <div x-show="service.images.length > 1" class="image-count">
                                                        +<span x-text="service.images.length - 1"></span>
                                                    </div>
                                                </>
                                            </template>
                                            <template x-if="!service.images || service.images.length === 0">
                                                <div class="image-preview bg-[#f0f7fa] flex items-center justify-center text-xs text-[#3a5a78]">No</div>
                                            </template>
                                        </div>
                                    </td>
                                    
                                    <!-- Status -->
                                    <td>
                                        <span class="status-badge text-xs"
                                              :class="{
                                                  'bg-[#b5e5e0] text-[#0284a8]': service.status === 'available',
                                                  'bg-gray-200 text-gray-700': service.status === 'unavailable'
                                              }">
                                            <span class="flex items-center justify-center gap-1">
                                                <span x-text="service.status === 'available' ? '✅' : '⏸️'"></span>
                                                <span x-text="service.status === 'available' ? 'Available' : 'Unavailable'"></span>
                                            </span>
                                        </span>
                                    </td>
                                    
                                    <!-- Created Date -->
                                    <td>
                                        <div class="text-xs text-[#3a5a78]" x-text="formatShortDate(service.createdDate)"></div>
                                    </td>
                                    
                                    <!-- Actions -->
                                    <td>
                                        <div class="flex items-center gap-1">
                                            <!-- View Details -->
                                            <button @click="viewService(service)" 
                                                    class="action-btn w-7 h-7 bg-[#b5e5e0] text-[#0284a8] hover:bg-[#9ac9c2]"
                                                    title="View Details">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                                </svg>
                                            </button>
                                            
                                            <!-- Edit Service -->
                                            <button @click="editService(service)" 
                                                    class="action-btn w-7 h-7 bg-yellow-100 text-yellow-600 hover:bg-yellow-200"
                                                    title="Edit Service">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                                </svg>
                                            </button>
                                            
                                            <!-- Delete Service -->
                                            <button @click="confirmDelete(service)" 
                                                    class="action-btn w-7 h-7 bg-red-100 text-red-500 hover:bg-red-200"
                                                    title="Delete Service">
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
            <div x-show="filteredServices.length === 0" class="text-center py-12">
                <span class="text-5xl mb-3 block">💆‍♀️</span>
                <p class="text-lg text-[#3a5a78]">No services found matching your filters</p>
                <button @click="clearFilters()" class="mt-4 px-6 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                    Clear Filters
                </button>
            </div>

            <!-- Pagination with Items Per Page Selector -->
            <div x-show="filteredServices.length > 0" class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-6">
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
                    <span x-text="Math.min(currentPage * itemsPerPage, filteredServices.length)"></span> 
                    of <span x-text="filteredServices.length"></span>
                </div>
            </div>
        </div>

        <!-- Service Form Modal (New/Edit) -->
        <div x-show="showServiceFormModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="closeServiceFormModal()">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-2xl w-full p-6 transform transition-all max-h-[90vh] overflow-y-auto"
                 @click.stop>
                
                <div class="flex justify-between items-start mb-4">
                    <h3 class="text-xl font-bold text-[#1e3c5c]" x-text="formMode === 'new' ? 'Add New Service' : 'Edit Service'"></h3>
                    <button @click="closeServiceFormModal()" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <form @submit.prevent="saveService()" class="space-y-4">
                    <!-- Service Title -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Service Title *</label>
                        <input type="text" 
                               x-model="formData.title"
                               required
                               placeholder="e.g., Ayurveda Treatment, Deep Tissue Massage"
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                    </div>

                    <!-- Description -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Description *</label>
                        <textarea x-model="formData.description"
                                  required
                                  rows="3"
                                  placeholder="Detailed description of the service..."
                                  class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]"></textarea>
                    </div>

                    <!-- Category -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Category *</label>
                        <select x-model="formData.category"
                                required
                                class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="">Select Category</option>
                            <option value="Spa & Wellness">Spa & Wellness</option>
                            <option value="Massage Therapy">Massage Therapy</option>
                            <option value="Ayurveda">Ayurveda</option>
                            <option value="Beauty Treatments">Beauty Treatments</option>
                            <option value="Yoga & Meditation">Yoga & Meditation</option>
                            <option value="Fitness">Fitness</option>
                        </select>
                    </div>

                    <!-- Duration (minutes) -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Duration (minutes) *</label>
                        <input type="number" 
                               x-model="formData.duration"
                               required
                               min="0"
                               step="15"
                               placeholder="e.g., 60, 90, 120 (0 for unlimited)"
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                        <p class="text-xs text-[#3a5a78] mt-1">Enter 0 for unlimited duration</p>
                    </div>

                    <!-- Fees (LKR) -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Fees (LKR) *</label>
                        <input type="number" 
                               x-model="formData.fees"
                               required
                               min="0"
                               step="100"
                               placeholder="e.g., 5000, 7500, 10000 (0 for free)"
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                        <p class="text-xs text-[#3a5a78] mt-1">Enter 0 for free service</p>
                    </div>

                    <!-- Multiple Images Upload -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Service Images</label>
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
                            <p class="text-sm text-[#3a5a78]">Click to upload service images</p>
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
                            <option value="unavailable">Unavailable</option>
                        </select>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex justify-end gap-2 pt-4">
                        <button type="button" @click="closeServiceFormModal()" 
                                class="px-4 py-2 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                            Cancel
                        </button>
                        <button type="submit" 
                                class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                            <span x-text="formMode === 'new' ? 'Add Service' : 'Update Service'"></span>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- View Service Modal with Image Gallery -->
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
                    <h3 class="text-xl font-bold text-[#1e3c5c]">Service Details</h3>
                    <button @click="showViewModal = false" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <div class="space-y-4" x-show="selectedService">
                    <!-- Image Gallery with Navigation -->
                    <div class="col-span-2" x-show="selectedService?.images && selectedService.images.length > 0">
                        <p class="text-sm text-[#3a5a78] mb-2">Service Images</p>
                        <div class="gallery-container">
                            <img :src="selectedService.images[currentImageIndex]" class="gallery-image" 
                                 onerror="this.src='https://via.placeholder.com/800x400?text=No+Image'">
                            
                            <!-- Navigation -->
                            <button class="gallery-nav prev" @click="prevImage" x-show="selectedService.images.length > 1">
                                ←
                            </button>
                            <button class="gallery-nav next" @click="nextImage" x-show="selectedService.images.length > 1">
                                →
                            </button>
                            
                            <!-- Dots -->
                            <div class="gallery-dots" x-show="selectedService.images.length > 1">
                                <template x-for="(_, index) in selectedService.images" :key="index">
                                    <div class="gallery-dot" :class="{ 'active': currentImageIndex === index }" 
                                         @click="currentImageIndex = index"></div>
                                </template>
                            </div>
                        </div>
                    </div>
                    
                    <!-- No Images -->
                    <div class="col-span-2" x-show="!selectedService?.images || selectedService.images.length === 0">
                        <p class="text-sm text-[#3a5a78] mb-2">Service Images</p>
                        <div class="bg-[#f0f7fa] p-8 rounded-lg text-center text-[#3a5a78]">
                            No images available
                        </div>
                    </div>
                    
                    <!-- Details -->
                    <div class="grid grid-cols-2 gap-4 mt-4">
                        <!-- Service Title -->
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Service Title</p>
                            <p class="font-medium text-[#1e3c5c] text-lg" x-text="selectedService?.title"></p>
                        </div>
                        
                        <!-- Description (full width) -->
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Description</p>
                            <p class="text-[#1e3c5c] bg-[#f0f7fa] p-3 rounded-lg whitespace-pre-wrap" x-text="selectedService?.description"></p>
                        </div>
                        
                        <!-- Category -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Category</p>
                            <p class="font-medium">
                                <span class="category-badge"
                                      :class="{
                                          'bg-purple-100 text-purple-700': selectedService?.category === 'Spa & Wellness',
                                          'bg-blue-100 text-blue-700': selectedService?.category === 'Massage Therapy',
                                          'bg-green-100 text-green-700': selectedService?.category === 'Ayurveda',
                                          'bg-pink-100 text-pink-700': selectedService?.category === 'Beauty Treatments',
                                          'bg-orange-100 text-orange-700': selectedService?.category === 'Yoga & Meditation',
                                          'bg-yellow-100 text-yellow-700': selectedService?.category === 'Fitness'
                                      }">
                                    <span x-text="selectedService?.category"></span>
                                </span>
                            </p>
                        </div>
                        
                        <!-- Duration -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Duration</p>
                            <p class="font-medium">
                                <span class="duration-pill">
                                    <template x-if="selectedService?.duration === 0">
                                        <span>Unlimited</span>
                                    </template>
                                    <template x-if="selectedService?.duration > 0">
                                        <span x-text="selectedService?.duration + ' minutes'"></span>
                                    </template>
                                </span>
                            </p>
                        </div>
                        
                        <!-- Fees -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Fees</p>
                            <p class="font-medium text-[#1e3c5c] text-lg">
                                <template x-if="selectedService?.fees === 0">
                                    <span>Free</span>
                                </template>
                                <template x-if="selectedService?.fees > 0">
                                    <span>LKR <span x-text="formatPrice(selectedService?.fees)"></span></span>
                                </template>
                            </p>
                        </div>
                        
                        <!-- Status -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Status</p>
                            <p class="font-medium">
                                <span class="status-badge"
                                      :class="{
                                          'bg-[#b5e5e0] text-[#0284a8]': selectedService?.status === 'available',
                                          'bg-gray-200 text-gray-700': selectedService?.status === 'unavailable'
                                      }">
                                    <span class="flex items-center gap-1">
                                        <span x-text="selectedService?.status === 'available' ? '✅' : '⏸️'"></span>
                                        <span x-text="selectedService?.status === 'available' ? 'Available' : 'Unavailable'"></span>
                                    </span>
                                </span>
                            </p>
                        </div>
                        
                        <!-- Created Date -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Created Date</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="formatDate(selectedService?.createdDate)"></p>
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
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Delete Service</h3>
                <p class="text-[#3a5a78] text-center mb-6">
                    Are you sure you want to delete service "<span class="font-semibold" x-text="selectedService?.title"></span>"? This action cannot be undone.
                </p>
                
                <div class="flex gap-3">
                    <button @click="showDeleteModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                    <button @click="deleteService()" 
                            class="flex-1 px-4 py-2.5 rounded-lg bg-red-500 text-white hover:bg-red-600 transition text-sm font-medium">
                        Delete
                    </button>
                </div>
            </div>
        </div>

    </main>

    <script>
        function serviceManager() {
            return {
                // Sample service data with multiple images
                services: [
                    { 
                        id: 1, 
                        title: 'Ayurveda Treatment',
                        description: 'Traditional Ayurvedic healing therapy with herbal oils and specialized massage techniques to balance doshas and promote overall wellness.',
                        category: 'Ayurveda',
                        duration: 90,
                        fees: 8500,
                        images: [
                            'https://images.unsplash.com/photo-1544161515-4ab6ce6db874',
                            'https://images.unsplash.com/photo-1600334129128-685c5582fd35'
                        ],
                        status: 'available',
                        createdDate: '2024-01-15'
                    },
                    { 
                        id: 2, 
                        title: 'Deep Tissue Massage',
                        description: 'Intensive massage targeting deep muscle layers and connective tissue to relieve chronic tension and muscle pain.',
                        category: 'Massage Therapy',
                        duration: 60,
                        fees: 6500,
                        images: [
                            'https://images.unsplash.com/photo-1544161515-4ab6ce6db874',
                            'https://images.unsplash.com/photo-1600334129128-685c5582fd35',
                            'https://images.unsplash.com/photo-1519823551278-64ac92734ab2'
                        ],
                        status: 'available',
                        createdDate: '2024-01-15'
                    },
                    { 
                        id: 3, 
                        title: 'Aromatherapy Massage',
                        description: 'Relaxing massage using essential oils to enhance psychological and physical well-being.',
                        category: 'Spa & Wellness',
                        duration: 60,
                        fees: 5500,
                        images: [
                            'https://images.unsplash.com/photo-1600334129128-685c5582fd35',
                            'https://images.unsplash.com/photo-1544161515-4ab6ce6db874'
                        ],
                        status: 'available',
                        createdDate: '2024-02-10'
                    },
                    { 
                        id: 4, 
                        title: 'Facial Treatment',
                        description: 'Rejuvenating facial with deep cleansing, exfoliation, and mask to restore skin radiance.',
                        category: 'Beauty Treatments',
                        duration: 45,
                        fees: 4500,
                        images: [
                            'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881',
                            'https://images.unsplash.com/photo-1519823551278-64ac92734ab2'
                        ],
                        status: 'available',
                        createdDate: '2024-02-10'
                    },
                    { 
                        id: 5, 
                        title: 'Hot Stone Massage',
                        description: 'Therapeutic massage using heated stones to relax muscles and improve circulation.',
                        category: 'Massage Therapy',
                        duration: 75,
                        fees: 7500,
                        images: [
                            'https://images.unsplash.com/photo-1519823551278-64ac92734ab2',
                            'https://images.unsplash.com/photo-1600334129128-685c5582fd35'
                        ],
                        status: 'available',
                        createdDate: '2024-03-05'
                    },
                    { 
                        id: 6, 
                        title: 'Yoga Session',
                        description: 'Private yoga session tailored to your skill level, focusing on asanas and breathing techniques.',
                        category: 'Yoga & Meditation',
                        duration: 60,
                        fees: 3500,
                        images: [
                            'https://images.unsplash.com/photo-1545205597-3d9d02c29597',
                            'https://images.unsplash.com/photo-1575052814086-f385e2e2ad1b'
                        ],
                        status: 'unavailable',
                        createdDate: '2024-03-05'
                    },
                    { 
                        id: 7, 
                        title: 'Shirodhara Treatment',
                        description: 'Ancient Ayurvedic therapy with warm oil poured on the forehead to calm the mind and nervous system.',
                        category: 'Ayurveda',
                        duration: 90,
                        fees: 9500,
                        images: [
                            'https://images.unsplash.com/photo-1600334129128-685c5582fd35',
                            'https://images.unsplash.com/photo-1544161515-4ab6ce6db874'
                        ],
                        status: 'available',
                        createdDate: '2024-04-20'
                    },
                    { 
                        id: 8, 
                        title: 'Personal Training',
                        description: 'One-on-one fitness session with certified trainer to achieve your fitness goals.',
                        category: 'Fitness',
                        duration: 60,
                        fees: 4000,
                        images: [
                            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
                            'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b'
                        ],
                        status: 'available',
                        createdDate: '2024-05-12'
                    },
                    { 
                        id: 9, 
                        title: 'Complimentary Meditation',
                        description: 'Guided meditation session for relaxation and mindfulness. Free for all guests.',
                        category: 'Yoga & Meditation',
                        duration: 0,
                        fees: 0,
                        images: [
                            'https://images.unsplash.com/photo-1506126613408-eca07ce68773',
                            'https://images.unsplash.com/photo-1593811167562-9cef47bfc4d7'
                        ],
                        status: 'available',
                        createdDate: '2024-06-01'
                    },
                    { 
                        id: 10, 
                        title: 'Unlimited Spa Access',
                        description: 'Full day access to all spa facilities including sauna, steam room, and relaxation areas.',
                        category: 'Spa & Wellness',
                        duration: 0,
                        fees: 12000,
                        images: [
                            'https://images.unsplash.com/photo-1540555700478-4be289fbecef',
                            'https://images.unsplash.com/photo-1560750588-73207b1ef5b8'
                        ],
                        status: 'available',
                        createdDate: '2024-06-15'
                    }
                ],
                
                searchQuery: '',
                statusFilter: 'all',
                categoryFilter: 'all',
                durationFilter: 'all',
                priceMin: '',
                priceMax: '',
                
                currentPage: 1,
                itemsPerPage: 10,
                currentImageIndex: 0,
                
                // Modal properties
                showServiceFormModal: false,
                showViewModal: false,
                showDeleteModal: false,
                
                selectedService: null,
                formMode: 'new', // 'new' or 'edit'
                
                formData: {
                    id: null,
                    title: '',
                    description: '',
                    category: '',
                    duration: '',
                    fees: '',
                    images: [],
                    status: 'available'
                },
                
                // Get category counts for dropdown
                getCategoryCounts: function() {
                    var counts = {};
                    this.services.forEach(function(service) {
                        if (counts[service.category]) {
                            counts[service.category]++;
                        } else {
                            counts[service.category] = 1;
                        }
                    });
                    
                    // Convert to array and sort by count
                    var result = [];
                    for (var category in counts) {
                        result.push({
                            name: category,
                            count: counts[category]
                        });
                    }
                    return result.sort(function(a, b) { return b.count - a.count; });
                },
                
                get filteredServices() {
                    return this.services.filter(service => {
                        // Search filter - title and description
                        if (this.searchQuery) {
                            var query = this.searchQuery.toLowerCase();
                            var matchesSearch = service.title.toLowerCase().includes(query) ||
                                                service.description.toLowerCase().includes(query);
                            if (!matchesSearch) return false;
                        }
                        
                        // Status filter
                        if (this.statusFilter !== 'all' && service.status !== this.statusFilter) {
                            return false;
                        }
                        
                        // Category filter
                        if (this.categoryFilter !== 'all' && service.category !== this.categoryFilter) {
                            return false;
                        }
                        
                        // Duration filter
                        if (this.durationFilter !== 'all') {
                            var filterDuration = parseInt(this.durationFilter);
                            if (service.duration !== filterDuration) return false;
                        }
                        
                        // Price range filter
                        if (this.priceMin !== '' && this.priceMin !== null) {
                            var minPrice = parseFloat(this.priceMin);
                            if (service.fees < minPrice) return false;
                        }
                        
                        if (this.priceMax !== '' && this.priceMax !== null) {
                            var maxPrice = parseFloat(this.priceMax);
                            if (service.fees > maxPrice) return false;
                        }
                        
                        return true;
                    });
                },
                
                get paginatedServices() {
                    var start = (this.currentPage - 1) * this.itemsPerPage;
                    var end = start + this.itemsPerPage;
                    return this.filteredServices.slice(start, end);
                },
                
                get totalPages() {
                    return Math.ceil(this.filteredServices.length / this.itemsPerPage);
                },
                
                // Count methods
                getAvailableCount: function() {
                    return this.services.filter(function(s) { return s.status === 'available'; }).length;
                },
                
                getUnavailableCount: function() {
                    return this.services.filter(function(s) { return s.status === 'unavailable'; }).length;
                },
                
                getCategoriesCount: function() {
                    var categories = {};
                    this.services.forEach(function(service) {
                        categories[service.category] = true;
                    });
                    return Object.keys(categories).length;
                },
                
                init: function() {
                    var self = this;
                    
                    // Reset to first page when filters change
                    this.$watch('filteredServices', function() {
                        self.currentPage = 1;
                    });
                    
                    console.log('Service Manager initialized');
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
                
                formatPrice: function(price) {
                    if (!price) return '0';
                    return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
                },
                
                // Reset form data
                resetFormData: function() {
                    this.formData = {
                        id: null,
                        title: '',
                        description: '',
                        category: '',
                        duration: '',
                        fees: '',
                        images: [],
                        status: 'available'
                    };
                },
                
                // Handle multiple image upload
                handleImageUpload: function(event) {
                    var files = event.target.files;
                    var self = this;
                    
                    for (var i = 0; i < files.length; i++) {
                        var file = files[i];
                        var reader = new FileReader();
                        
                        reader.onload = function(e) {
                            self.formData.images.push(e.target.result);
                        };
                        
                        reader.readAsDataURL(file);
                    }
                },
                
                // Remove image
                removeImage: function(index) {
                    this.formData.images.splice(index, 1);
                },
                
                // Open new service modal
                openNewServiceModal: function() {
                    this.resetFormData();
                    this.formMode = 'new';
                    this.showServiceFormModal = true;
                },
                
                // Edit service
                editService: function(service) {
                    this.formData = {
                        id: service.id,
                        title: service.title,
                        description: service.description,
                        category: service.category,
                        duration: service.duration,
                        fees: service.fees,
                        images: service.images ? [...service.images] : [],
                        status: service.status
                    };
                    this.formMode = 'edit';
                    this.showServiceFormModal = true;
                },
                
                // Close service form modal
                closeServiceFormModal: function() {
                    this.showServiceFormModal = false;
                },
                
                // Save service (new or edit)
                saveService: function() {
                    var self = this;
                    
                    if (this.formMode === 'new') {
                        // Create new service
                        var newService = {
                            id: this.services.length + 1,
                            title: this.formData.title,
                            description: this.formData.description,
                            category: this.formData.category,
                            duration: parseInt(this.formData.duration),
                            fees: parseInt(this.formData.fees),
                            images: this.formData.images.length > 0 ? this.formData.images : [],
                            status: this.formData.status,
                            createdDate: new Date().toISOString().split('T')[0]
                        };
                        this.services.push(newService);
                        
                        if (window.showSuccess) {
                            window.showSuccess('Service added successfully', 3000);
                        }
                    } else {
                        // Update existing service
                        var index = this.services.findIndex(function(s) { return s.id === self.formData.id; });
                        if (index !== -1) {
                            this.services[index] = {
                                ...this.services[index],
                                title: this.formData.title,
                                description: this.formData.description,
                                category: this.formData.category,
                                duration: parseInt(this.formData.duration),
                                fees: parseInt(this.formData.fees),
                                images: this.formData.images.length > 0 ? this.formData.images : [],
                                status: this.formData.status
                            };
                        }
                        
                        if (window.showSuccess) {
                            window.showSuccess('Service updated successfully', 3000);
                        }
                    }
                    
                    this.closeServiceFormModal();
                },
                
                // View service details
                viewService: function(service) {
                    this.selectedService = service;
                    this.currentImageIndex = 0;
                    this.showViewModal = true;
                },
                
                // Image navigation
                prevImage: function() {
                    if (this.currentImageIndex > 0) {
                        this.currentImageIndex--;
                    } else {
                        this.currentImageIndex = this.selectedService.images.length - 1;
                    }
                },
                
                nextImage: function() {
                    if (this.currentImageIndex < this.selectedService.images.length - 1) {
                        this.currentImageIndex++;
                    } else {
                        this.currentImageIndex = 0;
                    }
                },
                
                // Confirm delete
                confirmDelete: function(service) {
                    this.selectedService = service;
                    this.showDeleteModal = true;
                },
                
                // Delete service
                deleteService: function() {
                    var self = this;
                    var index = this.services.findIndex(function(s) { return s.id === self.selectedService.id; });
                    if (index !== -1) {
                        this.services.splice(index, 1);
                        
                        if (window.showSuccess) {
                            window.showSuccess('Service deleted successfully', 3000);
                        }
                    }
                    
                    this.showDeleteModal = false;
                    this.selectedService = null;
                    
                    // Adjust current page if necessary
                    if (this.paginatedServices.length === 0 && this.currentPage > 1) {
                        this.currentPage--;
                    }
                },
                
                clearFilters: function() {
                    this.searchQuery = '';
                    this.statusFilter = 'all';
                    this.categoryFilter = 'all';
                    this.durationFilter = 'all';
                    this.priceMin = '';
                    this.priceMax = '';
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