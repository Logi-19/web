package wepapp.service;

import wepapp.dao.ManageServiceDAO;
import wepapp.dao.ServiceCategoryDAO;
import wepapp.model.ManageService;
import wepapp.model.ServiceCategory;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

public class ManageServiceService {
    private final ManageServiceDAO serviceDAO;
    private final ServiceCategoryDAO categoryDAO;
    
    public ManageServiceService() {
        this.serviceDAO = ManageServiceDAO.getInstance();
        this.categoryDAO = ServiceCategoryDAO.getInstance();
    }
    
    public ValidationResult createService(ManageService service) {
        try {
            if (service.getTitle() == null || service.getTitle().trim().isEmpty()) {
                return new ValidationResult(false, "Service title is required");
            }
            
            if (service.getDescription() == null || service.getDescription().trim().isEmpty()) {
                return new ValidationResult(false, "Description is required");
            }
            
            if (service.getCategoryId() <= 0) {
                return new ValidationResult(false, "Service category is required");
            }
            
            if (service.getDuration() < 0) {
                return new ValidationResult(false, "Duration cannot be negative");
            }
            
            if (service.getFees() < 0) {
                return new ValidationResult(false, "Fees cannot be negative");
            }
            
            // Check if category exists
            ServiceCategory category = categoryDAO.findById(service.getCategoryId());
            if (category == null) {
                return new ValidationResult(false, "Selected category does not exist");
            }
            
            // Check for duplicate title
            ManageService existing = serviceDAO.findByTitle(service.getTitle());
            if (existing != null) {
                return new ValidationResult(false, "Service title already exists");
            }
            
            service.setCreatedDate(LocalDate.now());
            service.setUpdatedDate(LocalDateTime.now());
            
            boolean saved = serviceDAO.save(service);
            
            if (saved) {
                return new ValidationResult(true, "Service created successfully!");
            } else {
                return new ValidationResult(false, "Failed to create service. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ValidationResult(false, "Error: " + e.getMessage());
        }
    }
    
    public ValidationResult updateService(ManageService service) {
        try {
            if (service.getTitle() == null || service.getTitle().trim().isEmpty()) {
                return new ValidationResult(false, "Service title is required");
            }
            
            if (service.getDescription() == null || service.getDescription().trim().isEmpty()) {
                return new ValidationResult(false, "Description is required");
            }
            
            if (service.getCategoryId() <= 0) {
                return new ValidationResult(false, "Service category is required");
            }
            
            if (service.getDuration() < 0) {
                return new ValidationResult(false, "Duration cannot be negative");
            }
            
            if (service.getFees() < 0) {
                return new ValidationResult(false, "Fees cannot be negative");
            }
            
            // Check if category exists
            ServiceCategory category = categoryDAO.findById(service.getCategoryId());
            if (category == null) {
                return new ValidationResult(false, "Selected category does not exist");
            }
            
            // Check for duplicate title excluding current service
            if (serviceDAO.titleExistsExcludingId(service.getTitle(), service.getId())) {
                return new ValidationResult(false, "Service title already exists");
            }
            
            service.setUpdatedDate(LocalDateTime.now());
            
            boolean updated = serviceDAO.update(service);
            
            if (updated) {
                return new ValidationResult(true, "Service updated successfully!");
            } else {
                return new ValidationResult(false, "Failed to update service. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ValidationResult(false, "Error: " + e.getMessage());
        }
    }
    
    public List<ManageService> getAllServices() {
        try {
            List<ManageService> services = serviceDAO.findAll();
            populateCategoryNames(services);
            return services;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public ManageService getServiceById(int id) {
        try {
            ManageService service = serviceDAO.findById(id);
            if (service != null) {
                populateCategoryName(service);
            }
            return service;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public List<ManageService> getAvailableServices() {
        try {
            List<ManageService> services = serviceDAO.findByStatus("available");
            populateCategoryNames(services);
            return services;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<ManageService> getUnavailableServices() {
        try {
            List<ManageService> services = serviceDAO.findByStatus("unavailable");
            populateCategoryNames(services);
            return services;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<ManageService> getServicesByCategory(int categoryId) {
        try {
            List<ManageService> services = serviceDAO.findByCategoryId(categoryId);
            populateCategoryNames(services);
            return services;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<ManageService> searchServices(String keyword) {
        try {
            List<ManageService> services = serviceDAO.search(keyword);
            populateCategoryNames(services);
            return services;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<ManageService> advancedSearch(String keyword, Integer categoryId, String status, 
                                              Integer minDuration, Integer maxDuration,
                                              Double minFees, Double maxFees) {
        try {
            List<ManageService> services = serviceDAO.advancedSearch(
                keyword, categoryId, status, minDuration, maxDuration, minFees, maxFees
            );
            populateCategoryNames(services);
            return services;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public boolean updateServiceStatus(int id, String status) {
        try {
            return serviceDAO.updateStatus(id, status);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteService(int id) {
        try {
            return serviceDAO.delete(id);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<CategoryStat> getCategoryStatistics() {
        try {
            List<ManageServiceDAO.CategoryStat> stats = serviceDAO.getCategoryStatistics();
            List<CategoryStat> result = new ArrayList<>();
            for (ManageServiceDAO.CategoryStat stat : stats) {
                CategoryStat categoryStat = new CategoryStat();
                categoryStat.setId(stat.getId());
                categoryStat.setName(stat.getName());
                categoryStat.setCount(stat.getServiceCount());
                result.add(categoryStat);
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public Stats getStats() {
        try {
            ManageServiceDAO.Stats daoStats = serviceDAO.getStats();
            Stats stats = new Stats();
            stats.setTotal(daoStats.getTotal());
            stats.setAvailable(daoStats.getAvailable());
            stats.setUnavailable(daoStats.getUnavailable());
            return stats;
        } catch (Exception e) {
            e.printStackTrace();
            return new Stats(0, 0, 0);
        }
    }
    
    public boolean serviceTitleExists(String title) {
        try {
            return serviceDAO.findByTitle(title) != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private void populateCategoryName(ManageService service) {
        try {
            if (service == null) {
                return;
            }
            
            ServiceCategory category = categoryDAO.findById(service.getCategoryId());
            if (category != null) {
                service.setCategoryName(category.getName());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void populateCategoryNames(List<ManageService> services) {
        for (ManageService service : services) {
            populateCategoryName(service);
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
    
    public static class CategoryStat {
        private int id;
        private String name;
        private int count;
        
        public CategoryStat() {}
        
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
        private int unavailable;
        
        public Stats() {}
        
        public Stats(int total, int available, int unavailable) {
            this.total = total;
            this.available = available;
            this.unavailable = unavailable;
        }
        
        public int getTotal() { return total; }
        public void setTotal(int total) { this.total = total; }
        public int getAvailable() { return available; }
        public void setAvailable(int available) { this.available = available; }
        public int getUnavailable() { return unavailable; }
        public void setUnavailable(int unavailable) { this.unavailable = unavailable; }
    }
}