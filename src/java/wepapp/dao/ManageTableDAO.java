package wepapp.dao;

import wepapp.model.ManageTable;
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

public class ManageTableDAO {
    
    private static ManageTableDAO instance;
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
    
    private ManageTableDAO() {
        this.connection = database.getConnection();
        this.gson = createGson();
    }
    
    public static synchronized ManageTableDAO getInstance() {
        if (instance == null) {
            instance = new ManageTableDAO();
        }
        return instance;
    }
    
    private ManageTable createTableFromResultSet(ResultSet rs) throws SQLException {
        ManageTable table = new ManageTable();
        table.setId(rs.getInt("id"));
        table.setTablePrefix(rs.getString("table_prefix"));
        table.setTableNo(rs.getString("table_no"));
        table.setDescription(rs.getString("description"));
        table.setLocationId(rs.getInt("location_id"));
        table.setCapacity(rs.getInt("capacity"));
        table.setStatus(rs.getString("status"));
        
        try {
            table.setLocationName(rs.getString("location_name"));
        } catch (SQLException e) {
            table.setLocationName("");
        }
        
        String imagesJson = rs.getString("images");
        if (imagesJson != null && !imagesJson.isEmpty() && !imagesJson.equals("[]") && !imagesJson.equals("null")) {
            try {
                Type listType = new TypeToken<ArrayList<String>>(){}.getType();
                List<String> images = gson.fromJson(imagesJson, listType);
                if (images != null) {
                    table.setImages(images);
                } else {
                    table.setImages(new ArrayList<>());
                }
            } catch (Exception e) {
                table.setImages(new ArrayList<>());
            }
        } else {
            table.setImages(new ArrayList<>());
        }
        
        Date createdDate = rs.getDate("created_date");
        if (createdDate != null) {
            table.setCreatedDate(createdDate.toLocalDate());
        }
        
        Timestamp updatedTs = rs.getTimestamp("updated_date");
        if (updatedTs != null) {
            table.setUpdatedDate(updatedTs.toLocalDateTime());
        }
        
        return table;
    }
    
