package wepapp.service;

import wepapp.dao.FacilityDAO;
import wepapp.model.Facility;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

// Strategy Pattern - Validation Strategy Interface
interface FacilityValidationStrategy {
    boolean validate(Facility facility);
    String getErrorMessage();
}

// Required Fields Validation Strategy
class FacilityRequiredFieldsStrategy implements FacilityValidationStrategy {
    @Override
    public boolean validate(Facility facility) {
        return facility.getName() != null && !facility.getName().trim().isEmpty();
    }
    
    @Override
    public String getErrorMessage() {
        return "Facility name is required";
    }
}

// Name Length Validation Strategy
class FacilityNameLengthStrategy implements FacilityValidationStrategy {
    private static final int MIN_LENGTH = 2;
    private static final int MAX_LENGTH = 100;
    
    @Override
    public boolean validate(Facility facility) {
        String name = facility.getName();
        return name != null && name.length() >= MIN_LENGTH && name.length() <= MAX_LENGTH;
    }
    
    @Override
    public String getErrorMessage() {
        return "Facility name must be between " + MIN_LENGTH + " and " + MAX_LENGTH + " characters";
    }
}

// Name Format Validation Strategy
class FacilityNameFormatStrategy implements FacilityValidationStrategy {
    private static final String NAME_PATTERN = "^[a-zA-Z0-9\\s\\-&]+$";
    
    @Override
    public boolean validate(Facility facility) {
        String name = facility.getName();
        return name != null && name.matches(NAME_PATTERN);
    }
    
    @Override
    public String getErrorMessage() {
        return "Facility name can only contain letters, numbers, spaces, hyphens, and ampersands (&)";
    }
}

// Main Service Class
public class FacilityService {
    private final FacilityDAO facilityDAO;
    private final List<FacilityValidationStrategy> validators;
    
    public FacilityService() {
        this.facilityDAO = FacilityDAO.getInstance();
        this.validators = List.of(
            new FacilityRequiredFieldsStrategy(),
            new FacilityNameLengthStrategy(),
            new FacilityNameFormatStrategy()
        );
    }
    
    // Validate facility using all strategies
    public ValidationResult validateFacility(Facility facility) {
        for (FacilityValidationStrategy validator : validators) {
            if (!validator.validate(facility)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Check if facility name exists
    public boolean facilityExists(String name) {
        return facilityDAO.exists(name);
    }
    
    // Check if facility name exists excluding a specific ID
    public boolean facilityExistsExcludingId(String name, int id) {
        return facilityDAO.existsExcludingId(name, id);
    }
    
    // Create new facility
    public ValidationResult createFacility(Facility facility) {
        // Validate first
        ValidationResult validationResult = validateFacility(facility);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if facility name already exists
        if (facilityExists(facility.getName())) {
            return new ValidationResult(false, "Facility name already exists");
        }
        
        // Set defaults if not set
        if (facility.getCreatedDate() == null) {
            facility.setCreatedDate(LocalDate.now());
        }
        if (facility.getUpdatedDate() == null) {
            facility.setUpdatedDate(LocalDateTime.now());
        }
        
        // Save to database
        boolean saved = facilityDAO.save(facility);
        
        if (saved) {
            return new ValidationResult(true, "Facility created successfully");
        } else {
            return new ValidationResult(false, "Failed to create facility");
        }
    }
    
    // Update facility
    public ValidationResult updateFacility(Facility facility) {
        // Validate the facility before updating
        ValidationResult validationResult = validateFacility(facility);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if facility name already exists (excluding current facility)
        if (facilityExistsExcludingId(facility.getName(), facility.getId())) {
            return new ValidationResult(false, "Facility name already exists");
        }
        
        // Update in database
        boolean updated = facilityDAO.update(facility);
        
        if (updated) {
            return new ValidationResult(true, "Facility updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update facility");
        }
    }
    
    // Get all facilities
    public List<Facility> getAllFacilities() {
        return facilityDAO.findAll();
    }
    
    // Get facility by ID
    public Facility getFacilityById(int id) {
        return facilityDAO.findById(id);
    }
    
    // Get facility by name
    public Facility getFacilityByName(String name) {
        return facilityDAO.findByName(name);
    }
    
    // Search facilities by name
    public List<Facility> searchFacilities(String keyword) {
        return facilityDAO.searchByName(keyword);
    }
    
    // Get facilities by date range
    public List<Facility> getFacilitiesByDateRange(LocalDate startDate, LocalDate endDate) {
        return facilityDAO.findByDateRange(startDate, endDate);
    }
    
    // Get facilities by month and year
    public List<Facility> getFacilitiesByMonthYear(int month, int year) {
        return facilityDAO.findByMonthYear(month, year);
    }
    
    // Get recent facilities
    public List<Facility> getRecentFacilities(int limit) {
        return facilityDAO.findRecent(limit);
    }
    
    // Delete facility
    public boolean deleteFacility(int id) {
        return facilityDAO.delete(id);
    }
    
    // Statistics methods
    public int getTotalCount() {
        return facilityDAO.countAll();
    }
    
    public int getCreatedThisMonthCount() {
        return facilityDAO.countCreatedThisMonth();
    }
    
    public int getCreatedLastMonthCount() {
        return facilityDAO.countCreatedLastMonth();
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