<%-- 
    Document   : feedbackview
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- ===== GUEST FEEDBACK VIEW SECTION ===== -->
<section class="bg-gradient-to-b from-white to-[#f0f7fa] py-16 md:py-20" id="feedback-view">
    <div class="max-w-7xl mx-auto px-6">
        <!-- decorative header -->
        <div class="text-center mb-12 relative">
            <div class="absolute left-1/2 -top-10 transform -translate-x-1/2 text-5xl opacity-10">💭</div>
            <span class="text-[#0284a8] font-semibold tracking-wider text-sm uppercase bg-[#b5e5e0]/20 px-4 py-2 rounded-full">Guest Voices</span>
            <h2 class="text-3xl md:text-4xl font-bold text-[#1e3c5c] mt-3">What our guests say</h2>
            <div class="w-32 h-1.5 bg-gradient-to-r from-[#b5e5e0] via-[#0284a8] to-[#f8e4c3] mx-auto mt-4 rounded-full"></div>
            <p class="text-[#3a5a78] mt-5 max-w-2xl mx-auto">Real experiences from guests who stayed with us</p>
        </div>

        <!-- Statistics Summary -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-10 max-w-3xl mx-auto">
            <!-- Total Feedbacks -->
            <div class="bg-white/80 backdrop-blur-sm rounded-xl shadow-md border border-[#b5e5e0] p-4 text-center">
                <div class="text-3xl mb-2">📊</div>
                <p class="text-[#3a5a78] text-sm font-medium">Total Feedbacks</p>
                <p class="text-2xl font-bold text-[#1e3c5c]" id="totalCount">0</p>
            </div>
            
            <!-- Average Rating -->
            <div class="bg-white/80 backdrop-blur-sm rounded-xl shadow-md border border-[#b5e5e0] p-4 text-center">
                <div class="text-3xl mb-2">⭐</div>
                <p class="text-[#3a5a78] text-sm font-medium">Average Rating</p>
                <p class="text-2xl font-bold text-[#1e3c5c]" id="avgRating">0.0</p>
            </div>
            
            <!-- 5-Star Feedbacks -->
            <div class="bg-white/80 backdrop-blur-sm rounded-xl shadow-md border border-[#b5e5e0] p-4 text-center">
                <div class="text-3xl mb-2">🌟🌟🌟🌟🌟</div>
                <p class="text-[#3a5a78] text-sm font-medium">5-Star Reviews</p>
                <p class="text-2xl font-bold text-[#1e3c5c]" id="fiveStarCount">0</p>
            </div>
        </div>

        <!-- Loading Indicator -->
        <div id="loadingIndicator" class="text-center py-12">
            <div class="loader mx-auto"></div>
            <p class="text-[#3a5a78] mt-4">Loading guest feedbacks...</p>
        </div>

        <!-- Error Message -->
        <div id="errorMessage" class="text-center py-12 hidden">
            <span class="text-5xl mb-3 block">😕</span>
            <p class="text-lg text-[#3a5a78] mb-2">Unable to load feedbacks</p>
            <p class="text-[#8aa9b9] text-sm">Please check your connection and try again</p>
            <button onclick="location.reload()" class="mt-4 px-6 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                Retry
            </button>
        </div>

        <!-- Feedback Cards Grid - 2 cards per row horizontally -->
        <div id="feedbacksContainer" class="grid grid-cols-1 md:grid-cols-2 gap-6 lg:gap-8 min-h-[400px] hidden">
            <!-- Cards will be dynamically inserted here -->
        </div>

        <!-- No Results Message -->
        <div id="noResultsMessage" class="text-center py-16 hidden">
            <span class="text-6xl mb-4 block">😕</span>
            <p class="text-xl text-[#3a5a78] mb-2">No feedbacks yet</p>
        </div>
    </div>
</section>

<!-- Template for feedback card (hidden, used for cloning) -->
<template id="feedbackCardTemplate">
    <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] p-6 card-hover">
        <!-- Header with avatar and name -->
        <div class="flex items-center gap-3 mb-4">
            <div class="w-12 h-12 rounded-full bg-[#b5e5e0] text-[#0284a8] flex items-center justify-center text-lg font-bold flex-shrink-0 initials-placeholder">??</div>
            <div>
                <h3 class="font-semibold text-[#1e3c5c] name-placeholder">Guest Name</h3>
                <p class="text-[#8aa9b9] text-xs date-placeholder">Date</p>
            </div>
        </div>
        
        <!-- Rating stars -->
        <div class="mb-3">
            <span class="text-yellow-500 text-lg stars-placeholder">★★★★★</span>
        </div>
        
        <!-- Feedback message -->
        <div>
            <p class="text-[#3a5a78] text-sm leading-relaxed message-placeholder">"Feedback message"</p>
        </div>
    </div>
