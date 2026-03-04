package wepapp.dao;

import wepapp.model.ServiceCategory;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ServiceCategoryDAO {
    
    // Singleton Pattern
    private static ServiceCategoryDAO instance;
    private Connection connection;
    
    private ServiceCategoryDAO() {
        this.connection = database.getConnection();
    }
    
    public static synchronized ServiceCategoryDAO getInstance() {
        if (instance == null) {
            instance = new ServiceCategoryDAO();
        }
        return instance;
    }
    
    // Factory Method Pattern - creates ServiceCategory from ResultSet
    private ServiceCategory createCategoryFromResultSet(ResultSet rs) throws SQLException {
        ServiceCategory category = new ServiceCategory();
        category.setId(rs.getInt("id"));
        category.setName(rs.getString("name"));
        category.setCreatedDate(rs.getDate("created_date").toLocalDate());
        
        Timestamp updatedTimestamp = rs.getTimestamp("updated_date");
        if (updatedTimestamp != null) {
            category.setUpdatedDate(updatedTimestamp.toLocalDateTime());
        }
        
        return category;
    }
    
    // Create (INSERT)
    public boolean save(ServiceCategory category) {
        String sql = "INSERT INTO service_categories (name, created_date, updated_date) VALUES (?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, category.getName());
            stmt.setDate(2, Date.valueOf(category.getCreatedDate()));
            stmt.setTimestamp(3, Timestamp.valueOf(category.getUpdatedDate()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    category.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Read All
    public List<ServiceCategory> findAll() {
        List<ServiceCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM service_categories ORDER BY created_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categories.add(createCategoryFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    // Read by ID
    public ServiceCategory findById(int id) {
        String sql = "SELECT * FROM service_categories WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createCategoryFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Name (exact match)
    public ServiceCategory findByName(String name) {
        String sql = "SELECT * FROM service_categories WHERE name = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createCategoryFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Name (case-insensitive search)
    public List<ServiceCategory> searchByName(String keyword) {
        List<ServiceCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM service_categories WHERE LOWER(name) LIKE LOWER(?) ORDER BY name";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                categories.add(createCategoryFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    // Find by Created Date Range
    public List<ServiceCategory> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<ServiceCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM service_categories WHERE created_date BETWEEN ? AND ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                categories.add(createCategoryFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    // Find by Month and Year
    public List<ServiceCategory> findByMonthYear(int month, int year) {
        List<ServiceCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM service_categories WHERE MONTH(created_date) = ? AND YEAR(created_date) = ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                categories.add(createCategoryFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    // Find recently added categories
    public List<ServiceCategory> findRecent(int limit) {
        List<ServiceCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM service_categories ORDER BY created_date DESC LIMIT ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                categories.add(createCategoryFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    // Update
    public boolean update(ServiceCategory category) {
        String sql = "UPDATE service_categories SET name = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, category.getName());
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, category.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete
    public boolean delete(int id) {
        String sql = "DELETE FROM service_categories WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Count methods
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM service_categories";
        return executeCountQuery(sql);
    }
    
    public int countCreatedThisMonth() {
        String sql = "SELECT COUNT(*) FROM service_categories WHERE MONTH(created_date) = MONTH(CURRENT_DATE) AND YEAR(created_date) = YEAR(CURRENT_DATE)";
        return executeCountQuery(sql);
    }
    
    public int countCreatedLastMonth() {
        String sql = "SELECT COUNT(*) FROM service_categories WHERE created_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)";
        return executeCountQuery(sql);
    }
    
    private int executeCountQuery(String sql) {
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Check if category name exists
    public boolean exists(String name) {
        String sql = "SELECT COUNT(*) FROM service_categories WHERE LOWER(name) = LOWER(?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Check if category name exists excluding a specific ID
    public boolean existsExcludingId(String name, int id) {
        String sql = "SELECT COUNT(*) FROM service_categories WHERE LOWER(name) = LOWER(?) AND id != ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.setInt(2, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}