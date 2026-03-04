package wepapp.service;

import wepapp.dao.TableLocationDAO;
import wepapp.model.TableLocation;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

// Strategy Pattern - Validation Strategy Interface
interface TableLocationValidationStrategy {
    boolean validate(TableLocation location);
    String getErrorMessage();
}

// Required Fields Validation Strategy
class TableLocationRequiredFieldsStrategy implements TableLocationValidationStrategy {
    @Override
    public boolean validate(TableLocation location) {
        return location.getName() != null && !location.getName().trim().isEmpty();
    }
    
    @Override
    public String getErrorMessage() {
        return "Location name is required";
    }
}

// Name Length Validation Strategy
class TableLocationNameLengthStrategy implements TableLocationValidationStrategy {
    private static final int MIN_LENGTH = 3;
    private static final int MAX_LENGTH = 100;
    
    @Override
    public boolean validate(TableLocation location) {
        String name = location.getName();
        return name != null && name.length() >= MIN_LENGTH && name.length() <= MAX_LENGTH;
    }
    
    @Override
    public String getErrorMessage() {
        return "Location name must be between " + MIN_LENGTH + " and " + MAX_LENGTH + " characters";
    }
}

// Name Format Validation Strategy
class TableLocationNameFormatStrategy implements TableLocationValidationStrategy {
    private static final String NAME_PATTERN = "^[a-zA-Z0-9\\s\\-&]+$";
    
    @Override
    public boolean validate(TableLocation location) {
        String name = location.getName();
        return name != null && name.matches(NAME_PATTERN);
    }
    
    @Override
    public String getErrorMessage() {
        return "Location name can only contain letters, numbers, spaces, hyphens, and ampersands (&)";
    }
}

// Main Service Class
public class TableLocationService {
    private final TableLocationDAO locationDAO;
    private final List<TableLocationValidationStrategy> validators;
    
    public TableLocationService() {
        this.locationDAO = TableLocationDAO.getInstance();
        this.validators = List.of(
            new TableLocationRequiredFieldsStrategy(),
            new TableLocationNameLengthStrategy(),
            new TableLocationNameFormatStrategy()
        );
    }
    
    // Validate location using all strategies
    public ValidationResult validateLocation(TableLocation location) {
        for (TableLocationValidationStrategy validator : validators) {
            if (!validator.validate(location)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Check if location name exists
    public boolean locationExists(String name) {
        return locationDAO.exists(name);
    }
    
    // Check if location name exists excluding a specific ID
    public boolean locationExistsExcludingId(String name, int id) {
        return locationDAO.existsExcludingId(name, id);
    }
    
    // Create new location
    public ValidationResult createLocation(TableLocation location) {
        // Validate first
        ValidationResult validationResult = validateLocation(location);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if location name already exists
        if (locationExists(location.getName())) {
            return new ValidationResult(false, "Location name already exists");
        }
        
        // Set defaults if not set
        if (location.getCreatedDate() == null) {
            location.setCreatedDate(LocalDate.now());
        }
        if (location.getUpdatedDate() == null) {
            location.setUpdatedDate(LocalDateTime.now());
        }
        
        // Save to database
        boolean saved = locationDAO.save(location);
        
        if (saved) {
            return new ValidationResult(true, "Location created successfully");
        } else {
            return new ValidationResult(false, "Failed to create location");
        }
    }
    
    // Update location
    public ValidationResult updateLocation(TableLocation location) {
        // Validate the location before updating
        ValidationResult validationResult = validateLocation(location);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if location name already exists (excluding current location)
        if (locationExistsExcludingId(location.getName(), location.getId())) {
            return new ValidationResult(false, "Location name already exists");
        }
        
        // Update in database
        boolean updated = locationDAO.update(location);
        
        if (updated) {
            return new ValidationResult(true, "Location updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update location");
        }
    }
    
    // Get all locations
    public List<TableLocation> getAllLocations() {
        return locationDAO.findAll();
    }
    
    // Get location by ID
    public TableLocation getLocationById(int id) {
        return locationDAO.findById(id);
    }
    
    // Get location by name
    public TableLocation getLocationByName(String name) {
        return locationDAO.findByName(name);
    }
    
    // Search locations by name
    public List<TableLocation> searchLocations(String keyword) {
        return locationDAO.searchByName(keyword);
    }
    
    // Get locations by date range
    public List<TableLocation> getLocationsByDateRange(LocalDate startDate, LocalDate endDate) {
        return locationDAO.findByDateRange(startDate, endDate);
    }
    
    // Get locations by month and year
    public List<TableLocation> getLocationsByMonthYear(int month, int year) {
        return locationDAO.findByMonthYear(month, year);
    }
    
    // Get recent locations
    public List<TableLocation> getRecentLocations(int limit) {
        return locationDAO.findRecent(limit);
    }
    
    // Delete location
    public boolean deleteLocation(int id) {
        // Check if location is being used by any tables
        // This would require a TableDAO check - implement as needed
        return locationDAO.delete(id);
    }
    
    // Statistics methods
    public int getTotalCount() {
        return locationDAO.countAll();
    }
    
    public int getCreatedThisMonthCount() {
        return locationDAO.countCreatedThisMonth();
    }
    
    public int getCreatedLastMonthCount() {
        return locationDAO.countCreatedLastMonth();
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