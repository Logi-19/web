<%-- 
    Document   : booktable
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book a Table · Ocean View Resort</title>
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
        
        /* Enhanced Table card styles */
        .table-card {
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid rgba(181, 229, 224, 0.3);
            border-radius: 1.5rem;
            overflow: hidden;
            background: white;
            height: 100%;
            display: flex;
            flex-direction: column;
            position: relative;
            box-shadow: 0 10px 30px -15px rgba(212, 163, 115, 0.2);
        }
        
        .table-card:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: 0 30px 40px -15px rgba(212, 163, 115, 0.4);
            border-color: #d4a373;
        }
        
        .table-image-wrapper {
            position: relative;
            overflow: hidden;
            height: 240px;
        }
        
        .table-image {
            height: 100%;
            width: 100%;
            object-fit: cover;
            transition: transform 0.8s ease;
        }
        
        .table-card:hover .table-image {
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
        .table-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(5px);
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            color: #d4a373;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            z-index: 2;
            border: 1px solid rgba(212, 163, 115, 0.3);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .table-badge i {
            font-size: 0.875rem;
            color: #0284a8;
        }
        
        .location-badge-table {
            position: absolute;
            top: 15px;
            right: 15px;
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
            color: #d4a373;
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
            background: #d4a373;
            transform: scale(1.3);
            box-shadow: 0 0 10px rgba(212, 163, 115, 0.5);
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
            border: 1px solid rgba(212, 163, 115, 0.2);
            color: #d4a373;
            font-size: 1rem;
            z-index: 3;
            opacity: 0;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        
        .table-image-wrapper:hover .nav-arrow {
            opacity: 1;
        }
        
        .nav-arrow:hover {
            background: #d4a373;
            color: white;
            transform: translateY(-50%) scale(1.1);
            border-color: #d4a373;
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
            background: linear-gradient(to bottom, white, #fff9f0);
        }
        
        .table-title {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.75rem;
        }
        
        .table-number {
            font-size: 1.4rem;
            font-weight: 800;
            color: #1e3c5c;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .table-number i {
            color: #d4a373;
            font-size: 1.2rem;
        }
        
        .location-badge-enhanced {
            padding: 0.4rem 1.2rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .location-badge-enhanced.first-floor {
            background: linear-gradient(135deg, #e6f0fa, #d4e4f5);
            color: #2c5282;
        }
        
        .location-badge-enhanced.second-floor {
            background: linear-gradient(135deg, #e6f7e6, #c8e6c9);
            color: #27632e;
        }
        
        .location-badge-enhanced.beachside {
            background: linear-gradient(135deg, #f3e5f5, #e1bee7);
            color: #6a1b9a;
        }
        
        .location-badge-enhanced.poolside {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            color: #b85d1a;
        }
        
        .location-badge-enhanced.rooftop {
            background: linear-gradient(135deg, #ffe5e5, #ffcdd2);
            color: #b71c1c;
        }
        
        .location-badge-enhanced.garden {
            background: linear-gradient(135deg, #e0f2f1, #b2dfdb);
            color: #00695c;
        }
        
        .table-description {
            color: #4a6572;
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 1.25rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        /* Capacity indicator */
        .capacity-container {
            margin-bottom: 1.25rem;
        }
        
        .capacity-title {
            font-size: 0.8rem;
            font-weight: 600;
            color: #3a5a78;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .capacity-title i {
            color: #d4a373;
        }
        
        .capacity-indicator {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .capacity-icons {
            display: flex;
            gap: 0.25rem;
        }
        
        .capacity-icons i {
            color: #d4a373;
            font-size: 1rem;
        }
        
        .capacity-text {
            font-weight: 600;
            color: #1e3c5c;
            font-size: 0.9rem;
            margin-left: 0.5rem;
        }
        
        /* Price and action */
        .price-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
            padding-top: 1.25rem;
            border-top: 2px dashed rgba(212, 163, 115, 0.3);
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
            color: #d4a373;
            line-height: 1.2;
        }
        
        .book-now-btn-enhanced {
            background: linear-gradient(135deg, #d4a373, #b88b4a);
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
            box-shadow: 0 8px 15px -5px rgba(212, 163, 115, 0.4);
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
            box-shadow: 0 15px 25px -8px rgba(212, 163, 115, 0.6);
            background: linear-gradient(135deg, #b88b4a, #9e742e);
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
            background: linear-gradient(135deg, white, #fff9f0);
            border-radius: 2rem;
            border: 1px solid rgba(212, 163, 115, 0.3);
            padding: 2rem;
            margin-bottom: 2.5rem;
            box-shadow: 0 20px 40px -15px rgba(212, 163, 115, 0.15);
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
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23d4a373' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
        }
        
        .filter-select-enhanced:focus {
            outline: none;
            border-color: #d4a373;
            box-shadow: 0 0 0 4px rgba(212, 163, 115, 0.1);
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
            background: linear-gradient(135deg, #d4a373, #b88b4a);
            border-radius: 2rem;
            padding: 1rem 2rem;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            box-shadow: 0 10px 25px -5px rgba(212, 163, 115, 0.4);
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
            background: #d4a373;
            border-color: #d4a373;
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -5px rgba(212, 163, 115, 0.4);
        }
        
        .pagination-btn.active {
            background: #d4a373;
            border-color: #d4a373;
            color: white;
        }
        
        .pagination-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        /* Loading skeleton enhanced */
        .skeleton-enhanced {
            background: linear-gradient(90deg, #fff9f0 25%, #e2e8f0 50%, #fff9f0 75%);
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
        
        .table-detail-image {
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
            border-color: #d4a373;
            box-shadow: 0 0 0 4px rgba(212, 163, 115, 0.1);
        }
        
        .booking-input.unavailable {
            border-color: #ef4444;
            background-color: #fee2e2;
        }
        
        .booking-input.available {
            border-color: #10b981;
            background-color: #f0fdf4;
        }
        
        .time-picker-container {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }
        
        .time-input {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 1rem;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: white;
            cursor: pointer;
        }
        
        .time-input:focus {
            outline: none;
            border-color: #d4a373;
            box-shadow: 0 0 0 4px rgba(212, 163, 115, 0.1);
        }
        
        .total-price {
            background: linear-gradient(135deg, #fff9f0, #ffe8d6);
            padding: 1rem;
            border-radius: 1rem;
            border: 1px solid #d4a373;
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
        
        .availability-warning {
            background-color: #fee2e2;
            border: 1px solid #ef4444;
            color: #b91c1c;
            padding: 0.75rem;
            border-radius: 1rem;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .availability-warning i {
            color: #ef4444;
        }

        /* Unavailable date style for flatpickr */
        .flatpickr-day.unavailable {
            background-color: #fee2e2 !important;
            color: #ef4444 !important;
            text-decoration: line-through;
            cursor: not-allowed;
            border-color: #ef4444 !important;
        }
        
        .flatpickr-day.unavailable:hover {
            background-color: #fecaca !important;
        }
        
        /* Ensure flatpickr calendar is on top of everything */
        .flatpickr-calendar {
            z-index: 999999 !important;
            pointer-events: auto !important;
        }

        /* Partially booked badge */
        .partial-badge {
            position: absolute;
            top: 60px;
            left: 15px;
            background: #fbbf24;
            color: #92400e;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            z-index: 2;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        /* Maintenance badge */
        .maintenance-badge {
            position: absolute;
            top: 60px;
            left: 15px;
            background: #ef4444;
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
            z-index: 2;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        [x-cloak] { display: none !important; }
    </style>
</head>
<body class="bg-[#fff9f0] text-[#1e3c5c] antialiased" x-data="tableBooking()" x-init="init()">

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
            <h1 class="text-4xl md:text-5xl font-bold text-[#1e3c5c]">Book Your Table <span class="text-[#d4a373]">🍽️</span></h1>
            <p class="text-[#3a5a78] mt-3 text-lg">Reserve the perfect table for your dining experience with ocean views</p>
        </div>

        <!-- Enhanced Filter Section -->
        <div class="filter-section-enhanced">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <!-- Location Filter -->
                <div>
                    <div class="filter-title-enhanced">
                        <i class="fas fa-map-marker-alt"></i> Location
                    </div>
                    <select x-model="filters.locationId" @change="applyFilters()" class="filter-select-enhanced">
                        <option value="all">All Locations</option>
                        <template x-for="location in locations" :key="location.id">
                            <option :value="location.id" x-text="location.name"></option>
                        </template>
                    </select>
                </div>

                <!-- Capacity Filter -->
                <div>
                    <div class="filter-title-enhanced">
                        <i class="fas fa-users"></i> Capacity
                    </div>
                    <select x-model="filters.capacity" @change="applyFilters()" class="filter-select-enhanced">
                        <option value="all">Any Capacity</option>
                        <option value="2">2 Persons</option>
                        <option value="4">4 Persons</option>
                        <option value="6">6 Persons</option>
                        <option value="8">8 Persons</option>
                        <option value="10">10 Persons</option>
                        <option value="12">12+ Persons</option>
                    </select>
                </div>

                <!-- Date Filter -->
                <div>
                    <div class="filter-title-enhanced">
                        <i class="fas fa-calendar-alt"></i> Date
                    </div>
                    <input type="text" 
                           x-ref="dateFilter"
                           x-model="filters.date"
                           @change="applyFilters()"
                           placeholder="Select date"
                           class="filter-select-enhanced"
                           readonly>
                </div>

                <!-- Sort By -->
                <div>
                    <div class="filter-title-enhanced">
                        <i class="fas fa-sort-amount-down"></i> Sort By
                    </div>
                    <select x-model="filters.sortBy" @change="applyFilters()" class="filter-select-enhanced">
                        <option value="recommended">Recommended</option>
                        <option value="capacity_low">Capacity: Low to High</option>
                        <option value="capacity_high">Capacity: High to Low</option>
                    </select>
                </div>
            </div>

            <!-- Active Filters Summary -->
            <div class="flex flex-wrap items-center justify-between mt-6 pt-4 border-t border-[#d4a373] border-opacity-30">
                <div class="text-sm text-[#3a5a78] flex items-center gap-2">
                    <i class="fas fa-utensils text-[#d4a373]"></i>
                    <span x-text="filteredTables.length + ' tables available'"></span>
                    <span x-show="filters.locationId !== 'all' || filters.capacity !== 'all' || filters.date" 
                          class="text-xs bg-[#d4a373] text-white px-2 py-1 rounded-full">
                        Filtered
                    </span>
                </div>
                <button @click="clearFilters()" class="clear-filters-btn">
                    <i class="fas fa-times"></i> Clear Filters
                </button>
            </div>
        </div>

        <!-- Tables Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <!-- Loading State -->
            <template x-if="loading">
                <template x-for="i in 6" :key="i">
                    <div class="table-card">
                        <div class="table-image-wrapper skeleton-enhanced"></div>
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

            <!-- No Tables Found -->
            <template x-if="!loading && filteredTables.length === 0">
                <div class="col-span-full">
                    <div class="text-center py-16">
                        <span class="text-7xl mb-6 block">🍽️</span>
                        <h3 class="text-3xl font-bold text-[#1e3c5c] mb-3">No Tables Available</h3>
                        <p class="text-[#3a5a78] mb-6 text-lg">Try adjusting your filters to find the perfect table for your dining.</p>
                        <button @click="clearFilters()" 
                                class="px-8 py-4 bg-gradient-to-r from-[#d4a373] to-[#b88b4a] text-white rounded-full hover:shadow-xl transition-all transform hover:scale-105">
                            <i class="fas fa-redo-alt mr-2"></i> Clear Filters
                        </button>
                    </div>
                </div>
            </template>

            <!-- Table Cards -->
            <template x-if="!loading && filteredTables.length > 0">
                <template x-for="table in paginatedTables" :key="table.id">
                    <div class="table-card">
                        <!-- Image Gallery with Navigation -->
                        <div class="table-image-wrapper" x-data="{ currentImage: 0 }">
                            <img :src="table.images && table.images.length > 0 ? table.images[currentImage] : 'https://via.placeholder.com/600x400?text=Ocean+View+Resort+Table'" 
                                 class="table-image"
                                 alt="Table">
                            
                            <!-- Gradient Overlay -->
                            <div class="image-overlay"></div>
                            
                            <!-- Table Number Badge -->
                            <div class="table-badge">
                                <i class="fas fa-hashtag"></i>
                                <span x-text="table.tablePrefix + ' - ' + table.tableNo"></span>
                            </div>
                            
                            <!-- Location Badge -->
                            <div class="location-badge-table">
                                <i class="fas fa-map-marker-alt"></i>
                                <span x-text="table.locationName || 'Unknown'"></span>
                            </div>
                            
                            <!-- Maintenance Badge -->
                            <div class="maintenance-badge" x-show="table.status === 'maintenance'">
                                <i class="fas fa-tools mr-1"></i>
                                <span>Maintenance</span>
                            </div>
                            
                            <!-- Image Counter -->
                            <div x-show="table.images && table.images.length > 0" class="image-counter">
                                <i class="far fa-images"></i>
                                <span x-text="(currentImage + 1) + '/' + table.images.length"></span>
                            </div>
                            
                            <!-- Navigation Dots -->
                            <div x-show="table.images && table.images.length > 1" class="nav-dots">
                                <template x-for="(img, index) in table.images" :key="index">
                                    <button @click="currentImage = index" 
                                            class="nav-dot"
                                            :class="{ 'active': currentImage === index }">
                                    </button>
                                </template>
                            </div>
                            
                            <!-- Navigation Arrows -->
                            <button x-show="table.images && table.images.length > 1" 
                                    @click="currentImage = currentImage > 0 ? currentImage - 1 : table.images.length - 1"
                                    class="nav-arrow prev">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <button x-show="table.images && table.images.length > 1" 
                                    @click="currentImage = currentImage < table.images.length - 1 ? currentImage + 1 : 0"
                                    class="nav-arrow next">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>

                        <!-- Card Content -->
                        <div class="card-content">
                            <!-- Table Title and Location -->
                            <div class="table-title">
                                <div class="table-number">
                                    <i class="fas fa-utensils"></i>
                                    <span x-text="table.tableNo"></span>
                                </div>
                                <span class="location-badge-enhanced"
                                      :class="{
                                          'first-floor': (table.locationName || '').toLowerCase() === '1st floor',
                                          'second-floor': (table.locationName || '').toLowerCase() === '2nd floor',
                                          'beachside': (table.locationName || '').toLowerCase() === 'beachside',
                                          'poolside': (table.locationName || '').toLowerCase() === 'poolside',
                                          'rooftop': (table.locationName || '').toLowerCase() === 'rooftop',
                                          'garden': (table.locationName || '').toLowerCase() === 'garden'
                                      }">
                                    <i class="fas fa-map-pin mr-1"></i>
                                    <span x-text="table.locationName || 'Standard'"></span>
                                </span>
                            </div>

                            <!-- Description -->
                            <p class="table-description" x-text="table.description || 'Enjoy a wonderful dining experience at this beautifully appointed table.'"></p>

                            <!-- Capacity Indicator -->
                            <div class="capacity-container">
                                <div class="capacity-title">
                                    <i class="fas fa-users"></i>
                                    <span>Seating Capacity</span>
                                </div>
                                <div class="capacity-indicator">
                                    <div class="capacity-icons">
                                        <template x-for="i in Math.min(table.capacity, 8)" :key="i">
                                            <i class="fas fa-user"></i>
                                        </template>
                                        <template x-if="table.capacity > 8">
                                            <span class="text-xs font-bold text-[#d4a373]">+<span x-text="table.capacity - 8"></span></span>
                                        </template>
                                    </div>
                                    <span class="capacity-text" x-text="table.capacity + ' persons'"></span>
                                </div>
                            </div>

                            <!-- Price and Book Button -->
                            <div class="price-section">
                                <div class="price-info">
                                    <span class="price-label">Minimum spend</span>
                                    <div class="price-value">
                                        $<span x-text="table.minimumSpend || '0'"></span>
                                    </div>
                                </div>
                                <button @click="openBookingModal(table)" 
                                        class="book-now-btn-enhanced"
                                        :class="{ 'disabled': !isLoggedIn || table.status === 'maintenance' }">
                                    <span x-text="table.status === 'maintenance' ? 'Maintenance' : (!isLoggedIn ? 'Login to Book' : 'Book Now')"></span>
                                    <i class="fas" :class="table.status === 'maintenance' ? 'fa-tools' : (isLoggedIn ? 'fa-arrow-right' : 'fa-lock')"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </template>
            </template>
        </div>

        <!-- Enhanced Pagination -->
        <div x-show="!loading && filteredTables.length > 0" class="flex flex-col items-center mt-12" x-cloak>
            <div class="text-sm text-[#3a5a78] mb-4">
                <i class="fas fa-utensils mr-2"></i>
                <span x-text="'Showing ' + (((currentPage - 1) * itemsPerPage) + 1) + ' - ' + Math.min(currentPage * itemsPerPage, filteredTables.length) + ' of ' + filteredTables.length + ' tables'"></span>
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
                    <!-- Left Side - Table Details -->
                    <div class="space-y-4">
                        <h2 class="text-2xl font-bold text-[#1e3c5c] mb-4">Table Details</h2>
                        
                        <!-- Table Image -->
                        <div class="relative">
                            <img :src="selectedTable?.images && selectedTable?.images.length > 0 ? selectedTable.images[0] : 'https://via.placeholder.com/600x400?text=Ocean+View+Resort+Table'" 
                                 class="table-detail-image"
                                 alt="Selected Table">
                            <span class="absolute top-2 left-2 bg-[#d4a373] text-white px-3 py-1 rounded-full text-xs font-semibold">
                                <i class="fas fa-hashtag mr-1"></i>
                                <span x-text="selectedTable?.tablePrefix + ' - ' + selectedTable?.tableNo"></span>
                            </span>
                        </div>
                        
                        <!-- Table Info -->
                        <div class="bg-[#fff9f0] p-4 rounded-xl">
                            <div class="flex justify-between items-start mb-3">
                                <div>
                                    <h3 class="text-xl font-bold text-[#1e3c5c]" x-text="selectedTable?.tableNo"></h3>
                                    <p class="text-sm text-[#3a5a78]" x-text="selectedTable?.description || 'No description available'"></p>
                                </div>
                                <span class="location-badge-enhanced"
                                      :class="{
                                          'first-floor': (selectedTable?.locationName || '').toLowerCase() === '1st floor',
                                          'second-floor': (selectedTable?.locationName || '').toLowerCase() === '2nd floor',
                                          'beachside': (selectedTable?.locationName || '').toLowerCase() === 'beachside',
                                          'poolside': (selectedTable?.locationName || '').toLowerCase() === 'poolside',
                                          'rooftop': (selectedTable?.locationName || '').toLowerCase() === 'rooftop',
                                          'garden': (selectedTable?.locationName || '').toLowerCase() === 'garden'
                                      }">
                                    <span x-text="selectedTable?.locationName || 'Standard'"></span>
                                </span>
                            </div>
                            
                            <div class="grid grid-cols-2 gap-3 mt-3">
                                <div class="flex items-center gap-2 text-sm">
                                    <i class="fas fa-users text-[#d4a373]"></i>
                                    <span x-text="'Capacity: ' + (selectedTable?.capacity || '0') + ' ' + ((selectedTable?.capacity || 0) === 1 ? 'person' : 'persons')"></span>
                                </div>
                                <div class="flex items-center gap-2 text-sm">
                                    <i class="fas fa-tag text-[#d4a373]"></i>
                                    <span x-text="'Min spend: $' + (selectedTable?.minimumSpend || '0')"></span>
                                </div>
                            </div>
                            
                            <!-- Location Details -->
                            <div class="mt-4">
                                <p class="text-sm font-semibold text-[#1e3c5c] mb-2">Location Details:</p>
                                <div class="flex items-center gap-2">
                                    <i class="fas fa-map-pin text-[#d4a373]"></i>
                                    <span class="text-sm" x-text="selectedTable?.locationName || 'Standard'"></span>
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
                                       :class="{
                                           'unavailable': bookingDetails.date && !bookingDetails.isAvailable,
                                           'available': bookingDetails.date && bookingDetails.isAvailable
                                       }"
                                       readonly>
                            </div>
                            
                            <!-- Availability Warning -->
                            <div x-show="!bookingDetails.isAvailable && bookingDetails.date" 
                                 class="availability-warning mt-2">
                                <i class="fas fa-exclamation-triangle"></i>
                                <span>This table is not available for the selected date. Please choose a different date.</span>
                            </div>
                        </div>
                        
                        <!-- Time Selection -->
                        <div>
                            <label class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                <i class="fas fa-clock mr-2 text-[#d4a373]"></i>Select Time
                            </label>
                            <div class="time-picker-container">
                                <input type="text" 
                                       x-ref="bookingTime"
                                       x-model="bookingDetails.time"
                                       placeholder="Select time"
                                       class="time-input">
                            </div>
                            <p class="text-xs text-[#3a5a78] mt-1">
                                <i class="far fa-info-circle mr-1"></i>
                                Standard dining time: 2 hours
                            </p>
                        </div>
                        
                        <!-- Party Size -->
                        <div>
                            <label class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                <i class="fas fa-users mr-2 text-[#d4a373]"></i>Party Size
                            </label>
                            <select x-model="bookingDetails.partySize" 
                                    class="booking-input"
                                    :disabled="!selectedTable">
                                <template x-for="i in (selectedTable?.capacity || 10)" :key="i">
                                    <option :value="i" x-text="i + ' ' + (i === 1 ? 'person' : 'persons')"></option>
                                </template>
                            </select>
                        </div>
                        
                        <!-- Special Requests -->
                        <div>
                            <label class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                <i class="fas fa-comment mr-2 text-[#d4a373]"></i>Special Requests (Optional)
                            </label>
                            <textarea x-model="bookingDetails.specialRequests" 
                                      rows="3"
                                      placeholder="Any special requests? (e.g., dietary requirements, occasion, etc.)"
                                      class="booking-input"></textarea>
                        </div>
                        
                        <!-- Minimum Spend Notice -->
                        <div class="total-price">
                            <div class="flex justify-between items-center mb-2">
                                <span class="text-sm text-[#3a5a78]">Minimum spend:</span>
                                <span class="font-semibold">$<span x-text="selectedTable?.minimumSpend || '0'"></span></span>
                            </div>
                            <div class="border-t border-[#d4a373] border-opacity-30 my-2 pt-2">
                                <p class="text-xs text-[#3a5a78] text-center">
                                    <i class="fas fa-info-circle mr-1"></i>
                                    This is the minimum spend requirement for this table
                                </p>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="flex gap-3 pt-4">
                            <button @click="closeBookingModal()" class="cancel-btn">
                                <i class="fas fa-times mr-2"></i>Cancel
                            </button>
                            <button @click="confirmBooking()" 
                                    class="confirm-btn"
                                    :disabled="!bookingDetails.isAvailable || !bookingDetails.date || !bookingDetails.time || !bookingDetails.partySize || bookingDetails.checkingAvailability || selectedTable?.status === 'maintenance'">
                                <i class="fas" :class="bookingDetails.checkingAvailability ? 'fa-spinner fa-spin' : 'fa-check-circle'"></i>
                                <span x-text="bookingDetails.checkingAvailability ? 'Checking...' : 'Confirm Booking'"></span>
                            </button>
                        </div>
                        
                        <!-- Maintenance Notice -->
                        <div x-show="selectedTable?.status === 'maintenance'" class="text-center mt-2">
                            <span class="inline-flex items-center gap-2 bg-gray-100 text-gray-700 text-xs px-3 py-1.5 rounded-full">
                                <i class="fas fa-tools"></i>
                                This table is under maintenance and cannot be booked
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
function tableBooking() {
    return {
        // User data from login
        isLoggedIn: false,
        userId: null,
        userName: '',
        userEmail: '',
        userRegNo: '',
        userType: '',
        
        // Data properties
        tables: [],
        filteredTables: [],
        locations: [],
        loading: true,
        unavailableDates: [], // Store unavailable dates for the selected table
        unavailableTimes: [], // Store unavailable times for the selected date
        
        // Filters
        filters: {
            locationId: 'all',
            capacity: 'all',
            date: '',
            sortBy: 'recommended'
        },
        
        // Pagination
        currentPage: 1,
        itemsPerPage: 6,
        
        // Modal
        showBookingModal: false,
        selectedTable: null,
        datePickersInitialized: false,
        flatpickrInstances: {
            dateFilter: null,
            bookingDate: null,
            bookingTime: null
        },
        
        // Booking Details
        bookingDetails: {
            date: '',
            time: '',
            partySize: 2,
            specialRequests: '',
            isAvailable: true,
            checkingAvailability: false
        },
        
        init() {
            // Load user data from storage
            this.loadUserData();
            
            this.loadLocations();
            this.loadTables();
            
            // Reset to first page when filters change
            this.$watch('filteredTables', () => {
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
                console.log('User logged in:', this.userName, 'Type:', this.userType);
            }
        },
        
        loadLocations() {
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
        
        loadTables() {
            this.loading = true;
            
            fetch('${pageContext.request.contextPath}/managetables/api/list')
                .then(response => response.json())
                .then(data => {
                    // Show ALL tables, regardless of status
                    this.tables = Array.isArray(data) ? data : [];
                    
                    // Add minimumSpend property if not present (for demo purposes)
                    this.tables.forEach(table => {
                        if (!table.minimumSpend) {
                            // Generate random minimum spend based on capacity and location
                            const baseSpend = 50;
                            const capacityMultiplier = table.capacity || 2;
                            const locationMultiplier = table.locationName === 'Beachside' ? 2 : 
                                                       table.locationName === 'Rooftop' ? 1.8 :
                                                       table.locationName === 'Poolside' ? 1.5 : 1;
                            table.minimumSpend = Math.round(baseSpend * capacityMultiplier * locationMultiplier);
                        }
                    });
                    
                    this.applyFilters();
                    this.loading = false;
                })
                .catch(error => {
                    console.error('Error loading tables:', error);
                    this.tables = [];
                    this.filteredTables = [];
                    this.loading = false;
                    
                    if (window.showError) {
                        window.showError('Failed to load tables', 3000);
                    }
                });
        },
        
        loadUnavailableDates(tableId) {
            return fetch('${pageContext.request.contextPath}/tablebookings/api/available-dates?tableId=' + tableId)
                .then(response => {
                    if (!response.ok) throw new Error('Failed to fetch bookings');
                    return response.json();
                })
                .then(bookings => {
                    console.log('Bookings for table', tableId, ':', bookings);
                    
                    // Clear previous unavailable dates
                    this.unavailableDates = [];
                    
                    bookings.forEach(booking => {
                        console.log('Processing booking:', booking.bookingDate);
                        
                        // Parse date
                        const dateStr = booking.bookingDate; // YYYY-MM-DD
                        
                        // Add to unavailable dates
                        if (dateStr && !this.unavailableDates.includes(dateStr)) {
                            this.unavailableDates.push(dateStr);
                        }
                    });
                    
                    console.log('Final unavailable dates for table', tableId, ':', this.unavailableDates);
                    return Promise.resolve();
                })
                .catch(error => {
                    console.error('Error loading unavailable dates:', error);
                    this.unavailableDates = [];
                    return Promise.resolve();
                });
        },
        
        loadUnavailableTimes(tableId, date) {
            return fetch('${pageContext.request.contextPath}/tablebookings/api/available-times?tableId=' + tableId + '&date=' + date)
                .then(response => {
                    if (!response.ok) throw new Error('Failed to fetch bookings');
                    return response.json();
                })
                .then(bookedTimes => {
                    console.log('Booked times for table', tableId, 'on', date, ':', bookedTimes);
                    
                    // Store unavailable times
                    this.unavailableTimes = bookedTimes || [];
                    
                    return Promise.resolve();
                })
                .catch(error => {
                    console.error('Error loading unavailable times:', error);
                    this.unavailableTimes = [];
                    return Promise.resolve();
                });
        },

        isDateUnavailable(dateStr) {
            return this.unavailableDates.includes(dateStr);
        },
        
        isTimeUnavailable(timeStr) {
            return this.unavailableTimes.includes(timeStr);
        },
        
        applyFilters() {
            let filtered = [...this.tables];
            
            // Filter by location
            if (this.filters.locationId !== 'all') {
                filtered = filtered.filter(table => table.locationId == this.filters.locationId);
            }
            
            // Filter by capacity
            if (this.filters.capacity !== 'all') {
                const capacityValue = parseInt(this.filters.capacity);
                if (capacityValue === 12) {
                    filtered = filtered.filter(table => (table.capacity || 0) >= 12);
                } else {
                    filtered = filtered.filter(table => (table.capacity || 0) >= capacityValue);
                }
            }
            
            // Apply sorting
            switch(this.filters.sortBy) {
                case 'capacity_low':
                    filtered.sort((a, b) => (a.capacity || 0) - (b.capacity || 0));
                    break;
                case 'capacity_high':
                    filtered.sort((a, b) => (b.capacity || 0) - (a.capacity || 0));
                    break;
                default:
                    // Recommended: sort by capacity then location
                    filtered.sort((a, b) => {
                        if (a.capacity === b.capacity) {
                            return (a.locationName || '').localeCompare(b.locationName || '');
                        }
                        return (a.capacity || 0) - (b.capacity || 0);
                    });
            }
            
            this.filteredTables = filtered;
        },
        
        clearFilters() {
            this.filters = {
                locationId: 'all',
                capacity: 'all',
                date: '',
                sortBy: 'recommended'
            };
            
            // Clear date filter picker
            if (this.flatpickrInstances.dateFilter) {
                this.flatpickrInstances.dateFilter.clear();
            }
            
            this.applyFilters();
            
            if (window.showInfo) {
                window.showInfo('Filters cleared', 2000);
            }
        },
        
        // Pagination methods
        get paginatedTables() {
            let start = (this.currentPage - 1) * this.itemsPerPage;
            let end = start + this.itemsPerPage;
            return this.filteredTables.slice(start, end);
        },
        
        get totalPages() {
            return Math.ceil(this.filteredTables.length / this.itemsPerPage);
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
        
        // Modal methods
        async openBookingModal(table) {
            if (!this.isLoggedIn) {
                if (window.showInfo) {
                    window.showInfo('Please login to book a table', 3000);
                }
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/login.jsp?redirect=booktable';
                }, 1500);
                return;
            }
            
            if (table.status === 'maintenance') {
                if (window.showError) {
                    window.showError('This table is under maintenance and cannot be booked', 3000);
                }
                return;
            }
            
            this.selectedTable = table;
            this.showBookingModal = true;
            this.datePickersInitialized = false;
            
            this.destroyFlatpickrInstances();
            this.resetBookingDetails();
            
            // Set default party size to table capacity or 2
            this.bookingDetails.partySize = Math.min(table.capacity || 10, 2);
            
            await this.loadUnavailableDates(table.id);
            
            setTimeout(() => {
                this.initDatePickers();
                this.initTimePicker();
            }, 300);
        },
        
        destroyFlatpickrInstances() {
            if (this.flatpickrInstances.dateFilter) {
                this.flatpickrInstances.dateFilter.destroy();
                this.flatpickrInstances.dateFilter = null;
            }
            if (this.flatpickrInstances.bookingDate) {
                this.flatpickrInstances.bookingDate.destroy();
                this.flatpickrInstances.bookingDate = null;
            }
            if (this.flatpickrInstances.bookingTime) {
                this.flatpickrInstances.bookingTime.destroy();
                this.flatpickrInstances.bookingTime = null;
            }
        },
        
        closeBookingModal() {
            this.showBookingModal = false;
            this.selectedTable = null;
            this.unavailableDates = [];
            this.unavailableTimes = [];
            this.datePickersInitialized = false;
            this.destroyFlatpickrInstances();
        },
        
        resetBookingDetails() {
            this.bookingDetails = {
                date: '',
                time: '',
                partySize: 2,
                specialRequests: '',
                isAvailable: true,
                checkingAvailability: false
            };
        },
        
        initDatePickers() {
            // Initialize date filter picker if it exists
            if (this.$refs.dateFilter && !this.flatpickrInstances.dateFilter) {
                this.flatpickrInstances.dateFilter = flatpickr(this.$refs.dateFilter, {
                    minDate: 'today',
                    dateFormat: 'Y-m-d',
                    onChange: (selectedDates, dateStr) => {
                        this.filters.date = dateStr;
                        this.applyFilters();
                    }
                });
            }
            
            // Initialize booking date picker
            if (this.$refs.bookingDate && !this.flatpickrInstances.bookingDate) {
                console.log('Initializing booking date picker');
                console.log('Unavailable dates:', this.unavailableDates);
                
                // Create array of disabled dates
                const disabledDates = this.unavailableDates && this.unavailableDates.length > 0 
                    ? this.unavailableDates 
                    : [];

                this.flatpickrInstances.bookingDate = flatpickr(this.$refs.bookingDate, {
                    minDate: 'today',
                    dateFormat: 'Y-m-d',
                    disable: disabledDates,
                    onChange: (selectedDates, dateStr) => {
                        console.log('Booking date changed:', dateStr);
                        this.bookingDetails.date = dateStr;
                        this.bookingDetails.time = ''; // Reset time when date changes
                        
                        // Load unavailable times for this date
                        if (dateStr && this.selectedTable) {
                            this.loadUnavailableTimes(this.selectedTable.id, dateStr).then(() => {
                                this.checkAvailability();
                                
                                // Update time picker with unavailable times
                                if (this.flatpickrInstances.bookingTime) {
                                    this.flatpickrInstances.bookingTime.set('disable', this.getDisabledTimes());
                                }
                            });
                        }
                    }
                });
            }
        },
        
        getDisabledTimes() {
            // Return array of disabled time strings
            return this.unavailableTimes || [];
        },
        
        initTimePicker() {
            if (!this.$refs.bookingTime) return;
            
            if (this.flatpickrInstances.bookingTime) {
                this.flatpickrInstances.bookingTime.destroy();
            }
            
            // Generate time options (every 30 minutes from 11:00 to 22:00)
            const timeOptions = [];
            for (let hour = 11; hour <= 22; hour++) {
                for (let minute = 0; minute < 60; minute += 30) {
                    if (hour === 22 && minute > 0) continue; // Last booking at 22:00
                    const timeStr = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
                    timeOptions.push(timeStr);
                }
            }
            
            this.flatpickrInstances.bookingTime = flatpickr(this.$refs.bookingTime, {
                enableTime: true,
                noCalendar: true,
                dateFormat: "H:i",
                time_24hr: true,
                minuteIncrement: 30,
                minTime: "11:00",
                maxTime: "22:00",
                disable: this.getDisabledTimes(),
                onChange: (selectedDates, timeStr) => {
                    console.log('Booking time changed:', timeStr);
                    this.bookingDetails.time = timeStr;
                    this.checkAvailability();
                }
            });
        },
        
        checkAvailability() {
            if (!this.selectedTable || !this.bookingDetails.date || !this.bookingDetails.time) {
                this.bookingDetails.isAvailable = false;
                return;
            }
            
            // Check if date is unavailable
            if (this.isDateUnavailable(this.bookingDetails.date)) {
                this.bookingDetails.isAvailable = false;
                return;
            }
            
            // Check if time is unavailable
            if (this.isTimeUnavailable(this.bookingDetails.time)) {
                this.bookingDetails.isAvailable = false;
                return;
            }
            
            this.bookingDetails.isAvailable = true;
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
            
            if (!this.bookingDetails.partySize) {
                if (window.showError) {
                    window.showError('Please select party size', 3000);
                }
                return;
            }
            
            if (!this.bookingDetails.isAvailable) {
                if (window.showError) {
                    window.showError('This table is not available for the selected date and time', 3000);
                }
                return;
            }
            
            if (this.selectedTable.status === 'maintenance') {
                if (window.showError) {
                    window.showError('This table is under maintenance and cannot be booked', 3000);
                }
                return;
            }
            
            const bookingData = {
                tableId: parseInt(this.selectedTable.id),
                guestId: parseInt(this.userId),
                bookingDate: this.bookingDetails.date,
                bookingTime: this.bookingDetails.time + ':00',
                partySize: parseInt(this.bookingDetails.partySize),
                specialRequests: this.bookingDetails.specialRequests || ''
            };
            
            if (window.showInfo) {
                window.showInfo('Processing your booking...', 0);
            }
            
            fetch('${pageContext.request.contextPath}/tablebookings/api/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(bookingData)
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
                        window.showSuccess(data.message, 5000);
                    }
                    
                    this.loadTables();
        
                    setTimeout(() => {
                        this.closeBookingModal();
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