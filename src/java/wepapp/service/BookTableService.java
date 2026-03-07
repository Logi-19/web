// BookTableService.java
package wepapp.service;

import wepapp.dao.BookTableDAO;
import wepapp.dao.ManageTableDAO;
import wepapp.model.BookTable;
import wepapp.model.ManageTable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

// Strategy Pattern - Validation Strategy Interface
interface BookTableValidationStrategy {
    boolean validate(BookTable booking);
    String getErrorMessage();
}

// Required Fields Validation Strategy
class BookTableRequiredFieldsStrategy implements BookTableValidationStrategy {
    @Override
    public boolean validate(BookTable booking) {
        return booking.getTableId() > 0 && 
               booking.getGuestId() > 0 && 
               booking.getBookingDate() != null && 
               booking.getBookingTime() != null &&
               booking.getPartySize() > 0;
    }
    
    @Override
    public String getErrorMessage() {
        return "Table ID, Guest ID, Booking date, Booking time, and Party size are required";
    }
}

// Date Validation Strategy
class BookTableDateStrategy implements BookTableValidationStrategy {
    @Override
    public boolean validate(BookTable booking) {
        LocalDate today = LocalDate.now();
        LocalDate bookingDate = booking.getBookingDate();
        
        // Booking date cannot be in the past
        if (bookingDate.isBefore(today)) {
            return false;
        }
        
        // Can't book more than 30 days in advance
        long daysInAdvance = bookingDate.toEpochDay() - today.toEpochDay();
        return daysInAdvance <= 30;
    }
    
    @Override
    public String getErrorMessage() {
        return "Invalid date: Booking date must be today or future, and cannot be more than 30 days in advance";
    }
}

// Time Validation Strategy
class BookTableTimeStrategy implements BookTableValidationStrategy {
    private static final LocalTime EARLIEST_TIME = LocalTime.of(11, 0); // 11:00 AM
    private static final LocalTime LATEST_TIME = LocalTime.of(22, 0);  // 10:00 PM
    
    @Override
    public boolean validate(BookTable booking) {
        LocalTime bookingTime = booking.getBookingTime();
        
        // Check if within operating hours
        if (bookingTime.isBefore(EARLIEST_TIME) || bookingTime.isAfter(LATEST_TIME)) {
            return false;
        }
        
        // Check if time is on the hour or half-hour
        int minute = bookingTime.getMinute();
        return minute == 0 || minute == 30;
    }
    
    @Override
    public String getErrorMessage() {
        return "Invalid time: Bookings must be between 11:00 AM and 10:00 PM, on the hour or half-hour";
    }
}

// Party Size Validation Strategy
class BookTablePartySizeStrategy implements BookTableValidationStrategy {
    private ManageTableDAO tableDAO;
    
    public BookTablePartySizeStrategy() {
        this.tableDAO = ManageTableDAO.getInstance();
    }
    
    @Override
    public boolean validate(BookTable booking) {
        ManageTable table = tableDAO.findById(booking.getTableId());
        if (table == null) {
            return false;
        }
        
        // Party size must not exceed table capacity
        return booking.getPartySize() <= table.getCapacity();
    }
    
    @Override
    public String getErrorMessage() {
        return "Party size exceeds table capacity";
    }
}

// Main Service Class
public class BookTableService {
    private final BookTableDAO bookTableDAO;
    private final ManageTableDAO tableDAO;
    private final List<BookTableValidationStrategy> validators;
    
    public BookTableService() {
        this.bookTableDAO = BookTableDAO.getInstance();
        this.tableDAO = ManageTableDAO.getInstance();
        this.validators = List.of(
            new BookTableRequiredFieldsStrategy(),
            new BookTableDateStrategy(),
            new BookTableTimeStrategy(),
            new BookTablePartySizeStrategy()
        );
    }
    
    // Auto update statuses based on dates and times
    public void autoUpdateStatuses() {
        bookTableDAO.autoUpdateStatuses();
    }
    
