package wepapp.dao;

import wepapp.model.RoomType;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeDAO {
    
    private static RoomTypeDAO instance;
    private Connection connection;
    
    private RoomTypeDAO() {
        try {
            this.connection = database.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static synchronized RoomTypeDAO getInstance() {
        if (instance == null) {
            instance = new RoomTypeDAO();
        }
        return instance;
    }
    
    private RoomType createRoomTypeFromResultSet(ResultSet rs) throws SQLException {
        RoomType roomType = new RoomType();
        roomType.setId(rs.getInt("id"));
        roomType.setName(rs.getString("name"));
        
        Date createdDate = rs.getDate("created_date");
        if (createdDate != null) {
            roomType.setCreatedDate(createdDate.toLocalDate());
        }
        
        Timestamp updatedTimestamp = rs.getTimestamp("updated_date");
        if (updatedTimestamp != null) {
            roomType.setUpdatedDate(updatedTimestamp.toLocalDateTime());
        }
        
        return roomType;
    }
    
    public boolean save(RoomType roomType) {
        String sql = "INSERT INTO room_types (name, created_date, updated_date) VALUES (?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, roomType.getName());
            stmt.setDate(2, Date.valueOf(roomType.getCreatedDate() != null ? roomType.getCreatedDate() : LocalDate.now()));
            stmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    roomType.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<RoomType> findAll() {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "SELECT * FROM room_types ORDER BY created_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                roomTypes.add(createRoomTypeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roomTypes;
    }
    
    public RoomType findById(int id) {
        String sql = "SELECT * FROM room_types WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createRoomTypeFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public RoomType findByName(String name) {
        String sql = "SELECT * FROM room_types WHERE name = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createRoomTypeFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<RoomType> searchByName(String keyword) {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "SELECT * FROM room_types WHERE LOWER(name) LIKE LOWER(?) ORDER BY name";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                roomTypes.add(createRoomTypeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roomTypes;
    }
    
    // Find by Created Date Range
    public List<RoomType> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "SELECT * FROM room_types WHERE created_date BETWEEN ? AND ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                roomTypes.add(createRoomTypeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roomTypes;
    }
    
    // Find by Month and Year
    public List<RoomType> findByMonthYear(int month, int year) {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "SELECT * FROM room_types WHERE MONTH(created_date) = ? AND YEAR(created_date) = ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                roomTypes.add(createRoomTypeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roomTypes;
    }
    
    public boolean update(RoomType roomType) {
        String sql = "UPDATE room_types SET name = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, roomType.getName());
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, roomType.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int id) {
        String sql = "DELETE FROM room_types WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM room_types";
        
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
    
    // Count created this month - Using the existing findByMonthYear method
    public int countCreatedThisMonth() {
        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        int year = now.getYear();
        return findByMonthYear(month, year).size();
    }
    
    // Count created last month - Using the existing findByMonthYear method
    public int countCreatedLastMonth() {
        LocalDate now = LocalDate.now();
        LocalDate lastMonth = now.minusMonths(1);
        int month = lastMonth.getMonthValue();
        int year = lastMonth.getYear();
        return findByMonthYear(month, year).size();
    }
    
    public boolean exists(String name) {
        String sql = "SELECT COUNT(*) FROM room_types WHERE LOWER(name) = LOWER(?)";
        
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
    
    public boolean existsExcludingId(String name, int id) {
        String sql = "SELECT COUNT(*) FROM room_types WHERE LOWER(name) = LOWER(?) AND id != ?";
        
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
    
    public List<RoomType> findRecent(int limit) {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "SELECT * FROM room_types ORDER BY created_date DESC LIMIT ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                roomTypes.add(createRoomTypeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roomTypes;
    }
}