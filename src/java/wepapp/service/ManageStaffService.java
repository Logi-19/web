package wepapp.service;

import wepapp.dao.ManageStaffDAO;
import wepapp.dao.RoleDAO;
import wepapp.model.ManageStaff;
import wepapp.model.Role;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.regex.Pattern;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

// Strategy Pattern - Validation Strategy Interfaces
interface StaffValidationStrategy {
    boolean validate(ManageStaff staff);
    String getErrorMessage();
}

// Required Fields Validation Strategy
class StaffRequiredFieldsStrategy implements StaffValidationStrategy {
    @Override
    public boolean validate(ManageStaff staff) {
        return staff.getFullname() != null && !staff.getFullname().trim().isEmpty() &&
               staff.getUsername() != null && !staff.getUsername().trim().isEmpty() &&
               staff.getEmail() != null && !staff.getEmail().trim().isEmpty() &&
               staff.getPhone() != null && !staff.getPhone().trim().isEmpty() &&
               staff.getGender() != null && !staff.getGender().trim().isEmpty() &&
               staff.getAddress() != null && !staff.getAddress().trim().isEmpty() &&
               staff.getPassword() != null && !staff.getPassword().trim().isEmpty() &&
               staff.getRoleId() > 0;
    }
    
    @Override
    public String getErrorMessage() {
        return "All required fields must be filled";
    }
}

// Full Name Validation Strategy
class StaffFullNameStrategy implements StaffValidationStrategy {
    private static final int MIN_LENGTH = 4;
    private static final int MAX_LENGTH = 100;
    private static final Pattern NAME_PATTERN = Pattern.compile("^[a-zA-Z\\s]+$");
    
    @Override
    public boolean validate(ManageStaff staff) {
        String name = staff.getFullname();
        if (name == null || name.trim().isEmpty()) return false;
        
        name = name.trim();
        return name.length() >= MIN_LENGTH && 
               name.length() <= MAX_LENGTH && 
               NAME_PATTERN.matcher(name).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Full name must be between " + MIN_LENGTH + " and " + MAX_LENGTH + 
               " characters and can only contain letters and spaces";
    }
}

// Username Validation Strategy
class StaffUsernameStrategy implements StaffValidationStrategy {
    private static final int MIN_LENGTH = 5;
    private static final int MAX_LENGTH = 50;
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_-]+$");
    
    @Override
    public boolean validate(ManageStaff staff) {
        String username = staff.getUsername();
        if (username == null || username.trim().isEmpty()) return false;
        
        username = username.trim();
        return username.length() >= MIN_LENGTH && 
               username.length() <= MAX_LENGTH && 
               USERNAME_PATTERN.matcher(username).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Username must be between " + MIN_LENGTH + " and " + MAX_LENGTH + 
               " characters and can only contain letters, numbers, _ and -";
    }
}

// Email Validation Strategy
class StaffEmailStrategy implements StaffValidationStrategy {
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    
    @Override
    public boolean validate(ManageStaff staff) {
        String email = staff.getEmail();
        if (email == null || email.trim().isEmpty()) return false;
        
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Please enter a valid email address";
    }
}

// Phone Validation Strategy
class StaffPhoneStrategy implements StaffValidationStrategy {
    private static final Pattern PHONE_PATTERN = 
        Pattern.compile("^[\\d\\s\\+\\-\\(\\)]{10,}$");
    
    @Override
    public boolean validate(ManageStaff staff) {
        String phone = staff.getPhone();
        if (phone == null || phone.trim().isEmpty()) return false;
        
        return PHONE_PATTERN.matcher(phone.trim()).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Please enter a valid phone number (minimum 10 digits)";
    }
}

// Gender Validation Strategy
class StaffGenderStrategy implements StaffValidationStrategy {
    @Override
    public boolean validate(ManageStaff staff) {
        String gender = staff.getGender();
        return gender != null && (gender.equalsIgnoreCase("male") || 
                                  gender.equalsIgnoreCase("female"));
    }
    
    @Override
    public String getErrorMessage() {
        return "Gender must be either Male or Female";
    }
}

// Password Validation Strategy
class StaffPasswordStrategy implements StaffValidationStrategy {
    private static final int MIN_LENGTH = 8;
    private static final Pattern PASSWORD_PATTERN = 
        Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).+$");
    
    @Override
    public boolean validate(ManageStaff staff) {
        String password = staff.getPassword();
        if (password == null || password.trim().isEmpty()) return false;
        
        return password.length() >= MIN_LENGTH && 
               PASSWORD_PATTERN.matcher(password).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Password must be at least " + MIN_LENGTH + 
               " characters with at least one uppercase letter, one lowercase letter, one number, and one symbol";
    }
}

