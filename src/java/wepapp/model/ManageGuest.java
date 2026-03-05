package wepapp.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import org.mindrot.jbcrypt.BCrypt;

public class ManageGuest {
    private int id;
    private String regNo;
    private String fullName;
    private String username;
    private String email;
    private String phone;
    private String address;
    private String gender; // male, female, other, prefer-not
    private String password; // will store hashed password
    private String status; // active, inactive
    private LocalDateTime lastLogin;
    private LocalDate createdDate;
    private LocalDateTime updatedDate;
    
    // Default constructor
    public ManageGuest() {}
    
    // Private constructor for Builder
    private ManageGuest(Builder builder) {
        this.id = builder.id;
        this.regNo = builder.regNo;
        this.fullName = builder.fullName;
        this.username = builder.username;
        this.email = builder.email;
        this.phone = builder.phone;
        this.address = builder.address;
        this.gender = builder.gender;
        this.password = builder.password;
        this.status = builder.status;
        this.lastLogin = builder.lastLogin;
        this.createdDate = builder.createdDate;
        this.updatedDate = builder.updatedDate;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getRegNo() { return regNo; }
    public void setRegNo(String regNo) { this.regNo = regNo; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDateTime getLastLogin() { return lastLogin; }
    public void setLastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; }
    
    public LocalDate getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDate createdDate) { this.createdDate = createdDate; }
    
    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }
    
    // Password hashing methods
    public void hashAndSetPassword(String plainPassword) {
        this.password = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }
    
    public boolean checkPassword(String plainPassword) {
        return BCrypt.checkpw(plainPassword, this.password);
    }
    
    // Helper method to generate registration number
    public static String generateRegNo(int id) {
        return String.format("GST-%05d", id);
    }
    
    // Builder Pattern
    public static class Builder {
        private int id;
        private String regNo;
        private String fullName;
        private String username;
        private String email;
        private String phone;
        private String address;
        private String gender;
        private String password;
        private String status = "active"; // Default status
        private LocalDateTime lastLogin;
        private LocalDate createdDate = LocalDate.now();
        private LocalDateTime updatedDate = LocalDateTime.now();
        
        public Builder id(int id) { this.id = id; return this; }
        public Builder regNo(String regNo) { this.regNo = regNo; return this; }
        public Builder fullName(String fullName) { this.fullName = fullName; return this; }
        public Builder username(String username) { this.username = username; return this; }
        public Builder email(String email) { this.email = email; return this; }
        public Builder phone(String phone) { this.phone = phone; return this; }
        public Builder address(String address) { this.address = address; return this; }
        public Builder gender(String gender) { this.gender = gender; return this; }
        public Builder password(String password) { this.password = password; return this; }
        public Builder status(String status) { this.status = status; return this; }
        public Builder lastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; return this; }
        public Builder createdDate(LocalDate createdDate) { this.createdDate = createdDate; return this; }
        public Builder updatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; return this; }
        
        public ManageGuest build() {
            return new ManageGuest(this);
        }
    }
    
    @Override
    public String toString() {
        return "ManageGuest{" + "id=" + id + ", regNo=" + regNo + 
               ", fullName=" + fullName + ", username=" + username + 
               ", email=" + email + ", phone=" + phone + 
               ", address=" + address + ", gender=" + gender + 
               ", status=" + status + ", lastLogin=" + lastLogin + 
               ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + "}";
    }
}