package wepapp.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class BookService {
    private int id;
    private String bookingNo;          // Unique booking number (S-YYYY-XXXX)
    private int serviceId;              // Foreign key to manage_services
    private int guestId;                // Foreign key to manage_guests
    private LocalDate bookingDate;       // Date of service
    private LocalTime bookingTime;       // Time of service
    private int numberOfGuests;          // Number of guests (1-10)
    private String specialRequests;      // Special requests/preferences
    private double totalPrice;           // Total price (service fee × guests)
    private String status;               // pending, confirmed, completed, cancelled, rejected, no_show
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;
    
    // Additional fields for joined data
    private String serviceTitle;
    private String serviceDescription;
    private int serviceDuration;
    private double serviceFee;
    private String serviceCategoryName;
    private String serviceCategoryId;
    private String guestName;
    private String guestEmail;
    private String guestPhone;
    
    // Status constants
    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_CONFIRMED = "confirmed";
    public static final String STATUS_COMPLETED = "completed";
    public static final String STATUS_CANCELLED = "cancelled";
    public static final String STATUS_REJECTED = "rejected";
    public static final String STATUS_NO_SHOW = "no_show";
    
    // Default constructor
    public BookService() {
        this.status = STATUS_PENDING;
        this.numberOfGuests = 1;
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }
    
    // Private constructor for Builder
    private BookService(Builder builder) {
        this.id = builder.id;
        this.bookingNo = builder.bookingNo;
        this.serviceId = builder.serviceId;
        this.guestId = builder.guestId;
        this.bookingDate = builder.bookingDate;
        this.bookingTime = builder.bookingTime;
        this.numberOfGuests = builder.numberOfGuests;
        this.specialRequests = builder.specialRequests;
        this.totalPrice = builder.totalPrice;
        this.status = builder.status;
        this.createdDate = builder.createdDate;
        this.updatedDate = builder.updatedDate;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getBookingNo() { return bookingNo; }
    public void setBookingNo(String bookingNo) { this.bookingNo = bookingNo; }
    
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    
    public int getGuestId() { return guestId; }
    public void setGuestId(int guestId) { this.guestId = guestId; }
    
    public LocalDate getBookingDate() { return bookingDate; }
    public void setBookingDate(LocalDate bookingDate) { this.bookingDate = bookingDate; }
    
    public LocalTime getBookingTime() { return bookingTime; }
    public void setBookingTime(LocalTime bookingTime) { this.bookingTime = bookingTime; }
    
    public int getNumberOfGuests() { return numberOfGuests; }
    public void setNumberOfGuests(int numberOfGuests) { 
        this.numberOfGuests = numberOfGuests;
        // Auto-update total price if service fee is available
        if (this.serviceFee > 0) {
            this.totalPrice = this.serviceFee * numberOfGuests;
        }
    }
    
    public String getSpecialRequests() { return specialRequests; }
    public void setSpecialRequests(String specialRequests) { this.specialRequests = specialRequests; }
    
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) { this.createdDate = createdDate; }
    
    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }
    
    // Joined data getters and setters
    public String getServiceTitle() { return serviceTitle; }
    public void setServiceTitle(String serviceTitle) { this.serviceTitle = serviceTitle; }
    
    public String getServiceDescription() { return serviceDescription; }
    public void setServiceDescription(String serviceDescription) { this.serviceDescription = serviceDescription; }
    
    public int getServiceDuration() { return serviceDuration; }
    public void setServiceDuration(int serviceDuration) { this.serviceDuration = serviceDuration; }
    
    public double getServiceFee() { return serviceFee; }
    public void setServiceFee(double serviceFee) { 
        this.serviceFee = serviceFee;
        // Auto-update total price if guests count is available
        if (this.numberOfGuests > 0) {
            this.totalPrice = serviceFee * this.numberOfGuests;
        }
    }
    
    public String getServiceCategoryName() { return serviceCategoryName; }
    public void setServiceCategoryName(String serviceCategoryName) { this.serviceCategoryName = serviceCategoryName; }
    
    public String getServiceCategoryId() { return serviceCategoryId; }
    public void setServiceCategoryId(String serviceCategoryId) { this.serviceCategoryId = serviceCategoryId; }
    
    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }
    
    public String getGuestEmail() { return guestEmail; }
    public void setGuestEmail(String guestEmail) { this.guestEmail = guestEmail; }
    
    public String getGuestPhone() { return guestPhone; }
    public void setGuestPhone(String guestPhone) { this.guestPhone = guestPhone; }
    
    // Helper method to get formatted booking time with duration
    public String getFormattedBookingTimeWithDuration() {
        if (bookingTime == null) return "";
        if (serviceDuration == 0) {
            return bookingTime.toString() + " (Unlimited)";
        }
        LocalTime endTime = bookingTime.plusMinutes(serviceDuration);
        return bookingTime.toString() + " - " + endTime.toString() + " (" + serviceDuration + " min)";
    }
    
    // Helper method to get end time based on duration
    public LocalTime getEndTime() {
        if (bookingTime == null || serviceDuration == 0) return null;
        return bookingTime.plusMinutes(serviceDuration);
    }
    
    // Check if booking is in the past
    public boolean isPast() {
        if (bookingDate == null) return false;
        LocalDate today = LocalDate.now();
        if (bookingDate.isBefore(today)) return true;
        if (bookingDate.isAfter(today)) return false;
        
        // Same day - check time
        if (bookingTime == null) return false;
        return bookingTime.isBefore(LocalTime.now());
    }
    
    // Check if booking is today
    public boolean isToday() {
        if (bookingDate == null) return false;
        return bookingDate.equals(LocalDate.now());
    }
    
    // Check if booking is upcoming
    public boolean isUpcoming() {
        if (bookingDate == null) return false;
        LocalDate today = LocalDate.now();
        if (bookingDate.isAfter(today)) return true;
        if (bookingDate.isBefore(today)) return false;
        
        // Same day - check time
        if (bookingTime == null) return false;
        return bookingTime.isAfter(LocalTime.now());
    }
    
    // Check if booking can be cancelled by guest
    public boolean canGuestCancel() {
        if (!STATUS_PENDING.equals(this.status) && !STATUS_CONFIRMED.equals(this.status)) {
            return false;
        }
        
        // Can cancel up to 2 hours before booking time
        if (bookingDate == null || bookingTime == null) return false;
        
        LocalDateTime bookingDateTime = LocalDateTime.of(bookingDate, bookingTime);
        LocalDateTime now = LocalDateTime.now();
        
        // Check if booking is at least 2 hours in the future
        return bookingDateTime.isAfter(now.plusHours(2));
    }
    
    // Check if status can be changed by staff
    public boolean canStaffChangeStatus() {
        return !STATUS_COMPLETED.equals(this.status) && 
               !STATUS_REJECTED.equals(this.status) && 
               !STATUS_NO_SHOW.equals(this.status);
    }
    
    // Check if booking is active (pending or confirmed)
    public boolean isActive() {
        return STATUS_PENDING.equals(this.status) || STATUS_CONFIRMED.equals(this.status);
    }
    
    // Check if booking is confirmed
    public boolean isConfirmed() {
        return STATUS_CONFIRMED.equals(this.status);
    }
    
    // Check if booking is completed
    public boolean isCompleted() {
        return STATUS_COMPLETED.equals(this.status);
    }
    
    // Check if booking is cancelled
    public boolean isCancelled() {
        return STATUS_CANCELLED.equals(this.status);
    }
    
    // Check if booking is no show
    public boolean isNoShow() {
        return STATUS_NO_SHOW.equals(this.status);
    }
    
    // Check if service is free
    public boolean isFree() {
        return this.totalPrice == 0;
    }
    
    // Get status badge class for UI
    public String getStatusBadgeClass() {
        switch (this.status) {
            case STATUS_PENDING:
                return "bg-yellow-100 text-yellow-700";
            case STATUS_CONFIRMED:
                return "bg-green-100 text-green-700";
            case STATUS_COMPLETED:
                return "bg-blue-100 text-blue-700";
            case STATUS_CANCELLED:
                return "bg-gray-100 text-gray-700";
            case STATUS_REJECTED:
                return "bg-red-100 text-red-700";
            case STATUS_NO_SHOW:
                return "bg-purple-100 text-purple-700";
            default:
                return "bg-gray-100 text-gray-700";
        }
    }
    
    // Get status icon
    public String getStatusIcon() {
        switch (this.status) {
            case STATUS_PENDING:
                return "⏳";
            case STATUS_CONFIRMED:
                return "✅";
            case STATUS_COMPLETED:
                return "✓";
            case STATUS_CANCELLED:
                return "✗";
            case STATUS_REJECTED:
                return "⚠️";
            case STATUS_NO_SHOW:
                return "🚫";
            default:
                return "•";
        }
    }
    
    // Get status display text
    public String getStatusDisplay() {
        switch (this.status) {
            case STATUS_PENDING:
                return "Pending";
            case STATUS_CONFIRMED:
                return "Confirmed";
            case STATUS_COMPLETED:
                return "Completed";
            case STATUS_CANCELLED:
                return "Cancelled";
            case STATUS_REJECTED:
                return "Rejected";
            case STATUS_NO_SHOW:
                return "No Show";
            default:
                return this.status;
        }
    }
    
    // Builder Pattern
    public static class Builder {
        private int id;
        private String bookingNo;
        private int serviceId;
        private int guestId;
        private LocalDate bookingDate;
        private LocalTime bookingTime;
        private int numberOfGuests = 1;
        private String specialRequests;
        private double totalPrice;
        private String status = STATUS_PENDING;
        private LocalDateTime createdDate = LocalDateTime.now();
        private LocalDateTime updatedDate = LocalDateTime.now();
        
        public Builder id(int id) { this.id = id; return this; }
        public Builder bookingNo(String bookingNo) { this.bookingNo = bookingNo; return this; }
        public Builder serviceId(int serviceId) { this.serviceId = serviceId; return this; }
        public Builder guestId(int guestId) { this.guestId = guestId; return this; }
        public Builder bookingDate(LocalDate bookingDate) { this.bookingDate = bookingDate; return this; }
        public Builder bookingTime(LocalTime bookingTime) { this.bookingTime = bookingTime; return this; }
        public Builder numberOfGuests(int numberOfGuests) { this.numberOfGuests = numberOfGuests; return this; }
        public Builder specialRequests(String specialRequests) { this.specialRequests = specialRequests; return this; }
        public Builder totalPrice(double totalPrice) { this.totalPrice = totalPrice; return this; }
        public Builder status(String status) { this.status = status; return this; }
        public Builder createdDate(LocalDateTime createdDate) { this.createdDate = createdDate; return this; }
        public Builder updatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; return this; }
        
        public BookService build() {
            return new BookService(this);
        }
    }
    
    @Override
    public String toString() {
        return "BookService{" + "id=" + id + ", bookingNo=" + bookingNo + 
               ", serviceId=" + serviceId + ", guestId=" + guestId + 
               ", bookingDate=" + bookingDate + ", bookingTime=" + bookingTime + 
               ", guests=" + numberOfGuests + ", status=" + status + 
               ", totalPrice=" + totalPrice + "}";
    }
}