// Address Validation Strategy
class StaffAddressStrategy implements StaffValidationStrategy {
    private static final int MIN_LENGTH = 5;
    private static final int MAX_LENGTH = 255;
    
    @Override
    public boolean validate(ManageStaff staff) {
        String address = staff.getAddress();
        if (address == null || address.trim().isEmpty()) return false;
        
        address = address.trim();
        return address.length() >= MIN_LENGTH && address.length() <= MAX_LENGTH;
    }
    
    @Override
    public String getErrorMessage() {
        return "Address must be between " + MIN_LENGTH + " and " + MAX_LENGTH + " characters";
    }
}

// Role Validation Strategy
class StaffRoleStrategy implements StaffValidationStrategy {
    private RoleDAO roleDAO;
    
    public StaffRoleStrategy() {
        this.roleDAO = RoleDAO.getInstance();
    }
    
    @Override
    public boolean validate(ManageStaff staff) {
        int roleId = staff.getRoleId();
        if (roleId <= 0) return false;
        
        Role role = roleDAO.findById(roleId);
        return role != null;
    }
    
    @Override
    public String getErrorMessage() {
        return "Selected role is invalid";
    }
}

// Inner class for login session
class LoginSession {
    int staffId;
    String staffName;
    String regNo;
    String role;
    LocalDateTime loginTime;
    
    public LoginSession(int staffId, String staffName, String regNo, String role) {
        this.staffId = staffId;
        this.staffName = staffName;
        this.regNo = regNo;
        this.role = role;
        this.loginTime = LocalDateTime.now();
    }
}

// Main Service Class
public class ManageStaffService {
    private final ManageStaffDAO staffDAO;
    private final RoleDAO roleDAO;
    private final List<StaffValidationStrategy> validators;
    
    // Password hashing constants
    private static final int SALT_LENGTH = 16;
    private static final String HASH_ALGORITHM = "SHA-256";
    
    public ManageStaffService() {
        this.staffDAO = ManageStaffDAO.getInstance();
        this.roleDAO = RoleDAO.getInstance();
        this.validators = List.of(
            new StaffRequiredFieldsStrategy(),
            new StaffFullNameStrategy(),
            new StaffUsernameStrategy(),
            new StaffEmailStrategy(),
            new StaffPhoneStrategy(),
            new StaffGenderStrategy(),
            new StaffPasswordStrategy(),
            new StaffAddressStrategy(),
            new StaffRoleStrategy()
        );
    }
    
    // Password hashing methods
    private String hashPassword(String password) {
        try {
            // Generate salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            // Hash password with salt
            MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());
            
            // Combine salt and hashed password
            byte[] combined = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);
            