    public boolean save(ManageTable table) {
        String sql = "INSERT INTO manage_tables (table_prefix, table_no, description, location_id, capacity, images, status, created_date, updated_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, table.getTablePrefix());
            stmt.setString(2, table.getTableNo());
            stmt.setString(3, table.getDescription());
            stmt.setInt(4, table.getLocationId());
            stmt.setInt(5, table.getCapacity());
            
            String imagesJson = table.getImages() != null ? gson.toJson(table.getImages()) : "[]";
            stmt.setString(6, imagesJson);
            
            stmt.setString(7, table.getStatus() != null ? table.getStatus() : "available");
            stmt.setDate(8, Date.valueOf(table.getCreatedDate() != null ? table.getCreatedDate() : LocalDate.now()));
            stmt.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    table.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<ManageTable> findAll() {
        List<ManageTable> tables = new ArrayList<>();
        String sql = "SELECT t.*, tl.name as location_name FROM manage_tables t " +
                     "LEFT JOIN table_locations tl ON t.location_id = tl.id " +
                     "ORDER BY t.id DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                ManageTable table = createTableFromResultSet(rs);
                tables.add(table);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tables;
    }
    
    public ManageTable findById(int id) {
        String sql = "SELECT t.*, tl.name as location_name FROM manage_tables t " +
                     "LEFT JOIN table_locations tl ON t.location_id = tl.id " +
                     "WHERE t.id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createTableFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public ManageTable findByTableNo(String tableNo) {
        String sql = "SELECT t.*, tl.name as location_name FROM manage_tables t " +
                     "LEFT JOIN table_locations tl ON t.location_id = tl.id " +
                     "WHERE t.table_no = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, tableNo);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createTableFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean tableNoExistsExcludingId(String tableNo, int excludeId) {
        String sql = "SELECT COUNT(*) FROM manage_tables WHERE table_no = ? AND id != ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, tableNo);
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
    
    public boolean update(ManageTable table) {
        String sql = "UPDATE manage_tables SET table_no=?, description=?, location_id=?, capacity=?, images=?, status=?, updated_date=? WHERE id=?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, table.getTableNo());
            stmt.setString(2, table.getDescription());
            stmt.setInt(3, table.getLocationId());
            stmt.setInt(4, table.getCapacity());
            
            String imagesJson = table.getImages() != null ? gson.toJson(table.getImages()) : "[]";
            stmt.setString(5, imagesJson);
            
            stmt.setString(6, table.getStatus());
            stmt.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(8, table.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int id) {
        String sql = "DELETE FROM manage_tables WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public String getNextTablePrefix() {
        String sql = "SELECT table_prefix FROM manage_tables ORDER BY id DESC LIMIT 1";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                String lastPrefix = rs.getString("table_prefix");
                if (lastPrefix != null && lastPrefix.startsWith("T-")) {
                    String numPart = lastPrefix.substring(2);
                    try {
                        int nextNum = Integer.parseInt(numPart) + 1;
                        return "T-" + String.format("%05d", nextNum);
                    } catch (NumberFormatException e) {
                        return "T-00001";
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "T-00001";
    }
    
    public List<ManageTable> findByStatus(String status) {
        List<ManageTable> tables = new ArrayList<>();
        String sql = "SELECT t.*, tl.name as location_name FROM manage_tables t " +
                     "LEFT JOIN table_locations tl ON t.location_id = tl.id " +
                     "WHERE t.status = ? ORDER BY t.id DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                tables.add(createTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tables;
    }
    
    public List<ManageTable> findByLocationId(int locationId) {
        List<ManageTable> tables = new ArrayList<>();
        String sql = "SELECT t.*, tl.name as location_name FROM manage_tables t " +
                     "LEFT JOIN table_locations tl ON t.location_id = tl.id " +
                     "WHERE t.location_id = ? ORDER BY t.id DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, locationId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                tables.add(createTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tables;
    }
    
    public List<ManageTable> search(String keyword) {
        List<ManageTable> tables = new ArrayList<>();
        String sql = "SELECT t.*, tl.name as location_name FROM manage_tables t " +
                     "LEFT JOIN table_locations tl ON t.location_id = tl.id " +
                     "WHERE t.table_prefix LIKE ? OR t.table_no LIKE ? OR t.description LIKE ? " +
                     "ORDER BY t.id DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                tables.add(createTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tables;
    }
    
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE manage_tables SET status = ?, updated_date = ? WHERE id = ?";
        
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
        String sql = "SELECT COUNT(*) FROM manage_tables";
        return executeCountQuery(sql);
    }
    
    public int countAvailable() {
        return countByStatus("available");
    }
    
    public int countMaintenance() {
        return countByStatus("maintenance");
    }
    
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM manage_tables WHERE status = ?";
        
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
    
    public List<LocationStat> getLocationStatistics() {
        List<LocationStat> stats = new ArrayList<>();
        String sql = "SELECT tl.id, tl.name, COUNT(t.id) as table_count " +
                     "FROM table_locations tl " +
                     "LEFT JOIN manage_tables t ON tl.id = t.location_id " +
                     "GROUP BY tl.id, tl.name " +
                     "ORDER BY tl.name";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                LocationStat stat = new LocationStat();
                stat.setId(rs.getInt("id"));
                stat.setName(rs.getString("name"));
                stat.setTableCount(rs.getInt("table_count"));
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
        stats.setMaintenance(countMaintenance());
        return stats;
    }
    
    public static class LocationStat {
        private int id;
        private String name;
        private int tableCount;
        
        public LocationStat() {}
        
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public int getTableCount() { return tableCount; }
        public void setTableCount(int tableCount) { this.tableCount = tableCount; }
    }
    
    public static class Stats {
        private int total;
        private int available;
        private int maintenance;
        
        public Stats() {}
        
        public int getTotal() { return total; }
        public void setTotal(int total) { this.total = total; }
        public int getAvailable() { return available; }
        public void setAvailable(int available) { this.available = available; }
        public int getMaintenance() { return maintenance; }
        public void setMaintenance(int maintenance) { this.maintenance = maintenance; }
    }
}