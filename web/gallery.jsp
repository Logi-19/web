<%-- 
    Document   : gallery
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gallery · Ocean View Resort Galle</title>
    <!-- Tailwind via CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        
        .gallery-item {
            transition: all 0.3s;
            border-radius: 1rem;
            overflow: hidden;
            background: white;
            border: 1px solid #b5e5e0;
        }
        
        .gallery-item:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 25px -5px rgba(2, 116, 140, 0.15);
        }
        
        .gallery-image-container {
            position: relative;
            height: 200px;
            overflow: hidden;
        }
        
        .gallery-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }
        
        .gallery-item:hover .gallery-image {
            transform: scale(1.05);
        }
        
        .image-count-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0, 0, 0, 0.6);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            backdrop-filter: blur(4px);
        }
        
        .category-badge {
            position: absolute;
            top: 10px;
            left: 10px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(4px);
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            color: #03738C;
            border: 1px solid rgba(181, 229, 224, 0.5);
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        
        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #0284a8;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 40px auto;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .filter-btn {
            transition: all 0.2s ease;
        }
        
        .filter-btn.active {
            background-color: #0284a8;
            color: white;
            border-color: #0284a8;
        }
        
        .filter-btn.active i {
            color: white;
        }
        
        /* Gallery view modal */
        .modal-overlay {
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
        }
        
        .gallery-view-container {
            position: relative;
            width: 100%;
            height: 400px;
            overflow: hidden;
            border-radius: 0.75rem;
        }
        
        .gallery-view-image {
            width: 100%;
            height: 100%;
            object-fit: contain;
            background: #f0f7fa;
        }
        
        .gallery-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
            border: 1px solid #b5e5e0;
        }
        
        .gallery-nav:hover {
            background: white;
            transform: translateY(-50%) scale(1.1);
        }
        
        .gallery-nav.prev {
            left: 10px;
        }
        
        .gallery-nav.next {
            right: 10px;
        }
        
        .gallery-dots {
            position: absolute;
            bottom: 10px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 0.5rem;
        }
        
        .gallery-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.5);
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .gallery-dot.active {
            background: #0284a8;
            transform: scale(1.2);
        }
        
        .line-clamp-1 {
            display: -webkit-box;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .line-clamp-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        /* Gallery grid */
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
        }
    </style>
