<%-- 
    Document   : manageblogs
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="wepapp.model.BlogCategory"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · Manage Blogs</title>
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
        .blog-preview {
            max-width: 250px;
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
        /* Notification animation */
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        .notification-slide {
            animation: slideIn 0.3s ease-out;
        }
        /* Loading spinner */
        .spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #0284a8;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
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
    <main class="flex-1 overflow-y-auto" x-data="blogManager()" x-init="init()">
        <!-- top bar -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#b5e5e0] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">📝</span>
                <span class="font-semibold">Blog Management</span>
            </div>
            <div class="flex items-center gap-3">
                <span class="bg-[#0284a8] text-white text-xs px-3 py-1.5 rounded-full" x-text="`${filteredBlogs.length} blogs`"></span>
                <div x-show="loading" class="spinner w-6 h-6"></div>
            </div>
        </header>

        <!-- dashboard content -->
        <div class="p-4 md:p-6 lg:p-8 space-y-6 max-w-full">

            <!-- Header with title and new blog button -->
            <div class="flex justify-between items-center">
                <div>
                    <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Manage Blogs 📝</h2>
                    <p class="text-[#3a5a78] text-base mt-1">Create, edit and manage blog posts</p>
                </div>
                <button @click="openNewBlogModal()" 
                        class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    New Blog
                </button>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-4 gap-4">
                <!-- Total Blogs -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Total Blogs</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="blogs.length"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0]/30 flex items-center justify-center">
                            <span class="text-2xl">📝</span>
                        </div>
                    </div>
                </div>
                
                <!-- Visible Blogs -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Visible</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="getVisibleCount()"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0] flex items-center justify-center">
                            <span class="text-2xl">👁️</span>
                        </div>
                    </div>
                </div>
                
                <!-- Hidden Blogs -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Hidden</p>
                            <p class="text-3xl font-bold text-[#1e3c5c]" x-text="getHiddenCount()"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#f8e4c3] flex items-center justify-center">
                            <span class="text-2xl">👁️‍🗨️</span>
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
                            <span class="text-2xl">🏷️</span>
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
                           @input.debounce="searchBlogs()"
                           placeholder="Search by blog prefix or title..." 
                           class="w-full pl-10 pr-4 py-3 rounded-xl border border-[#b5e5e0] focus:outline-none focus:ring-2 focus:ring-[#0284a8] focus:border-transparent text-sm">
                    <span class="absolute left-3 top-3.5 text-[#3a5a78] text-lg">🔍</span>
                </div>

                <!-- Filter Row -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-6 gap-3">
                    <!-- Status Filter (Visible/Hidden) -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Status</label>
                        <select x-model="statusFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Status</option>
                            <option value="visible">Visible</option>
                            <option value="hidden">Hidden</option>
                        </select>
                    </div>

                    <!-- Category Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Category</label>
                        <select x-model="categoryFilter" @change="applyFilters()" class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="all">All Categories</option>
                            <template x-for="category in categories" :key="category.id">
                                <option :value="category.name" x-text="category.name"></option>
                            </template>
                        </select>
                    </div>

                    <!-- Blog Date Filter -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Blog Date</label>
                        <input type="date" 
                               x-model="blogDateFilter"
                               @change="applyFilters()"
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
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

                    <!-- Year Filter (Dynamic from blog data) -->
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

            <!-- Blogs Table -->
            <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] overflow-hidden">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Blog Prefix</th>
                                <th>Title</th>
                                <th>Category</th>
                                <th>Images</th>
                                <th>Link</th>
                                <th>Blog Date</th>
                                <th>Status</th>
                                <th>Posted Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template x-if="loading">
                                <tr>
                                    <td colspan="9" class="text-center py-8">
                                        <div class="spinner mx-auto"></div>
                                        <p class="mt-2 text-[#3a5a78]">Loading blogs...</p>
                                    </td>
                                </tr>
                            </template>
                            <template x-if="!loading && paginatedBlogs.length === 0">
                                <tr>
                                    <td colspan="9" class="text-center py-8 text-[#3a5a78]">
                                        No blogs found
                                    </td>
                                </tr>
                            </template>
                            <template x-for="blog in paginatedBlogs" :key="blog.id">
                                <tr>
                                    <!-- Blog Prefix -->
                                    <td>
                                        <div class="font-medium text-[#1e3c5c]" x-text="blog.blogPrefix"></div>
                                    </td>
                                    
                                    <!-- Title -->
                                    <td>
                                        <div class="text-sm text-[#1e3c5c] font-medium" x-text="blog.title"></div>
                                        <div class="text-xs text-[#3a5a78] blog-preview" x-text="blog.description ? blog.description.substring(0, 50) + '...' : ''"></div>
                                    </td>
                                    
                                    <!-- Category -->
                                    <td>
                                        <span class="px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-700">
                                            <span x-text="blog.categoryName || blog.category"></span>
                                        </span>
                                    </td>
                                    
                                    <!-- Images -->
                                    <td>
                                        <div class="image-stack">
                                            <template x-if="blog.images && blog.images.length > 0">
                                                <>
                                                    <img :src="blog.images[0]" alt="Blog" class="image-preview" 
                                                         onerror="this.src='https://via.placeholder.com/40?text=No+Image'">
                                                    <div x-show="blog.images.length > 1" class="image-count">
                                                        +<span x-text="blog.images.length - 1"></span>
                                                    </div>
                                                </>
                                            </template>
                                            <template x-if="!blog.images || blog.images.length === 0">
                                                <div class="image-count">No</div>
                                            </template>
                                        </div>
                                    </td>
                                    
                                    <!-- Link -->
                                    <td>
                                        <template x-if="blog.link">
                                            <a :href="blog.link" target="_blank" class="text-[#0284a8] hover:underline text-sm">
                                                View Link
                                            </a>
                                        </template>
                                        <template x-if="!blog.link">
                                            <span class="text-sm text-[#3a5a78]">No link</span>
                                        </template>
                                    </td>
                                    
                                    <!-- Blog Date -->
                                    <td>
                                        <div class="text-sm text-[#3a5a78]" x-text="formatDate(blog.blogDate)"></div>
                                    </td>
                                    
                                    <!-- Status Badge (using boolean) -->
                                    <td>
                                        <span class="status-badge w-full"
                                              :class="{
                                                  'bg-[#b5e5e0] text-[#0284a8]': blog.status === true,
                                                  'bg-[#f8e4c3] text-[#d4a373]': blog.status === false
                                              }">
                                            <span class="flex items-center justify-center gap-1">
                                                <span x-text="blog.status === true ? '👁️' : '👁️‍🗨️'"></span>
                                                <span x-text="blog.status === true ? 'Visible' : 'Hidden'"></span>
                                            </span>
                                        </span>
                                    </td>
                                    
                                    <!-- Posted Date -->
                                    <td>
                                        <div class="text-sm text-[#3a5a78]" x-text="formatDate(blog.postedDate)"></div>
                                    </td>
                                    
                                    <!-- Actions -->
                                    <td>
                                        <div class="flex items-center gap-2">
                                            <!-- View Details -->
                                            <button @click="viewBlog(blog)" 
                                                    class="action-btn bg-[#b5e5e0] text-[#0284a8] hover:bg-[#9ac9c2]"
                                                    title="View Details">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                                </svg>
                                            </button>
                                            
                                            <!-- Edit Blog -->
                                            <button @click="editBlog(blog)" 
                                                    class="action-btn bg-yellow-100 text-yellow-600 hover:bg-yellow-200"
                                                    title="Edit Blog">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                                </svg>
                                            </button>
                                            
                                            <!-- Delete Blog -->
                                            <button @click="confirmDelete(blog)" 
                                                    class="action-btn bg-red-100 text-red-500 hover:bg-red-200"
                                                    title="Delete Blog">
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
            <div x-show="!loading && filteredBlogs.length === 0" class="text-center py-12">
                <span class="text-5xl mb-3 block">😕</span>
                <p class="text-lg text-[#3a5a78]">No blogs found matching your filters</p>
                <button @click="clearFilters()" class="mt-4 px-6 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                    Clear Filters
                </button>
            </div>

            <!-- Pagination with Items Per Page Selector -->
            <div x-show="!loading && filteredBlogs.length > 0" class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-6">
                <div class="flex items-center gap-2">
                    <span class="text-sm text-[#3a5a78]">Show:</span>
                    <select x-model="itemsPerPage" @change="currentPage = 1; loadBlogs()" 
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
                    <span x-text="Math.min(currentPage * itemsPerPage, filteredBlogs.length)"></span> 
                    of <span x-text="filteredBlogs.length"></span>
                </div>
            </div>
        </div>

        <!-- Blog Form Modal (New/Edit) -->
        <div x-show="showBlogFormModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="closeBlogFormModal()">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-2xl w-full p-6 transform transition-all max-h-[90vh] overflow-y-auto"
                 @click.stop>
                
                <div class="flex justify-between items-start mb-4">
                    <h3 class="text-xl font-bold text-[#1e3c5c]" x-text="formMode === 'new' ? 'Create New Blog' : 'Edit Blog'"></h3>
                    <button @click="closeBlogFormModal()" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <form @submit.prevent="saveBlog()" class="space-y-4">
                    <!-- Blog Prefix - Always Read-only (not editable) -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Blog Prefix</label>
                        <input type="text" 
                               x-model="formData.blogPrefix"
                               readonly
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm bg-gray-100 cursor-not-allowed">
                    </div>

                    <!-- Title -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Title *</label>
                        <input type="text" 
                               x-model="formData.title"
                               required
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                    </div>

                    <!-- Description -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Description *</label>
                        <textarea x-model="formData.description"
                                  required
                                  rows="4"
                                  class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]"></textarea>
                    </div>

                    <!-- Category (using categoryId) -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Category *</label>
                        <select x-model="formData.categoryId"
                                required
                                class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="">Select Category</option>
                            <template x-for="category in categories" :key="category.id">
                                <option :value="category.id" x-text="category.name"></option>
                            </template>
                        </select>
                    </div>

                    <!-- Images Upload -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Images</label>
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
                            <p class="text-sm text-[#3a5a78]">Click to upload images</p>
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

                    <!-- Link -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Link</label>
                        <input type="url" 
                               x-model="formData.link"
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]"
                               placeholder="https://example.com/blog">
                    </div>

                    <!-- Blog Date -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Blog Date *</label>
                        <input type="date" 
                               x-model="formData.blogDate"
                               required
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                    </div>

                    <!-- Status (Visible/Hidden) - using boolean -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Status</label>
                        <select x-model="formData.status"
                                class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                            <option value="true">Visible</option>
                            <option value="false">Hidden</option>
                        </select>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex justify-end gap-2 pt-4">
                        <button type="button" @click="closeBlogFormModal()" 
                                class="px-4 py-2 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                            Cancel
                        </button>
                        <button type="submit" :disabled="saving"
                                class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium disabled:opacity-50 disabled:cursor-not-allowed">
                            <span x-show="!saving" x-text="formMode === 'new' ? 'Create Blog' : 'Update Blog'"></span>
                            <span x-show="saving">Saving...</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- View Blog Modal (Read Only) -->
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
                    <h3 class="text-xl font-bold text-[#1e3c5c]">Blog Details</h3>
                    <button @click="showViewModal = false" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <div class="space-y-4" x-show="selectedBlog">
                    <!-- Blog Prefix -->
                    <div class="grid grid-cols-2 gap-4">
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Blog Prefix</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedBlog?.blogPrefix"></p>
                        </div>
                        
                        <!-- Title -->
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Title</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedBlog?.title"></p>
                        </div>
                        
                        <!-- Description -->
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Description</p>
                            <p class="text-[#1e3c5c] bg-[#f0f7fa] p-3 rounded-lg whitespace-pre-wrap" x-text="selectedBlog?.description"></p>
                        </div>
                        
                        <!-- Category and Status -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Category</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="selectedBlog?.categoryName || selectedBlog?.category"></p>
                        </div>
                        <div>
                            <p class="text-sm text-[#3a5a78]">Status</p>
                            <p class="font-medium" :class="selectedBlog?.status === true ? 'text-[#0284a8]' : 'text-[#d4a373]'">
                                <span x-text="selectedBlog?.status === true ? 'Visible' : 'Hidden'"></span>
                            </p>
                        </div>
                        
                        <!-- Images Gallery -->
                        <div class="col-span-2" x-show="selectedBlog?.images && selectedBlog.images.length > 0">
                            <p class="text-sm text-[#3a5a78] mb-2">Images</p>
                            <div class="gallery-container">
                                <img :src="selectedBlog.images[currentImageIndex]" class="gallery-image" 
                                     onerror="this.src='https://via.placeholder.com/800x400?text=No+Image'">
                                
                                <!-- Navigation -->
                                <button class="gallery-nav prev" @click="prevImage" x-show="selectedBlog.images.length > 1">
                                    ←
                                </button>
                                <button class="gallery-nav next" @click="nextImage" x-show="selectedBlog.images.length > 1">
                                    →
                                </button>
                                
                                <!-- Dots -->
                                <div class="gallery-dots" x-show="selectedBlog.images.length > 1">
                                    <template x-for="(_, index) in selectedBlog.images" :key="index">
                                        <div class="gallery-dot" :class="{ 'active': currentImageIndex === index }" 
                                             @click="currentImageIndex = index"></div>
                                    </template>
                                </div>
                            </div>
                        </div>
                        
                        <!-- No Images -->
                        <div class="col-span-2" x-show="!selectedBlog?.images || selectedBlog.images.length === 0">
                            <p class="text-sm text-[#3a5a78] mb-2">Images</p>
                            <div class="bg-[#f0f7fa] p-4 rounded-lg text-center text-[#3a5a78]">
                                No images uploaded
                            </div>
                        </div>
                        
                        <!-- Link -->
                        <div class="col-span-2">
                            <p class="text-sm text-[#3a5a78]">Link</p>
                            <template x-if="selectedBlog?.link">
                                <a :href="selectedBlog.link" target="_blank" class="text-[#0284a8] hover:underline" x-text="selectedBlog.link"></a>
                            </template>
                            <template x-if="!selectedBlog?.link">
                                <span class="text-[#3a5a78]">No link provided</span>
                            </template>
                        </div>
                        
                        <!-- Dates -->
                        <div>
                            <p class="text-sm text-[#3a5a78]">Blog Date</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="formatDate(selectedBlog?.blogDate)"></p>
                        </div>
                        <div>
                            <p class="text-sm text-[#3a5a78]">Posted Date</p>
                            <p class="font-medium text-[#1e3c5c]" x-text="formatDate(selectedBlog?.postedDate)"></p>
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
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Delete Blog</h3>
                <p class="text-[#3a5a78] text-center mb-6">
                    Are you sure you want to delete blog "<span class="font-semibold" x-text="selectedBlog?.title"></span>"? This action cannot be undone.
                </p>
                
                <div class="flex gap-3">
                    <button @click="showDeleteModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                    <button @click="deleteBlog()" :disabled="deleting"
                            class="flex-1 px-4 py-2.5 rounded-lg bg-red-500 text-white hover:bg-red-600 transition text-sm font-medium disabled:opacity-50 disabled:cursor-not-allowed">
                        <span x-show="!deleting">Delete</span>
                        <span x-show="deleting">Deleting...</span>
                    </button>
                </div>
            </div>
        </div>

    </main>

    <script>
        function blogManager() {
            return {
                // State variables
                blogs: [],
                categories: [],
                loading: false,
                saving: false,
                deleting: false,
                
                searchQuery: '',
                statusFilter: 'all',
                categoryFilter: 'all',
                blogDateFilter: '',
                monthFilter: 'all',
                yearFilter: 'all',
                dateFilter: '',
                
                currentPage: 1,
                itemsPerPage: 10,
                
                // Modal properties
                showBlogFormModal: false,
                showViewModal: false,
                showDeleteModal: false,
                
                selectedBlog: null,
                formMode: 'new', // 'new' or 'edit'
                currentImageIndex: 0,
                
                formData: {
                    id: null,
                    blogPrefix: '',
                    title: '',
                    description: '',
                    categoryId: '',
                    images: [],
                    link: '',
                    blogDate: '',
                    status: 'true' // string for select
                },
                
                // Initialize
                init: function() {
                    var self = this;
                    
                    // Reset to first page when filters change
                    this.$watch('filteredBlogs', function() {
                        self.currentPage = 1;
                    });
                    
                    // Load categories first, then blogs
                    this.loadCategories();
                },
                
                // Load categories from server
                loadCategories: function() {
                    var self = this;
                    fetch('${pageContext.request.contextPath}/blogcategory/api/list')
                        .then(response => response.json())
                        .then(data => {
                            self.categories = data;
                            self.loadBlogs();
                        })
                        .catch(error => {
                            console.error('Error loading categories:', error);
                            if (window.showError) {
                                window.showError('Failed to load categories', 3000);
                            }
                            self.loadBlogs(); // Still try to load blogs
                        });
                },
                
                // Load blogs from server
                loadBlogs: function() {
                    var self = this;
                    this.loading = true;
                    
                    fetch('${pageContext.request.contextPath}/manageblogs/api/list')
                        .then(response => response.json())
                        .then(data => {
                            self.blogs = data;
                            self.loading = false;
                        })
                        .catch(error => {
                            console.error('Error loading blogs:', error);
                            if (window.showError) {
                                window.showError('Failed to load blogs', 3000);
                            }
                            self.loading = false;
                        });
                },
                
                // Get available years from blog data (for dynamic year filter)
                get availableYears() {
                    var years = new Set();
                    this.blogs.forEach(function(blog) {
                        if (blog.blogDate) {
                            var year = new Date(blog.postedDate).getFullYear();
                            if (!isNaN(year)) {
                                years.add(year.toString());
                            }
                        }
                    });
                    return Array.from(years).sort().reverse(); // Sort descending (newest first)
                },
                
                // Search blogs
                searchBlogs: function() {
                    var self = this;
                    if (!this.searchQuery) {
                        this.loadBlogs();
                        return;
                    }
                    
                    this.loading = true;
                    fetch('${pageContext.request.contextPath}/manageblogs/api/search?q=' + encodeURIComponent(this.searchQuery))
                        .then(response => response.json())
                        .then(data => {
                            self.blogs = data;
                            self.loading = false;
                        })
                        .catch(error => {
                            console.error('Error searching blogs:', error);
                            if (window.showError) {
                                window.showError('Search failed', 3000);
                            }
                            self.loading = false;
                        });
                },
                
                // Get category counts for dropdown
                getCategoryCounts: function() {
                    var counts = {};
                    this.blogs.forEach(function(blog) {
                        var catName = blog.categoryName || blog.category;
                        if (counts[catName]) {
                            counts[catName]++;
                        } else {
                            counts[catName] = 1;
                        }
                    });
                    
                    // Convert to array and sort by count
                    var result = [];
                    for (var cat in counts) {
                        result.push({
                            name: cat,
                            count: counts[cat]
                        });
                    }
                    return result.sort(function(a, b) { return b.count - a.count; });
                },
                
                get filteredBlogs() {
                    var self = this;
                    return this.blogs.filter(function(blog) {
                        // Search filter (already applied via API)
                        
                        // Status filter - convert to boolean comparison
                        if (self.statusFilter !== 'all') {
                            var statusBool = self.statusFilter === 'visible' ? true : false;
                            if (blog.status !== statusBool) return false;
                        }
                        
                        // Category filter
                        if (self.categoryFilter !== 'all') {
                            var catName = blog.categoryName || blog.category;
                            if (catName !== self.categoryFilter) return false;
                        }
                        
                        // Blog date filter
                        if (self.blogDateFilter && blog.blogDate !== self.blogDateFilter) {
                            return false;
                        }
                        
                        // Date filters
                        if (blog.blogDate) {
                            var blogDate = new Date(blog.blogDate);
                            
                            // Month filter
                            if (self.monthFilter !== 'all') {
                                var month = (blogDate.getMonth() + 1).toString();
                                if (month.length === 1) month = '0' + month;
                                if (month !== self.monthFilter) return false;
                            }
                            
                            // Year filter (dynamic)
                            if (self.yearFilter !== 'all') {
                                var year = blogDate.getFullYear().toString();
                                if (year !== self.yearFilter) return false;
                            }
                        }
                        
                        // Specific date filter
                        if (self.dateFilter && blog.blogDate !== self.dateFilter) {
                            return false;
                        }
                        
                        return true;
                    });
                },
                
                get paginatedBlogs() {
                    var start = (this.currentPage - 1) * this.itemsPerPage;
                    var end = start + this.itemsPerPage;
                    return this.filteredBlogs.slice(start, end);
                },
                
                get totalPages() {
                    return Math.ceil(this.filteredBlogs.length / this.itemsPerPage);
                },
                
                // Count methods
                getVisibleCount: function() {
                    return this.blogs.filter(function(b) { return b.status === true; }).length;
                },
                
                getHiddenCount: function() {
                    return this.blogs.filter(function(b) { return b.status === false; }).length;
                },
                
                getCategoriesCount: function() {
                    var categories = {};
                    this.blogs.forEach(function(blog) {
                        var catName = blog.categoryName || blog.category;
                        categories[catName] = true;
                    });
                    return Object.keys(categories).length;
                },
                
                formatDate: function(dateString) {
                    if (!dateString) return '';
                    var options = { year: 'numeric', month: 'short', day: 'numeric' };
                    return new Date(dateString).toLocaleDateString('en-US', options);
                },
                
                // Get next blog prefix from server
                getNextBlogPrefix: function() {
                    var self = this;
                    fetch('${pageContext.request.contextPath}/manageblogs/api/next-prefix')
                        .then(response => response.json())
                        .then(data => {
                            self.formData.blogPrefix = data.prefix;
                        })
                        .catch(error => {
                            console.error('Error getting next prefix:', error);
                            // Fallback to client-side generation
                            var lastId = this.blogs.length > 0 ? Math.max.apply(Math, this.blogs.map(function(b) { return b.id; })) : 0;
                            var newId = lastId + 1;
                            this.formData.blogPrefix = 'B-' + newId.toString().padStart(5, '0');
                        });
                },
                
                // Handle image upload
                handleImageUpload: function(event) {
                    var files = event.target.files;
                    var self = this;
                    var formData = new FormData();
                    
                    for (var i = 0; i < files.length; i++) {
                        formData.append('images', files[i]);
                    }
                    
                    // Show uploading indicator
                    if (window.showInfo) {
                        window.showInfo('Uploading images...', 2000);
                    }
                    
                    fetch('${pageContext.request.contextPath}/manageblogs/api/upload', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Add uploaded image URLs to formData.images
                            data.images.forEach(function(imageUrl) {
                                self.formData.images.push(imageUrl);
                            });
                            if (window.showSuccess) {
                                window.showSuccess('Images uploaded successfully', 3000);
                            }
                        } else {
                            if (window.showError) {
                                window.showError(data.error || 'Upload failed', 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error uploading images:', error);
                        if (window.showError) {
                            window.showError('Image upload failed', 3000);
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
                        blogPrefix: '',
                        title: '',
                        description: '',
                        categoryId: '',
                        images: [],
                        link: '',
                        blogDate: '',
                        status: 'true'
                    };
                },
                
                // Open new blog modal
                openNewBlogModal: function() {
                    this.resetFormData();
                    this.formMode = 'new';
                    this.getNextBlogPrefix(); // Get next prefix from server
                    this.showBlogFormModal = true;
                },
                
                // Edit blog
                editBlog: function(blog) {
                    this.formData = {
                        id: blog.id,
                        blogPrefix: blog.blogPrefix,
                        title: blog.title,
                        description: blog.description,
                        categoryId: blog.categoryId || '',
                        images: blog.images ? [...blog.images] : [],
                        link: blog.link || '',
                        blogDate: blog.blogDate,
                        status: blog.status ? 'true' : 'false' // Convert boolean to string for select
                    };
                    this.formMode = 'edit';
                    this.showBlogFormModal = true;
                },
                
                // Close blog form modal
                closeBlogFormModal: function() {
                    this.showBlogFormModal = false;
                    this.resetFormData();
                },
                
                // Save blog (new or edit)
                saveBlog: function() {
                    var self = this;
                    this.saving = true;
                    
                    // Convert status string to boolean
                    var blogData = {
                        id: this.formData.id,
                        blogPrefix: this.formData.blogPrefix,
                        title: this.formData.title,
                        description: this.formData.description,
                        categoryId: parseInt(this.formData.categoryId),
                        images: this.formData.images,
                        link: this.formData.link || '',
                        blogDate: this.formData.blogDate,
                        status: this.formData.status === 'true'
                    };
                    
                    var url = this.formMode === 'new' 
                        ? '${pageContext.request.contextPath}/manageblogs/api/create'
                        : '${pageContext.request.contextPath}/manageblogs/api/' + this.formData.id;
                    
                    var method = this.formMode === 'new' ? 'POST' : 'PUT';
                    
                    fetch(url, {
                        method: method,
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(blogData)
                    })
                    .then(response => response.json())
                    .then(data => {
                        self.saving = false;
                        if (data.success) {
                            if (window.showSuccess) {
                                window.showSuccess(data.message, 3000);
                            }
                            self.closeBlogFormModal();
                            self.loadBlogs(); // Reload blogs
                        } else {
                            if (window.showError) {
                                window.showError(data.message || 'Operation failed', 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error saving blog:', error);
                        self.saving = false;
                        if (window.showError) {
                            window.showError('Failed to save blog', 3000);
                        }
                    });
                },
                
                // View blog details
                viewBlog: function(blog) {
                    this.selectedBlog = blog;
                    this.currentImageIndex = 0;
                    this.showViewModal = true;
                },
                
                // Image navigation
                prevImage: function() {
                    if (this.currentImageIndex > 0) {
                        this.currentImageIndex--;
                    } else {
                        this.currentImageIndex = this.selectedBlog.images.length - 1;
                    }
                },
                
                nextImage: function() {
                    if (this.currentImageIndex < this.selectedBlog.images.length - 1) {
                        this.currentImageIndex++;
                    } else {
                        this.currentImageIndex = 0;
                    }
                },
                
                // Confirm delete
                confirmDelete: function(blog) {
                    this.selectedBlog = blog;
                    this.showDeleteModal = true;
                },
                
                // Delete blog
                deleteBlog: function() {
                    var self = this;
                    this.deleting = true;
                    
                    fetch('${pageContext.request.contextPath}/manageblogs/api/' + this.selectedBlog.id, {
                        method: 'DELETE'
                    })
                    .then(response => response.json())
                    .then(data => {
                        self.deleting = false;
                        if (data.success) {
                            if (window.showSuccess) {
                                window.showSuccess(data.message || 'Blog deleted successfully', 3000);
                            }
                            self.showDeleteModal = false;
                            self.selectedBlog = null;
                            self.loadBlogs(); // Reload blogs
                            
                            // Adjust current page if necessary
                            if (self.paginatedBlogs.length === 0 && self.currentPage > 1) {
                                self.currentPage--;
                            }
                        } else {
                            if (window.showError) {
                                window.showError(data.message || 'Delete failed', 3000);
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error deleting blog:', error);
                        self.deleting = false;
                        if (window.showError) {
                            window.showError('Failed to delete blog', 3000);
                        }
                    });
                },
                
                clearFilters: function() {
                    this.searchQuery = '';
                    this.statusFilter = 'all';
                    this.categoryFilter = 'all';
                    this.blogDateFilter = '';
                    this.monthFilter = 'all';
                    this.yearFilter = 'all';
                    this.dateFilter = '';
                    this.currentPage = 1;
                    
                    this.loadBlogs(); // Reload blogs
                    
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