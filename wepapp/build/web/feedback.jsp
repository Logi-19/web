<%-- 
    Document   : feedback
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- ===== GUEST FEEDBACK FORM ===== -->
<section class="bg-gradient-to-b from-white to-[#f0f7fa] py-16 md:py-20 feedback-section" id="feedback-form">
    <div class="max-w-4xl mx-auto px-6">
        <!-- decorative header -->
        <div class="text-center mb-10 relative">
            <div class="absolute left-1/2 -top-10 transform -translate-x-1/2 text-5xl opacity-10">🗣️</div>
            <span class="text-[#0284a8] font-semibold tracking-wider text-sm uppercase bg-[#b5e5e0]/20 px-4 py-2 rounded-full">We're listening</span>
            <h2 class="text-3xl md:text-4xl font-bold text-[#1e3c5c] mt-3">Tell us about your stay</h2>
            <div class="w-32 h-1.5 bg-gradient-to-r from-[#b5e5e0] via-[#0284a8] to-[#f8e4c3] mx-auto mt-4 rounded-full"></div>
            <p class="text-[#3a5a78] mt-5 max-w-2xl mx-auto">Your feedback helps us improve and create better experiences for all our guests.</p>
        </div>

        <!-- main feedback card -->
        <div class="bg-white/90 backdrop-blur-sm rounded-3xl shadow-2xl border border-[#b5e5e0] overflow-hidden card-hover">
            <div class="h-3 bg-gradient-to-r from-[#0284a8] via-[#b5e5e0] to-[#f8e4c3]"></div>
            
            <div class="p-8 md:p-10">
                <form id="feedbackForm" onsubmit="handleSubmit(event)" class="space-y-6">
                    <!-- name + email row -->
                    <div class="grid md:grid-cols-2 gap-6">
                        <!-- name field -->
                        <div class="group">
                            <label for="name" class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                Full name <span class="text-[#0284a8]">*</span>
                            </label>
                            <div class="relative">
                                <span class="absolute left-4 top-3.5 text-[#b5e5e0] text-xl group-focus-within:text-[#0284a8] transition-colors">👤</span>
                                <input type="text" id="name" name="name" required 
                                       class="w-full pl-12 pr-4 py-3.5 rounded-2xl border-2 border-[#d1e6e0] bg-white/80 input-focus text-[#1e3c5c] placeholder:text-[#8aa9b9]"
                                       placeholder="e.g. Nimali Perera">
                            </div>
                        </div>
                        <!-- email field -->
                        <div class="group">
                            <label for="email" class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                                Email address <span class="text-[#0284a8]">*</span>
                            </label>
                            <div class="relative">
                                <span class="absolute left-4 top-3.5 text-[#b5e5e0] text-xl group-focus-within:text-[#0284a8] transition-colors">✉️</span>
                                <input type="email" id="email" name="email" required 
                                       class="w-full pl-12 pr-4 py-3.5 rounded-2xl border-2 border-[#d1e6e0] bg-white/80 input-focus text-[#1e3c5c] placeholder:text-[#8aa9b9]"
                                       placeholder="your@email.com">
                            </div>
                        </div>
                    </div>

                    <!-- rating field with colored stars -->
                    <div>
                        <label class="block text-sm font-semibold text-[#1e3c5c] mb-3">
                            Your rating <span class="text-[#0284a8]">*</span>
                        </label>
                        <div class="flex flex-wrap gap-4 items-center">
                            <div class="flex gap-2 bg-[#f0f7fa] p-3 rounded-2xl border-2 border-[#d1e6e0]">
                                <span onclick="setRating(1)" class="rating-star text-4xl" data-rating="1" id="star1">★</span>
                                <span onclick="setRating(2)" class="rating-star text-4xl" data-rating="2" id="star2">★</span>
                                <span onclick="setRating(3)" class="rating-star text-4xl" data-rating="3" id="star3">★</span>
                                <span onclick="setRating(4)" class="rating-star text-4xl" data-rating="4" id="star4">★</span>
                                <span onclick="setRating(5)" class="rating-star text-4xl" data-rating="5" id="star5">★</span>
                            </div>
                            <input type="hidden" id="rating" name="rating" value="0">
                            <span class="text-sm text-[#3a5a78] bg-white px-4 py-2 rounded-full border border-[#d1e6e0]" id="rating-label">select stars</span>
                        </div>
                        <!-- rating emoji helper with colors -->
                        <div class="mt-2 text-xs flex gap-2">
                            <span style="color: #ef4444;">😞 Poor</span>
                            <span style="color: #f97316;">😐 Fair</span>
                            <span style="color: #eab308;">🙂 Good</span>
                            <span style="color: #84cc16;">😊 Very Good</span>
                            <span style="color: #22c55e;">🤩 Excellent</span>
                        </div>
                    </div>

                    <!-- message field -->
                    <div>
                        <label for="message" class="block text-sm font-semibold text-[#1e3c5c] mb-2">
                            Your feedback <span class="text-[#0284a8]">*</span>
                        </label>
                        <div class="relative">
                            <span class="absolute left-4 top-4 text-[#b5e5e0] text-xl">💬</span>
                            <textarea id="message" name="message" rows="4" required
                                      class="w-full pl-12 pr-4 py-3.5 rounded-2xl border-2 border-[#d1e6e0] bg-white/80 input-focus text-[#1e3c5c] placeholder:text-[#8aa9b9]"
                                      placeholder="Tell us about your experience... what did you love? what can we improve?"
                                      oninput="updateCharCount(this)"></textarea>
                        </div>
                        <div class="text-right mt-1 text-xs text-[#8aa9b9]" id="charCount">
                            0/500 characters
                        </div>
                    </div>

                    <!-- submit button with loading state -->
                    <div class="pt-4 flex justify-center md:justify-end">
                        <button type="submit" id="submitBtn" 
                                class="bg-gradient-to-r from-[#0284a8] to-[#03738C] hover:from-[#03738C] hover:to-[#0284a8] text-white font-semibold px-10 py-4 rounded-full shadow-xl transition-all transform hover:scale-105 flex items-center gap-3 group">
                            <span class="text-xl group-hover:rotate-12 transition-transform" id="submitIcon">📨</span>
                            <span id="submitText">Submit feedback</span>
                            <span class="opacity-0 group-hover:opacity-100 transition-opacity" id="submitArrow">→</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- Simple JavaScript for form functionality with backend integration -->
