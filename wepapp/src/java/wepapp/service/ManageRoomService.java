package wepapp.service;

import wepapp.dao.ManageRoomDAO;
import wepapp.dao.RoomTypeDAO;
import wepapp.dao.FacilityDAO;
import wepapp.model.ManageRoom;
import wepapp.model.RoomType;
import wepapp.model.Facility;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

public class ManageRoomService {
    private final ManageRoomDAO roomDAO;
    private final RoomTypeDAO typeDAO;
    private final FacilityDAO facilityDAO;
    
    public ManageRoomService() {
        this.roomDAO = ManageRoomDAO.getInstance();
        this.typeDAO = RoomTypeDAO.getInstance();
        this.facilityDAO = FacilityDAO.getInstance();
    }
    
    public ValidationResult createRoom(ManageRoom room) {
        try {
            if (room.getRoomNo() == null || room.getRoomNo().trim().isEmpty()) {
                return new ValidationResult(false, "Room number is required");
            }
            
            if (room.getDescription() == null || room.getDescription().trim().isEmpty()) {
                return new ValidationResult(false, "Description is required");
            }
            
            if (room.getTypeId() <= 0) {
                return new ValidationResult(false, "Room type is required");
            }
            
            if (room.getFacilityIds() == null || room.getFacilityIds().isEmpty()) {
                return new ValidationResult(false, "At least one facility is required");
            }
            
            if (room.getCapacity() <= 0) {
                return new ValidationResult(false, "Capacity must be greater than 0");
            }
            
            if (room.getPrice() <= 0) {
                return new ValidationResult(false, "Price must be greater than 0");
            }
            
            ManageRoom existing = roomDAO.findByRoomNo(room.getRoomNo());
            if (existing != null) {
                return new ValidationResult(false, "Room number already exists");
            }
            
            if (room.getRoomPrefix() == null || room.getRoomPrefix().isEmpty()) {
                room.setRoomPrefix(roomDAO.getNextRoomPrefix());
            }
            
            room.setCreatedDate(LocalDate.now());
            room.setUpdatedDate(LocalDateTime.now());
            
            boolean saved = roomDAO.save(room);
            
            if (saved) {
                return new ValidationResult(true, "Room created successfully!");
            } else {
                return new ValidationResult(false, "Failed to create room. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ValidationResult(false, "Error: " + e.getMessage());
        }
    }
    
    public ValidationResult updateRoom(ManageRoom room) {
        try {
            if (room.getRoomNo() == null || room.getRoomNo().trim().isEmpty()) {
                return new ValidationResult(false, "Room number is required");
            }
            
            if (room.getDescription() == null || room.getDescription().trim().isEmpty()) {
                return new ValidationResult(false, "Description is required");
            }
            
            if (room.getTypeId() <= 0) {
                return new ValidationResult(false, "Room type is required");
            }
            
            if (room.getFacilityIds() == null || room.getFacilityIds().isEmpty()) {
                return new ValidationResult(false, "At least one facility is required");
            }
            
            if (room.getCapacity() <= 0) {
                return new ValidationResult(false, "Capacity must be greater than 0");
            }
            
            if (room.getPrice() <= 0) {
                return new ValidationResult(false, "Price must be greater than 0");
            }
            
            if (roomDAO.roomNoExistsExcludingId(room.getRoomNo(), room.getId())) {
                return new ValidationResult(false, "Room number already exists");
            }
            
            room.setUpdatedDate(LocalDateTime.now());
            
            boolean updated = roomDAO.update(room);
            
            if (updated) {
                return new ValidationResult(true, "Room updated successfully!");
            } else {
                return new ValidationResult(false, "Failed to update room. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ValidationResult(false, "Error: " + e.getMessage());
        }
    }
    
    public List<ManageRoom> getAllRooms() {
        try {
            List<ManageRoom> rooms = roomDAO.findAll();
            populateFacilityNames(rooms);
            return rooms;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public ManageRoom getRoomById(int id) {
        try {
            ManageRoom room = roomDAO.findById(id);
            if (room != null) {
                populateFacilityNames(room);
            }
            return room;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public List<ManageRoom> getAvailableRooms() {
        try {
            List<ManageRoom> rooms = roomDAO.findByStatus("available");
            populateFacilityNames(rooms);
            return rooms;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<ManageRoom> getMaintenanceRooms() {
        try {
            List<ManageRoom> rooms = roomDAO.findByStatus("maintenance");
            populateFacilityNames(rooms);
            return rooms;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<ManageRoom> getRoomsByType(int typeId) {
        try {
            List<ManageRoom> rooms = roomDAO.findByTypeId(typeId);
            populateFacilityNames(rooms);
            return rooms;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<ManageRoom> searchRooms(String keyword) {
        try {
            List<ManageRoom> rooms = roomDAO.search(keyword);
            populateFacilityNames(rooms);
            return rooms;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<ManageRoom> advancedSearch(String keyword, Integer typeId, String status, 
                                          Integer minCapacity, Double minPrice, Double maxPrice,
                                          List<Integer> facilityIds) {
        try {
            List<ManageRoom> allRooms = getAllRooms();
            
            return allRooms.stream()
                .filter(room -> {
                    if (keyword != null && !keyword.isEmpty()) {
                        return room.getRoomNo().toLowerCase().contains(keyword.toLowerCase()) ||
                               room.getRoomPrefix().toLowerCase().contains(keyword.toLowerCase()) ||
                               room.getDescription().toLowerCase().contains(keyword.toLowerCase());
                    }
                    return true;
                })
                .filter(room -> {
                    if (typeId != null && typeId > 0) {
                        return room.getTypeId() == typeId;
                    }
                    return true;
                })
                .filter(room -> {
                    if (status != null && !status.isEmpty() && !status.equals("all")) {
                        return room.getStatus().equals(status);
                    }
                    return true;
                })
                .filter(room -> {
                    if (minCapacity != null && minCapacity > 0) {
                        return room.getCapacity() >= minCapacity;
                    }
                    return true;
                })
                .filter(room -> {
                    if (minPrice != null && minPrice > 0) {
                        return room.getPrice() >= minPrice;
                    }
                    return true;
                })
                .filter(room -> {
                    if (maxPrice != null && maxPrice > 0) {
                        return room.getPrice() <= maxPrice;
                    }
                    return true;
                })
                .filter(room -> {
                    if (facilityIds != null && !facilityIds.isEmpty()) {
                        return room.getFacilityIds().containsAll(facilityIds);
                    }
                    return true;
                })
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public boolean updateRoomStatus(int id, String status) {
        try {
            return roomDAO.updateStatus(id, status);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteRoom(int id) {
        try {
            return roomDAO.delete(id);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<RoomTypeStat> getRoomTypeStatistics() {
        try {
            List<ManageRoomDAO.TypeStat> stats = roomDAO.getRoomTypeStatistics();
            List<RoomTypeStat> result = new ArrayList<>();
            for (ManageRoomDAO.TypeStat stat : stats) {
                RoomTypeStat roomTypeStat = new RoomTypeStat();
                roomTypeStat.setId(stat.getId());
                roomTypeStat.setName(stat.getName());
                roomTypeStat.setCount(stat.getRoomCount());
                result.add(roomTypeStat);
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public Stats getStats() {
        try {
            ManageRoomDAO.Stats daoStats = roomDAO.getStats();
            Stats stats = new Stats();
            stats.setTotal(daoStats.getTotal());
            stats.setAvailable(daoStats.getAvailable());
            stats.setMaintenance(daoStats.getMaintenance());
            return stats;
        } catch (Exception e) {
            e.printStackTrace();
            return new Stats(0, 0, 0);
        }
    }
    
    public String getNextRoomPrefix() {
        try {
            return roomDAO.getNextRoomPrefix();
        } catch (Exception e) {
            e.printStackTrace();
            return "R-00001";
        }
    }
    
    public boolean roomNumberExists(String roomNo) {
        try {
            return roomDAO.findByRoomNo(roomNo) != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private void populateFacilityNames(ManageRoom room) {
        try {
            if (room == null || room.getFacilityIds() == null) {
                return;
            }
            
            List<String> facilityNames = new ArrayList<>();
            for (int facilityId : room.getFacilityIds()) {
                Facility facility = facilityDAO.findById(facilityId);
                if (facility != null) {
                    facilityNames.add(facility.getName());
                }
            }
            room.setFacilityNames(facilityNames);
            
            RoomType type = typeDAO.findById(room.getTypeId());
            if (type != null) {
                room.setTypeName(type.getName());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void populateFacilityNames(List<ManageRoom> rooms) {
        for (ManageRoom room : rooms) {
            populateFacilityNames(room);
        }
    }
    
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
    
    public static class RoomTypeStat {
        private int id;
        private String name;
        private int count;
        
        public RoomTypeStat() {}
        
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public int getCount() { return count; }
        public void setCount(int count) { this.count = count; }
    }
    
    public static class Stats {
        private int total;
        private int available;
        private int maintenance;
        
        public Stats() {}
        
        public Stats(int total, int available, int maintenance) {
            this.total = total;
            this.available = available;
            this.maintenance = maintenance;
        }
        
        public int getTotal() { return total; }
        public void setTotal(int total) { this.total = total; }
        public int getAvailable() { return available; }
        public void setAvailable(int available) { this.available = available; }
        public int getMaintenance() { return maintenance; }
        public void setMaintenance(int maintenance) { this.maintenance = maintenance; }
    }
}