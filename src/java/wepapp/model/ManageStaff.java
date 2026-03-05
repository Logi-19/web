package wepapp.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class ManageStaff {
    private int id;
    private String regNo;
    private String fullname;
    private String username;
    private String email;
    private String phone;
    private String gender;
    private String address;
    private String password;
    private int roleId; // Foreign key to Role table
    private String status; // active/inactive
    private LocalDate joinedDate;
    private LocalDateTime lastLogin;
    private LocalDateTime updatedDate;
    
    // Default constructor
    public ManageStaff() {}
    
    // Private constructor for Builder
    private ManageStaff(Builder builder) {
        this.id = builder.id;
        this.regNo = builder.regNo;
        this.fullname = builder.fullname;
        this.username = builder.username;
        this.email = builder.email;
        this.phone = builder.phone;
        this.gender = builder.gender;
        this.address = builder.address;
        this.password = builder.password;
        this.roleId = builder.roleId;
        this.status = builder.status;
        this.joinedDate = builder.joinedDate;
        this.lastLogin = builder.lastLogin;
        this.updatedDate = builder.updatedDate;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getRegNo() { return regNo; }
    public void setRegNo(String regNo) { this.regNo = regNo; }
    
    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDate getJoinedDate() { return joinedDate; }
    public void setJoinedDate(LocalDate joinedDate) { this.joinedDate = joinedDate; }
    
    public LocalDateTime getLastLogin() { return lastLogin; }
    public void setLastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; }
    
    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }
    
    // Builder Pattern
    public static class Builder {
        private int id;
        private String regNo;
        private String fullname;
        private String username;
        private String email;
        private String phone;
        private String gender;
        private String address;
        private String password;
        private int roleId = 2; // Default role ID is 2 (Staff)
        private String status = "active"; // Default status is active
        private LocalDate joinedDate = LocalDate.now();
        private LocalDateTime lastLogin;
        private LocalDateTime updatedDate = LocalDateTime.now();
        
        public Builder id(int id) { this.id = id; return this; }
        public Builder regNo(String regNo) { this.regNo = regNo; return this; }
        public Builder fullname(String fullname) { this.fullname = fullname; return this; }
        public Builder username(String username) { this.username = username; return this; }
        public Builder email(String email) { this.email = email; return this; }
        public Builder phone(String phone) { this.phone = phone; return this; }
        public Builder gender(String gender) { this.gender = gender; return this; }
        public Builder address(String address) { this.address = address; return this; }
        public Builder password(String password) { this.password = password; return this; }
        public Builder roleId(int roleId) { this.roleId = roleId; return this; }
        public Builder status(String status) { this.status = status; return this; }
        public Builder joinedDate(LocalDate joinedDate) { this.joinedDate = joinedDate; return this; }
        public Builder lastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; return this; }
        public Builder updatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; return this; }
        
        public ManageStaff build() {
            return new ManageStaff(this);
        }
    }
    
    // Generate registration number
    public static String generateRegNo(int id) {
        return String.format("STF-%05d", id);
    }
    
    @Override
    public String toString() {
        return "ManageStaff{" + "id=" + id + ", regNo=" + regNo + 
               ", fullname=" + fullname + ", username=" + username + 
               ", email=" + email + ", phone=" + phone + 
               ", gender=" + gender + ", roleId=" + roleId + 
               ", status=" + status + ", joinedDate=" + joinedDate + "}";
    }
}