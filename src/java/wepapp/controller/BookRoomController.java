package wepapp.controller;

import wepapp.model.BookRoom;
import wepapp.service.BookRoomService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import wepapp.dao.BookRoomDAO;

// Front Controller Pattern - Single entry point for all booking-related requests
@WebServlet("/bookings/*")
public class BookRoomController extends HttpServlet {
    
    private BookRoomService bookingService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        this.bookingService = new BookRoomService();
        
        // Create Gson with custom LocalDate, LocalTime, and LocalDateTime adapters
        this.gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
            .registerTypeAdapter(LocalTime.class, new LocalTimeAdapter())
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .create();
    }
    
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
    
    // Custom TypeAdapter for LocalTime
    private static class LocalTimeAdapter extends TypeAdapter<LocalTime> {
        private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_TIME;
        
        @Override
        public void write(JsonWriter out, LocalTime value) throws IOException {
            if (value == null) {
                out.nullValue();
            } else {
                out.value(formatter.format(value));
            }
        }
        
        @Override
        public LocalTime read(JsonReader in) throws IOException {
            if (in.peek() == null) {
                in.nextNull();
                return null;
            }
            String timeStr = in.nextString();
            return LocalTime.parse(timeStr, formatter);
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
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        // Check if it's an API request or page request
        if (isPageRequest(pathInfo)) {
            handlePageRequest(request, response, pathInfo);
        } else {
            handleApiGetRequest(request, response, pathInfo);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        // Check if it's an API request
        if (pathInfo != null && pathInfo.startsWith("/api")) {
            handleApiPostRequest(request, response, pathInfo);
        } else {
            response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/api")) {
            handleApiPutRequest(request, response, pathInfo);
        } else {
            response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }
    
    // DELETE method removed - no delete operations allowed
    
    // Helper method to determine if it's a page request
    private boolean isPageRequest(String pathInfo) {
        return pathInfo == null || 
               pathInfo.equals("/") || 
               pathInfo.equals("/list") ||
               pathInfo.equals("/bookings.jsp");
    }
    
    // Handle page requests
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/bookings.jsp")) {
            // Show booking management page
            request.getRequestDispatcher("/bookings.jsp").forward(request, response);
        } else if (pathInfo.equals("/list")) {
            // Redirect to main page
            response.sendRedirect(request.getContextPath() + "/bookings/");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    // Handle API GET requests
    private void handleApiGetRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(Map.of("error", "Invalid API endpoint")));
                return;
            }
            
            // GET ALL bookings
            if (pathInfo.equals("/api/list")) {
                List<BookRoom> bookings = bookingService.getAllBookings();
                out.print(gson.toJson(bookings));
                
            // GET BOOKINGS BY GUEST ID
            } else if (pathInfo.equals("/api/guest")) {
                int guestId = getIntParameter(request, "guestId", 0);
                if (guestId > 0) {
                    List<BookRoom> bookings = bookingService.getBookingsByGuestId(guestId);
                    out.print(gson.toJson(bookings));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Guest ID is required")));
                }
                
            // GET BOOKINGS BY ROOM ID
            } else if (pathInfo.equals("/api/room")) {
                int roomId = getIntParameter(request, "roomId", 0);
                if (roomId > 0) {
                    List<BookRoom> bookings = bookingService.getBookingsByRoomId(roomId);
                    out.print(gson.toJson(bookings));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Room ID is required")));
                }
                
            // GET BOOKINGS BY STATUS
            } else if (pathInfo.equals("/api/status")) {
                String status = request.getParameter("status");
                if (status != null && !status.isEmpty()) {
                    List<BookRoom> bookings = bookingService.getBookingsByStatus(status);
                    out.print(gson.toJson(bookings));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Status is required")));
                }
                
            // GET TODAY'S CHECK-INS
            } else if (pathInfo.equals("/api/today-checkins")) {
                List<BookRoom> bookings = bookingService.getTodayCheckIns();
                out.print(gson.toJson(bookings));
                
            // GET TODAY'S CHECK-OUTS
            } else if (pathInfo.equals("/api/today-checkouts")) {
                List<BookRoom> bookings = bookingService.getTodayCheckOuts();
                out.print(gson.toJson(bookings));
                
            // GET UPCOMING BOOKINGS
            } else if (pathInfo.equals("/api/upcoming")) {
                LocalDate fromDate = LocalDate.now();
                List<BookRoom> bookings = bookingService.getUpcomingBookings(fromDate);
                out.print(gson.toJson(bookings));
                
            // CHECK ROOM AVAILABILITY
            } else if (pathInfo.equals("/api/check-availability")) {
                int roomId = getIntParameter(request, "roomId", 0);
                String checkInStr = request.getParameter("checkIn");
                String checkOutStr = request.getParameter("checkOut");
                
                if (roomId > 0 && checkInStr != null && checkOutStr != null) {
                    try {
                        LocalDate checkIn = LocalDate.parse(checkInStr);
                        LocalDate checkOut = LocalDate.parse(checkOutStr);
                        
                        boolean available = bookingService.isRoomAvailable(roomId, checkIn, checkOut, null);
                        out.print(gson.toJson(Map.of("available", available)));
                    } catch (Exception e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Map.of("error", "Invalid date format. Use YYYY-MM-DD")));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Room ID, check-in, and check-out dates are required")));
                }
                
            // CALCULATE TOTAL PRICE
            } else if (pathInfo.equals("/api/calculate-price")) {
                int roomId = getIntParameter(request, "roomId", 0);
                String checkInStr = request.getParameter("checkIn");
                String checkOutStr = request.getParameter("checkOut");
                
                if (roomId > 0 && checkInStr != null && checkOutStr != null) {
                    try {
                        LocalDate checkIn = LocalDate.parse(checkInStr);
                        LocalDate checkOut = LocalDate.parse(checkOutStr);
                        
                        double totalPrice = bookingService.calculateTotalPrice(roomId, checkIn, checkOut);
                        out.print(gson.toJson(Map.of("totalPrice", totalPrice)));
                    } catch (Exception e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Map.of("error", "Invalid date format. Use YYYY-MM-DD")));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Room ID, check-in, and check-out dates are required")));
                }
                
            // GET STATISTICS
            } else if (pathInfo.equals("/api/stats")) {
                BookRoomDAO.Stats stats = bookingService.getStats();
                out.print(gson.toJson(stats));
                
            // GET BOOKING BY ID
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                BookRoom booking = bookingService.getBookingById(id);
                
                if (booking == null) {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(Map.of("error", "Booking not found")));
                    return;
                }
                
                out.print(gson.toJson(booking));
                
            // GET BOOKING BY RESERVATION NUMBER
            } else if (pathInfo.startsWith("/api/reservation/")) {
                String reservationNo = pathInfo.substring("/api/reservation/".length());
                if (!reservationNo.isEmpty()) {
                    BookRoom booking = bookingService.getBookingByReservationNo(reservationNo);
                    
                    if (booking == null) {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        out.print(gson.toJson(Map.of("error", "Booking not found")));
                        return;
                    }
                    
                    out.print(gson.toJson(booking));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Reservation number is required")));
                }
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(Map.of("error", "API endpoint not found")));
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("error", e.getMessage())));
            e.printStackTrace();
        }
    }
    
    // Handle API POST requests (CREATE)
    private void handleApiPostRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // CREATE new booking
            if (pathInfo.equals("/api/create")) {
                BookRoom booking = extractBookingFromRequest(request);
                
                // Validate guest ID is provided
                if (booking.getGuestId() <= 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("success", false, "message", "Guest ID is required")));
                    return;
                }
                
                BookRoomService.ValidationResult result = bookingService.createBooking(booking);
                
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("success", result.isValid());
                responseMap.put("message", result.getMessage());
                
                if (result.isValid()) {
                    responseMap.put("booking", booking);
                    responseMap.put("reservationNo", booking.getReservationNo());
                    responseMap.put("bookingId", booking.getId());
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
                
                out.print(gson.toJson(responseMap));
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(Map.of("error", "API endpoint not found")));
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("error", e.getMessage())));
            e.printStackTrace();
        }
    }
    
    // Handle API PUT requests (UPDATE)
    private void handleApiPutRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // CANCEL booking by guest
            if (pathInfo.equals("/api/cancel")) {
                int bookingId = getIntParameter(request, "bookingId", 0);
                int guestId = getIntParameter(request, "guestId", 0);
                
                if (bookingId <= 0 || guestId <= 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("success", false, "message", "Booking ID and Guest ID are required")));
                    return;
                }
                
                BookRoomService.ValidationResult result = bookingService.cancelBookingByGuest(bookingId, guestId);
                
                out.print(gson.toJson(Map.of(
                    "success", result.isValid(),
                    "message", result.getMessage()
                )));
                
            // UPDATE booking status (by staff)
            } else if (pathInfo.equals("/api/update-status")) {
                int bookingId = getIntParameter(request, "bookingId", 0);
                String status = request.getParameter("status");
                
                if (bookingId <= 0 || status == null || status.isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("success", false, "message", "Booking ID and status are required")));
                    return;
                }
                
                BookRoomService.ValidationResult result = bookingService.updateBookingStatus(bookingId, status);
                
                out.print(gson.toJson(Map.of(
                    "success", result.isValid(),
                    "message", result.getMessage()
                )));
                
            // UPDATE complete booking (by staff)
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                
                BookRoom booking = extractBookingFromRequest(request);
                booking.setId(id);
                
                BookRoomService.ValidationResult result = bookingService.updateBooking(booking);
                
                out.print(gson.toJson(Map.of(
                    "success", result.isValid(),
                    "message", result.getMessage()
                )));
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(Map.of("error", "API endpoint not found")));
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("error", e.getMessage())));
            e.printStackTrace();
        }
    }
    
    // Helper method to extract ID from path
    private int extractIdFromPath(String pathInfo) {
        String[] parts = pathInfo.split("/");
        return Integer.parseInt(parts[2]);
    }
    
    // Helper method to get integer parameter with default value
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.isEmpty()) {
            try {
                return Integer.parseInt(paramValue);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }
    
    // Helper method to parse JSON request
    private JsonObject parseJsonRequest(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        return JsonParser.parseString(sb.toString()).getAsJsonObject();
    }
    
    // Helper method to extract BookRoom from request (JSON or form)
    private BookRoom extractBookingFromRequest(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        
        if (contentType != null && contentType.contains("application/json")) {
            return extractBookingFromJson(request);
        } else {
            return extractBookingFromForm(request);
        }
    }
    
    // Extract BookRoom from JSON
    private BookRoom extractBookingFromJson(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        
        BookRoom booking = new BookRoom();
        
        if (json.has("id") && !json.get("id").isJsonNull()) {
            booking.setId(json.get("id").getAsInt());
        }
        
        if (json.has("roomId") && !json.get("roomId").isJsonNull()) {
            booking.setRoomId(json.get("roomId").getAsInt());
        }
        
        if (json.has("guestId") && !json.get("guestId").isJsonNull()) {
            booking.setGuestId(json.get("guestId").getAsInt());
        }
        
        if (json.has("checkInDate") && !json.get("checkInDate").isJsonNull()) {
            booking.setCheckInDate(LocalDate.parse(json.get("checkInDate").getAsString()));
        }
        
        if (json.has("checkOutDate") && !json.get("checkOutDate").isJsonNull()) {
            booking.setCheckOutDate(LocalDate.parse(json.get("checkOutDate").getAsString()));
        }
        
        if (json.has("checkInTime") && !json.get("checkInTime").isJsonNull()) {
            booking.setCheckInTime(LocalTime.parse(json.get("checkInTime").getAsString()));
        } else {
            booking.setCheckInTime(LocalTime.of(14, 0)); // Default 2:00 PM
        }
        
        if (json.has("checkOutTime") && !json.get("checkOutTime").isJsonNull()) {
            booking.setCheckOutTime(LocalTime.parse(json.get("checkOutTime").getAsString()));
        }
        
        if (json.has("specialRequests") && !json.get("specialRequests").isJsonNull()) {
            booking.setSpecialRequests(json.get("specialRequests").getAsString());
        }
        
        if (json.has("totalPrice") && !json.get("totalPrice").isJsonNull()) {
            booking.setTotalPrice(json.get("totalPrice").getAsDouble());
        }
        
        if (json.has("status") && !json.get("status").isJsonNull()) {
            booking.setStatus(json.get("status").getAsString());
        }
        
        return booking;
    }
    
    // Extract BookRoom from form data
    private BookRoom extractBookingFromForm(HttpServletRequest request) {
        BookRoom booking = new BookRoom();
        
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            booking.setId(Integer.parseInt(id));
        }
        
        String roomId = request.getParameter("roomId");
        if (roomId != null && !roomId.isEmpty()) {
            booking.setRoomId(Integer.parseInt(roomId));
        }
        
        String guestId = request.getParameter("guestId");
        if (guestId != null && !guestId.isEmpty()) {
            booking.setGuestId(Integer.parseInt(guestId));
        }
        
        String checkInDate = request.getParameter("checkInDate");
        if (checkInDate != null && !checkInDate.isEmpty()) {
            booking.setCheckInDate(LocalDate.parse(checkInDate));
        }
        
        String checkOutDate = request.getParameter("checkOutDate");
        if (checkOutDate != null && !checkOutDate.isEmpty()) {
            booking.setCheckOutDate(LocalDate.parse(checkOutDate));
        }
        
        String checkInTime = request.getParameter("checkInTime");
        if (checkInTime != null && !checkInTime.isEmpty()) {
            booking.setCheckInTime(LocalTime.parse(checkInTime));
        } else {
            booking.setCheckInTime(LocalTime.of(14, 0)); // Default 2:00 PM
        }
        
        String checkOutTime = request.getParameter("checkOutTime");
        if (checkOutTime != null && !checkOutTime.isEmpty()) {
            booking.setCheckOutTime(LocalTime.parse(checkOutTime));
        }
        
        String specialRequests = request.getParameter("specialRequests");
        if (specialRequests != null && !specialRequests.isEmpty()) {
            booking.setSpecialRequests(specialRequests);
        }
        
        String totalPrice = request.getParameter("totalPrice");
        if (totalPrice != null && !totalPrice.isEmpty()) {
            booking.setTotalPrice(Double.parseDouble(totalPrice));
        }
        
        String status = request.getParameter("status");
        if (status != null && !status.isEmpty()) {
            booking.setStatus(status);
        }
        
        return booking;
    }
}