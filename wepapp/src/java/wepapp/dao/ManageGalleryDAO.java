package wepapp.dao;

import wepapp.model.ManageGallery;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ManageGalleryDAO {
    
    // Singleton Pattern
    private static ManageGalleryDAO instance;
    private Connection connection;
    
    private ManageGalleryDAO() {
        try {
            this.connection = database.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static synchronized ManageGalleryDAO getInstance() {
        if (instance == null) {
            instance = new ManageGalleryDAO();
        }
        return instance;
    }
    
    // Factory Method Pattern - creates ManageGallery from ResultSet
    private ManageGallery createGalleryFromResultSet(ResultSet rs) throws SQLException {
        ManageGallery item = new ManageGallery();
        item.setId(rs.getInt("id"));
        item.setTitle(rs.getString("title"));
        item.setDescription(rs.getString("description"));
        item.setCategoryId(rs.getInt("category_id"));
        
        // Get images as JSON array and convert to List
        String imagesJson = rs.getString("images");
        if (imagesJson != null && !imagesJson.isEmpty() && !imagesJson.equals("[]") && !imagesJson.equals("null")) {
            List<String> images = new ArrayList<>();
            try {
                // Better JSON parsing using simple approach
                // Remove brackets: [url1,url2,url3]
                String content = imagesJson.trim();
                if (content.startsWith("[") && content.endsWith("]")) {
                    content = content.substring(1, content.length() - 1);
                    
                    if (!content.isEmpty()) {
                        // Split by comma but handle quoted strings properly
                        String[] items = content.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
                        for (String itemStr : items) {
                            String clean = itemStr.trim();
                            // Remove quotes if present
                            if (clean.startsWith("\"") && clean.endsWith("\"")) {
                                clean = clean.substring(1, clean.length() - 1);
                            }
                            if (!clean.isEmpty()) {
                                images.add(clean);
                            }
                        }
                    }
                }
            } catch (Exception e) {
                System.err.println("Error parsing images JSON: " + imagesJson);
                e.printStackTrace();
            }
            item.setImages(images);
        } else {
            item.setImages(new ArrayList<>());
        }
        
        item.setStatus(rs.getBoolean("status"));
        
        Timestamp postedTs = rs.getTimestamp("posted_date");
        if (postedTs != null) {
            item.setPostedDate(postedTs.toLocalDateTime());
        }
        
        Timestamp updatedTs = rs.getTimestamp("updated_date");
        if (updatedTs != null) {
            item.setUpdatedDate(updatedTs.toLocalDateTime());
        }
        
        return item;
    }
    
    // Create (INSERT)
    public boolean save(ManageGallery item) {
        String sql = "INSERT INTO manage_gallery (title, description, category_id, images, status, posted_date, updated_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, item.getTitle());
            stmt.setString(2, item.getDescription());
            stmt.setInt(3, item.getCategoryId());
            
            // Convert images List to JSON array string
            String imagesJson = convertImagesToJson(item.getImages());
            stmt.setString(4, imagesJson);
            
            stmt.setBoolean(5, item.isStatus());
            stmt.setTimestamp(6, Timestamp.valueOf(item.getPostedDate()));
            stmt.setTimestamp(7, Timestamp.valueOf(item.getUpdatedDate()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    item.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error saving gallery item: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Read All
    public List<ManageGallery> findAll() {
        List<ManageGallery> items = new ArrayList<>();
        String sql = "SELECT g.*, c.name as category_name FROM manage_gallery g " +
                     "LEFT JOIN blog_categories c ON g.category_id = c.id " +
                     "ORDER BY g.posted_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                ManageGallery item = createGalleryFromResultSet(rs);
                item.setCategoryName(rs.getString("category_name"));
                items.add(item);
            }
            System.out.println("DAO: Found " + items.size() + " gallery items");
        } catch (SQLException e) {
            System.err.println("Error in findAll: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }
    
    // Read by ID
    public ManageGallery findById(int id) {
        String sql = "SELECT g.*, c.name as category_name FROM manage_gallery g " +
                     "LEFT JOIN blog_categories c ON g.category_id = c.id " +
                     "WHERE g.id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                ManageGallery item = createGalleryFromResultSet(rs);
                item.setCategoryName(rs.getString("category_name"));
                return item;
            }
        } catch (SQLException e) {
            System.err.println("Error in findById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Category ID
    public List<ManageGallery> findByCategoryId(int categoryId) {
        List<ManageGallery> items = new ArrayList<>();
        String sql = "SELECT g.*, c.name as category_name FROM manage_gallery g " +
                     "LEFT JOIN blog_categories c ON g.category_id = c.id " +
                     "WHERE g.category_id = ? ORDER BY g.posted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ManageGallery item = createGalleryFromResultSet(rs);
                item.setCategoryName(rs.getString("category_name"));
                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error in findByCategoryId: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }
    
    // Find by Status (visible/hidden)
    public List<ManageGallery> findByStatus(boolean status) {
        List<ManageGallery> items = new ArrayList<>();
        String sql = "SELECT g.*, c.name as category_name FROM manage_gallery g " +
                     "LEFT JOIN blog_categories c ON g.category_id = c.id " +
                     "WHERE g.status = ? ORDER BY g.posted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ManageGallery item = createGalleryFromResultSet(rs);
                item.setCategoryName(rs.getString("category_name"));
                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error in findByStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }
    
    // Find by Month and Year (based on posted date)
    public List<ManageGallery> findByMonthYear(int month, int year) {
        List<ManageGallery> items = new ArrayList<>();
        String sql = "SELECT g.*, c.name as category_name FROM manage_gallery g " +
                     "LEFT JOIN blog_categories c ON g.category_id = c.id " +
                     "WHERE MONTH(g.posted_date) = ? AND YEAR(g.posted_date) = ? ORDER BY g.posted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ManageGallery item = createGalleryFromResultSet(rs);
                item.setCategoryName(rs.getString("category_name"));
                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error in findByMonthYear: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }
    
    // Search by keyword (title or description)
    public List<ManageGallery> search(String keyword) {
        List<ManageGallery> items = new ArrayList<>();
        String sql = "SELECT g.*, c.name as category_name FROM manage_gallery g " +
                     "LEFT JOIN blog_categories c ON g.category_id = c.id " +
                     "WHERE g.title LIKE ? OR g.description LIKE ? " +
                     "ORDER BY g.posted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ManageGallery item = createGalleryFromResultSet(rs);
                item.setCategoryName(rs.getString("category_name"));
                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error in search: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }
    
    // Update
    public boolean update(ManageGallery item) {
        String sql = "UPDATE manage_gallery SET title=?, description=?, category_id=?, images=?, status=?, updated_date=? WHERE id=?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, item.getTitle());
            stmt.setString(2, item.getDescription());
            stmt.setInt(3, item.getCategoryId());
            
            // Convert images List to JSON array string
            String imagesJson = convertImagesToJson(item.getImages());
            stmt.setString(4, imagesJson);
            
            stmt.setBoolean(5, item.isStatus());
            stmt.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(7, item.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error in update: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Update Status (visible/hidden)
    public boolean updateStatus(int id, boolean status) {
        String sql = "UPDATE manage_gallery SET status = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, status);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error in updateStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete
    public boolean delete(int id) {
        String sql = "DELETE FROM manage_gallery WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error in delete: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Count methods
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM manage_gallery";
        return executeCountQuery(sql);
    }
    
    public int countVisible() {
        String sql = "SELECT COUNT(*) FROM manage_gallery WHERE status = true";
        return executeCountQuery(sql);
    }
    
    public int countHidden() {
        String sql = "SELECT COUNT(*) FROM manage_gallery WHERE status = false";
        return executeCountQuery(sql);
    }
    
    public int countByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM manage_gallery WHERE category_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error in countByCategory: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    private int executeCountQuery(String sql) {
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error in executeCountQuery: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Helper method to convert images List to JSON array string
    private String convertImagesToJson(List<String> images) {
        if (images == null || images.isEmpty()) {
            return "[]";
        }
        
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < images.size(); i++) {
            if (i > 0) {
                json.append(",");
            }
            // Escape quotes in the image URL
            String imageUrl = images.get(i).replace("\"", "\\\"");
            json.append("\"").append(imageUrl).append("\"");
        }
        json.append("]");
        return json.toString();
    }
}