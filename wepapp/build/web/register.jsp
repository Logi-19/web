<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register · Ocean View Resort Galle</title>
    <!-- Tailwind via CDN + subtle overlay & font -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        .hero-glow { text-shadow: 0 8px 20px rgba(0,0,0,0.25); }
        .card-hover { transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .card-hover:hover { transform: translateY(-8px); box-shadow: 0 25px 35px -12px rgba(2, 136, 209, 0.2); }
        .form-input-focus { transition: all 0.2s ease; }
        
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
            max-width: 900px;
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
    </style>
</head>
<body class="register-bg">
    
    <!-- Include Notification Component -->
    <jsp:include page="component/notification.jsp" />

    <!-- ===== REGISTER FORM SECTION ===== -->
    <div class="register-content">
        
        
        <!-- REGISTER CARD -->
        <div class="bg-white/95 backdrop-blur-sm rounded-3xl shadow-2xl p-6 md:p-8 border border-white/20 relative overflow-hidden">
            <!-- decorative wave -->
            <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-[#0284a8] via-[#d4a373] to-[#0284a8]"></div>
            
            <div class="flex flex-col items-center text-center mb-6">
                <div class="w-20 h-20 bg-[#0284a8]/20 rounded-full flex items-center justify-center mb-4 backdrop-blur-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/456/456212.png" alt="register" class="w-10 h-10">
                </div>
                <h2 class="text-3xl md:text-4xl font-bold text-[#1e3c5c]">Create Account</h2>
                <p class="text-[#3a5a78] text-base mt-2">Join Ocean View Resort family and enjoy exclusive benefits</p>
            </div>

            <form id="registerForm" action="#" method="post" class="space-y-4 scrollable-form" onsubmit="return handleRegister(event)">
                
                <!-- Full Name and Username in one row -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Name Field -->
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
                                   placeholder="johndoe123" oninput="validateField('username')">
                        </div>
                        <div id="username-error" class="text-xs text-red-500 mt-1 hidden">Username must be at least 5 characters and can only contain letters, numbers, _ and -</div>
                    </div>
                </div>

                <!-- Email and Phone in one row -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Email Field -->
                    <div>
                        <label for="email" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                            <img src="https://cdn-icons-png.flaticon.com/128/732/732200.png" alt="email" class="w-4 h-4"> Email Address <span class="text-[#d4a373]">*</span>
                        </label>
                        <div class="relative">
                            <input type="email" id="email" name="email" required 
                                   class="w-full pl-11 pr-5 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] placeholder-[#8fa8bc] text-base"
                                   placeholder="john@example.com" oninput="validateField('email')">
                        </div>
                        <div id="email-error" class="text-xs text-red-500 mt-1 hidden">Please enter a valid email address</div>
                    </div>

                    <!-- Phone Field -->
                    <div>
                        <label for="phone" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                            <img src="https://cdn-icons-png.flaticon.com/128/9639/9639598.png" alt="phone" class="w-4 h-4"> Phone Number <span class="text-[#d4a373]">*</span>
                        </label>
                        <div class="relative">
                            <input type="tel" id="phone" name="phone" required 
                                   class="w-full pl-11 pr-5 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] placeholder-[#8fa8bc] text-base"
                                   placeholder="+94 77 123 4567" oninput="validateField('phone')">
                        </div>
                        <div id="phone-error" class="text-xs text-red-500 mt-1 hidden">Please enter a valid phone number</div>
                    </div>
                </div>

                <!-- Gender Dropdown -->
                <div>
                    <label for="gender" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/2922/2922506.png" alt="gender" class="w-4 h-4"> Gender <span class="text-[#d4a373]">*</span>
                    </label>
                    <div class="relative">
                        <select id="gender" name="gender" required 
                                class="w-full pl-11 pr-10 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] text-base cursor-pointer">
                            <option value="" disabled selected>Select your gender</option>
                            <option value="male">Male</option>
                            <option value="female">Female</option>
                            <option value="other">Other</option>
                            <option value="prefer-not">Prefer not to say</option>
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
                        I agree to the <a href="#" class="text-[#0284a8] hover:underline">Terms of Service</a> and 
                        <a href="#" class="text-[#0284a8] hover:underline">Privacy Policy</a> <span class="text-[#d4a373]">*</span>
                    </label>
                </div>

                <!-- Create Account button (only) -->
                <div class="mt-6">
                    <button type="submit" 
                            class="w-full bg-gradient-to-r from-[#0284a8] to-[#03738C] hover:from-[#03738C] hover:to-[#025c73] text-white font-semibold py-3.5 px-6 rounded-xl text-base transition-all transform hover:scale-[1.01] shadow-lg flex items-center justify-center gap-2">
                        <span>📝</span> Create Account
                    </button>
                </div>

                <!-- login link -->
                <div class="text-center pt-3">
                    <p class="text-[#3a5a78] text-sm">
                        Already have an account? 
                        <a href="login.jsp" class="text-[#0284a8] font-semibold hover:text-[#03738C] hover:underline transition">
                            Sign in here
                        </a>
                    </p>
                </div>
            </form>
        </div>
        
        <!-- Back to Home button (bottom right, outside form) -->
        <div class="flex justify-end mt-4">
            <a href="index.jsp" 
               class="inline-flex items-center gap-2 bg-white/20 backdrop-blur-sm border-2 border-white/30 hover:bg-white/30 text-white font-semibold py-2.5 px-5 rounded-xl text-sm transition-all transform hover:scale-[1.02] shadow-lg">
                <span>🏠</span> Back to Home
            </a>
        </div>
        
        <!-- Small resort branding -->
        <div class="text-center mt-4 text-white/80 text-sm">
            © 2026 Ocean View Resort Galle · Luxury by the sea
        </div>
    </div>

    <!-- Register handling script -->
    <script>
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
                color = '#ef4444'; // red
            } else if (percentage < 40) {
                strengthLevel = 'Weak';
                color = '#f59e0b'; // orange
            } else if (percentage < 60) {
                strengthLevel = 'Okay';
                color = '#fbbf24'; // yellow
            } else if (percentage < 80) {
                strengthLevel = 'Good';
                color = '#3b82f6'; // blue
            } else {
                strengthLevel = 'Strong';
                color = '#10b981'; // green
            }
            
            strengthBar.style.backgroundColor = color;
            strengthText.textContent = 'Strength: ' + strengthLevel;
        }
        
        // Field validation
        function validateField(fieldId) {
            const value = document.getElementById(fieldId).value.trim();
            const errorElement = document.getElementById(fieldId + '-error');
            
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
        
        // Toggle password visibility with eye icon
        function togglePasswordVisibility(fieldId) {
            const field = document.getElementById(fieldId);
            const eyeSpan = document.getElementById(fieldId + '-eye');
            
            if (field.type === 'password') {
                field.type = 'text';
                eyeSpan.textContent = '👁️‍🗨️'; // closed eye
            } else {
                field.type = 'password';
                eyeSpan.textContent = '👁️'; // open eye
            }
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
            
            // Full name validation (min 4 characters)
            if (fullname.length < 4) {
                document.getElementById('fullname-error').classList.remove('hidden');
                isValid = false;
            } else {
                document.getElementById('fullname-error').classList.add('hidden');
            }
            
            // Username validation (min 5 chars, letters, numbers, _ -)
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
                showError('Please select your gender.');
                isValid = false;
            }
            
            // Address validation
            if (address.length === 0) {
                document.getElementById('address-error').classList.remove('hidden');
                isValid = false;
            } else {
                document.getElementById('address-error').classList.add('hidden');
            }
            
            // Password validation (min 8 chars, at least one uppercase, one lowercase, one number, one symbol)
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
                showError('You must agree to the Terms of Service and Privacy Policy.');
                isValid = false;
            }
            
            if (!isValid) {
                return false;
            }
            
            // Show loading message
            showInfo('Creating your account...', 2000);
            
            // Simulate registration process
            setTimeout(() => {
                showSuccess('Registration successful! Welcome to Ocean View Resort, ' + fullname.split(' ')[0] + '!');
                
                // Clear form
                document.getElementById('registerForm').reset();
                
                // Reset password strength meter
                document.getElementById('strength-bar').style.width = '0%';
                document.getElementById('strength-text').textContent = '';
                
                // Redirect to login after 2 seconds
                setTimeout(() => {
                    window.location.href = 'login.jsp';
                }, 2000);
            }, 1500);
            
            return false;
        }
    </script>
</body>
</html>