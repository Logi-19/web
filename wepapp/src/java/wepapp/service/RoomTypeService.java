package wepapp.service;

import wepapp.dao.RoomTypeDAO;
import wepapp.model.RoomType;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

// Strategy Pattern - Validation Strategy Interface
interface RoomTypeValidationStrategy {
    boolean validate(RoomType roomType);
    String getErrorMessage();
}

// Required Fields Validation Strategy
class RoomTypeRequiredFieldsStrategy implements RoomTypeValidationStrategy {
    @Override
    public boolean validate(RoomType roomType) {
        return roomType.getName() != null && !roomType.getName().trim().isEmpty();
    }
    
    @Override
    public String getErrorMessage() {
        return "Room type name is required";
    }
}

// Name Length Validation Strategy
class RoomTypeNameLengthStrategy implements RoomTypeValidationStrategy {
    private static final int MIN_LENGTH = 3;
    private static final int MAX_LENGTH = 100;
    
    @Override
    public boolean validate(RoomType roomType) {
        String name = roomType.getName();
        return name != null && name.length() >= MIN_LENGTH && name.length() <= MAX_LENGTH;
    }
    
    @Override
    public String getErrorMessage() {
        return "Room type name must be between " + MIN_LENGTH + " and " + MAX_LENGTH + " characters";
    }
}

// Name Format Validation Strategy
class RoomTypeNameFormatStrategy implements RoomTypeValidationStrategy {
    private static final String NAME_PATTERN = "^[a-zA-Z0-9\\s\\-&]+$";
    
    @Override
    public boolean validate(RoomType roomType) {
        String name = roomType.getName();
        return name != null && name.matches(NAME_PATTERN);
    }
    
    @Override
    public String getErrorMessage() {
        return "Room type name can only contain letters, numbers, spaces, hyphens, and ampersands (&)";
    }
}

// Main Service Class
public class RoomTypeService {
    private final RoomTypeDAO roomTypeDAO;
    private final List<RoomTypeValidationStrategy> validators;
    
    public RoomTypeService() {
        this.roomTypeDAO = RoomTypeDAO.getInstance();
        this.validators = List.of(
            new RoomTypeRequiredFieldsStrategy(),
            new RoomTypeNameLengthStrategy(),
            new RoomTypeNameFormatStrategy()
        );
    }
    
    // Validate room type using all strategies
    public ValidationResult validateRoomType(RoomType roomType) {
        for (RoomTypeValidationStrategy validator : validators) {
            if (!validator.validate(roomType)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Check if room type name exists
    public boolean roomTypeExists(String name) {
        return roomTypeDAO.exists(name);
    }
    
    // Check if room type name exists excluding a specific ID
    public boolean roomTypeExistsExcludingId(String name, int id) {
        return roomTypeDAO.existsExcludingId(name, id);
    }
    
    // Create new room type
    public ValidationResult createRoomType(RoomType roomType) {
        // Validate first
        ValidationResult validationResult = validateRoomType(roomType);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if room type name already exists
        if (roomTypeExists(roomType.getName())) {
            return new ValidationResult(false, "Room type name already exists");
        }
        
        // Set defaults if not set
        if (roomType.getCreatedDate() == null) {
            roomType.setCreatedDate(LocalDate.now());
        }
        if (roomType.getUpdatedDate() == null) {
            roomType.setUpdatedDate(LocalDateTime.now());
        }
        
        // Save to database
        boolean saved = roomTypeDAO.save(roomType);
        
        if (saved) {
            return new ValidationResult(true, "Room type created successfully");
        } else {
            return new ValidationResult(false, "Failed to create room type");
        }
    }
    
    // Update room type
    public ValidationResult updateRoomType(RoomType roomType) {
        // Validate the room type before updating
        ValidationResult validationResult = validateRoomType(roomType);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if room type name already exists (excluding current room type)
        if (roomTypeExistsExcludingId(roomType.getName(), roomType.getId())) {
            return new ValidationResult(false, "Room type name already exists");
        }
        
        // Update in database
        boolean updated = roomTypeDAO.update(roomType);
        
        if (updated) {
            return new ValidationResult(true, "Room type updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update room type");
        }
    }
    
    // Get all room types
    public List<RoomType> getAllRoomTypes() {
        return roomTypeDAO.findAll();
    }
    
    // Get room type by ID
    public RoomType getRoomTypeById(int id) {
        return roomTypeDAO.findById(id);
    }
    
    // Get room type by name
    public RoomType getRoomTypeByName(String name) {
        return roomTypeDAO.findByName(name);
    }
    
    // Search room types by name
    public List<RoomType> searchRoomTypes(String keyword) {
        return roomTypeDAO.searchByName(keyword);
    }
    
    // Get room types by date range
    public List<RoomType> getRoomTypesByDateRange(LocalDate startDate, LocalDate endDate) {
        return roomTypeDAO.findByDateRange(startDate, endDate);
    }
    
    // Get room types by month and year
    public List<RoomType> getRoomTypesByMonthYear(int month, int year) {
        return roomTypeDAO.findByMonthYear(month, year);
    }
    
    // Get recent room types
    public List<RoomType> getRecentRoomTypes(int limit) {
        return roomTypeDAO.findRecent(limit);
    }
    
    // Delete room type
    public boolean deleteRoomType(int id) {
        // Check if room type is being used by any rooms
        // This would require a RoomDAO check - implement as needed
        return roomTypeDAO.delete(id);
    }
    
    // Statistics methods
    public int getTotalCount() {
        return roomTypeDAO.countAll();
    }
    
    // FIXED: These methods now call the correct DAO methods
    public int getCreatedThisMonthCount() {
        // Get current month and year
        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        int year = now.getYear();
        
        // Get room types created this month and count them
        List<RoomType> roomTypesThisMonth = roomTypeDAO.findByMonthYear(month, year);
        return roomTypesThisMonth.size();
    }
    
    public int getCreatedLastMonthCount() {
        // Get last month and year
        LocalDate now = LocalDate.now();
        LocalDate lastMonth = now.minusMonths(1);
        int month = lastMonth.getMonthValue();
        int year = lastMonth.getYear();
        
        // Get room types created last month and count them
        List<RoomType> roomTypesLastMonth = roomTypeDAO.findByMonthYear(month, year);
        return roomTypesLastMonth.size();
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