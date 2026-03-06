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
    <title>Ocean View Resort · My Staff Profile</title>
    <!-- Tailwind via CDN + Inter font -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <!-- Alpine.js for interactive components -->
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        .card-hover { transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .card-hover:hover { transform: translateY(-4px); box-shadow: 0 20px 30px -10px rgba(2, 136, 209, 0.15); }
        .break-word {
            word-break: break-word;
            overflow-wrap: break-word;
        }
        /* Modal backdrop */
        .modal-overlay {
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
        }
        /* Profile field styles */
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
        .profile-input.error {
            border-color: #ef4444;
            background-color: #fef2f2;
        }
        .profile-input.valid {
            border-color: #10b981;
            background-color: #f0fdf4;
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
        .gender-select {
            width: 100%;
            border: 1px solid #b5e5e0;
            border-radius: 0.75rem;
            padding: 0.625rem 1rem;
            font-size: 0.95rem;
            color: #1e3c5c;
            background-color: white;
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20' stroke='%231e3c5c'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 1.25rem;
        }
        .gender-select:focus {
            outline: none;
            ring: 2px solid #0284a8;
            border-color: transparent;
            box-shadow: 0 0 0 2px rgba(2, 132, 168, 0.2);
        }
        /* Status badges */
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
        
        /* Loading state */
        .spinner {
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top: 3px solid #0284a8;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
        }
        
        /* Notification animation */
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        .notification-slide {
            animation: slideIn 0.3s ease-out;
        }
        
        /* Hide elements with x-cloak until Alpine is loaded */
        [x-cloak] { display: none !important; }
        
        /* Debug panel (hidden by default) */
        .debug-panel {
            position: fixed;
            bottom: 10px;
            right: 10px;
            background: rgba(0,0,0,0.8);
            color: #00ff00;
            padding: 10px;
            border-radius: 5px;
            font-family: monospace;
            font-size: 12px;
            max-width: 400px;
            max-height: 300px;
            overflow: auto;
            z-index: 9999;
            display: none;
        }
        .debug-panel.show {
            display: block;
        }
    </style>
</head>
<body class="bg-[#f0f7fa] text-[#1e3c5c] antialiased flex">

    <!-- Include Sidebar -->
    <jsp:include page="/component/sidebar.jsp" />
    
    <!-- Include Notification -->
    <jsp:include page="/component/notification.jsp" />

    <!-- ===== MAIN PROFILE CONTENT ===== -->
    <main class="flex-1 overflow-y-auto" x-data="staffProfileManager()" x-init="init()" x-cloak>
        <!-- top bar -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#b5e5e0] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">👤</span>
                <span class="font-semibold">My Profile</span>
            </div>
            <div class="flex items-center gap-3">
                <span class="bg-[#0284a8] text-white text-xs px-3 py-1.5 rounded-full" x-text="profile.role || 'Staff'"></span>
            </div>
        </header>

        <!-- dashboard content -->
        <div class="p-4 md:p-6 lg:p-8 space-y-6 max-w-4xl mx-auto">

            <!-- Header with title and edit button -->
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                <div>
                    <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">My Staff Profile 👤</h2>
                    <p class="text-[#3a5a78] text-base mt-1">View and manage your staff information</p>
                </div>
                <button @click="toggleEditMode()" 
                        class="px-4 py-2 rounded-lg transition text-sm font-medium flex items-center gap-2"
                        :class="editMode ? 'bg-gray-200 text-gray-700 hover:bg-gray-300' : 'bg-[#0284a8] text-white hover:bg-[#03738C]'">
                    <template x-if="!editMode">
                        <span class="flex items-center gap-2">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                            </svg>
                            Edit Profile
                        </span>
                    </template>
                    <template x-if="editMode">
                        <span class="flex items-center gap-2">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                            </svg>
                            Cancel Editing
                        </span>
                    </template>
                </button>
            </div>

            <!-- Loading State -->
            <div x-show="loading" class="flex justify-center items-center py-12">
                <div class="text-center">
                    <div class="spinner mx-auto"></div>
                    <p class="mt-4 text-[#1e3c5c] font-medium">Loading staff profile...</p>
                </div>
            </div>

            <!-- dashboard content -->
            <div x-show="!loading &amp;&amp; !error">

                <!-- Statistics Cards -->
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <!-- Member Since -->
                    <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4 card-hover">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-[#3a5a78] text-sm font-medium">Joined Date</p>
                                <p class="text-lg font-bold text-[#1e3c5c]" x-text="formatDate(profile.joinedDate)"></p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-[#b5e5e0]/30 flex items-center justify-center">
                                <span class="text-2xl">📅</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Last Login -->
                    <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4 card-hover">
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
                    
                    <!-- Account Status -->
                    <div class="bg-white rounded-xl shadow-md border border-[#b5e5e0] p-4 card-hover">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-[#3a5a78] text-sm font-medium">Account Status</p>
                                <p class="text-lg font-bold text-[#1e3c5c]">
                                    <span :class="profile.status === 'active' ? 'status-badge-active' : 'status-badge-inactive'" 
                                          x-text="profile.status === 'active' ? 'Active' : 'Inactive'"></span>
                                </p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-[#f8e4c3] flex items-center justify-center">
                                <span class="text-2xl">⭐</span>
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
                                <span x-text="getAvatar()"></span>
                            </div>
                            <div>
                                <h3 class="text-2xl font-bold" x-text="profile.fullname || 'Not set'"></h3>
                                <p class="text-white/80 text-sm mt-1" x-text="profile.username ? '@' + profile.username : 'Username not set'"></p>
                                <p class="text-white/60 text-xs mt-1" x-text="'Staff ID: ' + (profile.regNo || 'Not assigned')"></p>
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
                                        <label class="field-label block">Staff Registration No</label>
                                        <input type="text" 
                                               x-model="profile.regNo"
                                               readonly
                                               class="profile-input bg-gray-50"
                                               :value="profile.regNo || 'Not assigned'">
                                    </div>
                                    
                                    <!-- Full Name -->
                                    <div>
                                        <label class="field-label block">Full Name <span class="text-[#d4a373]">*</span></label>
                                        <input type="text" 
                                               x-model="profile.fullname"
                                               :readonly="!editMode"
                                               :class="{'bg-gray-50': !editMode, 'error': validationErrors.fullname, 'valid': !validationErrors.fullname &amp;&amp; profile.fullname}"
                                               class="profile-input"
                                               @input="validateField('fullname')">
                                        <p x-show="validationErrors.fullname" class="text-xs text-red-500 mt-1" x-text="validationErrors.fullname"></p>
                                    </div>
                                    
                                    <!-- Username -->
                                    <div>
                                        <label class="field-label block">Username <span class="text-[#d4a373]">*</span></label>
                                        <input type="text" 
                                               x-model="profile.username"
                                               :readonly="!editMode"
                                               :class="{'bg-gray-50': !editMode, 'error': validationErrors.username, 'valid': !validationErrors.username &amp;&amp; profile.username &amp;&amp; usernameAvailable}"
                                               class="profile-input"
                                               @input="validateField('username'); if(editMode) checkUsernameAvailability()">
                                        <p x-show="validationErrors.username" class="text-xs text-red-500 mt-1" x-text="validationErrors.username"></p>
                                        <p x-show="!validationErrors.username &amp;&amp; usernameChecking" class="text-xs text-gray-500 mt-1">Checking availability...</p>
                                        <p x-show="!validationErrors.username &amp;&amp; !usernameChecking &amp;&amp; usernameAvailable === false &amp;&amp; editMode" class="text-xs text-red-500 mt-1">Username is already taken</p>
                                        <p x-show="!validationErrors.username &amp;&amp; !usernameChecking &amp;&amp; usernameAvailable === true &amp;&amp; editMode" class="text-xs text-green-500 mt-1">Username is available</p>
                                    </div>
                                    
                                    <!-- Email -->
                                    <div>
                                        <label class="field-label block">Email Address <span class="text-[#d4a373]">*</span></label>
                                        <input type="email" 
                                               x-model="profile.email"
                                               :readonly="!editMode"
                                               :class="{'bg-gray-50': !editMode, 'error': validationErrors.email, 'valid': !validationErrors.email &amp;&amp; profile.email &amp;&amp; emailAvailable}"
                                               class="profile-input"
                                               @input="validateField('email'); if(editMode) checkEmailAvailability()">
                                        <p x-show="validationErrors.email" class="text-xs text-red-500 mt-1" x-text="validationErrors.email"></p>
                                        <p x-show="!validationErrors.email &amp;&amp; emailChecking" class="text-xs text-gray-500 mt-1">Checking availability...</p>
                                        <p x-show="!validationErrors.email &amp;&amp; !emailChecking &amp;&amp; emailAvailable === false &amp;&amp; editMode" class="text-xs text-red-500 mt-1">Email is already registered</p>
                                        <p x-show="!validationErrors.email &amp;&amp; !emailChecking &amp;&amp; emailAvailable === true &amp;&amp; editMode" class="text-xs text-green-500 mt-1">Email is available</p>
                                    </div>
                                    
                                    <!-- Phone -->
                                    <div>
                                        <label class="field-label block">Phone Number <span class="text-[#d4a373]">*</span></label>
                                        <input type="tel" 
                                               x-model="profile.phone"
                                               :readonly="!editMode"
                                               :class="{'bg-gray-50': !editMode, 'error': validationErrors.phone, 'valid': !validationErrors.phone &amp;&amp; profile.phone}"
                                               class="profile-input"
                                               @input="validateField('phone'); if(editMode) checkPhoneAvailability()">
                                        <p x-show="validationErrors.phone" class="text-xs text-red-500 mt-1" x-text="validationErrors.phone"></p>
                                        <p x-show="!validationErrors.phone &amp;&amp; phoneChecking" class="text-xs text-gray-500 mt-1">Checking availability...</p>
                                        <p x-show="!validationErrors.phone &amp;&amp; !phoneChecking &amp;&amp; phoneAvailable === false &amp;&amp; editMode" class="text-xs text-red-500 mt-1">Phone number is already registered</p>
                                        <p x-show="!validationErrors.phone &amp;&amp; !phoneChecking &amp;&amp; phoneAvailable === true &amp;&amp; editMode" class="text-xs text-green-500 mt-1">Phone number is available</p>
                                    </div>
                                </div>
                                
                                <!-- Right Column -->
                                <div class="space-y-4">
                                    <!-- Address -->
                                    <div>
                                        <label class="field-label block">Address <span class="text-[#d4a373]">*</span></label>
                                        <textarea x-model="profile.address"
                                                  :readonly="!editMode"
                                                  :class="{'bg-gray-50': !editMode, 'error': validationErrors.address, 'valid': !validationErrors.address &amp;&amp; profile.address}"
                                                  class="profile-input min-h-[100px]"
                                                  rows="3"
                                                  @input="validateField('address')"></textarea>
                                        <p x-show="validationErrors.address" class="text-xs text-red-500 mt-1" x-text="validationErrors.address"></p>
                                    </div>
                                    
                                    <!-- Gender -->
                                    <div>
                                        <label class="field-label block">Gender <span class="text-[#d4a373]">*</span></label>
                                        <template x-if="!editMode">
                                            <div class="field-value" x-text="formatGender(profile.gender)"></div>
                                        </template>
                                        <template x-if="editMode">
                                            <select x-model="profile.gender" class="gender-select" @change="validateField('gender')">
                                                <option value="">Select your gender</option>
                                                <option value="male">♂️ Male</option>
                                                <option value="female">♀️ Female</option>
                                                <option value="other">⚧️ Other</option>
                                                <option value="prefer-not">🤫 Prefer not to say</option>
                                            </select>
                                        </template>
                                        <p x-show="editMode &amp;&amp; !profile.gender" class="text-xs text-red-500 mt-1">Please select your gender</p>
                                    </div>
                                    
                                    <!-- Role (Read Only) -->
                                    <div>
                                        <label class="field-label block">Role</label>
                                        <div class="mt-1">
                                            <span class="role-badge" x-text="profile.role || 'Staff'"></span>
                                        </div>
                                    </div>
                                    
                                    <!-- Password Change (only in edit mode) -->
                                    <div x-show="editMode">
                                        <label class="field-label block">New Password</label>
                                        <div class="relative">
                                            <input :type="showPassword ? 'text' : 'password'" 
                                                   x-model="profile.newPassword"
                                                   :class="{'error': validationErrors.password, 'valid': !validationErrors.password &amp;&amp; profile.newPassword &amp;&amp; profile.newPassword.length >= 8}"
                                                   class="profile-input pr-10"
                                                   @input="checkPasswordStrength(); validateField('password')"
                                                   placeholder="Leave blank to keep current">
                                            <button type="button" 
                                                    @click="showPassword = !showPassword"
                                                    class="absolute right-3 top-2.5 text-[#3a5a78] hover:text-[#1e3c5c] eye-icon">
                                                <span x-text="showPassword ? '👁️‍🗨️' : '👁️'"></span>
                                            </button>
                                        </div>
                                        <!-- Password strength meter -->
                                        <div class="strength-meter" x-show="profile.newPassword">
                                            <div id="strength-bar" class="strength-bar" :style="'width: ' + passwordStrength.percentage + '%; background-color: ' + passwordStrength.color"></div>
                                        </div>
                                        <div class="strength-text" x-show="profile.newPassword" x-text="'Strength: ' + passwordStrength.level" :style="'color: ' + passwordStrength.color"></div>
                                        <p x-show="validationErrors.password" class="text-xs text-red-500 mt-1" x-text="validationErrors.password"></p>
                                        <p class="text-xs text-[#3a5a78] mt-1">Minimum 8 characters with at least one uppercase, one lowercase, one number, and one symbol</p>
                                    </div>
                                    
                                    <!-- Confirm Password (only in edit mode and when new password is entered) -->
                                    <div x-show="editMode &amp;&amp; profile.newPassword">
                                        <label class="field-label block">Confirm Password</label>
                                        <div class="relative">
                                            <input :type="showConfirmPassword ? 'text' : 'password'" 
                                                   x-model="profile.confirmPassword"
                                                   :class="{'error': validationErrors.confirmPassword, 'valid': !validationErrors.confirmPassword &amp;&amp; profile.confirmPassword &amp;&amp; profile.newPassword === profile.confirmPassword}"
                                                   class="profile-input pr-10"
                                                   @input="validateField('confirmPassword')">
                                            <button type="button" 
                                                    @click="showConfirmPassword = !showConfirmPassword"
                                                    class="absolute right-3 top-2.5 text-[#3a5a78] hover:text-[#1e3c5c] eye-icon">
                                                <span x-text="showConfirmPassword ? '👁️‍🗨️' : '👁️'"></span>
                                            </button>
                                        </div>
                                        <p x-show="validationErrors.confirmPassword" class="text-xs text-red-500 mt-1" x-text="validationErrors.confirmPassword"></p>
                                    </div>
                                    
                                    <!-- Status -->
                                    <div>
                                        <label class="field-label block">Status</label>
                                        <div class="mt-1">
                                            <span :class="profile.status === 'active' ? 'status-badge-active' : 'status-badge-inactive'" 
                                                  x-text="profile.status === 'active' ? 'Active' : 'Inactive'"></span>
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
                                <button type="submit" :disabled="saving || !isFormValid()"
                                        class="px-6 py-2.5 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium flex items-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed">
                                    <span x-show="saving" class="inline-block h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
                                    <span x-text="saving ? 'Saving...' : 'Save Changes'"></span>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Account Timeline -->
                <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] p-6">
                    <h3 class="text-lg font-semibold text-[#1e3c5c] mb-4">Account Timeline</h3>
                    <div class="space-y-3">
                        <div class="flex items-center gap-3 text-sm">
                            <span class="w-24 text-[#3a5a78]">Joined:</span>
                            <span class="font-medium" x-text="formatDateTime(profile.joinedDate) || 'Not available'"></span>
                        </div>
                        <div class="flex items-center gap-3 text-sm">
                            <span class="w-24 text-[#3a5a78]">Last Login:</span>
                            <span class="font-medium" x-text="formatDateTime(profile.lastLogin) || 'Not available'"></span>
                        </div>
                        <div class="flex items-center gap-3 text-sm">
                            <span class="w-24 text-[#3a5a78]">Last Updated:</span>
                            <span class="font-medium" x-text="formatDateTime(profile.updatedDate) || 'Not available'"></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Error State -->
            <div x-show="error &amp;&amp; !loading" class="max-w-4xl mx-auto text-center py-12">
                <div class="bg-red-50 border border-red-200 rounded-xl p-8">
                    <span class="text-5xl mb-4 block">😕</span>
                    <h3 class="text-xl font-bold text-red-800 mb-2">Error Loading Profile</h3>
                    <p class="text-red-600" x-text="error"></p>
                    <button @click="init()" class="mt-4 px-6 py-2 bg-[#0284a8] text-white rounded-lg hover:bg-[#03738C] transition">
                        Try Again
                    </button>
                </div>
            </div>
        </div>
    </main>

    <!-- Debug Panel (press F2 to toggle) -->
    <div id="debugPanel" class="debug-panel">
        <strong>Debug Log</strong>
        <div id="debugLog"></div>
    </div>

    <script>
        // Toggle debug panel with F2 key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'F2') {
                e.preventDefault();
                document.getElementById('debugPanel').classList.toggle('show');
            }
        });

        // Debug log function
        function debugLog(message, data) {
            const log = document.getElementById('debugLog');
            const timestamp = new Date().toLocaleTimeString();
            let logEntry = `[${timestamp}] ${message}`;
            if (data) {
                logEntry += `<br>Data: ${JSON.stringify(data, null, 2)}`;
            }
            log.innerHTML = logEntry + '<br>' + log.innerHTML;
            console.log(message, data);
        }

        function staffProfileManager() {
            return {
                // Profile data
                profile: {
                    id: null,
                    regNo: '',
                    fullname: '',
                    username: '',
                    email: '',
                    phone: '',
                    address: '',
                    gender: '',
                    role: '',
                    status: 'active',
                    lastLogin: null,
                    joinedDate: null,
                    updatedDate: null,
                    newPassword: '', // For password change
                    confirmPassword: '' // For password confirmation
                },
                
                editMode: false,
                showPassword: false,
                showConfirmPassword: false,
                loading: true,
                saving: false,
                error: null,
                
                // Validation and availability states
                validationErrors: {},
                usernameAvailable: null,
                emailAvailable: null,
                phoneAvailable: null,
                usernameChecking: false,
                emailChecking: false,
                phoneChecking: false,
                
                // Password strength
                passwordStrength: {
                    percentage: 0,
                    level: '',
                    color: '#e0e0e0'
                },
                
                // Original profile data for cancel functionality
                originalProfile: null,
                
                // Base URL for API calls
                baseUrl: window.location.pathname.includes('/wepapp/') ? '/wepapp' : '',
                
                init: function() {
                    this.loadStaffData();
                },
                
                // Load staff data from server using staffId from storage (set by login.jsp)
                loadStaffData: function() {
                    this.loading = true;
                    this.error = null;
                    
                    // Get staff ID from storage - using the same keys set by login.jsp
                    // Login.jsp stores userId for both guest and staff, and also userType to differentiate
                    const staffId = localStorage.getItem('userId') || sessionStorage.getItem('userId');
                    const userType = localStorage.getItem('userType') || sessionStorage.getItem('userType');
                    
                    debugLog('Loading staff profile for ID:', staffId, 'User type:', userType);
                    
                    if (!staffId) {
                        this.error = 'No user logged in. Please login again.';
                        this.loading = false;
                        setTimeout(() => {
                            window.location.href = this.baseUrl + '/staff/login.jsp';
                        }, 2000);
                        return;
                    }
                    
                    // Verify this is a staff user
                    if (userType !== 'staff') {
                        this.error = 'Invalid user type. Please login as staff.';
                        this.loading = false;
                        setTimeout(() => {
                            window.location.href = this.baseUrl + '/staff/login.jsp';
                        }, 2000);
                        return;
                    }
                    
                    // Construct the full URL with context path
                    const url = this.baseUrl + '/staff/api/' + staffId;
                    debugLog('Fetching from URL:', url);
                    
                    // Fetch staff profile from server
                    fetch(url)
                        .then(response => {
                            debugLog('Response status:', response.status);
                            if (!response.ok) {
                                if (response.status === 401) {
                                    throw new Error('Session expired. Please login again.');
                                } else if (response.status === 404) {
                                    throw new Error('Profile API endpoint not found.');
                                }
                                throw new Error('Failed to load profile. Status: ' + response.status);
                            }
                            return response.json();
                        })
                        .then(data => {
                            debugLog('Profile data loaded:', data);

                            // Map server response to profile object
                            // The API returns {staff: staffObject, role: roleObject}
                            const staff = data.staff || data;

                            // Get role name from the role object
                            let roleValue = 'Staff'; // Default value

                            // Check if role is an object with name property
                            if (data.role && data.role.name) {
                                roleValue = data.role.name;
                            } 
                            // Check if role is in staff.roleName or staff.role
                            else if (staff.roleName) {
                                roleValue = staff.roleName;
                            }
                            else if (staff.role) {
                                // If staff.role is an object, get its name
                                if (typeof staff.role === 'object' && staff.role.name) {
                                    roleValue = staff.role.name;
                                } else {
                                    roleValue = staff.role;
                                }
                            }

                            // Capitalize first letter if needed
                            if (roleValue && roleValue !== 'Staff' && roleValue.length > 0) {
                                roleValue = roleValue.charAt(0).toUpperCase() + roleValue.slice(1);
                            }

                            this.profile = {
                                id: staff.id,
                                regNo: staff.regNo || 'Not assigned',
                                fullname: staff.fullname || '',
                                username: staff.username || '',
                                email: staff.email || '',
                                phone: staff.phone || '',
                                address: staff.address || '',
                                gender: staff.gender || '',
                                role: roleValue,
                                status: staff.status || 'active',
                                lastLogin: staff.lastLogin,
                                joinedDate: staff.joinedDate,
                                updatedDate: staff.updatedDate,
                                newPassword: '',
                                confirmPassword: ''
                            };

                            // Store original profile for cancel functionality
                            this.originalProfile = JSON.parse(JSON.stringify(this.profile));

                            this.loading = false;
                        })
                        .catch(error => {
                            debugLog('Error loading profile:', error);
                            this.error = error.message || 'Failed to load profile. Please try again.';
                            this.loading = false;
                            
                            // If session expired, redirect to login after showing error
                            if (error.message.includes('Session expired') || error.message.includes('login again')) {
                                setTimeout(() => {
                                    window.location.href = this.baseUrl + '/staff/login.jsp';
                                }, 2000);
                            }
                        });
                },
                
                // Get avatar emoji based on gender
                getAvatar: function() {
                    if (this.profile.gender === 'male') return '👨';
                    if (this.profile.gender === 'female') return '👩';
                    return '🧑';
                },
                
                // Format gender for display
                formatGender: function(gender) {
                    const genderMap = {
                        'male': '♂️ Male',
                        'female': '♀️ Female',
                        'other': '⚧️ Other',
                        'prefer-not': '🤫 Prefer not to say'
                    };
                    return genderMap[gender] || gender || 'Not specified';
                },
                
                // Format date without time
                formatDate: function(dateTimeString) {
                    if (!dateTimeString) return 'Not available';
                    try {
                        const date = new Date(dateTimeString);
                        if (isNaN(date.getTime())) return 'Not available';
                        
                        const options = { year: 'numeric', month: 'long', day: 'numeric' };
                        return date.toLocaleDateString('en-US', options);
                    } catch (e) {
                        return 'Not available';
                    }
                },
                
                // Format date with time
                formatDateTime: function(dateTimeString) {
                    if (!dateTimeString) return 'Not available';
                    try {
                        const date = new Date(dateTimeString);
                        if (isNaN(date.getTime())) return 'Not available';
                        
                        const options = { 
                            year: 'numeric', 
                            month: 'long', 
                            day: 'numeric',
                            hour: '2-digit',
                            minute: '2-digit'
                        };
                        return date.toLocaleDateString('en-US', options);
                    } catch (e) {
                        return 'Not available';
                    }
                },
                
                // Toggle edit mode
                toggleEditMode: function() {
                    if (this.editMode) {
                        // Cancel editing - restore original data
                        this.profile = JSON.parse(JSON.stringify(this.originalProfile));
                        this.profile.newPassword = ''; // Clear new password field
                        this.profile.confirmPassword = ''; // Clear confirm password
                        this.validationErrors = {}; // Clear validation errors
                        this.usernameAvailable = null;
                        this.emailAvailable = null;
                        this.phoneAvailable = null;
                        this.resetPasswordStrength();
                    }
                    this.editMode = !this.editMode;
                    this.showPassword = false;
                    this.showConfirmPassword = false;
                },
                
                // Reset password strength meter
                resetPasswordStrength: function() {
                    this.passwordStrength = {
                        percentage: 0,
                        level: '',
                        color: '#e0e0e0'
                    };
                },
                
                // Check password strength
                checkPasswordStrength: function() {
                    const password = this.profile.newPassword || '';
                    
                    let strength = 0;
                    let strengthLevel = '';
                    let color = '#e0e0e0';
                    
                    if (!password) {
                        this.resetPasswordStrength();
                        return;
                    }
                    
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
                    
                    this.passwordStrength = {
                        percentage: percentage,
                        level: strengthLevel,
                        color: color
                    };
                },
                
                // Validate individual field
                validateField: function(field) {
                    const errors = {...this.validationErrors};
                    
                    switch(field) {
                        case 'fullname':
                            if (!this.profile.fullname || !this.profile.fullname.trim()) {
                                errors.fullname = 'Full name is required';
                            } else if (this.profile.fullname.trim().length < 4) {
                                errors.fullname = 'Name must be at least 4 characters';
                            } else {
                                delete errors.fullname;
                            }
                            break;
                            
                        case 'username':
                            if (!this.profile.username || !this.profile.username.trim()) {
                                errors.username = 'Username is required';
                            } else {
                                const usernameRegex = /^[a-zA-Z0-9_-]{5,}$/;
                                if (!usernameRegex.test(this.profile.username)) {
                                    errors.username = 'Username must be at least 5 characters and can only contain letters, numbers, _ and -';
                                } else {
                                    delete errors.username;
                                }
                            }
                            break;
                            
                        case 'email':
                            if (!this.profile.email || !this.profile.email.trim()) {
                                errors.email = 'Email is required';
                            } else {
                                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                if (!emailRegex.test(this.profile.email)) {
                                    errors.email = 'Please enter a valid email address';
                                } else {
                                    delete errors.email;
                                }
                            }
                            break;
                            
                        case 'phone':
                            if (!this.profile.phone || !this.profile.phone.trim()) {
                                errors.phone = 'Phone number is required';
                            } else {
                                const phoneRegex = /^[\d\s\+\-\(\)]{10,}$/;
                                if (!phoneRegex.test(this.profile.phone)) {
                                    errors.phone = 'Please enter a valid phone number';
                                } else {
                                    delete errors.phone;
                                }
                            }
                            break;
                            
                        case 'address':
                            if (!this.profile.address || !this.profile.address.trim()) {
                                errors.address = 'Address is required';
                            } else {
                                delete errors.address;
                            }
                            break;
                            
                        case 'gender':
                            if (!this.profile.gender) {
                                errors.gender = 'Please select your gender';
                            } else {
                                delete errors.gender;
                            }
                            break;
                            
                        case 'password':
                            if (this.profile.newPassword) {
                                const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,}$/;
                                if (!passwordRegex.test(this.profile.newPassword)) {
                                    errors.password = 'Password must be at least 8 characters with uppercase, lowercase, number and symbol';
                                } else {
                                    delete errors.password;
                                }
                            } else {
                                delete errors.password;
                            }
                            break;
                            
                        case 'confirmPassword':
                            if (this.profile.newPassword && this.profile.newPassword !== this.profile.confirmPassword) {
                                errors.confirmPassword = 'Passwords do not match';
                            } else {
                                delete errors.confirmPassword;
                            }
                            break;
                    }
                    
                    this.validationErrors = errors;
                },
                
                // Check if username exists
                checkUsernameAvailability: function() {
                    if (!this.editMode || !this.profile.username || this.validationErrors.username) {
                        return;
                    }
                    
                    this.usernameChecking = true;
                    this.usernameAvailable = null;
                    
                    const staffId = this.profile.id;
                    const url = this.baseUrl + '/staff/api/check-username?username=' + encodeURIComponent(this.profile.username) + '&excludeId=' + staffId;
                    
                    debugLog('Checking username availability:', this.profile.username);
                    
                    fetch(url)
                        .then(response => response.json())
                        .then(data => {
                            debugLog('Username check response:', data);
                            this.usernameAvailable = !data.exists;
                            this.usernameChecking = false;
                        })
                        .catch(error => {
                            debugLog('Error checking username:', error);
                            this.usernameChecking = false;
                        });
                },
                
                // Check if email exists
                checkEmailAvailability: function() {
                    if (!this.editMode || !this.profile.email || this.validationErrors.email) {
                        return;
                    }
                    
                    this.emailChecking = true;
                    this.emailAvailable = null;
                    
                    const staffId = this.profile.id;
                    const url = this.baseUrl + '/staff/api/check-email?email=' + encodeURIComponent(this.profile.email) + '&excludeId=' + staffId;
                    
                    debugLog('Checking email availability:', this.profile.email);
                    
                    fetch(url)
                        .then(response => response.json())
                        .then(data => {
                            debugLog('Email check response:', data);
                            this.emailAvailable = !data.exists;
                            this.emailChecking = false;
                        })
                        .catch(error => {
                            debugLog('Error checking email:', error);
                            this.emailChecking = false;
                        });
                },
                
                // Check if phone exists
                checkPhoneAvailability: function() {
                    if (!this.editMode || !this.profile.phone || this.validationErrors.phone) {
                        return;
                    }
                    
                    this.phoneChecking = true;
                    this.phoneAvailable = null;
                    
                    const staffId = this.profile.id;
                    const url = this.baseUrl + '/staff/api/check-phone?phone=' + encodeURIComponent(this.profile.phone) + '&excludeId=' + staffId;
                    
                    debugLog('Checking phone availability:', this.profile.phone);
                    
                    fetch(url)
                        .then(response => response.json())
                        .then(data => {
                            debugLog('Phone check response:', data);
                            this.phoneAvailable = !data.exists;
                            this.phoneChecking = false;
                        })
                        .catch(error => {
                            debugLog('Error checking phone:', error);
                            this.phoneChecking = false;
                        });
                },
                
                // Check if form is valid
                isFormValid: function() {
                    // Validate all fields first
                    this.validateField('fullname');
                    this.validateField('username');
                    this.validateField('email');
                    this.validateField('phone');
                    this.validateField('address');
                    this.validateField('gender');
                    
                    if (this.profile.newPassword) {
                        this.validateField('password');
                        this.validateField('confirmPassword');
                    }
                    
                    // Check if there are any validation errors
                    const hasErrors = Object.keys(this.validationErrors).length > 0;
                    
                    // Check availability for username and email if they've been checked
                    const usernameCheck = !this.usernameChecking && (this.usernameAvailable === null || this.usernameAvailable === true);
                    const emailCheck = !this.emailChecking && (this.emailAvailable === null || this.emailAvailable === true);
                    const phoneCheck = !this.phoneChecking && (this.phoneAvailable === null || this.phoneAvailable === true);
                    
                    return !hasErrors && usernameCheck && emailCheck && phoneCheck;
                },
                
                // Save profile changes
                saveProfile: function() {
                    // Validate form
                    if (!this.isFormValid()) {
                        this.showNotification('Please fix the validation errors', 'error');
                        return;
                    }
                    
                    // Check availability
                    if (this.usernameAvailable === false) {
                        this.showNotification('Username is already taken', 'error');
                        return;
                    }
                    
                    if (this.emailAvailable === false) {
                        this.showNotification('Email is already registered', 'error');
                        return;
                    }
                    
                    if (this.phoneAvailable === false) {
                        this.showNotification('Phone number is already registered', 'error');
                        return;
                    }
                    
                    this.saving = true;
                    
                    // Prepare data for update
                    const updateData = {
                        id: this.profile.id,
                        fullname: this.profile.fullname.trim(),
                        username: this.profile.username.trim(),
                        email: this.profile.email.trim(),
                        phone: this.profile.phone.trim(),
                        address: this.profile.address.trim(),
                        gender: this.profile.gender
                    };
                    
                    // Add password if changed
                    if (this.profile.newPassword && this.profile.newPassword.length > 0) {
                        updateData.password = this.profile.newPassword;
                    }
                    
                    debugLog('Saving profile:', updateData);
                    
                    const url = this.baseUrl + '/staff/api/' + this.profile.id;
                    
                    // Send update request
                    fetch(url, {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(updateData)
                    })
                    .then(response => response.json())
                    .then(data => {
                        debugLog('Save response:', data);
                        
                        if (data.success) {
                            // Refresh profile data
                            this.loadStaffData();
                            
                            this.showNotification('Profile updated successfully!', 'success');
                            
                            // Exit edit mode
                            this.editMode = false;
                            this.showPassword = false;
                            this.showConfirmPassword = false;
                            this.profile.newPassword = '';
                            this.profile.confirmPassword = '';
                            this.resetPasswordStrength();
                        } else {
                            this.showNotification(data.message || 'Failed to update profile', 'error');
                        }
                    })
                    .catch(error => {
                        debugLog('Error saving profile:', error);
                        this.showNotification('Failed to save profile. Please try again.', 'error');
                    })
                    .finally(() => {
                        this.saving = false;
                    });
                },
                
                // Show notification
                showNotification: function(message, type) {
                    // Check if notification functions are available from notification.jsp
                    if (type === 'success' && window.showSuccess) {
                        window.showSuccess(message, 3000);
                    } else if (type === 'error' && window.showError) {
                        window.showError(message, 3000);
                    } else {
                        // Fallback alert
                        alert(message);
                    }
                }
            }
        }
    </script>
</body>
</html>