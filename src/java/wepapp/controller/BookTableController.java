// BookTableController.java
package wepapp.controller;

import wepapp.model.BookTable;
import wepapp.service.BookTableService;
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
import wepapp.dao.BookTableDAO;

// Front Controller Pattern - Single entry point for all table booking-related requests
@WebServlet("/tablebookings/*")
public class BookTableController extends HttpServlet {
    
    private BookTableService bookingService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        this.bookingService = new BookTableService();
        
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
               pathInfo.equals("/booktable.jsp");
    }
    
    // Handle page requests
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/booktable.jsp")) {
            // Show table booking page
            request.getRequestDispatcher("/booktable.jsp").forward(request, response);
        } else if (pathInfo.equals("/list")) {
            // Redirect to main page
            response.sendRedirect(request.getContextPath() + "/tablebookings/");
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
                List<BookTable> bookings = bookingService.getAllBookings();
                out.print(gson.toJson(bookings));
                
            // GET BOOKINGS BY GUEST ID
            } else if (pathInfo.equals("/api/guest")) {
                int guestId = getIntParameter(request, "guestId", 0);
                if (guestId > 0) {
                    List<BookTable> bookings = bookingService.getBookingsByGuestId(guestId);
                    out.print(gson.toJson(bookings));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Guest ID is required")));
                }
                
            // GET BOOKINGS BY TABLE ID
            } else if (pathInfo.equals("/api/table")) {
                int tableId = getIntParameter(request, "tableId", 0);
                if (tableId > 0) {
                    List<BookTable> bookings = bookingService.getBookingsByTableId(tableId);
                    out.print(gson.toJson(bookings));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Table ID is required")));
                }
                
            // GET BOOKINGS BY STATUS
            } else if (pathInfo.equals("/api/status")) {
                String status = request.getParameter("status");
                if (status != null && !status.isEmpty()) {
                    List<BookTable> bookings = bookingService.getBookingsByStatus(status);
                    out.print(gson.toJson(bookings));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Status is required")));
                }
                
            // GET BOOKINGS BY DATE
            } else if (pathInfo.equals("/api/date")) {
                String dateStr = request.getParameter("date");
                if (dateStr != null && !dateStr.isEmpty()) {
                    try {
                        LocalDate date = LocalDate.parse(dateStr);
                        List<BookTable> bookings = bookingService.getBookingsByDate(date);
                        out.print(gson.toJson(bookings));
                    } catch (Exception e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Map.of("error", "Invalid date format. Use YYYY-MM-DD")));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Date is required")));
                }
                
            // GET TODAY'S BOOKINGS
            } else if (pathInfo.equals("/api/today")) {
                List<BookTable> bookings = bookingService.getTodayBookings();
                out.print(gson.toJson(bookings));
                
            // GET UPCOMING BOOKINGS
            } else if (pathInfo.equals("/api/upcoming")) {
                LocalDate fromDate = LocalDate.now();
                List<BookTable> bookings = bookingService.getUpcomingBookings(fromDate);
                out.print(gson.toJson(bookings));
                
            // CHECK TABLE AVAILABILITY
            } else if (pathInfo.equals("/api/check-availability")) {
                int tableId = getIntParameter(request, "tableId", 0);
                String dateStr = request.getParameter("date");
                String timeStr = request.getParameter("time");
                
                if (tableId > 0 && dateStr != null && timeStr != null) {
                    try {
                        LocalDate date = LocalDate.parse(dateStr);
                        LocalTime time = LocalTime.parse(timeStr);
                        
                        boolean available = bookingService.isTableAvailable(tableId, date, time, null);
                        out.print(gson.toJson(Map.of("available", available)));
                    } catch (Exception e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Map.of("error", "Invalid date or time format. Use YYYY-MM-DD for date and HH:MM for time")));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Table ID, date, and time are required")));
                }
                
            // GET AVAILABLE DATES (dates that have any availability)
            } else if (pathInfo.equals("/api/available-dates")) {
                int tableId = getIntParameter(request, "tableId", 0);
                if (tableId > 0) {
                    List<BookTable> bookings = bookingService.getBookingsByTableId(tableId);
                    out.print(gson.toJson(bookings));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Table ID is required")));
                }
                
            // GET AVAILABLE TIMES FOR A TABLE ON A DATE
            } else if (pathInfo.equals("/api/available-times")) {
                int tableId = getIntParameter(request, "tableId", 0);
                String dateStr = request.getParameter("date");
                
                if (tableId > 0 && dateStr != null && !dateStr.isEmpty()) {
                    try {
                        LocalDate date = LocalDate.parse(dateStr);
                        List<LocalTime> bookedTimes = bookingService.getBookedTimes(tableId, date);
                        
                        // Convert times to strings for JSON
                        List<String> bookedTimeStrings = bookedTimes.stream()
                            .map(time -> time.toString())
                            .toList();
                        
                        out.print(gson.toJson(bookedTimeStrings));
                    } catch (Exception e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Map.of("error", "Invalid date format. Use YYYY-MM-DD")));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Table ID and date are required")));
                }
                
            // GET STATISTICS
            } else if (pathInfo.equals("/api/stats")) {
                BookTableDAO.Stats stats = bookingService.getStats();
                out.print(gson.toJson(stats));
                
            // GET BOOKING BY ID
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                BookTable booking = bookingService.getBookingById(id);
                
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
                    BookTable booking = bookingService.getBookingByReservationNo(reservationNo);
                    
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
                BookTable booking = extractBookingFromRequest(request);
                
                // Validate guest ID is provided
                if (booking.getGuestId() <= 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("success", false, "message", "Guest ID is required")));
                    return;
                }
                
                BookTableService.ValidationResult result = bookingService.createBooking(booking);
                
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
                
                BookTableService.ValidationResult result = bookingService.cancelBookingByGuest(bookingId, guestId);
                
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
                
                BookTableService.ValidationResult result = bookingService.updateBookingStatus(bookingId, status);
                
                out.print(gson.toJson(Map.of(
                    "success", result.isValid(),
                    "message", result.getMessage()
                )));
                
            // UPDATE complete booking (by staff)
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                
                BookTable booking = extractBookingFromRequest(request);
                booking.setId(id);
                
                BookTableService.ValidationResult result = bookingService.updateBooking(booking);
                
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
    
    // Helper method to extract BookTable from request (JSON or form)
    private BookTable extractBookingFromRequest(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        
        if (contentType != null && contentType.contains("application/json")) {
            return extractBookingFromJson(request);
        } else {
            return extractBookingFromForm(request);
        }
    }
    
    // Extract BookTable from JSON
    private BookTable extractBookingFromJson(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        
        BookTable booking = new BookTable();
        
        if (json.has("id") && !json.get("id").isJsonNull()) {
            booking.setId(json.get("id").getAsInt());
        }
        
        if (json.has("tableId") && !json.get("tableId").isJsonNull()) {
            booking.setTableId(json.get("tableId").getAsInt());
        }
        
        if (json.has("guestId") && !json.get("guestId").isJsonNull()) {
            booking.setGuestId(json.get("guestId").getAsInt());
        }
        
        if (json.has("bookingDate") && !json.get("bookingDate").isJsonNull()) {
            booking.setBookingDate(LocalDate.parse(json.get("bookingDate").getAsString()));
        }
        
        if (json.has("bookingTime") && !json.get("bookingTime").isJsonNull()) {
            booking.setBookingTime(LocalTime.parse(json.get("bookingTime").getAsString()));
        }
        
        if (json.has("partySize") && !json.get("partySize").isJsonNull()) {
            booking.setPartySize(json.get("partySize").getAsInt());
        }
        
        if (json.has("specialRequests") && !json.get("specialRequests").isJsonNull()) {
            booking.setSpecialRequests(json.get("specialRequests").getAsString());
        }
        
        if (json.has("status") && !json.get("status").isJsonNull()) {
            booking.setStatus(json.get("status").getAsString());
        }
        
        return booking;
    }
    
    // Extract BookTable from form data
    private BookTable extractBookingFromForm(HttpServletRequest request) {
        BookTable booking = new BookTable();
        
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            booking.setId(Integer.parseInt(id));
        }
        
        String tableId = request.getParameter("tableId");
        if (tableId != null && !tableId.isEmpty()) {
            booking.setTableId(Integer.parseInt(tableId));
        }
        
        String guestId = request.getParameter("guestId");
        if (guestId != null && !guestId.isEmpty()) {
            booking.setGuestId(Integer.parseInt(guestId));
        }
        
        String bookingDate = request.getParameter("bookingDate");
        if (bookingDate != null && !bookingDate.isEmpty()) {
            booking.setBookingDate(LocalDate.parse(bookingDate));
        }
        
        String bookingTime = request.getParameter("bookingTime");
        if (bookingTime != null && !bookingTime.isEmpty()) {
            booking.setBookingTime(LocalTime.parse(bookingTime));
        }
        
        String partySize = request.getParameter("partySize");
        if (partySize != null && !partySize.isEmpty()) {
            booking.setPartySize(Integer.parseInt(partySize));
        }
        
        String specialRequests = request.getParameter("specialRequests");
        if (specialRequests != null && !specialRequests.isEmpty()) {
            booking.setSpecialRequests(specialRequests);
        }
        
        String status = request.getParameter("status");
        if (status != null && !status.isEmpty()) {
            booking.setStatus(status);
        }
        
        return booking;
    }
}