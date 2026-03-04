package wepapp.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ManageRoom {
    private int id;
    private String roomPrefix;
    private String roomNo;
    private String description;
    private int typeId;
    private String typeName;
    private List<Integer> facilityIds;
    private List<String> facilityNames;
    private int capacity;
    private double price;
    private List<String> images;
    private String status;
    private LocalDate createdDate;
    private LocalDateTime updatedDate;
    
    public ManageRoom() {
        this.images = new ArrayList<>();
        this.facilityIds = new ArrayList<>();
        this.facilityNames = new ArrayList<>();
        this.status = "available";
        this.createdDate = LocalDate.now();
        this.updatedDate = LocalDateTime.now();
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getRoomPrefix() { return roomPrefix; }
    public void setRoomPrefix(String roomPrefix) { this.roomPrefix = roomPrefix; }
    
    public String getRoomNo() { return roomNo; }
    public void setRoomNo(String roomNo) { this.roomNo = roomNo; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public int getTypeId() { return typeId; }
    public void setTypeId(int typeId) { this.typeId = typeId; }
    
    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }
    
    public List<Integer> getFacilityIds() { return facilityIds; }
    public void setFacilityIds(List<Integer> facilityIds) { this.facilityIds = facilityIds; }
    
    public List<String> getFacilityNames() { return facilityNames; }
    public void setFacilityNames(List<String> facilityNames) { this.facilityNames = facilityNames; }
    
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
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
    
    public void addFacilityId(int facilityId) {
        if (this.facilityIds == null) {
            this.facilityIds = new ArrayList<>();
        }
        if (!this.facilityIds.contains(facilityId)) {
            this.facilityIds.add(facilityId);
        }
    }
    
    public boolean isAvailable() {
        return "available".equals(this.status);
    }
    
    public boolean isMaintenance() {
        return "maintenance".equals(this.status);
    }
}