package wepapp.dao;

import wepapp.model.Contact;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {
    
    // Singleton Pattern
    private static ContactDAO instance;
    private Connection connection;
    
    private ContactDAO() {
        this.connection = database.getConnection();
    }
    
    public static synchronized ContactDAO getInstance() {
        if (instance == null) {
            instance = new ContactDAO();
        }
        return instance;
    }
    
    // Factory Method Pattern - creates Contact from ResultSet
    private Contact createContactFromResultSet(ResultSet rs) throws SQLException {
        Contact contact = new Contact();
        contact.setId(rs.getInt("id"));
        contact.setName(rs.getString("name"));
        contact.setEmail(rs.getString("email"));
        contact.setPhone(rs.getString("phone"));
        contact.setMessage(rs.getString("message"));
        contact.setReplyMethod(rs.getString("reply_method"));
        contact.setStatus(rs.getBoolean("status"));
        contact.setReply(rs.getBoolean("reply"));
        contact.setSentDate(rs.getDate("sent_date").toLocalDate());
        return contact;
    }
    
    // Create (INSERT)
    public boolean save(Contact contact) {
        String sql = "INSERT INTO contacts (name, email, phone, message, reply_method, status, reply, sent_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, contact.getName());
            stmt.setString(2, contact.getEmail());
            stmt.setString(3, contact.getPhone());
            stmt.setString(4, contact.getMessage());
            stmt.setString(5, contact.getReplyMethod());
            stmt.setBoolean(6, contact.isStatus());
            stmt.setBoolean(7, contact.isReply());
            stmt.setDate(8, Date.valueOf(contact.getSentDate()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    contact.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Read All
    public List<Contact> findAll() {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts ORDER BY sent_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                contacts.add(createContactFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contacts;
    }
    
    // Read by ID
    public Contact findById(int id) {
        String sql = "SELECT * FROM contacts WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createContactFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Status (read/unread)
    public List<Contact> findByStatus(boolean status) {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts WHERE status = ? ORDER BY sent_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                contacts.add(createContactFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contacts;
    }
    
    // Find by Reply Status
    public List<Contact> findByReplyStatus(boolean replied) {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts WHERE reply = ? ORDER BY sent_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, replied);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                contacts.add(createContactFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contacts;
    }
    
    // Find by Reply Method
    public List<Contact> findByReplyMethod(String method) {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts WHERE reply_method = ? ORDER BY sent_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, method);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                contacts.add(createContactFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contacts;
    }
    
    // Find by Date Range
    public List<Contact> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts WHERE sent_date BETWEEN ? AND ? ORDER BY sent_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                contacts.add(createContactFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contacts;
    }
    
    // Find by Month and Year
    public List<Contact> findByMonthYear(int month, int year) {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts WHERE MONTH(sent_date) = ? AND YEAR(sent_date) = ? ORDER BY sent_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                contacts.add(createContactFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contacts;
    }
    
    // Search by keyword
    public List<Contact> search(String keyword) {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts WHERE name LIKE ? OR email LIKE ? OR message LIKE ? OR phone LIKE ? ORDER BY sent_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                contacts.add(createContactFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contacts;
    }
    
    // Update
    public boolean update(Contact contact) {
        String sql = "UPDATE contacts SET name=?, email=?, phone=?, message=?, reply_method=?, status=?, reply=? WHERE id=?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, contact.getName());
            stmt.setString(2, contact.getEmail());
            stmt.setString(3, contact.getPhone());
            stmt.setString(4, contact.getMessage());
            stmt.setString(5, contact.getReplyMethod());
            stmt.setBoolean(6, contact.isStatus());
            stmt.setBoolean(7, contact.isReply());
            stmt.setInt(8, contact.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update Status (read/unread)
    public boolean updateStatus(int id, boolean status) {
        String sql = "UPDATE contacts SET status = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, status);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update Reply Status
    public boolean updateReplyStatus(int id, boolean replied) {
        String sql = "UPDATE contacts SET reply = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, replied);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete
    public boolean delete(int id) {
        String sql = "DELETE FROM contacts WHERE id = ?";
        
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
        String sql = "SELECT COUNT(*) FROM contacts";
        return executeCountQuery(sql);
    }
    
    public int countUnread() {
        String sql = "SELECT COUNT(*) FROM contacts WHERE status = false";
        return executeCountQuery(sql);
    }
    
    public int countRead() {
        String sql = "SELECT COUNT(*) FROM contacts WHERE status = true";
        return executeCountQuery(sql);
    }
    
    public int countReplied() {
        String sql = "SELECT COUNT(*) FROM contacts WHERE reply = true";
        return executeCountQuery(sql);
    }
    
    public int countNotReplied() {
        String sql = "SELECT COUNT(*) FROM contacts WHERE reply = false";
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
}