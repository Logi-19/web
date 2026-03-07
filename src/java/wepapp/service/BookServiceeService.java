package wepapp.service;

import wepapp.dao.BookServiceDAO;
import wepapp.dao.ManageServiceDAO;
import wepapp.model.BookService;
import wepapp.model.ManageService;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

// Strategy Pattern - Validation Strategy Interface
interface BookServiceValidationStrategy {
    boolean validate(BookService booking);
    String getErrorMessage();
}

// Required Fields Validation Strategy
class BookServiceRequiredFieldsStrategy implements BookServiceValidationStrategy {
    @Override
    public boolean validate(BookService booking) {
        return booking.getServiceId() > 0 && 
               booking.getGuestId() > 0 && 
               booking.getBookingDate() != null && 
               booking.getBookingTime() != null &&
               booking.getNumberOfGuests() > 0;
    }
    
    @Override
    public String getErrorMessage() {
        return "Service ID, Guest ID, Booking date, Booking time, and Number of guests are required";
    }
}

// Date Validation Strategy
class BookServiceDateStrategy implements BookServiceValidationStrategy {
    @Override
    public boolean validate(BookService booking) {
        LocalDate today = LocalDate.now();
        LocalDate bookingDate = booking.getBookingDate();
        LocalTime bookingTime = booking.getBookingTime();
        LocalTime now = LocalTime.now();
        
        // Booking date cannot be in the past
        if (bookingDate.isBefore(today)) {
            return false;
        }
        
        // If booking is today, time must be at least 2 hours from now
        if (bookingDate.equals(today)) {
            return bookingTime.isAfter(now.plusHours(2));
        }
        
        // Maximum booking window of 3 months
        LocalDate maxDate = today.plusMonths(3);
        return !bookingDate.isAfter(maxDate);
    }
    
    @Override
    public String getErrorMessage() {
        return "Invalid date: Bookings must be at least 2 hours in advance and within 3 months";
    }
}

// Guests Validation Strategy
class BookServiceGuestsStrategy implements BookServiceValidationStrategy {
    private static final int MIN_GUESTS = 1;
    private static final int MAX_GUESTS = 10;
    
    @Override
    public boolean validate(BookService booking) {
        int guests = booking.getNumberOfGuests();
        return guests >= MIN_GUESTS && guests <= MAX_GUESTS;
    }
    
    @Override
    public String getErrorMessage() {
        return "Number of guests must be between 1 and 10";
    }
}

// Price Validation Strategy
class BookServicePriceStrategy implements BookServiceValidationStrategy {
    private static final double MIN_PRICE = 0;
    private static final double MAX_PRICE = 1000000;
    
    @Override
    public boolean validate(BookService booking) {
        return booking.getTotalPrice() >= MIN_PRICE && booking.getTotalPrice() <= MAX_PRICE;
    }
    
    @Override
    public String getErrorMessage() {
        return "Total price must be between LKR " + MIN_PRICE + " and LKR " + MAX_PRICE;
    }
}

// Main Service Class
public class BookServiceeService {
    private final BookServiceDAO bookServiceDAO;
    private final ManageServiceDAO serviceDAO;
    private final List<BookServiceValidationStrategy> validators;
    
    public BookServiceeService() {
        this.bookServiceDAO = BookServiceDAO.getInstance();
        this.serviceDAO = ManageServiceDAO.getInstance();
        this.validators = List.of(
            new BookServiceRequiredFieldsStrategy(),
            new BookServiceDateStrategy(),
            new BookServiceGuestsStrategy(),
            new BookServicePriceStrategy()
        );
    }
    
    // Auto update statuses based on dates and times
    public void autoUpdateStatuses() {
        bookServiceDAO.autoUpdateStatuses();
    }
    
