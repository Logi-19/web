package wepapp.service;

import wepapp.dao.BlogCategoryDAO;
import wepapp.model.BlogCategory;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

// Strategy Pattern - Validation Strategy Interface
interface CategoryValidationStrategy {
    boolean validate(BlogCategory category);
    String getErrorMessage();
}

// Required Fields Validation Strategy
class CategoryRequiredFieldsStrategy implements CategoryValidationStrategy {
    @Override
    public boolean validate(BlogCategory category) {
        return category.getName() != null && !category.getName().trim().isEmpty();
    }
    
    @Override
    public String getErrorMessage() {
        return "Category name is required";
    }
}

// Name Length Validation Strategy
class CategoryNameLengthStrategy implements CategoryValidationStrategy {
    private static final int MIN_LENGTH = 2;
    private static final int MAX_LENGTH = 100;
    
    @Override
    public boolean validate(BlogCategory category) {
        String name = category.getName();
        return name != null && name.length() >= MIN_LENGTH && name.length() <= MAX_LENGTH;
    }
    
    @Override
    public String getErrorMessage() {
        return "Category name must be between " + MIN_LENGTH + " and " + MAX_LENGTH + " characters";
    }
}

// Name Format Validation Strategy
class CategoryNameFormatStrategy implements CategoryValidationStrategy {
    private static final String NAME_PATTERN = "^[a-zA-Z0-9\\s\\-&]+$";
    
    @Override
    public boolean validate(BlogCategory category) {
        String name = category.getName();
        return name != null && name.matches(NAME_PATTERN);
    }
    
    @Override
    public String getErrorMessage() {
        return "Category name can only contain letters, numbers, spaces, hyphens, and ampersands (&)";
    }
}

// Main Service Class
public class BlogCategoryService {
    private final BlogCategoryDAO categoryDAO;
    private final List<CategoryValidationStrategy> validators;
    
    public BlogCategoryService() {
        this.categoryDAO = BlogCategoryDAO.getInstance();
        this.validators = List.of(
            new CategoryRequiredFieldsStrategy(),
            new CategoryNameLengthStrategy(),
            new CategoryNameFormatStrategy()
        );
    }
    
    // Validate category using all strategies
    public ValidationResult validateCategory(BlogCategory category) {
        for (CategoryValidationStrategy validator : validators) {
            if (!validator.validate(category)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Check if category name exists
    public boolean categoryExists(String name) {
        return categoryDAO.exists(name);
    }
    
    // Check if category name exists excluding a specific ID
    public boolean categoryExistsExcludingId(String name, int id) {
        return categoryDAO.existsExcludingId(name, id);
    }
    
    // Create new category
    public ValidationResult createCategory(BlogCategory category) {
        // Validate first
        ValidationResult validationResult = validateCategory(category);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if category name already exists
        if (categoryExists(category.getName())) {
            return new ValidationResult(false, "Category name already exists");
        }
        
        // Set defaults if not set
        if (category.getCreatedDate() == null) {
            category.setCreatedDate(LocalDate.now());
        }
        if (category.getUpdatedDate() == null) {
            category.setUpdatedDate(LocalDateTime.now());
        }
        
        // Save to database
        boolean saved = categoryDAO.save(category);
        
        if (saved) {
            return new ValidationResult(true, "Category created successfully");
        } else {
            return new ValidationResult(false, "Failed to create category");
        }
    }
    
    // Update category
    public ValidationResult updateCategory(BlogCategory category) {
        // Validate the category before updating
        ValidationResult validationResult = validateCategory(category);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if category name already exists (excluding current category)
        if (categoryExistsExcludingId(category.getName(), category.getId())) {
            return new ValidationResult(false, "Category name already exists");
        }
        
        // Update in database
        boolean updated = categoryDAO.update(category);
        
        if (updated) {
            return new ValidationResult(true, "Category updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update category");
        }
    }
    
    // Get all categories
    public List<BlogCategory> getAllCategories() {
        return categoryDAO.findAll();
    }
    
    // Get category by ID
    public BlogCategory getCategoryById(int id) {
        return categoryDAO.findById(id);
    }
    
    // Get category by name
    public BlogCategory getCategoryByName(String name) {
        return categoryDAO.findByName(name);
    }
    
    // Search categories by name
    public List<BlogCategory> searchCategories(String keyword) {
        return categoryDAO.searchByName(keyword);
    }
    
    // Get categories by date range
    public List<BlogCategory> getCategoriesByDateRange(LocalDate startDate, LocalDate endDate) {
        return categoryDAO.findByDateRange(startDate, endDate);
    }
    
    // Get categories by month and year
    public List<BlogCategory> getCategoriesByMonthYear(int month, int year) {
        return categoryDAO.findByMonthYear(month, year);
    }
    
    // Get recent categories
    public List<BlogCategory> getRecentCategories(int limit) {
        return categoryDAO.findRecent(limit);
    }
    
    // Delete category
    public boolean deleteCategory(int id) {
        return categoryDAO.delete(id);
    }
    
    // Statistics methods
    public int getTotalCount() {
        return categoryDAO.countAll();
    }
    
    public int getCreatedThisMonthCount() {
        return categoryDAO.countCreatedThisMonth();
    }
    
    public int getCreatedLastMonthCount() {
        return categoryDAO.countCreatedLastMonth();
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
}