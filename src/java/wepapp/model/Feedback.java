package wepapp.model;

import java.time.LocalDate;

public class Feedback {
    private int id;
    private String name;
    private String email;
    private int rating; // 1-5 stars
    private String message;
    private boolean status; // true = visible/show, false = hidden
    private LocalDate submittedDate;
    
    // Default constructor
    public Feedback() {}
    
    // Private constructor for Builder
    private Feedback(Builder builder) {
        this.id = builder.id;
        this.name = builder.name;
        this.email = builder.email;
        this.rating = builder.rating;
        this.message = builder.message;
        this.status = builder.status;
        this.submittedDate = builder.submittedDate;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public int getRating() { return rating; }
    public void setRating(int rating) { 
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        this.rating = rating; 
    }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
    
    // Helper method to get status as string for display
    public String getStatusDisplay() {
        return status ? "visible" : "hidden";
    }
    
    // Helper method to set status from string
    public void setStatusFromString(String statusStr) {
        if (statusStr == null) {
            this.status = true; // default to visible
        } else {
            this.status = statusStr.equalsIgnoreCase("show") || 
                         statusStr.equalsIgnoreCase("visible") || 
                         statusStr.equalsIgnoreCase("true");
        }
    }
    
    public LocalDate getSubmittedDate() { return submittedDate; }
    public void setSubmittedDate(LocalDate submittedDate) { this.submittedDate = submittedDate; }
    
    // Helper method to get initials
    public String getInitials() {
        if (name == null || name.trim().isEmpty()) {
            return "??";
        }
        String[] parts = name.trim().split("\\s+");
        if (parts.length >= 2) {
            return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
        } else {
            return name.substring(0, Math.min(2, name.length())).toUpperCase();
        }
    }
    
    // Builder Pattern
    public static class Builder {
        private int id;
        private String name;
        private String email;
        private int rating = 5;
        private String message;
        private boolean status = true; // Default to visible
        private LocalDate submittedDate = LocalDate.now();
        
        public Builder id(int id) { this.id = id; return this; }
        public Builder name(String name) { this.name = name; return this; }
        public Builder email(String email) { this.email = email; return this; }
        public Builder rating(int rating) { 
            if (rating < 1 || rating > 5) {
                throw new IllegalArgumentException("Rating must be between 1 and 5");
            }
            this.rating = rating; 
            return this; 
        }
        public Builder message(String message) { this.message = message; return this; }
        public Builder status(boolean status) { this.status = status; return this; }
        public Builder statusFromString(String statusStr) { 
            this.status = statusStr == null || 
                         statusStr.equalsIgnoreCase("show") || 
                         statusStr.equalsIgnoreCase("visible") || 
                         statusStr.equalsIgnoreCase("true");
            return this; 
        }
        public Builder submittedDate(LocalDate submittedDate) { this.submittedDate = submittedDate; return this; }
        
        public Feedback build() {
            return new Feedback(this);
        }
    }
    
    @Override
    public String toString() {
        return "Feedback{" + "id=" + id + ", name=" + name + ", rating=" + rating + 
               ", status=" + (status ? "visible" : "hidden") + ", date=" + submittedDate + "}";
    }
}