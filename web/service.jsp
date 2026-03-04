<%-- 
    Document   : service
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Services · Ocean View Resort Galle</title>
    <!-- Tailwind via CDN + a touch of subtle overlay & font -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        .hero-glow { text-shadow: 0 8px 20px rgba(0,0,0,0.25); }
        .card-hover { transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .card-hover:hover { transform: translateY(-8px); box-shadow: 0 25px 35px -12px rgba(2, 136, 209, 0.2); }
        .service-icon { transition: all 0.3s ease; }
        .card-hover:hover .service-icon { transform: scale(1.1) rotate(5deg); }
    </style>
</head>
<body class="bg-[#f8fafc] text-[#1e3c5c] antialiased">

    <!-- Include Navbar -->
    <jsp:include page="component/navbar.jsp" />

    <!-- ===== PAGE HEADER / HERO ===== -->
    <section class="relative overflow-hidden -mt-20">
        <!-- background image with ocean overlay - FIXED: removed gap/white line issue -->
        <div class="absolute inset-0 z-0">
            <div class="absolute inset-0 bg-gradient-to-r from-[#022b42]/50 via-[#03738C]/40 to-[#1e3c5c]/50 z-10"></div>
            <img src="https://images.unsplash.com/photo-1540541338287-41700207dee6?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" 
                 alt="Ocean View Resort services" 
                 class="w-full h-full object-cover object-center">
        </div>
        
        <!-- header content -->
        <div class="relative z-20 max-w-6xl mx-auto px-6 md:px-10 py-28 md:py-36 text-center text-white">
            <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold leading-tight hero-glow">Our <span class="text-[#f8e4c3]">Services</span></h1>
            <p class="text-xl md:text-2xl text-[#f0f9ff] mt-4 max-w-3xl mx-auto">Experience unparalleled luxury and comfort with our exclusive resort amenities</p>
            <div class="w-24 h-1 bg-[#f8e4c3] mx-auto mt-6 rounded-full"></div>
        </div>
        
        <!-- wave divider - FIXED: removed any potential gap -->
        <div class="absolute bottom-0 left-0 w-full z-20">
            <svg viewBox="0 0 1440 120" fill="none" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" class="w-full h-16 md:h-24">
                <path d="M0 0L60 15C120 30 240 60 360 65C480 70 600 50 720 40C840 30 960 30 1080 40C1200 50 1320 70 1380 80L1440 90V120H1380C1320 120 1200 120 1080 120C960 120 840 120 720 120C600 120 480 120 360 120C240 120 120 120 60 120H0V0Z" fill="#f8fafc"/>
            </svg>
        </div>
    </section>

    <!-- ===== INTRODUCTION ===== -->
    <section class="py-16 bg-white">
        <div class="max-w-4xl mx-auto px-6 text-center">
            <span class="text-[#0284a8] font-semibold tracking-wider text-sm uppercase">World-class amenities</span>
            <h2 class="text-3xl md:text-4xl font-bold text-[#1e3c5c] mt-3">Everything You Need for the Perfect Stay</h2>
            <p class="text-[#3a5a78] text-lg mt-5 leading-relaxed">From rejuvenating spa treatments to exquisite dining experiences, we offer a wide range of services designed to make your vacation truly unforgettable.</p>
        </div>
    </section>

    <!-- ===== MAIN SERVICES GRID ===== -->
    <section class="bg-[#f0f7fa] py-20">
        <div class="max-w-7xl mx-auto px-6">
            <!-- Spa & Wellness Row -->
            <div class="mb-16">
                <div class="flex items-center gap-3 mb-8">
                    <div class="w-10 h-10 bg-[#0284a8] rounded-lg flex items-center justify-center text-white text-xl">🧘</div>
                    <h3 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Spa & Wellness</h3>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <!-- Service 1 - Ayurveda -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover border border-[#b5e5e0] group">
                        <div class="h-48 overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1544161515-4ab6ce6db874?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80" alt="Ayurveda treatment" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                        </div>
                        <div class="p-6">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="service-icon w-12 h-12 bg-[#b5e5e0] text-[#0284a8] rounded-xl flex items-center justify-center text-2xl">🌿</div>
                                <h4 class="text-xl font-bold text-[#1e3c5c]">Ayurveda Treatments</h4>
                            </div>
                            <p class="text-[#3a5a78]">Traditional Sri Lankan Ayurvedic therapies using natural herbs and oils for complete rejuvenation.</p>
                            <div class="mt-4 flex items-center justify-between">
                                <span class="text-[#0284a8] font-semibold">60-90 min sessions</span>
                                <span class="text-[#d4a373] font-bold">from $75</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Service 2 - Massage -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover border border-[#b5e5e0] group">
                        <div class="h-48 overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1600334129128-685c5582fd35?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80" alt="Ocean massage" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                        </div>
                        <div class="p-6">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="service-icon w-12 h-12 bg-[#b5e5e0] text-[#0284a8] rounded-xl flex items-center justify-center text-2xl">💆</div>
                                <h4 class="text-xl font-bold text-[#1e3c5c]">Ocean Massage</h4>
                            </div>
                            <p class="text-[#3a5a78]">Relaxing massages with ocean views, combining Swedish and deep tissue techniques.</p>
                            <div class="mt-4 flex items-center justify-between">
                                <span class="text-[#0284a8] font-semibold">50/80 min</span>
                                <span class="text-[#d4a373] font-bold">$65/$95</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Service 3 - Yoga -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover border border-[#b5e5e0] group">
                        <div class="h-48 overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1545389336-cf090694435e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1164&q=80" alt="Sunrise yoga" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                        </div>
                        <div class="p-6">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="service-icon w-12 h-12 bg-[#b5e5e0] text-[#0284a8] rounded-xl flex items-center justify-center text-2xl">🧘‍♀️</div>
                                <h4 class="text-xl font-bold text-[#1e3c5c]">Sunrise Yoga</h4>
                            </div>
                            <p class="text-[#3a5a78]">Daily yoga sessions on the beach deck, suitable for all levels with expert instructors.</p>
                            <div class="mt-4 flex items-center justify-between">
                                <span class="text-[#0284a8] font-semibold">6:30 AM daily</span>
                                <span class="text-[#d4a373] font-bold">Complimentary</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Dining & Culinary Row -->
            <div class="mb-16">
                <div class="flex items-center gap-3 mb-8">
                    <div class="w-10 h-10 bg-[#d4a373] rounded-lg flex items-center justify-center text-white text-xl">🍽️</div>
                    <h3 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Dining & Culinary</h3>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <!-- Service 4 - Beachfront Restaurant -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover border border-[#f8e4c3] group">
                        <div class="h-48 overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80" alt="Beachfront dining" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                        </div>
                        <div class="p-6">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="service-icon w-12 h-12 bg-[#f8e4c3] text-[#d4a373] rounded-xl flex items-center justify-center text-2xl">🍴</div>
                                <h4 class="text-xl font-bold text-[#1e3c5c]">Beachfront Restaurant</h4>
                            </div>
                            <p class="text-[#3a5a78]">Fresh seafood and Sri Lankan specialties served with your toes in the sand, sunset views.</p>
                            <div class="mt-4 flex items-center justify-between">
                                <span class="text-[#0284a8] font-semibold">7 AM - 10 PM</span>
                                <span class="text-[#d4a373] font-bold">$$</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Service 5 - Private Dinner -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover border border-[#f8e4c3] group">
                        <div class="h-48 overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1470337458703-46ad1756a187?ixlib=rb-4.0.3&auto=format&fit=crop&w=1169&q=80" alt="Private dinner" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                        </div>
                        <div class="p-6">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="service-icon w-12 h-12 bg-[#f8e4c3] text-[#d4a373] rounded-xl flex items-center justify-center text-2xl">🕯️</div>
                                <h4 class="text-xl font-bold text-[#1e3c5c]">Private Candlelit Dinner</h4>
                            </div>
                            <p class="text-[#3a5a78]">Romantic private dining on the beach or your balcony, personalized menu and service.</p>
                            <div class="mt-4 flex items-center justify-between">
                                <span class="text-[#0284a8] font-semibold">Reservation only</span>
                                <span class="text-[#d4a373] font-bold">from $120/couple</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Service 6 - Cooking Class -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover border border-[#f8e4c3] group">
                        <div class="h-48 overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1556910103-1c02745aae4d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80" alt="Cooking class" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                        </div>
                        <div class="p-6">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="service-icon w-12 h-12 bg-[#f8e4c3] text-[#d4a373] rounded-xl flex items-center justify-center text-2xl">👩‍🍳</div>
                                <h4 class="text-xl font-bold text-[#1e3c5c]">Sri Lankan Cooking Class</h4>
                            </div>
                            <p class="text-[#3a5a78]">Learn to prepare authentic Sri Lankan curries and spices with our master chefs.</p>
                            <div class="mt-4 flex items-center justify-between">
                                <span class="text-[#0284a8] font-semibold">3 hours</span>
                                <span class="text-[#d4a373] font-bold">$65/person</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Activities & Recreation Row -->
            <div class="mb-16">
                <div class="flex items-center gap-3 mb-8">
                    <div class="w-10 h-10 bg-[#03738C] rounded-lg flex items-center justify-center text-white text-xl">🏊</div>
                    <h3 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Activities & Recreation</h3>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <!-- Service 7 - Water Sports -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover border border-[#9ac9c2] group">
                        <div class="h-48 overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1519046904884-53103b34b689?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80" alt="Water sports" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                        </div>
                        <div class="p-6">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="service-icon w-12 h-12 bg-[#9ac9c2] text-[#03738C] rounded-xl flex items-center justify-center text-2xl">🏄</div>
                                <h4 class="text-xl font-bold text-[#1e3c5c]">Water Sports</h4>
                            </div>
                            <p class="text-[#3a5a78]">Jet skiing, snorkeling, paddleboarding, and banana boat rides with professional guides.</p>
                            <div class="mt-4 flex items-center justify-between">
                                <span class="text-[#0284a8] font-semibold">Equipment provided</span>
                                <span class="text-[#d4a373] font-bold">from $45</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Service 8 - Boat Tours -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover border border-[#9ac9c2] group">
                        <div class="h-48 overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1601315488950-3b5047998b38?ixlib=rb-4.0.3&auto=format&fit=crop&w=1172&q=80" alt="Boat tour" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                        </div>
                        <div class="p-6">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="service-icon w-12 h-12 bg-[#9ac9c2] text-[#03738C] rounded-xl flex items-center justify-center text-2xl">🛥️</div>
                                <h4 class="text-xl font-bold text-[#1e3c5c]">Sunset Boat Tours</h4>
                            </div>
                            <p class="text-[#3a5a78]">Private boat trips along the Galle coast, dolphin watching and spectacular sunsets.</p>
                            <div class="mt-4 flex items-center justify-between">
                                <span class="text-[#0284a8] font-semibold">2-3 hours</span>
                                <span class="text-[#d4a373] font-bold">$180/boat</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Service 9 - Cultural Tours -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover border border-[#9ac9c2] group">
                        <div class="h-48 overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1554118811-1e0d58224f24?ixlib=rb-4.0.3&auto=format&fit=crop&w=1147&q=80" alt="Galle Fort" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                        </div>
                        <div class="p-6">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="service-icon w-12 h-12 bg-[#9ac9c2] text-[#03738C] rounded-xl flex items-center justify-center text-2xl">🏛️</div>
                                <h4 class="text-xl font-bold text-[#1e3c5c]">Galle Fort Tours</h4>
                            </div>
                            <p class="text-[#3a5a78]">Guided heritage walks through historic Galle Fort, museums, and local markets.</p>
                            <div class="mt-4 flex items-center justify-between">
                                <span class="text-[#0284a8] font-semibold">Half-day</span>
                                <span class="text-[#d4a373] font-bold">$35/person</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Family & Kids Row -->
            <div>
                <div class="flex items-center gap-3 mb-8">
                    <div class="w-10 h-10 bg-[#d4a373] rounded-lg flex items-center justify-center text-white text-xl">👨‍👩‍👧‍👦</div>
                    <h3 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Family & Kids</h3>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <!-- Service 10 - Kids Club -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover border border-[#f8e4c3] group">
                        <div class="h-48 overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1587653263095-68d2b749965f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80" alt="Kids club" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                        </div>
                        <div class="p-6">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="service-icon w-12 h-12 bg-[#f8e4c3] text-[#d4a373] rounded-xl flex items-center justify-center text-2xl">🎨</div>
                                <h4 class="text-xl font-bold text-[#1e3c5c]">Kids' Club</h4>
                            </div>
                            <p class="text-[#3a5a78]">Supervised activities, games, and crafts for children while parents relax.</p>
                            <div class="mt-4 flex items-center justify-between">
                                <span class="text-[#0284a8] font-semibold">9 AM - 6 PM</span>
                                <span class="text-[#d4a373] font-bold">Complimentary</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Service 11 - Babysitting -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover border border-[#f8e4c3] group">
                        <div class="h-48 overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1075&q=80" alt="Babysitting" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                        </div>
                        <div class="p-6">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="service-icon w-12 h-12 bg-[#f8e4c3] text-[#d4a373] rounded-xl flex items-center justify-center text-2xl">🍼</div>
                                <h4 class="text-xl font-bold text-[#1e3c5c]">Babysitting Service</h4>
                            </div>
                            <p class="text-[#3a5a78]">Professional, caring babysitters available for evening or daytime childcare.</p>
                            <div class="mt-4 flex items-center justify-between">
                                <span class="text-[#0284a8] font-semibold">4-hour minimum</span>
                                <span class="text-[#d4a373] font-bold">$15/hour</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Service 12 - Family Pool -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover border border-[#f8e4c3] group">
                        <div class="h-48 overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1576016775882-36c8b16f6ab6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1169&q=80" alt="Family pool" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                        </div>
                        <div class="p-6">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="service-icon w-12 h-12 bg-[#f8e4c3] text-[#d4a373] rounded-xl flex items-center justify-center text-2xl">🏊‍♀️</div>
                                <h4 class="text-xl font-bold text-[#1e3c5c]">Family Pool</h4>
                            </div>
                            <p class="text-[#3a5a78]">Dedicated children's pool with water slides, fountains, and lifeguard supervision.</p>
                            <div class="mt-4 flex items-center justify-between">
                                <span class="text-[#0284a8] font-semibold">8 AM - 8 PM</span>
                                <span class="text-[#d4a373] font-bold">Free access</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== SPECIAL PACKAGES SECTION ===== -->
    <section class="bg-white py-20">
        <div class="max-w-7xl mx-auto px-6">
            <div class="text-center mb-12">
                <span class="text-[#0284a8] font-semibold tracking-wider text-sm uppercase">Exclusive offers</span>
                <h2 class="text-3xl md:text-4xl font-bold text-[#1e3c5c] mt-3">Special Service Packages</h2>
                <p class="text-[#3a5a78] text-lg mt-4 max-w-2xl mx-auto">Combine services for an enhanced experience at special rates</p>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <!-- Package 1 - Romance -->
                <div class="bg-gradient-to-br from-[#f0f7fa] to-white rounded-3xl shadow-xl overflow-hidden border-2 border-[#f8e4c3] transform hover:scale-105 transition duration-300">
                    <div class="bg-[#f8e4c3] py-4 px-6 text-center">
                        <h3 class="text-2xl font-bold text-[#1e3c5c]">Romantic Escape</h3>
                    </div>
                    <div class="p-8">
                        <div class="text-center mb-6">
                            <span class="text-4xl font-bold text-[#1e3c5c]">$399</span>
                            <span class="text-[#3a5a78]">/couple</span>
                        </div>
                        <ul class="space-y-4">
                            <li class="flex items-center gap-3 text-[#3a5a78]"><span class="text-[#0284a8] text-xl">✓</span> Private candlelit dinner on beach</li>
                            <li class="flex items-center gap-3 text-[#3a5a78]"><span class="text-[#0284a8] text-xl">✓</span> Couples massage (60 min)</li>
                            <li class="flex items-center gap-3 text-[#3a5a78]"><span class="text-[#0284a8] text-xl">✓</span> Sunset boat tour</li>
                            <li class="flex items-center gap-3 text-[#3a5a78]"><span class="text-[#0284a8] text-xl">✓</span> Champagne & strawberries</li>
                        </ul>
                        <a href="#" class="block text-center bg-[#0284a8] hover:bg-[#03738C] text-white font-semibold py-3 rounded-full mt-8 transition">Book Package</a>
                    </div>
                </div>
                
                <!-- Package 2 - Wellness -->
                <div class="bg-gradient-to-br from-[#f0f7fa] to-white rounded-3xl shadow-xl overflow-hidden border-2 border-[#b5e5e0] transform hover:scale-105 transition duration-300 scale-105 md:scale-110 relative z-10">
                    <div class="bg-[#0284a8] py-4 px-6 text-center">
                        <h3 class="text-2xl font-bold text-white">Wellness Retreat</h3>
                        <span class="text-[#f8e4c3] text-sm">Most Popular</span>
                    </div>
                    <div class="p-8">
                        <div class="text-center mb-6">
                            <span class="text-4xl font-bold text-[#1e3c5c]">$299</span>
                            <span class="text-[#3a5a78]">/person</span>
                        </div>
                        <ul class="space-y-4">
                            <li class="flex items-center gap-3 text-[#3a5a78]"><span class="text-[#0284a8] text-xl">✓</span> 3 Ayurveda treatments</li>
                            <li class="flex items-center gap-3 text-[#3a5a78]"><span class="text-[#0284a8] text-xl">✓</span> Daily sunrise yoga</li>
                            <li class="flex items-center gap-3 text-[#3a5a78]"><span class="text-[#0284a8] text-xl">✓</span> Healthy meal plan</li>
                            <li class="flex items-center gap-3 text-[#3a5a78]"><span class="text-[#0284a8] text-xl">✓</span> Meditation sessions</li>
                        </ul>
                        <a href="#" class="block text-center bg-[#0284a8] hover:bg-[#03738C] text-white font-semibold py-3 rounded-full mt-8 transition">Book Package</a>
                    </div>
                </div>
                
                <!-- Package 3 - Family Fun -->
                <div class="bg-gradient-to-br from-[#f0f7fa] to-white rounded-3xl shadow-xl overflow-hidden border-2 border-[#9ac9c2] transform hover:scale-105 transition duration-300">
                    <div class="bg-[#9ac9c2] py-4 px-6 text-center">
                        <h3 class="text-2xl font-bold text-[#1e3c5c]">Family Fun</h3>
                    </div>
                    <div class="p-8">
                        <div class="text-center mb-6">
                            <span class="text-4xl font-bold text-[#1e3c5c]">$549</span>
                            <span class="text-[#3a5a78]">/family (4)</span>
                        </div>
                        <ul class="space-y-4">
                            <li class="flex items-center gap-3 text-[#3a5a78]"><span class="text-[#0284a8] text-xl">✓</span> Water sports for 2 hours</li>
                            <li class="flex items-center gap-3 text-[#3a5a78]"><span class="text-[#0284a8] text-xl">✓</span> Kids' club full day pass</li>
                            <li class="flex items-center gap-3 text-[#3a5a78]"><span class="text-[#0284a8] text-xl">✓</span> Family cooking class</li>
                            <li class="flex items-center gap-3 text-[#3a5a78]"><span class="text-[#0284a8] text-xl">✓</span> Beach picnic lunch</li>
                        </ul>
                        <a href="#" class="block text-center bg-[#0284a8] hover:bg-[#03738C] text-white font-semibold py-3 rounded-full mt-8 transition">Book Package</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="component/footer.jsp" />

</body>
</html>