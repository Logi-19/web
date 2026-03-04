<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login · Ocean View Resort Galle</title>
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
        .login-bg {
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
        
        .login-bg::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(2, 43, 66, 0.85) 0%, rgba(3, 115, 140, 0.75) 50%, rgba(30, 60, 92, 0.85) 100%);
            z-index: 1;
        }
        
        .login-content {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 400px;
            padding: 1.5rem;
        }
    </style>
</head>
<body class="login-bg">
    
    <!-- Include Notification Component -->
    <jsp:include page="component/notification.jsp" />

    <!-- ===== LOGIN FORM SECTION ===== -->
    <div class="login-content">
        
        <!-- LOGIN CARD -->
        <div class="bg-white/95 backdrop-blur-sm rounded-3xl shadow-2xl p-6 md:p-8 border border-white/20 relative overflow-hidden">
            <!-- decorative wave -->
            <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-[#0284a8] via-[#d4a373] to-[#0284a8]"></div>
            
            <div class="flex flex-col items-center text-center mb-6">
                <div class="w-20 h-20 bg-[#0284a8]/20 rounded-full flex items-center justify-center mb-4 backdrop-blur-sm">
                    <img src="https://cdn-icons-png.flaticon.com/128/295/295128.png" alt="login" class="w-10 h-10">
                </div>
                <h2 class="text-3xl md:text-4xl font-bold text-[#1e3c5c]">Welcome Back</h2>
                <p class="text-[#3a5a78] text-base mt-2">Sign in to continue to Ocean View Resort</p>
            </div>

            <form id="loginForm" action="#" method="post" class="space-y-5" onsubmit="return handleLogin(event)">
                
                <!-- username / email field -->
                <div>
                    <label for="username" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/2544/2544085.png" alt="username" class="w-4 h-4"> Username or Email <span class="text-[#d4a373]">*</span>
                    </label>
                    <div class="relative">
                        <input type="text" id="username" name="username" required 
                               class="w-full pl-11 pr-5 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] placeholder-[#8fa8bc] text-base"
                               placeholder="Enter your email or username">
                    </div>
                </div>
                
                <!-- password field -->
                <div>
                    <label for="password" class="flex items-center gap-2 text-[#1e3c5c] font-medium mb-2 text-sm">
                        <img src="https://cdn-icons-png.flaticon.com/128/15184/15184206.png" alt="password" class="w-4 h-4"> Password <span class="text-[#d4a373]">*</span>
                    </label>
                    <div class="relative">
                        <input type="password" id="password" name="password" required 
                               class="w-full pl-11 pr-11 py-3.5 rounded-xl border-2 border-[#d1e7e3] focus:border-[#0284a8] outline-none transition bg-white/80 text-[#1e3c5c] placeholder-[#8fa8bc] text-base"
                               placeholder="Enter your password">
                        <button type="button" onclick="togglePasswordVisibility('password')" class="absolute right-4 top-1/2 -translate-y-1/2 text-[#8fa8bc] hover:text-[#0284a8] transition eye-icon">
                            <span id="password-eye">👁️</span>
                        </button>
                    </div>
                </div>

                <!-- forgot password link -->
                <div class="text-right">
                    <a href="#" class="text-sm text-[#0284a8] hover:text-[#03738C] font-medium hover:underline transition">
                        Forgot password?
                    </a>
                </div>

                <!-- login button -->
                <button type="submit" 
                        class="w-full bg-gradient-to-r from-[#0284a8] to-[#03738C] hover:from-[#03738C] hover:to-[#025c73] text-white font-semibold py-3.5 px-6 rounded-xl text-base transition-all transform hover:scale-[1.01] shadow-lg flex items-center justify-center gap-2">
                    <span>🔑</span> Sign In
                </button>

                <!-- register link -->
                <div class="text-center pt-3">
                    <p class="text-[#3a5a78] text-sm">
                        Don't have an account? 
                        <a href="register.jsp" class="text-[#0284a8] font-semibold hover:text-[#03738C] hover:underline transition">
                            Create account
                        </a>
                    </p>
                </div>
            </form>

            <p class="text-center text-xs text-[#6b8da8] mt-5">
                By signing in, you agree to our 
                <a href="#" class="text-[#0284a8] hover:underline">Terms</a> 
                and 
                <a href="#" class="text-[#0284a8] hover:underline">Privacy Policy</a>
            </p>
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

    <!-- Login handling script -->
    <script>
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
        
        function handleLogin(event) {
            event.preventDefault();
            
            // Get form values
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            
            // Validation
            if (!username || !password) {
                showError('Please enter both username and password.');
                return false;
            }
            
            // Show loading/info message
            showInfo('Verifying credentials...', 2000);
            
            // Simulate login process
            setTimeout(() => {
                showSuccess('Login successful! Welcome back, ' + username.split('@')[0] + '!');
                
                // Clear form
                document.getElementById('loginForm').reset();
                
                // Reset eye icons
                document.getElementById('password-eye').textContent = '👁️';
                
                // Optional: redirect after login
                 window.location.href = 'dashboard.jsp';
            }, 1500);
            
            return false;
        }
    </script>
</body>
</html>