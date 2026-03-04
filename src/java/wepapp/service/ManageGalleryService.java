package wepapp.service;

import wepapp.dao.ManageGalleryDAO;
import wepapp.dao.BlogCategoryDAO;
import wepapp.model.ManageGallery;
import wepapp.model.BlogCategory;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

// Strategy Pattern - Validation Strategy Interface
interface GalleryValidationStrategy {
    boolean validate(ManageGallery item);
    String getErrorMessage();
}

// Title Validation Strategy
class GalleryTitleValidationStrategy implements GalleryValidationStrategy {
    private static final int MIN_TITLE_LENGTH = 3;
    private static final int MAX_TITLE_LENGTH = 200;
    
    @Override
    public boolean validate(ManageGallery item) {
        String title = item.getTitle();
        return title != null && 
               !title.trim().isEmpty() &&
               title.length() >= MIN_TITLE_LENGTH &&
               title.length() <= MAX_TITLE_LENGTH;
    }
    
    @Override
    public String getErrorMessage() {
        return "Title must be between " + MIN_TITLE_LENGTH + " and " + MAX_TITLE_LENGTH + " characters";
    }
}

// Description Validation Strategy
class GalleryDescriptionValidationStrategy implements GalleryValidationStrategy {
    private static final int MIN_DESC_LENGTH = 10;
    private static final int MAX_DESC_LENGTH = 1000;
    
    @Override
    public boolean validate(ManageGallery item) {
        String desc = item.getDescription();
        return desc != null && 
               !desc.trim().isEmpty() &&
               desc.length() >= MIN_DESC_LENGTH &&
               desc.length() <= MAX_DESC_LENGTH;
    }
    
    @Override
    public String getErrorMessage() {
        return "Description must be between " + MIN_DESC_LENGTH + " and " + MAX_DESC_LENGTH + " characters";
    }
}

// Category Validation Strategy
class GalleryCategoryValidationStrategy implements GalleryValidationStrategy {
    private final BlogCategoryDAO categoryDAO;
    
    public GalleryCategoryValidationStrategy() {
        this.categoryDAO = BlogCategoryDAO.getInstance();
    }
    
    @Override
    public boolean validate(ManageGallery item) {
        int categoryId = item.getCategoryId();
        if (categoryId <= 0) {
            return false;
        }
        
        BlogCategory category = categoryDAO.findById(categoryId);
        return category != null;
    }
    
    @Override
    public String getErrorMessage() {
        return "Please select a valid category";
    }
}

// Images Validation Strategy
class GalleryImagesValidationStrategy implements GalleryValidationStrategy {
    @Override
    public boolean validate(ManageGallery item) {
        return item.getImages() != null && !item.getImages().isEmpty();
    }
    
    @Override
    public String getErrorMessage() {
        return "At least one image is required";
    }
}

// Main Service Class
public class ManageGalleryService {
    private final ManageGalleryDAO galleryDAO;
    private final BlogCategoryDAO categoryDAO;
    private final List<GalleryValidationStrategy> validators;
    
    public ManageGalleryService() {
        this.galleryDAO = ManageGalleryDAO.getInstance();
        this.categoryDAO = BlogCategoryDAO.getInstance();
        this.validators = List.of(
            new GalleryTitleValidationStrategy(),
            new GalleryDescriptionValidationStrategy(),
            new GalleryCategoryValidationStrategy(),
            new GalleryImagesValidationStrategy()
        );
    }
    
