package wepapp.dao;

import wepapp.model.ManageRoom;
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

public class ManageRoomDAO {
    
    private static ManageRoomDAO instance;
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
    
    private ManageRoomDAO() {
        this.connection = database.getConnection();
        this.gson = createGson();
    }
    
    public static synchronized ManageRoomDAO getInstance() {
        if (instance == null) {
            instance = new ManageRoomDAO();
        }
        return instance;
    }
    
    private ManageRoom createRoomFromResultSet(ResultSet rs) throws SQLException {
        ManageRoom room = new ManageRoom();
        room.setId(rs.getInt("id"));
        room.setRoomPrefix(rs.getString("room_prefix"));
        room.setRoomNo(rs.getString("room_no"));
        room.setDescription(rs.getString("description"));
        room.setTypeId(rs.getInt("type_id"));
        room.setCapacity(rs.getInt("capacity"));
        room.setPrice(rs.getDouble("price"));
        room.setStatus(rs.getString("status"));
        
        try {
            room.setTypeName(rs.getString("type_name"));
        } catch (SQLException e) {
            room.setTypeName("");
        }
        
        String facilityIdsJson = rs.getString("facility_ids");
        if (facilityIdsJson != null && !facilityIdsJson.isEmpty() && !facilityIdsJson.equals("[]") && !facilityIdsJson.equals("null")) {
            try {
                Type listType = new TypeToken<ArrayList<Integer>>(){}.getType();
                List<Integer> facilityIds = gson.fromJson(facilityIdsJson, listType);
                if (facilityIds != null) {
                    room.setFacilityIds(facilityIds);
                } else {
                    room.setFacilityIds(new ArrayList<>());
                }
            } catch (Exception e) {
                room.setFacilityIds(new ArrayList<>());
            }
        } else {
            room.setFacilityIds(new ArrayList<>());
        }
        
        String imagesJson = rs.getString("images");
        if (imagesJson != null && !imagesJson.isEmpty() && !imagesJson.equals("[]") && !imagesJson.equals("null")) {
            try {
                Type listType = new TypeToken<ArrayList<String>>(){}.getType();
                List<String> images = gson.fromJson(imagesJson, listType);
                if (images != null) {
                    room.setImages(images);
                } else {
                    room.setImages(new ArrayList<>());
                }
            } catch (Exception e) {
                room.setImages(new ArrayList<>());
            }
        } else {
            room.setImages(new ArrayList<>());
        }
        
        Date createdDate = rs.getDate("created_date");
        if (createdDate != null) {
            room.setCreatedDate(createdDate.toLocalDate());
        }
        
        Timestamp updatedTs = rs.getTimestamp("updated_date");
        if (updatedTs != null) {
            room.setUpdatedDate(updatedTs.toLocalDateTime());
        }
        
        return room;
    }
    
