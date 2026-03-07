package wepapp.controller;

import wepapp.model.BookService;
import wepapp.model.ManageService;
import wepapp.service.BookServiceeService;
import wepapp.dao.ManageServiceDAO;
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
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import wepapp.dao.BookServiceDAO;

// Front Controller Pattern - Single entry point for all service booking-related requests
@WebServlet("/bookservice/*")
public class BookServiceController extends HttpServlet {
    
    private BookServiceeService bookingService;
    private ManageServiceDAO serviceDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        this.bookingService = new BookServiceeService();
        this.serviceDAO = ManageServiceDAO.getInstance();
        
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
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/api")) {
            handleApiDeleteRequest(request, response, pathInfo);
        } else {
            response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }
    
    // Helper method to determine if it's a page request
    private boolean isPageRequest(String pathInfo) {
        return pathInfo == null || 
               pathInfo.equals("/") || 
               pathInfo.equals("/bookservice.jsp") ||
               pathInfo.equals("/my-bookings");
    }
    
    // Handle page requests
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        
        // Check if user is logged in for protected pages
        HttpSession session = request.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("userId") != null);
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/bookservice.jsp")) {
            // Show service booking page
            request.getRequestDispatcher("/bookservice.jsp").forward(request, response);
            
        } else if (pathInfo.equals("/my-bookings")) {
            // Show guest's bookings page
            if (!isLoggedIn) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=bookservice/my-bookings");
                return;
            }
            request.getRequestDispatcher("/my-service-bookings.jsp").forward(request, response);
            
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
                List<BookService> bookings = bookingService.getAllBookings();
                out.print(gson.toJson(bookings));
                
            // GET BOOKINGS BY GUEST ID
            } else if (pathInfo.equals("/api/guest")) {
                int guestId = getIntParameter(request, "guestId", 0);
                if (guestId > 0) {
                    List<BookService> bookings = bookingService.getBookingsByGuestId(guestId);
                    out.print(gson.toJson(bookings));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Guest ID is required")));
                }
                
            // GET GUEST UPCOMING BOOKINGS
            } else if (pathInfo.equals("/api/guest/upcoming")) {
                int guestId = getIntParameter(request, "guestId", 0);
                if (guestId > 0) {
                    List<BookService> bookings = bookingService.getGuestUpcomingBookings(guestId);
                    out.print(gson.toJson(bookings));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Guest ID is required")));
                }
                
            // GET GUEST PAST BOOKINGS
            } else if (pathInfo.equals("/api/guest/past")) {
                int guestId = getIntParameter(request, "guestId", 0);
                if (guestId > 0) {
                    List<BookService> bookings = bookingService.getGuestPastBookings(guestId);
                    out.print(gson.toJson(bookings));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Guest ID is required")));
                }
                
            // GET BOOKINGS BY SERVICE ID
            } else if (pathInfo.equals("/api/service")) {
                int serviceId = getIntParameter(request, "serviceId", 0);
                if (serviceId > 0) {
                    List<BookService> bookings = bookingService.getBookingsByServiceId(serviceId);
                    out.print(gson.toJson(bookings));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Service ID is required")));
                }
                
            // GET BOOKINGS BY STATUS
            } else if (pathInfo.equals("/api/status")) {
                String status = request.getParameter("status");
                if (status != null && !status.isEmpty()) {
                    List<BookService> bookings = bookingService.getBookingsByStatus(status);
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
                        List<BookService> bookings = bookingService.getBookingsByDate(date);
                        out.print(gson.toJson(bookings));
                    } catch (DateTimeParseException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Map.of("error", "Invalid date format. Use YYYY-MM-DD")));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Date is required")));
                }
                
            // GET TODAY'S BOOKINGS
            } else if (pathInfo.equals("/api/today")) {
                List<BookService> bookings = bookingService.getTodayBookings();
                out.print(gson.toJson(bookings));
                
            // GET UPCOMING BOOKINGS
            } else if (pathInfo.equals("/api/upcoming")) {
                LocalDate fromDate = LocalDate.now();
                List<BookService> bookings = bookingService.getUpcomingBookings(fromDate);
                out.print(gson.toJson(bookings));
                
            // GET AVAILABLE TIME SLOTS
            } else if (pathInfo.equals("/api/available-slots")) {
                int serviceId = getIntParameter(request, "serviceId", 0);
                String dateStr = request.getParameter("date");
                
                if (serviceId > 0 && dateStr != null && !dateStr.isEmpty()) {
                    try {
                        LocalDate date = LocalDate.parse(dateStr);
                        List<LocalTime> availableSlots = bookingService.getAvailableTimeSlots(serviceId, date);
                        out.print(gson.toJson(availableSlots));
                    } catch (DateTimeParseException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Map.of("error", "Invalid date format. Use YYYY-MM-DD")));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Service ID and date are required")));
                }
                
            // CHECK TIME SLOT AVAILABILITY
            } else if (pathInfo.equals("/api/check-availability")) {
                int serviceId = getIntParameter(request, "serviceId", 0);
                String dateStr = request.getParameter("date");
                String timeStr = request.getParameter("time");
                
                if (serviceId > 0 && dateStr != null && timeStr != null) {
                    try {
                        LocalDate date = LocalDate.parse(dateStr);
                        LocalTime time = LocalTime.parse(timeStr);
                        
                        boolean available = bookingService.isTimeSlotAvailable(serviceId, date, time, null);
                        out.print(gson.toJson(Map.of("available", available)));
                    } catch (DateTimeParseException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Map.of("error", "Invalid date or time format")));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Service ID, date, and time are required")));
                }
                
            // CALCULATE TOTAL PRICE
            } else if (pathInfo.equals("/api/calculate-price")) {
                int serviceId = getIntParameter(request, "serviceId", 0);
                int guests = getIntParameter(request, "guests", 1);
                
                if (serviceId > 0) {
                    double totalPrice = bookingService.calculateTotalPrice(serviceId, guests);
                    ManageService service = serviceDAO.findById(serviceId);
                    
                    Map<String, Object> result = new HashMap<>();
                    result.put("totalPrice", totalPrice);
                    result.put("serviceFee", service != null ? service.getFees() : 0);
                    result.put("guests", guests);
                    out.print(gson.toJson(result));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Service ID is required")));
                }
                
            // GET STATISTICS
            } else if (pathInfo.equals("/api/stats")) {
                BookServiceDAO.Stats stats = bookingService.getStats();
                out.print(gson.toJson(stats));
                
            // GET POPULAR SERVICES
            } else if (pathInfo.equals("/api/popular-services")) {
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                int limit = getIntParameter(request, "limit", 10);
                
                LocalDate startDate = startDateStr != null ? LocalDate.parse(startDateStr) : LocalDate.now().minusMonths(1);
                LocalDate endDate = endDateStr != null ? LocalDate.parse(endDateStr) : LocalDate.now();
                
                List<BookServiceDAO.PopularService> popularServices = bookingService.getPopularServices(startDate, endDate, limit);
                out.print(gson.toJson(popularServices));
                
            // GET PEAK HOURS
            } else if (pathInfo.equals("/api/peak-hours")) {
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                
                LocalDate startDate = startDateStr != null ? LocalDate.parse(startDateStr) : LocalDate.now().minusMonths(1);
                LocalDate endDate = endDateStr != null ? LocalDate.parse(endDateStr) : LocalDate.now();
                
                List<BookServiceDAO.PeakHour> peakHours = bookingService.getPeakHours(startDate, endDate);
                out.print(gson.toJson(peakHours));
                
            // GET BOOKING BY ID
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                BookService booking = bookingService.getBookingById(id);
                
                if (booking == null) {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(Map.of("error", "Booking not found")));
                    return;
                }
                
                out.print(gson.toJson(booking));
                
            // GET BOOKING BY BOOKING NUMBER
            } else if (pathInfo.startsWith("/api/booking/")) {
                String bookingNo = pathInfo.substring("/api/booking/".length());
                if (!bookingNo.isEmpty()) {
                    BookService booking = bookingService.getBookingByBookingNo(bookingNo);
                    
                    if (booking == null) {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        out.print(gson.toJson(Map.of("error", "Booking not found")));
                        return;
                    }
                    
                    out.print(gson.toJson(booking));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Booking number is required")));
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
                BookService booking = extractBookingFromRequest(request);
                
                // Validate guest ID is provided
                if (booking.getGuestId() <= 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("success", false, "message", "Guest ID is required")));
                    return;
                }
                
                BookServiceeService.ValidationResult result = bookingService.createBooking(booking);
                
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("success", result.isValid());
                responseMap.put("message", result.getMessage());
                
                if (result.isValid()) {
                    responseMap.put("booking", booking);
                    responseMap.put("bookingNo", booking.getBookingNo());
                    responseMap.put("bookingId", booking.getId());
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
                
                out.print(gson.toJson(responseMap));
                
            // BATCH CONFIRM BOOKINGS
            } else if (pathInfo.equals("/api/batch-confirm")) {
                JsonObject json = parseJsonRequest(request);
                List<Integer> bookingIds = gson.fromJson(json.get("bookingIds"), List.class);
                
                BookServiceeService.ValidationResult result = bookingService.confirmMultipleBookings(bookingIds);
                
                out.print(gson.toJson(Map.of(
                    "success", result.isValid(),
                    "message", result.getMessage()
                )));
                
            // BATCH CANCEL BOOKINGS
            } else if (pathInfo.equals("/api/batch-cancel")) {
                JsonObject json = parseJsonRequest(request);
                List<Integer> bookingIds = gson.fromJson(json.get("bookingIds"), List.class);
                
                BookServiceeService.ValidationResult result = bookingService.cancelMultipleBookings(bookingIds);
                
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
                
                BookServiceeService.ValidationResult result = bookingService.cancelBookingByGuest(bookingId, guestId);
                
                out.print(gson.toJson(Map.of(
                    "success", result.isValid(),
                    "message", result.getMessage()
                )));
                
            // UPDATE booking status (by staff)
            } else if (pathInfo.equals("/api/update-status")) {
                int bookingId = getIntParameter(request, "bookingId", 0);
                String status = request.getParameter("status");
                int staffId = getIntParameter(request, "staffId", 0);
                
                if (bookingId <= 0 || status == null || status.isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("success", false, "message", "Booking ID and status are required")));
                    return;
                }
                
                BookServiceeService.ValidationResult result = bookingService.updateBookingStatus(bookingId, status, staffId);
                
                out.print(gson.toJson(Map.of(
                    "success", result.isValid(),
                    "message", result.getMessage()
                )));
                
            // CHECK-IN booking
            } else if (pathInfo.equals("/api/checkin")) {
                int bookingId = getIntParameter(request, "bookingId", 0);
                
                if (bookingId <= 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("success", false, "message", "Booking ID is required")));
                    return;
                }
                
                BookServiceeService.ValidationResult result = bookingService.checkInBooking(bookingId);
                
                out.print(gson.toJson(Map.of(
                    "success", result.isValid(),
                    "message", result.getMessage()
                )));
                
            // COMPLETE booking
            } else if (pathInfo.equals("/api/complete")) {
                int bookingId = getIntParameter(request, "bookingId", 0);
                
                if (bookingId <= 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("success", false, "message", "Booking ID is required")));
                    return;
                }
                
                BookServiceeService.ValidationResult result = bookingService.completeBooking(bookingId);
                
                out.print(gson.toJson(Map.of(
                    "success", result.isValid(),
                    "message", result.getMessage()
                )));
                
            // UPDATE complete booking (by staff)
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                
                BookService booking = extractBookingFromRequest(request);
                booking.setId(id);
                
                BookServiceeService.ValidationResult result = bookingService.updateBooking(booking);
                
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
    
    // Handle API DELETE requests
    private void handleApiDeleteRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Note: We don't actually delete bookings for data integrity
            // Instead, we cancel them
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                
                response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                out.print(gson.toJson(Map.of(
                    "success", false, 
                    "message", "Bookings cannot be deleted. Use cancel endpoint instead."
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
    
    // Helper method to extract BookService from request (JSON or form)
    private BookService extractBookingFromRequest(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        
        if (contentType != null && contentType.contains("application/json")) {
            return extractBookingFromJson(request);
        } else {
            return extractBookingFromForm(request);
        }
    }
    
    // Extract BookService from JSON
    private BookService extractBookingFromJson(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        
        BookService booking = new BookService();
        
        if (json.has("id") && !json.get("id").isJsonNull()) {
            booking.setId(json.get("id").getAsInt());
        }
        
        if (json.has("serviceId") && !json.get("serviceId").isJsonNull()) {
            booking.setServiceId(json.get("serviceId").getAsInt());
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
        
        if (json.has("numberOfGuests") && !json.get("numberOfGuests").isJsonNull()) {
            booking.setNumberOfGuests(json.get("numberOfGuests").getAsInt());
        } else {
            booking.setNumberOfGuests(1);
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
    
    // Extract BookService from form data
    private BookService extractBookingFromForm(HttpServletRequest request) {
        BookService booking = new BookService();
        
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            booking.setId(Integer.parseInt(id));
        }
        
        String serviceId = request.getParameter("serviceId");
        if (serviceId != null && !serviceId.isEmpty()) {
            booking.setServiceId(Integer.parseInt(serviceId));
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
        
        String numberOfGuests = request.getParameter("numberOfGuests");
        if (numberOfGuests != null && !numberOfGuests.isEmpty()) {
            booking.setNumberOfGuests(Integer.parseInt(numberOfGuests));
        } else {
            booking.setNumberOfGuests(1);
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