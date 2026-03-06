package wepapp.service;

import wepapp.dao.BookRoomDAO;
import wepapp.dao.ManageRoomDAO;
import wepapp.model.BookRoom;
import wepapp.model.ManageRoom;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

// Strategy Pattern - Validation Strategy Interface
interface BookRoomValidationStrategy {
    boolean validate(BookRoom booking);
    String getErrorMessage();
}

// Required Fields Validation Strategy
class BookRoomRequiredFieldsStrategy implements BookRoomValidationStrategy {
    @Override
    public boolean validate(BookRoom booking) {
        return booking.getRoomId() > 0 && 
               booking.getGuestId() > 0 && 
               booking.getCheckInDate() != null && 
               booking.getCheckOutDate() != null &&
               booking.getCheckInTime() != null;
    }
    
    @Override
    public String getErrorMessage() {
        return "Room ID, Guest ID, Check-in date, Check-out date, and Check-in time are required";
    }
}

// Date Validation Strategy
class BookRoomDateStrategy implements BookRoomValidationStrategy {
    @Override
    public boolean validate(BookRoom booking) {
        LocalDate today = LocalDate.now();
        LocalDate checkIn = booking.getCheckInDate();
        LocalDate checkOut = booking.getCheckOutDate();
        
        // Check-in cannot be in the past
        if (checkIn.isBefore(today)) {
            return false;
        }
        
        // Check-out must be after check-in
        if (!checkOut.isAfter(checkIn)) {
            return false;
        }
        
        // Maximum stay of 30 days
        long nights = checkOut.toEpochDay() - checkIn.toEpochDay();
        return nights <= 30;
    }
    
    @Override
    public String getErrorMessage() {
        return "Invalid dates: Check-in must be today or future, check-out must be after check-in, and maximum stay is 30 days";
    }
}

// Price Validation Strategy
class BookRoomPriceStrategy implements BookRoomValidationStrategy {
    private static final double MIN_PRICE = 0;
    private static final double MAX_PRICE = 100000;
    
    @Override
    public boolean validate(BookRoom booking) {
        return booking.getTotalPrice() >= MIN_PRICE && booking.getTotalPrice() <= MAX_PRICE;
    }
    
    @Override
    public String getErrorMessage() {
        return "Total price must be between $" + MIN_PRICE + " and $" + MAX_PRICE;
    }
}

// Main Service Class
public class BookRoomService {
    private final BookRoomDAO bookRoomDAO;
    private final ManageRoomDAO roomDAO;
    private final List<BookRoomValidationStrategy> validators;
    
    public BookRoomService() {
        this.bookRoomDAO = BookRoomDAO.getInstance();
        this.roomDAO = ManageRoomDAO.getInstance();
        this.validators = List.of(
            new BookRoomRequiredFieldsStrategy(),
            new BookRoomDateStrategy(),
            new BookRoomPriceStrategy()
        );
    }
    
    // Auto update statuses based on dates
    public void autoUpdateStatuses() {
        bookRoomDAO.autoUpdateStatuses();
    }
    
