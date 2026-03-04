package wepapp.dao;

import wepapp.model.Feedback;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    
    // Singleton Pattern
    private static FeedbackDAO instance;
    private Connection connection;
    
    private FeedbackDAO() {
        this.connection = database.getConnection();
    }
    
    public static synchronized FeedbackDAO getInstance() {
        if (instance == null) {
            instance = new FeedbackDAO();
        }
        return instance;
    }
    
    // Factory Method Pattern - creates Feedback from ResultSet
    private Feedback createFeedbackFromResultSet(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setId(rs.getInt("id"));
        feedback.setName(rs.getString("name"));
        feedback.setEmail(rs.getString("email"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setMessage(rs.getString("message"));
        feedback.setStatus(rs.getBoolean("status")); // Now boolean
        feedback.setSubmittedDate(rs.getDate("submitted_date").toLocalDate());
        return feedback;
    }
    
    // Create (INSERT)
    public boolean save(Feedback feedback) {
        String sql = "INSERT INTO feedback (name, email, rating, message, status, submitted_date) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, feedback.getName());
            stmt.setString(2, feedback.getEmail());
            stmt.setInt(3, feedback.getRating());
            stmt.setString(4, feedback.getMessage());
            stmt.setBoolean(5, feedback.isStatus()); // Now boolean
            stmt.setDate(6, Date.valueOf(feedback.getSubmittedDate()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    feedback.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Read All
    public List<Feedback> findAll() {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM feedback ORDER BY submitted_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                feedbacks.add(createFeedbackFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
    
    // Read by ID
    public Feedback findById(int id) {
        String sql = "SELECT * FROM feedback WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createFeedbackFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Status (visible/hidden) - Now using boolean
    public List<Feedback> findByStatus(boolean status) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE status = ? ORDER BY submitted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                feedbacks.add(createFeedbackFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
    
    // Find visible feedback (convenience method)
    public List<Feedback> findVisible() {
        return findByStatus(true);
    }
    
    // Find hidden feedback (convenience method)
    public List<Feedback> findHidden() {
        return findByStatus(false);
    }
    
    // Find by Rating
    public List<Feedback> findByRating(int rating) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE rating = ? ORDER BY submitted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, rating);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                feedbacks.add(createFeedbackFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
    
    // Find by Minimum Rating (rating >= minRating)
    public List<Feedback> findByMinRating(int minRating) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE rating >= ? ORDER BY rating DESC, submitted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, minRating);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                feedbacks.add(createFeedbackFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
    
    // Find by Date Range
    public List<Feedback> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE submitted_date BETWEEN ? AND ? ORDER BY submitted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                feedbacks.add(createFeedbackFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
    
    // Find by Month and Year
    public List<Feedback> findByMonthYear(int month, int year) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE MONTH(submitted_date) = ? AND YEAR(submitted_date) = ? ORDER BY submitted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                feedbacks.add(createFeedbackFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
    
    // Search by keyword in name, email, or message
    public List<Feedback> search(String keyword) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE name LIKE ? OR email LIKE ? OR message LIKE ? ORDER BY submitted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                feedbacks.add(createFeedbackFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
    
    // Update
    public boolean update(Feedback feedback) {
        String sql = "UPDATE feedback SET name=?, email=?, rating=?, message=?, status=? WHERE id=?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, feedback.getName());
            stmt.setString(2, feedback.getEmail());
            stmt.setInt(3, feedback.getRating());
            stmt.setString(4, feedback.getMessage());
            stmt.setBoolean(5, feedback.isStatus()); // Now boolean
            stmt.setInt(6, feedback.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update Status (visible/hidden) - Now using boolean
    public boolean updateStatus(int id, boolean status) {
        String sql = "UPDATE feedback SET status = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, status);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Toggle Status
    public boolean toggleStatus(int id) {
        Feedback feedback = findById(id);
        if (feedback != null) {
            return updateStatus(id, !feedback.isStatus());
        }
        return false;
    }
    
    // Delete
    public boolean delete(int id) {
        String sql = "DELETE FROM feedback WHERE id = ?";
        
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
        String sql = "SELECT COUNT(*) FROM feedback";
        return executeCountQuery(sql);
    }
    
    public int countByStatus(boolean status) {
        String sql = "SELECT COUNT(*) FROM feedback WHERE status = " + (status ? "1" : "0");
        return executeCountQuery(sql);
    }
    
    public int countVisible() {
        return countByStatus(true);
    }
    
    public int countHidden() {
        return countByStatus(false);
    }
    
    public int countByRating(int rating) {
        String sql = "SELECT COUNT(*) FROM feedback WHERE rating = " + rating;
        return executeCountQuery(sql);
    }
    
    // Get average rating
    public double getAverageRating() {
        String sql = "SELECT AVG(rating) FROM feedback";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
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