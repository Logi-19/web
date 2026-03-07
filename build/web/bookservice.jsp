<%-- 
    Document   : bookservice
    Author     : Based on bookroom.jsp pattern
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Spa & Wellness · Ocean View Resort</title>
    <!-- Tailwind via CDN + Inter font -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <!-- Alpine.js for interactive components -->
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Flatpickr for date and time picker -->
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
            height: 220px;
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
        
        .image-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 70px;
            background: linear-gradient(to top, rgba(0,0,0,0.6), transparent);
            z-index: 1;
        }
        
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
        
        .duration-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(2, 132, 168, 0.9);
            backdrop-filter: blur(5px);
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            color: white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            z-index: 2;
            display: flex;
            align-items: center;
            gap: 0.5rem;
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
            font-size: 1.3rem;
            font-weight: 800;
            color: #1e3c5c;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            line-height: 1.3;
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
            white-space: nowrap;
        }
        
        .category-badge-enhanced.spa {
            background: linear-gradient(135deg, #e6f0fa, #d4e4f5);
            color: #2c5282;
        }
        
        .category-badge-enhanced.massage {
            background: linear-gradient(135deg, #e6f7e6, #c8e6c9);
            color: #27632e;
        }
        
        .category-badge-enhanced.ayurveda {
            background: linear-gradient(135deg, #f3e5f5, #e1bee7);
            color: #6a1b9a;
        }
        
        .category-badge-enhanced.beauty {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            color: #b85d1a;
        }
        
        .category-badge-enhanced.yoga {
            background: linear-gradient(135deg, #ffe5e5, #ffcdd2);
            color: #b71c1c;
        }
        
        .category-badge-enhanced.fitness {
            background: linear-gradient(135deg, #e0f2fe, #b8e2f2);
            color: #0369a1;
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
        
        .service-details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.75rem;
            margin-bottom: 1.25rem;
        }
        
        .detail-item {
            background: #f0f7fa;
            border-radius: 0.75rem;
            padding: 0.5rem;
            text-align: center;
        }
        
        .detail-label {
            font-size: 0.65rem;
            color: #3a5a78;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        
        .detail-value {
            font-size: 1rem;
            font-weight: 700;
            color: #0284a8;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.25rem;
        }
        
        .price-section {
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
        
        .free-badge {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        
        .unlimited-badge {
            background: linear-gradient(135deg, #8b5cf6, #7c3aed);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        
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
        
        .price-input-enhanced {
            border: 2px solid #e2e8f0;
            border-radius: 1rem;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            width: 100%;
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
        
        .skeleton-enhanced {
            background: linear-gradient(90deg, #f0f7fa 25%, #e2e8f0 50%, #f0f7fa 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
        }
        
        @keyframes loading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }

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
            height: 250px;
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
        
        .date-select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 1rem;
            font-size: 0.95rem;
            background: white;
            cursor: pointer;
        }
        
        .total-price {
            background: linear-gradient(135deg, #f0f7fa, #e5f0f5);
            padding: 1rem;
            border-radius: 1rem;
            border: 1px solid #b5e5e0;
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
        
        .confirm-btn:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px -5px rgba(16, 185, 129, 0.4);
        }
        
        .confirm-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            background: linear-gradient(135deg, #94a3b8, #64748b);
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
        
        .booking-summary {
            background: #f8fafc;
            border-radius: 1rem;
            padding: 1rem;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px dashed #e2e8f0;
        }
        
        .summary-row:last-child {
            border-bottom: none;
        }
        
        .summary-label {
            color: #3a5a78;
            font-size: 0.9rem;
        }
        
        .summary-value {
            font-weight: 600;
            color: #1e3c5c;
        }
        
        .summary-total {
            font-size: 1.2rem;
            font-weight: 700;
            color: #0284a8;
        }
        
        .guest-counter {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 1rem;
            padding: 0.5rem;
        }
        
        .guest-counter-btn {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #f0f7fa;
            border: 1px solid #b5e5e0;
            color: #0284a8;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .guest-counter-btn:hover:not(:disabled) {
            background: #0284a8;
            color: white;
            transform: scale(1.1);
        }
        
        .guest-counter-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .guest-count {
            font-size: 1.2rem;
            font-weight: 700;
            color: #1e3c5c;
            min-width: 40px;
            text-align: center;
        }
        
        .time-slots {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 0.5rem;
            margin-top: 0.5rem;
            max-height: 200px;
            overflow-y: auto;
            padding: 0.5rem;
            border: 1px solid #e2e8f0;
            border-radius: 1rem;
        }
        
        .time-slot {
            padding: 0.5rem;
            border: 2px solid #e2e8f0;
            border-radius: 0.75rem;
            text-align: center;
            font-size: 0.8rem;
            font-weight: 600;
            color: #1e3c5c;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .time-slot:hover:not(.unavailable) {
            border-color: #0284a8;
            background: #f0f7fa;
        }
        
        .time-slot.selected {
            background: #0284a8;
            color: white;
            border-color: #0284a8;
        }
        
        .time-slot.unavailable {
            opacity: 0.5;
            cursor: not-allowed;
            background: #f1f5f9;
            text-decoration: line-through;
        }

        .booking-input.unavailable {
            border-color: #ef4444;
            background-color: #fee2e2;
        }
        
        .booking-input.available {
            border-color: #10b981;
            background-color: #f0fdf4;
        }

        [x-cloak] { display: none !important; }
    </style>
</head>
<body class="bg-[#f0f7fa] text-[#1e3c5c] antialiased" x-data="serviceBooking()" x-init="init()">

    <!-- Include Navbar -->
    <jsp:include page="component/navbar.jsp" />
    
    <jsp:include page="component/notification.jsp" />

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 mt-16">
        
        <!-- User Welcome Bar (shown when logged in) -->
        <div x-show="isLoggedIn" class="user-welcome" x-cloak>
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
            <h1 class="text-4xl md:text-5xl font-bold text-[#1e3c5c]">Spa & Wellness <span class="text-[#d4a373]">💆‍♀️</span></h1>
            <p class="text-[#3a5a78] mt-3 text-lg">Indulge in our luxurious spa treatments and wellness services</p>
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
                            <option :value="category.id" x-text="category.name + ' (' + category.count + ')'"></option>
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
                        <option value="0">Unlimited</option>
                        <option value="30">30 min</option>
                        <option value="60">60 min</option>
                        <option value="90">90 min</option>
                        <option value="120">120 min</option>
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
                        <option value="name">Name: A to Z</option>
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
                    <div class="text-center py-16">
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
                            
                            <!-- Duration Badge -->
                            <div class="duration-badge">
                                <i class="far fa-clock"></i>
                                <span x-text="service.duration === 0 ? 'Unlimited' : service.duration + ' min'"></span>
                            </div>
                            
                            <!-- Free Badge (if free) -->
                            <div x-show="service.fees === 0" class="free-badge" style="position: absolute; top: 60px; left: 15px; z-index: 2;">
                                <i class="fas fa-gift mr-1"></i> Free
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
                            </div>

                            <!-- Category Badge (below title) -->
                            <div class="mb-3">
                                <span class="category-badge-enhanced"
                                      :class="{
                                          'spa': (service.categoryName || '').toLowerCase().includes('spa'),
                                          'massage': (service.categoryName || '').toLowerCase().includes('massage'),
                                          'ayurveda': (service.categoryName || '').toLowerCase().includes('ayurveda'),
                                          'beauty': (service.categoryName || '').toLowerCase().includes('beauty'),
                                          'yoga': (service.categoryName || '').toLowerCase().includes('yoga'),
                                          'fitness': (service.categoryName || '').toLowerCase().includes('fitness')
                                      }">
                                    <i class="fas fa-tag mr-1"></i>
                                    <span x-text="service.categoryName || 'Wellness'"></span>
                                </span>
                            </div>

                            <!-- Description -->
                            <p class="service-description" x-text="service.description || 'Experience pure relaxation with our premium wellness service.'"></p>

                            <!-- Service Details Grid -->
                            <div class="service-details-grid">
                                <!-- Duration Detail -->
                                <div class="detail-item">
                                    <div class="detail-label">Duration</div>
                                    <div class="detail-value">
                                        <i class="far fa-clock"></i>
                                        <span x-text="service.duration === 0 ? 'Unlimited' : service.duration + ' min'"></span>
                                    </div>
                                </div>
                                
                                <!-- Price Detail -->
                                <div class="detail-item">
                                    <div class="detail-label">Price</div>
                                    <div class="detail-value">
                                        <i class="fas fa-tag"></i>
                                        <span x-text="service.fees === 0 ? 'Free' : 'LKR ' + formatPrice(service.fees)"></span>
                                    </div>
                                </div>
                            </div>

                            <!-- Price and Book Button -->
                            <div class="price-section">
                                <div class="price-info">
                                    <span class="price-label">Starting from</span>
                                    <div class="price-value">
                                        <span x-show="service.fees === 0">Free</span>
                                        <span x-show="service.fees > 0">LKR <span x-text="formatPrice(service.fees)"></span></span>
                                        <small x-show="service.fees > 0">/person</small>
                                    </div>
                                </div>
                                <button @click="openBookingModal(service)" 
                                        class="book-now-btn-enhanced"
                                        :class="{ 'disabled': !isLoggedIn || service.status === 'unavailable' }">
                                    <span x-text="service.status === 'unavailable' ? 'Unavailable' : (!isLoggedIn ? 'Login to Book' : 'Book Now')"></span>
                                    <i class="fas" :class="service.status === 'unavailable' ? 'fa-ban' : (isLoggedIn ? 'fa-arrow-right' : 'fa-lock')"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </template>
            </template>
        </div>

        <!-- Enhanced Pagination -->
        <div x-show="!loading && filteredServices.length > 0" class="flex flex-col items-center mt-12" x-cloak>
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
                                          'spa': (selectedService?.categoryName || '').toLowerCase().includes('spa'),
                                          'massage': (selectedService?.categoryName || '').toLowerCase().includes('massage'),
                                          'ayurveda': (selectedService?.categoryName || '').toLowerCase().includes('ayurveda'),
                                          'beauty': (selectedService?.categoryName || '').toLowerCase().includes('beauty'),
                                          'yoga': (selectedService?.categoryName || '').toLowerCase().includes('yoga'),
                                          'fitness': (selectedService?.categoryName || '').toLowerCase().includes('fitness')
                                      }">
                                    <span x-text="selectedService?.categoryName || 'Wellness'"></span>
                                </span>
                            </div>
                            
                            <div class="grid grid-cols-2 gap-3 mt-3">
                                <div class="flex items-center gap-2 text-sm">
                                    <i class="far fa-clock text-[#0284a8]"></i>
                                    <span x-text="'Duration: ' + (selectedService?.duration === 0 ? 'Unlimited' : selectedService?.duration + ' min')"></span>
                                </div>
                                <div class="flex items-center gap-2 text-sm">
                                    <i class="fas fa-tag text-[#0284a8]"></i>
                                    <span x-text="selectedService?.fees === 0 ? 'Free' : 'LKR ' + formatPrice(selectedService?.fees) + '/person'"></span>
                                </div>
                            </div>
                            
                            <!-- Additional Info -->
                            <div class="mt-4 flex gap-2">
                                <span x-show="selectedService?.fees === 0" class="free-badge">
                                    <i class="fas fa-gift mr-1"></i> Free Service
                                </span>
                                <span x-show="selectedService?.duration === 0" class="unlimited-badge">
                                    <i class="fas fa-infinity mr-1"></i> Unlimited Time
                                </span>
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
                                       placeholder="Choose your preferred date"
                                       class="date-select"
                                       :class="{
                                           'unavailable': bookingDetails.date && !bookingDetails.isAvailable,
                                           'available': bookingDetails.date && bookingDetails.isAvailable
                                       }"
                                       readonly>
                            </div>
                            <p class="text-xs text-[#3a5a78] mt-1">
                                <i class="far fa-clock mr-1"></i>
                                Select your preferred date
                            </p>
                        </div>
                        
                        <!-- Time Slots (duration-based intervals) -->
                        <div>
                            <label class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                <i class="fas fa-clock mr-2 text-[#d4a373]"></i>Select Time
                            </label>
                            <div x-show="bookingDetails.date" class="time-slots">
                                <template x-if="availableTimeSlots.length > 0">
                                    <template x-for="time in availableTimeSlots" :key="time">
                                        <div class="time-slot"
                                             :class="{ 
                                                 'selected': bookingDetails.time === time,
                                                 'unavailable': !isTimeSlotAvailable(time)
                                             }"
                                             @click="selectTimeSlot(time)"
                                             x-text="time">
                                        </div>
                                    </template>
                                </template>
                                <template x-if="availableTimeSlots.length === 0">
                                    <div class="col-span-4 text-center py-4 text-[#3a5a78]">
                                        No available time slots for this date
                                    </div>
                                </template>
                            </div>
                            <div x-show="!bookingDetails.date" class="text-sm text-[#3a5a78] text-center py-4">
                                Please select a date first
                            </div>
                            <p class="text-xs text-[#3a5a78] mt-1">
                                <i class="far fa-clock mr-1"></i>
                                Service duration: <span x-text="selectedService?.duration === 0 ? 'Unlimited' : selectedService?.duration + ' minutes'"></span>
                                <span x-show="selectedService?.duration > 0" class="block mt-1">
                                    Available slots every <span x-text="selectedService?.duration"></span> minutes from 06:00 to 23:00
                                </span>
                            </p>
                            
                            <!-- Availability Warning -->
                            <div x-show="!bookingDetails.isAvailable && bookingDetails.date" 
                                 class="availability-warning mt-2">
                                <i class="fas fa-exclamation-triangle"></i>
                                <span>This time slot is not available. Please select a different time.</span>
                            </div>
                        </div>
                        
                        <!-- Number of Guests -->
                        <div>
                            <label class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                <i class="fas fa-users mr-2 text-[#d4a373]"></i>Number of Guests
                            </label>
                            <div class="guest-counter">
                                <button @click="decreaseGuests()" 
                                        :disabled="bookingDetails.guests <= 1"
                                        class="guest-counter-btn">
                                    <i class="fas fa-minus"></i>
                                </button>
                                <span class="guest-count" x-text="bookingDetails.guests"></span>
                                <button @click="increaseGuests()" 
                                        :disabled="bookingDetails.guests >= 10"
                                        class="guest-counter-btn">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                        </div>
                        
                        <!-- Special Requests -->
                        <div>
                            <label class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                <i class="fas fa-comment mr-2 text-[#d4a373]"></i>Special Requests (Optional)
                            </label>
                            <textarea x-model="bookingDetails.specialRequests" 
                                      rows="2"
                                      placeholder="Any preferences? (e.g., preferred therapist, allergies, etc.)"
                                      class="booking-input"></textarea>
                        </div>
                        
                        <!-- Booking Summary -->
                        <div class="booking-summary">
                            <h4 class="font-semibold text-[#1e3c5c] mb-2">Booking Summary</h4>
                            
                            <div class="summary-row">
                                <span class="summary-label">Service:</span>
                                <span class="summary-value" x-text="selectedService?.title"></span>
                            </div>
                            
                            <div class="summary-row">
                                <span class="summary-label">Date:</span>
                                <span class="summary-value" x-text="bookingDetails.date ? formatDisplayDate(bookingDetails.date) : 'Not selected'"></span>
                            </div>
                            
                            <div class="summary-row">
                                <span class="summary-label">Time:</span>
                                <span class="summary-value" x-text="bookingDetails.time || 'Not selected'"></span>
                            </div>
                            
                            <div class="summary-row" x-show="selectedService?.duration > 0">
                                <span class="summary-label">End Time:</span>
                                <span class="summary-value" x-text="calculateEndTime()"></span>
                            </div>
                            
                            <div class="summary-row">
                                <span class="summary-label">Guests:</span>
                                <span class="summary-value" x-text="bookingDetails.guests + ' ' + (bookingDetails.guests === 1 ? 'person' : 'persons')"></span>
                            </div>
                            
                            <div class="summary-row">
                                <span class="summary-label">Price per person:</span>
                                <span class="summary-value" x-text="selectedService?.fees === 0 ? 'Free' : 'LKR ' + formatPrice(selectedService?.fees)"></span>
                            </div>
                            
                            <div class="summary-row font-bold border-t border-[#b5e5e0] mt-2 pt-2">
                                <span class="summary-label">Total Amount:</span>
                                <span class="summary-total" x-text="selectedService?.fees === 0 ? 'Free' : 'LKR ' + formatPrice(bookingDetails.totalPrice)"></span>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="flex gap-3 pt-2">
                            <button @click="closeBookingModal()" class="cancel-btn">
                                <i class="fas fa-times mr-2"></i>Cancel
                            </button>
                            <button @click="confirmBooking()" 
                                    class="confirm-btn"
                                    :disabled="!isBookingValid() || selectedService?.status === 'unavailable'">
                                <i class="fas fa-check-circle mr-2"></i>
                                Confirm Booking
                            </button>
                        </div>
                        
                        <!-- Unavailable Notice -->
                        <div x-show="selectedService?.status === 'unavailable'" class="text-center mt-2">
                            <span class="inline-flex items-center gap-2 bg-gray-100 text-gray-700 text-xs px-3 py-1.5 rounded-full">
                                <i class="fas fa-ban"></i>
                                This service is currently unavailable
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
        datePickerInitialized: false,
        flatpickrInstances: {
            bookingDate: null
        },
        
        // Business hours (6 AM to 11 PM)
        BUSINESS_START_HOUR: 6,
        BUSINESS_END_HOUR: 23,
        
        // Unavailable time slots
        unavailableTimeSlots: [],
        
        // Booking Details
        bookingDetails: {
            date: '',
            time: '',
            guests: 1,
            specialRequests: '',
            totalPrice: 0,
            isAvailable: true
        },
        
        init() {
            console.log('Initializing service booking...');
            // Load user data from storage
            this.loadUserData();
            
            // Load data
            this.loadCategories();
            this.loadServices();
            
            // Reset to first page when filters change
            this.$watch('filteredServices', () => {
                this.currentPage = 1;
            });
        },
        
        loadUserData() {
            // Check localStorage first (persistent login)
            this.userId = localStorage.getItem('userId') || sessionStorage.getItem('userId');
            this.userName = localStorage.getItem('userName') || sessionStorage.getItem('userName');
            this.userEmail = localStorage.getItem('userEmail') || sessionStorage.getItem('userEmail');
            this.userRegNo = localStorage.getItem('userRegNo') || sessionStorage.getItem('userRegNo');
            this.userType = localStorage.getItem('userType') || sessionStorage.getItem('userType');
            
            this.isLoggedIn = !!(this.userId);
            
            if (this.isLoggedIn) {
                console.log('User logged in:', this.userName);
            }
        },
        
        async loadCategories() {
            try {
                const response = await fetch('${pageContext.request.contextPath}/servicecategory/api/list');
                const categories = await response.json();
                
                // Get service counts per category
                const categoryStats = await this.loadCategoryStatistics();
                
                this.categories = Array.isArray(categories) ? categories.map(cat => {
                    const stat = Array.isArray(categoryStats) ? categoryStats.find(s => s.id === cat.id) : null;
                    return {
                        ...cat,
                        count: stat ? stat.serviceCount : 0
                    };
                }) : [];
            } catch (error) {
                console.error('Error loading categories:', error);
                this.categories = [];
            }
        },
        
        async loadCategoryStatistics() {
            try {
                const response = await fetch('${pageContext.request.contextPath}/manageservices/api/category-stats');
                return await response.json();
            } catch (error) {
                console.error('Error loading category stats:', error);
                return [];
            }
        },
        
        async loadServices() {
            this.loading = true;
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/manageservices/api/list');
                const data = await response.json();
                this.services = Array.isArray(data) ? data : [];
                this.applyFilters();
            } catch (error) {
                console.error('Error loading services:', error);
                this.services = [];
                this.filteredServices = [];
                
                if (window.showError) {
                    window.showError('Failed to load services', 3000);
                }
            } finally {
                this.loading = false;
            }
        },
        
        applyFilters() {
            let filtered = this.services.filter(service => 
                service.status === 'available' // Only show available services
            );
            
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
                    filtered.sort((a, b) => a.fees - b.fees);
                    break;
                case 'price_high':
                    filtered.sort((a, b) => b.fees - a.fees);
                    break;
                case 'duration_low':
                    filtered.sort((a, b) => a.duration - b.duration);
                    break;
                case 'duration_high':
                    filtered.sort((a, b) => b.duration - a.duration);
                    break;
                case 'name':
                    filtered.sort((a, b) => a.title.localeCompare(b.title));
                    break;
                default:
                    filtered.sort((a, b) => a.id - b.id);
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
        
        formatPrice(price) {
            if (!price && price !== 0) return '0';
            return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        },
        
        formatDisplayDate(dateStr) {
            if (!dateStr) return '';
            try {
                const options = { year: 'numeric', month: 'long', day: 'numeric' };
                return new Date(dateStr).toLocaleDateString('en-US', options);
            } catch (e) {
                return dateStr;
            }
        },
        
        formatDate(date) {
            if (!date) return '';
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return `${year}-${month}-${day}`;
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
        
        // Get available time slots based on selected date
        get availableTimeSlots() {
            if (!this.selectedService || !this.bookingDetails.date) return [];
            
            const slots = [];
            const selectedDate = new Date(this.bookingDetails.date);
            const now = new Date();
            
            if (this.selectedService.duration === 0) {
                // For unlimited duration, show hourly slots from 6 AM to 11 PM
                for (let hour = this.BUSINESS_START_HOUR; hour <= this.BUSINESS_END_HOUR; hour++) {
                    const timeStr = this.formatTime(hour, 0);
                    
                    // If selected date is today, filter out past times
                    if (this.isToday(selectedDate)) {
                        if (hour > now.getHours() || (hour === now.getHours() && 0 > now.getMinutes())) {
                            slots.push(timeStr);
                        }
                    } else {
                        slots.push(timeStr);
                    }
                }
            } else {
                // For fixed duration, generate slots every 'duration' minutes
                const duration = this.selectedService.duration;
                const startMinutes = this.BUSINESS_START_HOUR * 60;
                const endMinutes = this.BUSINESS_END_HOUR * 60;
                
                for (let minutes = startMinutes; minutes <= endMinutes - duration; minutes += duration) {
                    const hour = Math.floor(minutes / 60);
                    const minute = minutes % 60;
                    const timeStr = this.formatTime(hour, minute);
                    
                    // If selected date is today, filter out past times
                    if (this.isToday(selectedDate)) {
                        const currentMinutes = now.getHours() * 60 + now.getMinutes();
                        if (minutes > currentMinutes) {
                            slots.push(timeStr);
                        }
                    } else {
                        slots.push(timeStr);
                    }
                }
            }
            
            return slots;
        },
        
        isToday(date) {
            const today = new Date();
            return date.getDate() === today.getDate() &&
                   date.getMonth() === today.getMonth() &&
                   date.getFullYear() === today.getFullYear();
        },
        
        formatTime(hour, minute) {
            return `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
        },
        
        isTimeSlotAvailable(time) {
            // Check if time slot is in unavailable list
            return !this.unavailableTimeSlots.includes(time);
        },
        
        // Modal methods
        async openBookingModal(service) {
            if (!this.isLoggedIn) {
                if (window.showInfo) {
                    window.showInfo('Please login to book a service', 3000);
                }
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/login.jsp?redirect=bookservice';
                }, 1500);
                return;
            }
            
            if (service.status === 'unavailable') {
                if (window.showError) {
                    window.showError('This service is currently unavailable', 3000);
                }
                return;
            }
            
            this.selectedService = service;
            this.showBookingModal = true;
            this.datePickerInitialized = false;
            
            this.destroyFlatpickrInstance();
            this.resetBookingDetails();
            
            // Small delay to ensure DOM is ready
            setTimeout(() => {
                this.initDatePicker();
            }, 300);
        },
        
        destroyFlatpickrInstance() {
            if (this.flatpickrInstances.bookingDate) {
                this.flatpickrInstances.bookingDate.destroy();
                this.flatpickrInstances.bookingDate = null;
            }
        },
        
        closeBookingModal() {
            this.showBookingModal = false;
            this.selectedService = null;
            this.datePickerInitialized = false;
            this.destroyFlatpickrInstance();
        },
        
        resetBookingDetails() {
            this.bookingDetails = {
                date: '',
                time: '',
                guests: 1,
                specialRequests: '',
                totalPrice: this.selectedService?.fees || 0,
                isAvailable: true
            };
            this.unavailableTimeSlots = ['12:00', '13:00', '18:00']; // Example unavailable slots
        },
        
        initDatePicker() {
            if (!this.$refs.bookingDate) {
                console.error('Date picker ref not found');
                return;
            }
            
            if (this.datePickerInitialized) {
                console.log('Date picker already initialized');
                return;
            }

            console.log('Initializing date picker');

            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            // Calculate max date (3 months from now)
            const maxDate = new Date(today);
            maxDate.setMonth(maxDate.getMonth() + 3);

            // Destroy any existing instance
            this.destroyFlatpickrInstance();

            try {
                // Create date picker
                this.flatpickrInstances.bookingDate = flatpickr(this.$refs.bookingDate, {
                    minDate: 'today',
                    maxDate: maxDate,
                    dateFormat: 'Y-m-d',
                    onChange: (selectedDates, dateStr) => {
                        console.log('Date changed:', dateStr);
                        this.bookingDetails.date = dateStr;
                        this.bookingDetails.time = ''; // Reset time when date changes
                        this.checkAvailability();
                    }
                });

                console.log('Flatpickr picker created successfully');
                this.datePickerInitialized = true;

            } catch (error) {
                console.error('Error initializing date picker:', error);
                this.datePickerInitialized = false;
            }
        },
        
        selectTimeSlot(time) {
            if (this.isTimeSlotAvailable(time)) {
                this.bookingDetails.time = time;
                this.checkAvailability();
            }
        },
        
        increaseGuests() {
            if (this.bookingDetails.guests < 10) {
                this.bookingDetails.guests++;
                this.updateTotalPrice();
            }
        },
        
        decreaseGuests() {
            if (this.bookingDetails.guests > 1) {
                this.bookingDetails.guests--;
                this.updateTotalPrice();
            }
        },
        
        updateTotalPrice() {
            if (this.selectedService) {
                this.bookingDetails.totalPrice = this.selectedService.fees * this.bookingDetails.guests;
            }
        },
        
        calculateEndTime() {
            if (!this.bookingDetails.time || !this.selectedService || this.selectedService.duration === 0) {
                return '—';
            }
            
            const [hours, minutes] = this.bookingDetails.time.split(':').map(Number);
            const startMinutes = hours * 60 + minutes;
            const endMinutes = startMinutes + this.selectedService.duration;
            
            const endHour = Math.floor(endMinutes / 60);
            const endMinute = endMinutes % 60;
            
            return this.formatTime(endHour, endMinute);
        },
        
        checkAvailability() {
            if (!this.bookingDetails.date || !this.bookingDetails.time) {
                this.bookingDetails.isAvailable = false;
                return;
            }
            
            // Check if time slot is available
            this.bookingDetails.isAvailable = this.isTimeSlotAvailable(this.bookingDetails.time);
            
            // Also check if the date is valid (not in past)
            const selectedDate = new Date(this.bookingDetails.date);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (selectedDate < today) {
                this.bookingDetails.isAvailable = false;
                return;
            }
            
            // If selected date is today, check if time is in the future
            if (this.isToday(selectedDate)) {
                const now = new Date();
                const [hours, minutes] = this.bookingDetails.time.split(':').map(Number);
                const selectedTime = new Date();
                selectedTime.setHours(hours, minutes, 0);
                
                if (selectedTime <= now) {
                    this.bookingDetails.isAvailable = false;
                }
            }
        },
        
        isBookingValid() {
            return this.bookingDetails.date && 
                   this.bookingDetails.time && 
                   this.bookingDetails.guests > 0 &&
                   this.bookingDetails.isAvailable &&
                   this.selectedService?.status === 'available';
        },
        
        confirmBooking() {
            if (!this.isBookingValid()) {
                if (window.showError) {
                    window.showError('Please select a valid date and time', 3000);
                }
                return;
            }
            
            if (this.selectedService.status === 'unavailable') {
                if (window.showError) {
                    window.showError('This service is unavailable', 3000);
                }
                return;
            }
            
            const bookingData = {
                serviceId: parseInt(this.selectedService.id),
                guestId: parseInt(this.userId),
                bookingDate: this.bookingDetails.date,
                bookingTime: this.bookingDetails.time + ':00',
                numberOfGuests: this.bookingDetails.guests,
                specialRequests: this.bookingDetails.specialRequests || '',
                totalPrice: this.bookingDetails.totalPrice
            };
            
            console.log('Sending booking data:', bookingData);
            
            if (window.showInfo) {
                window.showInfo('Processing your booking...', 0);
            }
            
            fetch('${pageContext.request.contextPath}/bookservice/api/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(bookingData)
            })
            .then(async response => {
                const data = await response.json();
                if (!response.ok) {
                    throw new Error(data.message || `Server error: ${response.status}`);
                }
                return data;
            })
            .then(data => {
                if (data.success) {
                    if (window.showSuccess) {
                        window.showSuccess(data.message, 5000);
                    }
                    
                    // Redirect to my bookings page after successful booking
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/serviceactivity.jsp';
                    }, 2000);
                } else {
                    if (window.showError) {
                        window.showError(data.message, 5000);
                    }
                }
            })
            .catch(error => {
                console.error('Error creating booking:', error);
                if (window.showError) {
                    window.showError(error.message || 'Failed to create booking. Please try again.', 3000);
                }
            });
        }
    }
}
    </script>
</body>
</html>