package wepapp.dao;

import wepapp.model.BookRoom;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class BookRoomDAO {
    
    // Singleton Pattern
    private static BookRoomDAO instance;
    private Connection connection;
    
    private BookRoomDAO() {
        this.connection = database.getConnection();
    }
    
    public static synchronized BookRoomDAO getInstance() {
        if (instance == null) {
            instance = new BookRoomDAO();
        }
        return instance;
    }
    
    // Generate Reservation Number (R-R-0000-0000 format)
    private String generateReservationNo() {
        String sql = "SELECT COUNT(*) FROM bookings";
        int count = 0;
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                count = rs.getInt(1) + 1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Format: R-R-XXXX-YYYY where X is sequence, Y is random
        String sequence = String.format("%04d", count);
        String randomPart = String.format("%04d", (int)(Math.random() * 10000));
        
        return "R-R-" + sequence + "-" + randomPart;
    }
    
    // Factory Method Pattern - creates BookRoom from ResultSet with joined data
    private BookRoom createBookRoomFromResultSet(ResultSet rs) throws SQLException {
        BookRoom booking = new BookRoom();
        
        // Booking fields
        booking.setId(rs.getInt("id"));
        booking.setReservationNo(rs.getString("reservation_no"));
        booking.setRoomId(rs.getInt("room_id"));
        booking.setGuestId(rs.getInt("guest_id"));
        
        Date checkInDateSql = rs.getDate("check_in_date");
        if (checkInDateSql != null) {
            booking.setCheckInDate(checkInDateSql.toLocalDate());
        }
        
        Date checkOutDateSql = rs.getDate("check_out_date");
        if (checkOutDateSql != null) {
            booking.setCheckOutDate(checkOutDateSql.toLocalDate());
        }
        
        Time checkInTimeSql = rs.getTime("check_in_time");
        if (checkInTimeSql != null) {
            booking.setCheckInTime(checkInTimeSql.toLocalTime());
        }
        
        Time checkOutTimeSql = rs.getTime("check_out_time");
        if (checkOutTimeSql != null) {
            booking.setCheckOutTime(checkOutTimeSql.toLocalTime());
        }
        
        booking.setSpecialRequests(rs.getString("special_requests"));
        booking.setTotalPrice(rs.getDouble("total_price"));
        booking.setStatus(rs.getString("status"));
        
        Timestamp createdTimestamp = rs.getTimestamp("created_date");
        if (createdTimestamp != null) {
            booking.setCreatedDate(createdTimestamp.toLocalDateTime());
        }
        
        Timestamp updatedTimestamp = rs.getTimestamp("updated_date");
        if (updatedTimestamp != null) {
            booking.setUpdatedDate(updatedTimestamp.toLocalDateTime());
        }
        
        // Try to get joined guest data
        try {
            booking.setGuestName(rs.getString("guest_name"));
            booking.setGuestEmail(rs.getString("guest_email"));
            booking.setGuestPhone(rs.getString("guest_phone"));
        } catch (SQLException e) {
            // Columns don't exist in this query
        }
        
        // Try to get joined room data
        try {
            booking.setRoomNo(rs.getString("room_no"));
            booking.setRoomPrefix(rs.getString("room_prefix"));
            booking.setRoomTypeName(rs.getString("room_type_name"));
        } catch (SQLException e) {
            // Columns don't exist in this query
        }
        
        return booking;
    }
    
    // CREATE - Insert new booking
    public boolean save(BookRoom booking) {
        String sql = "INSERT INTO bookings (reservation_no, room_id, guest_id, check_in_date, check_out_date, " +
                     "check_in_time, check_out_time, special_requests, total_price, status, " +
                     "created_date, updated_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        // Generate reservation number if not set
        if (booking.getReservationNo() == null || booking.getReservationNo().isEmpty()) {
            booking.setReservationNo(generateReservationNo());
        }
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, booking.getReservationNo());
            stmt.setInt(2, booking.getRoomId());
            stmt.setInt(3, booking.getGuestId());
            stmt.setDate(4, booking.getCheckInDate() != null ? Date.valueOf(booking.getCheckInDate()) : null);
            stmt.setDate(5, booking.getCheckOutDate() != null ? Date.valueOf(booking.getCheckOutDate()) : null);
            stmt.setTime(6, booking.getCheckInTime() != null ? Time.valueOf(booking.getCheckInTime()) : null);
            stmt.setTime(7, booking.getCheckOutTime() != null ? Time.valueOf(booking.getCheckOutTime()) : null);
            stmt.setString(8, booking.getSpecialRequests());
            stmt.setDouble(9, booking.getTotalPrice());
            stmt.setString(10, booking.getStatus() != null ? booking.getStatus() : BookRoom.STATUS_PENDING);
            stmt.setTimestamp(11, booking.getCreatedDate() != null ? Timestamp.valueOf(booking.getCreatedDate()) : Timestamp.valueOf(LocalDateTime.now()));
            stmt.setTimestamp(12, booking.getUpdatedDate() != null ? Timestamp.valueOf(booking.getUpdatedDate()) : Timestamp.valueOf(LocalDateTime.now()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    booking.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // READ ALL - Get all bookings with guest and room details
    public List<BookRoom> findAll() {
        List<BookRoom> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "r.room_no, r.room_prefix, rt.name as room_type_name " +
                     "FROM bookings b " +
                     "LEFT JOIN manage_guests g ON b.guest_id = g.id " +
                     "LEFT JOIN manage_rooms r ON b.room_id = r.id " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "ORDER BY b.created_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                bookings.add(createBookRoomFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // READ BY ID - Get booking by ID with details
    public BookRoom findById(int id) {
        String sql = "SELECT b.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "r.room_no, r.room_prefix, rt.name as room_type_name " +
                     "FROM bookings b " +
                     "LEFT JOIN manage_guests g ON b.guest_id = g.id " +
                     "LEFT JOIN manage_rooms r ON b.room_id = r.id " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE b.id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createBookRoomFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // FIND BY RESERVATION NUMBER
    public BookRoom findByReservationNo(String reservationNo) {
        String sql = "SELECT b.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "r.room_no, r.room_prefix, rt.name as room_type_name " +
                     "FROM bookings b " +
                     "LEFT JOIN manage_guests g ON b.guest_id = g.id " +
                     "LEFT JOIN manage_rooms r ON b.room_id = r.id " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE b.reservation_no = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, reservationNo);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createBookRoomFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // FIND BY GUEST ID
    public List<BookRoom> findByGuestId(int guestId) {
        List<BookRoom> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "r.room_no, r.room_prefix, rt.name as room_type_name " +
                     "FROM bookings b " +
                     "LEFT JOIN manage_guests g ON b.guest_id = g.id " +
                     "LEFT JOIN manage_rooms r ON b.room_id = r.id " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE b.guest_id = ? " +
                     "ORDER BY b.created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, guestId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookRoomFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND BY ROOM ID
    public List<BookRoom> findByRoomId(int roomId) {
        List<BookRoom> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "r.room_no, r.room_prefix, rt.name as room_type_name " +
                     "FROM bookings b " +
                     "LEFT JOIN manage_guests g ON b.guest_id = g.id " +
                     "LEFT JOIN manage_rooms r ON b.room_id = r.id " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE b.room_id = ? " +
                     "ORDER BY b.check_in_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookRoomFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND BY STATUS
    public List<BookRoom> findByStatus(String status) {
        List<BookRoom> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "r.room_no, r.room_prefix, rt.name as room_type_name " +
                     "FROM bookings b " +
                     "LEFT JOIN manage_guests g ON b.guest_id = g.id " +
                     "LEFT JOIN manage_rooms r ON b.room_id = r.id " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE b.status = ? " +
                     "ORDER BY b.created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookRoomFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND BY DATE RANGE
    public List<BookRoom> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<BookRoom> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "r.room_no, r.room_prefix, rt.name as room_type_name " +
                     "FROM bookings b " +
                     "LEFT JOIN manage_guests g ON b.guest_id = g.id " +
                     "LEFT JOIN manage_rooms r ON b.room_id = r.id " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE b.check_in_date BETWEEN ? AND ? OR b.check_out_date BETWEEN ? AND ? " +
                     "ORDER BY b.check_in_date";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            stmt.setDate(3, Date.valueOf(startDate));
            stmt.setDate(4, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookRoomFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND UPCOMING BOOKINGS (future check-in) - Only confirmed and pending
    public List<BookRoom> findUpcoming(LocalDate fromDate) {
        List<BookRoom> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "r.room_no, r.room_prefix, rt.name as room_type_name " +
                     "FROM bookings b " +
                     "LEFT JOIN manage_guests g ON b.guest_id = g.id " +
                     "LEFT JOIN manage_rooms r ON b.room_id = r.id " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE b.check_in_date >= ? AND b.status IN (?, ?) " +
                     "ORDER BY b.check_in_date";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(fromDate));
            stmt.setString(2, BookRoom.STATUS_CONFIRMED);
            stmt.setString(3, BookRoom.STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookRoomFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND TODAY'S CHECK-INS
    public List<BookRoom> findTodayCheckIns() {
        List<BookRoom> bookings = new ArrayList<>();
        LocalDate today = LocalDate.now();
        String sql = "SELECT b.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "r.room_no, r.room_prefix, rt.name as room_type_name " +
                     "FROM bookings b " +
                     "LEFT JOIN manage_guests g ON b.guest_id = g.id " +
                     "LEFT JOIN manage_rooms r ON b.room_id = r.id " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE b.check_in_date = ? AND b.status IN (?, ?) " +
                     "ORDER BY b.check_in_time";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(today));
            stmt.setString(2, BookRoom.STATUS_CONFIRMED);
            stmt.setString(3, BookRoom.STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookRoomFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND TODAY'S CHECK-OUTS
    public List<BookRoom> findTodayCheckOuts() {
        List<BookRoom> bookings = new ArrayList<>();
        LocalDate today = LocalDate.now();
        String sql = "SELECT b.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "r.room_no, r.room_prefix, rt.name as room_type_name " +
                     "FROM bookings b " +
                     "LEFT JOIN manage_guests g ON b.guest_id = g.id " +
                     "LEFT JOIN manage_rooms r ON b.room_id = r.id " +
                     "LEFT JOIN room_types rt ON r.type_id = rt.id " +
                     "WHERE b.check_out_date = ? AND b.status = ? " +
                     "ORDER BY b.check_out_time";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(today));
            stmt.setString(2, BookRoom.STATUS_CHECKED_IN);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookRoomFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // CHECK ROOM AVAILABILITY - Only consider confirmed bookings as occupied
    public boolean isRoomAvailable(int roomId, LocalDate checkIn, LocalDate checkOut, Integer excludeBookingId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE room_id = ? AND status = ? " +
                     "AND check_in_date < ? AND check_out_date > ?";
        
        if (excludeBookingId != null) {
            sql += " AND id != ?";
        }
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            stmt.setString(2, BookRoom.STATUS_CONFIRMED);
            stmt.setDate(3, Date.valueOf(checkOut));  // Requested check-out
            stmt.setDate(4, Date.valueOf(checkIn));   // Requested check-in
            
            if (excludeBookingId != null) {
                stmt.setInt(5, excludeBookingId);
            }
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) == 0;  // Available if count is 0
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // UPDATE STATUS BY ID (for Guest - can only cancel their own pending bookings)
    public boolean updateStatusByGuest(int id, int guestId) {
        // Guest can only cancel their own pending bookings
        String sql = "UPDATE bookings SET status = ?, updated_date = ? WHERE id = ? AND guest_id = ? AND status = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, BookRoom.STATUS_CANCELLED);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, id);
            stmt.setInt(4, guestId);
            stmt.setString(5, BookRoom.STATUS_PENDING);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // UPDATE STATUS BY ID (for Staff)
    public boolean updateStatusByStaff(int id, String status) {
        // Validate status is allowed for staff
        if (!isValidStaffStatus(status)) {
            return false;
        }
        
        String sql = "UPDATE bookings SET status = ?, updated_date = ? WHERE id = ?";
        
        // Special handling for status transitions
        if (BookRoom.STATUS_CHECKED_IN.equals(status)) {
            // When checking in, set check-in time if not set
            sql = "UPDATE bookings SET status = ?, updated_date = ?, check_in_time = COALESCE(check_in_time, ?) WHERE id = ?";
        } else if (BookRoom.STATUS_CHECKED_OUT.equals(status)) {
            // When checking out, set check-out time if not set
            sql = "UPDATE bookings SET status = ?, updated_date = ?, check_out_time = COALESCE(check_out_time, ?) WHERE id = ?";
        }
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            
            if (BookRoom.STATUS_CHECKED_IN.equals(status)) {
                stmt.setTime(3, Time.valueOf(LocalTime.now()));
                stmt.setInt(4, id);
            } else if (BookRoom.STATUS_CHECKED_OUT.equals(status)) {
                stmt.setTime(3, Time.valueOf(LocalTime.now()));
                stmt.setInt(4, id);
            } else {
                stmt.setInt(3, id);
            }
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // UPDATE COMPLETE BOOKING (for Staff)
    public boolean update(BookRoom booking) {
        String sql = "UPDATE bookings SET room_id = ?, guest_id = ?, check_in_date = ?, check_out_date = ?, " +
                     "check_in_time = ?, check_out_time = ?, special_requests = ?, total_price = ?, status = ?, " +
                     "updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, booking.getRoomId());
            stmt.setInt(2, booking.getGuestId());
            stmt.setDate(3, booking.getCheckInDate() != null ? Date.valueOf(booking.getCheckInDate()) : null);
            stmt.setDate(4, booking.getCheckOutDate() != null ? Date.valueOf(booking.getCheckOutDate()) : null);
            stmt.setTime(5, booking.getCheckInTime() != null ? Time.valueOf(booking.getCheckInTime()) : null);
            stmt.setTime(6, booking.getCheckOutTime() != null ? Time.valueOf(booking.getCheckOutTime()) : null);
            stmt.setString(7, booking.getSpecialRequests());
            stmt.setDouble(8, booking.getTotalPrice());
            stmt.setString(9, booking.getStatus());
            stmt.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(11, booking.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // AUTO UPDATE STATUS BASED ON DATES
    public void autoUpdateStatuses() {
        LocalDate today = LocalDate.now();
        
        // Check-in date is today or past -> update to checked_in if confirmed
        String checkInSql = "UPDATE bookings SET status = ?, updated_date = ?, check_in_time = COALESCE(check_in_time, ?) " +
                            "WHERE status = ? AND check_in_date <= ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(checkInSql)) {
            stmt.setString(1, BookRoom.STATUS_CHECKED_IN);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setTime(3, Time.valueOf(LocalTime.now()));
            stmt.setString(4, BookRoom.STATUS_CONFIRMED);
            stmt.setDate(5, Date.valueOf(today));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Check-out date is today or past -> update to checked_out if checked_in
        String checkOutSql = "UPDATE bookings SET status = ?, updated_date = ?, check_out_time = COALESCE(check_out_time, ?) " +
                             "WHERE status = ? AND check_out_date <= ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(checkOutSql)) {
            stmt.setString(1, BookRoom.STATUS_CHECKED_OUT);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setTime(3, Time.valueOf(LocalTime.now()));
            stmt.setString(4, BookRoom.STATUS_CHECKED_IN);
            stmt.setDate(5, Date.valueOf(today));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Past check-out -> update to completed if checked_out
        String completedSql = "UPDATE bookings SET status = ?, updated_date = ? " +
                              "WHERE status = ? AND check_out_date < ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(completedSql)) {
            stmt.setString(1, BookRoom.STATUS_COMPLETED);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(3, BookRoom.STATUS_CHECKED_OUT);
            stmt.setDate(4, Date.valueOf(today));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // COUNT METHODS
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM bookings";
        return executeCountQuery(sql);
    }
    
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status = ?";
        
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
    
    public int countByGuestId(int guestId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE guest_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, guestId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int countActiveBookings() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status IN (?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, BookRoom.STATUS_CONFIRMED);
            stmt.setString(2, BookRoom.STATUS_CHECKED_IN);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public double getTotalRevenueByDateRange(LocalDate startDate, LocalDate endDate) {
        String sql = "SELECT SUM(total_price) FROM bookings WHERE status IN (?, ?) " +
                     "AND check_out_date BETWEEN ? AND ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, BookRoom.STATUS_COMPLETED);
            stmt.setString(2, BookRoom.STATUS_CHECKED_OUT);
            stmt.setDate(3, Date.valueOf(startDate));
            stmt.setDate(4, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public double getMonthlyRevenue(int month, int year) {
        String sql = "SELECT SUM(total_price) FROM bookings WHERE status IN (?, ?) " +
                     "AND MONTH(check_out_date) = ? AND YEAR(check_out_date) = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, BookRoom.STATUS_COMPLETED);
            stmt.setString(2, BookRoom.STATUS_CHECKED_OUT);
            stmt.setInt(3, month);
            stmt.setInt(4, year);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public Stats getStats() {
        Stats stats = new Stats();
        stats.setTotal(countAll());
        stats.setPending(countByStatus(BookRoom.STATUS_PENDING));
        stats.setConfirmed(countByStatus(BookRoom.STATUS_CONFIRMED));
        stats.setCheckedIn(countByStatus(BookRoom.STATUS_CHECKED_IN));
        stats.setCheckedOut(countByStatus(BookRoom.STATUS_CHECKED_OUT));
        stats.setCompleted(countByStatus(BookRoom.STATUS_COMPLETED));
        stats.setCancelled(countByStatus(BookRoom.STATUS_CANCELLED));
        stats.setRejected(countByStatus(BookRoom.STATUS_REJECTED));
        stats.setActive(countActiveBookings());
        
        LocalDate today = LocalDate.now();
        stats.setTodayCheckIns(countTodayCheckIns());
        stats.setTodayCheckOuts(countTodayCheckOuts());
        
        return stats;
    }
    
    private int countTodayCheckIns() {
        LocalDate today = LocalDate.now();
        String sql = "SELECT COUNT(*) FROM bookings WHERE check_in_date = ? AND status IN (?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(today));
            stmt.setString(2, BookRoom.STATUS_CONFIRMED);
            stmt.setString(3, BookRoom.STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    private int countTodayCheckOuts() {
        LocalDate today = LocalDate.now();
        String sql = "SELECT COUNT(*) FROM bookings WHERE check_out_date = ? AND status = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(today));
            stmt.setString(2, BookRoom.STATUS_CHECKED_IN);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    private boolean isValidStaffStatus(String status) {
        return status.equals(BookRoom.STATUS_CONFIRMED) ||
               status.equals(BookRoom.STATUS_CHECKED_IN) ||
               status.equals(BookRoom.STATUS_CHECKED_OUT) ||
               status.equals(BookRoom.STATUS_COMPLETED) ||
               status.equals(BookRoom.STATUS_REJECTED);
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
    
    // Stats inner class
    public static class Stats {
        private int total;
        private int pending;
        private int confirmed;
        private int checkedIn;
        private int checkedOut;
        private int completed;
        private int cancelled;
        private int rejected;
        private int active;
        private int todayCheckIns;
        private int todayCheckOuts;
        
        public Stats() {}
        
        // Getters and Setters
        public int getTotal() { return total; }
        public void setTotal(int total) { this.total = total; }
        
        public int getPending() { return pending; }
        public void setPending(int pending) { this.pending = pending; }
        
        public int getConfirmed() { return confirmed; }
        public void setConfirmed(int confirmed) { this.confirmed = confirmed; }
        
        public int getCheckedIn() { return checkedIn; }
        public void setCheckedIn(int checkedIn) { this.checkedIn = checkedIn; }
        
        public int getCheckedOut() { return checkedOut; }
        public void setCheckedOut(int checkedOut) { this.checkedOut = checkedOut; }
        
        public int getCompleted() { return completed; }
        public void setCompleted(int completed) { this.completed = completed; }
        
        public int getCancelled() { return cancelled; }
        public void setCancelled(int cancelled) { this.cancelled = cancelled; }
        
        public int getRejected() { return rejected; }
        public void setRejected(int rejected) { this.rejected = rejected; }
        
        public int getActive() { return active; }
        public void setActive(int active) { this.active = active; }
        
        public int getTodayCheckIns() { return todayCheckIns; }
        public void setTodayCheckIns(int todayCheckIns) { this.todayCheckIns = todayCheckIns; }
        
        public int getTodayCheckOuts() { return todayCheckOuts; }
        public void setTodayCheckOuts(int todayCheckOuts) { this.todayCheckOuts = todayCheckOuts; }
    }
}