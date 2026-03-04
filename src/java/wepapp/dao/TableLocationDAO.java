package wepapp.dao;

import wepapp.model.TableLocation;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class TableLocationDAO {
    
    // Singleton Pattern
    private static TableLocationDAO instance;
    private Connection connection;
    
    private TableLocationDAO() {
        this.connection = database.getConnection();
    }
    
    public static synchronized TableLocationDAO getInstance() {
        if (instance == null) {
            instance = new TableLocationDAO();
        }
        return instance;
    }
    
    // Factory Method Pattern - creates TableLocation from ResultSet
    private TableLocation createLocationFromResultSet(ResultSet rs) throws SQLException {
        TableLocation location = new TableLocation();
        location.setId(rs.getInt("id"));
        location.setName(rs.getString("name"));
        location.setCreatedDate(rs.getDate("created_date").toLocalDate());
        
        Timestamp updatedTimestamp = rs.getTimestamp("updated_date");
        if (updatedTimestamp != null) {
            location.setUpdatedDate(updatedTimestamp.toLocalDateTime());
        }
        
        return location;
    }
    
    // Create (INSERT)
    public boolean save(TableLocation location) {
        String sql = "INSERT INTO table_locations (name, created_date, updated_date) VALUES (?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, location.getName());
            stmt.setDate(2, Date.valueOf(location.getCreatedDate()));
            stmt.setTimestamp(3, Timestamp.valueOf(location.getUpdatedDate()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    location.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Read All
    public List<TableLocation> findAll() {
        List<TableLocation> locations = new ArrayList<>();
        String sql = "SELECT * FROM table_locations ORDER BY created_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                locations.add(createLocationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return locations;
    }
    
    // Read by ID
    public TableLocation findById(int id) {
        String sql = "SELECT * FROM table_locations WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createLocationFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Name (exact match)
    public TableLocation findByName(String name) {
        String sql = "SELECT * FROM table_locations WHERE name = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createLocationFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Name (case-insensitive search)
    public List<TableLocation> searchByName(String keyword) {
        List<TableLocation> locations = new ArrayList<>();
        String sql = "SELECT * FROM table_locations WHERE LOWER(name) LIKE LOWER(?) ORDER BY name";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                locations.add(createLocationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return locations;
    }
    
    // Find by Created Date Range
    public List<TableLocation> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<TableLocation> locations = new ArrayList<>();
        String sql = "SELECT * FROM table_locations WHERE created_date BETWEEN ? AND ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                locations.add(createLocationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return locations;
    }
    
    // Find by Month and Year
    public List<TableLocation> findByMonthYear(int month, int year) {
        List<TableLocation> locations = new ArrayList<>();
        String sql = "SELECT * FROM table_locations WHERE MONTH(created_date) = ? AND YEAR(created_date) = ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                locations.add(createLocationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return locations;
    }
    
    // Find recently added locations
    public List<TableLocation> findRecent(int limit) {
        List<TableLocation> locations = new ArrayList<>();
        String sql = "SELECT * FROM table_locations ORDER BY created_date DESC LIMIT ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                locations.add(createLocationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return locations;
    }
    
    // Update
    public boolean update(TableLocation location) {
        String sql = "UPDATE table_locations SET name = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, location.getName());
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, location.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete
    public boolean delete(int id) {
        String sql = "DELETE FROM table_locations WHERE id = ?";
        
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
        String sql = "SELECT COUNT(*) FROM table_locations";
        return executeCountQuery(sql);
    }
    
    public int countCreatedThisMonth() {
        String sql = "SELECT COUNT(*) FROM table_locations WHERE MONTH(created_date) = MONTH(CURRENT_DATE) AND YEAR(created_date) = YEAR(CURRENT_DATE)";
        return executeCountQuery(sql);
    }
    
    public int countCreatedLastMonth() {
        String sql = "SELECT COUNT(*) FROM table_locations WHERE created_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)";
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
    
    // Check if location name exists
    public boolean exists(String name) {
        String sql = "SELECT COUNT(*) FROM table_locations WHERE LOWER(name) = LOWER(?)";
        
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
    
    // Check if location name exists excluding a specific ID
    public boolean existsExcludingId(String name, int id) {
        String sql = "SELECT COUNT(*) FROM table_locations WHERE LOWER(name) = LOWER(?) AND id != ?";
        
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