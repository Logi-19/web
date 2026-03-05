package wepapp.service;

import wepapp.dao.ManageGuestDAO;
import wepapp.model.ManageGuest;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.regex.Pattern;

// Strategy Pattern - Validation Strategy Interface
interface GuestValidationStrategy {
    boolean validate(ManageGuest guest);
    String getErrorMessage();
}

// Required Fields Validation Strategy
class GuestRequiredFieldsStrategy implements GuestValidationStrategy {
    @Override
    public boolean validate(ManageGuest guest) {
        return guest.getFullName() != null && !guest.getFullName().trim().isEmpty() &&
               guest.getUsername() != null && !guest.getUsername().trim().isEmpty() &&
               guest.getEmail() != null && !guest.getEmail().trim().isEmpty() &&
               guest.getPhone() != null && !guest.getPhone().trim().isEmpty() &&
               guest.getAddress() != null && !guest.getAddress().trim().isEmpty() &&
               guest.getGender() != null && !guest.getGender().trim().isEmpty() &&
               guest.getPassword() != null && !guest.getPassword().trim().isEmpty();
    }
    
    @Override
    public String getErrorMessage() {
        return "All required fields must be filled";
    }
}

// Full Name Validation Strategy
class GuestFullNameStrategy implements GuestValidationStrategy {
    private static final int MIN_LENGTH = 4;
    private static final int MAX_LENGTH = 100;
    private static final Pattern NAME_PATTERN = Pattern.compile("^[a-zA-Z\\s]+$");
    
    @Override
    public boolean validate(ManageGuest guest) {
        String fullName = guest.getFullName();
        if (fullName == null || fullName.trim().isEmpty()) {
            return false;
        }
        return fullName.length() >= MIN_LENGTH && 
               fullName.length() <= MAX_LENGTH && 
               NAME_PATTERN.matcher(fullName).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Full name must be between " + MIN_LENGTH + " and " + MAX_LENGTH + 
               " characters and can only contain letters and spaces";
    }
}

// Username Validation Strategy
class GuestUsernameStrategy implements GuestValidationStrategy {
    private static final int MIN_LENGTH = 5;
    private static final int MAX_LENGTH = 50;
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_-]+$");
    
    @Override
    public boolean validate(ManageGuest guest) {
        String username = guest.getUsername();
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
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
class GuestEmailStrategy implements GuestValidationStrategy {
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    
    @Override
    public boolean validate(ManageGuest guest) {
        String email = guest.getEmail();
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Please enter a valid email address";
    }
}

// Phone Validation Strategy
class GuestPhoneStrategy implements GuestValidationStrategy {
    private static final Pattern PHONE_PATTERN = 
        Pattern.compile("^[\\d\\s\\+\\-\\(\\)]{10,}$");
    
    @Override
    public boolean validate(ManageGuest guest) {
        String phone = guest.getPhone();
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        return PHONE_PATTERN.matcher(phone).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Please enter a valid phone number (minimum 10 digits)";
    }
}

// Address Validation Strategy
class GuestAddressStrategy implements GuestValidationStrategy {
    private static final int MIN_LENGTH = 5;
    private static final int MAX_LENGTH = 200;
    
    @Override
    public boolean validate(ManageGuest guest) {
        String address = guest.getAddress();
        if (address == null || address.trim().isEmpty()) {
            return false;
        }
        return address.length() >= MIN_LENGTH && address.length() <= MAX_LENGTH;
    }
    
    @Override
    public String getErrorMessage() {
        return "Address must be between " + MIN_LENGTH + " and " + MAX_LENGTH + " characters";
    }
}

// Gender Validation Strategy
class GuestGenderStrategy implements GuestValidationStrategy {
    private static final List<String> VALID_GENDERS = 
        List.of("male", "female", "other", "prefer-not");
    
    @Override
    public boolean validate(ManageGuest guest) {
        String gender = guest.getGender();
        if (gender == null || gender.trim().isEmpty()) {
            return false;
        }
        return VALID_GENDERS.contains(gender.toLowerCase());
    }
    
    @Override
    public String getErrorMessage() {
        return "Please select a valid gender option";
    }
}

// Password Validation Strategy
class GuestPasswordStrategy implements GuestValidationStrategy {
    private static final int MIN_LENGTH = 8;
    private static final Pattern PASSWORD_PATTERN = 
        Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).+$");
    
    @Override
    public boolean validate(ManageGuest guest) {
        String password = guest.getPassword();
        if (password == null || password.trim().isEmpty()) {
            return false;
        }
        return password.length() >= MIN_LENGTH && PASSWORD_PATTERN.matcher(password).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Password must be at least " + MIN_LENGTH + 
               " characters with at least one uppercase letter, one lowercase letter, one number, and one symbol";
    }
}

// Status Validation Strategy
class GuestStatusStrategy implements GuestValidationStrategy {
    private static final List<String> VALID_STATUSES = List.of("active", "inactive");
    