    // Validate gallery item using all strategies
    public ValidationResult validateGalleryItem(ManageGallery item) {
        for (GalleryValidationStrategy validator : validators) {
            if (!validator.validate(item)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Create new gallery item
    public ValidationResult createGalleryItem(ManageGallery item) {
        // Validate first
        ValidationResult validationResult = validateGalleryItem(item);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Set timestamps
        item.setPostedDate(LocalDateTime.now());
        item.setUpdatedDate(LocalDateTime.now());
        
        // Save to database
        boolean saved = galleryDAO.save(item);
        
        if (saved) {
            return new ValidationResult(true, "Gallery item added successfully!");
        } else {
            return new ValidationResult(false, "Failed to add gallery item. Please try again.");
        }
    }
    
    // Update gallery item
    public ValidationResult updateGalleryItem(ManageGallery item) {
        // Validate the item before updating
        ValidationResult validationResult = validateGalleryItem(item);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Set updated timestamp
        item.setUpdatedDate(LocalDateTime.now());

        // Update in database
        boolean updated = galleryDAO.update(item);
        
        if (updated) {
            return new ValidationResult(true, "Gallery item updated successfully!");
        } else {
            return new ValidationResult(false, "Failed to update gallery item. Please try again.");
        }
    }
    
    // Get all gallery items
    public List<ManageGallery> getAllGalleryItems() {
        List<ManageGallery> items = galleryDAO.findAll();
        // Set category names for all items
        for (ManageGallery item : items) {
            BlogCategory category = categoryDAO.findById(item.getCategoryId());
            if (category != null) {
                item.setCategoryName(category.getName());
            }
        }
        return items;
    }
    
    // Get gallery item by ID
    public ManageGallery getGalleryItemById(int id) {
        ManageGallery item = galleryDAO.findById(id);
        if (item != null) {
            // Set category name
            BlogCategory category = categoryDAO.findById(item.getCategoryId());
            if (category != null) {
                item.setCategoryName(category.getName());
            }
        }
        return item;
    }
    
    // Get items by category
    public List<ManageGallery> getItemsByCategory(int categoryId) {
        List<ManageGallery> items = galleryDAO.findByCategoryId(categoryId);
        // Set category names
        BlogCategory category = categoryDAO.findById(categoryId);
        String categoryName = category != null ? category.getName() : "Unknown";
        for (ManageGallery item : items) {
            item.setCategoryName(categoryName);
        }
        return items;
    }
    
    // Get visible items
    public List<ManageGallery> getVisibleItems() {
        List<ManageGallery> items = galleryDAO.findByStatus(true);
        // Set category names for visible items
        for (ManageGallery item : items) {
            BlogCategory category = categoryDAO.findById(item.getCategoryId());
            if (category != null) {
                item.setCategoryName(category.getName());
            }
        }
        return items;
    }
    
    // Get hidden items
    public List<ManageGallery> getHiddenItems() {
        List<ManageGallery> items = galleryDAO.findByStatus(false);
        // Set category names for hidden items
        for (ManageGallery item : items) {
            BlogCategory category = categoryDAO.findById(item.getCategoryId());
            if (category != null) {
                item.setCategoryName(category.getName());
            }
        }
        return items;
    }
    
    // Search items
    public List<ManageGallery> searchItems(String keyword) {
        List<ManageGallery> items = galleryDAO.search(keyword);
        // Set category names for search results
        for (ManageGallery item : items) {
            BlogCategory category = categoryDAO.findById(item.getCategoryId());
            if (category != null) {
                item.setCategoryName(category.getName());
            }
        }
        return items;
    }
    
    // Get items by month and year
    public List<ManageGallery> getItemsByMonthYear(int month, int year) {
        List<ManageGallery> items = galleryDAO.findByMonthYear(month, year);
        // Set category names
        for (ManageGallery item : items) {
            BlogCategory category = categoryDAO.findById(item.getCategoryId());
            if (category != null) {
                item.setCategoryName(category.getName());
            }
        }
        return items;
    }
    
    // Update status (visible/hidden)
    public boolean updateItemStatus(int id, boolean status) {
        ManageGallery item = galleryDAO.findById(id);
        if (item != null) {
            return galleryDAO.updateStatus(id, status);
        }
        return false;
    }
    
    // Toggle item status
    public boolean toggleItemStatus(int id) {
        ManageGallery item = galleryDAO.findById(id);
        if (item != null) {
            return galleryDAO.updateStatus(id, !item.isStatus());
        }
        return false;
    }
    
    // Delete gallery item
    public boolean deleteGalleryItem(int id) {
        return galleryDAO.delete(id);
    }
    
    // Get all blog categories (for dropdown menus, etc.)
    public List<BlogCategory> getAllCategories() {
        return categoryDAO.findAll();
    }
    
    // Get category by ID
    public BlogCategory getCategoryById(int id) {
        return categoryDAO.findById(id);
    }
    
    // Search categories by name
    public List<BlogCategory> searchCategories(String keyword) {
        return categoryDAO.searchByName(keyword);
    }
    
    // Get category statistics
    public List<CategoryStat> getCategoryStatistics() {
        List<BlogCategory> categories = categoryDAO.findAll();
        return categories.stream()
            .map(cat -> new CategoryStat(
                cat.getId(),
                cat.getName(),
                galleryDAO.countByCategory(cat.getId())
            ))
            .collect(Collectors.toList());
    }
    
    // Statistics methods
    public int getTotalCount() {
        return galleryDAO.countAll();
    }
    
    public int getVisibleCount() {
        return galleryDAO.countVisible();
    }
    
    public int getHiddenCount() {
        return galleryDAO.countHidden();
    }
    
    // Get count by category
    public int getCountByCategory(int categoryId) {
        return galleryDAO.countByCategory(categoryId);
    }
    
    // Check if category has any gallery items
    public boolean categoryHasItems(int categoryId) {
        return getCountByCategory(categoryId) > 0;
    }
    
    // Inner class for validation result
    public static class ValidationResult {
        private final boolean valid;
        private final String message;
        
        public ValidationResult(boolean valid, String message) {
            this.valid = valid;
            this.message = message;
        }
        
        public boolean isValid() { return valid; }
        public String getMessage() { return message; }
    }
    
    // Inner class for category statistics
    public static class CategoryStat {
        private final int id;
        private final String name;
        private final int count;
        
        public CategoryStat(int id, String name, int count) {
            this.id = id;
            this.name = name;
            this.count = count;
        }
        
        public int getId() { return id; }
        public String getName() { return name; }
        public int getCount() { return count; }
    }
}