package wepapp.dao;

import wepapp.model.ManageService;
import wepapp.config.database;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.lang.reflect.Type;

public class ManageServiceDAO {
    
    private static ManageServiceDAO instance;
    private Connection connection;
    private Gson gson;
    
    // Custom TypeAdapter for LocalDate
    private static class LocalDateAdapter extends TypeAdapter<LocalDate> {
        private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE;
        
        @Override
        public void write(JsonWriter out, LocalDate value) throws IOException {
            if (value == null) {
                out.nullValue();
            } else {
                out.value(formatter.format(value));
            }
        }
        
        @Override
        public LocalDate read(JsonReader in) throws IOException {
            if (in.peek() == null) {
                in.nextNull();
                return null;
            }
            String dateStr = in.nextString();
            return LocalDate.parse(dateStr, formatter);
        }
    }
    
    // Custom TypeAdapter for LocalDateTime
    private static class LocalDateTimeAdapter extends TypeAdapter<LocalDateTime> {
        private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        
        @Override
        public void write(JsonWriter out, LocalDateTime value) throws IOException {
            if (value == null) {
                out.nullValue();
            } else {
                out.value(formatter.format(value));
            }
        }
        
        @Override
        public LocalDateTime read(JsonReader in) throws IOException {
            if (in.peek() == null) {
                in.nextNull();
                return null;
            }
            String dateTimeStr = in.nextString();
            return LocalDateTime.parse(dateTimeStr, formatter);
        }
    }
    
    private Gson createGson() {
        return new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .create();
    }
    
    private ManageServiceDAO() {
        this.connection = database.getConnection();
        this.gson = createGson();
    }
    
    public static synchronized ManageServiceDAO getInstance() {
        if (instance == null) {
            instance = new ManageServiceDAO();
        }
        return instance;
    }
    
    private ManageService createServiceFromResultSet(ResultSet rs) throws SQLException {
        ManageService service = new ManageService();
        service.setId(rs.getInt("id"));
        service.setTitle(rs.getString("title"));
        service.setDescription(rs.getString("description"));
        service.setCategoryId(rs.getInt("category_id"));
        service.setDuration(rs.getInt("duration"));
        service.setFees(rs.getDouble("fees"));
        service.setStatus(rs.getString("status"));
        
        // Get category name from join if available
        try {
            service.setCategoryName(rs.getString("category_name"));
        } catch (SQLException e) {
            service.setCategoryName("");
        }
        
        // Parse images JSON array
        String imagesJson = rs.getString("images");
        if (imagesJson != null && !imagesJson.isEmpty() && !imagesJson.equals("[]") && !imagesJson.equals("null")) {
            try {
                Type listType = new TypeToken<ArrayList<String>>(){}.getType();
                List<String> images = gson.fromJson(imagesJson, listType);
                if (images != null) {
                    service.setImages(images);
                } else {
                    service.setImages(new ArrayList<>());
                }
            } catch (Exception e) {
                service.setImages(new ArrayList<>());
            }
        } else {
            service.setImages(new ArrayList<>());
        }
        
        Date createdDate = rs.getDate("created_date");
        if (createdDate != null) {
            service.setCreatedDate(createdDate.toLocalDate());
        }
        
        Timestamp updatedTs = rs.getTimestamp("updated_date");
        if (updatedTs != null) {
            service.setUpdatedDate(updatedTs.toLocalDateTime());
        }
        
        return service;
    }
    
