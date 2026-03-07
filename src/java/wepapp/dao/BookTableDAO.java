// BookTableDAO.java
package wepapp.dao;

import wepapp.model.BookTable;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class BookTableDAO {
    
    // Singleton Pattern
    private static BookTableDAO instance;
    private Connection connection;
    
    private BookTableDAO() {
        this.connection = database.getConnection();
    }
    
    public static synchronized BookTableDAO getInstance() {
        if (instance == null) {
            instance = new BookTableDAO();
        }
        return instance;
    }
    
    // Generate Reservation Number (T-R-0000-0000 format)
    private String generateReservationNo() {
        String sql = "SELECT COUNT(*) FROM table_bookings";
        int count = 0;
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                count = rs.getInt(1) + 1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Format: T-R-XXXX-YYYY where X is sequence, Y is random
        String sequence = String.format("%04d", count);
        String randomPart = String.format("%04d", (int)(Math.random() * 10000));
        
        return "T-R-" + sequence + "-" + randomPart;
    }
    
    // Factory Method Pattern - creates BookTable from ResultSet with joined data
    private BookTable createBookTableFromResultSet(ResultSet rs) throws SQLException {
        BookTable booking = new BookTable();
        
        // Booking fields
        booking.setId(rs.getInt("id"));
        booking.setReservationNo(rs.getString("reservation_no"));
        booking.setTableId(rs.getInt("table_id"));
        booking.setGuestId(rs.getInt("guest_id"));
        
        Date bookingDateSql = rs.getDate("booking_date");
        if (bookingDateSql != null) {
            booking.setBookingDate(bookingDateSql.toLocalDate());
        }
        
        Time bookingTimeSql = rs.getTime("booking_time");
        if (bookingTimeSql != null) {
            booking.setBookingTime(bookingTimeSql.toLocalTime());
        }
        
        booking.setPartySize(rs.getInt("party_size"));
        booking.setSpecialRequests(rs.getString("special_requests"));
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
        
        // Try to get joined table data
        try {
            booking.setTableNo(rs.getString("table_no"));
            booking.setTablePrefix(rs.getString("table_prefix"));
            booking.setLocationName(rs.getString("location_name"));
            booking.setCapacity(rs.getInt("capacity"));
            
            // Try to get minimum spend if it exists in the table
            try {
                booking.setMinimumSpend(rs.getDouble("minimum_spend"));
            } catch (SQLException e) {
                // Column doesn't exist, set default
                booking.setMinimumSpend(0.0);
            }
        } catch (SQLException e) {
            // Columns don't exist in this query
        }
        
        return booking;
    }
    
    // CREATE - Insert new table booking
    public boolean save(BookTable booking) {
        String sql = "INSERT INTO table_bookings (reservation_no, table_id, guest_id, booking_date, booking_time, " +
                     "party_size, special_requests, status, created_date, updated_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        // Generate reservation number if not set
        if (booking.getReservationNo() == null || booking.getReservationNo().isEmpty()) {
            booking.setReservationNo(generateReservationNo());
        }
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, booking.getReservationNo());
            stmt.setInt(2, booking.getTableId());
            stmt.setInt(3, booking.getGuestId());
            stmt.setDate(4, booking.getBookingDate() != null ? Date.valueOf(booking.getBookingDate()) : null);
            stmt.setTime(5, booking.getBookingTime() != null ? Time.valueOf(booking.getBookingTime()) : null);
            stmt.setInt(6, booking.getPartySize());
            stmt.setString(7, booking.getSpecialRequests());
            stmt.setString(8, booking.getStatus() != null ? booking.getStatus() : BookTable.STATUS_PENDING);
            stmt.setTimestamp(9, booking.getCreatedDate() != null ? Timestamp.valueOf(booking.getCreatedDate()) : Timestamp.valueOf(LocalDateTime.now()));
            stmt.setTimestamp(10, booking.getUpdatedDate() != null ? Timestamp.valueOf(booking.getUpdatedDate()) : Timestamp.valueOf(LocalDateTime.now()));
            
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
    
    // READ ALL - Get all table bookings with guest and table details
    public List<BookTable> findAll() {
        List<BookTable> bookings = new ArrayList<>();
        String sql = "SELECT tb.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "mt.table_no, mt.table_prefix, tl.name as location_name, mt.capacity " +
                     "FROM table_bookings tb " +
                     "LEFT JOIN manage_guests g ON tb.guest_id = g.id " +
                     "LEFT JOIN manage_tables mt ON tb.table_id = mt.id " +
                     "LEFT JOIN table_locations tl ON mt.location_id = tl.id " +
                     "ORDER BY tb.booking_date DESC, tb.booking_time DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                bookings.add(createBookTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // READ BY ID - Get booking by ID with details
    public BookTable findById(int id) {
        String sql = "SELECT tb.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "mt.table_no, mt.table_prefix, tl.name as location_name, mt.capacity " +
                     "FROM table_bookings tb " +
                     "LEFT JOIN manage_guests g ON tb.guest_id = g.id " +
                     "LEFT JOIN manage_tables mt ON tb.table_id = mt.id " +
                     "LEFT JOIN table_locations tl ON mt.location_id = tl.id " +
                     "WHERE tb.id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createBookTableFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // FIND BY RESERVATION NUMBER
    public BookTable findByReservationNo(String reservationNo) {
        String sql = "SELECT tb.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "mt.table_no, mt.table_prefix, tl.name as location_name, mt.capacity " +
                     "FROM table_bookings tb " +
                     "LEFT JOIN manage_guests g ON tb.guest_id = g.id " +
                     "LEFT JOIN manage_tables mt ON tb.table_id = mt.id " +
                     "LEFT JOIN table_locations tl ON mt.location_id = tl.id " +
                     "WHERE tb.reservation_no = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, reservationNo);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createBookTableFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // FIND BY GUEST ID
    public List<BookTable> findByGuestId(int guestId) {
        List<BookTable> bookings = new ArrayList<>();
        String sql = "SELECT tb.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "mt.table_no, mt.table_prefix, tl.name as location_name, mt.capacity " +
                     "FROM table_bookings tb " +
                     "LEFT JOIN manage_guests g ON tb.guest_id = g.id " +
                     "LEFT JOIN manage_tables mt ON tb.table_id = mt.id " +
                     "LEFT JOIN table_locations tl ON mt.location_id = tl.id " +
                     "WHERE tb.guest_id = ? " +
                     "ORDER BY tb.booking_date DESC, tb.booking_time DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, guestId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND BY TABLE ID
    public List<BookTable> findByTableId(int tableId) {
        List<BookTable> bookings = new ArrayList<>();
        String sql = "SELECT tb.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "mt.table_no, mt.table_prefix, tl.name as location_name, mt.capacity " +
                     "FROM table_bookings tb " +
                     "LEFT JOIN manage_guests g ON tb.guest_id = g.id " +
                     "LEFT JOIN manage_tables mt ON tb.table_id = mt.id " +
                     "LEFT JOIN table_locations tl ON mt.location_id = tl.id " +
                     "WHERE tb.table_id = ? " +
                     "ORDER BY tb.booking_date DESC, tb.booking_time DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, tableId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND BY STATUS
    public List<BookTable> findByStatus(String status) {
        List<BookTable> bookings = new ArrayList<>();
        String sql = "SELECT tb.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "mt.table_no, mt.table_prefix, tl.name as location_name, mt.capacity " +
                     "FROM table_bookings tb " +
                     "LEFT JOIN manage_guests g ON tb.guest_id = g.id " +
                     "LEFT JOIN manage_tables mt ON tb.table_id = mt.id " +
                     "LEFT JOIN table_locations tl ON mt.location_id = tl.id " +
                     "WHERE tb.status = ? " +
                     "ORDER BY tb.booking_date DESC, tb.booking_time DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND BY DATE
    public List<BookTable> findByDate(LocalDate date) {
        List<BookTable> bookings = new ArrayList<>();
        String sql = "SELECT tb.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "mt.table_no, mt.table_prefix, tl.name as location_name, mt.capacity " +
                     "FROM table_bookings tb " +
                     "LEFT JOIN manage_guests g ON tb.guest_id = g.id " +
                     "LEFT JOIN manage_tables mt ON tb.table_id = mt.id " +
                     "LEFT JOIN table_locations tl ON mt.location_id = tl.id " +
                     "WHERE tb.booking_date = ? AND tb.status IN (?, ?) " +
                     "ORDER BY tb.booking_time";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(date));
            stmt.setString(2, BookTable.STATUS_CONFIRMED);
            stmt.setString(3, BookTable.STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND BY DATE AND TABLE
    public List<BookTable> findByDateAndTable(LocalDate date, int tableId) {
        List<BookTable> bookings = new ArrayList<>();
        String sql = "SELECT tb.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "mt.table_no, mt.table_prefix, tl.name as location_name, mt.capacity " +
                     "FROM table_bookings tb " +
                     "LEFT JOIN manage_guests g ON tb.guest_id = g.id " +
                     "LEFT JOIN manage_tables mt ON tb.table_id = mt.id " +
                     "LEFT JOIN table_locations tl ON mt.location_id = tl.id " +
                     "WHERE tb.booking_date = ? AND tb.table_id = ? AND tb.status IN (?, ?) " +
                     "ORDER BY tb.booking_time";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(date));
            stmt.setInt(2, tableId);
            stmt.setString(3, BookTable.STATUS_CONFIRMED);
            stmt.setString(4, BookTable.STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND BOOKED TIMES FOR TABLE ON DATE
    public List<LocalTime> findBookedTimes(int tableId, LocalDate date) {
        List<LocalTime> bookedTimes = new ArrayList<>();
        String sql = "SELECT booking_time FROM table_bookings WHERE table_id = ? AND booking_date = ? AND status IN (?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, tableId);
            stmt.setDate(2, Date.valueOf(date));
            stmt.setString(3, BookTable.STATUS_CONFIRMED);
            stmt.setString(4, BookTable.STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Time timeSql = rs.getTime("booking_time");
                if (timeSql != null) {
                    bookedTimes.add(timeSql.toLocalTime());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookedTimes;
    }
    
    // FIND UPCOMING BOOKINGS (future date) - Only confirmed and pending
    public List<BookTable> findUpcoming(LocalDate fromDate) {
        List<BookTable> bookings = new ArrayList<>();
        String sql = "SELECT tb.*, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone, " +
                     "mt.table_no, mt.table_prefix, tl.name as location_name, mt.capacity " +
                     "FROM table_bookings tb " +
                     "LEFT JOIN manage_guests g ON tb.guest_id = g.id " +
                     "LEFT JOIN manage_tables mt ON tb.table_id = mt.id " +
                     "LEFT JOIN table_locations tl ON mt.location_id = tl.id " +
                     "WHERE tb.booking_date >= ? AND tb.status IN (?, ?) " +
                     "ORDER BY tb.booking_date, tb.booking_time";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(fromDate));
            stmt.setString(2, BookTable.STATUS_CONFIRMED);
            stmt.setString(3, BookTable.STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND TODAY'S BOOKINGS
    public List<BookTable> findTodayBookings() {
        LocalDate today = LocalDate.now();
        return findByDate(today);
    }
    
    // CHECK TABLE AVAILABILITY - Only consider confirmed and pending bookings as occupied
    public boolean isTableAvailable(int tableId, LocalDate date, LocalTime time, Integer excludeBookingId) {
        String sql = "SELECT COUNT(*) FROM table_bookings WHERE table_id = ? AND booking_date = ? AND booking_time = ? AND status IN (?, ?)";
        
        if (excludeBookingId != null) {
            sql += " AND id != ?";
        }
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, tableId);
            stmt.setDate(2, Date.valueOf(date));
            stmt.setTime(3, Time.valueOf(time));
            stmt.setString(4, BookTable.STATUS_CONFIRMED);
            stmt.setString(5, BookTable.STATUS_PENDING);
            
            if (excludeBookingId != null) {
                stmt.setInt(6, excludeBookingId);
            }
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) == 0; // Available if count is 0
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // CHECK IF TABLE HAS ANY BOOKINGS ON DATE
    public boolean hasBookingsOnDate(int tableId, LocalDate date) {
        String sql = "SELECT COUNT(*) FROM table_bookings WHERE table_id = ? AND booking_date = ? AND status IN (?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, tableId);
            stmt.setDate(2, Date.valueOf(date));
            stmt.setString(3, BookTable.STATUS_CONFIRMED);
            stmt.setString(4, BookTable.STATUS_PENDING);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // UPDATE STATUS BY ID (for Guest - can only cancel their own pending or confirmed bookings)
    public boolean updateStatusByGuest(int id, int guestId) {
        // Guest can only cancel their own pending or confirmed bookings
        String sql = "UPDATE table_bookings SET status = ?, updated_date = ? WHERE id = ? AND guest_id = ? AND status IN (?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, BookTable.STATUS_CANCELLED);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, id);
            stmt.setInt(4, guestId);
            stmt.setString(5, BookTable.STATUS_PENDING);
            stmt.setString(6, BookTable.STATUS_CONFIRMED);
            
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
        
        String sql = "UPDATE table_bookings SET status = ?, updated_date = ? WHERE id = ?";
        
        // Special handling for status transitions
        if (BookTable.STATUS_SEATED.equals(status)) {
            // When seating, record the time
            sql = "UPDATE table_bookings SET status = ?, updated_date = ? WHERE id = ?";
        }
        
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
    
    // UPDATE COMPLETE BOOKING (for Staff)
    public boolean update(BookTable booking) {
        String sql = "UPDATE table_bookings SET table_id = ?, guest_id = ?, booking_date = ?, booking_time = ?, " +
                     "party_size = ?, special_requests = ?, status = ?, updated_date = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, booking.getTableId());
            stmt.setInt(2, booking.getGuestId());
            stmt.setDate(3, booking.getBookingDate() != null ? Date.valueOf(booking.getBookingDate()) : null);
            stmt.setTime(4, booking.getBookingTime() != null ? Time.valueOf(booking.getBookingTime()) : null);
            stmt.setInt(5, booking.getPartySize());
            stmt.setString(6, booking.getSpecialRequests());
            stmt.setString(7, booking.getStatus());
            stmt.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(9, booking.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // AUTO UPDATE STATUS BASED ON DATE AND TIME
    public void autoUpdateStatuses() {
        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();
        
        // Past bookings (date is before today) -> update to completed if confirmed
        String pastBookingsSql = "UPDATE table_bookings SET status = ?, updated_date = ? " +
                                 "WHERE status = ? AND booking_date < ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(pastBookingsSql)) {
            stmt.setString(1, BookTable.STATUS_COMPLETED);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(3, BookTable.STATUS_CONFIRMED);
            stmt.setDate(4, Date.valueOf(today));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Today's bookings that are past their time + 2 hours (dining time) -> update to completed
        String pastTimeSql = "UPDATE table_bookings SET status = ?, updated_date = ? " +
                            "WHERE status = ? AND booking_date = ? AND booking_time < ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(pastTimeSql)) {
            stmt.setString(1, BookTable.STATUS_COMPLETED);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(3, BookTable.STATUS_CONFIRMED);
            stmt.setDate(4, Date.valueOf(today));
            stmt.setTime(5, Time.valueOf(now.minusHours(2)));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // No-show: bookings that are 30 minutes past their time and still pending/confirmed
        String noShowSql = "UPDATE table_bookings SET status = ?, updated_date = ? " +
                          "WHERE status IN (?, ?) AND booking_date = ? AND booking_time < ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(noShowSql)) {
            stmt.setString(1, BookTable.STATUS_NO_SHOW);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(3, BookTable.STATUS_PENDING);
            stmt.setString(4, BookTable.STATUS_CONFIRMED);
            stmt.setDate(5, Date.valueOf(today));
            stmt.setTime(6, Time.valueOf(now.minusMinutes(30)));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // COUNT METHODS
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM table_bookings";
        return executeCountQuery(sql);
    }
    
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM table_bookings WHERE status = ?";
        
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
        String sql = "SELECT COUNT(*) FROM table_bookings WHERE guest_id = ?";
        
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
    
    public int countByTableId(int tableId) {
        String sql = "SELECT COUNT(*) FROM table_bookings WHERE table_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, tableId);
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
        String sql = "SELECT COUNT(*) FROM table_bookings WHERE status IN (?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, BookTable.STATUS_CONFIRMED);
            stmt.setString(2, BookTable.STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int countBookingsByDate(LocalDate date) {
        String sql = "SELECT COUNT(*) FROM table_bookings WHERE booking_date = ? AND status IN (?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(date));
            stmt.setString(2, BookTable.STATUS_CONFIRMED);
            stmt.setString(3, BookTable.STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int countTodayBookings() {
        return countBookingsByDate(LocalDate.now());
    }
    
    public Stats getStats() {
        Stats stats = new Stats();
        stats.setTotal(countAll());
        stats.setPending(countByStatus(BookTable.STATUS_PENDING));
        stats.setConfirmed(countByStatus(BookTable.STATUS_CONFIRMED));
        stats.setSeated(countByStatus(BookTable.STATUS_SEATED));
        stats.setCompleted(countByStatus(BookTable.STATUS_COMPLETED));
        stats.setCancelled(countByStatus(BookTable.STATUS_CANCELLED));
        stats.setRejected(countByStatus(BookTable.STATUS_REJECTED));
        stats.setNoShow(countByStatus(BookTable.STATUS_NO_SHOW));
        stats.setActive(countActiveBookings());
        stats.setTodayBookings(countTodayBookings());
        
        return stats;
    }
    
    private boolean isValidStaffStatus(String status) {
        return status.equals(BookTable.STATUS_CONFIRMED) ||
               status.equals(BookTable.STATUS_SEATED) ||
               status.equals(BookTable.STATUS_COMPLETED) ||
               status.equals(BookTable.STATUS_REJECTED) ||
               status.equals(BookTable.STATUS_NO_SHOW);
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
        private int seated;
        private int completed;
        private int cancelled;
        private int rejected;
        private int noShow;
        private int active;
        private int todayBookings;
        
        public Stats() {}
        
        // Getters and Setters
        public int getTotal() { return total; }
        public void setTotal(int total) { this.total = total; }
        
        public int getPending() { return pending; }
        public void setPending(int pending) { this.pending = pending; }
        
        public int getConfirmed() { return confirmed; }
        public void setConfirmed(int confirmed) { this.confirmed = confirmed; }
        
        public int getSeated() { return seated; }
        public void setSeated(int seated) { this.seated = seated; }
        
        public int getCompleted() { return completed; }
        public void setCompleted(int completed) { this.completed = completed; }
        
        public int getCancelled() { return cancelled; }
        public void setCancelled(int cancelled) { this.cancelled = cancelled; }
        
        public int getRejected() { return rejected; }
        public void setRejected(int rejected) { this.rejected = rejected; }
        
        public int getNoShow() { return noShow; }
        public void setNoShow(int noShow) { this.noShow = noShow; }
        
        public int getActive() { return active; }
        public void setActive(int active) { this.active = active; }
        
        public int getTodayBookings() { return todayBookings; }
        public void setTodayBookings(int todayBookings) { this.todayBookings = todayBookings; }
    }
}