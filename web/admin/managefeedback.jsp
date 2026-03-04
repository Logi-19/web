<%-- 
    Document   : managefeedback
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · Feedback Management</title>
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
        .line-clamp-3 {
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            word-break: break-word;
        }
        .break-word {
            word-break: break-word;
            overflow-wrap: break-word;
        }
        /* Modal backdrop */
        .modal-overlay {
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
        }
        /* Star rating colors */
        .star-1 { color: #ef4444; } /* Red for 1 star */
        .star-2 { color: #f97316; } /* Orange for 2 stars */
        .star-3 { color: #eab308; } /* Yellow for 3 stars */
        .star-4 { color: #84cc16; } /* Lime green for 4 stars */
        .star-5 { color: #22c55e; } /* Green for 5 stars */
        
        /* Loading spinner */
        .loader {
            border: 3px solid #f3f3f3;
            border-radius: 50%;
            border-top: 3px solid #0284a8;
            width: 24px;
            height: 24px;
            animation: spin 1s linear infinite;
            display: inline-block;
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
    <main class="flex-1 overflow-y-auto" x-data="feedbackManager()" x-init="init()">
        <!-- top bar -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#b5e5e0] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">💬</span>
                <span class="font-semibold">Feedback Management</span>
            </div>
            <div class="flex items-center gap-3">
                <span class="bg-[#0284a8] text-white text-xs px-3 py-1.5 rounded-full" x-text="`${filteredFeedbacks.length} feedbacks`"></span>
                <button @click="refreshData()" class="p-2 hover:bg-[#b5e5e0]/20 rounded-full transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-[#0284a8]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                    </svg>
                </button>
            </div>
        </header>

        <!-- dashboard content -->
        <div class="p-4 md:p-6 lg:p-8 space-y-6 max-w-full">

            <!-- Header with title -->
            <div>
                <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Guest Feedbacks ⭐</h2>
                <p class="text-[#3a5a78] text-base mt-1">Manage and moderate guest reviews</p>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <!-- Total Feedbacks -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Total Feedbacks</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="stats.total || feedbacks.length"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0]/30 flex items-center justify-center">
                            <span class="text-2xl">📊</span>
                        </div>
                    </div>
                </div>
                
                <!-- Visible Feedbacks (Show) -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Visible</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="stats.visible || getVisibleCount()"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0] flex items-center justify-center">
                            <span class="text-2xl">✓</span>
                        </div>
                    </div>
                </div>
                
                <!-- Hidden Feedbacks -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Hidden</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="stats.hidden || getHiddenCount()"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#f8e4c3] flex items-center justify-center">
                            <span class="text-2xl">👁️</span>
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
                           @input.debounce="handleSearch()"
                           placeholder="Search by name, email, or message..." 
                           class="w-full pl-10 pr-4 py-3 rounded-xl border border-[#b5e5e0] focus:outline-none focus:ring-2 focus:ring-[#0284a8] focus:border-transparent text-sm">
                    <span class="absolute left-3 top-3.5 text-[#3a5a78] text-lg">🔍</span>
                    <span x-show="isSearching" class="absolute right-3 top-3">
                        <span class="loader"></span>
                    </span>
                </div>

                <!-- Filter Row -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3">
                    <!-- Status Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Status</label>
                        <select x-model="statusFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Status</option>
                            <option value="visible">Visible</option>
                            <option value="hidden">Hidden</option>
                        </select>
                    </div>

                    <!-- Rating Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Rating</label>
                        <select x-model="ratingFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Ratings</option>
                            <option value="5">5 Stars ⭐⭐⭐⭐⭐</option>
                            <option value="4">4 Stars ⭐⭐⭐⭐</option>
                            <option value="3">3 Stars ⭐⭐⭐</option>
                            <option value="2">2 Stars ⭐⭐</option>
                            <option value="1">1 Star ⭐</option>
                        </select>
                    </div>

                    <!-- Month Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Month</label>
                        <select x-model="monthFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
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

                    <!-- Year Filter - Dynamic from data -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Year</label>
                        <select x-model="yearFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Years</option>
                            <template x-for="year in availableYears" :key="year">
                                <option :value="year" x-text="year"></option>
                            </template>
                        </select>
                    </div>

                    <!-- Specific Date Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Specific Date</label>
                        <input type="date" 
                               x-model="dateFilter"
                               @change="applyFilters()"
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                    </div>
                </div>

                <!-- Filter Actions -->
                <div class="flex flex-wrap justify-end gap-2 pt-2">
                    <button @click="clearFilters()" class="px-4 py-2 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Clear Filters
                    </button>
                </div>
            </div>

            <!-- Loading Indicator -->
            <div x-show="isLoading" class="text-center py-12">
                <span class="loader mx-auto"></span>
                <p class="text-[#3a5a78] mt-4">Loading feedbacks...</p>
            </div>

            <!-- Feedback Cards Grid - 2 cards per row horizontally -->
            <div x-show="!isLoading" class="grid grid-cols-1 md:grid-cols-2 gap-4 lg:gap-6">
                <template x-for="feedback in paginatedFeedbacks" :key="feedback.id">
                    <div class="bg-white rounded-2xl shadow-md border p-5 card-dash w-full overflow-hidden relative" 
                         :class="{
                             'border-[#b5e5e0]': feedback.status === true,
                             'border-[#f8e4c3]': feedback.status === false
                         }">
                        <!-- Delete Icon (Top Right - Always Visible) -->
                        <button @click="confirmDelete(feedback.id, feedback.name)" 
                                class="absolute top-3 right-3 w-8 h-8 rounded-full bg-red-50 hover:bg-red-100 flex items-center justify-center transition-colors duration-200 z-10">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                            </svg>
                        </button>

                        <!-- Header Section -->
                        <div class="flex items-center gap-3 min-w-0 flex-1 pr-8">
                            <div class="w-12 h-12 rounded-full flex-shrink-0 flex items-center justify-center text-xl font-bold" 
                                 :class="{
                                     'bg-[#f8e4c3] text-[#d4a373]': feedback.initials && ['SP', 'NP', 'NJ'].includes(feedback.initials),
                                     'bg-[#b5e5e0] text-[#0284a8]': feedback.initials && ['EJ', 'DW'].includes(feedback.initials),
                                     'bg-[#9ac9c2] text-[#03738C]': feedback.initials && ['MK', 'AR', 'LM', 'RK'].includes(feedback.initials)
                                 }"
                                 x-text="feedback.initials || feedback.name.substring(0, 2).toUpperCase()">
                            </div>
                            <div class="min-w-0 flex-1">
                                <h3 class="font-bold text-lg text-[#1e3c5c] truncate" x-text="feedback.name"></h3>
                                <p class="text-[#3a5a78] text-xs truncate" x-text="feedback.email"></p>
                            </div>
                        </div>
                        
                        <!-- Rating Section with Colored Stars -->
                        <div class="mt-3 flex items-center gap-2">
                            <div class="flex items-center gap-1">
                                <span class="text-base" :class="getStarColorClass(feedback.rating)" x-html="getStarRating(feedback.rating)"></span>
                                <span class="text-[#d4a373] font-semibold text-sm ml-1" x-text="feedback.rating.toFixed(1)"></span>
                            </div>
                        </div>
                        
                        <!-- Message Section -->
                        <div class="mt-3">
                            <p class="text-[#1e3c5c] text-sm leading-relaxed line-clamp-3 break-word" x-text="feedback.message"></p>
                        </div>
                        
                        <!-- Bottom Row: Date (Left) and Status Toggle (Right) -->
                        <div class="mt-4 flex items-center justify-between">
                            <!-- Date - Bottom Left -->
                            <span class="text-xs text-[#3a5a78]" x-text="feedback.submittedDate || feedback.date"></span>
                            
                            <!-- Status Toggle - Bottom Right -->
                            <div class="flex items-center gap-2">
                                <span class="text-xs text-[#3a5a78]">Status:</span>
                                <button @click="toggleStatus(feedback.id)" 
                                        class="relative inline-flex h-5 w-9 items-center rounded-full transition-colors focus:outline-none flex-shrink-0"
                                        :class="feedback.status === true ? 'bg-[#0284a8]' : 'bg-[#f8e4c3]'">
                                    <span class="inline-block h-3 w-3 transform rounded-full bg-white transition-transform"
                                          :class="feedback.status === true ? 'translate-x-5' : 'translate-x-1'"></span>
                                </button>
                                <span class="text-xs font-medium whitespace-nowrap" 
                                      :class="feedback.status === true ? 'text-[#03738C]' : 'text-[#d4a373]'"
                                      x-text="feedback.status === true ? 'Visible' : 'Hidden'">
                                </span>
                            </div>
                        </div>
                    </div>
                </template>
            </div>

            <!-- No Results Message -->
            <div x-show="!isLoading && filteredFeedbacks.length === 0" class="text-center py-12">
                <span class="text-5xl mb-3 block">😕</span>
                <p class="text-lg text-[#3a5a78]">No feedbacks found matching your filters</p>
                <button @click="clearFilters()" class="mt-4 px-6 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                    Clear Filters
                </button>
            </div>

            <!-- Pagination with Items Per Page Selector -->
            <div x-show="!isLoading && filteredFeedbacks.length > 0" class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-6">
                <div class="flex items-center gap-2">
                    <span class="text-sm text-[#3a5a78]">Show:</span>
                    <select x-model="itemsPerPage" @change="currentPage = 1; applyFilters()" 
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
                    <span x-text="Math.min(currentPage * itemsPerPage, filteredFeedbacks.length)"></span> 
                    of <span x-text="filteredFeedbacks.length"></span>
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
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Delete Feedback</h3>
                <p class="text-[#3a5a78] text-center mb-6">
                    Are you sure you want to delete feedback from <span class="font-semibold" x-text="deleteItemName"></span>? This action cannot be undone.
                </p>
                
                <div class="flex gap-3">
                    <button @click="showDeleteModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                    <button @click="deleteFeedback()" 
                            class="flex-1 px-4 py-2.5 rounded-lg bg-red-500 text-white hover:bg-red-600 transition text-sm font-medium">
                        Delete
                    </button>
                </div>
            </div>
        </div>

    </main>

    <script>
        // Get context path
        const contextPath = '${pageContext.request.contextPath}';
        
        function feedbackManager() {
            return {
                // Data properties
                feedbacks: [],
                allFeedbacks: [], // Store all feedbacks for filtering
                stats: {
                    total: 0,
                    visible: 0,
                    hidden: 0,
                    averageRating: 0
                },
                
                // UI state
                isLoading: true,
                isSearching: false,
                
                // Filter properties
                searchQuery: '',
                statusFilter: 'all',
                ratingFilter: 'all',
                monthFilter: 'all',
                yearFilter: 'all',
                dateFilter: '',
                
                // Pagination
                currentPage: 1,
                itemsPerPage: 10,
                
                // Delete modal
                showDeleteModal: false,
                deleteItemId: null,
                deleteItemName: '',
                
                // Computed properties
                get filteredFeedbacks() {
                    return this.allFeedbacks.filter(feedback => {
                        // Search filter
                        if (this.searchQuery) {
                            const query = this.searchQuery.toLowerCase();
                            const matchesSearch = (feedback.name && feedback.name.toLowerCase().includes(query)) ||
                                                (feedback.email && feedback.email.toLowerCase().includes(query)) ||
                                                (feedback.message && feedback.message.toLowerCase().includes(query));
                            if (!matchesSearch) return false;
                        }
                        
                        // Status filter
                        if (this.statusFilter !== 'all') {
                            const statusBool = this.statusFilter === 'visible';
                            if (feedback.status !== statusBool) return false;
                        }
                        
                        // Rating filter
                        if (this.ratingFilter !== 'all') {
                            const ratingValue = parseInt(this.ratingFilter);
                            if (Math.floor(feedback.rating) !== ratingValue) return false;
                        }
                        
                        // Date filters
                        const feedbackDate = new Date(feedback.submittedDate || feedback.date);
                        
                        // Month filter
                        if (this.monthFilter !== 'all') {
                            const month = (feedbackDate.getMonth() + 1).toString().padStart(2, '0');
                            if (month !== this.monthFilter) return false;
                        }
                        
                        // Year filter
                        if (this.yearFilter !== 'all') {
                            const year = feedbackDate.getFullYear().toString();
                            if (year !== this.yearFilter) return false;
                        }
                        
                        // Specific date filter
                        if (this.dateFilter) {
                            const feedbackDateStr = (feedback.submittedDate || feedback.date);
                            if (feedbackDateStr !== this.dateFilter) return false;
                        }
                        
                        return true;
                    });
                },
                
                get paginatedFeedbacks() {
                    const start = (this.currentPage - 1) * this.itemsPerPage;
                    const end = start + this.itemsPerPage;
                    return this.filteredFeedbacks.slice(start, end);
                },
                
                get totalPages() {
                    return Math.ceil(this.filteredFeedbacks.length / this.itemsPerPage);
                },
                
                // Get unique years from feedbacks for filter
                get availableYears() {
                    const years = new Set();
                    this.feedbacks.forEach(feedback => {
                        const dateStr = feedback.submittedDate || feedback.date;
                        if (dateStr) {
                            const year = new Date(dateStr).getFullYear();
                            if (!isNaN(year)) {
                                years.add(year.toString());
                            }
                        }
                    });
                    return Array.from(years).sort().reverse(); // Sort descending (newest first)
                },
                
                // Initialize
                init() {
                    this.fetchFeedbacks();
                    this.fetchStats();
                    
                    // Watch for filter changes
                    this.$watch('filteredFeedbacks', () => {
                        if (this.currentPage > this.totalPages) {
                            this.currentPage = Math.max(1, this.totalPages);
                        }
                    });
                },
                
                // API Calls
                async fetchFeedbacks() {
                    this.isLoading = true;
                    try {
                        const response = await fetch(contextPath + '/feedback/api/list');
                        if (!response.ok) throw new Error('Failed to fetch feedbacks');
                        
                        const data = await response.json();
                        this.feedbacks = data;
                        this.allFeedbacks = [...data];
                        
                    } catch (error) {
                        console.error('Error fetching feedbacks:', error);
                        if (window.showError) {
                            window.showError('Failed to load feedbacks. Please refresh the page.', 3000);
                        }
                    } finally {
                        this.isLoading = false;
                    }
                },
                
                async fetchStats() {
                    try {
                        const response = await fetch(contextPath + '/feedback/api/stats');
                        if (!response.ok) throw new Error('Failed to fetch stats');
                        
                        this.stats = await response.json();
                        
                    } catch (error) {
                        console.error('Error fetching stats:', error);
                    }
                },
                
                async handleSearch() {
                    if (!this.searchQuery || this.searchQuery.length < 2) {
                        this.allFeedbacks = [...this.feedbacks];
                        return;
                    }
                    
                    this.isSearching = true;
                    try {
                        const response = await fetch(contextPath + '/feedback/api/search?q=' + encodeURIComponent(this.searchQuery));
                        if (!response.ok) throw new Error('Search failed');
                        
                        const data = await response.json();
                        this.allFeedbacks = data;
                        this.currentPage = 1;
                        
                    } catch (error) {
                        console.error('Error searching feedbacks:', error);
                        if (window.showError) {
                            window.showError('Search failed. Please try again.', 3000);
                        }
                    } finally {
                        this.isSearching = false;
                    }
                },
                
                async toggleStatus(id) {
                    try {
                        const response = await fetch(contextPath + '/feedback/api/' + id + '/toggle-status', {
                            method: 'PUT'
                        });
                        
                        if (!response.ok) throw new Error('Failed to toggle status');
                        
                        const result = await response.json();
                        
                        if (result.success) {
                            // Update local data
                            const feedback = this.feedbacks.find(f => f.id === id);
                            const oldStatus = feedback ? feedback.status : null;
                            
                            if (feedback) {
                                feedback.status = !feedback.status;
                            }
                            
                            // Update allFeedbacks
                            const feedbackInFiltered = this.allFeedbacks.find(f => f.id === id);
                            if (feedbackInFiltered) {
                                feedbackInFiltered.status = !feedbackInFiltered.status;
                            }
                            
                            // Show success notification for 3 seconds with correct new status
                            if (window.showSuccess) {
                                // Get the new status after toggling
                                const newStatus = feedback ? (feedback.status ? 'visible' : 'hidden') : 'updated';
                                window.showSuccess(`Feedback status changed to ${newStatus}`, 3000);
                            }
                            
                            // Refresh stats in background
                            this.fetchStats();
                            
                            // Wait 3 seconds then refresh the page
                            setTimeout(() => {
                                window.location.reload();
                            }, 3000);
                        } else {
                            throw new Error(result.message || 'Failed to toggle status');
                        }
                        
                    } catch (error) {
                        console.error('Error toggling status:', error);
                        if (window.showError) {
                            window.showError('Failed to update status. Please try again.', 3000);
                        }
                    }
                },
                
                async deleteFeedback() {
                    try {
                        const response = await fetch(contextPath + '/feedback/api/' + this.deleteItemId, {
                            method: 'DELETE'
                        });
                        
                        if (!response.ok) throw new Error('Failed to delete feedback');
                        
                        const result = await response.json();
                        
                        if (result.success) {
                            // Remove from local arrays
                            this.feedbacks = this.feedbacks.filter(f => f.id !== this.deleteItemId);
                            this.allFeedbacks = this.allFeedbacks.filter(f => f.id !== this.deleteItemId);
                            
                            // Show success notification for 3 seconds without refreshing
                            if (window.showSuccess) {
                                window.showSuccess('Feedback deleted successfully', 3000);
                            }
                            
                            // Refresh stats in background
                            this.fetchStats();
                            
                            // Wait 3 seconds then refresh the page
                            setTimeout(() => {
                                window.location.reload();
                            }, 3000);
                            
                            // Adjust current page if necessary
                            if (this.paginatedFeedbacks.length === 0 && this.currentPage > 1) {
                                this.currentPage--;
                            }
                        } else {
                            throw new Error(result.message || 'Failed to delete feedback');
                        }
                        
                    } catch (error) {
                        console.error('Error deleting feedback:', error);
                        if (window.showError) {
                            window.showError('Failed to delete feedback. Please try again.', 3000);
                        }
                    } finally {
                        // Close modal
                        this.showDeleteModal = false;
                        this.deleteItemId = null;
                        this.deleteItemName = '';
                    }
                },
                
                async refreshData() {
                    await Promise.all([
                        this.fetchFeedbacks(),
                        this.fetchStats()
                    ]);
                    
                    if (window.showSuccess) {
                        window.showSuccess('Data refreshed successfully', 2000);
                    }
                    
                    // Wait 2 seconds then refresh the page
                    setTimeout(() => {
                        window.location.reload();
                    }, 2000);
                },
                
                // Count methods (fallback if stats not available)
                getVisibleCount() {
                    return this.feedbacks.filter(f => f.status === true).length;
                },
                
                getHiddenCount() {
                    return this.feedbacks.filter(f => f.status === false).length;
                },
                
                // UI methods
                confirmDelete(id, name) {
                    this.deleteItemId = id;
                    this.deleteItemName = name;
                    this.showDeleteModal = true;
                },
                
                getStarRating(rating) {
                    const fullStars = Math.floor(rating);
                    let stars = '';
                    for (let i = 0; i < fullStars; i++) stars += '★';
                    const emptyStars = 5 - fullStars;
                    for (let i = 0; i < emptyStars; i++) stars += '☆';
                    return stars;
                },
                
                getStarColorClass(rating) {
                    const fullRating = Math.floor(rating);
                    switch(fullRating) {
                        case 5: return 'star-5';
                        case 4: return 'star-4';
                        case 3: return 'star-3';
                        case 2: return 'star-2';
                        case 1: return 'star-1';
                        default: return 'star-3';
                    }
                },
                
                // Filter methods
                clearFilters() {
                    this.searchQuery = '';
                    this.statusFilter = 'all';
                    this.ratingFilter = 'all';
                    this.monthFilter = 'all';
                    this.yearFilter = 'all';
                    this.dateFilter = '';
                    this.currentPage = 1;
                    
                    // Reset to all feedbacks
                    this.allFeedbacks = [...this.feedbacks];
                    
                    if (window.showSuccess) {
                        window.showSuccess('Filters cleared', 2000);
                    }
                    
                    // Wait 2 seconds then refresh the page
                    setTimeout(() => {
                        window.location.reload();
                    }, 2000);
                },
                
                applyFilters() {
                    // Apply filters locally
                    this.currentPage = 1;
                    
                    // If all filters are default, show all feedbacks
                    if (this.statusFilter === 'all' && 
                        this.ratingFilter === 'all' && 
                        this.monthFilter === 'all' && 
                        this.yearFilter === 'all' && 
                        !this.dateFilter) {
                        this.allFeedbacks = [...this.feedbacks];
                    } else {
                        // Filter is handled by the computed property
                        // Just trigger reactivity
                        this.allFeedbacks = [...this.feedbacks];
                    }
                },
                
                // Pagination methods
                prevPage() {
                    if (this.currentPage > 1) this.currentPage--;
                },
                
                nextPage() {
                    if (this.currentPage < this.totalPages) this.currentPage++;
                },
                
                goToPage(page) {
                    this.currentPage = page;
                }
            }
        }
    </script>
</body>
</html>