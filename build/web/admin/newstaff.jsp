<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Registration · Ocean View Resort Galle</title>
    <!-- Tailwind via CDN + subtle overlay & font -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        .hero-glow { text-shadow: 0 8px 20px rgba(0,0,0,0.25); }
        .card-hover { transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .card-hover:hover { transform: translateY(-8px); box-shadow: 0 25px 35px -12px rgba(2, 136, 209, 0.2); }
        
        /* Full background image with overlay */
        .register-bg {
            background-image: url('https://images.unsplash.com/photo-1582719508461-905c673771fd?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            position: relative;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .register-bg::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(2, 43, 66, 0.85) 0%, rgba(3, 115, 140, 0.75) 50%, rgba(30, 60, 92, 0.85) 100%);
            z-index: 1;
        }
        
        .register-content {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 700px;
            padding: 1.5rem;
        }
        
        /* Scrollable form for smaller screens */
        @media (max-height: 800px) {
            .register-content {
                padding: 1rem;
            }
            .scrollable-form {
                max-height: 70vh;
                overflow-y: auto;
                padding-right: 0.5rem;
            }
            .scrollable-form::-webkit-scrollbar {
                width: 5px;
            }
            .scrollable-form::-webkit-scrollbar-track {
                background: rgba(255,255,255,0.1);
                border-radius: 10px;
            }
            .scrollable-form::-webkit-scrollbar-thumb {
                background: rgba(2, 132, 168, 0.5);
                border-radius: 10px;
            }
        }
        
        /* Style for select dropdown */
        select {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%238fa8bc' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1.2rem;
        }
        
        /* Password strength meter */
        .strength-meter {
            height: 6px;
            border-radius: 10px;
            background-color: #e0e0e0;
            margin-top: 8px;
            overflow: hidden;
        }
        
        .strength-bar {
            height: 100%;
            width: 0%;
            transition: width 0.3s ease, background-color 0.3s ease;
            border-radius: 10px;
        }
        
        .strength-text {
            font-size: 12px;
            margin-top: 4px;
            text-align: right;
        }
        
        /* Eye icon styles */
        .eye-icon {
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .eye-icon:hover {
            opacity: 0.8;
        }
        
        /* Staff badge style */
        .staff-badge {
            background: linear-gradient(135deg, #d4a373 0%, #b4804f 100%);
        }

        /* Loading spinner */
        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #0284a8;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            animation: spin 1s linear infinite;
            display: inline-block;
            vertical-align: middle;
            margin-right: 8px;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .btn-loading {
            opacity: 0.7;
            cursor: not-allowed;
        }
    </style>
</head>
<body class="register-bg">
    
    <!-- Include Notification Component -->
    <jsp:include page="/component/notification.jsp" />

    <!-- ===== STAFF REGISTER FORM SECTION ===== -->
    <div class="register-content">
        
        <!-- REGISTER CARD -->
        <div class="bg-white/95 backdrop-blur-sm rounded-3xl shadow-2xl p-6 md:p-8 border border-white/20 relative overflow-hidden">
            <!-- decorative wave with staff theme -->
            <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-[#b4804f] via-[#d4a373] to-[#b4804f]"></div>
            
            <div class="flex flex-col items-center text-center mb-6">
                <div class="w-20 h-20 bg-[#b4804f]/20 rounded-full flex items-center justify-center mb-4 backdrop-blur-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/1995/1995572.png" alt="staff register" class="w-10 h-10">
                </div>
                <h2 class="text-3xl md:text-4xl font-bold text-[#1e3c5c]">Staff Registration</h2>
                <p class="text-[#3a5a78] text-base mt-2">Join our team at Ocean View Resort</p>
                <div class="mt-2 staff-badge text-white text-xs font-semibold px-3 py-1 rounded-full">
                    STAFF PORTAL
                </div>
            </div>

            <form id="registerForm" method="post" class="space-y-4 scrollable-form" onsubmit="return handleRegister(event)">
                
                <!-- Full Name Field -->
                <div>
                    <label for="fullname" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/2544/2544085.png" alt="name" class="w-4 h-4"> Full Name <span class="text-[#d4a373]">*</span>
                    </label>
                    <div class="relative">
                        <input type="text" id="fullname" name="fullname" required 
                               class="w-full pl-11 pr-5 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] placeholder-[#8fa8bc] text-base"
                               placeholder="John Doe" oninput="validateField('fullname')">
                    </div>
                    <div id="fullname-error" class="text-xs text-red-500 mt-1 hidden">Full name must be at least 4 characters</div>
                </div>

                <!-- Username Field -->
                <div>
                    <label for="username" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/2544/2544085.png" alt="username" class="w-4 h-4"> Username <span class="text-[#d4a373]">*</span>
                    </label>
                    <div class="relative">
                        <input type="text" id="username" name="username" required 
                               class="w-full pl-11 pr-5 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] placeholder-[#8fa8bc] text-base"
                               placeholder="johndoe123" oninput="validateField('username'); checkUsernameAvailability()">
                    </div>
                    <div id="username-error" class="text-xs text-red-500 mt-1 hidden">Username must be at least 5 characters and can only contain letters, numbers, _ and -</div>
                    <div id="username-availability" class="text-xs mt-1 hidden"></div>
                </div>

                <!-- Email Field -->
                <div>
                    <label for="email" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/732/732200.png" alt="email" class="w-4 h-4"> Email Address <span class="text-[#d4a373]">*</span>
                    </label>
                    <div class="relative">
                        <input type="email" id="email" name="email" required 
                               class="w-full pl-11 pr-5 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] placeholder-[#8fa8bc] text-base"
                               placeholder="john.doe@oceanview.com" oninput="validateField('email'); checkEmailAvailability()">
                    </div>
                    <div id="email-error" class="text-xs text-red-500 mt-1 hidden">Please enter a valid email address</div>
                    <div id="email-availability" class="text-xs mt-1 hidden"></div>
                </div>

                <!-- Phone Field -->
                <div>
                    <label for="phone" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/9639/9639598.png" alt="phone" class="w-4 h-4"> Phone Number <span class="text-[#d4a373]">*</span>
                    </label>
                    <div class="relative">
                        <input type="tel" id="phone" name="phone" required 
                               class="w-full pl-11 pr-5 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] placeholder-[#8fa8bc] text-base"
                               placeholder="+94 77 123 4567" oninput="validateField('phone'); checkPhoneAvailability()">
                    </div>
                    <div id="phone-error" class="text-xs text-red-500 mt-1 hidden">Please enter a valid phone number</div>
                    <div id="phone-availability" class="text-xs mt-1 hidden"></div>
                </div>

                <!-- Gender Dropdown (Male/Female only) -->
                <div>
                    <label for="gender" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/2922/2922506.png" alt="gender" class="w-4 h-4"> Gender <span class="text-[#d4a373]">*</span>
                    </label>
                    <div class="relative">
                        <select id="gender" name="gender" required 
                                class="w-full pl-11 pr-10 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] text-base cursor-pointer">
                            <option value="" disabled selected>Select gender</option>
                            <option value="male">Male</option>
                            <option value="female">Female</option>
                        </select>
                    </div>
                </div>

                <!-- Address Field -->
                <div>
                    <label for="address" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/149/149059.png" alt="address" class="w-4 h-4"> Address <span class="text-[#d4a373]">*</span>
                    </label>
                    <div class="relative">
                        <span class="absolute left-4 top-4 text-[#8fa8bc] text-lg">📍</span>
                        <textarea id="address" name="address" rows="2" required 
                                  class="w-full pl-11 pr-5 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] placeholder-[#8fa8bc] text-base resize-none"
                                  placeholder="480, Colombo Road, Galle, Sri Lanka" oninput="validateField('address')"></textarea>
                    </div>
                    <div id="address-error" class="text-xs text-red-500 mt-1 hidden">Address is required</div>
                </div>

                <!-- Password Field -->
                <div>
                    <label for="password" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/15184/15184206.png" alt="password" class="w-4 h-4"> Password <span class="text-[#d4a373]">*</span>
                    </label>
                    <div class="relative">
                        <input type="password" id="password" name="password" required 
                               class="w-full pl-11 pr-11 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] placeholder-[#8fa8bc] text-base"
                               placeholder="Create a strong password" oninput="checkPasswordStrength()">
                        <button type="button" onclick="togglePasswordVisibility('password')" class="absolute right-4 top-1/2 -translate-y-1/2 text-[#8fa8bc] hover:text-[#0284a8] transition eye-icon">
                            <span id="password-eye">👁️</span>
                        </button>
                    </div>
                    <!-- Password strength meter -->
                    <div class="strength-meter">
                        <div id="strength-bar" class="strength-bar" style="width: 0%; background-color: #e0e0e0;"></div>
                    </div>
                    <div id="strength-text" class="strength-text text-[#8fa8bc]"></div>
                    <div id="password-error" class="text-xs text-red-500 mt-1 hidden">Password must be at least 8 characters with at least one uppercase letter, one lowercase letter, one number, and one symbol</div>
                </div>

                <!-- Confirm Password Field -->
                <div>
                    <label for="confirmPassword" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/15184/15184206.png" alt="confirm password" class="w-4 h-4"> Confirm Password <span class="text-[#d4a373]">*</span>
                    </label>
                    <div class="relative">
                        <input type="password" id="confirmPassword" name="confirmPassword" required 
                               class="w-full pl-11 pr-11 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] placeholder-[#8fa8bc] text-base"
                               placeholder="Re-enter your password" oninput="validateField('confirmPassword')">
                        <button type="button" onclick="togglePasswordVisibility('confirmPassword')" class="absolute right-4 top-1/2 -translate-y-1/2 text-[#8fa8bc] hover:text-[#0284a8] transition eye-icon">
                            <span id="confirmPassword-eye">👁️</span>
                        </button>
                    </div>
                    <div id="confirmPassword-error" class="text-xs text-red-500 mt-1 hidden">Passwords do not match</div>
                </div>

                <!-- Terms and Conditions Checkbox -->
                <div class="flex items-start gap-2 mt-4">
                    <input type="checkbox" id="terms" name="terms" required class="accent-[#0284a8] w-4 h-4 mt-1">
                    <label for="terms" class="text-sm text-[#3a5a78]">
                        I agree to the <a href="#" class="text-[#0284a8] hover:underline">Staff Terms of Employment</a> and 
                        <a href="#" class="text-[#0284a8] hover:underline">Company Policies</a> <span class="text-[#d4a373]">*</span>
                    </label>
                </div>

                <!-- Register Staff button -->
                <div class="mt-6">
                    <button type="submit" id="submitBtn"
                            class="w-full bg-gradient-to-r from-[#b4804f] to-[#9a6739] hover:from-[#9a6739] hover:to-[#7b4f2b] text-white font-semibold py-3.5 px-6 rounded-xl text-base transition-all transform hover:scale-[1.01] shadow-lg flex items-center justify-center gap-2">
                        <span>👥</span> Register Staff Member
                    </button>
                </div>

                <!-- login link -->
                <div class="text-center pt-3">
                    <p class="text-[#3a5a78] text-sm">
                        Already have a staff account? 
                        <a href="staff-login.jsp" class="text-[#0284a8] font-semibold hover:text-[#03738C] hover:underline transition">
                            Sign in here
                        </a>
                    </p>
                </div>
            </form>
        </div>
        
        <!-- Back to Dashboard button -->
        <div class="flex justify-end mt-4">
            <a href="index.jsp" 
               class="inline-flex items-center gap-2 bg-white/20 backdrop-blur-sm border-2 border-white/30 hover:bg-white/30 text-white font-semibold py-2.5 px-5 rounded-xl text-sm transition-all transform hover:scale-[1.02] shadow-lg">
                <span>🏠</span> Back to Home
            </a>
        </div>
        
        <!-- Small resort branding -->
        <div class="text-center mt-4 text-white/80 text-sm">
            © 2026 Ocean View Resort Galle · Staff Management Portal
        </div>
    </div>

    <script>
        // Get context path for API calls
        var contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 2));
        if (contextPath === '') contextPath = '';

        // Password strength checker
        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthBar = document.getElementById('strength-bar');
            const strengthText = document.getElementById('strength-text');
            
            let strength = 0;
            let strengthLevel = '';
            let color = '#e0e0e0';
            
            // Check length
            if (password.length >= 8) strength += 1;
            if (password.length >= 10) strength += 0.5;
            if (password.length >= 12) strength += 0.5;
            
            // Check for numbers
            if (/\d/.test(password)) strength += 1;
            
            // Check for symbols
            if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) strength += 1;
            
            // Check for uppercase letters
            if (/[A-Z]/.test(password)) strength += 1;
            
            // Check for lowercase letters
            if (/[a-z]/.test(password)) strength += 1;
            
            // Calculate percentage (max possible strength is 6)
            const percentage = (strength / 6) * 100;
            strengthBar.style.width = percentage + '%';
            
            // Determine strength level and color
            if (percentage < 20) {
                strengthLevel = 'Very Weak';
                color = '#ef4444';
            } else if (percentage < 40) {
                strengthLevel = 'Weak';
                color = '#f59e0b';
            } else if (percentage < 60) {
                strengthLevel = 'Okay';
                color = '#fbbf24';
            } else if (percentage < 80) {
                strengthLevel = 'Good';
                color = '#3b82f6';
            } else {
                strengthLevel = 'Strong';
                color = '#10b981';
            }
            
            strengthBar.style.backgroundColor = color;
            strengthText.textContent = 'Strength: ' + strengthLevel;
        }
        
        // Field validation
        function validateField(fieldId) {
            const value = document.getElementById(fieldId).value.trim();
            const errorElement = document.getElementById(fieldId + '-error');
            
            if (!errorElement) return true;
            
            switch(fieldId) {
                case 'fullname':
                    if (value.length < 4) {
                        errorElement.classList.remove('hidden');
                        return false;
                    } else {
                        errorElement.classList.add('hidden');
                        return true;
                    }
                    
                case 'username':
                    const usernameRegex = /^[a-zA-Z0-9_-]{5,}$/;
                    if (!usernameRegex.test(value)) {
                        errorElement.classList.remove('hidden');
                        return false;
                    } else {
                        errorElement.classList.add('hidden');
                        return true;
                    }
                    
                case 'email':
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test(value)) {
                        errorElement.classList.remove('hidden');
                        return false;
                    } else {
                        errorElement.classList.add('hidden');
                        return true;
                    }
                    
                case 'phone':
                    const phoneRegex = /^[\d\s\+\-\(\)]{10,}$/;
                    if (!phoneRegex.test(value)) {
                        errorElement.classList.remove('hidden');
                        return false;
                    } else {
                        errorElement.classList.add('hidden');
                        return true;
                    }
                    
                case 'address':
                    if (value.length === 0) {
                        errorElement.classList.remove('hidden');
                        return false;
                    } else {
                        errorElement.classList.add('hidden');
                        return true;
                    }
                    
                case 'confirmPassword':
                    const password = document.getElementById('password').value;
                    if (value !== password) {
                        errorElement.classList.remove('hidden');
                        return false;
                    } else {
                        errorElement.classList.add('hidden');
                        return true;
                    }
            }
            return true;
        }
        
        // Check username availability
        function checkUsernameAvailability() {
            const username = document.getElementById('username').value.trim();
            const usernameRegex = /^[a-zA-Z0-9_-]{5,}$/;
            const availabilityElement = document.getElementById('username-availability');
            
            if (!usernameRegex.test(username)) {
                availabilityElement.classList.add('hidden');
                return;
            }
            
            fetch(contextPath + '/staff/api/check-username?username=' + encodeURIComponent(username))
                .then(response => response.json())
                .then(data => {
                    availabilityElement.classList.remove('hidden');
                    if (data.exists) {
                        availabilityElement.className = 'text-xs mt-1 text-red-500';
                        availabilityElement.textContent = '❌ Username is already taken';
                    } else {
                        availabilityElement.className = 'text-xs mt-1 text-green-500';
                        availabilityElement.textContent = '✅ Username is available';
                    }
                })
                .catch(error => {
                    console.error('Error checking username:', error);
                });
        }
        
        // Check email availability
        function checkEmailAvailability() {
            const email = document.getElementById('email').value.trim();
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            const availabilityElement = document.getElementById('email-availability');
            
            if (!emailRegex.test(email)) {
                availabilityElement.classList.add('hidden');
                return;
            }
            
            fetch(contextPath + '/staff/api/check-email?email=' + encodeURIComponent(email))
                .then(response => response.json())
                .then(data => {
                    availabilityElement.classList.remove('hidden');
                    if (data.exists) {
                        availabilityElement.className = 'text-xs mt-1 text-red-500';
                        availabilityElement.textContent = '❌ Email is already registered';
                    } else {
                        availabilityElement.className = 'text-xs mt-1 text-green-500';
                        availabilityElement.textContent = '✅ Email is available';
                    }
                })
                .catch(error => {
                    console.error('Error checking email:', error);
                });
        }
        
        // Check phone availability
        function checkPhoneAvailability() {
            const phone = document.getElementById('phone').value.trim();
            const phoneRegex = /^[\d\s\+\-\(\)]{10,}$/;
            const availabilityElement = document.getElementById('phone-availability');
            
            if (!phoneRegex.test(phone)) {
                availabilityElement.classList.add('hidden');
                return;
            }
            
            fetch(contextPath + '/staff/api/check-phone?phone=' + encodeURIComponent(phone))
                .then(response => response.json())
                .then(data => {
                    availabilityElement.classList.remove('hidden');
                    if (data.exists) {
                        availabilityElement.className = 'text-xs mt-1 text-red-500';
                        availabilityElement.textContent = '❌ Phone number is already registered';
                    } else {
                        availabilityElement.className = 'text-xs mt-1 text-green-500';
                        availabilityElement.textContent = '✅ Phone number is available';
                    }
                })
                .catch(error => {
                    console.error('Error checking phone:', error);
                });
        }
        
        // Toggle password visibility
        function togglePasswordVisibility(fieldId) {
            const field = document.getElementById(fieldId);
            const eyeSpan = document.getElementById(fieldId + '-eye');
            
            if (field.type === 'password') {
                field.type = 'text';
                eyeSpan.textContent = '👁️‍🗨️';
            } else {
                field.type = 'password';
                eyeSpan.textContent = '👁️';
            }
        }
        
        // Check all availabilities before submit
        async function checkAllAvailabilities() {
            const username = document.getElementById('username').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            
            // Check username
            const usernameResponse = await fetch(contextPath + '/staff/api/check-username?username=' + encodeURIComponent(username));
            const usernameData = await usernameResponse.json();
            if (usernameData.exists) {
                document.getElementById('username-availability').className = 'text-xs mt-1 text-red-500';
                document.getElementById('username-availability').textContent = '❌ Username is already taken';
                document.getElementById('username-availability').classList.remove('hidden');
                return false;
            }
            
            // Check email
            const emailResponse = await fetch(contextPath + '/staff/api/check-email?email=' + encodeURIComponent(email));
            const emailData = await emailResponse.json();
            if (emailData.exists) {
                document.getElementById('email-availability').className = 'text-xs mt-1 text-red-500';
                document.getElementById('email-availability').textContent = '❌ Email is already registered';
                document.getElementById('email-availability').classList.remove('hidden');
                return false;
            }
            
            // Check phone
            const phoneResponse = await fetch(contextPath + '/staff/api/check-phone?phone=' + encodeURIComponent(phone));
            const phoneData = await phoneResponse.json();
            if (phoneData.exists) {
                document.getElementById('phone-availability').className = 'text-xs mt-1 text-red-500';
                document.getElementById('phone-availability').textContent = '❌ Phone number is already registered';
                document.getElementById('phone-availability').classList.remove('hidden');
                return false;
            }
            
            return true;
        }
        
        function handleRegister(event) {
            event.preventDefault();
            
            // Get form values
            const fullname = document.getElementById('fullname').value.trim();
            const username = document.getElementById('username').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const gender = document.getElementById('gender').value;
            const address = document.getElementById('address').value.trim();
            const password = document.getElementById('password').value.trim();
            const confirmPassword = document.getElementById('confirmPassword').value.trim();
            const terms = document.getElementById('terms').checked;
            
            // Validate all fields
            let isValid = true;
            
            // Full name validation
            if (fullname.length < 4) {
                document.getElementById('fullname-error').classList.remove('hidden');
                isValid = false;
            } else {
                document.getElementById('fullname-error').classList.add('hidden');
            }
            
            // Username validation
            const usernameRegex = /^[a-zA-Z0-9_-]{5,}$/;
            if (!usernameRegex.test(username)) {
                document.getElementById('username-error').classList.remove('hidden');
                isValid = false;
            } else {
                document.getElementById('username-error').classList.add('hidden');
            }
            
            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                document.getElementById('email-error').classList.remove('hidden');
                isValid = false;
            } else {
                document.getElementById('email-error').classList.add('hidden');
            }
            
            // Phone validation
            const phoneRegex = /^[\d\s\+\-\(\)]{10,}$/;
            if (!phoneRegex.test(phone)) {
                document.getElementById('phone-error').classList.remove('hidden');
                isValid = false;
            } else {
                document.getElementById('phone-error').classList.add('hidden');
            }
            
            // Gender validation
            if (!gender) {
                alert('Please select your gender.');
                isValid = false;
            }
            
            // Address validation
            if (address.length === 0) {
                document.getElementById('address-error').classList.remove('hidden');
                isValid = false;
            } else {
                document.getElementById('address-error').classList.add('hidden');
            }
            
            // Password validation
            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,}$/;
            if (!passwordRegex.test(password)) {
                document.getElementById('password-error').classList.remove('hidden');
                isValid = false;
            } else {
                document.getElementById('password-error').classList.add('hidden');
            }
            
            // Confirm password
            if (password !== confirmPassword) {
                document.getElementById('confirmPassword-error').classList.remove('hidden');
                isValid = false;
            } else {
                document.getElementById('confirmPassword-error').classList.add('hidden');
            }
            
            // Terms agreement
            if (!terms) {
                alert('You must agree to the Staff Terms of Employment and Company Policies.');
                isValid = false;
            }
            
            if (!isValid) {
                return false;
            }
            
            // Show loading state
            const submitBtn = document.getElementById('submitBtn');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<span class="loading-spinner"></span> Registering...';
            submitBtn.disabled = true;
            submitBtn.classList.add('btn-loading');
            
            // Check availability before submitting
            checkAllAvailabilities().then(available => {
                if (!available) {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                    submitBtn.classList.remove('btn-loading');
                    return;
                }
                
                // Prepare data for API
                const staffData = {
                    fullname: fullname,
                    username: username,
                    email: email,
                    phone: phone,
                    gender: gender,
                    address: address,
                    password: password,
                    roleId: 2 // Default role ID for Staff
                };
                
                // Send data to server
                fetch(contextPath + '/staff/api/create', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(staffData)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Show success message
                        if (window.showSuccess) {
                            window.showSuccess(data.message, 5000);
                        } else {
                            alert('Success: ' + data.message);
                        }
                        
                        // Clear form
                        document.getElementById('registerForm').reset();
                        
                        // Reset password strength meter
                        document.getElementById('strength-bar').style.width = '0%';
                        document.getElementById('strength-text').textContent = '';
                        
                        // Hide availability messages
                        document.getElementById('username-availability').classList.add('hidden');
                        document.getElementById('email-availability').classList.add('hidden');
                        document.getElementById('phone-availability').classList.add('hidden');
                        
                        // Redirect to manage staff page after 2 seconds
                        setTimeout(() => {
                            window.location.href = contextPath + '/login.jsp';
                        }, 2000);
                    } else {
                        // Show error message
                        if (window.showError) {
                            window.showError(data.message, 5000);
                        } else {
                            alert('Error: ' + data.message);
                        }
                    }
                })
                .catch(error => {
                    console.error('Error registering staff:', error);
                    if (window.showError) {
                        window.showError('Failed to register staff member. Please try again.', 5000);
                    } else {
                        alert('Failed to register staff member. Please try again.');
                    }
                })
                .finally(() => {
                    // Reset button state
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                    submitBtn.classList.remove('btn-loading');
                });
            });
            
            return false;
        }
    </script>
</body>
</html>