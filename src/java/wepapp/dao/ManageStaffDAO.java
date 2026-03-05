package wepapp.dao;

import wepapp.model.ManageStaff;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ManageStaffDAO {
    
    // Singleton Pattern
    private static ManageStaffDAO instance;
    private Connection connection;
    
    private ManageStaffDAO() {
        this.connection = database.getConnection();
    }
    
    public static synchronized ManageStaffDAO getInstance() {
        if (instance == null) {
            instance = new ManageStaffDAO();
        }
        return instance;
    }
    
    // Factory Method Pattern - creates ManageStaff from ResultSet
    private ManageStaff createManageStaffFromResultSet(ResultSet rs) throws SQLException {
        ManageStaff staff = new ManageStaff();
        staff.setId(rs.getInt("id"));
        staff.setRegNo(rs.getString("reg_no"));
        staff.setFullname(rs.getString("fullname"));
        staff.setUsername(rs.getString("username"));
        staff.setEmail(rs.getString("email"));
        staff.setPhone(rs.getString("phone"));
        staff.setGender(rs.getString("gender"));
        staff.setAddress(rs.getString("address"));
        staff.setPassword(rs.getString("password")); // This is the hashed password
        staff.setRoleId(rs.getInt("role_id"));
        staff.setStatus(rs.getString("status"));
        staff.setJoinedDate(rs.getDate("joined_date").toLocalDate());
        
        Timestamp lastLoginTimestamp = rs.getTimestamp("last_login");
        if (lastLoginTimestamp != null) {
            staff.setLastLogin(lastLoginTimestamp.toLocalDateTime());
        }
        
        Timestamp updatedTimestamp = rs.getTimestamp("updated_date");
        if (updatedTimestamp != null) {
            staff.setUpdatedDate(updatedTimestamp.toLocalDateTime());
        }
        
        return staff;
    }
    
    // Create (INSERT) - Stores hashed password
    public boolean save(ManageStaff staff) {
        String sql = "INSERT INTO manage_staff (reg_no, fullname, username, email, phone, gender, address, password, role_id, status, joined_date, last_login, updated_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, staff.getRegNo());
            stmt.setString(2, staff.getFullname());
            stmt.setString(3, staff.getUsername());
            stmt.setString(4, staff.getEmail());
            stmt.setString(5, staff.getPhone());
            stmt.setString(6, staff.getGender());
            stmt.setString(7, staff.getAddress());
            stmt.setString(8, staff.getPassword()); // Store hashed password
            stmt.setInt(9, staff.getRoleId());
            stmt.setString(10, staff.getStatus());
            stmt.setDate(11, Date.valueOf(staff.getJoinedDate()));
            stmt.setTimestamp(12, staff.getLastLogin() != null ? Timestamp.valueOf(staff.getLastLogin()) : null);
            stmt.setTimestamp(13, Timestamp.valueOf(staff.getUpdatedDate()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    staff.setId(rs.getInt(1));
                    // Update regNo with the generated ID
                    staff.setRegNo(ManageStaff.generateRegNo(staff.getId()));
                    // Update the record with the correct regNo
                    updateRegNo(staff);
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update registration number after ID is generated
    private boolean updateRegNo(ManageStaff staff) {
        String sql = "UPDATE manage_staff SET reg_no = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, staff.getRegNo());
            stmt.setInt(2, staff.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Read All
    public List<ManageStaff> findAll() {
        List<ManageStaff> staffList = new ArrayList<>();
        String sql = "SELECT * FROM manage_staff ORDER BY joined_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                staffList.add(createManageStaffFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }
    
    // Read by ID
    public ManageStaff findById(int id) {
        String sql = "SELECT * FROM manage_staff WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createManageStaffFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Registration Number
    public ManageStaff findByRegNo(String regNo) {
        String sql = "SELECT * FROM manage_staff WHERE reg_no = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, regNo);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createManageStaffFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Username
    public ManageStaff findByUsername(String username) {
        String sql = "SELECT * FROM manage_staff WHERE username = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createManageStaffFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Email
    public ManageStaff findByEmail(String email) {
        String sql = "SELECT * FROM manage_staff WHERE email = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createManageStaffFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Role ID
    public List<ManageStaff> findByRoleId(int roleId) {
        List<ManageStaff> staffList = new ArrayList<>();
        String sql = "SELECT * FROM manage_staff WHERE role_id = ? ORDER BY joined_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, roleId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                staffList.add(createManageStaffFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }
    
    // Find by Status (active/inactive)
    public List<ManageStaff> findByStatus(String status) {
        List<ManageStaff> staffList = new ArrayList<>();
        String sql = "SELECT * FROM manage_staff WHERE status = ? ORDER BY joined_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                staffList.add(createManageStaffFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }
    
    // Search by name, username, email, or regNo
    public List<ManageStaff> search(String keyword) {
        List<ManageStaff> staffList = new ArrayList<>();
        String sql = "SELECT * FROM manage_staff WHERE LOWER(fullname) LIKE LOWER(?) OR LOWER(username) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?) OR LOWER(reg_no) LIKE LOWER(?) ORDER BY joined_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                staffList.add(createManageStaffFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }
    
    // Find by Joined Date Range
    public List<ManageStaff> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<ManageStaff> staffList = new ArrayList<>();
        String sql = "SELECT * FROM manage_staff WHERE joined_date BETWEEN ? AND ? ORDER BY joined_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                staffList.add(createManageStaffFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }
    
    // Find by Month and Year
    public List<ManageStaff> findByMonthYear(int month, int year) {
        List<ManageStaff> staffList = new ArrayList<>();
        String sql = "SELECT * FROM manage_staff WHERE MONTH(joined_date) = ? AND YEAR(joined_date) = ? ORDER BY joined_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                staffList.add(createManageStaffFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }
    
    // Find recently joined staff
    public List<ManageStaff> findRecent(int limit) {
        List<ManageStaff> staffList = new ArrayList<>();
        String sql = "SELECT * FROM manage_staff ORDER BY joined_date DESC LIMIT ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                staffList.add(createManageStaffFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }
    
    // Update all staff details (except regNo, password, status, role)
    public boolean update(ManageStaff staff) {
        String sql = "UPDATE manage_staff SET fullname = ?, username = ?, email = ?, phone = ?, gender = ?, address = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, staff.getFullname());
            stmt.setString(2, staff.getUsername());
            stmt.setString(3, staff.getEmail());
            stmt.setString(4, staff.getPhone());
            stmt.setString(5, staff.getGender());
            stmt.setString(6, staff.getAddress());
            stmt.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(8, staff.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update password only - stores hashed password
    public boolean updatePassword(int id, String hashedPassword) {
        String sql = "UPDATE manage_staff SET password = ?, updated_date = ? WHERE id = ?";
        
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
    
    // Update status only
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE manage_staff SET status = ?, updated_date = ? WHERE id = ?";
        
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
    
    // Update role only
    public boolean updateRole(int id, int roleId) {
        String sql = "UPDATE manage_staff SET role_id = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, roleId);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update last login
    public boolean updateLastLogin(int id) {
        String sql = "UPDATE manage_staff SET last_login = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(2, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete
    public boolean delete(int id) {
        String sql = "DELETE FROM manage_staff WHERE id = ?";
        
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
        String sql = "SELECT COUNT(*) FROM manage_staff";
        return executeCountQuery(sql);
    }
    
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM manage_staff WHERE status = '" + status + "'";
        return executeCountQuery(sql);
    }
    
    public int countByRoleId(int roleId) {
        String sql = "SELECT COUNT(*) FROM manage_staff WHERE role_id = " + roleId;
        return executeCountQuery(sql);
    }
    
    public int countJoinedThisMonth() {
        String sql = "SELECT COUNT(*) FROM manage_staff WHERE MONTH(joined_date) = MONTH(CURRENT_DATE) AND YEAR(joined_date) = YEAR(CURRENT_DATE)";
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
    
    // Check if username exists
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM manage_staff WHERE LOWER(username) = LOWER(?)";
        
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
    
    // Check if username exists excluding a specific ID
    public boolean usernameExistsExcludingId(String username, int id) {
        String sql = "SELECT COUNT(*) FROM manage_staff WHERE LOWER(username) = LOWER(?) AND id != ?";
        
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
    
    // Check if email exists
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM manage_staff WHERE LOWER(email) = LOWER(?)";
        
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
    
    // Check if email exists excluding a specific ID
    public boolean emailExistsExcludingId(String email, int id) {
        String sql = "SELECT COUNT(*) FROM manage_staff WHERE LOWER(email) = LOWER(?) AND id != ?";
        
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
    
    // Check if phone exists
    public boolean phoneExists(String phone) {
        String sql = "SELECT COUNT(*) FROM manage_staff WHERE phone = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, phone);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Check if phone exists excluding a specific ID
    public boolean phoneExistsExcludingId(String phone, int id) {
        String sql = "SELECT COUNT(*) FROM manage_staff WHERE phone = ? AND id != ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, phone);
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
    
    // Get password hash for a staff member
    public String getPasswordHash(int id) {
        String sql = "SELECT password FROM manage_staff WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("password");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}