<script>
    // Get context path for API calls
    const contextPath = '${pageContext.request.contextPath}';
    
    // Rating functionality
    let currentRating = 0;
    
    // Star colors for each rating level (all selected stars show the highest selected star's color)
    const starColors = {
        1: '#ef4444', // Red for 1 star
        2: '#f97316', // Orange for 2 stars
        3: '#eab308', // Yellow for 3 stars
        4: '#84cc16', // Lime for 4 stars
        5: '#22c55e'  // Green for 5 stars
    };
    
    // Wait for DOM to be fully loaded
    document.addEventListener('DOMContentLoaded', function() {
        console.log('Feedback form initialized');
        
        // Initialize stars with gray color
        const stars = document.querySelectorAll('.rating-star');
        stars.forEach(star => {
            star.style.color = '#9ca3af'; // Gray color for unselected stars
        });
    });

    function setRating(rating) {
        currentRating = rating;
        const ratingInput = document.getElementById('rating');
        const ratingLabel = document.getElementById('rating-label');
        const stars = document.querySelectorAll('.rating-star');
        
        ratingInput.value = rating;
        
        // Get the color for this rating level
        const selectedColor = starColors[rating];
        
        // Update star colors - all selected stars get the same color (the highest selected star's color)
        stars.forEach((star, index) => {
            const starRating = index + 1;
            if (starRating <= rating) {
                star.classList.add('selected');
                star.style.color = selectedColor; // All selected stars get the same color
            } else {
                star.classList.remove('selected');
                star.style.color = '#9ca3af'; // Gray for unselected
            }
        });
        
        // Update label
        const labels = ['', '😞 Poor (1/5)', '😐 Fair (2/5)', '🙂 Good (3/5)', '😊 Very Good (4/5)', '🤩 Excellent (5/5)'];
        ratingLabel.textContent = labels[rating];
        
        // Show notification using the global notification system
        if (window.showSuccess) {
            window.showSuccess(`You rated: ${labels[rating]}`, 3000);
        }
    }

    // Character counter
    function updateCharCount(textarea) {
        const charCount = document.getElementById('charCount');
        const length = textarea.value.length;
        charCount.textContent = length + '/500 characters';
        
        // Change color if approaching limit
        if (length > 480) {
            charCount.style.color = '#dc2626';
        } else if (length > 450) {
            charCount.style.color = '#f97316';
        } else {
            charCount.style.color = '#8aa9b9';
        }
    }

    // Show loading state on submit button
    function setLoading(isLoading) {
        const submitBtn = document.getElementById('submitBtn');
        const submitText = document.getElementById('submitText');
        const submitIcon = document.getElementById('submitIcon');
        const submitArrow = document.getElementById('submitArrow');
        
        if (isLoading) {
            submitBtn.disabled = true;
            submitBtn.classList.add('opacity-75', 'cursor-not-allowed');
            submitText.textContent = 'Submitting...';
            submitIcon.textContent = '⏳';
            submitArrow.classList.add('opacity-0');
        } else {
            submitBtn.disabled = false;
            submitBtn.classList.remove('opacity-75', 'cursor-not-allowed');
            submitText.textContent = 'Submit feedback';
            submitIcon.textContent = '📨';
            submitArrow.classList.remove('opacity-0');
        }
    }

    // Reset form to initial state
    function resetForm() {
        document.getElementById('name').value = '';
        document.getElementById('email').value = '';
        document.getElementById('rating').value = '0';
        document.getElementById('message').value = '';
        document.getElementById('charCount').textContent = '0/500 characters';
        
        // Reset stars to gray
        const stars = document.querySelectorAll('.rating-star');
        stars.forEach(star => {
            star.classList.remove('selected');
            star.style.color = '#9ca3af'; // Gray for unselected
        });
        document.getElementById('rating-label').textContent = 'select stars';
        currentRating = 0;
    }

    // Form submission with backend integration
    function handleSubmit(event) {
        event.preventDefault();
        
        const name = document.getElementById('name').value.trim();
        const email = document.getElementById('email').value.trim();
        const rating = parseInt(document.getElementById('rating').value);
        const message = document.getElementById('message').value.trim();
        
        // Validate rating
        if (rating === 0) {
            if (window.showError) {
                window.showError('Please select a rating', 3000);
            }
            return;
        }
        
        // Validate name
        if (!name) {
            if (window.showError) {
                window.showError('Please enter your name', 3000);
            }
            return;
        }
        
        // Validate email
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            if (window.showError) {
                window.showError('Please enter a valid email address', 3000);
            }
            return;
        }
        
        // Validate message - minimum 4 characters as requested
        if (message.length < 4) {
            if (window.showError) {
                window.showError('Please provide more detailed feedback (minimum 4 characters)', 3000);
            }
            return;
        }
        
        // Show loading state
        setLoading(true);
        
        // Create form data
        const formData = new URLSearchParams();
        formData.append('name', name);
        formData.append('email', email);
        formData.append('rating', rating);
        formData.append('message', message);
        
        // Log form data
        console.log('Submitting feedback:', { name, email, rating, message });
        
        // Send to backend using fetch API
        fetch(contextPath + '/feedback/submit', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData.toString()
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            console.log('Server response:', data);
            
            if (data.success) {
                // Show success notification
                if (window.showSuccess) {
                    window.showSuccess(data.message || 'Thank you for your feedback! 🌊', 3000);
                }
                
                // Reset form
                resetForm();
            } else {
                // Show error notification
                if (window.showError) {
                    window.showError(data.message || 'Failed to submit feedback. Please try again.', 3000);
                }
            }
        })
        .catch(error => {
            console.error('Error submitting feedback:', error);
            
            // Show error notification
            if (window.showError) {
                window.showError('Network error. Please check your connection and try again.', 3000);
            }
        })
        .finally(() => {
            // Hide loading state
            setLoading(false);
        });
    }

    // Optional: Add function to fetch and display existing feedback count
    function fetchFeedbackStats() {
        fetch(contextPath + '/feedback/api/stats')
            .then(response => response.json())
            .then(stats => {
                console.log('Feedback stats:', stats);
                // You can display stats somewhere if needed
            })
            .catch(error => console.error('Error fetching stats:', error));
    }

    // Call on page load if needed
    // document.addEventListener('DOMContentLoaded', fetchFeedbackStats);
</script>

<!-- Essential CSS for rating stars and cards -->
<style>
    .rating-star {
        transition: all 0.2s;
        cursor: pointer;
        font-size: 2rem;
        color: #9ca3af; /* Default gray color */
    }
    .rating-star:hover {
        transform: scale(1.2);
    }
    .rating-star.selected {
        text-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
    }
    .input-focus {
        transition: all 0.2s;
    }
    .input-focus:focus {
        border-color: #0284a8;
        box-shadow: 0 0 0 4px rgba(2, 132, 168, 0.15);
        outline: none;
    }
    .card-hover { transition: transform 0.2s ease, box-shadow 0.2s ease; }
    .card-hover:hover { transform: translateY(-4px); box-shadow: 0 20px 30px -10px rgba(2, 136, 209, 0.15); }
    
    /* Loading state styles */
    button:disabled {
        cursor: not-allowed;
        transform: none !important;
    }
</style>