</head>
<body class="bg-[#f8fafc] text-[#1e3c5c] antialiased">

    <!-- Include Navbar -->
    <jsp:include page="component/navbar.jsp" />
    
    <!-- ===== GALLERY HERO SECTION ===== -->
    <section class="relative overflow-hidden -mt-20">
        <div class="absolute inset-0 z-0">
            <div class="absolute inset-0 bg-gradient-to-r from-[#022b42]/60 via-[#03738C]/40 to-[#6ab0a8]/40 z-10"></div>
            <img src="https://images.unsplash.com/photo-1544644181-1484b3fdfc62?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" 
                 alt="Ocean View Resort Gallery" 
                 class="w-full h-full object-cover object-center">
        </div>
        <div class="relative z-20 max-w-6xl mx-auto px-6 md:px-10 py-24 md:py-32 text-white">
            <div class="max-w-3xl">
                <span class="inline-block bg-[#b0e0e6]/30 backdrop-blur-sm px-4 py-1.5 rounded-full text-sm font-medium border border-[#caf0f8]/40 mb-6 text-[#f0f9ff]">
                    <i class="fas fa-camera mr-2"></i>Our Precious Moments
                </span>
                <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold leading-tight">
                    Gallery <br><span class="text-[#f8e4c3]">Ocean View Resort</span>
                </h1>
                <p class="text-lg md:text-xl text-[#f0f9ff] mt-6 max-w-xl">
                    Explore the beauty of our resort through these captured moments. From stunning sunsets to luxurious interiors.
                </p>
            </div>
        </div>
        <div class="relative z-20 -mb-1 w-full rotate-180 text-[#b5e5e0]">
            <svg viewBox="0 0 1440 120" fill="none" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" class="w-full h-12 md:h-16 opacity-40">
                <path d="M0 0L60 15C120 30 240 60 360 65C480 70 600 50 720 40C840 30 960 30 1080 40C1200 50 1320 70 1380 80L1440 90V120H1380C1320 120 1200 120 1080 120C960 120 840 120 720 120C600 120 480 120 360 120C240 120 120 120 60 120H0V0Z" fill="currentColor" fill-opacity="0.8"/>
            </svg>
        </div>
    </section>

    <!-- ===== GALLERY FILTER SECTION ===== -->
    <section class="bg-white py-8 shadow-sm sticky top-0 z-30">
        <div class="max-w-7xl mx-auto px-6">
            <div class="flex flex-wrap items-center justify-between gap-4">
                <div class="flex items-center gap-3">
                    <i class="fas fa-images text-[#0284a8] text-xl"></i>
                    <h2 class="text-xl font-semibold text-[#1e3c5c]">Resort Gallery</h2>
                    <span id="gallery-count" class="bg-[#b5e5e0] text-[#03738C] px-3 py-1 rounded-full text-xs font-medium">0 items</span>
                </div>
                
                <div class="flex flex-wrap gap-2" id="category-filters">
                    <button class="filter-btn active px-4 py-2 rounded-full text-sm font-medium border border-[#b5e5e0] transition-all" data-category="all">
                        <i class="fas fa-th-large mr-1"></i>All
                    </button>
                </div>
                
                <div class="relative">
                    <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-[#8ba9c2] text-sm"></i>
                    <input type="text" id="search-input" placeholder="Search gallery..." 
                           class="pl-9 pr-4 py-2 border border-[#b5e5e0] rounded-full text-sm focus:outline-none focus:ring-2 focus:ring-[#0284a8] focus:border-transparent w-64">
                </div>
            </div>
        </div>
    </section>

    <!-- ===== GALLERY GRID SECTION ===== -->
    <section class="py-16 bg-gradient-to-b from-white to-[#f0f7fa] min-h-screen">
        <div class="max-w-7xl mx-auto px-6">
            <!-- Loading Spinner -->
            <div id="loading-spinner" class="loading-spinner"></div>
            
            <!-- Error Message -->
            <div id="error-message" class="hidden text-center py-12">
                <i class="fas fa-exclamation-circle text-5xl text-red-400 mb-4"></i>
                <h3 class="text-xl font-semibold text-[#1e3c5c] mb-2">Failed to Load Gallery</h3>
                <p class="text-[#3a5a78] mb-4">Please try refreshing the page</p>
                <button onclick="loadGalleryItems()" class="bg-[#0284a8] text-white px-6 py-2 rounded-full text-sm hover:bg-[#03738C] transition">
                    <i class="fas fa-sync-alt mr-2"></i>Retry
                </button>
            </div>
            
            <!-- No Results Message -->
            <div id="no-results" class="hidden text-center py-16">
                <i class="fas fa-image text-6xl text-[#b5e5e0] mb-4"></i>
                <h3 class="text-2xl font-semibold text-[#1e3c5c] mb-2">No gallery items found</h3>
                <p class="text-[#3a5a78]">Check back later for new photos!</p>
            </div>
            
            <!-- Gallery Grid -->
            <div id="gallery-grid" class="gallery-grid"></div>
        </div>
    </section>

    <!-- View Gallery Modal -->
    <div id="viewModal" class="fixed inset-0 z-50 hidden items-center justify-center p-4 modal-overlay">
        <div class="bg-white rounded-2xl shadow-xl max-w-4xl w-full p-6 transform transition-all max-h-[90vh] overflow-y-auto">
            <div class="flex justify-between items-start mb-4">
                <h3 class="text-xl font-bold text-[#1e3c5c]" id="modal-title">Gallery Item Details</h3>
                <button onclick="closeViewModal()" class="text-[#3a5a78] hover:text-[#1e3c5c]">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>
            
            <div id="modal-content" class="space-y-4">
                <!-- Images Gallery -->
                <div id="modal-images-container" class="col-span-2">
                    <div class="gallery-view-container" id="gallery-view-container">
                        <img id="modal-current-image" class="gallery-view-image" src="" alt="Gallery Image">
                        
                        <!-- Navigation -->
                        <button class="gallery-nav prev" onclick="changeModalImage(-1)" id="prev-image-btn" style="display: none;">
                            ←
                        </button>
                        <button class="gallery-nav next" onclick="changeModalImage(1)" id="next-image-btn" style="display: none;">
                            →
                        </button>
                        
                        <!-- Dots -->
                        <div class="gallery-dots" id="image-dots"></div>
                    </div>
                </div>
                
                <!-- No Images -->
                <div id="no-images-message" class="col-span-2 hidden">
                    <div class="bg-[#f0f7fa] p-8 rounded-lg text-center text-[#3a5a78]">
                        No images available
                    </div>
                </div>
                
                <!-- Details -->
                <div class="grid grid-cols-2 gap-4 mt-4">
                    <!-- Title -->
                    <div class="col-span-2">
                        <p class="text-sm text-[#3a5a78]">Title</p>
                        <p class="font-medium text-[#1e3c5c]" id="modal-item-title"></p>
                    </div>
                    
                    <!-- Description -->
                    <div class="col-span-2">
                        <p class="text-sm text-[#3a5a78]">Description</p>
                        <p class="text-[#1e3c5c] bg-[#f0f7fa] p-3 rounded-lg whitespace-pre-wrap" id="modal-item-description"></p>
                    </div>
                    
                    <!-- Category -->
                    <div>
                        <p class="text-sm text-[#3a5a78]">Category</p>
                        <p class="font-medium text-[#1e3c5c]" id="modal-item-category"></p>
                    </div>
                    
                    <!-- Posted Date -->
                    <div>
                        <p class="text-sm text-[#3a5a78]">Posted Date</p>
                        <p class="font-medium text-[#1e3c5c]" id="modal-item-date"></p>
                    </div>
                    
                    <!-- Image Count -->
                    <div class="col-span-2">
                        <p class="text-sm text-[#3a5a78]">Total Images</p>
                        <p class="font-medium text-[#1e3c5c]" id="modal-image-count"></p>
                    </div>
                </div>
            </div>
            
            <div class="flex justify-end mt-6">
                <button onclick="closeViewModal()" class="px-4 py-2 rounded-lg bg-[#0284a8] text-white hover:bg-[#03738C] transition text-sm font-medium">
                    Close
                </button>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="component/footer.jsp" />

    <script>
        // Get context path
        const contextPath = '${pageContext.request.contextPath}';
        
        // Store gallery data
        let allGalleryItems = [];
        let filteredItems = [];
        let categories = [];
        let currentCategory = 'all';
        
        // Modal state
        let currentImagesList = [];
        let currentImageIndex = 0;
        let currentItemTitle = '';
        
        // Date formatter
        function formatDate(dateTimeStr) {
            if (!dateTimeStr) return 'Recently added';
            try {
                const date = new Date(dateTimeStr);
                return date.toLocaleDateString('en-US', { 
                    year: 'numeric', 
                    month: 'short', 
                    day: 'numeric' 
                });
            } catch (e) {
                return 'Recently added';
            }
        }
        
        // Fix image URL - handles paths like "/wepapp/uploads/gallery/filename.jpeg"
        function getImageUrl(url) {
            if (!url) return null;
            if (url.startsWith('http')) return url;
            if (url.startsWith('/wepapp/')) return url;
            if (url.startsWith('/uploads')) return contextPath + url;
            if (url.startsWith('uploads/')) return contextPath + '/' + url;
            return contextPath + '/' + url.replace(/^\/+/, '');
        }
        
        // Load gallery items
        async function loadGalleryItems() {
            const spinner = document.getElementById('loading-spinner');
            const errorMsg = document.getElementById('error-message');
            const noResults = document.getElementById('no-results');
            const galleryGrid = document.getElementById('gallery-grid');
            const galleryCount = document.getElementById('gallery-count');
            
            spinner.classList.remove('hidden');
            errorMsg.classList.add('hidden');
            noResults.classList.add('hidden');
            galleryGrid.innerHTML = '';
            
            try {
                const response = await fetch(contextPath + '/managegallery/api/visible');
                
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                
                const items = await response.json();
                console.log('Loaded gallery items:', items);
                
                allGalleryItems = items.filter(item => item.status === true);
                
                if (allGalleryItems.length === 0) {
                    spinner.classList.add('hidden');
                    noResults.classList.remove('hidden');
                    galleryCount.textContent = '0 items';
                    return;
                }
                
                // Extract unique categories
                const categoryMap = new Map();
                allGalleryItems.forEach(item => {
                    if (item.categoryId && !categoryMap.has(item.categoryId)) {
                        categoryMap.set(item.categoryId, {
                            id: item.categoryId,
                            name: item.categoryName || `Category ${item.categoryId}`
                        });
                    }
                });
                
                categories = Array.from(categoryMap.values());
                
                // Update category filters
                updateCategoryFilters();
                
                // Update gallery count
                galleryCount.textContent = allGalleryItems.length + ' items';
                
                // Display all items
                filteredItems = [...allGalleryItems];
                displayGalleryItems(filteredItems);
                
                spinner.classList.add('hidden');
                
            } catch (error) {
                console.error('Error loading gallery:', error);
                spinner.classList.add('hidden');
                errorMsg.classList.remove('hidden');
                galleryCount.textContent = '0 items';
            }
        }
        
        // Update category filter buttons
        function updateCategoryFilters() {
            const filterContainer = document.getElementById('category-filters');
            const allButton = filterContainer.querySelector('[data-category="all"]');
            
            filterContainer.innerHTML = '';
            filterContainer.appendChild(allButton);
            
            categories.forEach(category => {
                const button = document.createElement('button');
                button.className = 'filter-btn px-4 py-2 rounded-full text-sm font-medium border border-[#b5e5e0] transition-all hover:bg-[#b5e5e0] hover:text-[#03738C]';
                button.setAttribute('data-category', category.id);
                button.innerHTML = '<i class="fas fa-tag mr-1"></i>' + category.name;
                button.addEventListener('click', function() { filterByCategory(category.id); });
                filterContainer.appendChild(button);
            });
            
            allButton.addEventListener('click', function() { filterByCategory('all'); });
        }
        
        // Filter by category
        function filterByCategory(categoryId) {
            document.querySelectorAll('.filter-btn').forEach(btn => {
                btn.classList.remove('active', 'bg-[#0284a8]', 'text-white');
            });
            
            const activeBtn = document.querySelector(`[data-category="${categoryId}"]`);
            if (activeBtn) {
                activeBtn.classList.add('active', 'bg-[#0284a8]', 'text-white');
            }
            
            currentCategory = categoryId;
            applyFilters();
        }
        
        // Apply filters
        function applyFilters() {
            const searchTerm = document.getElementById('search-input').value.toLowerCase().trim();
            
            filteredItems = allGalleryItems.filter(item => {
                if (currentCategory !== 'all' && item.categoryId != currentCategory) {
                    return false;
                }
                if (searchTerm) {
                    return (item.title && item.title.toLowerCase().includes(searchTerm)) ||
                           (item.description && item.description.toLowerCase().includes(searchTerm));
                }
                return true;
            });
            
            displayGalleryItems(filteredItems);
            
            const noResults = document.getElementById('no-results');
            if (filteredItems.length === 0) {
                noResults.classList.remove('hidden');
            } else {
                noResults.classList.add('hidden');
            }
            
            document.getElementById('gallery-count').textContent = filteredItems.length + ' items';
        }
        
        // Display gallery items
        function displayGalleryItems(items) {
            const galleryGrid = document.getElementById('gallery-grid');
            
            if (!items || items.length === 0) {
                galleryGrid.innerHTML = '';
                return;
            }
            
            let html = '';
            
            for (let i = 0; i < items.length; i++) {
                const item = items[i];
                const images = item.images || [];
                let coverImage = 'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80';
                
                if (images.length > 0) {
                    const imageUrl = getImageUrl(images[0]);
                    if (imageUrl) {
                        coverImage = imageUrl;
                    }
                }
                
                const imageCount = images.length;
                const formattedDate = formatDate(item.postedDate);
                const categoryName = item.categoryName || 'Uncategorized';
                
                html += '<div class="gallery-item cursor-pointer" onclick="openViewModal(' + i + ')">';
                html += '<div class="gallery-image-container">';
                html += '<img src="' + coverImage + '" alt="' + (item.title || 'Gallery image') + '" class="gallery-image" onerror="this.onerror=null; this.src=\'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80\'">';
                html += '<div class="category-badge"><i class="fas fa-tag mr-1"></i>' + categoryName + '</div>';
                
                if (imageCount > 1) {
                    html += '<div class="image-count-badge"><i class="fas fa-images mr-1"></i> ' + imageCount + ' photos</div>';
                }
                
                html += '</div>';
                html += '<div class="p-4">';
                html += '<h3 class="font-bold text-[#1e3c5c] mb-1 line-clamp-1">' + (item.title || 'Untitled') + '</h3>';
                html += '<p class="text-xs text-[#3a5a78] mb-2 line-clamp-2">' + (item.description || 'No description available.') + '</p>';
                html += '<div class="flex items-center justify-between mt-2">';
                html += '<span class="text-xs text-[#3a5a78]"><i class="far fa-calendar-alt mr-1"></i>' + formattedDate + '</span>';
                html += '<span class="text-[#0284a8] text-sm font-medium flex items-center gap-1 group">View <i class="fas fa-arrow-right text-xs group-hover:translate-x-1 transition-transform"></i></span>';
                html += '</div></div></div>';
            }
            
            galleryGrid.innerHTML = html;
        }
        
        // Open view modal
        function openViewModal(itemIndex) {
            const item = filteredItems[itemIndex];
            if (!item) return;
            
            // Set images list
            currentImagesList = [];
            if (item.images && item.images.length > 0) {
                for (let i = 0; i < item.images.length; i++) {
                    const imageUrl = getImageUrl(item.images[i]);
                    if (imageUrl) {
                        currentImagesList.push(imageUrl);
                    }
                }
            }
            
            currentImageIndex = 0;
            currentItemTitle = item.title || 'Gallery';
            
            // Set modal content
            document.getElementById('modal-item-title').textContent = item.title || '';
            document.getElementById('modal-item-description').textContent = item.description || 'No description available.';
            document.getElementById('modal-item-category').textContent = item.categoryName || 'Uncategorized';
            document.getElementById('modal-item-date').textContent = formatDate(item.postedDate);
            document.getElementById('modal-image-count').textContent = currentImagesList.length + ' images';
            
            // Show/hide image elements
            const imagesContainer = document.getElementById('modal-images-container');
            const noImagesMsg = document.getElementById('no-images-message');
            const prevBtn = document.getElementById('prev-image-btn');
            const nextBtn = document.getElementById('next-image-btn');
            const dotsContainer = document.getElementById('image-dots');
            
            if (currentImagesList.length > 0) {
                imagesContainer.classList.remove('hidden');
                noImagesMsg.classList.add('hidden');
                
                // Set current image
                document.getElementById('modal-current-image').src = currentImagesList[0];
                
                // Show/hide navigation
                if (currentImagesList.length > 1) {
                    prevBtn.style.display = 'flex';
                    nextBtn.style.display = 'flex';
                    
                    // Create dots
                    let dotsHtml = '';
                    for (let i = 0; i < currentImagesList.length; i++) {
                        const activeClass = (i === 0) ? 'active' : '';
                        dotsHtml += '<div class="gallery-dot ' + activeClass + '" onclick="setModalImage(' + i + ')"></div>';
                    }
                    dotsContainer.innerHTML = dotsHtml;
                } else {
                    prevBtn.style.display = 'none';
                    nextBtn.style.display = 'none';
                    dotsContainer.innerHTML = '';
                }
            } else {
                imagesContainer.classList.add('hidden');
                noImagesMsg.classList.remove('hidden');
            }
            
            // Show modal
            document.getElementById('viewModal').classList.remove('hidden');
            document.getElementById('viewModal').classList.add('flex');
            document.body.style.overflow = 'hidden';
        }
        
        // Close view modal
        function closeViewModal() {
            document.getElementById('viewModal').classList.add('hidden');
            document.getElementById('viewModal').classList.remove('flex');
            document.body.style.overflow = 'auto';
        }
        
        // Change modal image
        function changeModalImage(direction) {
            if (currentImagesList.length === 0) return;
            
            currentImageIndex = currentImageIndex + direction;
            
            if (currentImageIndex < 0) {
                currentImageIndex = currentImagesList.length - 1;
            } else if (currentImageIndex >= currentImagesList.length) {
                currentImageIndex = 0;
            }
            
            document.getElementById('modal-current-image').src = currentImagesList[currentImageIndex];
            
            // Update dots
            const dots = document.querySelectorAll('.gallery-dot');
            for (let i = 0; i < dots.length; i++) {
                if (i === currentImageIndex) {
                    dots[i].classList.add('active');
                } else {
                    dots[i].classList.remove('active');
                }
            }
        }
        
        // Set modal image to specific index
        function setModalImage(index) {
            if (currentImagesList.length === 0 || index < 0 || index >= currentImagesList.length) return;
            
            currentImageIndex = index;
            document.getElementById('modal-current-image').src = currentImagesList[index];
            
            // Update dots
            const dots = document.querySelectorAll('.gallery-dot');
            for (let i = 0; i < dots.length; i++) {
                if (i === index) {
                    dots[i].classList.add('active');
                } else {
                    dots[i].classList.remove('active');
                }
            }
        }
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            loadGalleryItems();
            
            // Search input with debounce
            let searchTimeout;
            document.getElementById('search-input').addEventListener('input', function() {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(function() {
                    applyFilters();
                }, 300);
            });
            
            // Close modal with Escape key
            document.addEventListener('keydown', function(e) {
                const modal = document.getElementById('viewModal');
                if (modal.classList.contains('flex') && e.key === 'Escape') {
                    closeViewModal();
                }
                
                if (modal.classList.contains('flex') && e.key === 'ArrowLeft') {
                    changeModalImage(-1);
                } else if (modal.classList.contains('flex') && e.key === 'ArrowRight') {
                    changeModalImage(1);
                }
            });
        });
    </script>
</body>
</html>