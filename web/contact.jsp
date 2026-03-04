<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="wepapp.model.Contact"%>
<%@page import="wepapp.service.ContactService"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us · Ocean View Resort Galle</title>
    <!-- Tailwind via CDN + subtle overlay & font -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        .hero-glow { text-shadow: 0 8px 20px rgba(0,0,0,0.25); }
        .card-hover { transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .card-hover:hover { transform: translateY(-8px); box-shadow: 0 25px 35px -12px rgba(2, 136, 209, 0.2); }
        .map-container iframe { filter: none; } /* original google colours */
        .form-input-focus { transition: all 0.2s ease; }
        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #0284a8;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            animation: spin 1s linear infinite;
            display: inline-block;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body class="bg-[#f8fafc] text-[#1e3c5c] antialiased">

    <!-- Include Navbar -->
    <jsp:include page="component/navbar.jsp" />
    
    <!-- Include Notification Component -->
    <jsp:include page="component/notification.jsp" />

    <!-- ===== PAGE HEADER / HERO (contact theme) ===== -->
    <section class="relative overflow-hidden -mt-20">
        <div class="absolute inset-0 z-0">
            <div class="absolute inset-0 bg-gradient-to-r from-[#022b42]/60 via-[#03738C]/50 to-[#1e3c5c]/60 z-10"></div>
            <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" 
                 alt="Ocean View Resort contact" 
                 class="w-full h-full object-cover object-center">
        </div>
        
        <div class="relative z-20 max-w-6xl mx-auto px-6 md:px-10 py-28 md:py-36 text-center text-white">
            <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold leading-tight hero-glow">Get in <span class="text-[#f8e4c3]">Touch</span></h1>
            <p class="text-xl md:text-2xl text-[#f0f9ff] mt-4 max-w-3xl mx-auto">We'd love to hear from you — reach out with questions or special requests</p>
            <div class="w-24 h-1 bg-[#f8e4c3] mx-auto mt-6 rounded-full"></div>
        </div>
        
        <!-- wave divider -->
        <div class="absolute bottom-0 left-0 w-full z-20">
            <svg viewBox="0 0 1440 120" fill="none" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" class="w-full h-16 md:h-24">
                <path d="M0 0L60 15C120 30 240 60 360 65C480 70 600 50 720 40C840 30 960 30 1080 40C1200 50 1320 70 1380 80L1440 90V120H1380C1320 120 1200 120 1080 120C960 120 840 120 720 120C600 120 480 120 360 120C240 120 120 120 60 120H0V0Z" fill="#f8fafc"/>
            </svg>
        </div>
    </section>

    <!-- ===== MAP SECTION – FULL WIDTH, ORIGINAL GOOGLE DESIGN ===== -->
    <section class="w-full bg-white pt-8 md:pt-12">
        <div class="max-w-7xl mx-auto px-6">
            <div class="text-center mb-8">
                <span class="text-[#0284a8] font-semibold tracking-wider text-sm uppercase">find us easily</span>
                <h2 class="text-3xl md:text-4xl font-bold text-[#1e3c5c] mt-2">Our location on the map</h2>
                <div class="w-20 h-0.5 bg-[#d4a373] mx-auto mt-3"></div>
            </div>
        </div>
        <!-- full-bleed map container -->
        <div class="w-full h-[400px] md:h-[480px] lg:h-[520px] map-container shadow-xl">
            <iframe 
                class="w-full h-full"
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d126894.37418719196!2d80.16694757565806!3d6.032326977624757!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3ae173bb6b61c6b9%3A0x53e9e0d4b7f7b0c!2sGalle%20Fort!5e0!3m2!1sen!2slk!4v1711456789012!5m2!1sen!2slk"
                style="border:0;" 
                allowfullscreen="" 
                loading="lazy" 
                referrerpolicy="no-referrer-when-downgrade">
            </iframe>
        </div>
    </section>

    <!-- ===== FORM + DECORATIVE CARDS SECTION (form above, cards below) ===== -->
    <section class="bg-gradient-to-b from-[#f0f7fa] to-white py-16 md:py-20">
        <div class="max-w-4xl mx-auto px-6">
            
            <!-- CONTACT FORM (centered, full width) -->
            <div class="bg-white rounded-3xl shadow-2xl p-8 md:p-10 border border-[#d1e7e3] relative overflow-hidden mb-12">
                <!-- decorative wave -->
                <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-[#0284a8] via-[#d4a373] to-[#0284a8]"></div>
                
                <div class="flex flex-col items-center text-center mb-6">
                    <img src="https://cdn-icons-png.flaticon.com/128/134/134909.png" alt="message" class="w-14 h-14 mb-3">
                    <h2 class="text-3xl md:text-4xl font-bold text-[#1e3c5c]">Send us a message</h2>
                    <p class="text-[#3a5a78] text-lg mt-2">Our team will respond within 24 hours</p>
                </div>

                <form id="contactForm" action="${pageContext.request.contextPath}/contact/submit" method="post" class="space-y-5">
                    <!-- name -->
                    <div>
                        <label for="name" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2">
                            <img src="https://cdn-icons-png.flaticon.com/128/10082/10082884.png" alt="name" class="w-5 h-5"> Full name <span class="text-[#d4a373]">*</span>
                        </label>
                        <input type="text" id="name" name="name" required 
                               class="w-full px-5 py-4 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white text-[#1e3c5c] placeholder-[#8fa8bc] text-lg"
                               placeholder="Samitha Perera">
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <!-- email -->
                        <div>
                            <label for="email" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2">
                                <img src="https://cdn-icons-png.flaticon.com/128/732/732200.png" alt="email" class="w-5 h-5"> Email <span class="text-[#d4a373]">*</span>
                            </label>
                            <input type="email" id="email" name="email" required 
                                   class="w-full px-5 py-4 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white text-[#1e3c5c] placeholder-[#8fa8bc] text-lg"
                                   placeholder="you@example.com">
                        </div>
                        <!-- phone -->
                        <div>
                            <label for="phone" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2">
                                <img src="https://cdn-icons-png.flaticon.com/128/9639/9639598.png" alt="phone" class="w-5 h-5"> Phone
                            </label>
                            <input type="tel" id="phone" name="phone" 
                                   class="w-full px-5 py-4 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white text-[#1e3c5c] placeholder-[#8fa8bc] text-lg"
                                   placeholder="+94 77 123 4567">
                        </div>
                    </div>

                    <!-- preferred reply -->
                    <div>
                        <label class="block text-[#1e3c5c] font-medium mb-2">Preferred reply method <span class="text-[#d4a373]">*</span> </label>
                        <div class="flex gap-6">
                            <label class="flex items-center gap-2 cursor-pointer">
                                <input type="radio" name="replyMethod" value="email" checked class="accent-[#0284a8] w-4 h-4"> 
                                <span class="text-[#1e3c5c]">Email</span>
                            </label>
                            <label class="flex items-center gap-2 cursor-pointer">
                                <input type="radio" name="replyMethod" value="phone" class="accent-[#0284a8] w-4 h-4"> 
                                <span class="text-[#1e3c5c]">Phone</span>
                            </label>
                            <label class="flex items-center gap-2 cursor-pointer">
                                <input type="radio" name="replyMethod" value="both" class="accent-[#0284a8] w-4 h-4"> 
                                <span class="text-[#1e3c5c]">Both</span>
                            </label>
                        </div>
                    </div>

                    <!-- message -->
                    <div>
                        <label for="message" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2">
                            <img src="https://cdn-icons-png.flaticon.com/128/134/134909.png" alt="message" class="w-5 h-5"> Message <span class="text-[#d4a373]">*</span>
                        </label>
                        <textarea id="message" name="message" rows="4" required 
                                  class="w-full px-5 py-4 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white text-[#1e3c5c] placeholder-[#8fa8bc] text-lg resize-none"
                                  placeholder="How can we help you?"></textarea>
                    </div>

                    <button type="submit" id="submitBtn"
                            class="w-full bg-gradient-to-r from-[#0284a8] to-[#03738C] hover:from-[#03738C] hover:to-[#025c73] text-white font-bold py-4 px-6 rounded-xl text-xl transition-all transform hover:scale-[1.02] shadow-lg flex items-center justify-center gap-3">
                        <span>✉️</span> Send message
                    </button>
                </form>
                <p class="text-center text-sm text-[#6b8da8] mt-6">We respect your privacy – your information is safe with us.</p>
            </div>

            <!-- DECORATIVE CONTACT DETAILS (three cards: phone, email, address) -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Phone card -->
                <div class="bg-white/90 backdrop-blur-sm p-6 rounded-2xl border border-[#d4e8e8] shadow-md hover:shadow-xl transition-all flex flex-col items-center text-center card-hover">
                    <img src="https://cdn-icons-png.flaticon.com/128/9639/9639598.png" alt="phone" class="w-14 h-14 mb-4">
                    <div class="font-semibold text-[#1e3c5c] text-xl">Phone</div>
                    <div class="text-[#0284a8] text-2xl font-medium mt-2">+94 77 123 4567</div>
                    <div class="text-sm text-[#5a7a98] mt-2">24/7 guest support</div>
                </div>
                <!-- Email card -->
                <div class="bg-white/90 backdrop-blur-sm p-6 rounded-2xl border border-[#d4e8e8] shadow-md hover:shadow-xl transition-all flex flex-col items-center text-center card-hover">
                    <img src="https://cdn-icons-png.flaticon.com/128/732/732200.png" alt="email" class="w-14 h-14 mb-4">
                    <div class="font-semibold text-[#1e3c5c] text-xl">Email</div>
                    <div class="text-[#0284a8] text-2xl font-medium mt-2">stay@oceangalle.com</div>
                    <div class="text-sm text-[#5a7a98] mt-2">reservations & inquiries</div>
                </div>
                <!-- Address card -->
                <div class="bg-white/90 backdrop-blur-sm p-6 rounded-2xl border border-[#d4e8e8] shadow-md hover:shadow-xl transition-all flex flex-col items-center text-center card-hover">
                    <img src="https://cdn-icons-png.flaticon.com/128/149/149059.png" alt="location" class="w-14 h-14 mb-4">
                    <div class="font-semibold text-[#1e3c5c] text-xl">Address</div>
                    <div class="text-[#3a5a78] text-lg mt-2">480, Colombo Rd,<br>Galle 80000, Sri Lanka</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="component/footer.jsp" />

    <!-- Form handling with AJAX -->
    <script>
        document.getElementById('contactForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            // Get form values
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const message = document.getElementById('message').value.trim();
            const replyMethod = document.querySelector('input[name="replyMethod"]:checked').value;
            
            // Simple validation
            if (!name || !email || !message) {
                showError('Please fill in all required fields.');
                return false;
            }
            
            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                showError('Please enter a valid email address.');
                return false;
            }
            
            // Phone validation (optional but if provided, check format)
            if (phone) {
                const phoneRegex = /^\+?[0-9]{10,14}$/;
                if (!phoneRegex.test(phone.replace(/\s/g, ''))) {
                    showError('Please enter a valid phone number (e.g., +94771234567)');
                    return false;
                }
            }
            
            // Disable submit button and show loading
            const submitBtn = document.getElementById('submitBtn');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<span class="loading-spinner"></span> Sending...';
            submitBtn.disabled = true;
            
            try {
                // Prepare form data
                const formData = new URLSearchParams();
                formData.append('name', name);
                formData.append('email', email);
                formData.append('phone', phone);
                formData.append('message', message);
                formData.append('replyMethod', replyMethod);
                
                // Send AJAX request
                const response = await fetch('${pageContext.request.contextPath}/contact/submit', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData.toString()
                });
                
                const result = await response.json();
                
                if (result.success) {
                    // Show success message
                    showSuccess(result.message);
                    
                    // Clear form
                    document.getElementById('contactForm').reset();
                } else {
                    // Show error message
                    showError(result.message);
                }
            } catch (error) {
                console.error('Error:', error);
                showError('An error occurred. Please try again.');
            } finally {
                // Re-enable submit button
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            }
            
            return false;
        });
    </script>
</body>
</html>