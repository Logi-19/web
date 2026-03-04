package wepapp.dao;

import wepapp.model.ManageBlogs;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ManageBlogsDAO {
    
    // Singleton Pattern
    private static ManageBlogsDAO instance;
    private Connection connection;
    
    private ManageBlogsDAO() {
        this.connection = database.getConnection();
    }
    
    public static synchronized ManageBlogsDAO getInstance() {
        if (instance == null) {
            instance = new ManageBlogsDAO();
        }
        return instance;
    }
    
    // Factory Method Pattern - creates ManageBlogs from ResultSet
    private ManageBlogs createBlogFromResultSet(ResultSet rs) throws SQLException {
        ManageBlogs blog = new ManageBlogs();
        blog.setId(rs.getInt("id"));
        blog.setBlogPrefix(rs.getString("blog_prefix"));
        blog.setTitle(rs.getString("title"));
        blog.setDescription(rs.getString("description"));
        blog.setCategoryId(rs.getInt("category_id"));
        
        // Get images as JSON array and convert to List
        String imagesJson = rs.getString("images");
        if (imagesJson != null && !imagesJson.isEmpty()) {
            List<String> images = new ArrayList<>();
            if (!imagesJson.equals("[]") && !imagesJson.equals("null")) {
                // Remove brackets and quotes, then split
                String cleanJson = imagesJson.replace("[", "").replace("]", "").replace("\"", "");
                if (!cleanJson.isEmpty()) {
                    String[] imageArray = cleanJson.split(",");
                    for (String img : imageArray) {
                        images.add(img.trim());
                    }
                }
            }
            blog.setImages(images);
        }
        
        blog.setLink(rs.getString("link"));
        
        Date blogDate = rs.getDate("blog_date");
        if (blogDate != null) {
            blog.setBlogDate(blogDate.toLocalDate());
        }
        
        blog.setStatus(rs.getBoolean("status"));
        
        Timestamp postedTs = rs.getTimestamp("posted_date");
        if (postedTs != null) {
            blog.setPostedDate(postedTs.toLocalDateTime());
        }
        
        Timestamp updatedTs = rs.getTimestamp("updated_date");
        if (updatedTs != null) {
            blog.setUpdatedDate(updatedTs.toLocalDateTime());
        }
        
        return blog;
    }
    
    // Create (INSERT)
    public boolean save(ManageBlogs blog) {
        String sql = "INSERT INTO manage_blogs (blog_prefix, title, description, category_id, images, link, blog_date, status, posted_date, updated_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, blog.getBlogPrefix());
            stmt.setString(2, blog.getTitle());
            stmt.setString(3, blog.getDescription());
            stmt.setInt(4, blog.getCategoryId());
            
            // Convert images List to JSON array string
            String imagesJson = convertImagesToJson(blog.getImages());
            stmt.setString(5, imagesJson);
            
            stmt.setString(6, blog.getLink());
            stmt.setDate(7, blog.getBlogDate() != null ? Date.valueOf(blog.getBlogDate()) : null);
            stmt.setBoolean(8, blog.isStatus());
            stmt.setTimestamp(9, Timestamp.valueOf(blog.getPostedDate()));
            stmt.setTimestamp(10, Timestamp.valueOf(blog.getUpdatedDate()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    blog.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Read All
    public List<ManageBlogs> findAll() {
        List<ManageBlogs> blogs = new ArrayList<>();
        String sql = "SELECT b.*, c.name as category_name FROM manage_blogs b " +
                     "LEFT JOIN blog_categories c ON b.category_id = c.id " +
                     "ORDER BY b.posted_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                ManageBlogs blog = createBlogFromResultSet(rs);
                blog.setCategoryName(rs.getString("category_name"));
                blogs.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blogs;
    }
    
    // Read by ID
    public ManageBlogs findById(int id) {
        String sql = "SELECT b.*, c.name as category_name FROM manage_blogs b " +
                     "LEFT JOIN blog_categories c ON b.category_id = c.id " +
                     "WHERE b.id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                ManageBlogs blog = createBlogFromResultSet(rs);
                blog.setCategoryName(rs.getString("category_name"));
                return blog;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Find by Category ID
    public List<ManageBlogs> findByCategoryId(int categoryId) {
        List<ManageBlogs> blogs = new ArrayList<>();
        String sql = "SELECT b.*, c.name as category_name FROM manage_blogs b " +
                     "LEFT JOIN blog_categories c ON b.category_id = c.id " +
                     "WHERE b.category_id = ? ORDER BY b.posted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ManageBlogs blog = createBlogFromResultSet(rs);
                blog.setCategoryName(rs.getString("category_name"));
                blogs.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blogs;
    }
    
    // Find by Status (visible/hidden)
    public List<ManageBlogs> findByStatus(boolean status) {
        List<ManageBlogs> blogs = new ArrayList<>();
        String sql = "SELECT b.*, c.name as category_name FROM manage_blogs b " +
                     "LEFT JOIN blog_categories c ON b.category_id = c.id " +
                     "WHERE b.status = ? ORDER BY b.posted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ManageBlogs blog = createBlogFromResultSet(rs);
                blog.setCategoryName(rs.getString("category_name"));
                blogs.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blogs;
    }
    
    // Find by Blog Date Range
    public List<ManageBlogs> findByBlogDateRange(LocalDate startDate, LocalDate endDate) {
        List<ManageBlogs> blogs = new ArrayList<>();
        String sql = "SELECT b.*, c.name as category_name FROM manage_blogs b " +
                     "LEFT JOIN blog_categories c ON b.category_id = c.id " +
                     "WHERE b.blog_date BETWEEN ? AND ? ORDER BY b.blog_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ManageBlogs blog = createBlogFromResultSet(rs);
                blog.setCategoryName(rs.getString("category_name"));
                blogs.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blogs;
    }
    
    // Find by Month and Year
    public List<ManageBlogs> findByMonthYear(int month, int year) {
        List<ManageBlogs> blogs = new ArrayList<>();
        String sql = "SELECT b.*, c.name as category_name FROM manage_blogs b " +
                     "LEFT JOIN blog_categories c ON b.category_id = c.id " +
                     "WHERE MONTH(b.blog_date) = ? AND YEAR(b.blog_date) = ? ORDER BY b.blog_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ManageBlogs blog = createBlogFromResultSet(rs);
                blog.setCategoryName(rs.getString("category_name"));
                blogs.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blogs;
    }
    
    // Search by keyword (title or description)
    public List<ManageBlogs> search(String keyword) {
        List<ManageBlogs> blogs = new ArrayList<>();
        String sql = "SELECT b.*, c.name as category_name FROM manage_blogs b " +
                     "LEFT JOIN blog_categories c ON b.category_id = c.id " +
                     "WHERE b.title LIKE ? OR b.description LIKE ? OR b.blog_prefix LIKE ? " +
                     "ORDER BY b.posted_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ManageBlogs blog = createBlogFromResultSet(rs);
                blog.setCategoryName(rs.getString("category_name"));
                blogs.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blogs;
    }
    
    // Update
    public boolean update(ManageBlogs blog) {
        String sql = "UPDATE manage_blogs SET title=?, description=?, category_id=?, images=?, link=?, blog_date=?, status=?, updated_date=? WHERE id=?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, blog.getTitle());
            stmt.setString(2, blog.getDescription());
            stmt.setInt(3, blog.getCategoryId());
            
            // Convert images List to JSON array string
            String imagesJson = convertImagesToJson(blog.getImages());
            stmt.setString(4, imagesJson);
            
            stmt.setString(5, blog.getLink());
            stmt.setDate(6, blog.getBlogDate() != null ? Date.valueOf(blog.getBlogDate()) : null);
            stmt.setBoolean(7, blog.isStatus());
            stmt.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(9, blog.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update Status (visible/hidden)
    public boolean updateStatus(int id, boolean status) {
        String sql = "UPDATE manage_blogs SET status = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, status);
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
        String sql = "DELETE FROM manage_blogs WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get next blog prefix (auto-generate like B-00001)
    public String getNextBlogPrefix() {
        String sql = "SELECT blog_prefix FROM manage_blogs ORDER BY id DESC LIMIT 1";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                String lastPrefix = rs.getString("blog_prefix");
                // Extract number part (after B-)
                String numPart = lastPrefix.substring(2);
                int nextNum = Integer.parseInt(numPart) + 1;
                return "B-" + String.format("%05d", nextNum);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // If no records exist, start with B-00001
        return "B-00001";
    }
    
    // Count methods
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM manage_blogs";
        return executeCountQuery(sql);
    }
    
    public int countVisible() {
        String sql = "SELECT COUNT(*) FROM manage_blogs WHERE status = true";
        return executeCountQuery(sql);
    }
    
    public int countHidden() {
        String sql = "SELECT COUNT(*) FROM manage_blogs WHERE status = false";
        return executeCountQuery(sql);
    }
    
    public int countByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM manage_blogs WHERE category_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
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
            json.append("\"").append(images.get(i).replace("\"", "\\\"")).append("\"");
        }
        json.append("]");
        return json.toString();
    }
}