            // Encode to Base64 for storage
            return Base64.getEncoder().encodeToString(combined);
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    private boolean verifyPassword(String password, String storedHash) {
        try {
            // Decode from Base64
            byte[] combined = Base64.getDecoder().decode(storedHash);
            
            // Extract salt (first SALT_LENGTH bytes)
            byte[] salt = new byte[SALT_LENGTH];
            System.arraycopy(combined, 0, salt, 0, SALT_LENGTH);
            
            // Extract stored hash
            byte[] storedHashBytes = new byte[combined.length - SALT_LENGTH];
            System.arraycopy(combined, SALT_LENGTH, storedHashBytes, 0, storedHashBytes.length);
            
            // Hash input password with same salt
            MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());
            
            // Compare byte arrays
            return MessageDigest.isEqual(storedHashBytes, hashedPassword);
            
        } catch (Exception e) {
            return false;
        }
    }
    
    // Validate staff using all strategies
    public ValidationResult validateStaff(ManageStaff staff) {
        for (StaffValidationStrategy validator : validators) {
            if (!validator.validate(staff)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Authenticate staff member
    public ManageStaff authenticate(String username, String password) {
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            return null;
        }
        
        // Get staff by username
        ManageStaff staff = staffDAO.findByUsername(username);
        if (staff == null) {
            return null;
        }
        
        // Check if account is active
        if (!"active".equals(staff.getStatus())) {
            return null;
        }
        
        // Verify password
        String storedHash = staffDAO.getPasswordHash(staff.getId());
        if (storedHash != null && verifyPassword(password, storedHash)) {
            // Don't return the password
            staff.setPassword(null);
            return staff;
        }
        
        return null;
    }
    
    // Check if username exists
    public boolean usernameExists(String username) {
        return staffDAO.usernameExists(username);
    }
    
    // Check if username exists excluding a specific ID
    public boolean usernameExistsExcludingId(String username, int id) {
        return staffDAO.usernameExistsExcludingId(username, id);
    }
    
    // Check if email exists
    public boolean emailExists(String email) {
        return staffDAO.emailExists(email);
    }
    
    // Check if email exists excluding a specific ID
    public boolean emailExistsExcludingId(String email, int id) {
        return staffDAO.emailExistsExcludingId(email, id);
    }
    
    // Check if phone exists
    public boolean phoneExists(String phone) {
        return staffDAO.phoneExists(phone);
    }
    
    // Check if phone exists excluding a specific ID
    public boolean phoneExistsExcludingId(String phone, int id) {
        return staffDAO.phoneExistsExcludingId(phone, id);
    }
    
    // Create new staff member
    public ValidationResult createStaff(ManageStaff staff) {
        // Validate first
        ValidationResult validationResult = validateStaff(staff);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if username already exists
        if (usernameExists(staff.getUsername())) {
            return new ValidationResult(false, "Username already exists");
        }
        
        // Check if email already exists
        if (emailExists(staff.getEmail())) {
            return new ValidationResult(false, "Email already exists");
        }
        
        // Check if phone already exists
        if (phoneExists(staff.getPhone())) {
            return new ValidationResult(false, "Phone number already exists");
        }
        
        // Hash the password
        String hashedPassword = hashPassword(staff.getPassword());
        
        // Set defaults if not set
        if (staff.getJoinedDate() == null) {
            staff.setJoinedDate(LocalDate.now());
        }
        if (staff.getUpdatedDate() == null) {
            staff.setUpdatedDate(LocalDateTime.now());
        }
        if (staff.getStatus() == null) {
            staff.setStatus("active");
        }
        
        // Generate temporary regNo (will be updated after ID is generated)
        staff.setRegNo("TEMP");
        
        // Set the hashed password
        staff.setPassword(hashedPassword);
        
        // Save to database
        boolean saved = staffDAO.save(staff);
        
        if (saved) {
            // Clear password from object before returning
            staff.setPassword(null);
            return new ValidationResult(true, "Staff member created successfully. Registration No: " + staff.getRegNo());
        } else {
            return new ValidationResult(false, "Failed to create staff member");
        }
    }
    
    // Update staff details (excluding password, status, role)
    public ValidationResult updateStaff(ManageStaff staff) {
        // Get existing staff to preserve fields we're not updating
        ManageStaff existingStaff = getStaffById(staff.getId());
        if (existingStaff == null) {
            return new ValidationResult(false, "Staff member not found");
        }
        
        // Validate the staff (skip password validation for update)
        List<StaffValidationStrategy> updateValidators = List.of(
            new StaffRequiredFieldsStrategy(),
            new StaffFullNameStrategy(),
            new StaffUsernameStrategy(),
            new StaffEmailStrategy(),
            new StaffPhoneStrategy(),
            new StaffGenderStrategy(),
            new StaffAddressStrategy()
        );
        
        for (StaffValidationStrategy validator : updateValidators) {
            if (!validator.validate(staff)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        
        // Check if username already exists (excluding current staff)
        if (usernameExistsExcludingId(staff.getUsername(), staff.getId())) {
            return new ValidationResult(false, "Username already exists");
        }
        
        // Check if email already exists (excluding current staff)
        if (emailExistsExcludingId(staff.getEmail(), staff.getId())) {
            return new ValidationResult(false, "Email already exists");
        }
        
        // Check if phone already exists (excluding current staff)
        if (phoneExistsExcludingId(staff.getPhone(), staff.getId())) {
            return new ValidationResult(false, "Phone number already exists");
        }
        
        // Preserve fields that shouldn't be updated through this method
        staff.setRegNo(existingStaff.getRegNo());
        staff.setPassword(existingStaff.getPassword()); // Keep existing password
        staff.setRoleId(existingStaff.getRoleId());
        staff.setStatus(existingStaff.getStatus());
        staff.setJoinedDate(existingStaff.getJoinedDate());
        staff.setLastLogin(existingStaff.getLastLogin());
        
        // Update in database
        boolean updated = staffDAO.update(staff);
        
        if (updated) {
            return new ValidationResult(true, "Staff details updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update staff details");
        }
    }
    
    // Update staff password
    public ValidationResult updatePassword(int id, String newPassword) {
        // Validate password
        ManageStaff tempStaff = new ManageStaff();
        tempStaff.setPassword(newPassword);
        
        StaffPasswordStrategy passwordValidator = new StaffPasswordStrategy();
        if (!passwordValidator.validate(tempStaff)) {
            return new ValidationResult(false, passwordValidator.getErrorMessage());
        }
        
        // Hash the new password
        String hashedPassword = hashPassword(newPassword);
        
        // Update in database
        boolean updated = staffDAO.updatePassword(id, hashedPassword);
        
        if (updated) {
            return new ValidationResult(true, "Password updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update password");
        }
    }
    
    // Update staff status
    public ValidationResult updateStatus(int id, String status) {
        if (status == null || (!status.equals("active") && !status.equals("inactive"))) {
            return new ValidationResult(false, "Status must be either 'active' or 'inactive'");
        }
        
        boolean updated = staffDAO.updateStatus(id, status);
        
        if (updated) {
            return new ValidationResult(true, "Staff status updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update staff status");
        }
    }
    
    // Update staff role
    public ValidationResult updateRole(int id, int roleId) {
        // Check if role exists
        Role role = roleDAO.findById(roleId);
        if (role == null) {
            return new ValidationResult(false, "Selected role does not exist");
        }
        
        boolean updated = staffDAO.updateRole(id, roleId);
        
        if (updated) {
            return new ValidationResult(true, "Staff role updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update staff role");
        }
    }
    
    // Update last login
    public boolean updateLastLogin(int id) {
        return staffDAO.updateLastLogin(id);
    }
    
    // Get all staff members
    public List<ManageStaff> getAllStaff() {
        List<ManageStaff> staffList = staffDAO.findAll();
        // Clear sensitive data
        for (ManageStaff staff : staffList) {
            staff.setPassword(null);
        }
        return staffList;
    }
    
    // Get staff by ID
    public ManageStaff getStaffById(int id) {
        ManageStaff staff = staffDAO.findById(id);
        if (staff != null) {
            staff.setPassword(null);
        }
        return staff;
    }
    
    // Get staff by registration number
    public ManageStaff getStaffByRegNo(String regNo) {
        ManageStaff staff = staffDAO.findByRegNo(regNo);
        if (staff != null) {
            staff.setPassword(null);
        }
        return staff;
    }
    
    // Get staff by username
    public ManageStaff getStaffByUsername(String username) {
        ManageStaff staff = staffDAO.findByUsername(username);
        if (staff != null) {
            staff.setPassword(null);
        }
        return staff;
    }
    
    // Get staff by email
    public ManageStaff getStaffByEmail(String email) {
        ManageStaff staff = staffDAO.findByEmail(email);
        if (staff != null) {
            staff.setPassword(null);
        }
        return staff;
    }
    
    // Get staff by role ID
    public List<ManageStaff> getStaffByRoleId(int roleId) {
        List<ManageStaff> staffList = staffDAO.findByRoleId(roleId);
        for (ManageStaff staff : staffList) {
            staff.setPassword(null);
        }
        return staffList;
    }
    
    // Get staff by status
    public List<ManageStaff> getStaffByStatus(String status) {
        List<ManageStaff> staffList = staffDAO.findByStatus(status);
        for (ManageStaff staff : staffList) {
            staff.setPassword(null);
        }
        return staffList;
    }
    
    // Search staff by keyword
    public List<ManageStaff> searchStaff(String keyword) {
        List<ManageStaff> staffList = staffDAO.search(keyword);
        for (ManageStaff staff : staffList) {
            staff.setPassword(null);
        }
        return staffList;
    }
    
    // Get staff by date range
    public List<ManageStaff> getStaffByDateRange(LocalDate startDate, LocalDate endDate) {
        List<ManageStaff> staffList = staffDAO.findByDateRange(startDate, endDate);
        for (ManageStaff staff : staffList) {
            staff.setPassword(null);
        }
        return staffList;
    }
    
    // Get staff by month and year
    public List<ManageStaff> getStaffByMonthYear(int month, int year) {
        List<ManageStaff> staffList = staffDAO.findByMonthYear(month, year);
        for (ManageStaff staff : staffList) {
            staff.setPassword(null);
        }
        return staffList;
    }
    
    // Get recent staff
    public List<ManageStaff> getRecentStaff(int limit) {
        List<ManageStaff> staffList = staffDAO.findRecent(limit);
        for (ManageStaff staff : staffList) {
            staff.setPassword(null);
        }
        return staffList;
    }
    
    // Delete staff
    public boolean deleteStaff(int id) {
        return staffDAO.delete(id);
    }
    
    // Statistics methods
    public int getTotalCount() {
        return staffDAO.countAll();
    }
    
    public int getActiveCount() {
        return staffDAO.countByStatus("active");
    }
    
    public int getInactiveCount() {
        return staffDAO.countByStatus("inactive");
    }
    
    public int getCountByRoleId(int roleId) {
        return staffDAO.countByRoleId(roleId);
    }
    
    public int getJoinedThisMonthCount() {
        return staffDAO.countJoinedThisMonth();
    }
    
    // Get role details for a staff member
    public Role getStaffRole(int staffId) {
        ManageStaff staff = getStaffById(staffId);
        if (staff != null) {
            return roleDAO.findById(staff.getRoleId());
        }
        return null;
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