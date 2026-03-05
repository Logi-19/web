package wepapp.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ManageService {
    private int id;
    private String title;
    private String description;
    private int categoryId;        // Foreign key to service_category
    private String categoryName;    // For display purposes
    private int duration;           // Duration in minutes (0 for unlimited)
    private double fees;            // Price in LKR (0 for free)
    private List<String> images;    // Multiple service images
    private String status;          // available, unavailable
    private LocalDate createdDate;
    private LocalDateTime updatedDate;
    
    public ManageService() {
        this.images = new ArrayList<>();
        this.status = "available";
        this.createdDate = LocalDate.now();
        this.updatedDate = LocalDateTime.now();
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
    
    public double getFees() { return fees; }
    public void setFees(double fees) { this.fees = fees; }
    
    public List<String> getImages() { return images; }
    public void setImages(List<String> images) { this.images = images; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDate getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDate createdDate) { this.createdDate = createdDate; }
    
    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }
    
    // Helper methods
    public void addImage(String imageUrl) {
        if (this.images == null) {
            this.images = new ArrayList<>();
        }
        this.images.add(imageUrl);
    }
    
    public boolean hasImages() {
        return this.images != null && !this.images.isEmpty();
    }
    
    public boolean isAvailable() {
        return "available".equals(this.status);
    }
    
    public boolean isUnavailable() {
        return "unavailable".equals(this.status);
    }
    
    public boolean isFree() {
        return this.fees == 0;
    }
    
    public boolean isUnlimitedDuration() {
        return this.duration == 0;
    }
    
    public String getFormattedDuration() {
        if (duration == 0) {
            return "Unlimited";
        }
        return duration + " min";
    }
    
    public String getFormattedFees() {
        if (fees == 0) {
            return "Free";
        }
        return String.format("LKR %,.0f", fees);
    }
}