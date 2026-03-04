<%-- 
    Document   : contactmessage
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · Contact Messages</title>
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
            padding: 1rem 1rem;
            border-bottom: 2px solid #b5e5e0;
        }
        td {
            padding: 1rem 1rem;
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
        }
        .reply-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
            text-align: center;
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
        .message-preview {
            max-width: 250px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        /* Loading spinner */
        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #0284a8;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        /* Notification animation */
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        .notification-slide {
            animation: slideIn 0.3s ease-out;
        }
    </style>
</head>
<body class="bg-[#f0f7fa] text-[#1e3c5c] antialiased flex">

    <!-- Include Sidebar -->
    <jsp:include page="/component/sidebar.jsp" />

    <!-- ===== MAIN DASHBOARD (right side) ===== -->
    <main class="flex-1 overflow-y-auto" x-data="contactManager()" x-init="init()">
        <!-- top bar -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#b5e5e0] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">✉️</span>
                <span class="font-semibold">Contact Message Management</span>
            </div>
            <div class="flex items-center gap-3">
                <span class="bg-[#0284a8] text-white text-xs px-3 py-1.5 rounded-full" x-text="`${filteredMessages.length} messages`"></span>
                <button @click="refreshData()" class="bg-[#b5e5e0] p-2 rounded-lg hover:bg-[#9ac9c2] transition" title="Refresh">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-[#0284a8]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                    </svg>
                </button>
            </div>
        </header>

        <!-- Loading Indicator -->
        <div x-show="loading" class="flex justify-center items-center py-20">
            <div class="loading-spinner"></div>
        </div>

        <!-- dashboard content -->
        <div x-show="!loading" class="p-4 md:p-6 lg:p-8 space-y-6 max-w-full">

            <!-- Header with title -->
            <div>
                <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Customer Contact Messages ✉️</h2>
                <p class="text-[#3a5a78] text-base mt-1">View and manage customer inquiries</p>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-5 gap-4">
                <!-- Total Messages -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Total Messages</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="stats.total"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0]/30 flex items-center justify-center">
                            <span class="text-2xl">📨</span>
                        </div>
                    </div>
                </div>
                
                <!-- Read Messages -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Read</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="stats.read"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0] flex items-center justify-center">
                            <span class="text-2xl">👁️</span>
                        </div>
                    </div>
                </div>
                
                <!-- Unread Messages -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Unread</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="stats.unread"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#f8e4c3] flex items-center justify-center">
                            <span class="text-2xl">📫</span>
                        </div>
                    </div>
                </div>

                <!-- Replied Messages -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Replied</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="stats.replied"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#9ac9c2] flex items-center justify-center">
                            <span class="text-2xl">✅</span>
                        </div>
                    </div>
                </div>

                <!-- Not Replied Messages -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Not Replied</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="stats.notReplied"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#f8e4c3] flex items-center justify-center">
                            <span class="text-2xl">⏳</span>
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
                           placeholder="Search by name, email, phone, or message..." 
                           class="w-full pl-10 pr-4 py-3 rounded-xl border border-[#b5e5e0] focus:outline-none focus:ring-2 focus:ring-[#0284a8] focus:border-transparent text-sm">
                    <span class="absolute left-3 top-3.5 text-[#3a5a78] text-lg">🔍</span>
                </div>

                <!-- Filter Row -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-6 gap-3">
                    <!-- Status Filter (Read/Unread) -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Status</label>
                        <select x-model="statusFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Status</option>
                            <option value="read">Read</option>
                            <option value="unread">Unread</option>
                        </select>
                    </div>

                    <!-- Reply Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Reply Status</label>
                        <select x-model="replyFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Replies</option>
                            <option value="replied">Replied</option>
                            <option value="not_replied">Not Replied</option>
                        </select>
                    </div>

                    <!-- Reply Method Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Reply Method</label>
                        <select x-model="methodFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Methods</option>
                            <option value="email">Email</option>
                            <option value="phone">Phone</option>
                            <option value="both">Both</option>
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

                    <!-- Year Filter - Dynamically populated from data -->
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

            <!-- Messages Table -->
            <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] overflow-hidden">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Message</th>
                                <th>Reply Method</th>
                                <th>Status</th>
                                <th>Reply</th>
                                <th>Sent Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template x-for="message in paginatedMessages" :key="message.id">
                                <tr>
                                    <!-- Name -->
                                    <td>
                                        <div class="font-medium text-[#1e3c5c]" x-text="message.name"></div>
                                    </td>
                                    
                                    <!-- Email -->
                                    <td>
                                        <div class="text-sm text-[#3a5a78]" x-text="message.email"></div>
                                    </td>
                                    
                                    <!-- Phone -->
                                    <td>
                                        <div class="text-sm text-[#3a5a78]" x-text="message.phone || '—'"></div>
                                    </td>
                                    
                                    <!-- Message (with preview) -->
                                    <td>
                                        <div class="message-preview text-sm text-[#1e3c5c]" x-text="message.message"></div>
                                    </td>
                                    
                                    <!-- Reply Method -->
                                    <td>
                                        <span class="px-2 py-1 rounded-full text-xs font-medium"
                                              :class="{
                                                  'bg-blue-100 text-blue-700': message.replyMethod === 'email',
                                                  'bg-green-100 text-green-700': message.replyMethod === 'phone',
                                                  'bg-purple-100 text-purple-700': message.replyMethod === 'both'
                                              }"
                                              x-text="message.replyMethod ? (message.replyMethod.charAt(0).toUpperCase() + message.replyMethod.slice(1)) : 'Email'">
                                        </span>
                                    </td>
                                    
                                    <!-- Status Badge (Read/Unread) - Display only -->
                                    <td>
                                        <span class="status-badge w-full"
                                              :class="{
                                                  'bg-[#b5e5e0] text-[#0284a8]': message.status === true,
                                                  'bg-[#f8e4c3] text-[#d4a373]': message.status === false
                                              }">
                                            <span class="flex items-center justify-center gap-1">
                                                <span x-text="message.status === true ? '👁️' : '📫'"></span>
                                                <span x-text="message.status === true ? 'Read' : 'Unread'"></span>
                                            </span>
                                        </span>
                                    </td>
                                    
                                    <!-- Reply Badge (Replied/Not Replied) - Display only -->
                                    <td>
                                        <span class="reply-badge w-full"
                                              :class="{
                                                  'bg-[#9ac9c2] text-[#03738C]': message.reply === true,
                                                  'bg-[#f8e4c3] text-[#d4a373]': message.reply === false
                                              }">
                                            <span class="flex items-center justify-center gap-1">
                                                <span x-text="message.reply === true ? '✅' : '⏳'"></span>
                                                <span x-text="message.reply === true ? 'Replied' : 'Not Replied'"></span>
                                            </span>
                                        </span>
                                    </td>
                                    
                                    <!-- Sent Date -->
                                    <td>
                                        <div class="text-sm text-[#3a5a78]" x-text="formatDate(message.sentDate)"></div>
                                    </td>
                                    
                                    <!-- Actions -->
                                    <td>
                                        <div class="flex items-center gap-2">
                                            <!-- View Details - Always visible -->
                                            <button @click="viewDetails(message)" 
                                                    class="action-btn bg-[#b5e5e0] text-[#0284a8] hover:bg-[#9ac9c2]"
                                                    title="View Details">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                                </svg>
                                            </button>
                                            
                                            <!-- REMOVED: Mark as Read/Unread toggle button - no longer shown -->
                                            
                                            <!-- Reply Icon - Only show if reply is false (not replied) -->
                                            <button x-show="message.reply === false" 
                                                    @click="confirmMarkAsReplied(message)"
                                                    class="action-btn bg-green-100 text-green-600 hover:bg-green-200"
                                                    title="Mark as Replied">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6" />
                                                </svg>
                                            </button>
                                            
                                            <!-- Delete Button -->
                                            <button @click="confirmDelete(message)" 
                                                    class="action-btn bg-red-100 text-red-600 hover:bg-red-200"
                                                    title="Delete">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
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
            <div x-show="filteredMessages.length === 0" class="text-center py-12">
                <span class="text-5xl mb-3 block">😕</span>
                <p class="text-lg text-[#3a5a78]">No messages found matching your filters</p>
                <button @click="clearFilters()" class="mt-4 px-6 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                    Clear Filters
                </button>
            </div>

            <!-- Pagination with Items Per Page Selector -->
            <div x-show="filteredMessages.length > 0" class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-6">
                <div class="flex items-center gap-2">
                    <span class="text-sm text-[#3a5a78]">Show:</span>
                    <select x-model="itemsPerPage" @change="currentPage = 1; updatePaginatedMessages()" 
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
                    <span x-text="Math.min(currentPage * itemsPerPage, filteredMessages.length)"></span> 
                    of <span x-text="filteredMessages.length"></span>
                </div>
            </div>
        </div>

        <!-- View Message Modal (Read Only) -->
        <div x-show="showViewModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="showViewModal = false">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-2xl w-full p-6 transform transition-all"
                 @click.stop>
                
                <div class="flex justify-between items-start mb-4">
                    <h3 class="text-xl font-bold text-[#1e3c5c]">Message Details</h3>
                    <button @click="showViewModal = false" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <div class="space-y-4" x-show="selectedMessage">
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <p class="text-sm text-[#3a5a78]">Name</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedMessage?.name"></p>
                        </div>
                        <div>
                            <p class="text-sm text-[#3a5a78]">Email</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedMessage?.email"></p>
                        </div>
                        <div>
                            <p class="text-sm text-[#3a5a78]">Phone</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedMessage?.phone || '—'"></p>
                        </div>
                        <div>
                            <p class="text-sm text-[#3a5a78]">Reply Method</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedMessage?.replyMethod ? (selectedMessage.replyMethod.charAt(0).toUpperCase() + selectedMessage.replyMethod.slice(1)) : 'Email'"></p>
                        </div>
                        <div>
                            <p class="text-sm text-[#3a5a78]">Status</p>
                            <p class="font-medium" :class="selectedMessage?.status === true ? 'text-[#0284a8]' : 'text-[#d4a373]'">
                                <span x-text="selectedMessage?.status === true ? 'Read' : 'Unread'"></span>
                            </p>
                        </div>
                        <div>
                            <p class="text-sm text-[#3a5a78]">Reply Status</p>
                            <p class="font-medium" :class="selectedMessage?.reply === true ? 'text-[#03738C]' : 'text-[#d4a373]'">
                                <span x-text="selectedMessage?.reply === true ? 'Replied' : 'Not Replied'"></span>
                            </p>
                        </div>
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Sent Date</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="formatDate(selectedMessage?.sentDate)"></p>
                        </div>
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Message</p>
                            <p class="text-[#1e3c5c] bg-[#f0f7fa] p-3 rounded-lg whitespace-pre-wrap" x-text="selectedMessage?.message"></p>
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

        <!-- Confirmation Modal for Mark as Replied -->
        <div x-show="showReplyConfirmModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="showReplyConfirmModal = false">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-md w-full p-6 transform transition-all"
                 @click.stop>
                
                <div class="flex items-center justify-center w-16 h-16 mx-auto bg-green-100 rounded-full mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6" />
                    </svg>
                </div>
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Mark as Replied</h3>
                <p class="text-[#3a5a78] text-center mb-6">
                    Are you sure you want to mark message from <span class="font-semibold" x-text="selectedMessage?.name"></span> as replied?
                </p>
                
                <div class="flex gap-3">
                    <button @click="showReplyConfirmModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                    <button @click="markAsReplied()" 
                            class="flex-1 px-4 py-2.5 rounded-lg bg-green-500 text-white hover:bg-green-600 transition text-sm font-medium">
                        Confirm
                    </button>
                </div>
            </div>
        </div>

        <!-- Confirmation Modal for Delete -->
        <div x-show="showDeleteConfirmModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="showDeleteConfirmModal = false">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-md w-full p-6 transform transition-all"
                 @click.stop>
                
                <div class="flex items-center justify-center w-16 h-16 mx-auto bg-red-100 rounded-full mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                </div>
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Delete Message</h3>
                <p class="text-[#3a5a78] text-center mb-6">
                    Are you sure you want to delete message from <span class="font-semibold" x-text="selectedMessage?.name"></span>? This action cannot be undone.
                </p>
                
                <div class="flex gap-3">
                    <button @click="showDeleteConfirmModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                    <button @click="deleteMessage()" 
                            class="flex-1 px-4 py-2.5 rounded-lg bg-red-500 text-white hover:bg-red-600 transition text-sm font-medium">
                        Delete
                    </button>
                </div>
            </div>
        </div>

    </main>

    <script>
        function contactManager() {
            return {
                // Data properties
                messages: [],
                filteredMessages: [],
                paginatedMessages: [],
                stats: {
                    total: 0,
                    read: 0,
                    unread: 0,
                    replied: 0,
                    notReplied: 0
                },
                
                // Filter properties
                searchQuery: '',
                statusFilter: 'all',
                replyFilter: 'all',
                methodFilter: 'all',
                monthFilter: 'all',
                yearFilter: 'all',
                dateFilter: '',
                
                // Pagination
                currentPage: 1,
                itemsPerPage: 10,
                
                // UI state
                loading: true,
                
                // Modal properties
                showViewModal: false,
                showReplyConfirmModal: false,
                showDeleteConfirmModal: false,
                selectedMessage: null,
                
                // Computed property for total pages
                get totalPages() {
                    return Math.ceil(this.filteredMessages.length / this.itemsPerPage);
                },
                
                // Get available years from messages
                get availableYears() {
                    var years = new Set();
                    this.messages.forEach(message => {
                        if (message.sentDate) {
                            var year = new Date(message.sentDate).getFullYear();
                            years.add(year.toString());
                        }
                    });
                    return Array.from(years).sort().reverse(); // Sort descending (newest first)
                },
                
                // Initialize
                init: function() {
                    this.loadData();
                    this.loadStats();
                },
                
                // Load all messages
                loadData: function() {
                    this.loading = true;
                    var self = this;
                    
                    fetch('${pageContext.request.contextPath}/contact/api/list')
                        .then(response => response.json())
                        .then(data => {
                            self.messages = data;
                            self.applyFilters();
                            self.loading = false;
                        })
                        .catch(error => {
                            console.error('Error loading messages:', error);
                            if (window.showError) {
                                window.showError('Failed to load messages');
                            }
                            self.loading = false;
                        });
                },
                
                // Load statistics
                loadStats: function() {
                    var self = this;
                    
                    fetch('${pageContext.request.contextPath}/contact/api/stats')
                        .then(response => response.json())
                        .then(data => {
                            self.stats = data;
                        })
                        .catch(error => {
                            console.error('Error loading stats:', error);
                        });
                },
                
                // Refresh data
                refreshData: function() {
                    this.loadData();
                    this.loadStats();
                },
                
                // Handle search with debounce
                handleSearch: function() {
                    var self = this;
                    clearTimeout(this.searchTimeout);
                    this.searchTimeout = setTimeout(function() {
                        self.applyFilters();
                    }, 300);
                },
                
                // Apply filters
                applyFilters: function() {
                    var self = this;
                    
                    // Build query parameters
                    var params = new URLSearchParams();
                    if (this.searchQuery) params.append('q', this.searchQuery);
                    
                    // Determine which API endpoint to use based on filters
                    var url = '${pageContext.request.contextPath}/contact/api/list';
                    
                    if (this.statusFilter !== 'all') {
                        url = this.statusFilter === 'read' 
                            ? '${pageContext.request.contextPath}/contact/api/read'
                            : '${pageContext.request.contextPath}/contact/api/unread';
                    } else if (this.replyFilter !== 'all') {
                        url = this.replyFilter === 'replied'
                            ? '${pageContext.request.contextPath}/contact/api/replied'
                            : '${pageContext.request.contextPath}/contact/api/not-replied';
                    }
                    
                    // If searching, use search API
                    if (this.searchQuery) {
                        url = '${pageContext.request.contextPath}/contact/api/search?' + params.toString();
                    }
                    
                    fetch(url)
                        .then(response => response.json())
                        .then(data => {
                            self.filteredMessages = data.filter(function(message) {
                                // Apply client-side filters that aren't handled by API
                                
                                // Reply method filter
                                if (self.methodFilter !== 'all' && message.replyMethod !== self.methodFilter) {
                                    return false;
                                }
                                
                                // Month filter
                                if (self.monthFilter !== 'all') {
                                    var messageDate = new Date(message.sentDate);
                                    var month = (messageDate.getMonth() + 1).toString();
                                    if (month.length === 1) month = '0' + month;
                                    if (month !== self.monthFilter) return false;
                                }
                                
                                // Year filter
                                if (self.yearFilter !== 'all') {
                                    var messageDate = new Date(message.sentDate);
                                    var year = messageDate.getFullYear().toString();
                                    if (year !== self.yearFilter) return false;
                                }
                                
                                // Date filter
                                if (self.dateFilter && message.sentDate !== self.dateFilter) {
                                    return false;
                                }
                                
                                return true;
                            });
                            
                            self.currentPage = 1;
                            self.updatePaginatedMessages();
                        })
                        .catch(error => {
                            console.error('Error applying filters:', error);
                        });
                },
                
                // Update paginated messages
                updatePaginatedMessages: function() {
                    var start = (this.currentPage - 1) * this.itemsPerPage;
                    var end = start + this.itemsPerPage;
                    this.paginatedMessages = this.filteredMessages.slice(start, end);
                },
                
                // Clear all filters
                clearFilters: function() {
                    this.searchQuery = '';
                    this.statusFilter = 'all';
                    this.replyFilter = 'all';
                    this.methodFilter = 'all';
                    this.monthFilter = 'all';
                    this.yearFilter = 'all';
                    this.dateFilter = '';
                    this.applyFilters();
                    
                    if (window.showInfo) {
                        window.showInfo('Filters cleared');
                    }
                },
                
                // Format date
                formatDate: function(dateString) {
                    if (!dateString) return '—';
                    var options = { year: 'numeric', month: 'short', day: 'numeric' };
                    return new Date(dateString).toLocaleDateString('en-US', options);
                },
                
                // View message details - automatically marks as read
                viewDetails: function(message) {
                    this.selectedMessage = message;
                    this.showViewModal = true;
                    
                    // Auto-mark as read when viewed (if unread) - one-way only
                    if (message.status === false) {
                        var self = this;
                        
                        fetch('${pageContext.request.contextPath}/contact/api/' + message.id + '/status', {
                            method: 'PUT',
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify({ status: true })
                        })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                message.status = true;
                                self.loadStats();
                                if (window.showSuccess) {
                                    window.showSuccess('Message marked as read');
                                }
                            }
                        })
                        .catch(error => {
                            console.error('Error updating status:', error);
                        });
                    }
                },
                
                // Confirm mark as replied
                confirmMarkAsReplied: function(message) {
                    this.selectedMessage = message;
                    this.showReplyConfirmModal = true;
                },
                
                // Mark as replied - one-way only
                markAsReplied: function() {
                    if (!this.selectedMessage) return;
                    
                    var self = this;
                    var message = this.selectedMessage;
                    
                    fetch('${pageContext.request.contextPath}/contact/api/' + message.id + '/reply', {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ replied: true })
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            message.reply = true;
                            this.showReplyConfirmModal = false;
                            this.loadStats();
                            if (window.showSuccess) {
                                window.showSuccess(data.message);
                            }
                        } else {
                            if (window.showError) {
                                window.showError(data.message);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error updating reply status:', error);
                        if (window.showError) {
                            window.showError('Failed to update reply status');
                        }
                    });
                },
                
                // Confirm delete
                confirmDelete: function(message) {
                    this.selectedMessage = message;
                    this.showDeleteConfirmModal = true;
                },
                
                // Delete message
                deleteMessage: function() {
                    if (!this.selectedMessage) return;
                    
                    var self = this;
                    var message = this.selectedMessage;
                    
                    fetch('${pageContext.request.contextPath}/contact/api/' + message.id, {
                        method: 'DELETE'
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Remove from arrays
                            self.messages = self.messages.filter(m => m.id !== message.id);
                            self.filteredMessages = self.filteredMessages.filter(m => m.id !== message.id);
                            self.updatePaginatedMessages();
                            self.loadStats();
                            self.showDeleteConfirmModal = false;
                            
                            if (window.showSuccess) {
                                window.showSuccess(data.message);
                            }
                        } else {
                            if (window.showError) {
                                window.showError(data.message);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error deleting message:', error);
                        if (window.showError) {
                            window.showError('Failed to delete message');
                        }
                    });
                },
                
                // Pagination methods
                prevPage: function() {
                    if (this.currentPage > 1) {
                        this.currentPage--;
                        this.updatePaginatedMessages();
                    }
                },
                
                nextPage: function() {
                    if (this.currentPage < this.totalPages) {
                        this.currentPage++;
                        this.updatePaginatedMessages();
                    }
                },
                
                goToPage: function(page) {
                    this.currentPage = page;
                    this.updatePaginatedMessages();
                }
            }
        }
    </script>
</body>
</html>