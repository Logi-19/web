package wepapp.dao;

import wepapp.model.Facility;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class FacilityDAO {
    
    // Singleton Pattern
    private static FacilityDAO instance;
    private Connection connection;
    
    private FacilityDAO() {
        this.connection = database.getConnection();
    }
    
    public static synchronized FacilityDAO getInstance() {
        if (instance == null) {
            instance = new FacilityDAO();
        }
        return instance;
    }
    
    // Factory Method Pattern - creates Facility from ResultSet
    private Facility createFacilityFromResultSet(ResultSet rs) throws SQLException {
        Facility facility = new Facility();
        facility.setId(rs.getInt("id"));
        facility.setName(rs.getString("name"));
        facility.setCreatedDate(rs.getDate("created_date").toLocalDate());
        
        Timestamp updatedTimestamp = rs.getTimestamp("updated_date");
        if (updatedTimestamp != null) {
            facility.setUpdatedDate(updatedTimestamp.toLocalDateTime());
        }
        
        return facility;
    }
    
    // Create (INSERT)
    public boolean save(Facility facility) {
        String sql = "INSERT INTO facilities (name, created_date, updated_date) VALUES (?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, facility.getName());
            stmt.setDate(2, Date.valueOf(facility.getCreatedDate()));
            stmt.setTimestamp(3, Timestamp.valueOf(facility.getUpdatedDate()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    facility.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Read All
    public List<Facility> findAll() {
        List<Facility> facilities = new ArrayList<>();
        String sql = "SELECT * FROM facilities ORDER BY created_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                facilities.add(createFacilityFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return facilities;
    }
    
    // Read by ID
    public Facility findById(int id) {
        String sql = "SELECT * FROM facilities WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createFacilityFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Name (exact match)
    public Facility findByName(String name) {
        String sql = "SELECT * FROM facilities WHERE name = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createFacilityFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Name (case-insensitive search)
    public List<Facility> searchByName(String keyword) {
        List<Facility> facilities = new ArrayList<>();
        String sql = "SELECT * FROM facilities WHERE LOWER(name) LIKE LOWER(?) ORDER BY name";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                facilities.add(createFacilityFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return facilities;
    }
    
    // Find by Created Date Range
    public List<Facility> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<Facility> facilities = new ArrayList<>();
        String sql = "SELECT * FROM facilities WHERE created_date BETWEEN ? AND ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                facilities.add(createFacilityFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return facilities;
    }
    
    // Find by Month and Year
    public List<Facility> findByMonthYear(int month, int year) {
        List<Facility> facilities = new ArrayList<>();
        String sql = "SELECT * FROM facilities WHERE MONTH(created_date) = ? AND YEAR(created_date) = ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                facilities.add(createFacilityFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return facilities;
    }
    
    // Find recently added facilities
    public List<Facility> findRecent(int limit) {
        List<Facility> facilities = new ArrayList<>();
        String sql = "SELECT * FROM facilities ORDER BY created_date DESC LIMIT ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                facilities.add(createFacilityFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return facilities;
    }
    
    // Update
    public boolean update(Facility facility) {
        String sql = "UPDATE facilities SET name = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, facility.getName());
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, facility.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete
    public boolean delete(int id) {
        String sql = "DELETE FROM facilities WHERE id = ?";
        
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
        String sql = "SELECT COUNT(*) FROM facilities";
        return executeCountQuery(sql);
    }
    
    public int countCreatedThisMonth() {
        String sql = "SELECT COUNT(*) FROM facilities WHERE MONTH(created_date) = MONTH(CURRENT_DATE) AND YEAR(created_date) = YEAR(CURRENT_DATE)";
        return executeCountQuery(sql);
    }
    
    public int countCreatedLastMonth() {
        String sql = "SELECT COUNT(*) FROM facilities WHERE created_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)";
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
    
    // Check if facility name exists
    public boolean exists(String name) {
        String sql = "SELECT COUNT(*) FROM facilities WHERE LOWER(name) = LOWER(?)";
        
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
    
    // Check if facility name exists excluding a specific ID
    public boolean existsExcludingId(String name, int id) {
        String sql = "SELECT COUNT(*) FROM facilities WHERE LOWER(name) = LOWER(?) AND id != ?";
        
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