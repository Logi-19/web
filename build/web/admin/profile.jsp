<%-- 
    Document   : profile
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · My Profile</title>
    <!-- Tailwind via CDN + Inter font + same subtle style -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <!-- Alpine.js for interactive components -->
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <!-- Include notification.jsp -->
    <jsp:include page="/component/notification.jsp" />
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        .card-dash { transition: all 0.2s; }
        .card-dash:hover { transform: translateY(-2px); box-shadow: 0 16px 24px -8px rgba(2, 116, 140, 0.12); }
        .stat-glow { text-shadow: 0 2px 5px rgba(2, 132, 168, 0.2); }
        .break-word {
            word-break: break-word;
            overflow-wrap: break-word;
        }
        /* Modal backdrop */
        .modal-overlay {
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
        }
        /* Profile card styles */
        .profile-field {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #e2e8f0;
        }
        .profile-field:last-child {
            border-bottom: none;
        }
        .field-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #3a5a78;
            font-weight: 500;
        }
        .field-value {
            font-size: 1rem;
            color: #1e3c5c;
            font-weight: 500;
            margin-top: 0.25rem;
        }
        .status-badge-active {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
            background-color: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }
        .status-badge-inactive {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
            background-color: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }
        .role-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
            background-color: #dbeafe;
            color: #1e40af;
            border: 1px solid #bfdbfe;
        }
        /* Notification animation */
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        .notification-slide {
            animation: slideIn 0.3s ease-out;
        }
        /* Form input styles */
        .profile-input {
            width: 100%;
            border: 1px solid #b5e5e0;
            border-radius: 0.75rem;
            padding: 0.625rem 1rem;
            font-size: 0.95rem;
            color: #1e3c5c;
            transition: all 0.2s;
        }
        .profile-input:focus {
            outline: none;
            ring: 2px solid #0284a8;
            border-color: transparent;
            box-shadow: 0 0 0 2px rgba(2, 132, 168, 0.2);
        }
        .profile-input[readonly] {
            background-color: #f8fafc;
            cursor: not-allowed;
            opacity: 0.7;
        }
        .gender-option {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border: 1px solid #b5e5e0;
            border-radius: 0.75rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        .gender-option.selected {
            background-color: #e6f7f5;
            border-color: #0284a8;
        }
    </style>
</head>
<body class="bg-[#f0f7fa] text-[#1e3c5c] antialiased flex">

    <!-- Include Sidebar -->
    <jsp:include page="/component/sidebar.jsp" />

    <!-- ===== MAIN DASHBOARD (right side) ===== -->
    <main class="flex-1 overflow-y-auto" x-data="profileManager()" x-init="init()">
        <!-- top bar -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#b5e5e0] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">👤</span>
                <span class="font-semibold">My Profile</span>
            </div>
            <div class="flex items-center gap-3">
                <span class="bg-[#0284a8] text-white text-xs px-3 py-1.5 rounded-full" x-text="profile.role"></span>
            </div>
        </header>

        <!-- dashboard content -->
        <div class="p-4 md:p-6 lg:p-8 space-y-6 max-w-4xl mx-auto">

            <!-- Header with title and edit button -->
            <div class="flex justify-between items-center">
                <div>
                    <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">My Profile 👤</h2>
                    <p class="text-[#3a5a78] text-base mt-1">View and manage your personal information</p>
                </div>
                <button @click="toggleEditMode()" 
                        class="px-4 py-2 rounded-lg transition text-sm font-medium flex items-center gap-2"
                        :class="editMode ? 'bg-gray-200 text-gray-700 hover:bg-gray-300' : 'bg-[#0284a8] text-white hover:bg-[#03738C]'">
                    <template x-if="!editMode">
                        <>
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                            </svg>
                            Edit Profile
                        </>
                    </template>
                    <template x-if="editMode">
                        <>
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                            </svg>
                            Cancel Editing
                        </>
                    </template>
                </button>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <!-- Member Since -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Member Since</p>
                            <p class="text-lg font-bold text-[#1e3c5c]" x-text="formatDate(profile.joinedDate)"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0]/30 flex items-center justify-center">
                            <span class="text-2xl">📅</span>
                        </div>
                    </div>
                </div>
                
                <!-- Last Login -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Last Login</p>
                            <p class="text-lg font-bold text-[#1e3c5c]" x-text="formatDateTime(profile.lastLogin)"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#9ac9c2] flex items-center justify-center">
                            <span class="text-2xl">🕐</span>
                        </div>
                    </div>
                </div>
                
                <!-- Last Updated -->
                <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-[#3a5a78] text-sm font-medium">Last Updated</p>
                            <p class="text-lg font-bold text-[#1e3c5c]" x-text="formatDateTime(profile.updatedDate)"></p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-[#b5e5e0]/30 flex items-center justify-center">
                            <span class="text-2xl">🔄</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Profile Card -->
            <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] overflow-hidden">
                <!-- Card Header with Avatar -->
                <div class="bg-gradient-to-r from-[#0284a8] to-[#03738C] px-6 py-8 text-white">
                    <div class="flex items-center gap-4">
                        <div class="w-20 h-20 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center text-4xl">
                            👤
                        </div>
                        <div>
                            <h3 class="text-2xl font-bold" x-text="profile.name"></h3>
                            <p class="text-white/80 text-sm mt-1" x-text="`@${profile.username}`"></p>
                        </div>
                    </div>
                </div>
                
                <!-- Profile Fields -->
                <div class="p-6">
                    <form @submit.prevent="saveProfile()">
                        <!-- Two Column Grid for fields -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <!-- Left Column -->
                            <div class="space-y-4">
                                <!-- Registration No (Read Only) -->
                                <div>
                                    <label class="field-label block">Registration Number</label>
                                    <input type="text" 
                                           x-model="profile.regNo"
                                           readonly
                                           class="profile-input bg-gray-50">
                                </div>
                                
                                <!-- Full Name -->
                                <div>
                                    <label class="field-label block">Full Name</label>
                                    <input type="text" 
                                           x-model="profile.name"
                                           :readonly="!editMode"
                                           :class="{'bg-gray-50': !editMode}"
                                           class="profile-input">
                                </div>
                                
                                <!-- Username -->
                                <div>
                                    <label class="field-label block">Username</label>
                                    <input type="text" 
                                           x-model="profile.username"
                                           :readonly="!editMode"
                                           :class="{'bg-gray-50': !editMode}"
                                           class="profile-input">
                                </div>
                                
                                <!-- Email -->
                                <div>
                                    <label class="field-label block">Email Address</label>
                                    <input type="email" 
                                           x-model="profile.email"
                                           :readonly="!editMode"
                                           :class="{'bg-gray-50': !editMode}"
                                           class="profile-input">
                                </div>
                                
                                <!-- Phone -->
                                <div>
                                    <label class="field-label block">Phone Number</label>
                                    <input type="tel" 
                                           x-model="profile.phone"
                                           :readonly="!editMode"
                                           :class="{'bg-gray-50': !editMode}"
                                           class="profile-input">
                                </div>
                            </div>
                            
                            <!-- Right Column -->
                            <div class="space-y-4">
                                <!-- Address -->
                                <div>
                                    <label class="field-label block">Address</label>
                                    <textarea x-model="profile.address"
                                              :readonly="!editMode"
                                              :class="{'bg-gray-50': !editMode}"
                                              class="profile-input min-h-[100px]"
                                              rows="3"></textarea>
                                </div>
                                
                                <!-- Gender -->
                                <div>
                                    <label class="field-label block">Gender</label>
                                    <template x-if="!editMode">
                                        <div class="field-value" x-text="profile.gender"></div>
                                    </template>
                                    <template x-if="editMode">
                                        <div class="flex gap-3 mt-1">
                                            <label class="gender-option" :class="{'selected': profile.gender === 'Male'}">
                                                <input type="radio" value="Male" x-model="profile.gender" class="hidden">
                                                <span>♂️ Male</span>
                                            </label>
                                            <label class="gender-option" :class="{'selected': profile.gender === 'Female'}">
                                                <input type="radio" value="Female" x-model="profile.gender" class="hidden">
                                                <span>♀️ Female</span>
                                            </label>
                                            <label class="gender-option" :class="{'selected': profile.gender === 'Other'}">
                                                <input type="radio" value="Other" x-model="profile.gender" class="hidden">
                                                <span>⚧️ Other</span>
                                            </label>
                                        </div>
                                    </template>
                                </div>
                                
                                <!-- Password -->
                                <div>
                                    <label class="field-label block">Password</label>
                                    <div class="relative">
                                        <input :type="showPassword ? 'text' : 'password'" 
                                               x-model="profile.password"
                                               :readonly="!editMode"
                                               :class="{'bg-gray-50': !editMode}"
                                               class="profile-input pr-10">
                                        <button type="button" 
                                                @click="showPassword = !showPassword"
                                                class="absolute right-3 top-2.5 text-[#3a5a78] hover:text-[#1e3c5c]">
                                            <span x-text="showPassword ? '👁️' : '👁️‍🗨️'"></span>
                                        </button>
                                    </div>
                                </div>
                                
                                <!-- Role and Status Row -->
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label class="field-label block">Role</label>
                                        <div class="mt-1">
                                            <span class="role-badge" x-text="profile.role"></span>
                                        </div>
                                    </div>
                                    <div>
                                        <label class="field-label block">Status</label>
                                        <div class="mt-1">
                                            <span :class="profile.status === 'Active' ? 'status-badge-active' : 'status-badge-inactive'" 
                                                  x-text="profile.status"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Action Buttons (visible only in edit mode) -->
                        <div x-show="editMode" class="flex justify-end gap-3 mt-8 pt-4 border-t border-[#b5e5e0]">
                            <button type="button" @click="toggleEditMode()" 
                                    class="px-6 py-2.5 rounded-lg border border-[#b5e5e0] text-[#1e3c5c] hover:bg-[#b5e5e0]/20 transition text-sm font-medium">
                                Cancel
                            </button>
                            <button type="submit" 
                                    class="px-6 py-2.5 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium flex items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                </svg>
                                Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Additional Info Card -->
            <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] p-6">
                <h3 class="text-lg font-semibold text-[#1e3c5c] mb-4">Account Timeline</h3>
                <div class="space-y-3">
                    <div class="flex items-center gap-3 text-sm">
                        <span class="w-24 text-[#3a5a78]">Joined Date:</span>
                        <span class="font-medium" x-text="formatDateTime(profile.joinedDate)"></span>
                    </div>
                    <div class="flex items-center gap-3 text-sm">
                        <span class="w-24 text-[#3a5a78]">Last Login:</span>
                        <span class="font-medium" x-text="formatDateTime(profile.lastLogin)"></span>
                    </div>
                    <div class="flex items-center gap-3 text-sm">
                        <span class="w-24 text-[#3a5a78]">Last Updated:</span>
                        <span class="font-medium" x-text="formatDateTime(profile.updatedDate)"></span>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        function profileManager() {
            return {
                // Profile data with all required fields
                profile: {
                    regNo: 'REG001',
                    name: 'John Doe',
                    username: 'john.doe',
                    email: 'john.doe@example.com',
                    phone: '+94 77 123 4567',
                    address: '123 Beach Road, Colombo 03, Sri Lanka',
                    gender: 'Male',
                    password: 'password123',
                    role: 'Administrator',
                    status: 'Active',
                    lastLogin: '2024-03-15T14:30:00',
                    joinedDate: '2024-01-01T09:00:00',
                    updatedDate: '2024-03-15T14:30:00'
                },
                
                editMode: false,
                showPassword: false,
                
                // Original profile data for cancel functionality
                originalProfile: null,
                
                init: function() {
                    // Store original profile data for cancel functionality
                    this.originalProfile = JSON.parse(JSON.stringify(this.profile));
                    
                    console.log('Profile Manager initialized');
                    
                    // Check if user is logged in (you can add session validation here)
                    // This is where you would fetch actual user data from the server
                },
                
                // Format date without time
                formatDate: function(dateTimeString) {
                    if (!dateTimeString) return '';
                    var options = { year: 'numeric', month: 'long', day: 'numeric' };
                    return new Date(dateTimeString).toLocaleDateString('en-US', options);
                },
                
                // Format date with time
                formatDateTime: function(dateTimeString) {
                    if (!dateTimeString) return '';
                    var options = { 
                        year: 'numeric', 
                        month: 'long', 
                        day: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit'
                    };
                    return new Date(dateTimeString).toLocaleDateString('en-US', options);
                },
                
                // Toggle edit mode
                toggleEditMode: function() {
                    if (this.editMode) {
                        // Cancel editing - restore original data
                        this.profile = JSON.parse(JSON.stringify(this.originalProfile));
                    }
                    this.editMode = !this.editMode;
                    this.showPassword = false; // Hide password when toggling mode
                },
                
                // Save profile changes
                saveProfile: function() {
                    // Validate required fields
                    if (!this.profile.name || !this.profile.username || !this.profile.email) {
                        if (window.showError) {
                            window.showError('Please fill in all required fields', 3000);
                        }
                        return;
                    }
                    
                    // Validate email format
                    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test(this.profile.email)) {
                        if (window.showError) {
                            window.showError('Please enter a valid email address', 3000);
                        }
                        return;
                    }
                    
                    // Update original profile with new data
                    this.originalProfile = JSON.parse(JSON.stringify(this.profile));
                    
                    // Update the updatedDate to now
                    this.profile.updatedDate = new Date().toISOString();
                    
                    // Here you would typically make an API call to save the data
                    // For now, we'll just show a success message
                    
                    if (window.showSuccess) {
                        window.showSuccess('Profile updated successfully', 3000);
                    }
                    
                    // Exit edit mode
                    this.editMode = false;
                    this.showPassword = false;
                },
                
                // Method to load user data (call this from your backend)
                loadUserData: function(userData) {
                    if (userData) {
                        this.profile = userData;
                        this.originalProfile = JSON.parse(JSON.stringify(userData));
                    }
                }
            }
        }
    </script>
</body>
</html>