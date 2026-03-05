<%-- 
    Document   : blogcategory
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · Manage Blog Categories</title>
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
            text-align: left;
        }
        td {
            padding: 1rem 0.75rem;
            border-bottom: 1px solid #e2e8f0;
            vertical-align: middle;
            text-align: left;
        }
        tr:last-child td {
            border-bottom: none;
        }
        tr:hover td {
            background-color: #f8fafc;
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
        /* Category badge styling */
        .category-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
            text-align: center;
            white-space: nowrap;
            background-color: #f0f7fa;
            color: #0284a8;
            border: 1px solid #b5e5e0;
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
        /* Search input */
        .search-input {
            padding-left: 2.5rem;
        }
        /* Actions cell alignment */
        .actions-cell {
            display: flex;
            align-items: center;
            gap: 0.25rem;
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
    <main class="flex-1 overflow-y-auto" x-data="blogCategoryManager()" x-init="init()">
        <!-- top bar -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#b5e5e0] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">📚</span>
                <span class="font-semibold">Blog & Gallery Category Management</span>
            </div>
            <div class="flex items-center gap-3">
                <span class="bg-[#0284a8] text-white text-xs px-3 py-1.5 rounded-full" x-text="`${categories.length} categories`"></span>
            </div>
        </header>

        <!-- dashboard content -->
        <div class="p-4 md:p-6 lg:p-8 space-y-6 max-w-full">

            <!-- Header with title and new category button -->
            <div class="flex justify-between items-center">
                <div>
                    <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Manage Blog & Gallery Categories 📚</h2>
                    <p class="text-[#3a5a78] text-base mt-1">Add, edit and manage Blog & Gallery post categories</p>
                </div>
                <button @click="openNewCategoryModal()" 
                        class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Add Category
                </button>
            </div>

            <!-- Loading Indicator -->
            <div x-show="loading" class="text-center py-4">
                <div class="loading-spinner"></div>
                <p class="text-[#3a5a78] mt-2">Loading categories...</p>
            </div>

            <template x-if="!loading">
                <div>
                    <!-- Statistics Cards -->
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <!-- Total Categories -->
                        <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                            <div class="flex items-center justify-between">
                                <div>
                                    <p class="text-[#3a5a78] text-sm font-medium">Total Categories</p>
                                    <p class="text-3xl font-bold text-[#1e3c5c]" x-text="categories.length"></p>
                                </div>
                                <div class="w-12 h-12 rounded-full bg-[#b5e5e0]/30 flex items-center justify-center">
                                    <span class="text-2xl">📚</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Latest Category -->
                        <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                            <div class="flex items-center justify-between">
                                <div class="truncate">
                                    <p class="text-[#3a5a78] text-sm font-medium">Recently Added</p>
                                    <p class="text-lg font-bold text-[#1e3c5c] truncate" x-text="getLatestCategory()"></p>
                                </div>
                                <div class="w-12 h-12 rounded-full bg-[#9ac9c2] flex items-center justify-center">
                                    <span class="text-2xl">🆕</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Search Section -->
                    <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] p-4 md:p-6">
                        <!-- Search Bar -->
                        <div class="relative">
                            <input type="text" 
                                   x-model="searchQuery"
                                   @input.debounce.300ms="searchCategories()"
                                   placeholder="Search by category name..." 
                                   class="w-full pl-10 pr-4 py-3 rounded-xl border border-[#b5e5e0] focus:outline-none focus:ring-2 focus:ring-[#0284a8] focus:border-transparent text-sm">
                            <span class="absolute left-3 top-3.5 text-[#3a5a78] text-lg">🔍</span>
                        </div>

                        <!-- Filter Actions -->
                        <div class="flex flex-wrap justify-end gap-2 pt-4">
                            <button @click="clearSearch()" class="px-4 py-2 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                                Clear Search
                            </button>
                            <button @click="loadCategories()" class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                                Refresh
                            </button>
                        </div>
                    </div>

                    <!-- Categories Table -->
                    <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] overflow-hidden">
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th class="w-1/2">Category Name</th>
                                        <th class="w-1/3">Created Date</th>
                                        <th class="w-1/6">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <template x-for="category in paginatedCategories" :key="category.id">
                                        <tr>
                                            <!-- Category Name -->
                                            <td>
                                                <span class="category-badge">
                                                    <span x-text="category.name"></span>
                                                </span>
                                            </td>
                                            
                                            <!-- Created Date -->
                                            <td>
                                                <div class="text-sm text-[#3a5a78]" x-text="formatDate(category.createdDate)"></div>
                                            </td>
                                            
                                            <!-- Actions -->
                                            <td>
                                                <div class="actions-cell">
                                                    <!-- Edit Category -->
                                                    <button @click="editCategory(category)" 
                                                            class="action-btn w-7 h-7 bg-yellow-100 text-yellow-600 hover:bg-yellow-200"
                                                            title="Edit Category">
                                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                                        </svg>
                                                    </button>
                                                    
                                                    <!-- Delete Category -->
                                                    <button @click="confirmDelete(category)" 
                                                            class="action-btn w-7 h-7 bg-red-100 text-red-500 hover:bg-red-200"
                                                            title="Delete Category">
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
                    <div x-show="filteredCategories.length === 0" class="text-center py-12">
                        <span class="text-5xl mb-3 block">📚</span>
                        <p class="text-lg text-[#3a5a78]">No categories found</p>
                        <button @click="clearSearch()" class="mt-4 px-6 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                            Clear Search
                        </button>
                    </div>

                    <!-- Pagination with Items Per Page Selector -->
                    <div x-show="filteredCategories.length > 0" class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-6">
                        <div class="flex items-center gap-2">
                            <span class="text-sm text-[#3a5a78]">Show:</span>
                            <select x-model="itemsPerPage" @change="currentPage = 1" 
                                    class="border border-[#b5e5e0] rounded-lg px-3 py-1.5 text-sm text-[#1e3c5c] focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                                <option value="5">5 / page</option>
                                <option value="10">10 / page</option>
                                <option value="20">20 / page</option>
                                <option value="50">50 / page</option>
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
                            <span x-text="Math.min(currentPage * itemsPerPage, filteredCategories.length)"></span> 
                            of <span x-text="filteredCategories.length"></span>
                        </div>
                    </div>
                </div>
            </template>
        </div>

        <!-- Category Form Modal (New/Edit) -->
        <div x-show="showCategoryFormModal" 
             class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-overlay"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0"
             @click.away="closeCategoryFormModal()">
            
            <div class="bg-white rounded-2xl shadow-xl max-w-md w-full p-6 transform transition-all"
                 @click.stop>
                
                <div class="flex justify-between items-start mb-4">
                    <h3 class="text-xl font-bold text-[#1e3c5c]" x-text="formMode === 'new' ? 'Add New Category' : 'Edit Category'"></h3>
                    <button @click="closeCategoryFormModal()" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                <form @submit.prevent="saveCategory()" class="space-y-4">
                    <!-- Category Name -->
                    <div>
                        <label class="block text-sm font-medium text-[#1e3c5c] mb-1">Category Name *</label>
                        <input type="text" 
                               x-model="formData.name"
                               @input="checkNameExists"
                               required
                               placeholder="e.g., Travel Tips, Resort News, Wellness"
                               class="w-full border border-[#b5e5e0] rounded-xl px-3 py-2.5 text-[#1e3c5c] text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8]">
                        <p class="text-xs text-[#3a5a78] mt-1" x-show="nameExists" x-text="nameExistsMessage"></p>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex justify-end gap-2 pt-4">
                        <button type="button" @click="closeCategoryFormModal()" 
                                class="px-4 py-2 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                            Cancel
                        </button>
                        <button type="submit" 
                                :disabled="saving || nameExists"
                                class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium disabled:opacity-50 disabled:cursor-not-allowed">
                            <span x-show="!saving" x-text="formMode === 'new' ? 'Add Category' : 'Update Category'"></span>
                            <span x-show="saving">Saving...</span>
                        </button>
                    </div>
                </form>
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
                
                <h3 class="text-xl font-bold text-[#1e3c5c] text-center mb-2">Delete Category</h3>
                <p class="text-[#3a5a78] text-center mb-6">
                    Are you sure you want to delete category "<span class="font-semibold" x-text="selectedCategory?.name"></span>"? This action cannot be undone.
                </p>
                
                <div class="flex gap-3">
                    <button @click="showDeleteModal = false" 
                            class="flex-1 px-4 py-2.5 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                        Cancel
                    </button>
                    <button @click="deleteCategory()" 
                            :disabled="deleting"
                            class="flex-1 px-4 py-2.5 rounded-lg bg-red-500 text-white hover:bg-red-600 transition text-sm font-medium disabled:opacity-50 disabled:cursor-not-allowed">
                        <span x-show="!deleting">Delete</span>
                        <span x-show="deleting">Deleting...</span>
                    </button>
                </div>
            </div>
        </div>

    </main>

    <script>
        function blogCategoryManager() {
            return {
                // State
                categories: [],
                originalCategories: [],
                searchQuery: '',
                loading: true,
                saving: false,
                deleting: false,
                
                currentPage: 1,
                itemsPerPage: 10,
                
                // Modal properties
                showCategoryFormModal: false,
                showDeleteModal: false,
                
                selectedCategory: null,
                formMode: 'new', // 'new' or 'edit'
                
                formData: {
                    id: null,
                    name: ''
                },
                
                nameExists: false,
                nameExistsMessage: '',
                
                // Computed properties
                get filteredCategories() {
                    if (!this.searchQuery) {
                        return this.categories;
                    }
                    var query = this.searchQuery.toLowerCase();
                    return this.categories.filter(category => {
                        return category.name.toLowerCase().includes(query);
                    });
                },
                
                get paginatedCategories() {
                    var start = (this.currentPage - 1) * this.itemsPerPage;
                    var end = start + this.itemsPerPage;
                    return this.filteredCategories.slice(start, end);
                },
                
                get totalPages() {
                    return Math.ceil(this.filteredCategories.length / this.itemsPerPage);
                },
                
                // Helper methods
                getLatestCategory: function() {
                    if (this.categories.length === 0) return 'None';
                    // Sort by createdDate descending and get the latest
                    var sorted = [...this.categories].sort(function(a, b) {
                        return new Date(b.createdDate) - new Date(a.createdDate);
                    });
                    return sorted[0].name;
                },
                
                // Initialize
                init: function() {
                    var self = this;
                    
                    // Reset to first page when search changes
                    this.$watch('searchQuery', function() {
                        self.currentPage = 1;
                    });
                    
                    // Load categories
                    this.loadCategories();
                },
                
                // API Calls
                loadCategories: function() {
                    this.loading = true;
                    var self = this;
                    
                    fetch('${pageContext.request.contextPath}/blogcategory/api/list')
                        .then(response => response.json())
                        .then(data => {
                            self.categories = data;
                            self.originalCategories = [...data];
                            self.loading = false;
                        })
                        .catch(error => {
                            console.error('Error loading categories:', error);
                            if (window.showError) {
                                window.showError('Failed to load categories', 3000);
                            }
                            self.loading = false;
                        });
                },
                
                searchCategories: function() {
                    if (!this.searchQuery) {
                        this.categories = [...this.originalCategories];
                        return;
                    }
                    
                    var self = this;
                    fetch('${pageContext.request.contextPath}/blogcategory/api/search?q=' + encodeURIComponent(this.searchQuery))
                        .then(response => response.json())
                        .then(data => {
                            self.categories = data;
                        })
                        .catch(error => {
                            console.error('Error searching categories:', error);
                        });
                },
                
                checkNameExists: function() {
                    if (!this.formData.name || this.formData.name.length < 2) {
                        this.nameExists = false;
                        this.nameExistsMessage = '';
                        return;
                    }
                    
                    var self = this;
                    var url = '${pageContext.request.contextPath}/blogcategory/api/exists?name=' + encodeURIComponent(this.formData.name);
                    if (this.formMode === 'edit' && this.formData.id) {
                        url += '&excludeId=' + this.formData.id;
                    }
                    
                    fetch(url)
                        .then(response => response.json())
                        .then(data => {
                            self.nameExists = data.exists;
                            if (data.exists) {
                                self.nameExistsMessage = 'Category name already exists';
                            } else {
                                self.nameExistsMessage = '';
                            }
                        })
                        .catch(error => {
                            console.error('Error checking category name:', error);
                        });
                },
                
                formatDate: function(dateString) {
                    if (!dateString) return '';
                    var options = { year: 'numeric', month: 'short', day: 'numeric' };
                    return new Date(dateString).toLocaleDateString('en-US', options);
                },
                
                // Reset form data
                resetFormData: function() {
                    this.formData = {
                        id: null,
                        name: ''
                    };
                    this.nameExists = false;
                    this.nameExistsMessage = '';
                },
                
                // Open new category modal
                openNewCategoryModal: function() {
                    this.resetFormData();
                    this.formMode = 'new';
                    this.showCategoryFormModal = true;
                },
                
                // Edit category
                editCategory: function(category) {
                    this.formData = {
                        id: category.id,
                        name: category.name
                    };
                    this.formMode = 'edit';
                    this.showCategoryFormModal = true;
                    this.checkNameExists();
                },
                
                // Close category form modal
                closeCategoryFormModal: function() {
                    this.showCategoryFormModal = false;
                },
                
                // Save category (new or edit)
                saveCategory: function() {
                    if (this.nameExists) {
                        if (window.showError) {
                            window.showError('Category name already exists', 3000);
                        }
                        return;
                    }
                    
                    this.saving = true;
                    var self = this;
                    
                    var url = this.formMode === 'new' 
                        ? '${pageContext.request.contextPath}/blogcategory/api/create'
                        : '${pageContext.request.contextPath}/blogcategory/api/' + this.formData.id;
                    
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
                            self.loadCategories();
                            self.closeCategoryFormModal();
                        } else {
                            if (window.showError) {
                                window.showError(data.message, 3000);
                            }
                        }
                        self.saving = false;
                    })
                    .catch(error => {
                        console.error('Error saving category:', error);
                        if (window.showError) {
                            window.showError('Failed to save category', 3000);
                        }
                        self.saving = false;
                    });
                },
                
                // Confirm delete
                confirmDelete: function(category) {
                    this.selectedCategory = category;
                    this.showDeleteModal = true;
                },
                
                // Delete category
                deleteCategory: function() {
                    this.deleting = true;
                    var self = this;
                    
                    fetch('${pageContext.request.contextPath}/blogcategory/api/' + this.selectedCategory.id, {
                        method: 'DELETE'
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            if (window.showSuccess) {
                                window.showSuccess(data.message, 3000);
                            }
                            self.loadCategories();
                            
                            // Adjust current page if necessary
                            if (self.paginatedCategories.length === 0 && self.currentPage > 1) {
                                self.currentPage--;
                            }
                        } else {
                            if (window.showError) {
                                window.showError(data.message, 3000);
                            }
                        }
                        self.deleting = false;
                        self.showDeleteModal = false;
                        self.selectedCategory = null;
                    })
                    .catch(error => {
                        console.error('Error deleting category:', error);
                        if (window.showError) {
                            window.showError('Failed to delete category', 3000);
                        }
                        self.deleting = false;
                        self.showDeleteModal = false;
                    });
                },
                
                clearSearch: function() {
                    this.searchQuery = '';
                    this.categories = [...this.originalCategories];
                    this.currentPage = 1;
                    
                    if (window.showInfo) {
                        window.showInfo('Search cleared', 3000);
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