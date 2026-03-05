package wepapp.service;

import wepapp.dao.ManageTableDAO;
import wepapp.dao.TableLocationDAO;
import wepapp.model.ManageTable;
import wepapp.model.TableLocation;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

public class ManageTableService {
    private final ManageTableDAO tableDAO;
    private final TableLocationDAO locationDAO;
    
    public ManageTableService() {
        this.tableDAO = ManageTableDAO.getInstance();
        this.locationDAO = TableLocationDAO.getInstance();
    }
    
    public ValidationResult createTable(ManageTable table) {
        try {
            if (table.getTableNo() == null || table.getTableNo().trim().isEmpty()) {
                return new ValidationResult(false, "Table number is required");
            }
            
            if (table.getDescription() == null || table.getDescription().trim().isEmpty()) {
                return new ValidationResult(false, "Description is required");
            }
            
            if (table.getLocationId() <= 0) {
                return new ValidationResult(false, "Location is required");
            }
            
            if (table.getCapacity() <= 0) {
                return new ValidationResult(false, "Capacity must be greater than 0");
            }
            
            ManageTable existing = tableDAO.findByTableNo(table.getTableNo());
            if (existing != null) {
                return new ValidationResult(false, "Table number already exists");
            }
            
            if (table.getTablePrefix() == null || table.getTablePrefix().isEmpty()) {
                table.setTablePrefix(tableDAO.getNextTablePrefix());
            }
            
            table.setCreatedDate(LocalDate.now());
            table.setUpdatedDate(LocalDateTime.now());
            
            boolean saved = tableDAO.save(table);
            
            if (saved) {
                return new ValidationResult(true, "Table created successfully!");
            } else {
                return new ValidationResult(false, "Failed to create table. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ValidationResult(false, "Error: " + e.getMessage());
        }
    }
    
    public ValidationResult updateTable(ManageTable table) {
        try {
            if (table.getTableNo() == null || table.getTableNo().trim().isEmpty()) {
                return new ValidationResult(false, "Table number is required");
            }
            
            if (table.getDescription() == null || table.getDescription().trim().isEmpty()) {
                return new ValidationResult(false, "Description is required");
            }
            
            if (table.getLocationId() <= 0) {
                return new ValidationResult(false, "Location is required");
            }
            
            if (table.getCapacity() <= 0) {
                return new ValidationResult(false, "Capacity must be greater than 0");
            }
            
            if (tableDAO.tableNoExistsExcludingId(table.getTableNo(), table.getId())) {
                return new ValidationResult(false, "Table number already exists");
            }
            
            table.setUpdatedDate(LocalDateTime.now());
            
            boolean updated = tableDAO.update(table);
            
            if (updated) {
                return new ValidationResult(true, "Table updated successfully!");
            } else {
                return new ValidationResult(false, "Failed to update table. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ValidationResult(false, "Error: " + e.getMessage());
        }
    }
    
    public List<ManageTable> getAllTables() {
        try {
            List<ManageTable> tables = tableDAO.findAll();
            populateLocationNames(tables);
            return tables;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public ManageTable getTableById(int id) {
        try {
            ManageTable table = tableDAO.findById(id);
            if (table != null) {
                populateLocationName(table);
            }
            return table;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public List<ManageTable> getAvailableTables() {
        try {
            List<ManageTable> tables = tableDAO.findByStatus("available");
            populateLocationNames(tables);
            return tables;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<ManageTable> getMaintenanceTables() {
        try {
            List<ManageTable> tables = tableDAO.findByStatus("maintenance");
            populateLocationNames(tables);
            return tables;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<ManageTable> getTablesByLocation(int locationId) {
        try {
            List<ManageTable> tables = tableDAO.findByLocationId(locationId);
            populateLocationNames(tables);
            return tables;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<ManageTable> searchTables(String keyword) {
        try {
            List<ManageTable> tables = tableDAO.search(keyword);
            populateLocationNames(tables);
            return tables;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<ManageTable> advancedSearch(String keyword, Integer locationId, String status, Integer minCapacity) {
        try {
            List<ManageTable> allTables = getAllTables();
            
            return allTables.stream()
                .filter(table -> {
                    if (keyword != null && !keyword.isEmpty()) {
                        return table.getTableNo().toLowerCase().contains(keyword.toLowerCase()) ||
                               table.getTablePrefix().toLowerCase().contains(keyword.toLowerCase()) ||
                               table.getDescription().toLowerCase().contains(keyword.toLowerCase());
                    }
                    return true;
                })
                .filter(table -> {
                    if (locationId != null && locationId > 0) {
                        return table.getLocationId() == locationId;
                    }
                    return true;
                })
                .filter(table -> {
                    if (status != null && !status.isEmpty() && !status.equals("all")) {
                        return table.getStatus().equals(status);
                    }
                    return true;
                })
                .filter(table -> {
                    if (minCapacity != null && minCapacity > 0) {
                        return table.getCapacity() >= minCapacity;
                    }
                    return true;
                })
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public boolean updateTableStatus(int id, String status) {
        try {
            return tableDAO.updateStatus(id, status);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteTable(int id) {
        try {
            return tableDAO.delete(id);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // FIXED: Convert DAO LocationStat to Service LocationStat
    public List<LocationStat> getLocationStatistics() {
        try {
            List<ManageTableDAO.LocationStat> daoStats = tableDAO.getLocationStatistics();
            List<LocationStat> serviceStats = new ArrayList<>();
            
            for (ManageTableDAO.LocationStat daoStat : daoStats) {
                LocationStat stat = new LocationStat();
                stat.setId(daoStat.getId());
                stat.setName(daoStat.getName());
                stat.setCount(daoStat.getTableCount());
                serviceStats.add(stat);
            }
            
            return serviceStats;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    // FIXED: Convert DAO Stats to Service Stats
    public Stats getStats() {
        try {
            ManageTableDAO.Stats daoStats = tableDAO.getStats();
            return new Stats(daoStats.getTotal(), daoStats.getAvailable(), daoStats.getMaintenance());
        } catch (Exception e) {
            e.printStackTrace();
            return new Stats(0, 0, 0);
        }
    }
    
    public String getNextTablePrefix() {
        try {
            return tableDAO.getNextTablePrefix();
        } catch (Exception e) {
            e.printStackTrace();
            return "T-00001";
        }
    }
    
    public boolean tableNumberExists(String tableNo) {
        try {
            return tableDAO.findByTableNo(tableNo) != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private void populateLocationName(ManageTable table) {
        try {
            if (table == null) return;
            
            TableLocation location = locationDAO.findById(table.getLocationId());
            if (location != null) {
                table.setLocationName(location.getName());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void populateLocationNames(List<ManageTable> tables) {
        for (ManageTable table : tables) {
            populateLocationName(table);
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
    
    public static class LocationStat {
        private int id;
        private String name;
        private int count;
        
        public LocationStat() {}
        
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