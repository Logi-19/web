<%-- 
    Document   : index
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · Galle</title>
    <!-- Tailwind via CDN + a touch of subtle overlay & font -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        .hero-glow { text-shadow: 0 8px 20px rgba(0,0,0,0.25); }
        .card-hover { transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .card-hover:hover { transform: translateY(-4px); box-shadow: 0 20px 30px -10px rgba(2, 136, 209, 0.15); }
        .wave-divider {
            background: linear-gradient(180deg, transparent 0%, rgba(178, 223, 219, 0.2) 100%);
        }
    </style>
</head>
<body class="bg-[#f8fafc] text-[#1e3c5c] antialiased">

    <!-- Include Navbar -->
    <jsp:include page="component/navbar.jsp" />
    
    <jsp:include page="component/notification.jsp" />

    <!-- ===== HERO SECTION (with beach vibe) ===== -->
    <section class="relative overflow-hidden -mt-20">
        <!-- background image + soft ocean overlay -->
        <div class="absolute inset-0 z-0">
            <div class="absolute inset-0 bg-gradient-to-r from-[#022b42]/40 via-[#03738C]/30 to-[#6ab0a8]/30 z-10"></div> <!-- ocean-inspired gradient overlay -->
            <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" 
                 alt="Ocean view resort beachfront" 
                 class="w-full h-full object-cover object-center">
        </div>
        <!-- hero content -->
        <div class="relative z-20 max-w-6xl mx-auto px-6 md:px-10 py-16 md:py-24 text-white">
            <div class="max-w-2xl">
                <span class="inline-block bg-[#b0e0e6]/30 backdrop-blur-sm px-4 py-1.5 rounded-full text-sm font-medium border border-[#caf0f8]/40 mb-6 text-[#f0f9ff]">🌞 Welcome to paradise · Galle, Sri Lanka</span>
                <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold leading-tight hero-glow">Ocean View <br><span class="text-[#f8e4c3]">Resort</span></h1>
                <p class="text-lg md:text-xl text-[#f0f9ff] mt-6 max-w-xl">Your beachside escape in Galle — where golden shores meet timeless comfort. Hundreds of happy guests every month.</p>
                <!-- CTA row -->
                <div class="flex flex-wrap gap-4 mt-8">
                    <a href="#" class="bg-[#e6c9a8] hover:bg-[#d4b185] text-[#1e3c5c] font-semibold px-7 py-3.5 rounded-full shadow-xl text-base transition flex items-center gap-2">
                        <span>✨</span> check availability
                    </a>
                    <a href="#" class="bg-[#03738C]/30 backdrop-blur-sm hover:bg-[#0284a8]/40 border border-[#9ed9e6]/50 text-white font-medium px-7 py-3.5 rounded-full transition">
                        explore resort
                    </a>
                </div>
                
            </div>
        </div>
        <!-- subtle wave divider with seafoam tint -->
        <div class="relative z-20 -mb-1 w-full rotate-180 text-[#b5e5e0]">
            <svg viewBox="0 0 1440 120" fill="none" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" class="w-full h-12 md:h-16 opacity-40">
                <path d="M0 0L60 15C120 30 240 60 360 65C480 70 600 50 720 40C840 30 960 30 1080 40C1200 50 1320 70 1380 80L1440 90V120H1380C1320 120 1200 120 1080 120C960 120 840 120 720 120C600 120 480 120 360 120C240 120 120 120 60 120H0V0Z" fill="currentColor" fill-opacity="0.8"/>
            </svg>
        </div>
    </section>

    <!-- ===== INTRO / WELCOME BLURB ===== -->
    <section class="bg-gradient-to-b from-white to-[#f0f7fa] py-12 md:py-16">
        <div class="max-w-5xl mx-auto px-6 text-center">
            <span class="text-[#0284a8] font-semibold tracking-wider text-sm uppercase">Ocean View Resort · since 1998</span>
            <h2 class="text-3xl md:text-4xl font-bold text-[#1e3c5c] mt-3">Where the waves greet you</h2>
            <p class="text-[#3a5a78] text-lg mt-5 max-w-3xl mx-auto leading-relaxed">Perched along the unspoiled coast of Galle, we've had the privilege of serving hundreds of guests each month. Whether it's a romantic getaway or a family holiday, our beachside rooms and warm hospitality make every stay unforgettable.</p>
        </div>
    </section>

    <!-- ===== HIGHLIGHTS / AMENITIES  (cards) ===== -->
    <section class="bg-[#f0f7fa] py-14 md:py-20">
        <div class="max-w-7xl mx-auto px-6">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <!-- card 1 - ocean theme -->
                <div class="bg-white/90 backdrop-blur-sm rounded-3xl shadow-lg overflow-hidden card-hover border border-[#b5e5e0]">
                    <div class="h-52 bg-cover bg-center" style="background-image: url('https://images.unsplash.com/photo-1582719508461-905c673771fd?ixlib=rb-4.0.3&auto=format&fit=crop&w=1025&q=80');"></div>
                    <div class="p-7">
                        <div class="w-12 h-12 bg-[#b5e5e0] text-[#0284a8] rounded-2xl flex items-center justify-center text-3xl mb-5">🛏️</div>
                        <h3 class="text-2xl font-bold text-[#1e3c5c]">Luxury rooms</h3>
                        <p class="text-[#3a5a78] mt-3 leading-relaxed">Wake up to ocean breezes. Each room blends modern comfort with coastal charm — private balcony, soft linens, and stunning views.</p>
                        <a href="#" class="inline-flex items-center gap-1 text-[#0284a8] font-medium mt-5 text-sm hover:underline">Explore rooms →</a>
                    </div>
                </div>
                <!-- card 2 - sand/sunset theme -->
                <div class="bg-white/90 backdrop-blur-sm rounded-3xl shadow-lg overflow-hidden card-hover border border-[#f8e4c3]">
                    <div class="h-52 bg-cover bg-center" style="background-image: url('https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80');"></div>
                    <div class="p-7">
                        <div class="w-12 h-12 bg-[#f8e4c3] text-[#d4a373] rounded-2xl flex items-center justify-center text-3xl mb-5">🍽️</div>
                        <h3 class="text-2xl font-bold text-[#1e3c5c]">Beachfront dining</h3>
                        <p class="text-[#3a5a78] mt-3 leading-relaxed">Fresh catch of the day, Sri Lankan spices, and tropical fruits. Enjoy your meal with your toes in the sand and sunset views.</p>
                        <a href="#" class="inline-flex items-center gap-1 text-[#d4a373] font-medium mt-5 text-sm hover:underline">View menus →</a>
                    </div>
                </div>
                <!-- card 3 - seafoam theme -->
                <div class="bg-white/90 backdrop-blur-sm rounded-3xl shadow-lg overflow-hidden card-hover border border-[#9ac9c2]">
                    <div class="h-52 bg-cover bg-center" style="background-image: url('https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1160&q=80');"></div>
                    <div class="p-7">
                        <div class="w-12 h-12 bg-[#9ac9c2] text-[#03738C] rounded-2xl flex items-center justify-center text-3xl mb-5">🧘</div>
                        <h3 class="text-2xl font-bold text-[#1e3c5c]">Wellness & leisure</h3>
                        <p class="text-[#3a5a78] mt-3 leading-relaxed">Dip in the infinity pool, book an Ayurveda massage, or join a morning yoga session — all overlooking the Indian Ocean.</p>
                        <a href="#" class="inline-flex items-center gap-1 text-[#03738C] font-medium mt-5 text-sm hover:underline">Spa & more →</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== STATS / SOCIAL PROOF ===== -->
    <section class="bg-gradient-to-r from-[#1e3c5c] to-[#03738C] text-white py-16">
        <div class="max-w-6xl mx-auto px-6 grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
            <div>
                <div class="text-4xl font-black text-[#f8e4c3]">350+</div>
                <div class="text-[#b5e5e0] text-sm uppercase tracking-wider mt-2">monthly guests</div>
            </div>
            <div>
                <div class="text-4xl font-black text-[#f8e4c3]">82</div>
                <div class="text-[#b5e5e0] text-sm uppercase tracking-wider mt-2">luxury rooms</div>
            </div>
            <div>
                <div class="text-4xl font-black text-[#f8e4c3]">15yrs</div>
                <div class="text-[#b5e5e0] text-sm uppercase tracking-wider mt-2">hospitality excellence</div>
            </div>
            <div>
                <div class="text-4xl font-black text-[#f8e4c3]">⨯2</div>
                <div class="text-[#b5e5e0] text-sm uppercase tracking-wider mt-2">beachfront restaurants</div>
            </div>
        </div>
    </section>

    <!-- ===== ROOM PREVIEW / GALLERY SNEAK PEEK ===== -->
    <section class="bg-gradient-to-b from-white to-[#f0f7fa] py-16">
        <div class="max-w-7xl mx-auto px-6">
            <div class="flex flex-wrap items-end justify-between gap-4 mb-10">
                <div>
                    <span class="text-[#0284a8] font-semibold text-sm uppercase">stay in style</span>
                    <h3 class="text-3xl md:text-4xl font-bold text-[#1e3c5c] mt-1">Choose your view</h3>
                </div>
                <a href="#" class="text-[#0284a8] font-medium flex items-center gap-1 hover:gap-2 transition-all">View all rooms <span>→</span></a>
            </div>
            <div class="grid md:grid-cols-3 gap-6">
                <!-- room card 1 - ocean -->
                <div class="rounded-2xl overflow-hidden shadow-md hover:shadow-xl transition bg-white border border-[#b5e5e0]">
                    <img src="https://images.unsplash.com/photo-1618773928121-c32242e63f39?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80" alt="deluxe ocean" class="h-64 w-full object-cover">
                    <div class="p-5">
                        <div class="flex justify-between items-center">
                            <h4 class="font-bold text-xl text-[#1e3c5c]">Deluxe Ocean</h4>
                            <span class="bg-[#b5e5e0] text-[#03738C] px-3 py-1 rounded-full text-xs font-bold">🌊 sea view</span>
                        </div>
                        <p class="text-[#3a5a78] mt-2">King bed · private balcony</p>
                        <div class="flex justify-between items-center mt-4">
                            <span class="text-2xl font-bold text-[#1e3c5c]">$189<span class="text-sm font-normal text-[#3a5a78]">/night</span></span>
                            <a href="#" class="bg-[#0284a8] hover:bg-[#03738C] text-white px-4 py-2 rounded-full text-sm transition">book</a>
                        </div>
                    </div>
                </div>
                <!-- room card 2 - beachfront -->
                <div class="rounded-2xl overflow-hidden shadow-md hover:shadow-xl transition bg-white border border-[#f8e4c3]">
                    <img src="https://images.unsplash.com/photo-1591088398332-8a7791972843?ixlib=rb-4.0.3&auto=format&fit=crop&w=1074&q=80" alt="beachfront suite" class="h-64 w-full object-cover">
                    <div class="p-5">
                        <div class="flex justify-between items-center">
                            <h4 class="font-bold text-xl text-[#1e3c5c]">Beachfront Suite</h4>
                            <span class="bg-[#f8e4c3] text-[#d4a373] px-3 py-1 rounded-full text-xs font-bold">🏖️ private deck</span>
                        </div>
                        <p class="text-[#3a5a78] mt-2">Separate living · outdoor shower</p>
                        <div class="flex justify-between items-center mt-4">
                            <span class="text-2xl font-bold text-[#1e3c5c]">$299<span class="text-sm font-normal text-[#3a5a78]">/night</span></span>
                            <a href="#" class="bg-[#0284a8] hover:bg-[#03738C] text-white px-4 py-2 rounded-full text-sm transition">book</a>
                        </div>
                    </div>
                </div>
                <!-- room card 3 - garden -->
                <div class="rounded-2xl overflow-hidden shadow-md hover:shadow-xl transition bg-white border border-[#9ac9c2]">
                    <img src="https://images.unsplash.com/photo-1566665797739-1674de7a421a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1074&q=80" alt="garden view" class="h-64 w-full object-cover">
                    <div class="p-5">
                        <div class="flex justify-between items-center">
                            <h4 class="font-bold text-xl text-[#1e3c5c]">Garden View</h4>
                            <span class="bg-[#9ac9c2] text-[#03738C] px-3 py-1 rounded-full text-xs font-bold">🌿 lush</span>
                        </div>
                        <p class="text-[#3a5a78] mt-2">Twin/King · tropical garden access</p>
                        <div class="flex justify-between items-center mt-4">
                            <span class="text-2xl font-bold text-[#1e3c5c]">$139<span class="text-sm font-normal text-[#3a5a78]">/night</span></span>
                            <a href="#" class="bg-[#0284a8] hover:bg-[#03738C] text-white px-4 py-2 rounded-full text-sm transition">book</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== TESTIMONIAL / REVIEW ===== -->
    <section class="bg-[#f0f7fa] py-16">
        <div class="max-w-4xl mx-auto px-6 text-center">
            <span class="text-[#f8e4c3] text-4xl mb-2 block">“</span>
            <p class="text-2xl md:text-3xl text-[#1e3c5c] italic font-light leading-relaxed">Absolutely stunning location — woke up to the sound of waves. The staff treated us like family. Already planning our next visit to Ocean View Resort.</p>
            <div class="flex items-center justify-center gap-2 mt-8">
                <div class="w-12 h-12 rounded-full bg-[#b5e5e0] flex items-center justify-center text-2xl">👩🏽‍🦰</div>
                <div class="text-left">
                    <strong class="block text-[#1e3c5c]">Nimali Perera</strong>
                    <span class="text-[#3a5a78] text-sm">guest from Colombo · stayed 5 nights</span>
                </div>
            </div>
        </div>
    </section>

    
    <jsp:include page="feedback.jsp" />
    
    <jsp:include page="feedbackview.jsp" />

    <!-- Include Footer -->
    <jsp:include page="component/footer.jsp" />

</body>
</html>