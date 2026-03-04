package wepapp.service;

import wepapp.dao.RoleDAO;
import wepapp.model.Role;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

// Strategy Pattern - Validation Strategy Interface
interface RoleValidationStrategy {
    boolean validate(Role role);
    String getErrorMessage();
}

// Required Fields Validation Strategy
class RoleRequiredFieldsStrategy implements RoleValidationStrategy {
    @Override
    public boolean validate(Role role) {
        return role.getName() != null && !role.getName().trim().isEmpty();
    }
    
    @Override
    public String getErrorMessage() {
        return "Role name is required";
    }
}

// Name Length Validation Strategy
class RoleNameLengthStrategy implements RoleValidationStrategy {
    private static final int MIN_LENGTH = 2;
    private static final int MAX_LENGTH = 50;
    
    @Override
    public boolean validate(Role role) {
        String name = role.getName();
        return name != null && name.length() >= MIN_LENGTH && name.length() <= MAX_LENGTH;
    }
    
    @Override
    public String getErrorMessage() {
        return "Role name must be between " + MIN_LENGTH + " and " + MAX_LENGTH + " characters";
    }
}

// Name Format Validation Strategy
class RoleNameFormatStrategy implements RoleValidationStrategy {
    private static final String NAME_PATTERN = "^[a-zA-Z\\s]+$";
    
    @Override
    public boolean validate(Role role) {
        String name = role.getName();
        return name != null && name.matches(NAME_PATTERN);
    }
    
    @Override
    public String getErrorMessage() {
        return "Role name can only contain letters and spaces";
    }
}

// Main Service Class
public class RoleService {
    private final RoleDAO roleDAO;
    private final List<RoleValidationStrategy> validators;
    
    public RoleService() {
        this.roleDAO = RoleDAO.getInstance();
        this.validators = List.of(
            new RoleRequiredFieldsStrategy(),
            new RoleNameLengthStrategy(),
            new RoleNameFormatStrategy()
        );
    }
    
    // Validate role using all strategies
    public ValidationResult validateRole(Role role) {
        for (RoleValidationStrategy validator : validators) {
            if (!validator.validate(role)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Check if role name exists
    public boolean roleExists(String name) {
        return roleDAO.exists(name);
    }
    
    // Check if role name exists excluding a specific ID
    public boolean roleExistsExcludingId(String name, int id) {
        return roleDAO.existsExcludingId(name, id);
    }
    
    // Create new role
    public ValidationResult createRole(Role role) {
        // Validate first
        ValidationResult validationResult = validateRole(role);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if role name already exists
        if (roleExists(role.getName())) {
            return new ValidationResult(false, "Role name already exists");
        }
        
        // Set defaults if not set
        if (role.getCreatedDate() == null) {
            role.setCreatedDate(LocalDate.now());
        }
        if (role.getUpdatedDate() == null) {
            role.setUpdatedDate(LocalDateTime.now());
        }
        
        // Save to database
        boolean saved = roleDAO.save(role);
        
        if (saved) {
            return new ValidationResult(true, "Role created successfully");
        } else {
            return new ValidationResult(false, "Failed to create role");
        }
    }
    
    // Update role
    public ValidationResult updateRole(Role role) {
        // Validate the role before updating
        ValidationResult validationResult = validateRole(role);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if role name already exists (excluding current role)
        if (roleExistsExcludingId(role.getName(), role.getId())) {
            return new ValidationResult(false, "Role name already exists");
        }
        
        // Update in database
        boolean updated = roleDAO.update(role);
        
        if (updated) {
            return new ValidationResult(true, "Role updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update role");
        }
    }
    
    // Get all roles
    public List<Role> getAllRoles() {
        return roleDAO.findAll();
    }
    
    // Get role by ID
    public Role getRoleById(int id) {
        return roleDAO.findById(id);
    }
    
    // Get role by name
    public Role getRoleByName(String name) {
        return roleDAO.findByName(name);
    }
    
    // Search roles by name
    public List<Role> searchRoles(String keyword) {
        return roleDAO.searchByName(keyword);
    }
    
    // Get roles by date range
    public List<Role> getRolesByDateRange(LocalDate startDate, LocalDate endDate) {
        return roleDAO.findByDateRange(startDate, endDate);
    }
    
    // Get roles by month and year
    public List<Role> getRolesByMonthYear(int month, int year) {
        return roleDAO.findByMonthYear(month, year);
    }
    
    // Get recent roles
    public List<Role> getRecentRoles(int limit) {
        return roleDAO.findRecent(limit);
    }
    
    // Delete role
    public boolean deleteRole(int id) {
        // Check if role is being used by any staff members
        // This would require a StaffDAO check - implement as needed
        return roleDAO.delete(id);
    }
    
    // Statistics methods
    public int getTotalCount() {
        return roleDAO.countAll();
    }
    
    public int getCreatedThisMonthCount() {
        return roleDAO.countCreatedThisMonth();
    }
    
    public int getCreatedLastMonthCount() {
        return roleDAO.countCreatedLastMonth();
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