    @Override
    public boolean validate(ManageGuest guest) {
        String status = guest.getStatus();
        if (status == null || status.trim().isEmpty()) {
            return false;
        }
        return VALID_STATUSES.contains(status.toLowerCase());
    }
    
    @Override
    public String getErrorMessage() {
        return "Status must be either 'active' or 'inactive'";
    }
}

// Main Service Class
public class ManageGuestService {
    private final ManageGuestDAO guestDAO;
    private final List<GuestValidationStrategy> createValidators;
    private final List<GuestValidationStrategy> updateValidators;
    
    public ManageGuestService() {
        this.guestDAO = ManageGuestDAO.getInstance();
        
        // Validators for creating a new guest (all fields required)
        this.createValidators = List.of(
            new GuestRequiredFieldsStrategy(),
            new GuestFullNameStrategy(),
            new GuestUsernameStrategy(),
            new GuestEmailStrategy(),
            new GuestPhoneStrategy(),
            new GuestAddressStrategy(),
            new GuestGenderStrategy(),
            new GuestPasswordStrategy(),
            new GuestStatusStrategy()
        );
        
        // Validators for updating a guest (password optional, other fields required)
        this.updateValidators = List.of(
            new GuestFullNameStrategy(),
            new GuestUsernameStrategy(),
            new GuestEmailStrategy(),
            new GuestPhoneStrategy(),
            new GuestAddressStrategy(),
            new GuestGenderStrategy()
        );
    }
    
