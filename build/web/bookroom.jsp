<%-- 
    Document   : bookroom
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book a Room · Ocean View Resort</title>
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
        
        /* Enhanced Room card styles */
        .room-card {
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
        
        .room-card:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: 0 30px 40px -15px rgba(2, 132, 168, 0.4);
            border-color: #0284a8;
        }
        
        .room-image-wrapper {
            position: relative;
            overflow: hidden;
            height: 240px;
        }
        
        .room-image {
            height: 100%;
            width: 100%;
            object-fit: cover;
            transition: transform 0.8s ease;
        }
        
        .room-card:hover .room-image {
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
        .room-badge {
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
        
        .room-badge i {
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
        
        .room-image-wrapper:hover .nav-arrow {
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
        
        .room-title {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.75rem;
        }
        
        .room-number {
            font-size: 1.4rem;
            font-weight: 800;
            color: #1e3c5c;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .room-number i {
            color: #d4a373;
            font-size: 1.2rem;
        }
        
        .type-badge-enhanced {
            padding: 0.4rem 1.2rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .type-badge-enhanced.standard {
            background: linear-gradient(135deg, #e6f0fa, #d4e4f5);
            color: #2c5282;
        }
        
        .type-badge-enhanced.deluxe {
            background: linear-gradient(135deg, #e6f7e6, #c8e6c9);
            color: #27632e;
        }
        
        .type-badge-enhanced.suite {
            background: linear-gradient(135deg, #f3e5f5, #e1bee7);
            color: #6a1b9a;
        }
        
        .type-badge-enhanced.executive {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            color: #b85d1a;
        }
        
        .type-badge-enhanced.presidential {
            background: linear-gradient(135deg, #ffe5e5, #ffcdd2);
            color: #b71c1c;
        }
        
        .room-description {
            color: #4a6572;
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 1.25rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        /* Facilities tags */
        .facilities-container {
            margin-bottom: 1.25rem;
        }
        
        .facilities-title {
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
        
        .facilities-title i {
            color: #d4a373;
        }
        
        .facilities-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
        }
        
        .facility-tag-enhanced {
            background: linear-gradient(135deg, #f0f7fa, #e5f0f5);
            padding: 0.35rem 1rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 500;
            color: #0284a8;
            border: 1px solid rgba(2, 132, 168, 0.2);
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }
        
        .facility-tag-enhanced i {
            font-size: 0.7rem;
            color: #d4a373;
        }
        
        .more-facilities {
            background: #e2e8f0;
            color: #1e3c5c;
            padding: 0.35rem 1rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        
        /* Price and action */
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
        
        .room-detail-image {
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
        
        .booking-input.unavailable {
            border-color: #ef4444;
            background-color: #fee2e2;
        }
        
        .booking-input.available {
            border-color: #10b981;
            background-color: #f0fdf4;
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
            border-color: #0284a8;
            box-shadow: 0 0 0 4px rgba(2, 132, 168, 0.1);
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
<body class="bg-[#f0f7fa] text-[#1e3c5c] antialiased" x-data="roomBooking()" x-init="init()">

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
            <h1 class="text-4xl md:text-5xl font-bold text-[#1e3c5c]">Book Your Dream Stay <span class="text-[#d4a373]">🏝️</span></h1>
            <p class="text-[#3a5a78] mt-3 text-lg">Choose from our selection of luxurious rooms with breathtaking ocean views</p>
        </div>

        <!-- Enhanced Filter Section -->
        <div class="filter-section-enhanced">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <!-- Room Type Filter -->
                <div>
                    <div class="filter-title-enhanced">
                        <i class="fas fa-tag"></i> Room Type
                    </div>
                    <select x-model="filters.typeId" @change="applyFilters()" class="filter-select-enhanced">
                        <option value="all">All Room Types</option>
                        <template x-for="type in roomTypes" :key="type.id">
                            <option :value="type.id" x-text="type.name"></option>
                        </template>
                    </select>
                </div>

                <!-- Price Range Filter -->
                <div>
                    <div class="filter-title-enhanced">
                        <i class="fas fa-dollar-sign"></i> Price Range
                    </div>
                    <div class="flex gap-2">
                        <input type="number" 
                               x-model="filters.minPrice"
                               @change="applyFilters()"
                               placeholder="Min $"
                               class="price-input-enhanced"
                               min="0">
                        <input type="number" 
                               x-model="filters.maxPrice"
                               @change="applyFilters()"
                               placeholder="Max $"
                               class="price-input-enhanced"
                               min="0">
                    </div>
                </div>

                <!-- Capacity Filter -->
                <div>
                    <div class="filter-title-enhanced">
                        <i class="fas fa-users"></i> Capacity
                    </div>
                    <select x-model="filters.capacity" @change="applyFilters()" class="filter-select-enhanced">
                        <option value="all">Any Capacity</option>
                        <option value="1">1 Person</option>
                        <option value="2">2 Persons</option>
                        <option value="3">3 Persons</option>
                        <option value="4">4 Persons</option>
                        <option value="6">6 Persons</option>
                        <option value="8">8 Persons</option>
                        <option value="10">10 Persons</option>
                        <option value="12">12+ Persons</option>
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
                        <option value="capacity_low">Capacity: Low to High</option>
                        <option value="capacity_high">Capacity: High to Low</option>
                    </select>
                </div>
            </div>

            <!-- Active Filters Summary -->
            <div class="flex flex-wrap items-center justify-between mt-6 pt-4 border-t border-[#b5e5e0]">
                <div class="text-sm text-[#3a5a78] flex items-center gap-2">
                    <i class="fas fa-door-open text-[#0284a8]"></i>
                    <span x-text="filteredRooms.length + ' rooms available'"></span>
                    <span x-show="filters.typeId !== 'all' || filters.minPrice || filters.maxPrice || filters.capacity !== 'all'" 
                          class="text-xs bg-[#0284a8] text-white px-2 py-1 rounded-full">
                        Filtered
                    </span>
                </div>
                <button @click="clearFilters()" class="clear-filters-btn">
                    <i class="fas fa-times"></i> Clear Filters
                </button>
            </div>
        </div>

        <!-- Rooms Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <!-- Loading State -->
            <template x-if="loading">
                <template x-for="i in 6" :key="i">
                    <div class="room-card">
                        <div class="room-image-wrapper skeleton-enhanced"></div>
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

            <!-- No Rooms Found -->
            <template x-if="!loading && filteredRooms.length === 0">
                <div class="col-span-full">
                    <div class="text-center py-16">
                        <span class="text-7xl mb-6 block">🏖️</span>
                        <h3 class="text-3xl font-bold text-[#1e3c5c] mb-3">No Rooms Available</h3>
                        <p class="text-[#3a5a78] mb-6 text-lg">Try adjusting your filters to find the perfect room for your stay.</p>
                        <button @click="clearFilters()" 
                                class="px-8 py-4 bg-gradient-to-r from-[#0284a8] to-[#03738C] text-white rounded-full hover:shadow-xl transition-all transform hover:scale-105">
                            <i class="fas fa-redo-alt mr-2"></i> Clear Filters
                        </button>
                    </div>
                </div>
            </template>

            <!-- Room Cards -->
            <template x-if="!loading && filteredRooms.length > 0">
                <template x-for="room in paginatedRooms" :key="room.id">
                    <div class="room-card">
                        <!-- Image Gallery with Navigation -->
                        <div class="room-image-wrapper" x-data="{ currentImage: 0 }">
                            <img :src="room.images && room.images.length > 0 ? room.images[currentImage] : 'https://via.placeholder.com/600x400?text=Ocean+View+Resort'" 
                                 class="room-image"
                                 alt="Room">
                            
                            <!-- Gradient Overlay -->
                            <div class="image-overlay"></div>
                            
                            <!-- Room Number Badge -->
                            <div class="room-badge">
                                <i class="fas fa-door-open"></i>
                                <span x-text="'Room ' + (room.roomNo || room.room_no || 'N/A')"></span>
                            </div>
                            
                            <!-- Partially Booked Badge (show if room has any confirmed bookings) -->
                            <div class="partial-badge" x-show="room.hasActiveBookings">
                                <i class="fas fa-calendar-alt mr-1"></i>
                                <span>Partially Booked</span>
                            </div>
                            
                            <!-- Maintenance Badge -->
                            <div class="maintenance-badge" x-show="room.status === 'maintenance'">
                                <i class="fas fa-tools mr-1"></i>
                                <span>Maintenance</span>
                            </div>
                            
                            <!-- Image Counter -->
                            <div x-show="room.images && room.images.length > 0" class="image-counter">
                                <i class="far fa-images"></i>
                                <span x-text="(currentImage + 1) + '/' + room.images.length"></span>
                            </div>
                            
                            <!-- Navigation Dots -->
                            <div x-show="room.images && room.images.length > 1" class="nav-dots">
                                <template x-for="(img, index) in room.images" :key="index">
                                    <button @click="currentImage = index" 
                                            class="nav-dot"
                                            :class="{ 'active': currentImage === index }">
                                    </button>
                                </template>
                            </div>
                            
                            <!-- Navigation Arrows -->
                            <button x-show="room.images && room.images.length > 1" 
                                    @click="currentImage = currentImage > 0 ? currentImage - 1 : room.images.length - 1"
                                    class="nav-arrow prev">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <button x-show="room.images && room.images.length > 1" 
                                    @click="currentImage = currentImage < room.images.length - 1 ? currentImage + 1 : 0"
                                    class="nav-arrow next">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>

                        <!-- Card Content -->
                        <div class="card-content">
                            <!-- Room Title and Type -->
                            <div class="room-title">
                                <div class="room-number">
                                    <i class="fas fa-hashtag"></i>
                                    <span x-text="room.roomNo || room.room_no || 'N/A'"></span>
                                </div>
                                <span class="type-badge-enhanced"
                                      :class="{
                                          'standard': (room.typeName || '').toLowerCase() === 'standard',
                                          'deluxe': (room.typeName || '').toLowerCase() === 'deluxe',
                                          'suite': (room.typeName || '').toLowerCase() === 'suite',
                                          'executive': (room.typeName || '').toLowerCase() === 'executive',
                                          'presidential': (room.typeName || '').toLowerCase() === 'presidential'
                                      }">
                                    <i class="fas fa-star mr-1"></i>
                                    <span x-text="room.typeName || room.room_type_name || 'Standard'"></span>
                                </span>
                            </div>

                            <!-- Description -->
                            <p class="room-description" x-text="room.description || 'Experience luxury and comfort in this beautifully appointed room with modern amenities.'"></p>

                            <!-- Facilities -->
                            <div class="facilities-container">
                                <div class="facilities-title">
                                    <i class="fas fa-concierge-bell"></i>
                                    <span>Amenities</span>
                                </div>
                                <div class="facilities-tags">
                                    <template x-if="room.facilityNames && room.facilityNames.length > 0">
                                        <template x-for="facility in room.facilityNames.slice(0, 3)" :key="facility">
                                            <span class="facility-tag-enhanced">
                                                <i class="fas fa-check-circle"></i>
                                                <span x-text="facility"></span>
                                            </span>
                                        </template>
                                    </template>
                                    <template x-if="room.facilityNames && room.facilityNames.length > 3">
                                        <span class="more-facilities">
                                            +<span x-text="room.facilityNames.length - 3"></span> more
                                        </span>
                                    </template>
                                    <template x-if="!room.facilityNames || room.facilityNames.length === 0">
                                        <span class="text-xs text-gray-400">Standard amenities included</span>
                                    </template>
                                </div>
                            </div>

                            <!-- Price and Book Button -->
                            <div class="price-section">
                                <div class="price-info">
                                    <span class="price-label">Starting from</span>
                                    <div class="price-value">
                                        $<span x-text="room.price || room.rate || '0'"></span>
                                        <small>/night</small>
                                    </div>
                                </div>
                                <button @click="openBookingModal(room)" 
                                        class="book-now-btn-enhanced"
                                        :class="{ 'disabled': !isLoggedIn || room.status === 'maintenance' }">
                                    <span x-text="room.status === 'maintenance' ? 'Maintenance' : (!isLoggedIn ? 'Login to Book' : 'Book Now')"></span>
                                    <i class="fas" :class="room.status === 'maintenance' ? 'fa-tools' : (isLoggedIn ? 'fa-arrow-right' : 'fa-lock')"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </template>
            </template>
        </div>

        <!-- Enhanced Pagination -->
        <div x-show="!loading && filteredRooms.length > 0" class="flex flex-col items-center mt-12" x-cloak>
            <div class="text-sm text-[#3a5a78] mb-4">
                <i class="fas fa-door-open mr-2"></i>
                <span x-text="'Showing ' + (((currentPage - 1) * itemsPerPage) + 1) + ' - ' + Math.min(currentPage * itemsPerPage, filteredRooms.length) + ' of ' + filteredRooms.length + ' rooms'"></span>
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
                    <!-- Left Side - Room Details -->
                    <div class="space-y-4">
                        <h2 class="text-2xl font-bold text-[#1e3c5c] mb-4">Room Details</h2>
                        
                        <!-- Room Image -->
                        <div class="relative">
                            <img :src="selectedRoom?.images && selectedRoom?.images.length > 0 ? selectedRoom.images[0] : 'https://via.placeholder.com/600x400?text=Ocean+View+Resort'" 
                                 class="room-detail-image"
                                 alt="Selected Room">
                            <span class="absolute top-2 left-2 bg-[#0284a8] text-white px-3 py-1 rounded-full text-xs font-semibold">
                                <i class="fas fa-door-open mr-1"></i>
                                <span x-text="'Room ' + (selectedRoom?.roomNo || selectedRoom?.room_no || 'N/A')"></span>
                            </span>
                        </div>
                        
                        <!-- Room Info -->
                        <div class="bg-[#f8fafc] p-4 rounded-xl">
                            <div class="flex justify-between items-start mb-3">
                                <div>
                                    <h3 class="text-xl font-bold text-[#1e3c5c]" x-text="selectedRoom?.roomNo || selectedRoom?.room_no || 'N/A'"></h3>
                                    <p class="text-sm text-[#3a5a78]" x-text="selectedRoom?.description || 'No description available'"></p>
                                </div>
                                <span class="type-badge-enhanced"
                                      :class="{
                                          'standard': (selectedRoom?.typeName || '').toLowerCase() === 'standard',
                                          'deluxe': (selectedRoom?.typeName || '').toLowerCase() === 'deluxe',
                                          'suite': (selectedRoom?.typeName || '').toLowerCase() === 'suite',
                                          'executive': (selectedRoom?.typeName || '').toLowerCase() === 'executive',
                                          'presidential': (selectedRoom?.typeName || '').toLowerCase() === 'presidential'
                                      }">
                                    <span x-text="selectedRoom?.typeName || selectedRoom?.room_type_name || 'Standard'"></span>
                                </span>
                            </div>
                            
                            <div class="grid grid-cols-2 gap-3 mt-3">
                                <div class="flex items-center gap-2 text-sm">
                                    <i class="fas fa-users text-[#0284a8]"></i>
                                    <span x-text="'Capacity: ' + (selectedRoom?.capacity || '0') + ' ' + ((selectedRoom?.capacity || 0) === 1 ? 'person' : 'persons')"></span>
                                </div>
                                <div class="flex items-center gap-2 text-sm">
                                    <i class="fas fa-tag text-[#0284a8]"></i>
                                    <span x-text="'$' + (selectedRoom?.price || selectedRoom?.rate || '0') + '/night'"></span>
                                </div>
                            </div>
                            
                            <!-- Facilities -->
                            <div class="mt-4">
                                <p class="text-sm font-semibold text-[#1e3c5c] mb-2">Amenities:</p>
                                <div class="flex flex-wrap gap-2">
                                    <template x-if="selectedRoom?.facilityNames && selectedRoom.facilityNames.length > 0">
                                        <template x-for="facility in selectedRoom.facilityNames.slice(0, 4)" :key="facility">
                                            <span class="facility-tag-enhanced text-xs">
                                                <i class="fas fa-check-circle"></i>
                                                <span x-text="facility"></span>
                                            </span>
                                        </template>
                                    </template>
                                    <template x-if="selectedRoom?.facilityNames && selectedRoom.facilityNames.length > 4">
                                        <span class="more-facilities text-xs">
                                            +<span x-text="selectedRoom.facilityNames.length - 4"></span> more
                                        </span>
                                    </template>
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
                                <i class="fas fa-calendar-alt mr-2 text-[#d4a373]"></i>Select Dates
                            </label>
                            <div class="grid grid-cols-2 gap-3">
                                <div>
                                    <input type="text" 
                                           x-ref="checkInDate"
                                           x-model="bookingDetails.checkIn"
                                           placeholder="Check-in"
                                           class="booking-input"
                                           :class="{
                                               'unavailable': bookingDetails.checkIn && bookingDetails.checkOut && !bookingDetails.isAvailable,
                                               'available': bookingDetails.checkIn && bookingDetails.checkOut && bookingDetails.isAvailable
                                           }"
                                           readonly>
                                </div>
                                <div>
                                    <input type="text" 
                                           x-ref="checkOutDate"
                                           x-model="bookingDetails.checkOut"
                                           placeholder="Check-out"
                                           class="booking-input"
                                           :class="{
                                               'unavailable': bookingDetails.checkIn && bookingDetails.checkOut && !bookingDetails.isAvailable,
                                               'available': bookingDetails.checkIn && bookingDetails.checkOut && bookingDetails.isAvailable
                                           }"
                                           readonly>
                                </div>
                            </div>
                            <p class="text-xs text-[#3a5a78] mt-1">
                                <i class="far fa-clock mr-1"></i>
                                <span x-text="bookingDetails.nights + ' night' + (bookingDetails.nights !== 1 ? 's' : '')"></span>
                            </p>
                            
                            <!-- Availability Warning -->
                            <div x-show="!bookingDetails.isAvailable && bookingDetails.checkIn && bookingDetails.checkOut" 
                                 class="availability-warning mt-2">
                                <i class="fas fa-exclamation-triangle"></i>
                                <span>This room is not available for the selected dates. Please choose different dates.</span>
                            </div>
                        </div>
                        
                        <!-- Check-in Time with Time Picker -->
                        <div>
                            <label class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                <i class="fas fa-clock mr-2 text-[#d4a373]"></i>Check-in Time
                            </label>
                            <div class="time-picker-container">
                                <input type="text" 
                                       x-ref="checkInTime"
                                       x-model="bookingDetails.checkInTime"
                                       placeholder="Select time"
                                       class="time-input">
                            </div>
                        </div>
                        
                        <!-- Special Requests -->
                        <div>
                            <label class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                <i class="fas fa-comment mr-2 text-[#d4a373]"></i>Special Requests (Optional)
                            </label>
                            <textarea x-model="bookingDetails.specialRequests" 
                                      rows="3"
                                      placeholder="Any special requests? (e.g., extra pillows, late check-out, etc.)"
                                      class="booking-input"></textarea>
                        </div>
                        
                        <!-- Total Price -->
                        <div class="total-price">
                            <div class="flex justify-between items-center mb-2">
                                <span class="text-sm text-[#3a5a78]">Price per night:</span>
                                <span class="font-semibold">$<span x-text="selectedRoom?.price || selectedRoom?.rate || '0'"></span></span>
                            </div>
                            <div class="flex justify-between items-center mb-2">
                                <span class="text-sm text-[#3a5a78]">Number of nights:</span>
                                <span class="font-semibold" x-text="bookingDetails.nights"></span>
                            </div>
                            <div class="border-t border-[#b5e5e0] my-2 pt-2">
                                <div class="flex justify-between items-center">
                                    <span class="font-bold text-[#1e3c5c]">Total Amount:</span>
                                    <span class="text-2xl font-bold text-[#0284a8]">
                                        $<span x-text="bookingDetails.totalPrice"></span>
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="flex gap-3 pt-4">
                            <button @click="closeBookingModal()" class="cancel-btn">
                                <i class="fas fa-times mr-2"></i>Cancel
                            </button>
                            <button @click="confirmBooking()" 
                                    class="confirm-btn"
                                    :disabled="!bookingDetails.isAvailable || !bookingDetails.checkIn || !bookingDetails.checkOut || !bookingDetails.checkInTime || bookingDetails.checkingAvailability || selectedRoom?.status === 'maintenance'">
                                <i class="fas" :class="bookingDetails.checkingAvailability ? 'fa-spinner fa-spin' : 'fa-check-circle'"></i>
                                <span x-text="bookingDetails.checkingAvailability ? 'Checking...' : 'Confirm Booking'"></span>
                            </button>
                        </div>
                        
                        <!-- Maintenance Notice -->
                        <div x-show="selectedRoom?.status === 'maintenance'" class="text-center mt-2">
                            <span class="inline-flex items-center gap-2 bg-gray-100 text-gray-700 text-xs px-3 py-1.5 rounded-full">
                                <i class="fas fa-tools"></i>
                                This room is under maintenance and cannot be booked
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
function roomBooking() {
    return {
        // User data from login
        isLoggedIn: false,
        userId: null,
        userName: '',
        userEmail: '',
        userRegNo: '',
        userType: '',
        
        // Data properties
        rooms: [],
        filteredRooms: [],
        roomTypes: [],
        loading: true,
        unavailableDates: [], // Store unavailable dates for the selected room
        
        // Filters
        filters: {
            typeId: 'all',
            minPrice: '',
            maxPrice: '',
            capacity: 'all',
            sortBy: 'recommended'
        },
        
        // Pagination
        currentPage: 1,
        itemsPerPage: 6,
        
        // Modal
        showBookingModal: false,
        selectedRoom: null,
        datePickersInitialized: false,
        flatpickrInstances: {
            checkIn: null,
            checkOut: null,
            checkInTime: null
        },
        
        // Booking Details
        bookingDetails: {
            checkIn: '',
            checkOut: '',
            nights: 1,
            checkInTime: '',
            specialRequests: '',
            totalPrice: 0,
            isAvailable: true,
            checkingAvailability: false
        },
        
        init() {
            // Load user data from storage
            this.loadUserData();
            
            this.loadRoomTypes();
            this.loadRooms();
            
            // Reset to first page when filters change
            this.$watch('filteredRooms', () => {
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
        
        loadRoomTypes() {
            fetch('${pageContext.request.contextPath}/roomtypes/api/list')
                .then(response => response.json())
                .then(data => {
                    this.roomTypes = Array.isArray(data) ? data : [];
                })
                .catch(error => {
                    console.error('Error loading room types:', error);
                    this.roomTypes = [];
                });
        },
        
        loadRooms() {
            this.loading = true;
            
            fetch('${pageContext.request.contextPath}/managerooms/api/list')
                .then(response => response.json())
                .then(data => {
                    // Show ALL rooms, regardless of status
                    this.rooms = Array.isArray(data) ? data : [];
                    
                    // Fetch bookings for each room to check if they have active bookings
                    const promises = this.rooms.map(room => {
                        return fetch('${pageContext.request.contextPath}/bookings/api/room?roomId=' + room.id)
                            .then(res => res.json())
                            .then(bookings => {
                                // Check if room has any confirmed bookings
                                room.hasActiveBookings = bookings.some(b => 
                                    b.status === 'confirmed'
                                );
                                return room;
                            })
                            .catch(() => {
                                room.hasActiveBookings = false;
                                return room;
                            });
                    });
                    
                    Promise.all(promises).then(() => {
                        this.applyFilters();
                        this.loading = false;
                    });
                })
                .catch(error => {
                    console.error('Error loading rooms:', error);
                    this.rooms = [];
                    this.filteredRooms = [];
                    this.loading = false;
                    
                    if (window.showError) {
                        window.showError('Failed to load rooms', 3000);
                    }
                });
        },
        
        loadUnavailableDates(roomId) {
            return fetch('${pageContext.request.contextPath}/bookings/api/room?roomId=' + roomId)
                .then(response => {
                    if (!response.ok) throw new Error('Failed to fetch bookings');
                    return response.json();
                })
                .then(bookings => {
                    console.log('Bookings for room', roomId, ':', bookings);
                    // Only consider confirmed bookings as blocking availability
                    const confirmedBookings = bookings.filter(b => b.status === 'confirmed');
                    console.log('Confirmed bookings for room', roomId, ':', confirmedBookings);

                    // Clear previous unavailable dates
                    this.unavailableDates = [];
                    
                    confirmedBookings.forEach(booking => {
                        console.log('Processing booking:', booking.checkInDate, 'to', booking.checkOutDate);
                        
                        // Parse dates as strings only - no Date objects to avoid timezone issues
                        const startDateStr = booking.checkInDate; // YYYY-MM-DD
                        const endDateStr = booking.checkOutDate;   // YYYY-MM-DD
                        
                        // Convert to comparable format (just the date strings)
                        const startParts = startDateStr.split('-').map(Number);
                        const endParts = endDateStr.split('-').map(Number);
                        
                        // Create date strings in YYYY-MM-DD format
                        const start = new Date(startParts[0], startParts[1] - 1, startParts[2]);
                        const end = new Date(endParts[0], endParts[1] - 1, endParts[2]);
                        
                        // Generate all dates between start and end (excluding end date)
                        const currentDate = new Date(start);
                        while (currentDate < end) {
                            const year = currentDate.getFullYear();
                            const month = String(currentDate.getMonth() + 1).padStart(2, '0');
                            const day = String(currentDate.getDate()).padStart(2, '0');
                            const dateStr = `${year}-${month}-${day}`;
                            
                            // Validate the generated string is a proper YYYY-MM-DD
                            if (/^\d{4}-\d{2}-\d{2}$/.test(dateStr) && !this.unavailableDates.includes(dateStr)) {
                                this.unavailableDates.push(dateStr);
                            }
                            
                            // Move to next day
                            currentDate.setDate(currentDate.getDate() + 1);
                        }
                    });
                    
                    console.log('Final unavailable dates for room', roomId, ':', this.unavailableDates);
                    return Promise.resolve();
                })
                .catch(error => {
                    console.error('Error loading unavailable dates:', error);
                    this.unavailableDates = [];
                    return Promise.resolve();
                });
        },

        isDateUnavailable(dateStr) {
            // dateStr is already in YYYY-MM-DD format from flatpickr
            return this.unavailableDates.includes(dateStr);
        },
        
        applyFilters() {
            let filtered = [...this.rooms];
            
            // Filter by type
            if (this.filters.typeId !== 'all') {
                filtered = filtered.filter(room => room.typeId == this.filters.typeId);
            }
            
            // Filter by price range
            if (this.filters.minPrice) {
                filtered = filtered.filter(room => (room.price || room.rate || 0) >= parseFloat(this.filters.minPrice));
            }
            if (this.filters.maxPrice) {
                filtered = filtered.filter(room => (room.price || room.rate || 0) <= parseFloat(this.filters.maxPrice));
            }
            
            // Filter by capacity
            if (this.filters.capacity !== 'all') {
                const capacityValue = parseInt(this.filters.capacity);
                if (capacityValue === 12) {
                    filtered = filtered.filter(room => (room.capacity || 0) >= 12);
                } else {
                    filtered = filtered.filter(room => (room.capacity || 0) >= capacityValue);
                }
            }
            
            // Apply sorting
            switch(this.filters.sortBy) {
                case 'price_low':
                    filtered.sort((a, b) => (a.price || a.rate || 0) - (b.price || b.rate || 0));
                    break;
                case 'price_high':
                    filtered.sort((a, b) => (b.price || b.rate || 0) - (a.price || a.rate || 0));
                    break;
                case 'capacity_low':
                    filtered.sort((a, b) => (a.capacity || 0) - (b.capacity || 0));
                    break;
                case 'capacity_high':
                    filtered.sort((a, b) => (b.capacity || 0) - (a.capacity || 0));
                    break;
                default:
                    filtered.sort((a, b) => (a.price || a.rate || 0) - (b.price || b.rate || 0));
            }
            
            this.filteredRooms = filtered;
        },
        
        clearFilters() {
            this.filters = {
                typeId: 'all',
                minPrice: '',
                maxPrice: '',
                capacity: 'all',
                sortBy: 'recommended'
            };
            this.applyFilters();
            
            if (window.showInfo) {
                window.showInfo('Filters cleared', 2000);
            }
        },
        
        // Pagination methods
        get paginatedRooms() {
            let start = (this.currentPage - 1) * this.itemsPerPage;
            let end = start + this.itemsPerPage;
            return this.filteredRooms.slice(start, end);
        },
        
        get totalPages() {
            return Math.ceil(this.filteredRooms.length / this.itemsPerPage);
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
        async openBookingModal(room) {
            if (!this.isLoggedIn) {
                if (window.showInfo) {
                    window.showInfo('Please login to book a room', 3000);
                }
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/login.jsp?redirect=bookroom';
                }, 1500);
                return;
            }
            
            if (room.status === 'maintenance') {
                if (window.showError) {
                    window.showError('This room is under maintenance and cannot be booked', 3000);
                }
                return;
            }
            
            this.selectedRoom = room;
            this.showBookingModal = true;
            this.datePickersInitialized = false;
            
            this.destroyFlatpickrInstances();
            this.resetBookingDetails();
            
            await this.loadUnavailableDates(room.id);
            
            setTimeout(() => {
                this.initDatePickers();
                this.initTimePicker();
            }, 300);
        },
        
        destroyFlatpickrInstances() {
            if (this.flatpickrInstances.checkIn) {
                this.flatpickrInstances.checkIn.destroy();
                this.flatpickrInstances.checkIn = null;
            }
            if (this.flatpickrInstances.checkOut) {
                this.flatpickrInstances.checkOut.destroy();
                this.flatpickrInstances.checkOut = null;
            }
            if (this.flatpickrInstances.checkInTime) {
                this.flatpickrInstances.checkInTime.destroy();
                this.flatpickrInstances.checkInTime = null;
            }
        },
        
        closeBookingModal() {
            this.showBookingModal = false;
            this.selectedRoom = null;
            this.unavailableDates = [];
            this.datePickersInitialized = false;
            this.destroyFlatpickrInstances();
        },
        
        resetBookingDetails() {
            this.bookingDetails = {
                checkIn: '',
                checkOut: '',
                nights: 1,
                checkInTime: '',
                specialRequests: '',
                totalPrice: 0,
                isAvailable: true,
                checkingAvailability: false
            };
        },
        
        initDatePickers() {
            if (!this.$refs.checkInDate || !this.$refs.checkOutDate) {
                console.error('Date picker refs not found');
                return;
            }
            if (this.datePickersInitialized) {
                console.log('Date pickers already initialized');
                return;
            }

            console.log('Initializing date pickers');
            console.log('Unavailable dates:', this.unavailableDates);

            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);

            const tomorrowStr = this.formatDate(tomorrow);

            // Destroy any existing instances
            if (this.flatpickrInstances.checkIn) {
                this.flatpickrInstances.checkIn.destroy();
                this.flatpickrInstances.checkIn = null;
            }
            if (this.flatpickrInstances.checkOut) {
                this.flatpickrInstances.checkOut.destroy();
                this.flatpickrInstances.checkOut = null;
            }

            // Create array of disabled dates
            const disabledDates = this.unavailableDates && this.unavailableDates.length > 0 
                ? this.unavailableDates 
                : [];

            // Clear input values completely
            this.$refs.checkInDate.value = '';
            this.$refs.checkOutDate.value = '';

            try {
                // Create check-in picker
                this.flatpickrInstances.checkIn = flatpickr(this.$refs.checkInDate, {
                    minDate: 'today',
                    dateFormat: 'Y-m-d',
                    disable: disabledDates,
                    onChange: (selectedDates, dateStr) => {
                        console.log('Check-in changed:', dateStr);
                        this.bookingDetails.checkIn = dateStr;
                        this.updateNightsAndTotal();
                        // Update checkout min date
                        if (this.flatpickrInstances.checkOut && dateStr) {
                            const nextDay = new Date(dateStr);
                            nextDay.setDate(nextDay.getDate() + 1);
                            this.flatpickrInstances.checkOut.set('minDate', nextDay);
                        }
                        this.checkAvailability();
                    }
                });

                // Create check-out picker
                this.flatpickrInstances.checkOut = flatpickr(this.$refs.checkOutDate, {
                    minDate: tomorrowStr,
                    dateFormat: 'Y-m-d',
                    disable: disabledDates,
                    onChange: (selectedDates, dateStr) => {
                        console.log('Check-out changed:', dateStr);
                        this.bookingDetails.checkOut = dateStr;
                        this.updateNightsAndTotal();
                        this.checkAvailability();
                    }
                });

                console.log('Flatpickr pickers created successfully');

                // Initialize booking details with empty strings (user must select)
                this.bookingDetails.checkIn = '';
                this.bookingDetails.checkOut = '';
                this.bookingDetails.nights = 0;
                this.bookingDetails.totalPrice = 0;

                this.datePickersInitialized = true;

            } catch (error) {
                console.error('Error initializing date pickers:', error);
                this.datePickersInitialized = false;
            }
        },
        
        initTimePicker() {
            if (!this.$refs.checkInTime) return;
            
            if (this.flatpickrInstances.checkInTime) {
                this.flatpickrInstances.checkInTime.destroy();
            }
            
            // Create a default date object for time picker (today at 14:00)
            const defaultTime = new Date();
            defaultTime.setHours(14, 0, 0);
            
            this.flatpickrInstances.checkInTime = flatpickr(this.$refs.checkInTime, {
                enableTime: true,
                noCalendar: true,
                dateFormat: "H:i",
                time_24hr: true,
                defaultDate: defaultTime,
                minuteIncrement: 15,
                onChange: (selectedDates, timeStr) => {
                    this.bookingDetails.checkInTime = timeStr;
                }
            });
            
            // Set initial time value from input
            this.bookingDetails.checkInTime = this.$refs.checkInTime.value || "14:00";
        },
        
        formatDate(date) {
            if (!date) return '';
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return `${year}-${month}-${day}`;
        },
        
        updateNightsAndTotal() {
            if (this.bookingDetails.checkIn && this.bookingDetails.checkOut) {
                const checkIn = new Date(this.bookingDetails.checkIn + 'T00:00:00');
                const checkOut = new Date(this.bookingDetails.checkOut + 'T00:00:00');
                const diffTime = Math.abs(checkOut - checkIn);
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                
                this.bookingDetails.nights = diffDays || 1;
                
                const pricePerNight = this.selectedRoom?.price || this.selectedRoom?.rate || 0;
                this.bookingDetails.totalPrice = (pricePerNight * this.bookingDetails.nights).toFixed(2);
            }
        },
        
        checkAvailability() {
            if (!this.selectedRoom || 
                !this.bookingDetails.checkIn || 
                !this.bookingDetails.checkOut ||
                this.bookingDetails.checkIn === '' ||
                this.bookingDetails.checkOut === '') {
                this.bookingDetails.isAvailable = false;
                return;
            }
            
            const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
            if (!dateRegex.test(this.bookingDetails.checkIn) || !dateRegex.test(this.bookingDetails.checkOut)) {
                console.warn('Invalid date format:', this.bookingDetails.checkIn, this.bookingDetails.checkOut);
                this.bookingDetails.isAvailable = false;
                return;
            }
            
            // Parse dates
            const checkInParts = this.bookingDetails.checkIn.split('-').map(Number);
            const checkOutParts = this.bookingDetails.checkOut.split('-').map(Number);
            
            const checkInDate = new Date(checkInParts[0], checkInParts[1] - 1, checkInParts[2]);
            const checkOutDate = new Date(checkOutParts[0], checkOutParts[1] - 1, checkOutParts[2]);
            
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (checkInDate < today) {
                this.bookingDetails.isAvailable = false;
                return;
            }
            
            if (checkOutDate <= checkInDate) {
                this.bookingDetails.isAvailable = false;
                return;
            }
            
            // Check each date in the range (excluding check-out date)
            let hasConflict = false;
            const currentDate = new Date(checkInDate);
            
            while (currentDate < checkOutDate) {
                const year = currentDate.getFullYear();
                const month = String(currentDate.getMonth() + 1).padStart(2, '0');
                const day = String(currentDate.getDate()).padStart(2, '0');
                const dateStr = `${year}-${month}-${day}`;
                
                if (this.unavailableDates.includes(dateStr)) {
                    console.warn('Date unavailable:', dateStr);
                    hasConflict = true;
                    break;
                }
                
                // Move to next day
                currentDate.setDate(currentDate.getDate() + 1);
            }
            
            this.bookingDetails.isAvailable = !hasConflict;
            console.log('Room available:', this.bookingDetails.isAvailable);
        },
        
        confirmBooking() {
            if (!this.bookingDetails.checkIn || !this.bookingDetails.checkOut) {
                if (window.showError) {
                    window.showError('Please select check-in and check-out dates', 3000);
                }
                return;
            }
            
            if (!this.bookingDetails.checkInTime) {
                if (window.showError) {
                    window.showError('Please select check-in time', 3000);
                }
                return;
            }
            
            if (!this.bookingDetails.isAvailable) {
                if (window.showError) {
                    window.showError('This room is not available for the selected dates', 3000);
                }
                return;
            }
            
            if (this.selectedRoom.status === 'maintenance') {
                if (window.showError) {
                    window.showError('This room is under maintenance and cannot be booked', 3000);
                }
                return;
            }
            
            const bookingData = {
                roomId: parseInt(this.selectedRoom.id),
                guestId: parseInt(this.userId),
                checkInDate: this.bookingDetails.checkIn,
                checkOutDate: this.bookingDetails.checkOut,
                checkInTime: this.bookingDetails.checkInTime + ':00',
                specialRequests: this.bookingDetails.specialRequests || '',
                totalPrice: parseFloat(this.bookingDetails.totalPrice)
            };
            
            if (window.showInfo) {
                window.showInfo('Processing your booking...', 0);
            }
            
            fetch('${pageContext.request.contextPath}/bookings/api/create', {
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
                    
                    this.loadRooms();
        
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