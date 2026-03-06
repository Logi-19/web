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

        /* Loading spinner */
        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #0284a8;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            animation: spin 1s linear infinite;
            display: inline-block;
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
        
        /* User type toggle */
        .user-type-toggle {
            display: flex;
            background: #f0f4f8;
            border-radius: 50px;
            padding: 4px;
            margin-bottom: 20px;
        }
        .user-type-btn {
            flex: 1;
            padding: 10px;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            border: none;
            background: transparent;
            color: #4a5568;
        }
        .user-type-btn.active {
            background: #0284a8;
            color: white;
            box-shadow: 0 4px 10px rgba(2, 132, 168, 0.3);
        }
        .user-type-btn.guest.active {
            background: #0284a8;
        }
        .user-type-btn.staff.active {
            background: #6b46c1;
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

            <!-- User Type Toggle -->
            <div class="user-type-toggle mb-6">
                <button type="button" id="guestTypeBtn" class="user-type-btn guest active" onclick="setUserType('guest')">
                    👤 Guest
                </button>
                <button type="button" id="staffTypeBtn" class="user-type-btn staff" onclick="setUserType('staff')">
                    👔 Staff
                </button>
            </div>

            <form id="loginForm" method="post" class="space-y-5" onsubmit="return handleLogin(event)">
                
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
                <button type="submit" id="loginBtn"
                        class="w-full bg-gradient-to-r from-[#0284a8] to-[#03738C] hover:from-[#03738C] hover:to-[#025c73] text-white font-semibold py-3.5 px-6 rounded-xl text-base transition-all transform hover:scale-[1.01] shadow-lg flex items-center justify-center gap-2">
                    <span id="btn-icon">🔑</span> 
                    <span id="btn-text">Sign In</span>
                </button>

                <!-- register link (only for guests) -->
                <div id="guestRegisterLink" class="text-center pt-3">
                    <p class="text-[#3a5a78] text-sm">
                        Don't have an account? 
                        <a href="register.jsp" class="text-[#0284a8] font-semibold hover:text-[#03738C] hover:underline transition">
                            Create account
                        </a>
                    </p>
                </div>
                
                <!-- staff note (only for staff) -->
                <div id="staffNote" class="text-center pt-3 hidden">
                    <p class="text-[#3a5a78] text-sm">
                        Staff access only. Contact administrator if you need access.
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
        // Current user type (guest or staff)
        let currentUserType = 'guest';
        
        // Check if user is already logged in (has token)
        (function checkExistingLogin() {
            const token = localStorage.getItem('authToken') || sessionStorage.getItem('authToken');
            const userType = localStorage.getItem('userType') || sessionStorage.getItem('userType');
            
            if (token && userType) {
                // Verify token with appropriate endpoint
                const verifyEndpoint = userType === 'staff' 
                    ? '${pageContext.request.contextPath}/staff/api/verify-token'
                    : '${pageContext.request.contextPath}/guests/api/verify-token';
                
                fetch(verifyEndpoint, {
                    headers: {
                        'Authorization': 'Bearer ' + token
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.valid) {
                        // Token is valid, redirect to appropriate page
                        if (userType === 'staff') {
                            window.location.href = '${pageContext.request.contextPath}/admin/dashboard.jsp';
                        } else {
                            window.location.href = '${pageContext.request.contextPath}/index.jsp';
                        }
                    } else {
                        // Token invalid, clear storage
                        clearAuthStorage();
                    }
                })
                .catch(() => {
                    // Error verifying token, clear storage
                    clearAuthStorage();
                });
            }
        })();
        
        function clearAuthStorage() {
            localStorage.removeItem('authToken');
            localStorage.removeItem('userId');
            localStorage.removeItem('userName');
            localStorage.removeItem('userEmail');
            localStorage.removeItem('userRegNo');
            localStorage.removeItem('userType');
            localStorage.removeItem('userRole');
            localStorage.removeItem('userRoleId');
            
            sessionStorage.removeItem('authToken');
            sessionStorage.removeItem('userId');
            sessionStorage.removeItem('userName');
            sessionStorage.removeItem('userEmail');
            sessionStorage.removeItem('userRegNo');
            sessionStorage.removeItem('userType');
            sessionStorage.removeItem('userRole');
            sessionStorage.removeItem('userRoleId');
        }

        function setUserType(type) {
            currentUserType = type;
            
            // Update button styles
            const guestBtn = document.getElementById('guestTypeBtn');
            const staffBtn = document.getElementById('staffTypeBtn');
            const guestLink = document.getElementById('guestRegisterLink');
            const staffNote = document.getElementById('staffNote');
            
            if (type === 'guest') {
                guestBtn.classList.add('active');
                staffBtn.classList.remove('active');
                guestLink.classList.remove('hidden');
                staffNote.classList.add('hidden');
                
                // Update login button gradient
                document.getElementById('loginBtn').className = 'w-full bg-gradient-to-r from-[#0284a8] to-[#03738C] hover:from-[#03738C] hover:to-[#025c73] text-white font-semibold py-3.5 px-6 rounded-xl text-base transition-all transform hover:scale-[1.01] shadow-lg flex items-center justify-center gap-2';
            } else {
                guestBtn.classList.remove('active');
                staffBtn.classList.add('active');
                guestLink.classList.add('hidden');
                staffNote.classList.remove('hidden');
                
                // Update login button gradient for staff
                document.getElementById('loginBtn').className = 'w-full bg-gradient-to-r from-[#6b46c1] to-[#553c9a] hover:from-[#553c9a] hover:to-[#44337a] text-white font-semibold py-3.5 px-6 rounded-xl text-base transition-all transform hover:scale-[1.01] shadow-lg flex items-center justify-center gap-2';
            }
        }

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

        // Show loading state on button
        function setLoading(isLoading) {
            const btn = document.getElementById('loginBtn');
            const btnIcon = document.getElementById('btn-icon');
            const btnText = document.getElementById('btn-text');
            
            if (isLoading) {
                btn.classList.add('btn-loading');
                btnIcon.innerHTML = '<span class="loading-spinner"></span>';
                btnText.textContent = 'Signing In...';
                btn.disabled = true;
            } else {
                btn.classList.remove('btn-loading');
                btnIcon.innerHTML = '🔑';
                btnText.textContent = 'Sign In';
                btn.disabled = false;
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
            
            // Show loading state
            setLoading(true);
            showInfo('Verifying credentials...', 0);
            
            // Prepare login data
            const loginData = {
                username: username,
                password: password
            };
            
            // Determine login endpoint based on user type
            const loginEndpoint = currentUserType === 'staff' 
                ? '${pageContext.request.contextPath}/staff/api/login'
                : '${pageContext.request.contextPath}/guests/api/login';
            
            // Make API call to login
            fetch(loginEndpoint, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(loginData)
            })
            .then(async response => {
                const text = await response.text();
                let data;
                try {
                    data = JSON.parse(text);
                } catch (e) {
                    throw new Error('Invalid server response');
                }
                
                if (!response.ok) {
                    throw data;
                }
                return data;
            })
            .then(data => {
                setLoading(false);
                
                if (data.success) {
                    // Store token and user info (using generic keys for both user types)
                    if (data.token) {
                        // Common keys for both guest and staff
                        const userId = data.staffId || data.guestId;
                        const userName = data.staffName || data.guestName;
                        const userEmail = data.staffEmail || data.guestEmail;
                        const userRegNo = data.staffRegNo || data.guestRegNo;
                        const userRole = data.staffRole || null;
                        const userRoleId = data.staffRoleId || null;
                        
                        // Store in localStorage for persistence across sessions
                        localStorage.setItem('authToken', data.token);
                        localStorage.setItem('userId', userId);
                        localStorage.setItem('userName', userName);
                        localStorage.setItem('userEmail', userEmail);
                        localStorage.setItem('userRegNo', userRegNo);
                        localStorage.setItem('userType', currentUserType);
                        if (userRole) localStorage.setItem('userRole', userRole);
                        if (userRoleId) localStorage.setItem('userRoleId', userRoleId);
                        
                        // Also store in sessionStorage for current session
                        sessionStorage.setItem('authToken', data.token);
                        sessionStorage.setItem('userId', userId);
                        sessionStorage.setItem('userName', userName);
                        sessionStorage.setItem('userEmail', userEmail);
                        sessionStorage.setItem('userRegNo', userRegNo);
                        sessionStorage.setItem('userType', currentUserType);
                        if (userRole) sessionStorage.setItem('userRole', userRole);
                        if (userRoleId) sessionStorage.setItem('userRoleId', userRoleId);
                    }
                    
                    showSuccess('Login successful! Welcome back, ' + (data.staffName || data.guestName || username.split('@')[0]) + '!');
                    
                    // Clear form
                    document.getElementById('loginForm').reset();
                    
                    // Reset eye icon
                    document.getElementById('password-eye').textContent = '👁️';
                    
                    // Redirect based on user type
                    setTimeout(() => {
                        if (currentUserType === 'staff') {
                            window.location.href = '${pageContext.request.contextPath}/admin/dashboard.jsp';
                        } else {
                            window.location.href = '${pageContext.request.contextPath}/index.jsp';
                        }
                    }, 1500);
                } else {
                    showError(data.message || 'Login failed. Please try again.');
                }
            })
            .catch(error => {
                setLoading(false);
                console.error('Login error:', error);
                
                let errorMessage = 'An error occurred during login.';
                if (error && error.message) {
                    errorMessage = error.message;
                } else if (error && typeof error === 'string') {
                    errorMessage = error;
                }
                
                showError(errorMessage);
            });
            
            return false;
        }

        // Check for registration success message
        window.addEventListener('load', function() {
            if (sessionStorage.getItem('registrationSuccess') === 'true') {
                const email = sessionStorage.getItem('registeredEmail');
                showSuccess('Registration successful! Please login with your credentials.');
                if (email) {
                    document.getElementById('username').value = email;
                }
                sessionStorage.removeItem('registrationSuccess');
                sessionStorage.removeItem('registeredEmail');
            }
            
            // Check URL parameters for user type
            const urlParams = new URLSearchParams(window.location.search);
            const type = urlParams.get('type');
            if (type === 'staff') {
                setUserType('staff');
            } else {
                setUserType('guest');
            }
        });
    </script>
</body>
</html>