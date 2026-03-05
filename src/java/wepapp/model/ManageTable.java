package wepapp.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ManageTable {
    private int id;
    private String tablePrefix;
    private String tableNo;
    private String description;
    private int locationId; // Foreign key to TableLocation
    private String locationName; // For display purposes
    private int capacity;
    private List<String> images;
    private String status;
    private LocalDate createdDate;
    private LocalDateTime updatedDate;
    
    public ManageTable() {
        this.images = new ArrayList<>();
        this.status = "available";
        this.createdDate = LocalDate.now();
        this.updatedDate = LocalDateTime.now();
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getTablePrefix() { return tablePrefix; }
    public void setTablePrefix(String tablePrefix) { this.tablePrefix = tablePrefix; }
    
    public String getTableNo() { return tableNo; }
    public void setTableNo(String tableNo) { this.tableNo = tableNo; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public int getLocationId() { return locationId; }
    public void setLocationId(int locationId) { this.locationId = locationId; }
    
    public String getLocationName() { return locationName; }
    public void setLocationName(String locationName) { this.locationName = locationName; }
    
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    
    public List<String> getImages() { return images; }
    public void setImages(List<String> images) { this.images = images; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDate getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDate createdDate) { this.createdDate = createdDate; }
    
    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }
    
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
    
    public boolean isMaintenance() {
        return "maintenance".equals(this.status);
    }
}