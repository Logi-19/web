package wepapp.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class TableLocation {
    private int id;
    private String name;
    private LocalDate createdDate;
    private LocalDateTime updatedDate;
    
    // Default constructor
    public TableLocation() {}
    
    // Private constructor for Builder
    private TableLocation(Builder builder) {
        this.id = builder.id;
        this.name = builder.name;
        this.createdDate = builder.createdDate;
        this.updatedDate = builder.updatedDate;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public LocalDate getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDate createdDate) { this.createdDate = createdDate; }
    
    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }
    
    // Builder Pattern
    public static class Builder {
        private int id;
        private String name;
        private LocalDate createdDate = LocalDate.now();
        private LocalDateTime updatedDate = LocalDateTime.now();
        
        public Builder id(int id) { this.id = id; return this; }
        public Builder name(String name) { this.name = name; return this; }
        public Builder createdDate(LocalDate createdDate) { this.createdDate = createdDate; return this; }
        public Builder updatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; return this; }
        
        public TableLocation build() {
            return new TableLocation(this);
        }
    }
    
    @Override
    public String toString() {
        return "TableLocation{" + "id=" + id + ", name=" + name + 
               ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + "}";
    }
}