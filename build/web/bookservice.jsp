<%-- 
    Document   : bookservice
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book a Service · Ocean View Resort</title>
    <!-- Tailwind via CDN + Inter font -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <!-- Alpine.js for interactive components -->
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Flatpickr for date picker -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        
        /* Enhanced Service card styles */
        .service-card {
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid rgba(181, 229, 224, 0.3);
            border-radius: 1.5rem;
            overflow: hidden;
            background: white;
            height: 100%;
            display: flex;
            flex-direction: column;
            position: relative;
            box-shadow: 0 10px 30px -15px rgba(2, 132, 168, 0.2);
        }
        
        .service-card:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: 0 30px 40px -15px rgba(2, 132, 168, 0.4);
            border-color: #0284a8;
        }
        
        .service-image-wrapper {
            position: relative;
            overflow: hidden;
            height: 240px;
        }
        
        .service-image {
            height: 100%;
            width: 100%;
            object-fit: cover;
            transition: transform 0.8s ease;
        }
        
        .service-card:hover .service-image {
            transform: scale(1.1);
        }
        
        /* Image overlay gradient */
        .image-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 70px;
            background: linear-gradient(to top, rgba(0,0,0,0.6), transparent);
            z-index: 1;
        }
        
        /* Floating badges */
        .service-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(5px);
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            color: #0284a8;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            z-index: 2;
            border: 1px solid rgba(2, 132, 168, 0.3);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .service-badge i {
            font-size: 0.875rem;
            color: #d4a373;
        }
        
        .image-counter {
            position: absolute;
            bottom: 15px;
            right: 15px;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(5px);
            color: white;
            padding: 0.35rem 0.9rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            z-index: 2;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border: 1px solid rgba(255,255,255,0.2);
        }
        
        .image-counter i {
            font-size: 0.7rem;
            color: #b5e5e0;
        }
        
        /* Navigation dots */
        .nav-dots {
            position: absolute;
            bottom: 15px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 0.5rem;
            z-index: 2;
        }
        
        .nav-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.5);
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .nav-dot.active {
            background: #0284a8;
            transform: scale(1.3);
            box-shadow: 0 0 10px rgba(2, 132, 168, 0.5);
        }
        
        .nav-dot:hover {
            background: white;
            transform: scale(1.2);
        }
        
        /* Navigation arrows */
        .nav-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(5px);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid rgba(2, 132, 168, 0.2);
            color: #0284a8;
            font-size: 1rem;
            z-index: 3;
            opacity: 0;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        
        .service-image-wrapper:hover .nav-arrow {
            opacity: 1;
        }
        
        .nav-arrow:hover {
            background: #0284a8;
            color: white;
            transform: translateY(-50%) scale(1.1);
            border-color: #0284a8;
        }
        
        .nav-arrow.prev {
            left: 10px;
        }
        
        .nav-arrow.next {
            right: 10px;
        }
        
        /* Card content */
        .card-content {
            padding: 1.5rem;
            flex: 1;
            display: flex;
            flex-direction: column;
            background: linear-gradient(to bottom, white, #fafeff);
        }
        
        .service-title {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.75rem;
        }
        
        .service-name {
            font-size: 1.4rem;
            font-weight: 800;
            color: #1e3c5c;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .service-name i {
            color: #d4a373;
            font-size: 1.2rem;
        }
        
        .category-badge-enhanced {
            padding: 0.4rem 1.2rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .category-badge-enhanced.spa {
            background: linear-gradient(135deg, #f3e5f5, #e1bee7);
            color: #6a1b9a;
        }
        
        .category-badge-enhanced.massage {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: #1e40af;
        }
        
        .category-badge-enhanced.ayurveda {
            background: linear-gradient(135deg, #dcfce7, #bbf7d0);
            color: #166534;
        }
        
        .category-badge-enhanced.beauty {
            background: linear-gradient(135deg, #fce7f3, #fbcfe8);
            color: #9d174d;
        }
        
        .category-badge-enhanced.yoga {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            color: #b85d1a;
        }
        
        .category-badge-enhanced.fitness {
            background: linear-gradient(135deg, #cffafe, #a5f3fc);
            color: #0891b2;
        }
        
        .service-description {
            color: #4a6572;
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 1.25rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
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
        
        /* Price and action */
        .info-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
            padding-top: 1.25rem;
            border-top: 2px dashed rgba(181, 229, 224, 0.5);
        }
        
        .price-info {
            display: flex;
            flex-direction: column;
        }
        
        .price-label {
            font-size: 0.7rem;
            color: #6b8da8;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .price-value {
            font-size: 1.8rem;
            font-weight: 800;
            color: #0284a8;
            line-height: 1.2;
            display: flex;
            align-items: baseline;
            gap: 0.25rem;
        }
        
        .price-value small {
            font-size: 0.9rem;
            font-weight: 600;
            color: #3a5a78;
        }
        
        .book-now-btn-enhanced {
            background: linear-gradient(135deg, #0284a8, #03738C);
            color: white;
            padding: 0.75rem 1.8rem;
            border-radius: 50px;
            font-size: 0.95rem;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            border: none;
            cursor: pointer;
            box-shadow: 0 8px 15px -5px rgba(2, 132, 168, 0.4);
            position: relative;
            overflow: hidden;
        }
        
        .book-now-btn-enhanced.disabled {
            background: linear-gradient(135deg, #94a3b8, #64748b);
            cursor: not-allowed;
            opacity: 0.7;
            box-shadow: none;
        }
        
        .book-now-btn-enhanced.disabled:hover {
            transform: none;
            box-shadow: none;
        }
        
        .book-now-btn-enhanced::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        
        .book-now-btn-enhanced:hover:not(.disabled) {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 15px 25px -8px rgba(2, 132, 168, 0.6);
            background: linear-gradient(135deg, #03738C, #025c73);
        }
        
        .book-now-btn-enhanced:hover:not(.disabled)::before {
            left: 100%;
        }
        
        .book-now-btn-enhanced i {
            font-size: 1rem;
            transition: transform 0.3s ease;
        }
        
        .book-now-btn-enhanced:hover:not(.disabled) i {
            transform: translateX(5px);
        }
        
        /* Enhanced filter section */
        .filter-section-enhanced {
            background: linear-gradient(135deg, white, #f8fafc);
            border-radius: 2rem;
            border: 1px solid rgba(181, 229, 224, 0.5);
            padding: 2rem;
            margin-bottom: 2.5rem;
            box-shadow: 0 20px 40px -15px rgba(2, 132, 168, 0.15);
        }
        
        .filter-title-enhanced {
            font-size: 0.9rem;
            font-weight: 700;
            color: #1e3c5c;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .filter-title-enhanced i {
            color: #d4a373;
        }
        
        .filter-select-enhanced {
            width: 100%;
            border: 2px solid #e2e8f0;
            border-radius: 1rem;
            padding: 0.75rem 1rem;
            color: #1e3c5c;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: white;
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%230284a8' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
        }
        
        .filter-select-enhanced:focus {
            outline: none;
            border-color: #0284a8;
            box-shadow: 0 0 0 4px rgba(2, 132, 168, 0.1);
        }
        
        .price-input-enhanced {
            border: 2px solid #e2e8f0;
            border-radius: 1rem;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .price-input-enhanced:focus {
            outline: none;
            border-color: #0284a8;
            box-shadow: 0 0 0 4px rgba(2, 132, 168, 0.1);
        }
        
        .clear-filters-btn {
            background: white;
            border: 2px solid #e2e8f0;
            color: #1e3c5c;
            padding: 0.75rem 1.5rem;
            border-radius: 1rem;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .clear-filters-btn:hover {
            background: #fee2e2;
            border-color: #ef4444;
            color: #dc2626;
        }
        
        /* User welcome bar */
        .user-welcome {
            background: linear-gradient(135deg, #0284a8, #03738C);
            border-radius: 2rem;
            padding: 1rem 2rem;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            box-shadow: 0 10px 25px -5px rgba(2, 132, 168, 0.4);
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .user-avatar {
            width: 50px;
            height: 50px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            border: 2px solid rgba(255,255,255,0.5);
        }
        
        .user-details h3 {
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 0.25rem;
        }
        
        .user-details p {
            font-size: 0.8rem;
            opacity: 0.9;
        }
        
        /* Pagination enhanced */
        .pagination-enhanced {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin-top: 3rem;
        }
        
        .pagination-btn {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            border: 2px solid #e2e8f0;
            background: white;
            color: #1e3c5c;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .pagination-btn:hover:not(:disabled) {
            background: #0284a8;
            border-color: #0284a8;
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -5px rgba(2, 132, 168, 0.4);
        }
        
        .pagination-btn.active {
            background: #0284a8;
            border-color: #0284a8;
            color: white;
        }
        
        .pagination-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        /* Loading skeleton enhanced */
        .skeleton-enhanced {
            background: linear-gradient(90deg, #f0f7fa 25%, #e2e8f0 50%, #f0f7fa 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
        }
        
        @keyframes loading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }

        /* Booking Modal Styles */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }
        
        .booking-modal {
            background: white;
            border-radius: 2rem;
            max-width: 1100px;
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
        
        .service-detail-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 1rem;
        }
        
        .booking-input {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 1rem;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }
        
        .booking-input:focus {
            outline: none;
            border-color: #0284a8;
            box-shadow: 0 0 0 4px rgba(2, 132, 168, 0.1);
        }
        
        .time-select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 1rem;
            font-size: 0.95rem;
            background: white;
            cursor: pointer;
        }
        
        .confirm-btn {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            flex: 1;
        }
        
        .confirm-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px -5px rgba(16, 185, 129, 0.4);
        }
        
        .cancel-btn {
            background: white;
            border: 2px solid #e2e8f0;
            color: #64748b;
            padding: 0.75rem 2rem;
            border-radius: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
            flex: 1;
        }
        
        .cancel-btn:hover {
            background: #f1f5f9;
            border-color: #94a3b8;
        }
    </style>
</head>
<body class="bg-[#f0f7fa] text-[#1e3c5c] antialiased" x-data="serviceBooking()" x-init="init()">

    <!-- Include Navbar -->
    <jsp:include page="component/navbar.jsp" />
    
    <jsp:include page="component/notification.jsp" />

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 mt-16">
        
        <!-- User Welcome Bar (shown when logged in) -->
        <div x-show="isLoggedIn" class="user-welcome">
            <div class="user-info">
                <div class="user-avatar">
                    <i class="fas fa-user-circle"></i>
                </div>
                <div class="user-details">
                    <h3 x-text="'Welcome back, ' + userName + '!'"></h3>
                    <p><i class="far fa-envelope"></i> <span x-text="userEmail"></span></p>
                </div>
            </div>
        </div>

        <!-- Page Header -->
        <div class="mb-8 text-center md:text-left">
            <h1 class="text-4xl md:text-5xl font-bold text-[#1e3c5c]">Book Your Service <span class="text-[#d4a373]">💆‍♀️</span></h1>
            <p class="text-[#3a5a78] mt-3 text-lg">Choose from our selection of spa and wellness services for ultimate relaxation</p>
        </div>

        <!-- Enhanced Filter Section -->
        <div class="filter-section-enhanced">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <!-- Category Filter -->
                <div>
                    <div class="filter-title-enhanced">
                        <i class="fas fa-tag"></i> Category
                    </div>
                    <select x-model="filters.categoryId" @change="applyFilters()" class="filter-select-enhanced">
                        <option value="all">All Categories</option>
                        <template x-for="category in categories" :key="category.id">
                            <option :value="category.id" x-text="category.name"></option>
                        </template>
                    </select>
                </div>

                <!-- Price Range Filter -->
                <div>
                    <div class="filter-title-enhanced">
                        <i class="fas fa-dollar-sign"></i> Price Range (LKR)
                    </div>
                    <div class="flex gap-2">
                        <input type="number" 
                               x-model="filters.minPrice"
                               @change="applyFilters()"
                               placeholder="Min"
                               class="price-input-enhanced"
                               min="0">
                        <input type="number" 
                               x-model="filters.maxPrice"
                               @change="applyFilters()"
                               placeholder="Max"
                               class="price-input-enhanced"
                               min="0">
                    </div>
                </div>

                <!-- Duration Filter -->
                <div>
                    <div class="filter-title-enhanced">
                        <i class="fas fa-clock"></i> Duration
                    </div>
                    <select x-model="filters.duration" @change="applyFilters()" class="filter-select-enhanced">
                        <option value="all">Any Duration</option>
                        <option value="30">30 min</option>
                        <option value="60">60 min</option>
                        <option value="90">90 min</option>
                        <option value="120">120 min</option>
                        <option value="0">Unlimited</option>
                    </select>
                </div>

                <!-- Sort By -->
                <div>
                    <div class="filter-title-enhanced">
                        <i class="fas fa-sort-amount-down"></i> Sort By
                    </div>
                    <select x-model="filters.sortBy" @change="applyFilters()" class="filter-select-enhanced">
                        <option value="recommended">Recommended</option>
                        <option value="price_low">Price: Low to High</option>
                        <option value="price_high">Price: High to Low</option>
                        <option value="duration_low">Duration: Short to Long</option>
                        <option value="duration_high">Duration: Long to Short</option>
                    </select>
                </div>
            </div>

            <!-- Active Filters Summary -->
            <div class="flex flex-wrap items-center justify-between mt-6 pt-4 border-t border-[#b5e5e0]">
                <div class="text-sm text-[#3a5a78] flex items-center gap-2">
                    <i class="fas fa-spa text-[#0284a8]"></i>
                    <span x-text="filteredServices.length + ' services available'"></span>
                    <span x-show="filters.categoryId !== 'all' || filters.minPrice || filters.maxPrice || filters.duration !== 'all'" 
                          class="text-xs bg-[#0284a8] text-white px-2 py-1 rounded-full">
                        Filtered
                    </span>
                </div>
                <button @click="clearFilters()" class="clear-filters-btn">
                    <i class="fas fa-times"></i> Clear Filters
                </button>
            </div>
        </div>

        <!-- Services Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <!-- Loading State -->
            <template x-if="loading">
                <template x-for="i in 6" :key="i">
                    <div class="service-card">
                        <div class="service-image-wrapper skeleton-enhanced"></div>
                        <div class="card-content space-y-3">
                            <div class="h-7 skeleton-enhanced rounded-full w-3/4"></div>
                            <div class="h-4 skeleton-enhanced rounded-full w-full"></div>
                            <div class="h-4 skeleton-enhanced rounded-full w-2/3"></div>
                            <div class="grid grid-cols-2 gap-2">
                                <div class="h-8 skeleton-enhanced rounded-lg"></div>
                                <div class="h-8 skeleton-enhanced rounded-lg"></div>
                            </div>
                            <div class="flex justify-between items-center pt-3">
                                <div class="h-10 skeleton-enhanced rounded-full w-24"></div>
                                <div class="h-12 skeleton-enhanced rounded-full w-28"></div>
                            </div>
                        </div>
                    </div>
                </template>
            </template>

            <!-- No Services Found -->
            <template x-if="!loading && filteredServices.length === 0">
                <div class="col-span-full">
                    <div class="no-services">
                        <span class="text-7xl mb-6 block">💆‍♀️</span>
                        <h3 class="text-3xl font-bold text-[#1e3c5c] mb-3">No Services Available</h3>
                        <p class="text-[#3a5a78] mb-6 text-lg">Try adjusting your filters to find the perfect service for your relaxation.</p>
                        <button @click="clearFilters()" 
                                class="px-8 py-4 bg-gradient-to-r from-[#0284a8] to-[#03738C] text-white rounded-full hover:shadow-xl transition-all transform hover:scale-105">
                            <i class="fas fa-redo-alt mr-2"></i> Clear Filters
                        </button>
                    </div>
                </div>
            </template>

            <!-- Service Cards -->
            <template x-if="!loading && filteredServices.length > 0">
                <template x-for="service in paginatedServices" :key="service.id">
                    <div class="service-card">
                        <!-- Image Gallery with Navigation -->
                        <div class="service-image-wrapper" x-data="{ currentImage: 0 }">
                            <img :src="service.images && service.images.length > 0 ? service.images[currentImage] : 'https://via.placeholder.com/600x400?text=Spa+Service'" 
                                 class="service-image"
                                 alt="Service">
                            
                            <!-- Gradient Overlay -->
                            <div class="image-overlay"></div>
                            
                            <!-- Service Badge -->
                            <div class="service-badge">
                                <i class="fas fa-spa"></i>
                                <span x-text="service.title"></span>
                            </div>
                            
                            <!-- Image Counter -->
                            <div x-show="service.images && service.images.length > 0" class="image-counter">
                                <i class="far fa-images"></i>
                                <span x-text="(currentImage + 1) + '/' + service.images.length"></span>
                            </div>
                            
                            <!-- Navigation Dots -->
                            <div x-show="service.images && service.images.length > 1" class="nav-dots">
                                <template x-for="(img, index) in service.images" :key="index">
                                    <button @click="currentImage = index" 
                                            class="nav-dot"
                                            :class="{ 'active': currentImage === index }">
                                    </button>
                                </template>
                            </div>
                            
                            <!-- Navigation Arrows -->
                            <button x-show="service.images && service.images.length > 1" 
                                    @click="currentImage = currentImage > 0 ? currentImage - 1 : service.images.length - 1"
                                    class="nav-arrow prev">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <button x-show="service.images && service.images.length > 1" 
                                    @click="currentImage = currentImage < service.images.length - 1 ? currentImage + 1 : 0"
                                    class="nav-arrow next">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>

                        <!-- Card Content -->
                        <div class="card-content">
                            <!-- Service Title and Category -->
                            <div class="service-title">
                                <div class="service-name">
                                    <i class="fas fa-spa"></i>
                                    <span x-text="service.title"></span>
                                </div>
                                <span class="category-badge-enhanced"
                                      :class="{
                                          'spa': service.categoryName === 'Spa & Wellness',
                                          'massage': service.categoryName === 'Massage Therapy',
                                          'ayurveda': service.categoryName === 'Ayurveda',
                                          'beauty': service.categoryName === 'Beauty Treatments',
                                          'yoga': service.categoryName === 'Yoga & Meditation',
                                          'fitness': service.categoryName === 'Fitness'
                                      }">
                                    <i class="fas fa-tag mr-1"></i>
                                    <span x-text="service.categoryName || 'Wellness'"></span>
                                </span>
                            </div>

                            <!-- Description -->
                            <p class="service-description" x-text="service.description || 'Experience ultimate relaxation with our premium wellness services.'"></p>

                            <!-- Duration and Price -->
                            <div class="info-section">
                                <div class="flex flex-col gap-2">
                                    <!-- Duration -->
                                    <div class="duration-pill">
                                        <i class="far fa-clock mr-1"></i>
                                        <template x-if="service.duration === 0">
                                            <span>Unlimited</span>
                                        </template>
                                        <template x-if="service.duration > 0">
                                            <span x-text="service.duration + ' min'"></span>
                                        </template>
                                    </div>
                                    
                                    <!-- Price -->
                                    <div class="price-info">
                                        <span class="price-label">Starting from</span>
                                        <div class="price-value">
                                            <template x-if="service.fees === 0">
                                                <span>Free</span>
                                            </template>
                                            <template x-if="service.fees > 0">
                                                <>
                                                    LKR <span x-text="formatPrice(service.fees)"></span>
                                                    <small></small>
                                                </>
                                            </template>
                                        </div>
                                    </div>
                                </div>
                                
                                <button @click="openBookingModal(service)" 
                                        class="book-now-btn-enhanced"
                                        :class="{ 'disabled': !isLoggedIn }">
                                    <span x-text="isLoggedIn ? 'Book Now' : 'Login to Book'"></span>
                                    <i class="fas" :class="isLoggedIn ? 'fa-arrow-right' : 'fa-lock'"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </template>
            </template>
        </div>

        <!-- Enhanced Pagination -->
        <div x-show="!loading && filteredServices.length > 0" class="flex flex-col items-center mt-12">
            <div class="text-sm text-[#3a5a78] mb-4">
                <i class="fas fa-spa mr-2"></i>
                <span x-text="'Showing ' + (((currentPage - 1) * itemsPerPage) + 1) + ' - ' + Math.min(currentPage * itemsPerPage, filteredServices.length) + ' of ' + filteredServices.length + ' services'"></span>
            </div>
            
            <div class="pagination-enhanced">
                <button @click="prevPage" :disabled="currentPage === 1" class="pagination-btn">
                    <i class="fas fa-chevron-left"></i>
                </button>
                <template x-for="page in totalPages" :key="page">
                    <button @click="goToPage(page)" 
                            class="pagination-btn"
                            :class="{ 'active': currentPage === page }">
                        <span x-text="page"></span>
                    </button>
                </template>
                <button @click="nextPage" :disabled="currentPage === totalPages || totalPages === 0" class="pagination-btn">
                    <i class="fas fa-chevron-right"></i>
                </button>
            </div>
        </div>

        <!-- Booking Modal -->
        <div x-show="showBookingModal" class="modal-overlay" x-cloak>
            <div class="booking-modal relative">
                <!-- Close Button -->
                <button @click="closeBookingModal()" class="modal-close">
                    <i class="fas fa-times"></i>
                </button>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 p-6">
                    <!-- Left Side - Service Details -->
                    <div class="space-y-4">
                        <h2 class="text-2xl font-bold text-[#1e3c5c] mb-4">Service Details</h2>
                        
                        <!-- Service Image -->
                        <div class="relative">
                            <img :src="selectedService?.images && selectedService?.images.length > 0 ? selectedService.images[0] : 'https://via.placeholder.com/600x400?text=Spa+Service'" 
                                 class="service-detail-image"
                                 alt="Selected Service">
                            <span class="absolute top-2 left-2 bg-[#0284a8] text-white px-3 py-1 rounded-full text-xs font-semibold">
                                <i class="fas fa-spa mr-1"></i>
                                <span x-text="selectedService?.title"></span>
                            </span>
                        </div>
                        
                        <!-- Service Info -->
                        <div class="bg-[#f8fafc] p-4 rounded-xl">
                            <div class="flex justify-between items-start mb-3">
                                <div>
                                    <h3 class="text-xl font-bold text-[#1e3c5c]" x-text="selectedService?.title"></h3>
                                    <p class="text-sm text-[#3a5a78]" x-text="selectedService?.description || 'No description available'"></p>
                                </div>
                                <span class="category-badge-enhanced"
                                      :class="{
                                          'spa': selectedService?.categoryName === 'Spa & Wellness',
                                          'massage': selectedService?.categoryName === 'Massage Therapy',
                                          'ayurveda': selectedService?.categoryName === 'Ayurveda',
                                          'beauty': selectedService?.categoryName === 'Beauty Treatments',
                                          'yoga': selectedService?.categoryName === 'Yoga & Meditation',
                                          'fitness': selectedService?.categoryName === 'Fitness'
                                      }">
                                    <span x-text="selectedService?.categoryName || 'Wellness'"></span>
                                </span>
                            </div>
                            
                            <div class="grid grid-cols-2 gap-3 mt-3">
                                <div class="flex items-center gap-2 text-sm">
                                    <i class="far fa-clock text-[#0284a8]"></i>
                                    <span>
                                        <template x-if="selectedService?.duration === 0">
                                            Unlimited
                                        </template>
                                        <template x-if="selectedService?.duration > 0">
                                            <span x-text="selectedService?.duration + ' minutes'"></span>
                                        </template>
                                    </span>
                                </div>
                                <div class="flex items-center gap-2 text-sm">
                                    <i class="fas fa-tag text-[#0284a8]"></i>
                                    <span>
                                        <template x-if="selectedService?.fees === 0">
                                            Free
                                        </template>
                                        <template x-if="selectedService?.fees > 0">
                                            LKR <span x-text="formatPrice(selectedService?.fees)"></span>
                                        </template>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Right Side - Booking Form -->
                    <div class="space-y-4">
                        <h2 class="text-2xl font-bold text-[#1e3c5c] mb-4">Booking Details</h2>
                        
                        <!-- Date Selection -->
                        <div>
                            <label class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                <i class="fas fa-calendar-alt mr-2 text-[#d4a373]"></i>Select Date
                            </label>
                            <div>
                                <input type="text" 
                                       x-ref="bookingDate"
                                       x-model="bookingDetails.date"
                                       placeholder="Select date"
                                       class="booking-input"
                                       readonly>
                            </div>
                        </div>
                        
                        <!-- Time Selection -->
                        <div>
                            <label class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                <i class="fas fa-clock mr-2 text-[#d4a373]"></i>Select Time
                            </label>
                            <select x-model="bookingDetails.time" class="time-select">
                                <option value="09:00">9:00 AM</option>
                                <option value="10:00">10:00 AM</option>
                                <option value="11:00">11:00 AM</option>
                                <option value="12:00">12:00 PM</option>
                                <option value="13:00">1:00 PM</option>
                                <option value="14:00">2:00 PM</option>
                                <option value="15:00">3:00 PM</option>
                                <option value="16:00">4:00 PM</option>
                                <option value="17:00">5:00 PM</option>
                            </select>
                        </div>
                        
                        <!-- Number of Persons -->
                        <div>
                            <label class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                <i class="fas fa-user-friends mr-2 text-[#d4a373]"></i>Number of Persons
                            </label>
                            <input type="number" 
                                   x-model="bookingDetails.persons"
                                   min="1"
                                   max="4"
                                   class="booking-input">
                            <p class="text-xs text-[#3a5a78] mt-1">
                                <i class="far fa-info-circle mr-1"></i>
                                Maximum 4 persons per booking
                            </p>
                        </div>
                        
                        <!-- Special Requests -->
                        <div>
                            <label class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                <i class="fas fa-comment mr-2 text-[#d4a373]"></i>Special Requests (Optional)
                            </label>
                            <textarea x-model="bookingDetails.specialRequests" 
                                      rows="3"
                                      placeholder="Any special requests? (e.g., allergies, preferences, etc.)"
                                      class="booking-input"></textarea>
                        </div>
                        
                        <!-- Total Price -->
                        <div class="bg-[#f0f7fa] p-4 rounded-xl border border-[#b5e5e0]">
                            <div class="flex justify-between items-center">
                                <span class="font-semibold text-[#1e3c5c]">Total Amount:</span>
                                <span class="text-2xl font-bold text-[#0284a8]">
                                    <template x-if="selectedService?.fees === 0">
                                        Free
                                    </template>
                                    <template x-if="selectedService?.fees > 0">
                                        LKR <span x-text="formatPrice(selectedService?.fees * bookingDetails.persons)"></span>
                                    </template>
                                </span>
                            </div>
                            <p class="text-xs text-[#3a5a78] mt-1">
                                <i class="far fa-info-circle mr-1"></i>
                                Price per person: 
                                <template x-if="selectedService?.fees === 0">
                                    Free
                                </template>
                                <template x-if="selectedService?.fees > 0">
                                    LKR <span x-text="formatPrice(selectedService?.fees)"></span>
                                </template>
                            </p>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="flex gap-3 pt-4">
                            <button @click="closeBookingModal()" class="cancel-btn">
                                <i class="fas fa-times mr-2"></i>Cancel
                            </button>
                            <button @click="confirmBooking()" class="confirm-btn">
                                <i class="fas fa-check-circle mr-2"></i>Confirm Booking
                            </button>
                        </div>
                        
                        <!-- Test Mode Notice -->
                        <div class="text-center mt-4">
                            <span class="inline-flex items-center gap-2 bg-yellow-100 text-yellow-800 text-xs px-3 py-1.5 rounded-full">
                                <i class="fas fa-flask"></i>
                                Test Mode - Frontend Demo Only
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Include Footer -->
    <jsp:include page="component/footer.jsp" />

    <script>
        function serviceBooking() {
            return {
                // User data from login
                isLoggedIn: false,
                userId: null,
                userName: '',
                userEmail: '',
                userRegNo: '',
                userType: '',
                authToken: '',
                
                // Data properties
                services: [],
                filteredServices: [],
                categories: [],
                loading: true,
                
                // Filters
                filters: {
                    categoryId: 'all',
                    minPrice: '',
                    maxPrice: '',
                    duration: 'all',
                    sortBy: 'recommended'
                },
                
                // Pagination
                currentPage: 1,
                itemsPerPage: 6,
                
                // Modal
                showBookingModal: false,
                selectedService: null,
                
                // Booking Details
                bookingDetails: {
                    date: '',
                    time: '10:00',
                    persons: 1,
                    specialRequests: ''
                },
                
                init() {
                    // Load user data from storage
                    this.loadUserData();
                    
                    this.loadCategories();
                    this.loadServices();
                    
                    // Reset to first page when filters change
                    this.$watch('filteredServices', () => {
                        this.currentPage = 1;
                    });
                },
                
                loadUserData() {
                    // Check localStorage first (persistent login)
                    this.authToken = localStorage.getItem('authToken') || sessionStorage.getItem('authToken');
                    this.userId = localStorage.getItem('userId') || sessionStorage.getItem('userId');
                    this.userName = localStorage.getItem('userName') || sessionStorage.getItem('userName');
                    this.userEmail = localStorage.getItem('userEmail') || sessionStorage.getItem('userEmail');
                    this.userRegNo = localStorage.getItem('userRegNo') || sessionStorage.getItem('userRegNo');
                    this.userType = localStorage.getItem('userType') || sessionStorage.getItem('userType');
                    
                    this.isLoggedIn = !!(this.authToken && this.userId);
                    
                    if (this.isLoggedIn) {
                        console.log('User logged in:', this.userName, 'Type:', this.userType);
                    }
                },
                
                loadCategories() {
                    fetch('${pageContext.request.contextPath}/servicecategory/api/list')
                        .then(response => response.json())
                        .then(data => {
                            this.categories = Array.isArray(data) ? data : [];
                        })
                        .catch(error => {
                            console.error('Error loading categories:', error);
                            this.categories = [];
                        });
                },
                
                loadServices() {
                    this.loading = true;
                    
                    fetch('${pageContext.request.contextPath}/manageservices/api/list')
                        .then(response => response.json())
                        .then(data => {
                            // Only show available services
                            this.services = Array.isArray(data) ? data.filter(service => service.status === 'available') : [];
                            this.applyFilters();
                            this.loading = false;
                        })
                        .catch(error => {
                            console.error('Error loading services:', error);
                            this.services = [];
                            this.filteredServices = [];
                            this.loading = false;
                            
                            if (window.showError) {
                                window.showError('Failed to load services', 3000);
                            }
                        });
                },
                
                applyFilters() {
                    let filtered = [...this.services];
                    
                    // Filter by category
                    if (this.filters.categoryId !== 'all') {
                        filtered = filtered.filter(service => service.categoryId == this.filters.categoryId);
                    }
                    
                    // Filter by price range
                    if (this.filters.minPrice) {
                        filtered = filtered.filter(service => service.fees >= parseFloat(this.filters.minPrice));
                    }
                    if (this.filters.maxPrice) {
                        filtered = filtered.filter(service => service.fees <= parseFloat(this.filters.maxPrice));
                    }
                    
                    // Filter by duration
                    if (this.filters.duration !== 'all') {
                        const durationValue = parseInt(this.filters.duration);
                        filtered = filtered.filter(service => service.duration === durationValue);
                    }
                    
                    // Apply sorting
                    switch(this.filters.sortBy) {
                        case 'price_low':
                            filtered.sort((a, b) => (a.fees || 0) - (b.fees || 0));
                            break;
                        case 'price_high':
                            filtered.sort((a, b) => (b.fees || 0) - (a.fees || 0));
                            break;
                        case 'duration_low':
                            filtered.sort((a, b) => (a.duration || 0) - (b.duration || 0));
                            break;
                        case 'duration_high':
                            filtered.sort((a, b) => (b.duration || 0) - (a.duration || 0));
                            break;
                        default:
                            // Recommended: sort by price (low to high) as default
                            filtered.sort((a, b) => (a.fees || 0) - (b.fees || 0));
                    }
                    
                    this.filteredServices = filtered;
                },
                
                clearFilters() {
                    this.filters = {
                        categoryId: 'all',
                        minPrice: '',
                        maxPrice: '',
                        duration: 'all',
                        sortBy: 'recommended'
                    };
                    this.applyFilters();
                    
                    if (window.showInfo) {
                        window.showInfo('Filters cleared', 2000);
                    }
                },
                
                // Pagination methods
                get paginatedServices() {
                    let start = (this.currentPage - 1) * this.itemsPerPage;
                    let end = start + this.itemsPerPage;
                    return this.filteredServices.slice(start, end);
                },
                
                get totalPages() {
                    return Math.ceil(this.filteredServices.length / this.itemsPerPage);
                },
                
                prevPage() {
                    if (this.currentPage > 1) this.currentPage--;
                },
                
                nextPage() {
                    if (this.currentPage < this.totalPages) this.currentPage++;
                },
                
                goToPage(page) {
                    this.currentPage = page;
                },
                
                formatPrice(price) {
                    if (!price) return '0';
                    return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
                },
                
                // Modal methods
                openBookingModal(service) {
                    if (!this.isLoggedIn) {
                        // Show message and redirect to login if not logged in
                        if (window.showInfo) {
                            window.showInfo('Please login to book a service', 3000);
                        }
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/login.jsp?redirect=bookservice';
                        }, 1500);
                        return;
                    }
                    
                    this.selectedService = service;
                    this.showBookingModal = true;
                    
                    // Reset booking details
                    this.resetBookingDetails();
                    
                    // Initialize date picker after modal is shown
                    setTimeout(() => {
                        this.initDatePicker();
                    }, 100);
                },
                
                closeBookingModal() {
                    this.showBookingModal = false;
                    this.selectedService = null;
                    this.resetBookingDetails();
                },
                
                resetBookingDetails() {
                    this.bookingDetails = {
                        date: '',
                        time: '10:00',
                        persons: 1,
                        specialRequests: ''
                    };
                },
                
                initDatePicker() {
                    if (!this.$refs.bookingDate) return;
                    
                    const today = new Date();
                    
                    flatpickr(this.$refs.bookingDate, {
                        minDate: 'today',
                        dateFormat: 'Y-m-d',
                        defaultDate: today,
                        onChange: (selectedDates, dateStr) => {
                            this.bookingDetails.date = dateStr;
                        }
                    });
                    
                    // Set initial date
                    this.bookingDetails.date = this.formatDate(today);
                },
                
                formatDate(date) {
                    const year = date.getFullYear();
                    const month = String(date.getMonth() + 1).padStart(2, '0');
                    const day = String(date.getDate()).padStart(2, '0');
                    return `${year}-${month}-${day}`;
                },
                
                confirmBooking() {
                    if (!this.bookingDetails.date) {
                        if (window.showError) {
                            window.showError('Please select a date', 3000);
                        }
                        return;
                    }
                    
                    if (!this.bookingDetails.time) {
                        if (window.showError) {
                            window.showError('Please select a time', 3000);
                        }
                        return;
                    }
                    
                    if (!this.bookingDetails.persons || this.bookingDetails.persons < 1) {
                        if (window.showError) {
                            window.showError('Please enter number of persons', 3000);
                        }
                        return;
                    }
                    
                    if (this.bookingDetails.persons > 4) {
                        if (window.showError) {
                            window.showError('Maximum 4 persons per booking', 3000);
                        }
                        return;
                    }
                    
                    // Show success message (test mode)
                    if (window.showSuccess) {
                        window.showSuccess('Service booked successfully! (Test Mode - This is just a demo)', 3000);
                    }
                    
                    // Log booking details to console
                    console.log('Service Booking Details:', {
                        service: this.selectedService,
                        userId: this.userId,
                        userName: this.userName,
                        date: this.bookingDetails.date,
                        time: this.bookingDetails.time,
                        persons: this.bookingDetails.persons,
                        specialRequests: this.bookingDetails.specialRequests,
                        totalPrice: this.selectedService.fees * this.bookingDetails.persons
                    });
                    
                    // Close modal
                    setTimeout(() => {
                        this.closeBookingModal();
                    }, 2000);
                }
            }
        }
    </script>
</body>
</html>