</template>

<!-- Essential CSS -->
<style>
    .card-hover {
        transition: all 0.3s ease;
    }
    .card-hover:hover {
        transform: translateY(-4px);
        box-shadow: 0 20px 25px -5px rgba(2, 132, 168, 0.1), 0 10px 10px -5px rgba(2, 132, 168, 0.04);
    }
    
    /* Loading spinner */
    .loader {
        border: 3px solid #f3f3f3;
        border-radius: 50%;
        border-top: 3px solid #0284a8;
        width: 40px;
        height: 40px;
        animation: spin 1s linear infinite;
        display: inline-block;
    }
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
    
    /* Star colors */
    .text-yellow-500 {
        color: #fbbf24;
    }
    
    /* Hide/show utilities */
    .hidden {
        display: none !important;
    }
    
    /* FIX: Ensure navbar stays on top */
    header {
        z-index: 9999 !important;
    }
    
    nav {
        z-index: 10000 !important;
    }
    
    /* FIX: Ensure dropdowns appear above everything */
    .group .absolute {
        z-index: 10001 !important;
    }
</style>

<!-- JavaScript for feedback view functionality - FIXED: Wrapped in DOMContentLoaded and using strict mode -->
<script>
(function() {
    'use strict';
    
    // Wait for DOM to be fully loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initFeedbackModule);
    } else {
        // DOM is already loaded, execute immediately
        initFeedbackModule();
    }
    
    function initFeedbackModule() {
        // Check if we're on the page and elements exist
        if (!document.getElementById('feedbacksContainer')) {
            console.log('Feedback view container not found - skipping initialization');
            return;
        }
        
        console.log('Initializing feedback view module...');
        
        // Get context path safely
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
        
        // State management
        let allFeedbacks = [];
        
        // Initialize
        fetchFeedbacks();
        
        // Fetch feedbacks from API
        async function fetchFeedbacks() {
            showLoading(true);
            hideError();
            
            try {
                // Fetch only visible feedbacks (status = true)
                const url = contextPath + '/feedback/api/visible';
                console.log('Fetching from:', url);
                
                const response = await fetch(url);
                
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                
                const data = await response.json();
                console.log('Received feedbacks:', data);
                
                // The API already returns only visible feedbacks
                allFeedbacks = Array.isArray(data) ? data : [];
                
                // Hide loading
                showLoading(false);
                
                if (allFeedbacks.length === 0) {
                    showNoResults();
                } else {
                    // Show container and render feedbacks
                    document.getElementById('feedbacksContainer').classList.remove('hidden');
                    renderFeedbacks();
                    
                    // Fetch stats
                    fetchStats();
                }
                
            } catch (error) {
                console.error('Error fetching feedbacks:', error);
                showLoading(false);
                showError();
            }
        }
        
        // Fetch statistics
        async function fetchStats() {
            try {
                const url = contextPath + '/feedback/api/stats';
                const response = await fetch(url);
                
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                
                const stats = await response.json();
                console.log('Received stats:', stats);
                
                // Update stats with visible counts only
                const totalEl = document.getElementById('totalCount');
                const avgEl = document.getElementById('avgRating');
                const fiveStarEl = document.getElementById('fiveStarCount');
                
                if (totalEl) totalEl.textContent = stats.visible || 0;
                if (avgEl) avgEl.textContent = (stats.averageRating || 0).toFixed(1);
                
                // Get 5-star count from rating distribution
                const distribution = stats.ratingDistribution || [0,0,0,0,0,0];
                if (fiveStarEl) fiveStarEl.textContent = distribution[5] || 0;
                
            } catch (error) {
                console.error('Error fetching stats:', error);
                // If stats fail, calculate from loaded feedbacks
                if (allFeedbacks.length > 0) {
                    const totalCount = allFeedbacks.length;
                    const avgRating = (allFeedbacks.reduce(function(sum, f) { return sum + f.rating; }, 0) / totalCount).toFixed(1);
                    const fiveStarCount = allFeedbacks.filter(function(f) { return Math.floor(f.rating) === 5; }).length;
                    
                    const totalEl = document.getElementById('totalCount');
                    const avgEl = document.getElementById('avgRating');
                    const fiveStarEl = document.getElementById('fiveStarCount');
                    
                    if (totalEl) totalEl.textContent = totalCount;
                    if (avgEl) avgEl.textContent = avgRating;
                    if (fiveStarEl) fiveStarEl.textContent = fiveStarCount;
                }
            }
        }
        
        // Render feedback cards using template
        function renderFeedbacks() {
            const container = document.getElementById('feedbacksContainer');
            const template = document.getElementById('feedbackCardTemplate');
            
            if (!container || !template) return;
            
            // Clear container
            container.innerHTML = '';
            
            // Create cards from template
            allFeedbacks.forEach(function(feedback) {
                // Clone the template
                const card = document.importNode(template.content, true);
                
                // Set initials
                const initialsEl = card.querySelector('.initials-placeholder');
                if (initialsEl) {
                    initialsEl.textContent = getInitials(feedback.name);
                }
                
                // Set name
                const nameEl = card.querySelector('.name-placeholder');
                if (nameEl) {
                    nameEl.textContent = feedback.name || 'Guest';
                }
                
                // Set date
                const dateEl = card.querySelector('.date-placeholder');
                if (dateEl) {
                    dateEl.textContent = formatDate(feedback.submittedDate || feedback.date);
                }
                
                // Set stars
                const starsEl = card.querySelector('.stars-placeholder');
                if (starsEl) {
                    starsEl.textContent = getStarRatingHTML(feedback.rating);
                }
                
                // Set message
                const messageEl = card.querySelector('.message-placeholder');
                if (messageEl) {
                    messageEl.textContent = '"' + (feedback.message || '') + '"';
                }
                
                // Append to container
                container.appendChild(card);
            });
        }
        
        // Helper function to get initials from name
        function getInitials(name) {
            if (!name) return '??';
            var parts = name.trim().split(/\s+/);
            if (parts.length >= 2) {
                return (parts[0][0] + parts[1][0]).toUpperCase();
            }
            return name.substring(0, 2).toUpperCase();
        }
        
        // Helper function to format date
        function formatDate(dateStr) {
            if (!dateStr) return '';
            try {
                var date = new Date(dateStr);
                return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
            } catch (e) {
                return dateStr;
            }
        }
        
        // Helper function to generate star rating HTML
        function getStarRatingHTML(rating) {
            var fullStars = Math.floor(rating);
            var stars = '';
            for (var i = 0; i < fullStars; i++) stars += '★';
            for (var i = fullStars; i < 5; i++) stars += '☆';
            return stars;
        }
        
        // Show/hide loading indicator
        function showLoading(show) {
            var loading = document.getElementById('loadingIndicator');
            var container = document.getElementById('feedbacksContainer');
            var noResults = document.getElementById('noResultsMessage');
            var error = document.getElementById('errorMessage');
            
            if (!loading) return;
            
            if (show) {
                loading.classList.remove('hidden');
                if (container) container.classList.add('hidden');
                if (noResults) noResults.classList.add('hidden');
                if (error) error.classList.add('hidden');
            } else {
                loading.classList.add('hidden');
            }
        }
        
        // Show error message
        function showError() {
            var error = document.getElementById('errorMessage');
            var container = document.getElementById('feedbacksContainer');
            var noResults = document.getElementById('noResultsMessage');
            
            if (error) {
                error.classList.remove('hidden');
            }
            if (container) {
                container.classList.add('hidden');
            }
            if (noResults) {
                noResults.classList.add('hidden');
            }
        }
        
        // Hide error message
        function hideError() {
            var error = document.getElementById('errorMessage');
            if (error) {
                error.classList.add('hidden');
            }
        }
        
        // Show no results message
        function showNoResults() {
            var noResults = document.getElementById('noResultsMessage');
            var container = document.getElementById('feedbacksContainer');
            var error = document.getElementById('errorMessage');
            
            if (noResults) {
                noResults.classList.remove('hidden');
            }
            if (container) {
                container.classList.add('hidden');
            }
            if (error) {
                error.classList.add('hidden');
            }
        }
    }
})();
</script>