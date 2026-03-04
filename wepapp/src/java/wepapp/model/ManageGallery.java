package wepapp.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ManageGallery {
    private int id;
    private String title;
    private String description;
    private int categoryId; // Foreign key to GalleryCategory
    private String categoryName; // For display purposes (not stored in DB)
    private List<String> images;
    private boolean status; // true = visible, false = hidden
    private LocalDateTime postedDate;
    private LocalDateTime updatedDate;
    
    // Default constructor
    public ManageGallery() {
        this.images = new ArrayList<>();
        this.status = true; // Default to visible
        this.postedDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }
    
    // Private constructor for Builder
    private ManageGallery(Builder builder) {
        this.id = builder.id;
        this.title = builder.title;
        this.description = builder.description;
        this.categoryId = builder.categoryId;
        this.categoryName = builder.categoryName;
        this.images = builder.images != null ? builder.images : new ArrayList<>();
        this.status = builder.status;
        this.postedDate = builder.postedDate;
        this.updatedDate = builder.updatedDate;
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
    
    public List<String> getImages() { return images; }
    public void setImages(List<String> images) { this.images = images; }
    
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
    
    public LocalDateTime getPostedDate() { return postedDate; }
    public void setPostedDate(LocalDateTime postedDate) { this.postedDate = postedDate; }
    
    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }
    
    // Helper methods
    public void addImage(String imageUrl) {
        if (this.images == null) {
            this.images = new ArrayList<>();
        }
        this.images.add(imageUrl);
    }
    
    public void removeImage(String imageUrl) {
        if (this.images != null) {
            this.images.remove(imageUrl);
        }
    }
    
    public void removeImageAt(int index) {
        if (this.images != null && index >= 0 && index < this.images.size()) {
            this.images.remove(index);
        }
    }
    
    public int getImageCount() {
        return this.images != null ? this.images.size() : 0;
    }
    
    public boolean hasImages() {
        return this.images != null && !this.images.isEmpty();
    }
    
    public String getFirstImage() {
        return hasImages() ? this.images.get(0) : null;
    }
    
    // Builder Pattern
    public static class Builder {
        private int id;
        private String title;
        private String description;
        private int categoryId;
        private String categoryName;
        private List<String> images;
        private boolean status = true;
        private LocalDateTime postedDate = LocalDateTime.now();
        private LocalDateTime updatedDate = LocalDateTime.now();
        
        public Builder id(int id) { this.id = id; return this; }
        public Builder title(String title) { this.title = title; return this; }
        public Builder description(String description) { this.description = description; return this; }
        public Builder categoryId(int categoryId) { this.categoryId = categoryId; return this; }
        public Builder categoryName(String categoryName) { this.categoryName = categoryName; return this; }
        public Builder images(List<String> images) { this.images = images; return this; }
        public Builder status(boolean status) { this.status = status; return this; }
        public Builder postedDate(LocalDateTime postedDate) { this.postedDate = postedDate; return this; }
        public Builder updatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; return this; }
        
        public ManageGallery build() {
            return new ManageGallery(this);
        }
    }
    
    @Override
    public String toString() {
        return "ManageGallery{" + "id=" + id + ", title=" + title + 
               ", categoryId=" + categoryId + ", status=" + (status ? "visible" : "hidden") + "}";
    }
}