    public boolean save(ManageService service) {
        String sql = "INSERT INTO manage_services (title, description, category_id, duration, fees, images, status, created_date, updated_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, service.getTitle());
            stmt.setString(2, service.getDescription());
            stmt.setInt(3, service.getCategoryId());
            stmt.setInt(4, service.getDuration());
            stmt.setDouble(5, service.getFees());
            
            String imagesJson = service.getImages() != null ? gson.toJson(service.getImages()) : "[]";
            stmt.setString(6, imagesJson);
            
            stmt.setString(7, service.getStatus() != null ? service.getStatus() : "available");
            stmt.setDate(8, Date.valueOf(service.getCreatedDate() != null ? service.getCreatedDate() : LocalDate.now()));
            stmt.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    service.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<ManageService> findAll() {
        List<ManageService> services = new ArrayList<>();
        String sql = "SELECT s.*, sc.name as category_name FROM manage_services s " +
                     "LEFT JOIN service_categories sc ON s.category_id = sc.id " +
                     "ORDER BY s.id DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                ManageService service = createServiceFromResultSet(rs);
                services.add(service);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }
    
    public ManageService findById(int id) {
        String sql = "SELECT s.*, sc.name as category_name FROM manage_services s " +
                     "LEFT JOIN service_categories sc ON s.category_id = sc.id " +
                     "WHERE s.id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createServiceFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public ManageService findByTitle(String title) {
        String sql = "SELECT s.*, sc.name as category_name FROM manage_services s " +
                     "LEFT JOIN service_categories sc ON s.category_id = sc.id " +
                     "WHERE s.title = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, title);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createServiceFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean titleExistsExcludingId(String title, int excludeId) {
        String sql = "SELECT COUNT(*) FROM manage_services WHERE title = ? AND id != ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, title);
            stmt.setInt(2, excludeId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean update(ManageService service) {
        String sql = "UPDATE manage_services SET title=?, description=?, category_id=?, duration=?, fees=?, images=?, status=?, updated_date=? WHERE id=?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, service.getTitle());
            stmt.setString(2, service.getDescription());
            stmt.setInt(3, service.getCategoryId());
            stmt.setInt(4, service.getDuration());
            stmt.setDouble(5, service.getFees());
            
            String imagesJson = service.getImages() != null ? gson.toJson(service.getImages()) : "[]";
            stmt.setString(6, imagesJson);
            
            stmt.setString(7, service.getStatus());
            stmt.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(9, service.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int id) {
        String sql = "DELETE FROM manage_services WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<ManageService> findByStatus(String status) {
        List<ManageService> services = new ArrayList<>();
        String sql = "SELECT s.*, sc.name as category_name FROM manage_services s " +
                     "LEFT JOIN service_categories sc ON s.category_id = sc.id " +
                     "WHERE s.status = ? ORDER BY s.id DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                services.add(createServiceFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }
    
    public List<ManageService> findByCategoryId(int categoryId) {
        List<ManageService> services = new ArrayList<>();
        String sql = "SELECT s.*, sc.name as category_name FROM manage_services s " +
                     "LEFT JOIN service_categories sc ON s.category_id = sc.id " +
                     "WHERE s.category_id = ? ORDER BY s.id DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                services.add(createServiceFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }
    
    public List<ManageService> search(String keyword) {
        List<ManageService> services = new ArrayList<>();
        String sql = "SELECT s.*, sc.name as category_name FROM manage_services s " +
                     "LEFT JOIN service_categories sc ON s.category_id = sc.id " +
                     "WHERE s.title LIKE ? OR s.description LIKE ? " +
                     "ORDER BY s.id DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                services.add(createServiceFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }
    
    public List<ManageService> advancedSearch(String keyword, Integer categoryId, String status, 
                                             Integer minDuration, Integer maxDuration, 
                                             Double minFees, Double maxFees) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.*, sc.name as category_name FROM manage_services s ");
        sql.append("LEFT JOIN service_categories sc ON s.category_id = sc.id ");
        sql.append("WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (s.title LIKE ? OR s.description LIKE ?) ");
            String searchPattern = "%" + keyword + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        if (categoryId != null && categoryId > 0) {
            sql.append("AND s.category_id = ? ");
            params.add(categoryId);
        }
        
        if (status != null && !status.isEmpty() && !status.equals("all")) {
            sql.append("AND s.status = ? ");
            params.add(status);
        }
        
        if (minDuration != null && minDuration > 0) {
            sql.append("AND s.duration >= ? ");
            params.add(minDuration);
        }
        
        if (maxDuration != null && maxDuration > 0) {
            sql.append("AND s.duration <= ? ");
            params.add(maxDuration);
        }
        
        if (minFees != null && minFees > 0) {
            sql.append("AND s.fees >= ? ");
            params.add(minFees);
        }
        
        if (maxFees != null && maxFees > 0) {
            sql.append("AND s.fees <= ? ");
            params.add(maxFees);
        }
        
        sql.append("ORDER BY s.id DESC");
        
        List<ManageService> services = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                services.add(createServiceFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return services;
    }
    
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE manage_services SET status = ?, updated_date = ? WHERE id = ?";
        
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
    
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM manage_services";
        return executeCountQuery(sql);
    }
    
    public int countAvailable() {
        return countByStatus("available");
    }
    
    public int countUnavailable() {
        return countByStatus("unavailable");
    }
    
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM manage_services WHERE status = ?";
        
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
    
    public List<CategoryStat> getCategoryStatistics() {
        List<CategoryStat> stats = new ArrayList<>();
        String sql = "SELECT sc.id, sc.name, COUNT(s.id) as service_count " +
                     "FROM service_categories sc " +
                     "LEFT JOIN manage_services s ON sc.id = s.category_id " +
                     "GROUP BY sc.id, sc.name " +
                     "ORDER BY sc.name";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                CategoryStat stat = new CategoryStat();
                stat.setId(rs.getInt("id"));
                stat.setName(rs.getString("name"));
                stat.setServiceCount(rs.getInt("service_count"));
                stats.add(stat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    
    public Stats getStats() {
        Stats stats = new Stats();
        stats.setTotal(countAll());
        stats.setAvailable(countAvailable());
        stats.setUnavailable(countUnavailable());
        return stats;
    }
    
    public static class CategoryStat {
        private int id;
        private String name;
        private int serviceCount;
        
        public CategoryStat() {}
        
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public int getServiceCount() { return serviceCount; }
        public void setServiceCount(int serviceCount) { this.serviceCount = serviceCount; }
    }
    
    public static class Stats {
        private int total;
        private int available;
        private int unavailable;
        
        public Stats() {}
        
        public int getTotal() { return total; }
        public void setTotal(int total) { this.total = total; }
        public int getAvailable() { return available; }
        public void setAvailable(int available) { this.available = available; }
        public int getUnavailable() { return unavailable; }
        public void setUnavailable(int unavailable) { this.unavailable = unavailable; }
    }
}