    // Validate booking using all strategies
    public ValidationResult validateBooking(BookService booking) {
        for (BookServiceValidationStrategy validator : validators) {
            if (!validator.validate(booking)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Check if time slot is available
    public boolean isTimeSlotAvailable(int serviceId, LocalDate date, LocalTime time, Integer excludeBookingId) {
        ManageService service = serviceDAO.findById(serviceId);
        if (service == null) {
            return false;
        }
        return bookServiceDAO.isTimeSlotAvailable(serviceId, date, time, service.getDuration(), excludeBookingId);
    }
    
    // Get available time slots for a service on a given date
    public List<LocalTime> getAvailableTimeSlots(int serviceId, LocalDate date) {
        ManageService service = serviceDAO.findById(serviceId);
        if (service == null) {
            return List.of();
        }
        
        // Define business hours (9 AM to 8 PM)
        List<LocalTime> allSlots = List.of(
            LocalTime.of(9, 0), LocalTime.of(10, 0), LocalTime.of(11, 0), LocalTime.of(12, 0),
            LocalTime.of(13, 0), LocalTime.of(14, 0), LocalTime.of(15, 0), LocalTime.of(16, 0),
            LocalTime.of(17, 0), LocalTime.of(18, 0), LocalTime.of(19, 0), LocalTime.of(20, 0)
        );
        
        // Filter out unavailable slots
        return allSlots.stream()
            .filter(time -> isTimeSlotAvailable(serviceId, date, time, null))
            .toList();
    }
    
    // Calculate total price based on service fee and number of guests
    public double calculateTotalPrice(int serviceId, int numberOfGuests) {
        ManageService service = serviceDAO.findById(serviceId);
        if (service == null) {
            return 0;
        }
        return service.getFees() * numberOfGuests;
    }
    
    // CREATE - New service booking
    public ValidationResult createBooking(BookService booking) {
        // Validate required fields
        if (booking.getServiceId() <= 0) {
            return new ValidationResult(false, "Service ID is required");
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
        if (booking.getNumberOfGuests() <= 0) {
            return new ValidationResult(false, "Number of guests is required");
        }
        
        // Validate guests range
        if (booking.getNumberOfGuests() < 1 || booking.getNumberOfGuests() > 10) {
            return new ValidationResult(false, "Number of guests must be between 1 and 10");
        }
        
        // Validate date and time
        ValidationResult validationResult = validateBooking(booking);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Get service details
        ManageService service = serviceDAO.findById(booking.getServiceId());
        if (service == null) {
            return new ValidationResult(false, "Service not found");
        }
        
        // Check if service is available
        if (!"available".equals(service.getStatus())) {
            return new ValidationResult(false, "Service is not available for booking");
        }
        
        // Check if time slot is available
        if (!isTimeSlotAvailable(booking.getServiceId(), booking.getBookingDate(), 
                                booking.getBookingTime(), null)) {
            return new ValidationResult(false, "Selected time slot is not available");
        }
        
        // Set defaults if not set
        if (booking.getStatus() == null) {
            booking.setStatus(BookService.STATUS_PENDING);
        }
        if (booking.getCreatedDate() == null) {
            booking.setCreatedDate(LocalDateTime.now());
        }
        if (booking.getUpdatedDate() == null) {
            booking.setUpdatedDate(LocalDateTime.now());
        }
        
        // Calculate total price if not set or incorrect
        double calculatedPrice = service.getFees() * booking.getNumberOfGuests();
        if (booking.getTotalPrice() <= 0 || Math.abs(booking.getTotalPrice() - calculatedPrice) > 0.01) {
            booking.setTotalPrice(calculatedPrice);
        }
        
        // Save to database
        boolean saved = bookServiceDAO.save(booking);
        
        if (saved) {
            return new ValidationResult(true, "Service booking created successfully. Booking No: " + booking.getBookingNo());
        } else {
            return new ValidationResult(false, "Failed to create service booking");
        }
    }
    
    // READ ALL - Get all service bookings
    public List<BookService> getAllBookings() {
        autoUpdateStatuses(); // Auto-update statuses before returning
        return bookServiceDAO.findAll();
    }
    
    // READ BY ID - Get booking by ID
    public BookService getBookingById(int id) {
        autoUpdateStatuses();
        return bookServiceDAO.findById(id);
    }
    
    // READ BY BOOKING NUMBER
    public BookService getBookingByBookingNo(String bookingNo) {
        autoUpdateStatuses();
        return bookServiceDAO.findByBookingNo(bookingNo);
    }
    
    // READ BY GUEST ID
    public List<BookService> getBookingsByGuestId(int guestId) {
        autoUpdateStatuses();
        return bookServiceDAO.findByGuestId(guestId);
    }
    
    // READ BY SERVICE ID
    public List<BookService> getBookingsByServiceId(int serviceId) {
        autoUpdateStatuses();
        return bookServiceDAO.findByServiceId(serviceId);
    }
    
    // READ BY STATUS
    public List<BookService> getBookingsByStatus(String status) {
        autoUpdateStatuses();
        return bookServiceDAO.findByStatus(status);
    }
    
    // READ BY DATE RANGE
    public List<BookService> getBookingsByDateRange(LocalDate startDate, LocalDate endDate) {
        autoUpdateStatuses();
        return bookServiceDAO.findByDateRange(startDate, endDate);
    }
    
    // READ BY DATE
    public List<BookService> getBookingsByDate(LocalDate date) {
        autoUpdateStatuses();
        return bookServiceDAO.findByDate(date);
    }
    
    // READ UPCOMING BOOKINGS (future date)
    public List<BookService> getUpcomingBookings(LocalDate fromDate) {
        autoUpdateStatuses();
        return bookServiceDAO.findUpcoming(fromDate);
    }
    
    // READ TODAY'S BOOKINGS
    public List<BookService> getTodayBookings() {
        autoUpdateStatuses();
        return bookServiceDAO.findTodayBookings();
    }
    
    // UPDATE STATUS BY GUEST (cancel their own bookings)
    public ValidationResult cancelBookingByGuest(int bookingId, int guestId) {
        BookService booking = bookServiceDAO.findById(bookingId);
        
        if (booking == null) {
            return new ValidationResult(false, "Booking not found");
        }
        
        // Verify this booking belongs to the guest
        if (booking.getGuestId() != guestId) {
            return new ValidationResult(false, "You can only cancel your own bookings");
        }
        
        // Check if booking can be cancelled (using business logic from model)
        if (!booking.canGuestCancel()) {
            return new ValidationResult(false, "This booking cannot be cancelled. Bookings can only be cancelled up to 2 hours before the scheduled time.");
        }
        
        boolean updated = bookServiceDAO.updateStatusByGuest(bookingId, guestId);
        
        if (updated) {
            return new ValidationResult(true, "Booking cancelled successfully");
        } else {
            return new ValidationResult(false, "Failed to cancel booking");
        }
    }
    
    // UPDATE STATUS (by staff)
    public ValidationResult updateBookingStatus(int bookingId, String newStatus, int staffId) {
        BookService booking = bookServiceDAO.findById(bookingId);
        
        if (booking == null) {
            return new ValidationResult(false, "Booking not found");
        }
        
        // Define valid status transitions
        String currentStatus = booking.getStatus();
        boolean validTransition = false;
        String transitionMessage = "";
        
        switch (newStatus) {
            case BookService.STATUS_CONFIRMED:
                validTransition = BookService.STATUS_PENDING.equals(currentStatus);
                transitionMessage = "confirmed";
                break;
            case BookService.STATUS_COMPLETED:
                validTransition = BookService.STATUS_CONFIRMED.equals(currentStatus) ||
                                  BookService.STATUS_NO_SHOW.equals(currentStatus);
                transitionMessage = "completed";
                break;
            case BookService.STATUS_REJECTED:
                validTransition = BookService.STATUS_PENDING.equals(currentStatus);
                transitionMessage = "rejected";
                break;
            case BookService.STATUS_NO_SHOW:
                validTransition = BookService.STATUS_CONFIRMED.equals(currentStatus);
                transitionMessage = "marked as no show";
                break;
            case BookService.STATUS_CANCELLED:
                validTransition = BookService.STATUS_PENDING.equals(currentStatus) ||
                                  BookService.STATUS_CONFIRMED.equals(currentStatus);
                transitionMessage = "cancelled";
                break;
        }
        
        if (!validTransition) {
            return new ValidationResult(false, "Cannot change status from " + currentStatus + " to " + newStatus);
        }
        
        boolean updated = bookServiceDAO.updateStatusByStaff(bookingId, newStatus);
        
        if (updated) {
            return new ValidationResult(true, "Booking " + transitionMessage + " successfully");
        } else {
            return new ValidationResult(false, "Failed to update booking status");
        }
    }
    
    // UPDATE COMPLETE BOOKING (by staff)
    public ValidationResult updateBooking(BookService booking) {
        BookService existingBooking = bookServiceDAO.findById(booking.getId());
        
        if (existingBooking == null) {
            return new ValidationResult(false, "Booking not found");
        }
        
        // Validate if date/time changed, check availability
        if (!existingBooking.getBookingDate().equals(booking.getBookingDate()) ||
            !existingBooking.getBookingTime().equals(booking.getBookingTime())) {
            
            ManageService service = serviceDAO.findById(booking.getServiceId());
            if (service == null) {
                return new ValidationResult(false, "Service not found");
            }
            
            if (!isTimeSlotAvailable(booking.getServiceId(), booking.getBookingDate(), 
                                    booking.getBookingTime(), booking.getId())) {
                return new ValidationResult(false, "Selected time slot is not available");
            }
        }
        
        // Validate guests range
        if (booking.getNumberOfGuests() < 1 || booking.getNumberOfGuests() > 10) {
            return new ValidationResult(false, "Number of guests must be between 1 and 10");
        }
        
        // Recalculate total price if needed
        ManageService service = serviceDAO.findById(booking.getServiceId());
        if (service != null) {
            double calculatedPrice = service.getFees() * booking.getNumberOfGuests();
            if (Math.abs(booking.getTotalPrice() - calculatedPrice) > 0.01) {
                booking.setTotalPrice(calculatedPrice);
            }
        }
        
        // Update the booking
        booking.setUpdatedDate(LocalDateTime.now());
        boolean updated = bookServiceDAO.update(booking);
        
        if (updated) {
            return new ValidationResult(true, "Booking updated successfully");
        } else {
            return new ValidationResult(false, "Failed to update booking");
        }
    }
    
    // GET GUEST UPCOMING BOOKINGS (for customer dashboard)
    public List<BookService> getGuestUpcomingBookings(int guestId) {
        autoUpdateStatuses();
        List<BookService> allBookings = bookServiceDAO.findByGuestId(guestId);
        LocalDateTime now = LocalDateTime.now();
        
        return allBookings.stream()
            .filter(b -> (BookService.STATUS_PENDING.equals(b.getStatus()) || 
                          BookService.STATUS_CONFIRMED.equals(b.getStatus())) &&
                          b.isUpcoming())
            .toList();
    }
    
    // GET GUEST PAST BOOKINGS (for customer history)
    public List<BookService> getGuestPastBookings(int guestId) {
        autoUpdateStatuses();
        List<BookService> allBookings = bookServiceDAO.findByGuestId(guestId);
        
        return allBookings.stream()
            .filter(b -> b.isPast() || 
                         BookService.STATUS_COMPLETED.equals(b.getStatus()) ||
                         BookService.STATUS_NO_SHOW.equals(b.getStatus()) ||
                         BookService.STATUS_CANCELLED.equals(b.getStatus()) ||
                         BookService.STATUS_REJECTED.equals(b.getStatus()))
            .toList();
    }
    
    // STATISTICS
    public int getTotalCount() {
        return bookServiceDAO.countAll();
    }
    
    public int getCountByStatus(String status) {
        return bookServiceDAO.countByStatus(status);
    }
    
    public int getCountByGuestId(int guestId) {
        return bookServiceDAO.countByGuestId(guestId);
    }
    
    public int getCountByServiceId(int serviceId) {
        return bookServiceDAO.countByServiceId(serviceId);
    }
    
    public int getActiveBookingsCount() {
        return bookServiceDAO.countActiveBookings();
    }
    
    public int getTodayBookingsCount() {
        return bookServiceDAO.countTodayBookings();
    }
    
    public double getTotalRevenueByDateRange(LocalDate startDate, LocalDate endDate) {
        return bookServiceDAO.getTotalRevenueByDateRange(startDate, endDate);
    }
    
    public double getMonthlyRevenue(int month, int year) {
        return bookServiceDAO.getMonthlyRevenue(month, year);
    }
    
    public double getRevenueByServiceId(int serviceId, LocalDate startDate, LocalDate endDate) {
        return bookServiceDAO.getRevenueByServiceId(serviceId, startDate, endDate);
    }
    
    public BookServiceDAO.Stats getStats() {
        autoUpdateStatuses();
        return bookServiceDAO.getStats();
    }
    
    public List<BookServiceDAO.PopularService> getPopularServices(LocalDate startDate, LocalDate endDate, int limit) {
        return bookServiceDAO.getPopularServices(startDate, endDate, limit);
    }
    
    public List<BookServiceDAO.PeakHour> getPeakHours(LocalDate startDate, LocalDate endDate) {
        return bookServiceDAO.getPeakHours(startDate, endDate);
    }
    
    // BATCH OPERATIONS
    public ValidationResult confirmMultipleBookings(List<Integer> bookingIds) {
        int successCount = 0;
        int failCount = 0;
        
        for (Integer id : bookingIds) {
            ValidationResult result = updateBookingStatus(id, BookService.STATUS_CONFIRMED, 0);
            if (result.isValid()) {
                successCount++;
            } else {
                failCount++;
            }
        }
        
        if (failCount == 0) {
            return new ValidationResult(true, "All " + successCount + " bookings confirmed successfully");
        } else {
            return new ValidationResult(false, successCount + " bookings confirmed, " + failCount + " failed");
        }
    }
    
    public ValidationResult cancelMultipleBookings(List<Integer> bookingIds) {
        int successCount = 0;
        int failCount = 0;
        
        for (Integer id : bookingIds) {
            ValidationResult result = updateBookingStatus(id, BookService.STATUS_CANCELLED, 0);
            if (result.isValid()) {
                successCount++;
            } else {
                failCount++;
            }
        }
        
        if (failCount == 0) {
            return new ValidationResult(true, "All " + successCount + " bookings cancelled successfully");
        } else {
            return new ValidationResult(false, successCount + " bookings cancelled, " + failCount + " failed");
        }
    }
    
    // CHECK-IN / CHECK-OUT functionality (for spa reception)
    public ValidationResult checkInBooking(int bookingId) {
        BookService booking = bookServiceDAO.findById(bookingId);
        
        if (booking == null) {
            return new ValidationResult(false, "Booking not found");
        }
        
        if (!BookService.STATUS_CONFIRMED.equals(booking.getStatus())) {
            return new ValidationResult(false, "Only confirmed bookings can be checked in");
        }
        
        // Check if it's the correct date
        if (!booking.isToday()) {
            return new ValidationResult(false, "This booking is for " + booking.getBookingDate() + ", not today");
        }
        
        // Check if it's within 30 minutes of booking time
        LocalTime now = LocalTime.now();
        LocalTime bookingTime = booking.getBookingTime();
        LocalTime gracePeriodEnd = bookingTime.plusMinutes(30);
        LocalTime lateThreshold = bookingTime.minusMinutes(15); // Can check in up to 15 min early
        
        if (now.isBefore(lateThreshold)) {
            return new ValidationResult(false, "Too early to check in. You can check in 15 minutes before the booking time.");
        }
        
        if (now.isAfter(gracePeriodEnd)) {
            // Auto-mark as no show if more than 30 min late
            updateBookingStatus(bookingId, BookService.STATUS_NO_SHOW, 0);
            return new ValidationResult(false, "Guest is late. Booking has been marked as no show.");
        }
        
        // Check in successful - could update to a "checked_in" status if you want
        // For now, we'll just return success
        return new ValidationResult(true, "Guest checked in successfully");
    }
    
    public ValidationResult completeBooking(int bookingId) {
        return updateBookingStatus(bookingId, BookService.STATUS_COMPLETED, 0);
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