    // Validate booking using all strategies
    public ValidationResult validateBooking(BookRoom booking) {
        for (BookRoomValidationStrategy validator : validators) {
            if (!validator.validate(booking)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Check if room is available for given dates (only considers confirmed bookings)
    public boolean isRoomAvailable(int roomId, LocalDate checkIn, LocalDate checkOut, Integer excludeBookingId) {
        return bookRoomDAO.isRoomAvailable(roomId, checkIn, checkOut, excludeBookingId);
    }
    
    // Calculate total price based on room rate and nights
    public double calculateTotalPrice(int roomId, LocalDate checkIn, LocalDate checkOut) {
        ManageRoom room = roomDAO.findById(roomId);
        if (room == null) {
            return 0;
        }
        
        long nights = checkOut.toEpochDay() - checkIn.toEpochDay();
        return room.getPrice() * nights;
    }
    
    // CREATE - New booking
    public ValidationResult createBooking(BookRoom booking) {
        // Validate required fields
        if (booking.getRoomId() <= 0) {
            return new ValidationResult(false, "Room ID is required");
        }
        if (booking.getGuestId() <= 0) {
            return new ValidationResult(false, "Guest ID is required");
        }
        if (booking.getCheckInDate() == null) {
            return new ValidationResult(false, "Check-in date is required");
        }
        if (booking.getCheckOutDate() == null) {
            return new ValidationResult(false, "Check-out date is required");
        }
        if (booking.getCheckInTime() == null) {
            return new ValidationResult(false, "Check-in time is required");
        }
        
        // Validate dates
        ValidationResult validationResult = validateBooking(booking);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Check if room is available (only confirmed bookings block availability)
        if (!isRoomAvailable(booking.getRoomId(), booking.getCheckInDate(), booking.getCheckOutDate(), null)) {
            return new ValidationResult(false, "Room is not available for the selected dates (already confirmed)");
        }
        
        // Get room details to verify price
        ManageRoom room = roomDAO.findById(booking.getRoomId());
        if (room == null) {
            return new ValidationResult(false, "Room not found");
        }
        
        // Check if room is available for booking
        if (!"available".equals(room.getStatus())) {
            return new ValidationResult(false, "Room is not available for booking (maintenance)");
        }
        
        // Set defaults if not set
        if (booking.getStatus() == null) {
            booking.setStatus(BookRoom.STATUS_PENDING);
        }
        if (booking.getCreatedDate() == null) {
            booking.setCreatedDate(LocalDateTime.now());
        }
        if (booking.getUpdatedDate() == null) {
            booking.setUpdatedDate(LocalDateTime.now());
        }
        
        // Calculate total price if not set
        if (booking.getTotalPrice() <= 0) {
            long nights = booking.getCheckOutDate().toEpochDay() - booking.getCheckInDate().toEpochDay();
            booking.setTotalPrice(room.getPrice() * nights);
        }
        
        // Set check-out time to match check-in time (24-hour basis)
        if (booking.getCheckOutTime() == null) {
            booking.setCheckOutTime(booking.getCheckInTime()); 
        }
        
        // Save to database
        boolean saved = bookRoomDAO.save(booking);
        
        if (saved) {
            return new ValidationResult(true, "Booking created successfully. Reservation No: " + booking.getReservationNo());
        } else {
            return new ValidationResult(false, "Failed to create booking");
        }
    }
    
    // READ ALL - Get all bookings
    public List<BookRoom> getAllBookings() {
        autoUpdateStatuses(); // Auto-update statuses before returning
        return bookRoomDAO.findAll();
    }
    
    // READ BY ID - Get booking by ID
    public BookRoom getBookingById(int id) {
        autoUpdateStatuses();
        return bookRoomDAO.findById(id);
    }
    
    // READ BY RESERVATION NUMBER
    public BookRoom getBookingByReservationNo(String reservationNo) {
        autoUpdateStatuses();
        return bookRoomDAO.findByReservationNo(reservationNo);
    }
    
    // READ BY GUEST ID
    public List<BookRoom> getBookingsByGuestId(int guestId) {
        autoUpdateStatuses();
        return bookRoomDAO.findByGuestId(guestId);
    }
    
    // READ BY ROOM ID
    public List<BookRoom> getBookingsByRoomId(int roomId) {
        autoUpdateStatuses();
        return bookRoomDAO.findByRoomId(roomId);
    }
    
    // READ BY STATUS
    public List<BookRoom> getBookingsByStatus(String status) {
        autoUpdateStatuses();
        return bookRoomDAO.findByStatus(status);
    }
    
    // READ UPCOMING BOOKINGS (confirmed and pending)
    public List<BookRoom> getUpcomingBookings(LocalDate fromDate) {
        autoUpdateStatuses();
        return bookRoomDAO.findUpcoming(fromDate);
    }
    
    // READ TODAY'S CHECK-INS (confirmed and pending)
    public List<BookRoom> getTodayCheckIns() {
        autoUpdateStatuses();
        return bookRoomDAO.findTodayCheckIns();
    }
    
    // READ TODAY'S CHECK-OUTS (checked_in)
    public List<BookRoom> getTodayCheckOuts() {
        autoUpdateStatuses();
        return bookRoomDAO.findTodayCheckOuts();
    }
    
    // UPDATE STATUS BY GUEST (cancel their own pending bookings)
    public ValidationResult cancelBookingByGuest(int bookingId, int guestId) {
        BookRoom booking = bookRoomDAO.findById(bookingId);
        
        if (booking == null) {
            return new ValidationResult(false, "Booking not found");
        }
        
        // Verify this booking belongs to the guest
        if (booking.getGuestId() != guestId) {
            return new ValidationResult(false, "You can only cancel your own bookings");
        }
        
        // Check if booking can be cancelled (only pending)
        if (!BookRoom.STATUS_PENDING.equals(booking.getStatus())) {
            return new ValidationResult(false, "Only pending bookings can be cancelled");
        }
        
        boolean updated = bookRoomDAO.updateStatusByGuest(bookingId, guestId);
        
        if (updated) {
            return new ValidationResult(true, "Booking cancelled successfully");
        } else {
            return new ValidationResult(false, "Failed to cancel booking");
        }
    }
    
    // UPDATE STATUS (public - can be used by staff)
    public ValidationResult updateBookingStatus(int bookingId, String newStatus) {
        BookRoom booking = bookRoomDAO.findById(bookingId);
        
        if (booking == null) {
            return new ValidationResult(false, "Booking not found");
        }
        
        // Define valid status transitions
        String currentStatus = booking.getStatus();
        boolean validTransition = false;
        
        switch (newStatus) {
            case BookRoom.STATUS_CONFIRMED:
                validTransition = BookRoom.STATUS_PENDING.equals(currentStatus);
                break;
            case BookRoom.STATUS_CHECKED_IN:
                validTransition = BookRoom.STATUS_CONFIRMED.equals(currentStatus) ||
                                  BookRoom.STATUS_PENDING.equals(currentStatus);
                break;
            case BookRoom.STATUS_CHECKED_OUT:
                validTransition = BookRoom.STATUS_CHECKED_IN.equals(currentStatus);
                break;
            case BookRoom.STATUS_COMPLETED:
                validTransition = BookRoom.STATUS_CHECKED_OUT.equals(currentStatus);
                break;
            case BookRoom.STATUS_REJECTED:
                validTransition = BookRoom.STATUS_PENDING.equals(currentStatus) ||
                                  BookRoom.STATUS_CONFIRMED.equals(currentStatus);
                break;
            case BookRoom.STATUS_CANCELLED:
                validTransition = BookRoom.STATUS_PENDING.equals(currentStatus) ||
                                  BookRoom.STATUS_CONFIRMED.equals(currentStatus);
                break;
        }
        
        if (!validTransition) {
            return new ValidationResult(false, "Cannot change status from " + currentStatus + " to " + newStatus);
        }
        
        boolean updated = bookRoomDAO.updateStatusByStaff(bookingId, newStatus);
        
        if (updated) {
            return new ValidationResult(true, "Booking status updated to " + newStatus);
        } else {
            return new ValidationResult(false, "Failed to update booking status");
        }
    }
    
    // UPDATE COMPLETE BOOKING
    public ValidationResult updateBooking(BookRoom booking) {
        BookRoom existingBooking = bookRoomDAO.findById(booking.getId());
        
        if (existingBooking == null) {
            return new ValidationResult(false, "Booking not found");
        }
        
        // Validate if dates changed, check availability (only confirmed bookings block)
        if (!existingBooking.getCheckInDate().equals(booking.getCheckInDate()) ||
            !existingBooking.getCheckOutDate().equals(booking.getCheckOutDate())) {
            
            if (!isRoomAvailable(booking.getRoomId(), booking.getCheckInDate(), 
                                 booking.getCheckOutDate(), booking.getId())) {
                return new ValidationResult(false, "Room is not available for the new dates (already confirmed)");
            }
        }
        
        // Update the booking
        booking.setUpdatedDate(LocalDateTime.now());
        boolean updated = bookRoomDAO.update(booking);
        
        if (updated) {
            return new ValidationResult(true, "Booking updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update booking");
        }
    }
    
    // STATISTICS
    public int getTotalCount() {
        return bookRoomDAO.countAll();
    }
    
    public int getCountByStatus(String status) {
        return bookRoomDAO.countByStatus(status);
    }
    
    public int getCountByGuestId(int guestId) {
        return bookRoomDAO.countByGuestId(guestId);
    }
    
    public int getActiveBookingsCount() {
        return bookRoomDAO.countActiveBookings();
    }
    
    public double getTotalRevenueByDateRange(LocalDate startDate, LocalDate endDate) {
        return bookRoomDAO.getTotalRevenueByDateRange(startDate, endDate);
    }
    
    public double getMonthlyRevenue(int month, int year) {
        return bookRoomDAO.getMonthlyRevenue(month, year);
    }
    
    public BookRoomDAO.Stats getStats() {
        autoUpdateStatuses();
        return bookRoomDAO.getStats();
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