    // Validate booking using all strategies
    public ValidationResult validateBooking(BookTable booking) {
        for (BookTableValidationStrategy validator : validators) {
            if (!validator.validate(booking)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Check if table is available for given date and time (only considers confirmed and pending bookings)
    public boolean isTableAvailable(int tableId, LocalDate date, LocalTime time, Integer excludeBookingId) {
        return bookTableDAO.isTableAvailable(tableId, date, time, excludeBookingId);
    }
    
    // Get booked times for a table on a specific date
    public List<LocalTime> getBookedTimes(int tableId, LocalDate date) {
        return bookTableDAO.findBookedTimes(tableId, date);
    }
    
    // Check if table has any bookings on a date
    public boolean hasBookingsOnDate(int tableId, LocalDate date) {
        return bookTableDAO.hasBookingsOnDate(tableId, date);
    }
    
    // CREATE - New table booking
    public ValidationResult createBooking(BookTable booking) {
        // Validate required fields
        if (booking.getTableId() <= 0) {
            return new ValidationResult(false, "Table ID is required");
        }
        if (booking.getGuestId() <= 0) {
            return new ValidationResult(false, "Guest ID is required");
        }
        if (booking.getBookingDate() == null) {
            return new ValidationResult(false, "Booking date is required");
        }
        if (booking.getBookingTime() == null) {
            return new ValidationResult(false, "Booking time is required");
        }
        if (booking.getPartySize() <= 0) {
            return new ValidationResult(false, "Party size is required and must be greater than 0");
        }
        
        // Validate using all strategies
        ValidationResult validationResult = validateBooking(booking);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if table is available (only confirmed and pending bookings block availability)
        if (!isTableAvailable(booking.getTableId(), booking.getBookingDate(), booking.getBookingTime(), null)) {
            return new ValidationResult(false, "Table is not available for the selected date and time");
        }
        
        // Get table details to verify capacity and status
        ManageTable table = tableDAO.findById(booking.getTableId());
        if (table == null) {
            return new ValidationResult(false, "Table not found");
        }
        
        // Check if table is available for booking
        if (!"available".equals(table.getStatus())) {
            return new ValidationResult(false, "Table is not available for booking (maintenance)");
        }
        
        // Verify party size against capacity
        if (booking.getPartySize() > table.getCapacity()) {
            return new ValidationResult(false, "Party size exceeds table capacity of " + table.getCapacity());
        }
        
        // Set defaults if not set
        if (booking.getStatus() == null) {
            booking.setStatus(BookTable.STATUS_PENDING);
        }
        if (booking.getCreatedDate() == null) {
            booking.setCreatedDate(LocalDateTime.now());
        }
        if (booking.getUpdatedDate() == null) {
            booking.setUpdatedDate(LocalDateTime.now());
        }
        
        // Save to database
        boolean saved = bookTableDAO.save(booking);
        
        if (saved) {
            return new ValidationResult(true, "Table booking created successfully. Reservation No: " + booking.getReservationNo());
        } else {
            return new ValidationResult(false, "Failed to create table booking");
        }
    }
    
    // READ ALL - Get all table bookings
    public List<BookTable> getAllBookings() {
        autoUpdateStatuses(); // Auto-update statuses before returning
        return bookTableDAO.findAll();
    }
    
    // READ BY ID - Get booking by ID
    public BookTable getBookingById(int id) {
        autoUpdateStatuses();
        return bookTableDAO.findById(id);
    }
    
    // READ BY RESERVATION NUMBER
    public BookTable getBookingByReservationNo(String reservationNo) {
        autoUpdateStatuses();
        return bookTableDAO.findByReservationNo(reservationNo);
    }
    
    // READ BY GUEST ID
    public List<BookTable> getBookingsByGuestId(int guestId) {
        autoUpdateStatuses();
        return bookTableDAO.findByGuestId(guestId);
    }
    
    // READ BY TABLE ID
    public List<BookTable> getBookingsByTableId(int tableId) {
        autoUpdateStatuses();
        return bookTableDAO.findByTableId(tableId);
    }
    
    // READ BY STATUS
    public List<BookTable> getBookingsByStatus(String status) {
        autoUpdateStatuses();
        return bookTableDAO.findByStatus(status);
    }
    
    // READ BY DATE
    public List<BookTable> getBookingsByDate(LocalDate date) {
        autoUpdateStatuses();
        return bookTableDAO.findByDate(date);
    }
    
    // READ BY DATE AND TABLE
    public List<BookTable> getBookingsByDateAndTable(LocalDate date, int tableId) {
        autoUpdateStatuses();
        return bookTableDAO.findByDateAndTable(date, tableId);
    }
    
    // READ UPCOMING BOOKINGS (confirmed and pending)
    public List<BookTable> getUpcomingBookings(LocalDate fromDate) {
        autoUpdateStatuses();
        return bookTableDAO.findUpcoming(fromDate);
    }
    
    // READ TODAY'S BOOKINGS
    public List<BookTable> getTodayBookings() {
        autoUpdateStatuses();
        return bookTableDAO.findTodayBookings();
    }
    
    // UPDATE STATUS BY GUEST (cancel their own pending or confirmed bookings)
    public ValidationResult cancelBookingByGuest(int bookingId, int guestId) {
        BookTable booking = bookTableDAO.findById(bookingId);
        
        if (booking == null) {
            return new ValidationResult(false, "Booking not found");
        }
        
        // Verify this booking belongs to the guest
        if (booking.getGuestId() != guestId) {
            return new ValidationResult(false, "You can only cancel your own bookings");
        }
        
        // Check if booking can be cancelled (pending or confirmed)
        if (!BookTable.STATUS_PENDING.equals(booking.getStatus()) && 
            !BookTable.STATUS_CONFIRMED.equals(booking.getStatus())) {
            return new ValidationResult(false, "Only pending or confirmed bookings can be cancelled");
        }
        
        // Check if booking is for today and time has passed
        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();
        
        if (booking.getBookingDate().equals(today) && booking.getBookingTime().isBefore(now)) {
            return new ValidationResult(false, "Cannot cancel a booking that has already passed");
        }
        
        boolean updated = bookTableDAO.updateStatusByGuest(bookingId, guestId);
        
        if (updated) {
            return new ValidationResult(true, "Booking cancelled successfully");
        } else {
            return new ValidationResult(false, "Failed to cancel booking");
        }
    }
    
    // UPDATE STATUS (public - can be used by staff)
    public ValidationResult updateBookingStatus(int bookingId, String newStatus) {
        BookTable booking = bookTableDAO.findById(bookingId);
        
        if (booking == null) {
            return new ValidationResult(false, "Booking not found");
        }
        
        // Define valid status transitions
        String currentStatus = booking.getStatus();
        boolean validTransition = false;
        
        switch (newStatus) {
            case BookTable.STATUS_CONFIRMED:
                validTransition = BookTable.STATUS_PENDING.equals(currentStatus);
                break;
            case BookTable.STATUS_SEATED:
                validTransition = BookTable.STATUS_CONFIRMED.equals(currentStatus);
                break;
            case BookTable.STATUS_COMPLETED:
                validTransition = BookTable.STATUS_SEATED.equals(currentStatus) ||
                                  BookTable.STATUS_CONFIRMED.equals(currentStatus);
                break;
            case BookTable.STATUS_REJECTED:
                validTransition = BookTable.STATUS_PENDING.equals(currentStatus);
                break;
            case BookTable.STATUS_NO_SHOW:
                validTransition = BookTable.STATUS_CONFIRMED.equals(currentStatus) ||
                                  BookTable.STATUS_PENDING.equals(currentStatus);
                break;
            case BookTable.STATUS_CANCELLED:
                validTransition = BookTable.STATUS_PENDING.equals(currentStatus) ||
                                  BookTable.STATUS_CONFIRMED.equals(currentStatus);
                break;
        }
        
        if (!validTransition) {
            return new ValidationResult(false, "Cannot change status from " + currentStatus + " to " + newStatus);
        }
        
        boolean updated = bookTableDAO.updateStatusByStaff(bookingId, newStatus);
        
        if (updated) {
            return new ValidationResult(true, "Booking status updated to " + newStatus);
        } else {
            return new ValidationResult(false, "Failed to update booking status");
        }
    }
    
    // UPDATE COMPLETE BOOKING
    public ValidationResult updateBooking(BookTable booking) {
        BookTable existingBooking = bookTableDAO.findById(booking.getId());
        
        if (existingBooking == null) {
            return new ValidationResult(false, "Booking not found");
        }
        
        // Validate if date/time changed, check availability
        if (!existingBooking.getBookingDate().equals(booking.getBookingDate()) ||
            !existingBooking.getBookingTime().equals(booking.getBookingTime())) {
            
            if (!isTableAvailable(booking.getTableId(), booking.getBookingDate(), 
                                 booking.getBookingTime(), booking.getId())) {
                return new ValidationResult(false, "Table is not available for the new date/time");
            }
        }
        
        // Validate party size against table capacity
        ManageTable table = tableDAO.findById(booking.getTableId());
        if (table != null && booking.getPartySize() > table.getCapacity()) {
            return new ValidationResult(false, "Party size exceeds table capacity of " + table.getCapacity());
        }
        
        // Update the booking
        booking.setUpdatedDate(LocalDateTime.now());
        boolean updated = bookTableDAO.update(booking);
        
        if (updated) {
            return new ValidationResult(true, "Booking updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update booking");
        }
    }
    
    // GET AVAILABLE TIME SLOTS FOR A TABLE ON A DATE
    public List<LocalTime> getAvailableTimeSlots(int tableId, LocalDate date) {
        List<LocalTime> allTimeSlots = generateTimeSlots();
        List<LocalTime> bookedTimes = bookTableDAO.findBookedTimes(tableId, date);
        
        // Remove booked times from all time slots
        allTimeSlots.removeAll(bookedTimes);
        
        return allTimeSlots;
    }
    
    // Generate all possible time slots (every 30 minutes from 11:00 to 22:00)
    private List<LocalTime> generateTimeSlots() {
        List<LocalTime> slots = new java.util.ArrayList<>();
        for (int hour = 11; hour <= 22; hour++) {
            for (int minute = 0; minute < 60; minute += 30) {
                if (hour == 22 && minute > 0) continue; // Last booking at 22:00
                slots.add(LocalTime.of(hour, minute));
            }
        }
        return slots;
    }
    
    // STATISTICS
    public int getTotalCount() {
        return bookTableDAO.countAll();
    }
    
    public int getCountByStatus(String status) {
        return bookTableDAO.countByStatus(status);
    }
    
    public int getCountByGuestId(int guestId) {
        return bookTableDAO.countByGuestId(guestId);
    }
    
    public int getCountByTableId(int tableId) {
        return bookTableDAO.countByTableId(tableId);
    }
    
    public int getActiveBookingsCount() {
        return bookTableDAO.countActiveBookings();
    }
    
    public int getTodayBookingsCount() {
        return bookTableDAO.countTodayBookings();
    }
    
    public BookTableDAO.Stats getStats() {
        autoUpdateStatuses();
        return bookTableDAO.getStats();
    }
    
    // Inner class for validation result
    public static class ValidationResult {
        private final boolean valid;
        private final String message;
        
        public ValidationResult(boolean valid, String message) {
            this.valid = valid;
            this.message = message;
        }
        
        public boolean isValid() { return valid; }
        public String getMessage() { return message; }
    }
}