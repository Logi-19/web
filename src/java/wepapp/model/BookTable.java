// BookTable.java
package wepapp.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class BookTable {
    private int id;
    private String reservationNo;
    private int tableId;
    private int guestId;
    private LocalDate bookingDate;
    private LocalTime bookingTime;
    private int partySize;
    private String specialRequests;
    private String status; // pending, confirmed, seated, completed, cancelled, rejected
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;
    
    // Additional fields for joined data
    private String guestName;
    private String guestEmail;
    private String guestPhone;
    private String tableNo;
    private String tablePrefix;
    private String locationName;
    private int capacity;
    private double minimumSpend;
    
    // Status constants
    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_CONFIRMED = "confirmed";
    public static final String STATUS_SEATED = "seated";
    public static final String STATUS_COMPLETED = "completed";
    public static final String STATUS_CANCELLED = "cancelled";
    public static final String STATUS_REJECTED = "rejected";
    public static final String STATUS_NO_SHOW = "no_show";
    
    // Default constructor
    public BookTable() {
        this.status = STATUS_PENDING;
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }
    
    // Private constructor for Builder
    private BookTable(Builder builder) {
        this.id = builder.id;
        this.reservationNo = builder.reservationNo;
        this.tableId = builder.tableId;
        this.guestId = builder.guestId;
        this.bookingDate = builder.bookingDate;
        this.bookingTime = builder.bookingTime;
        this.partySize = builder.partySize;
        this.specialRequests = builder.specialRequests;
        this.status = builder.status;
        this.createdDate = builder.createdDate;
        this.updatedDate = builder.updatedDate;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getReservationNo() { return reservationNo; }
    public void setReservationNo(String reservationNo) { this.reservationNo = reservationNo; }
    
    public int getTableId() { return tableId; }
    public void setTableId(int tableId) { this.tableId = tableId; }
    
    public int getGuestId() { return guestId; }
    public void setGuestId(int guestId) { this.guestId = guestId; }
    
    public LocalDate getBookingDate() { return bookingDate; }
    public void setBookingDate(LocalDate bookingDate) { this.bookingDate = bookingDate; }
    
    public LocalTime getBookingTime() { return bookingTime; }
    public void setBookingTime(LocalTime bookingTime) { this.bookingTime = bookingTime; }
    
    public int getPartySize() { return partySize; }
    public void setPartySize(int partySize) { this.partySize = partySize; }
    
    public String getSpecialRequests() { return specialRequests; }
    public void setSpecialRequests(String specialRequests) { this.specialRequests = specialRequests; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) { this.createdDate = createdDate; }
    
    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }
    
    // Joined data getters and setters
    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }
    
    public String getGuestEmail() { return guestEmail; }
    public void setGuestEmail(String guestEmail) { this.guestEmail = guestEmail; }
    
    public String getGuestPhone() { return guestPhone; }
    public void setGuestPhone(String guestPhone) { this.guestPhone = guestPhone; }
    
    public String getTableNo() { return tableNo; }
    public void setTableNo(String tableNo) { this.tableNo = tableNo; }
    
    public String getTablePrefix() { return tablePrefix; }
    public void setTablePrefix(String tablePrefix) { this.tablePrefix = tablePrefix; }
    
    public String getLocationName() { return locationName; }
    public void setLocationName(String locationName) { this.locationName = locationName; }
    
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    
    public double getMinimumSpend() { return minimumSpend; }
    public void setMinimumSpend(double minimumSpend) { this.minimumSpend = minimumSpend; }
    
    // Helper methods
    public String getDisplayTableInfo() {
        return tablePrefix + " - " + tableNo + " (" + locationName + ")";
    }
    
    public String getFormattedBookingDateTime() {
        if (bookingDate == null || bookingTime == null) return "";
        return bookingDate.toString() + " at " + bookingTime.toString();
    }
    
    // Check if status can be changed by guest
    public boolean canGuestChangeStatus() {
        return STATUS_PENDING.equals(this.status) || STATUS_CONFIRMED.equals(this.status);
    }
    
    // Check if status can be changed by staff
    public boolean canStaffChangeStatus() {
        return !STATUS_COMPLETED.equals(this.status) && !STATUS_REJECTED.equals(this.status) && !STATUS_NO_SHOW.equals(this.status);
    }
    
    // Check if booking is active (confirmed)
    public boolean isActive() {
        return STATUS_CONFIRMED.equals(this.status);
    }
    
    // Builder Pattern
    public static class Builder {
        private int id;
        private String reservationNo;
        private int tableId;
        private int guestId;
        private LocalDate bookingDate;
        private LocalTime bookingTime;
        private int partySize;
        private String specialRequests;
        private String status = STATUS_PENDING;
        private LocalDateTime createdDate = LocalDateTime.now();
        private LocalDateTime updatedDate = LocalDateTime.now();
        
        public Builder id(int id) { this.id = id; return this; }
        public Builder reservationNo(String reservationNo) { this.reservationNo = reservationNo; return this; }
        public Builder tableId(int tableId) { this.tableId = tableId; return this; }
        public Builder guestId(int guestId) { this.guestId = guestId; return this; }
        public Builder bookingDate(LocalDate bookingDate) { this.bookingDate = bookingDate; return this; }
        public Builder bookingTime(LocalTime bookingTime) { this.bookingTime = bookingTime; return this; }
        public Builder partySize(int partySize) { this.partySize = partySize; return this; }
        public Builder specialRequests(String specialRequests) { this.specialRequests = specialRequests; return this; }
        public Builder status(String status) { this.status = status; return this; }
        public Builder createdDate(LocalDateTime createdDate) { this.createdDate = createdDate; return this; }
        public Builder updatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; return this; }
        
        public BookTable build() {
            return new BookTable(this);
        }
    }
    
    @Override
    public String toString() {
        return "BookTable{" + "id=" + id + ", reservationNo=" + reservationNo + 
               ", tableId=" + tableId + ", guestId=" + guestId + 
               ", bookingDate=" + bookingDate + ", bookingTime=" + bookingTime + 
               ", partySize=" + partySize + ", status=" + status + "}";
    }
}