    public boolean save(ManageRoom room) {
        String sql = "INSERT INTO manage_rooms (room_prefix, room_no, description, type_id, facility_ids, capacity, price, images, status, created_date, updated_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, room.getRoomPrefix());
            stmt.setString(2, room.getRoomNo());
            stmt.setString(3, room.getDescription());
            stmt.setInt(4, room.getTypeId());
            
            String facilityIdsJson = room.getFacilityIds() != null ? gson.toJson(room.getFacilityIds()) : "[]";
            stmt.setString(5, facilityIdsJson);
            
            stmt.setInt(6, room.getCapacity());
            stmt.setDouble(7, room.getPrice());
            
            String imagesJson = room.getImages() != null ? gson.toJson(room.getImages()) : "[]";
            stmt.setString(8, imagesJson);
            
            stmt.setString(9, room.getStatus() != null ? room.getStatus() : "available");
            stmt.setDate(10, Date.valueOf(room.getCreatedDate() != null ? room.getCreatedDate() : LocalDate.now()));
            stmt.setTimestamp(11, Timestamp.valueOf(LocalDateTime.now()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    room.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<ManageRoom> findAll() {
        List<ManageRoom> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.name as type_name FROM manage_rooms r " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "ORDER BY r.id DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                ManageRoom room = createRoomFromResultSet(rs);
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }
    
    public ManageRoom findById(int id) {
        String sql = "SELECT r.*, rt.name as type_name FROM manage_rooms r " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE r.id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createRoomFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public ManageRoom findByRoomNo(String roomNo) {
        String sql = "SELECT r.*, rt.name as type_name FROM manage_rooms r " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE r.room_no = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, roomNo);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createRoomFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean roomNoExistsExcludingId(String roomNo, int excludeId) {
        String sql = "SELECT COUNT(*) FROM manage_rooms WHERE room_no = ? AND id != ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, roomNo);
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
    
    public boolean update(ManageRoom room) {
        String sql = "UPDATE manage_rooms SET room_no=?, description=?, type_id=?, facility_ids=?, capacity=?, price=?, images=?, status=?, updated_date=? WHERE id=?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, room.getRoomNo());
            stmt.setString(2, room.getDescription());
            stmt.setInt(3, room.getTypeId());
            
            String facilityIdsJson = room.getFacilityIds() != null ? gson.toJson(room.getFacilityIds()) : "[]";
            stmt.setString(4, facilityIdsJson);
            
            stmt.setInt(5, room.getCapacity());
            stmt.setDouble(6, room.getPrice());
            
            String imagesJson = room.getImages() != null ? gson.toJson(room.getImages()) : "[]";
            stmt.setString(7, imagesJson);
            
            stmt.setString(8, room.getStatus());
            stmt.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(10, room.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int id) {
        String sql = "DELETE FROM manage_rooms WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public String getNextRoomPrefix() {
        String sql = "SELECT room_prefix FROM manage_rooms ORDER BY id DESC LIMIT 1";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                String lastPrefix = rs.getString("room_prefix");
                if (lastPrefix != null && lastPrefix.startsWith("R-")) {
                    String numPart = lastPrefix.substring(2);
                    try {
                        int nextNum = Integer.parseInt(numPart) + 1;
                        return "R-" + String.format("%05d", nextNum);
                    } catch (NumberFormatException e) {
                        return "R-00001";
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "R-00001";
    }
    
    public List<ManageRoom> findByStatus(String status) {
        List<ManageRoom> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.name as type_name FROM manage_rooms r " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE r.status = ? ORDER BY r.id DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                rooms.add(createRoomFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }
    
    public List<ManageRoom> findByTypeId(int typeId) {
        List<ManageRoom> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.name as type_name FROM manage_rooms r " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE r.type_id = ? ORDER BY r.id DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, typeId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                rooms.add(createRoomFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }
    
    public List<ManageRoom> search(String keyword) {
        List<ManageRoom> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.name as type_name FROM manage_rooms r " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE r.room_prefix LIKE ? OR r.room_no LIKE ? OR r.description LIKE ? " +
                     "ORDER BY r.id DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                rooms.add(createRoomFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }
    
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE manage_rooms SET status = ?, updated_date = ? WHERE id = ?";
        
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
        String sql = "SELECT COUNT(*) FROM manage_rooms";
        return executeCountQuery(sql);
    }
    
    public int countAvailable() {
        return countByStatus("available");
    }
    
    public int countMaintenance() {
        return countByStatus("maintenance");
    }
    
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM manage_rooms WHERE status = ?";
        
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
    
    public List<TypeStat> getRoomTypeStatistics() {
        List<TypeStat> stats = new ArrayList<>();
        String sql = "SELECT rt.id, rt.name, COUNT(r.id) as room_count " +
                     "FROM room_types rt " +
                     "LEFT JOIN manage_rooms r ON rt.id = r.type_id " +
                     "GROUP BY rt.id, rt.name " +
                     "ORDER BY rt.name";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                TypeStat stat = new TypeStat();
                stat.setId(rs.getInt("id"));
                stat.setName(rs.getString("name"));
                stat.setRoomCount(rs.getInt("room_count"));
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
    
    public static class TypeStat {
        private int id;
        private String name;
        private int roomCount;
        
        public TypeStat() {}
        
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public int getRoomCount() { return roomCount; }
        public void setRoomCount(int roomCount) { this.roomCount = roomCount; }
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