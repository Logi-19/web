package wepapp.service;

import wepapp.dao.ManageBlogsDAO;
import wepapp.dao.BlogCategoryDAO;
import wepapp.model.ManageBlogs;
import wepapp.model.BlogCategory;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.regex.Pattern;

// Strategy Pattern - Validation Strategy Interface
interface BlogValidationStrategy {
    boolean validate(ManageBlogs blog);
    String getErrorMessage();
}

// Title Validation Strategy
class TitleValidationStrategy implements BlogValidationStrategy {
    private static final int MIN_TITLE_LENGTH = 5;
    private static final int MAX_TITLE_LENGTH = 200;
    
    @Override
    public boolean validate(ManageBlogs blog) {
        String title = blog.getTitle();
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
class DescriptionValidationStrategy implements BlogValidationStrategy {
    private static final int MIN_DESC_LENGTH = 20;
    private static final int MAX_DESC_LENGTH = 5000;
    
    @Override
    public boolean validate(ManageBlogs blog) {
        String desc = blog.getDescription();
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
class BlogCategoryValidationStrategy implements BlogValidationStrategy {
    private final BlogCategoryDAO categoryDAO;
    
    public BlogCategoryValidationStrategy() {
        this.categoryDAO = BlogCategoryDAO.getInstance();
    }
    
    @Override
    public boolean validate(ManageBlogs blog) {
        int categoryId = blog.getCategoryId();
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

// Blog Date Validation Strategy
class BlogDateValidationStrategy implements BlogValidationStrategy {
    @Override
    public boolean validate(ManageBlogs blog) {
        return blog.getBlogDate() != null;
    }
    
    @Override
    public String getErrorMessage() {
        return "Blog date is required";
    }
}

// Link Validation Strategy (optional)
class BlogLinkValidationStrategy implements BlogValidationStrategy {
    private static final Pattern URL_PATTERN = 
        Pattern.compile("^(https?://)?([\\da-z.-]+)\\.([a-z.]{2,6})[/\\w .-]*/?$", Pattern.CASE_INSENSITIVE);
    
    @Override
    public boolean validate(ManageBlogs blog) {
        String link = blog.getLink();
        // Link is optional - if provided, validate format
        if (link == null || link.trim().isEmpty()) {
            return true;
        }
        return URL_PATTERN.matcher(link).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Invalid URL format. Please enter a valid URL (e.g., https://example.com)";
    }
}

// Blog Prefix Validation Strategy
class BlogPrefixValidationStrategy implements BlogValidationStrategy {
    private static final Pattern PREFIX_PATTERN = Pattern.compile("^B-\\d{5}$");
    
    @Override
    public boolean validate(ManageBlogs blog) {
        String prefix = blog.getBlogPrefix();
        return prefix != null && !prefix.isEmpty() && PREFIX_PATTERN.matcher(prefix).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Invalid blog prefix format";
    }
}

// Main Service Class
public class ManageBlogsService {
    private final ManageBlogsDAO blogsDAO;
    private final BlogCategoryDAO categoryDAO;
    private final List<BlogValidationStrategy> validators;
    
    public ManageBlogsService() {
        this.blogsDAO = ManageBlogsDAO.getInstance();
        this.categoryDAO = BlogCategoryDAO.getInstance();
        this.validators = List.of(
            new BlogPrefixValidationStrategy(),
            new TitleValidationStrategy(),
            new DescriptionValidationStrategy(),
            new BlogCategoryValidationStrategy(),
            new BlogDateValidationStrategy(),
            new BlogLinkValidationStrategy()
        );
    }
    
    // Validate blog using all strategies
    public ValidationResult validateBlog(ManageBlogs blog) {
        for (BlogValidationStrategy validator : validators) {
            if (!validator.validate(blog)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Create new blog
    public ValidationResult createBlog(ManageBlogs blog) {
        // Validate first
        ValidationResult validationResult = validateBlog(blog);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Generate blog prefix if not set
        if (blog.getBlogPrefix() == null || blog.getBlogPrefix().isEmpty()) {
            blog.setBlogPrefix(blogsDAO.getNextBlogPrefix());
        }
        
        // Set timestamps
        blog.setPostedDate(LocalDateTime.now());
        blog.setUpdatedDate(LocalDateTime.now());
        
        // Save to database
        boolean saved = blogsDAO.save(blog);
        
        if (saved) {
            return new ValidationResult(true, "Blog created successfully!");
        } else {
            return new ValidationResult(false, "Failed to create blog. Please try again.");
        }
    }
    
    // Update blog
    public ValidationResult updateBlog(ManageBlogs blog) {
        // Validate the blog before updating
        ValidationResult validationResult = validateBlog(blog);
        if (!validationResult.isValid()) {
            return validationResult;
        }

        // Update in database
        boolean updated = blogsDAO.update(blog);
        
        if (updated) {
            return new ValidationResult(true, "Blog updated successfully!");
        } else {
            return new ValidationResult(false, "Failed to update blog. Please try again.");
        }
    }
    
    // Get all blogs
    public List<ManageBlogs> getAllBlogs() {
        return blogsDAO.findAll();
    }
    
    // Get blog by ID
    public ManageBlogs getBlogById(int id) {
        ManageBlogs blog = blogsDAO.findById(id);
        if (blog != null) {
            // Set category name
            BlogCategory category = categoryDAO.findById(blog.getCategoryId());
            if (category != null) {
                blog.setCategoryName(category.getName());
            }
        }
        return blog;
    }
    
    // Get blogs by category
    public List<ManageBlogs> getBlogsByCategory(int categoryId) {
        List<ManageBlogs> blogs = blogsDAO.findByCategoryId(categoryId);
        // Set category names
        BlogCategory category = categoryDAO.findById(categoryId);
        String categoryName = category != null ? category.getName() : "Unknown";
        for (ManageBlogs blog : blogs) {
            blog.setCategoryName(categoryName);
        }
        return blogs;
    }
    
    // Get visible blogs
    public List<ManageBlogs> getVisibleBlogs() {
        return blogsDAO.findByStatus(true);
    }
    
    // Get hidden blogs
    public List<ManageBlogs> getHiddenBlogs() {
        return blogsDAO.findByStatus(false);
    }
    
    // Search blogs
    public List<ManageBlogs> searchBlogs(String keyword) {
        return blogsDAO.search(keyword);
    }
    
    // Get blogs by date range
    public List<ManageBlogs> getBlogsByDateRange(LocalDate startDate, LocalDate endDate) {
        return blogsDAO.findByBlogDateRange(startDate, endDate);
    }
    
    // Get blogs by month and year
    public List<ManageBlogs> getBlogsByMonthYear(int month, int year) {
        return blogsDAO.findByMonthYear(month, year);
    }
    
    // Update status (visible/hidden)
    public boolean updateBlogStatus(int id, boolean status) {
        ManageBlogs blog = blogsDAO.findById(id);
        if (blog != null) {
            return blogsDAO.updateStatus(id, status);
        }
        return false;
    }
    
    // Toggle blog status
    public boolean toggleBlogStatus(int id) {
        ManageBlogs blog = blogsDAO.findById(id);
        if (blog != null) {
            return blogsDAO.updateStatus(id, !blog.isStatus());
        }
        return false;
    }
    
    // Delete blog
    public boolean deleteBlog(int id) {
        return blogsDAO.delete(id);
    }
    
    // Get category statistics
    public List<CategoryStat> getCategoryStatistics() {
        List<BlogCategory> categories = categoryDAO.findAll();
        return categories.stream()
            .map(cat -> new CategoryStat(
                cat.getId(),
                cat.getName(),
                blogsDAO.countByCategory(cat.getId())
            ))
            .toList();
    }
    
    // Statistics methods
    public int getTotalCount() {
        return blogsDAO.countAll();
    }
    
    public int getVisibleCount() {
        return blogsDAO.countVisible();
    }
    
    public int getHiddenCount() {
        return blogsDAO.countHidden();
    }
    
    // Generate next blog prefix
    public String getNextBlogPrefix() {
        return blogsDAO.getNextBlogPrefix();
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