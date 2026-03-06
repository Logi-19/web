package wepapp.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class BookRoom {
    private int id;
    private String reservationNo;
    private int roomId;
    private int guestId;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private LocalTime checkInTime;
    private LocalTime checkOutTime;
    private String specialRequests;
    private double totalPrice;
    private String status; // pending, confirmed, checked_in, checked_out, completed, cancelled, rejected
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;
    
    // Additional fields for joined data
    private String guestName;
    private String guestEmail;
    private String guestPhone;
    private String roomNo;
    private String roomTypeName;
    private String roomPrefix;
    
    // Status constants
    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_CONFIRMED = "confirmed";
    public static final String STATUS_CHECKED_IN = "checked_in";
    public static final String STATUS_CHECKED_OUT = "checked_out";
    public static final String STATUS_COMPLETED = "completed";
    public static final String STATUS_CANCELLED = "cancelled";
    public static final String STATUS_REJECTED = "rejected";
    
    // Default constructor
    public BookRoom() {
        this.status = STATUS_PENDING;
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }
    
    // Private constructor for Builder
    private BookRoom(Builder builder) {
        this.id = builder.id;
        this.reservationNo = builder.reservationNo;
        this.roomId = builder.roomId;
        this.guestId = builder.guestId;
        this.checkInDate = builder.checkInDate;
        this.checkOutDate = builder.checkOutDate;
        this.checkInTime = builder.checkInTime;
        this.checkOutTime = builder.checkOutTime;
        this.specialRequests = builder.specialRequests;
        this.totalPrice = builder.totalPrice;
        this.status = builder.status;
        this.createdDate = builder.createdDate;
        this.updatedDate = builder.updatedDate;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getReservationNo() { return reservationNo; }
    public void setReservationNo(String reservationNo) { this.reservationNo = reservationNo; }
    
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    
    public int getGuestId() { return guestId; }
    public void setGuestId(int guestId) { this.guestId = guestId; }
    
    public LocalDate getCheckInDate() { return checkInDate; }
    public void setCheckInDate(LocalDate checkInDate) { this.checkInDate = checkInDate; }
    
    public LocalDate getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(LocalDate checkOutDate) { this.checkOutDate = checkOutDate; }
    
    public LocalTime getCheckInTime() { return checkInTime; }
    public void setCheckInTime(LocalTime checkInTime) { this.checkInTime = checkInTime; }
    
    public LocalTime getCheckOutTime() { return checkOutTime; }
    public void setCheckOutTime(LocalTime checkOutTime) { this.checkOutTime = checkOutTime; }
    
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
    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }
    
    public String getGuestEmail() { return guestEmail; }
    public void setGuestEmail(String guestEmail) { this.guestEmail = guestEmail; }
    
    public String getGuestPhone() { return guestPhone; }
    public void setGuestPhone(String guestPhone) { this.guestPhone = guestPhone; }
    
    public String getRoomNo() { return roomNo; }
    public void setRoomNo(String roomNo) { this.roomNo = roomNo; }
    
    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }
    
    public String getRoomPrefix() { return roomPrefix; }
    public void setRoomPrefix(String roomPrefix) { this.roomPrefix = roomPrefix; }
    
    // Helper method to get number of nights
    public int getNights() {
        if (checkInDate != null && checkOutDate != null) {
            return (int) (checkOutDate.toEpochDay() - checkInDate.toEpochDay());
        }
        return 0;
    }
    
    // Check if status can be changed by guest
    public boolean canGuestChangeStatus() {
        return STATUS_PENDING.equals(this.status) || STATUS_CANCELLED.equals(this.status);
    }
    
    // Check if status can be changed by staff
    public boolean canStaffChangeStatus() {
        return !STATUS_COMPLETED.equals(this.status) && !STATUS_REJECTED.equals(this.status);
    }
    
    // Check if booking is active (confirmed or checked-in)
    public boolean isActive() {
        return STATUS_CONFIRMED.equals(this.status) || STATUS_CHECKED_IN.equals(this.status);
    }
    
    // Builder Pattern
    public static class Builder {
        private int id;
        private String reservationNo;
        private int roomId;
        private int guestId;
        private LocalDate checkInDate;
        private LocalDate checkOutDate;
        private LocalTime checkInTime;
        private LocalTime checkOutTime;
        private String specialRequests;
        private double totalPrice;
        private String status = STATUS_PENDING;
        private LocalDateTime createdDate = LocalDateTime.now();
        private LocalDateTime updatedDate = LocalDateTime.now();
        
        public Builder id(int id) { this.id = id; return this; }
        public Builder reservationNo(String reservationNo) { this.reservationNo = reservationNo; return this; }
        public Builder roomId(int roomId) { this.roomId = roomId; return this; }
        public Builder guestId(int guestId) { this.guestId = guestId; return this; }
        public Builder checkInDate(LocalDate checkInDate) { this.checkInDate = checkInDate; return this; }
        public Builder checkOutDate(LocalDate checkOutDate) { this.checkOutDate = checkOutDate; return this; }
        public Builder checkInTime(LocalTime checkInTime) { this.checkInTime = checkInTime; return this; }
        public Builder checkOutTime(LocalTime checkOutTime) { this.checkOutTime = checkOutTime; return this; }
        public Builder specialRequests(String specialRequests) { this.specialRequests = specialRequests; return this; }
        public Builder totalPrice(double totalPrice) { this.totalPrice = totalPrice; return this; }
        public Builder status(String status) { this.status = status; return this; }
        public Builder createdDate(LocalDateTime createdDate) { this.createdDate = createdDate; return this; }
        public Builder updatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; return this; }
        
        public BookRoom build() {
            return new BookRoom(this);
        }
    }
    
    @Override
    public String toString() {
        return "BookRoom{" + "id=" + id + ", reservationNo=" + reservationNo + 
               ", roomId=" + roomId + ", guestId=" + guestId + 
               ", checkInDate=" + checkInDate + ", checkOutDate=" + checkOutDate + 
               ", status=" + status + ", totalPrice=" + totalPrice + "}";
    }
}