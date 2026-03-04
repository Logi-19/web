<%-- 
    Document   : footer
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- ===== FOOTER COMPONENT ===== -->
<footer class="bg-gradient-to-r from-[#1e3c5c] to-[#03738C] text-[#f0f9ff] pt-16 pb-8 relative overflow-hidden">
    <!-- Decorative wave element at top -->
    <div class="absolute top-0 left-0 w-full rotate-180">
        <svg viewBox="0 0 1440 120" fill="none" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" class="w-full h-8 opacity-20">
            <path d="M0 0L60 15C120 30 240 60 360 65C480 70 600 50 720 40C840 30 960 30 1080 40C1200 50 1320 70 1380 80L1440 90V120H1380C1320 120 1200 120 1080 120C960 120 840 120 720 120C600 120 480 120 360 120C240 120 120 120 60 120H0V0Z" fill="white"/>
        </svg>
    </div>
    
    <!-- Background decorative elements -->
    <div class="absolute inset-0 overflow-hidden">
        <div class="absolute -bottom-10 -right-10 w-64 h-64 bg-[#b5e5e0]/10 rounded-full blur-3xl"></div>
        <div class="absolute -top-10 -left-10 w-64 h-64 bg-[#f8e4c3]/10 rounded-full blur-3xl"></div>
    </div>
    
    <div class="max-w-7xl mx-auto px-6 relative z-10">
        <!-- Main Footer Content -->
        <div class="grid md:grid-cols-4 gap-8 lg:gap-12">
            <!-- Brand Column -->
            <div class="space-y-4">
                <div class="flex items-center gap-2">
                    <div class="w-10 h-10 bg-gradient-to-br from-[#0284a8] to-[#9ac9c2] rounded-xl flex items-center justify-center text-white font-bold text-xl shadow-lg transform hover:scale-110 transition duration-300">🌊</div>
                    <h4 class="text-white font-bold text-xl">Ocean View <span class="text-[#f8e4c3]">Resort</span></h4>
                </div>
                <p class="text-sm leading-relaxed text-[#b5e5e0]">Experience unparalleled luxury and warm Sri Lankan hospitality on the beautiful shores of Galle.</p>
                
                <!-- Social Media Links - showing normally (not white) -->
                <div class="flex gap-3 pt-3 flex-wrap">
                    <a href="#" class="w-10 h-10 bg-white/10 hover:bg-[#0284a8] rounded-full flex items-center justify-center text-white hover:text-white transition-all duration-300 transform hover:scale-110 hover:rotate-6 border border-[#b5e5e0]/30">
                        <img src="https://cdn-icons-png.flaticon.com/128/5968/5968764.png" alt="Facebook" class="w-5 h-5">
                    </a>
                    <a href="#" class="w-10 h-10 bg-white/10 hover:bg-[#0284a8] rounded-full flex items-center justify-center text-white hover:text-white transition-all duration-300 transform hover:scale-110 hover:rotate-6 border border-[#b5e5e0]/30">
                        <img src="https://cdn-icons-png.flaticon.com/128/15707/15707749.png" alt="Instagram" class="w-5 h-5">
                    </a>
                    <a href="#" class="w-10 h-10 bg-white/10 hover:bg-[#0284a8] rounded-full flex items-center justify-center text-white hover:text-white transition-all duration-300 transform hover:scale-110 hover:rotate-6 border border-[#b5e5e0]/30">
                        <img src="https://cdn-icons-png.flaticon.com/128/4782/4782345.png" alt="TikTok" class="w-5 h-5">
                    </a>
                    <a href="#" class="w-10 h-10 bg-white/10 hover:bg-[#0284a8] rounded-full flex items-center justify-center text-white hover:text-white transition-all duration-300 transform hover:scale-110 hover:rotate-6 border border-[#b5e5e0]/30">
                        <img src="https://cdn-icons-png.flaticon.com/128/5969/5969020.png" alt="X (Twitter)" class="w-5 h-5">
                    </a>
                    <a href="#" class="w-10 h-10 bg-white/10 hover:bg-[#0284a8] rounded-full flex items-center justify-center text-white hover:text-white transition-all duration-300 transform hover:scale-110 hover:rotate-6 border border-[#b5e5e0]/30">
                        <img src="https://cdn-icons-png.flaticon.com/128/15707/15707820.png" alt="WhatsApp" class="w-5 h-5">
                    </a>
                </div>
            </div>
            
            <!-- Quick Links Column - Updated to match navbar structure -->
            <div>
                <h5 class="text-white font-semibold text-lg mb-4 flex items-center gap-2">
                    <span class="w-1 h-5 bg-[#f8e4c3] rounded-full"></span>
                    Quick Links
                </h5>
                <ul class="space-y-3 text-sm">
                    <li><a href="index.jsp" class="text-[#b5e5e0] hover:text-[#f8e4c3] transition flex items-center gap-2 group">
                        <span class="group-hover:translate-x-1 transition">→</span> Home
                    </a></li>
                    <li><a href="#" class="text-[#b5e5e0] hover:text-[#f8e4c3] transition flex items-center gap-2 group">
                        <span class="group-hover:translate-x-1 transition">→</span> Rooms
                    </a></li>
                    <li><a href="#" class="text-[#b5e5e0] hover:text-[#f8e4c3] transition flex items-center gap-2 group">
                        <span class="group-hover:translate-x-1 transition">→</span> Dine In
                    </a></li>
                    <li><a href="service.jsp" class="text-[#b5e5e0] hover:text-[#f8e4c3] transition flex items-center gap-2 group">
                        <span class="group-hover:translate-x-1 transition">→</span> Services
                    </a></li>
                    <li><a href="#" class="text-[#b5e5e0] hover:text-[#f8e4c3] transition flex items-center gap-2 group">
                        <span class="group-hover:translate-x-1 transition">→</span> Gallery
                    </a></li>
                    <li><a href="#" class="text-[#b5e5e0] hover:text-[#f8e4c3] transition flex items-center gap-2 group">
                        <span class="group-hover:translate-x-1 transition">→</span> Blogs
                    </a></li>
                    <li><a href="#" class="text-[#b5e5e0] hover:text-[#f8e4c3] transition flex items-center gap-2 group">
                        <span class="group-hover:translate-x-1 transition">→</span> Contact
                    </a></li>
                </ul>
            </div>
            
            <!-- Book Now Dropdown Links Column (matches navbar Book Now dropdown) -->
            <div>
                <h5 class="text-white font-semibold text-lg mb-4 flex items-center gap-2">
                    <span class="w-1 h-5 bg-[#f8e4c3] rounded-full"></span>
                    Book Now
                </h5>
                <ul class="space-y-3 text-sm">
                    <li><a href="#" class="text-[#b5e5e0] hover:text-[#f8e4c3] transition flex items-center gap-2 group">
                        <span class="text-[#0284a8] mr-2">🏨</span> Room Reservation
                    </a></li>
                    <li><a href="#" class="text-[#b5e5e0] hover:text-[#f8e4c3] transition flex items-center gap-2 group">
                        <span class="text-[#d4a373] mr-2">🍽️</span> Dine In (Table Book)
                    </a></li>
                    <li><a href="service.jsp" class="text-[#b5e5e0] hover:text-[#f8e4c3] transition flex items-center gap-2 group">
                        <span class="text-[#03738C] mr-2">💆</span> Book a Service
                    </a></li>
                </ul>
                
                <!-- Stories & Moments from navbar -->
                <h5 class="text-white font-semibold text-lg mb-4 mt-6 flex items-center gap-2">
                    <span class="w-1 h-5 bg-[#f8e4c3] rounded-full"></span>
                    Stories & Moments
                </h5>
                <ul class="space-y-3 text-sm">
                    <li><a href="#" class="text-[#b5e5e0] hover:text-[#f8e4c3] transition flex items-center gap-2 group">
                        <span class="text-[#0284a8] mr-2">🖼️</span> Gallery
                    </a></li>
                    <li><a href="#" class="text-[#b5e5e0] hover:text-[#f8e4c3] transition flex items-center gap-2 group">
                        <span class="text-[#d4a373] mr-2">📝</span> Blogs
                    </a></li>
                </ul>
            </div>
            
            <!-- Contact & Support Column -->
            <div>
                <h5 class="text-white font-semibold text-lg mb-4 flex items-center gap-2">
                    <span class="w-1 h-5 bg-[#f8e4c3] rounded-full"></span>
                    Contact & Support
                </h5>
                <ul class="space-y-4 text-sm text-[#b5e5e0]">
                    <li class="flex items-start gap-3 group">
                        <span class="text-[#f8e4c3] text-lg group-hover:scale-110 transition">📞</span>
                        <div>
                            <span class="block text-white text-xs">Phone</span>
                            <a href="tel:+94771234567" class="hover:text-[#f8e4c3] transition">+94 77 123 4567</a>
                        </div>
                    </li>
                    <li class="flex items-start gap-3 group">
                        <span class="text-[#f8e4c3] text-lg group-hover:scale-110 transition">📧</span>
                        <div>
                            <span class="block text-white text-xs">Email</span>
                            <a href="mailto:stay@oceanview.lk" class="hover:text-[#f8e4c3] transition">stay@oceanview.lk</a>
                        </div>
                    </li>
                    <li class="flex items-start gap-3 group">
                        <span class="text-[#f8e4c3] text-lg group-hover:scale-110 transition">📍</span>
                        <div>
                            <span class="block text-white text-xs">Address</span>
                            <span>Galle beach road, <br>Sri Lanka</span>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        
        <!-- Bottom Bar -->
        <div class="border-t border-[#b5e5e0]/20 mt-8 pt-6 text-xs text-[#b5e5e0] flex flex-wrap justify-between items-center">
            <span>© 2026 Ocean View Resort. All rights reserved.</span>
            <div class="flex gap-6">
                <a href="#" class="hover:text-[#f8e4c3] transition">Privacy Policy</a>
                <a href="#" class="hover:text-[#f8e4c3] transition">Terms of Service</a>
                <a href="#" class="hover:text-[#f8e4c3] transition">Sitemap</a>
            </div>
            <span class="flex items-center gap-1">🌴 designed by Kiru</span>
        </div>
    </div>
</footer>