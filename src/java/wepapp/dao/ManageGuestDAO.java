package wepapp.dao;

import wepapp.model.ManageGuest;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ManageGuestDAO {
    
    // Singleton Pattern
    private static ManageGuestDAO instance;
    private Connection connection;
    
    private ManageGuestDAO() {
        this.connection = database.getConnection();
    }
    
    public static synchronized ManageGuestDAO getInstance() {
        if (instance == null) {
            instance = new ManageGuestDAO();
        }
        return instance;
    }
    
    // Factory Method Pattern - creates ManageGuest from ResultSet
    private ManageGuest createGuestFromResultSet(ResultSet rs) throws SQLException {
        ManageGuest guest = new ManageGuest();
        guest.setId(rs.getInt("id"));
        guest.setRegNo(rs.getString("reg_no"));
        guest.setFullName(rs.getString("full_name"));
        guest.setUsername(rs.getString("username"));
        guest.setEmail(rs.getString("email"));
        guest.setPhone(rs.getString("phone"));
        guest.setAddress(rs.getString("address"));
        guest.setGender(rs.getString("gender"));
        guest.setPassword(rs.getString("password"));
        guest.setStatus(rs.getString("status"));
        
        Timestamp lastLoginTimestamp = rs.getTimestamp("last_login");
        if (lastLoginTimestamp != null) {
            guest.setLastLogin(lastLoginTimestamp.toLocalDateTime());
        }
        
        guest.setCreatedDate(rs.getDate("created_date").toLocalDate());
        
        Timestamp updatedTimestamp = rs.getTimestamp("updated_date");
        if (updatedTimestamp != null) {
            guest.setUpdatedDate(updatedTimestamp.toLocalDateTime());
        }
        
        return guest;
    }
    
    // Create (INSERT) - Uses database trigger to auto-generate reg_no
    public boolean save(ManageGuest guest) {
        // Insert without reg_no - the trigger will generate it automatically
        String sql = "INSERT INTO manage_guests (full_name, username, email, phone, address, gender, password, status, last_login, created_date, updated_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, guest.getFullName());
            stmt.setString(2, guest.getUsername());
            stmt.setString(3, guest.getEmail());
            stmt.setString(4, guest.getPhone());
            stmt.setString(5, guest.getAddress());
            stmt.setString(6, guest.getGender());
            stmt.setString(7, guest.getPassword()); // Already hashed
            stmt.setString(8, guest.getStatus());
            
            if (guest.getLastLogin() != null) {
                stmt.setTimestamp(9, Timestamp.valueOf(guest.getLastLogin()));
            } else {
                stmt.setNull(9, Types.TIMESTAMP);
            }
            
            stmt.setDate(10, Date.valueOf(guest.getCreatedDate()));
            stmt.setTimestamp(11, Timestamp.valueOf(guest.getUpdatedDate()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    int generatedId = rs.getInt(1);
                    guest.setId(generatedId);
                    
                    // Fetch the complete saved guest to get the generated reg_no
                    ManageGuest savedGuest = findById(generatedId);
                    if (savedGuest != null) {
                        guest.setRegNo(savedGuest.getRegNo());
                        System.out.println("Guest saved successfully with ID: " + generatedId + 
                                         ", Reg No: " + savedGuest.getRegNo());
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Error: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
        }
        return false;
    }
    
    // Read All
    public List<ManageGuest> findAll() {
        List<ManageGuest> guests = new ArrayList<>();
        String sql = "SELECT * FROM manage_guests ORDER BY created_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                guests.add(createGuestFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return guests;
    }
    
    // Read by ID
    public ManageGuest findById(int id) {
        String sql = "SELECT * FROM manage_guests WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createGuestFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Registration Number
    public ManageGuest findByRegNo(String regNo) {
        String sql = "SELECT * FROM manage_guests WHERE reg_no = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, regNo);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createGuestFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Username
    public ManageGuest findByUsername(String username) {
        String sql = "SELECT * FROM manage_guests WHERE username = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createGuestFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Email
    public ManageGuest findByEmail(String email) {
        String sql = "SELECT * FROM manage_guests WHERE email = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createGuestFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Status (active/inactive)
    public List<ManageGuest> findByStatus(String status) {
        List<ManageGuest> guests = new ArrayList<>();
        String sql = "SELECT * FROM manage_guests WHERE status = ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                guests.add(createGuestFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return guests;
    }
    
    // Find by Gender
    public List<ManageGuest> findByGender(String gender) {
        List<ManageGuest> guests = new ArrayList<>();
        String sql = "SELECT * FROM manage_guests WHERE gender = ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, gender);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                guests.add(createGuestFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return guests;
    }
    
    // Search by keyword (full_name, username, email, phone, address)
    public List<ManageGuest> search(String keyword) {
        List<ManageGuest> guests = new ArrayList<>();
        String sql = "SELECT * FROM manage_guests WHERE LOWER(full_name) LIKE LOWER(?) OR LOWER(username) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?) OR phone LIKE ? OR LOWER(address) LIKE LOWER(?) ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            stmt.setString(5, searchPattern);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                guests.add(createGuestFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return guests;
    }
    
    // Find by Created Date Range
    public List<ManageGuest> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<ManageGuest> guests = new ArrayList<>();
        String sql = "SELECT * FROM manage_guests WHERE created_date BETWEEN ? AND ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                guests.add(createGuestFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return guests;
    }
    
    // Find by Month and Year
    public List<ManageGuest> findByMonthYear(int month, int year) {
        List<ManageGuest> guests = new ArrayList<>();
        String sql = "SELECT * FROM manage_guests WHERE MONTH(created_date) = ? AND YEAR(created_date) = ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                guests.add(createGuestFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return guests;
    }
    
    // Find recently added guests
    public List<ManageGuest> findRecent(int limit) {
        List<ManageGuest> guests = new ArrayList<>();
        String sql = "SELECT * FROM manage_guests ORDER BY created_date DESC LIMIT ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                guests.add(createGuestFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return guests;
    }
    
    // Find guests who haven't logged in recently
    public List<ManageGuest> findInactiveSince(LocalDateTime date) {
        List<ManageGuest> guests = new ArrayList<>();
        String sql = "SELECT * FROM manage_guests WHERE last_login IS NULL OR last_login < ? ORDER BY last_login";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(date));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                guests.add(createGuestFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return guests;
    }
    
    // Update full guest details (excluding password)
    public boolean update(ManageGuest guest) {
        String sql = "UPDATE manage_guests SET full_name = ?, username = ?, email = ?, phone = ?, address = ?, gender = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, guest.getFullName());
            stmt.setString(2, guest.getUsername());
            stmt.setString(3, guest.getEmail());
            stmt.setString(4, guest.getPhone());
            stmt.setString(5, guest.getAddress());
            stmt.setString(6, guest.getGender());
            stmt.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(8, guest.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update guest status only
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE manage_guests SET status = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update last login
    public boolean updateLastLogin(int id, LocalDateTime lastLogin) {
        String sql = "UPDATE manage_guests SET last_login = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(lastLogin));
            stmt.setInt(2, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update password only (with hashed password)
    public boolean updatePassword(int id, String hashedPassword) {
        String sql = "UPDATE manage_guests SET password = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, hashedPassword);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete
    public boolean delete(int id) {
        String sql = "DELETE FROM manage_guests WHERE id = ?";
        
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
        String sql = "SELECT COUNT(*) FROM manage_guests";
        return executeCountQuery(sql);
    }
    
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM manage_guests WHERE status = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int countActive() {
        return countByStatus("active");
    }
    
    public int countInactive() {
        return countByStatus("inactive");
    }
    
    public int countByGender(String gender) {
        String sql = "SELECT COUNT(*) FROM manage_guests WHERE gender = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, gender);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int countCreatedThisMonth() {
        String sql = "SELECT COUNT(*) FROM manage_guests WHERE MONTH(created_date) = MONTH(CURRENT_DATE) AND YEAR(created_date) = YEAR(CURRENT_DATE)";
        return executeCountQuery(sql);
    }
    
    public int countCreatedLastMonth() {
        String sql = "SELECT COUNT(*) FROM manage_guests WHERE created_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)";
        return executeCountQuery(sql);
    }
    
    public int countCreatedThisYear() {
        String sql = "SELECT COUNT(*) FROM manage_guests WHERE YEAR(created_date) = YEAR(CURRENT_DATE)";
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
    
    // Check existence methods
    public boolean exists(String username, String email) {
        String sql = "SELECT COUNT(*) FROM manage_guests WHERE username = ? OR email = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM manage_guests WHERE username = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM manage_guests WHERE email = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean usernameExistsExcludingId(String username, int id) {
        String sql = "SELECT COUNT(*) FROM manage_guests WHERE LOWER(username) = LOWER(?) AND id != ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
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
    
    public boolean emailExistsExcludingId(String email, int id) {
        String sql = "SELECT COUNT(*) FROM manage_guests WHERE LOWER(email) = LOWER(?) AND id != ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
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
    
    // Authenticate guest using BCrypt
    public ManageGuest authenticate(String username, String password) {
        String sql = "SELECT * FROM manage_guests WHERE (username = ? OR email = ?) AND status = 'active'";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                ManageGuest guest = createGuestFromResultSet(rs);
                // Verify password using BCrypt
                if (guest.checkPassword(password)) {
                    return guest;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}