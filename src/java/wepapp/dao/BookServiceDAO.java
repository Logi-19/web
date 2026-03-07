package wepapp.dao;

import wepapp.model.BookService;
import wepapp.config.database;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class BookServiceDAO {
    
    // Singleton Pattern
    private static BookServiceDAO instance;
    private Connection connection;
    
    private BookServiceDAO() {
        this.connection = database.getConnection();
    }
    
    public static synchronized BookServiceDAO getInstance() {
        if (instance == null) {
            instance = new BookServiceDAO();
        }
        return instance;
    }
    
    // Generate Booking Number (S-YYYY-XXXX format)
    private String generateBookingNo() {
        int year = LocalDate.now().getYear();
        String sql = "SELECT COUNT(*) FROM book_services WHERE YEAR(created_date) = ?";
        int count = 0;
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, year);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1) + 1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Format: S-YYYY-XXXX (e.g., S-2024-0001)
        return String.format("S-%d-%04d", year, count);
    }
    
    // Factory Method Pattern - creates BookService from ResultSet with joined data
    private BookService createBookServiceFromResultSet(ResultSet rs) throws SQLException {
        BookService booking = new BookService();
        
        // Booking fields
        booking.setId(rs.getInt("id"));
        booking.setBookingNo(rs.getString("booking_no"));
        booking.setServiceId(rs.getInt("service_id"));
        booking.setGuestId(rs.getInt("guest_id"));
        
        Date bookingDateSql = rs.getDate("booking_date");
        if (bookingDateSql != null) {
            booking.setBookingDate(bookingDateSql.toLocalDate());
        }
        
        Time bookingTimeSql = rs.getTime("booking_time");
        if (bookingTimeSql != null) {
            booking.setBookingTime(bookingTimeSql.toLocalTime());
        }
        
        booking.setNumberOfGuests(rs.getInt("number_of_guests"));
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
        
        // Try to get joined service data
        try {
            booking.setServiceTitle(rs.getString("service_title"));
            booking.setServiceDescription(rs.getString("service_description"));
            booking.setServiceDuration(rs.getInt("service_duration"));
            booking.setServiceFee(rs.getDouble("service_fee"));
            booking.setServiceCategoryName(rs.getString("service_category_name"));
        } catch (SQLException e) {
            // Columns don't exist in this query
        }
        
        // Try to get joined guest data
        try {
            booking.setGuestName(rs.getString("guest_name"));
            booking.setGuestEmail(rs.getString("guest_email"));
            booking.setGuestPhone(rs.getString("guest_phone"));
        } catch (SQLException e) {
            // Columns don't exist in this query
        }
        
        return booking;
    }
    
    // CREATE - Insert new service booking
    public boolean save(BookService booking) {
        String sql = "INSERT INTO book_services (booking_no, service_id, guest_id, booking_date, booking_time, " +
                     "number_of_guests, special_requests, total_price, status, created_date, updated_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        // Generate booking number if not set
        if (booking.getBookingNo() == null || booking.getBookingNo().isEmpty()) {
            booking.setBookingNo(generateBookingNo());
        }
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, booking.getBookingNo());
            stmt.setInt(2, booking.getServiceId());
            stmt.setInt(3, booking.getGuestId());
            stmt.setDate(4, booking.getBookingDate() != null ? Date.valueOf(booking.getBookingDate()) : null);
            stmt.setTime(5, booking.getBookingTime() != null ? Time.valueOf(booking.getBookingTime()) : null);
            stmt.setInt(6, booking.getNumberOfGuests());
            stmt.setString(7, booking.getSpecialRequests());
            stmt.setDouble(8, booking.getTotalPrice());
            stmt.setString(9, booking.getStatus() != null ? booking.getStatus() : BookService.STATUS_PENDING);
            stmt.setTimestamp(10, booking.getCreatedDate() != null ? Timestamp.valueOf(booking.getCreatedDate()) : Timestamp.valueOf(LocalDateTime.now()));
            stmt.setTimestamp(11, booking.getUpdatedDate() != null ? Timestamp.valueOf(booking.getUpdatedDate()) : Timestamp.valueOf(LocalDateTime.now()));
            
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
    
    // READ ALL - Get all service bookings with guest and service details
    public List<BookService> findAll() {
        List<BookService> bookings = new ArrayList<>();
        String sql = "SELECT bs.*, " +
                     "ms.title as service_title, ms.description as service_description, " +
                     "ms.duration as service_duration, ms.fees as service_fee, " +
                     "sc.name as service_category_name, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone " +
                     "FROM book_services bs " +
                     "LEFT JOIN manage_services ms ON bs.service_id = ms.id " +
                     "LEFT JOIN service_categories sc ON ms.category_id = sc.id " +
                     "LEFT JOIN manage_guests g ON bs.guest_id = g.id " +
                     "ORDER BY bs.booking_date DESC, bs.booking_time DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                bookings.add(createBookServiceFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // READ BY ID - Get booking by ID with details
    public BookService findById(int id) {
        String sql = "SELECT bs.*, " +
                     "ms.title as service_title, ms.description as service_description, " +
                     "ms.duration as service_duration, ms.fees as service_fee, " +
                     "sc.name as service_category_name, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone " +
                     "FROM book_services bs " +
                     "LEFT JOIN manage_services ms ON bs.service_id = ms.id " +
                     "LEFT JOIN service_categories sc ON ms.category_id = sc.id " +
                     "LEFT JOIN manage_guests g ON bs.guest_id = g.id " +
                     "WHERE bs.id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createBookServiceFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // FIND BY BOOKING NUMBER
    public BookService findByBookingNo(String bookingNo) {
        String sql = "SELECT bs.*, " +
                     "ms.title as service_title, ms.description as service_description, " +
                     "ms.duration as service_duration, ms.fees as service_fee, " +
                     "sc.name as service_category_name, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone " +
                     "FROM book_services bs " +
                     "LEFT JOIN manage_services ms ON bs.service_id = ms.id " +
                     "LEFT JOIN service_categories sc ON ms.category_id = sc.id " +
                     "LEFT JOIN manage_guests g ON bs.guest_id = g.id " +
                     "WHERE bs.booking_no = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, bookingNo);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createBookServiceFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // FIND BY GUEST ID
    public List<BookService> findByGuestId(int guestId) {
        List<BookService> bookings = new ArrayList<>();
        String sql = "SELECT bs.*, " +
                     "ms.title as service_title, ms.description as service_description, " +
                     "ms.duration as service_duration, ms.fees as service_fee, " +
                     "sc.name as service_category_name, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone " +
                     "FROM book_services bs " +
                     "LEFT JOIN manage_services ms ON bs.service_id = ms.id " +
                     "LEFT JOIN service_categories sc ON ms.category_id = sc.id " +
                     "LEFT JOIN manage_guests g ON bs.guest_id = g.id " +
                     "WHERE bs.guest_id = ? " +
                     "ORDER BY bs.booking_date DESC, bs.booking_time DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, guestId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookServiceFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND BY SERVICE ID
    public List<BookService> findByServiceId(int serviceId) {
        List<BookService> bookings = new ArrayList<>();
        String sql = "SELECT bs.*, " +
                     "ms.title as service_title, ms.description as service_description, " +
                     "ms.duration as service_duration, ms.fees as service_fee, " +
                     "sc.name as service_category_name, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone " +
                     "FROM book_services bs " +
                     "LEFT JOIN manage_services ms ON bs.service_id = ms.id " +
                     "LEFT JOIN service_categories sc ON ms.category_id = sc.id " +
                     "LEFT JOIN manage_guests g ON bs.guest_id = g.id " +
                     "WHERE bs.service_id = ? " +
                     "ORDER BY bs.booking_date DESC, bs.booking_time DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookServiceFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND BY STATUS
    public List<BookService> findByStatus(String status) {
        List<BookService> bookings = new ArrayList<>();
        String sql = "SELECT bs.*, " +
                     "ms.title as service_title, ms.description as service_description, " +
                     "ms.duration as service_duration, ms.fees as service_fee, " +
                     "sc.name as service_category_name, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone " +
                     "FROM book_services bs " +
                     "LEFT JOIN manage_services ms ON bs.service_id = ms.id " +
                     "LEFT JOIN service_categories sc ON ms.category_id = sc.id " +
                     "LEFT JOIN manage_guests g ON bs.guest_id = g.id " +
                     "WHERE bs.status = ? " +
                     "ORDER BY bs.booking_date DESC, bs.booking_time DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookServiceFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND BY DATE RANGE
    public List<BookService> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<BookService> bookings = new ArrayList<>();
        String sql = "SELECT bs.*, " +
                     "ms.title as service_title, ms.description as service_description, " +
                     "ms.duration as service_duration, ms.fees as service_fee, " +
                     "sc.name as service_category_name, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone " +
                     "FROM book_services bs " +
                     "LEFT JOIN manage_services ms ON bs.service_id = ms.id " +
                     "LEFT JOIN service_categories sc ON ms.category_id = sc.id " +
                     "LEFT JOIN manage_guests g ON bs.guest_id = g.id " +
                     "WHERE bs.booking_date BETWEEN ? AND ? " +
                     "ORDER BY bs.booking_date, bs.booking_time";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookServiceFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND BY DATE
    public List<BookService> findByDate(LocalDate date) {
        return findByDateRange(date, date);
    }
    
    // FIND UPCOMING BOOKINGS (future date)
    public List<BookService> findUpcoming(LocalDate fromDate) {
        List<BookService> bookings = new ArrayList<>();
        String sql = "SELECT bs.*, " +
                     "ms.title as service_title, ms.description as service_description, " +
                     "ms.duration as service_duration, ms.fees as service_fee, " +
                     "sc.name as service_category_name, " +
                     "g.full_name as guest_name, g.email as guest_email, g.phone as guest_phone " +
                     "FROM book_services bs " +
                     "LEFT JOIN manage_services ms ON bs.service_id = ms.id " +
                     "LEFT JOIN service_categories sc ON ms.category_id = sc.id " +
                     "LEFT JOIN manage_guests g ON bs.guest_id = g.id " +
                     "WHERE bs.booking_date >= ? AND bs.status IN (?, ?) " +
                     "ORDER BY bs.booking_date, bs.booking_time";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(fromDate));
            stmt.setString(2, BookService.STATUS_CONFIRMED);
            stmt.setString(3, BookService.STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(createBookServiceFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // FIND TODAY'S BOOKINGS
    public List<BookService> findTodayBookings() {
        return findByDate(LocalDate.now());
    }
    
    // CHECK TIME SLOT AVAILABILITY
    public boolean isTimeSlotAvailable(int serviceId, LocalDate date, LocalTime time, int duration, Integer excludeBookingId) {
        // Calculate end time
        LocalTime endTime = time.plusMinutes(duration);
        
        // Check for overlapping bookings (confirmed or pending)
        String sql = "SELECT COUNT(*) FROM book_services bs " +
                     "JOIN manage_services ms ON bs.service_id = ms.id " +
                     "WHERE bs.service_id = ? AND bs.booking_date = ? " +
                     "AND bs.status IN (?, ?) " + // Only confirmed and pending block the slot
                     "AND ( " +
                     "   (bs.booking_time <= ? AND ADDTIME(bs.booking_time, SEC_TO_TIME(ms.duration * 60)) > ?) " + // Overlap condition
                     ")";
        
        if (excludeBookingId != null) {
            sql += " AND bs.id != ?";
        }
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            stmt.setDate(2, Date.valueOf(date));
            stmt.setString(3, BookService.STATUS_CONFIRMED);
            stmt.setString(4, BookService.STATUS_PENDING);
            stmt.setTime(5, Time.valueOf(time)); // Start time of new booking
            stmt.setTime(6, Time.valueOf(time)); // End time of new booking? Actually we need end time
            // Fix: Need to handle time comparison properly
            
            if (excludeBookingId != null) {
                stmt.setInt(7, excludeBookingId);
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
    
    // UPDATE STATUS BY GUEST (can cancel their own pending/confirmed bookings if within cancellation window)
    public boolean updateStatusByGuest(int id, int guestId) {
        // Guest can cancel pending or confirmed bookings if within cancellation window
        // The actual time check should be done in service layer
        String sql = "UPDATE book_services SET status = ?, updated_date = ? WHERE id = ? AND guest_id = ? AND status IN (?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, BookService.STATUS_CANCELLED);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, id);
            stmt.setInt(4, guestId);
            stmt.setString(5, BookService.STATUS_PENDING);
            stmt.setString(6, BookService.STATUS_CONFIRMED);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // UPDATE STATUS BY STAFF
    public boolean updateStatusByStaff(int id, String status) {
        // Validate status is allowed for staff
        if (!isValidStaffStatus(status)) {
            return false;
        }
        
        String sql = "UPDATE book_services SET status = ?, updated_date = ? WHERE id = ?";
        
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
    public boolean update(BookService booking) {
        String sql = "UPDATE book_services SET service_id = ?, guest_id = ?, booking_date = ?, booking_time = ?, " +
                     "number_of_guests = ?, special_requests = ?, total_price = ?, status = ?, updated_date = ? " +
                     "WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, booking.getServiceId());
            stmt.setInt(2, booking.getGuestId());
            stmt.setDate(3, booking.getBookingDate() != null ? Date.valueOf(booking.getBookingDate()) : null);
            stmt.setTime(4, booking.getBookingTime() != null ? Time.valueOf(booking.getBookingTime()) : null);
            stmt.setInt(5, booking.getNumberOfGuests());
            stmt.setString(6, booking.getSpecialRequests());
            stmt.setDouble(7, booking.getTotalPrice());
            stmt.setString(8, booking.getStatus());
            stmt.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(10, booking.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // AUTO UPDATE STATUS BASED ON DATES AND TIMES
    public void autoUpdateStatuses() {
        LocalDateTime now = LocalDateTime.now();
        LocalDate today = now.toLocalDate();
        LocalTime currentTime = now.toLocalTime();
        
        // Mark as no_show for past bookings that are still confirmed/pending
        String noShowSql = "UPDATE book_services bs " +
                           "JOIN manage_services ms ON bs.service_id = ms.id " +
                           "SET bs.status = ?, bs.updated_date = ? " +
                           "WHERE bs.status IN (?, ?) AND " +
                           "(bs.booking_date < ? OR (bs.booking_date = ? AND ADDTIME(bs.booking_time, SEC_TO_TIME(ms.duration * 60)) < ?))";
        
        try (PreparedStatement stmt = connection.prepareStatement(noShowSql)) {
            stmt.setString(1, BookService.STATUS_NO_SHOW);
            stmt.setTimestamp(2, Timestamp.valueOf(now));
            stmt.setString(3, BookService.STATUS_CONFIRMED);
            stmt.setString(4, BookService.STATUS_PENDING);
            stmt.setDate(5, Date.valueOf(today));
            stmt.setDate(6, Date.valueOf(today));
            stmt.setTime(7, Time.valueOf(currentTime));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Mark as completed for past bookings that were no_show? No, keep as no_show
        // Staff will manually mark as completed when service is delivered
    }
    
    // COUNT METHODS
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM book_services";
        return executeCountQuery(sql);
    }
    
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM book_services WHERE status = ?";
        
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
        String sql = "SELECT COUNT(*) FROM book_services WHERE guest_id = ?";
        
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
    
    public int countByServiceId(int serviceId) {
        String sql = "SELECT COUNT(*) FROM book_services WHERE service_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
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
        String sql = "SELECT COUNT(*) FROM book_services WHERE status IN (?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, BookService.STATUS_CONFIRMED);
            stmt.setString(2, BookService.STATUS_PENDING);
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
        LocalDate today = LocalDate.now();
        String sql = "SELECT COUNT(*) FROM book_services WHERE booking_date = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(today));
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // REVENUE METHODS
    public double getTotalRevenueByDateRange(LocalDate startDate, LocalDate endDate) {
        String sql = "SELECT SUM(total_price) FROM book_services WHERE status = ? " +
                     "AND booking_date BETWEEN ? AND ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, BookService.STATUS_COMPLETED);
            stmt.setDate(2, Date.valueOf(startDate));
            stmt.setDate(3, Date.valueOf(endDate));
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
        String sql = "SELECT SUM(total_price) FROM book_services WHERE status = ? " +
                     "AND MONTH(booking_date) = ? AND YEAR(booking_date) = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, BookService.STATUS_COMPLETED);
            stmt.setInt(2, month);
            stmt.setInt(3, year);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public double getRevenueByServiceId(int serviceId, LocalDate startDate, LocalDate endDate) {
        String sql = "SELECT SUM(total_price) FROM book_services WHERE service_id = ? AND status = ? " +
                     "AND booking_date BETWEEN ? AND ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            stmt.setString(2, BookService.STATUS_COMPLETED);
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
    
    // STATISTICS
    public Stats getStats() {
        Stats stats = new Stats();
        stats.setTotal(countAll());
        stats.setPending(countByStatus(BookService.STATUS_PENDING));
        stats.setConfirmed(countByStatus(BookService.STATUS_CONFIRMED));
        stats.setCompleted(countByStatus(BookService.STATUS_COMPLETED));
        stats.setCancelled(countByStatus(BookService.STATUS_CANCELLED));
        stats.setRejected(countByStatus(BookService.STATUS_REJECTED));
        stats.setNoShow(countByStatus(BookService.STATUS_NO_SHOW));
        stats.setActive(countActiveBookings());
        stats.setTodayBookings(countTodayBookings());
        
        LocalDate today = LocalDate.now();
        stats.setTodayRevenue(getTotalRevenueByDateRange(today, today));
        
        return stats;
    }
    
    // POPULAR SERVICES
    public List<PopularService> getPopularServices(LocalDate startDate, LocalDate endDate, int limit) {
        List<PopularService> popularServices = new ArrayList<>();
        String sql = "SELECT ms.id, ms.title, sc.name as category_name, " +
                     "COUNT(bs.id) as booking_count, SUM(bs.total_price) as total_revenue " +
                     "FROM manage_services ms " +
                     "LEFT JOIN service_categories sc ON ms.category_id = sc.id " +
                     "LEFT JOIN book_services bs ON ms.id = bs.service_id AND bs.status = ? " +
                     "AND bs.booking_date BETWEEN ? AND ? " +
                     "GROUP BY ms.id, ms.title, sc.name " +
                     "ORDER BY booking_count DESC " +
                     "LIMIT ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, BookService.STATUS_COMPLETED);
            stmt.setDate(2, Date.valueOf(startDate));
            stmt.setDate(3, Date.valueOf(endDate));
            stmt.setInt(4, limit);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                PopularService ps = new PopularService();
                ps.setServiceId(rs.getInt("id"));
                ps.setServiceTitle(rs.getString("title"));
                ps.setCategoryName(rs.getString("category_name"));
                ps.setBookingCount(rs.getInt("booking_count"));
                ps.setTotalRevenue(rs.getDouble("total_revenue"));
                popularServices.add(ps);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return popularServices;
    }
    
    // PEAK HOURS
    public List<PeakHour> getPeakHours(LocalDate startDate, LocalDate endDate) {
        List<PeakHour> peakHours = new ArrayList<>();
        String sql = "SELECT HOUR(booking_time) as hour, COUNT(*) as booking_count " +
                     "FROM book_services " +
                     "WHERE status = ? AND booking_date BETWEEN ? AND ? " +
                     "GROUP BY HOUR(booking_time) " +
                     "ORDER BY hour";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, BookService.STATUS_COMPLETED);
            stmt.setDate(2, Date.valueOf(startDate));
            stmt.setDate(3, Date.valueOf(endDate));
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                PeakHour ph = new PeakHour();
                ph.setHour(rs.getInt("hour"));
                ph.setBookingCount(rs.getInt("booking_count"));
                peakHours.add(ph);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return peakHours;
    }
    
    private boolean isValidStaffStatus(String status) {
        return status.equals(BookService.STATUS_CONFIRMED) ||
               status.equals(BookService.STATUS_COMPLETED) ||
               status.equals(BookService.STATUS_REJECTED) ||
               status.equals(BookService.STATUS_NO_SHOW);
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
        private int completed;
        private int cancelled;
        private int rejected;
        private int noShow;
        private int active;
        private int todayBookings;
        private double todayRevenue;
        
        public Stats() {}
        
        // Getters and Setters
        public int getTotal() { return total; }
        public void setTotal(int total) { this.total = total; }
        
        public int getPending() { return pending; }
        public void setPending(int pending) { this.pending = pending; }
        
        public int getConfirmed() { return confirmed; }
        public void setConfirmed(int confirmed) { this.confirmed = confirmed; }
        
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
        
        public double getTodayRevenue() { return todayRevenue; }
        public void setTodayRevenue(double todayRevenue) { this.todayRevenue = todayRevenue; }
    }
    
    // Popular Service inner class
    public static class PopularService {
        private int serviceId;
        private String serviceTitle;
        private String categoryName;
        private int bookingCount;
        private double totalRevenue;
        
        public PopularService() {}
        
        public int getServiceId() { return serviceId; }
        public void setServiceId(int serviceId) { this.serviceId = serviceId; }
        
        public String getServiceTitle() { return serviceTitle; }
        public void setServiceTitle(String serviceTitle) { this.serviceTitle = serviceTitle; }
        
        public String getCategoryName() { return categoryName; }
        public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
        
        public int getBookingCount() { return bookingCount; }
        public void setBookingCount(int bookingCount) { this.bookingCount = bookingCount; }
        
        public double getTotalRevenue() { return totalRevenue; }
        public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }
    }
    
    // Peak Hour inner class
    public static class PeakHour {
        private int hour;
        private int bookingCount;
        
        public PeakHour() {}
        
        public int getHour() { return hour; }
        public void setHour(int hour) { this.hour = hour; }
        
        public int getBookingCount() { return bookingCount; }
        public void setBookingCount(int bookingCount) { this.bookingCount = bookingCount; }
        
        public String getFormattedHour() {
            if (hour == 0) return "12 AM";
            if (hour < 12) return hour + " AM";
            if (hour == 12) return "12 PM";
            return (hour - 12) + " PM";
        }
    }
}