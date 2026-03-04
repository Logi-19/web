package wepapp.dao;

import wepapp.model.Role;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO {
    
    // Singleton Pattern
    private static RoleDAO instance;
    private Connection connection;
    
    private RoleDAO() {
        this.connection = database.getConnection();
    }
    
    public static synchronized RoleDAO getInstance() {
        if (instance == null) {
            instance = new RoleDAO();
        }
        return instance;
    }
    
    // Factory Method Pattern - creates Role from ResultSet
    private Role createRoleFromResultSet(ResultSet rs) throws SQLException {
        Role role = new Role();
        role.setId(rs.getInt("id"));
        role.setName(rs.getString("name"));
        role.setCreatedDate(rs.getDate("created_date").toLocalDate());
        
        Timestamp updatedTimestamp = rs.getTimestamp("updated_date");
        if (updatedTimestamp != null) {
            role.setUpdatedDate(updatedTimestamp.toLocalDateTime());
        }
        
        return role;
    }
    
    // Create (INSERT)
    public boolean save(Role role) {
        String sql = "INSERT INTO roles (name, created_date, updated_date) VALUES (?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, role.getName());
            stmt.setDate(2, Date.valueOf(role.getCreatedDate()));
            stmt.setTimestamp(3, Timestamp.valueOf(role.getUpdatedDate()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    role.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Read All
    public List<Role> findAll() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM roles ORDER BY created_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                roles.add(createRoleFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }
    
    // Read by ID
    public Role findById(int id) {
        String sql = "SELECT * FROM roles WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createRoleFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Name (exact match)
    public Role findByName(String name) {
        String sql = "SELECT * FROM roles WHERE name = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createRoleFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Name (case-insensitive search)
    public List<Role> searchByName(String keyword) {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM roles WHERE LOWER(name) LIKE LOWER(?) ORDER BY name";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                roles.add(createRoleFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }
    
    // Find by Created Date Range
    public List<Role> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM roles WHERE created_date BETWEEN ? AND ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                roles.add(createRoleFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }
    
    // Find by Month and Year
    public List<Role> findByMonthYear(int month, int year) {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM roles WHERE MONTH(created_date) = ? AND YEAR(created_date) = ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                roles.add(createRoleFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }
    
    // Find recently added roles
    public List<Role> findRecent(int limit) {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM roles ORDER BY created_date DESC LIMIT ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                roles.add(createRoleFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }
    
    // Update
    public boolean update(Role role) {
        String sql = "UPDATE roles SET name = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, role.getName());
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, role.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete
    public boolean delete(int id) {
        String sql = "DELETE FROM roles WHERE id = ?";
        
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
        String sql = "SELECT COUNT(*) FROM roles";
        return executeCountQuery(sql);
    }
    
    public int countCreatedThisMonth() {
        String sql = "SELECT COUNT(*) FROM roles WHERE MONTH(created_date) = MONTH(CURRENT_DATE) AND YEAR(created_date) = YEAR(CURRENT_DATE)";
        return executeCountQuery(sql);
    }
    
    public int countCreatedLastMonth() {
        String sql = "SELECT COUNT(*) FROM roles WHERE created_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)";
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
    
    // Check if role name exists
    public boolean exists(String name) {
        String sql = "SELECT COUNT(*) FROM roles WHERE LOWER(name) = LOWER(?)";
        
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
    
    // Check if role name exists excluding a specific ID
    public boolean existsExcludingId(String name, int id) {
        String sql = "SELECT COUNT(*) FROM roles WHERE LOWER(name) = LOWER(?) AND id != ?";
        
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