    // Validate guest for creation using all strategies
    public ValidationResult validateForCreate(ManageGuest guest) {
        for (GuestValidationStrategy validator : createValidators) {
            if (!validator.validate(guest)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Validate guest for update using update validators
    public ValidationResult validateForUpdate(ManageGuest guest) {
        for (GuestValidationStrategy validator : updateValidators) {
            if (!validator.validate(guest)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Validate status only
    public ValidationResult validateStatus(String status) {
        ManageGuest tempGuest = new ManageGuest();
        tempGuest.setStatus(status);
        GuestStatusStrategy statusValidator = new GuestStatusStrategy();
        
        if (statusValidator.validate(tempGuest)) {
            return new ValidationResult(true, "Status is valid");
        } else {
            return new ValidationResult(false, statusValidator.getErrorMessage());
        }
    }
    
    // Validate password only
    public ValidationResult validatePassword(String password) {
        ManageGuest tempGuest = new ManageGuest();
        tempGuest.setPassword(password);
        GuestPasswordStrategy passwordValidator = new GuestPasswordStrategy();
        
        if (passwordValidator.validate(tempGuest)) {
            return new ValidationResult(true, "Password is valid");
        } else {
            return new ValidationResult(false, passwordValidator.getErrorMessage());
        }
    }
    
    // Check if username exists
    public boolean usernameExists(String username) {
        return guestDAO.usernameExists(username);
    }
    
    // Check if email exists
    public boolean emailExists(String email) {
        return guestDAO.emailExists(email);
    }
    
    // Check if username exists excluding a specific ID
    public boolean usernameExistsExcludingId(String username, int id) {
        return guestDAO.usernameExistsExcludingId(username, id);
    }
    
    // Check if email exists excluding a specific ID
    public boolean emailExistsExcludingId(String email, int id) {
        return guestDAO.emailExistsExcludingId(email, id);
    }
    
    // Create new guest with password hashing
    public ValidationResult createGuest(ManageGuest guest) {
        // Validate first
        ValidationResult validationResult = validateForCreate(guest);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if username already exists
        if (usernameExists(guest.getUsername())) {
            return new ValidationResult(false, "Username already exists");
        }
        
        // Check if email already exists
        if (emailExists(guest.getEmail())) {
            return new ValidationResult(false, "Email already exists");
        }
        
        // Hash the password
        String plainPassword = guest.getPassword();
        guest.hashAndSetPassword(plainPassword);
        
        // Set defaults if not set
        if (guest.getCreatedDate() == null) {
            guest.setCreatedDate(LocalDate.now());
        }
        if (guest.getUpdatedDate() == null) {
            guest.setUpdatedDate(LocalDateTime.now());
        }
        if (guest.getStatus() == null) {
            guest.setStatus("active");
        }
        
        // Save to database
        boolean saved = guestDAO.save(guest);
        
        if (saved) {
            return new ValidationResult(true, "Guest created successfully");
        } else {
            return new ValidationResult(false, "Failed to create guest");
        }
    }
    
    // Update guest (excluding password)
    public ValidationResult updateGuest(ManageGuest guest) {
        // Validate the guest for update
        ValidationResult validationResult = validateForUpdate(guest);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if username already exists (excluding current guest)
        if (usernameExistsExcludingId(guest.getUsername(), guest.getId())) {
            return new ValidationResult(false, "Username already exists");
        }
        
        // Check if email already exists (excluding current guest)
        if (emailExistsExcludingId(guest.getEmail(), guest.getId())) {
            return new ValidationResult(false, "Email already exists");
        }
        
        // Update in database
        boolean updated = guestDAO.update(guest);
        
        if (updated) {
            return new ValidationResult(true, "Guest updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update guest");
        }
    }
    
    // Update guest status only
    public ValidationResult updateGuestStatus(int id, String status) {
        // Validate status
        ValidationResult statusValidation = validateStatus(status);
        if (!statusValidation.isValid()) {
            return statusValidation;
        }
        
        // Check if guest exists
        ManageGuest guest = getGuestById(id);
        if (guest == null) {
            return new ValidationResult(false, "Guest not found");
        }
        
        // Update status
        boolean updated = guestDAO.updateStatus(id, status);
        
        if (updated) {
            return new ValidationResult(true, "Guest status updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update guest status");
        }
    }
    
    // Update guest password only (with hashing)
    public ValidationResult updateGuestPassword(int id, String newPassword) {
        // Validate password
        ValidationResult passwordValidation = validatePassword(newPassword);
        if (!passwordValidation.isValid()) {
            return passwordValidation;
        }
        
        // Check if guest exists
        ManageGuest guest = getGuestById(id);
        if (guest == null) {
            return new ValidationResult(false, "Guest not found");
        }
        
        // Hash the new password
        guest.hashAndSetPassword(newPassword);
        
        // Update password
        boolean updated = guestDAO.updatePassword(id, guest.getPassword());
        
        if (updated) {
            return new ValidationResult(true, "Password updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update password");
        }
    }
    
    // Update last login
    public boolean updateLastLogin(int id) {
        return guestDAO.updateLastLogin(id, LocalDateTime.now());
    }
    
    // Get all guests
    public List<ManageGuest> getAllGuests() {
        return guestDAO.findAll();
    }
    
    // Get guest by ID
    public ManageGuest getGuestById(int id) {
        return guestDAO.findById(id);
    }
    
    // Get guest by registration number
    public ManageGuest getGuestByRegNo(String regNo) {
        return guestDAO.findByRegNo(regNo);
    }
    
    // Get guest by username
    public ManageGuest getGuestByUsername(String username) {
        return guestDAO.findByUsername(username);
    }
    
    // Get guest by email
    public ManageGuest getGuestByEmail(String email) {
        return guestDAO.findByEmail(email);
    }
    
    // Get guests by status
    public List<ManageGuest> getGuestsByStatus(String status) {
        return guestDAO.findByStatus(status);
    }
    
    // Get active guests
    public List<ManageGuest> getActiveGuests() {
        return guestDAO.findByStatus("active");
    }
    
    // Get inactive guests
    public List<ManageGuest> getInactiveGuests() {
        return guestDAO.findByStatus("inactive");
    }
    
    // Get guests by gender
    public List<ManageGuest> getGuestsByGender(String gender) {
        return guestDAO.findByGender(gender);
    }
    
    // Search guests by keyword
    public List<ManageGuest> searchGuests(String keyword) {
        return guestDAO.search(keyword);
    }
    
    // Get guests by date range
    public List<ManageGuest> getGuestsByDateRange(LocalDate startDate, LocalDate endDate) {
        return guestDAO.findByDateRange(startDate, endDate);
    }
    
    // Get guests by month and year
    public List<ManageGuest> getGuestsByMonthYear(int month, int year) {
        return guestDAO.findByMonthYear(month, year);
    }
    
    // Get recent guests
    public List<ManageGuest> getRecentGuests(int limit) {
        return guestDAO.findRecent(limit);
    }
    
    // Get inactive guests since date
    public List<ManageGuest> getInactiveGuestsSince(LocalDateTime date) {
        return guestDAO.findInactiveSince(date);
    }
    
    // Delete guest
    public boolean deleteGuest(int id) {
        return guestDAO.delete(id);
    }
    
    // Authenticate guest
    public ManageGuest authenticate(String username, String password) {
        return guestDAO.authenticate(username, password);
    }
    
    // Statistics methods
    public int getTotalCount() {
        return guestDAO.countAll();
    }
    
    public int getActiveCount() {
        return guestDAO.countActive();
    }
    
    public int getInactiveCount() {
        return guestDAO.countInactive();
    }
    
    public int getMaleCount() {
        return guestDAO.countByGender("male");
    }
    
    public int getFemaleCount() {
        return guestDAO.countByGender("female");
    }
    
    public int getOtherGenderCount() {
        return guestDAO.countByGender("other") + guestDAO.countByGender("prefer-not");
    }
    
    public int getCreatedThisMonthCount() {
        return guestDAO.countCreatedThisMonth();
    }
    
    public int getCreatedLastMonthCount() {
        return guestDAO.countCreatedLastMonth();
    }
    
    public int getCreatedThisYearCount() {
        return guestDAO.countCreatedThisYear();
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