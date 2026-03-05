package wepapp.controller;

import wepapp.model.ManageGuest;
import wepapp.service.ManageGuestService;
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
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

// Front Controller Pattern - Single entry point for all guest-related requests
@WebServlet("/guests/*")
public class ManageGuestController extends HttpServlet {
    
    private ManageGuestService guestService;
    private Gson gson;
    
    // Simple token storage (will be used later for session management)
    private static Map<String, LoginSession> activeSessions = new HashMap<>();
    
    private static class LoginSession {
        int guestId;
        String guestName;
        String regNo;
        LocalDateTime loginTime;
        
        LoginSession(int guestId, String guestName, String regNo) {
            this.guestId = guestId;
            this.guestName = guestName;
            this.regNo = regNo;
            this.loginTime = LocalDateTime.now();
        }
    }
    
    @Override
    public void init() throws ServletException {
        this.guestService = new ManageGuestService();
        
        // Create Gson with custom LocalDate and LocalDateTime adapters
        this.gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
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
               pathInfo.equals("/list") ||
               pathInfo.equals("/manageguests.jsp");
    }
    
    // Handle page requests
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/manageguests.jsp")) {
            // Show guest management page
            request.getRequestDispatcher("/manageguests.jsp").forward(request, response);
        } else if (pathInfo.equals("/list")) {
            // Redirect to main page
            response.sendRedirect(request.getContextPath() + "/guests/");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    // Handle API GET requests - Temporarily no authentication required for testing
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
            
            // Get all guests
            if (pathInfo.equals("/api/list")) {
                List<ManageGuest> guests = guestService.getAllGuests();
                out.print(gson.toJson(guests));
                
            // Get active guests
            } else if (pathInfo.equals("/api/active")) {
                List<ManageGuest> guests = guestService.getActiveGuests();
                out.print(gson.toJson(guests));
                
            // Get inactive guests
            } else if (pathInfo.equals("/api/inactive")) {
                List<ManageGuest> guests = guestService.getInactiveGuests();
                out.print(gson.toJson(guests));
                
            // Get recent guests
            } else if (pathInfo.equals("/api/recent")) {
                int limit = getIntParameter(request, "limit", 5);
                List<ManageGuest> guests = guestService.getRecentGuests(limit);
                out.print(gson.toJson(guests));
                
            // Get statistics
            } else if (pathInfo.equals("/api/stats")) {
                Map<String, Integer> stats = new HashMap<>();
                stats.put("total", guestService.getTotalCount());
                stats.put("active", guestService.getActiveCount());
                stats.put("inactive", guestService.getInactiveCount());
                stats.put("male", guestService.getMaleCount());
                stats.put("female", guestService.getFemaleCount());
                stats.put("other", guestService.getOtherGenderCount());
                stats.put("createdThisMonth", guestService.getCreatedThisMonthCount());
                stats.put("createdLastMonth", guestService.getCreatedLastMonthCount());
                stats.put("createdThisYear", guestService.getCreatedThisYearCount());
                out.print(gson.toJson(stats));
                
            // Search guests
            } else if (pathInfo.equals("/api/search")) {
                String keyword = request.getParameter("q");
                if (keyword != null && !keyword.isEmpty()) {
                    List<ManageGuest> guests = guestService.searchGuests(keyword);
                    out.print(gson.toJson(guests));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Search keyword is required")));
                }
                
            // Get guests by status
            } else if (pathInfo.equals("/api/by-status")) {
                String status = request.getParameter("status");
                if (status != null && !status.isEmpty()) {
                    List<ManageGuest> guests = guestService.getGuestsByStatus(status);
                    out.print(gson.toJson(guests));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Status parameter is required")));
                }
                
            // Get guests by gender
            } else if (pathInfo.equals("/api/by-gender")) {
                String gender = request.getParameter("gender");
                if (gender != null && !gender.isEmpty()) {
                    List<ManageGuest> guests = guestService.getGuestsByGender(gender);
                    out.print(gson.toJson(guests));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Gender parameter is required")));
                }
                
            // Get guests by date range
            } else if (pathInfo.equals("/api/by-date-range")) {
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                
                if (startDateStr != null && endDateStr != null) {
                    LocalDate startDate = LocalDate.parse(startDateStr);
                    LocalDate endDate = LocalDate.parse(endDateStr);
                    List<ManageGuest> guests = guestService.getGuestsByDateRange(startDate, endDate);
                    out.print(gson.toJson(guests));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Start date and end date are required")));
                }
                
            // Get guests by month and year
            } else if (pathInfo.equals("/api/by-month-year")) {
                String monthStr = request.getParameter("month");
                String yearStr = request.getParameter("year");
                
                if (monthStr != null && yearStr != null) {
                    int month = Integer.parseInt(monthStr);
                    int year = Integer.parseInt(yearStr);
                    List<ManageGuest> guests = guestService.getGuestsByMonthYear(month, year);
                    out.print(gson.toJson(guests));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Month and year are required")));
                }
                
            // Check if username exists
            } else if (pathInfo.equals("/api/username-exists")) {
                String username = request.getParameter("username");
                String excludeId = request.getParameter("excludeId");
                
                if (username != null && !username.isEmpty()) {
                    boolean exists;
                    if (excludeId != null && !excludeId.isEmpty()) {
                        exists = guestService.usernameExistsExcludingId(username, Integer.parseInt(excludeId));
                    } else {
                        exists = guestService.usernameExists(username);
                    }
                    out.print(gson.toJson(Map.of("exists", exists)));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Username is required")));
                }
                
            // Check if email exists
            } else if (pathInfo.equals("/api/email-exists")) {
                String email = request.getParameter("email");
                String excludeId = request.getParameter("excludeId");
                
                if (email != null && !email.isEmpty()) {
                    boolean exists;
                    if (excludeId != null && !excludeId.isEmpty()) {
                        exists = guestService.emailExistsExcludingId(email, Integer.parseInt(excludeId));
                    } else {
                        exists = guestService.emailExists(email);
                    }
                    out.print(gson.toJson(Map.of("exists", exists)));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Email is required")));
                }
                
            // Get guest by ID
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                ManageGuest guest = guestService.getGuestById(id);
                if (guest != null) {
                    out.print(gson.toJson(guest));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(Map.of("error", "Guest not found")));
                }
                
            // Get guest by username
            } else if (pathInfo.equals("/api/by-username")) {
                String username = request.getParameter("username");
                if (username != null && !username.isEmpty()) {
                    ManageGuest guest = guestService.getGuestByUsername(username);
                    if (guest != null) {
                        out.print(gson.toJson(guest));
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        out.print(gson.toJson(Map.of("error", "Guest not found")));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Username is required")));
                }
                
            // Get guest by email
            } else if (pathInfo.equals("/api/by-email")) {
                String email = request.getParameter("email");
                if (email != null && !email.isEmpty()) {
                    ManageGuest guest = guestService.getGuestByEmail(email);
                    if (guest != null) {
                        out.print(gson.toJson(guest));
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        out.print(gson.toJson(Map.of("error", "Guest not found")));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Email is required")));
                }
                
            // Get guest by registration number
            } else if (pathInfo.equals("/api/by-regno")) {
                String regNo = request.getParameter("regNo");
                if (regNo != null && !regNo.isEmpty()) {
                    ManageGuest guest = guestService.getGuestByRegNo(regNo);
                    if (guest != null) {
                        out.print(gson.toJson(guest));
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        out.print(gson.toJson(Map.of("error", "Guest not found")));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Registration number is required")));
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
    
    // Handle API POST requests
    private void handleApiPostRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Create new guest
            if (pathInfo.equals("/api/create")) {
                ManageGuest guest = extractGuestFromRequest(request);
                ManageGuestService.ValidationResult result = guestService.createGuest(guest);
                
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("success", result.isValid());
                responseMap.put("message", result.getMessage());
                
                if (result.isValid()) {
                    // Don't send password back
                    guest.setPassword(null);
                    responseMap.put("guest", guest);
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
                
                out.print(gson.toJson(responseMap));
                
            // Authenticate guest - Returns token for future use
            } else if (pathInfo.equals("/api/login")) {
                JsonObject json = parseJsonRequest(request);
                String username = json.has("username") ? json.get("username").getAsString() : null;
                String password = json.has("password") ? json.get("password").getAsString() : null;
                
                if (username != null && password != null) {
                    ManageGuest guest = guestService.authenticate(username, password);
                    
                    if (guest != null) {
                        // Update last login
                        guestService.updateLastLogin(guest.getId());
                        
                        // Generate token for session management (will be used later)
                        String token = UUID.randomUUID().toString();
                        activeSessions.put(token, new LoginSession(
                            guest.getId(), 
                            guest.getFullName(), 
                            guest.getRegNo()
                        ));
                        
                        // Return success with token and user info
                        Map<String, Object> responseMap = new HashMap<>();
                        responseMap.put("success", true);
                        responseMap.put("message", "Login successful");
                        responseMap.put("token", token); // Token for future session management
                        responseMap.put("guestId", guest.getId());
                        responseMap.put("guestName", guest.getFullName());
                        responseMap.put("guestRegNo", guest.getRegNo());
                        responseMap.put("guestEmail", guest.getEmail());
                        
                        out.print(gson.toJson(responseMap));
                    } else {
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                        out.print(gson.toJson(Map.of(
                            "success", false,
                            "message", "Invalid username or password"
                        )));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of(
                        "success", false,
                        "message", "Username and password are required"
                    )));
                }
                
            // Logout - Invalidates token
            } else if (pathInfo.equals("/api/logout")) {
                String token = request.getHeader("Authorization");
                if (token != null && token.startsWith("Bearer ")) {
                    String tokenValue = token.substring(7);
                    activeSessions.remove(tokenValue);
                }
                
                out.print(gson.toJson(Map.of(
                    "success", true,
                    "message", "Logout successful"
                )));
                
            // Verify token - Check if token is still valid
            } else if (pathInfo.equals("/api/verify-token")) {
                String token = request.getHeader("Authorization");
                if (token != null && token.startsWith("Bearer ")) {
                    String tokenValue = token.substring(7);
                    if (activeSessions.containsKey(tokenValue)) {
                        LoginSession session = activeSessions.get(tokenValue);
                        out.print(gson.toJson(Map.of(
                            "success", true,
                            "valid", true,
                            "guestId", session.guestId,
                            "guestName", session.guestName,
                            "guestRegNo", session.regNo
                        )));
                    } else {
                        out.print(gson.toJson(Map.of(
                            "success", true,
                            "valid", false
                        )));
                    }
                } else {
                    out.print(gson.toJson(Map.of(
                        "success", true,
                        "valid", false
                    )));
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
    
    // Handle API PUT requests - Temporarily no authentication required for testing
    private void handleApiPutRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Update guest by ID
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                ManageGuest guest = extractGuestFromRequest(request);
                guest.setId(id);
                
                ManageGuestService.ValidationResult result = guestService.updateGuest(guest);
                
                out.print(gson.toJson(Map.of(
                    "success", result.isValid(),
                    "message", result.getMessage()
                )));
                
            // Update guest status by ID
            } else if (pathInfo.matches("/api/\\d+/status")) {
                int id = extractIdFromStatusPath(pathInfo);
                JsonObject json = parseJsonRequest(request);
                String status = json.has("status") ? json.get("status").getAsString() : null;
                
                if (status != null) {
                    ManageGuestService.ValidationResult result = guestService.updateGuestStatus(id, status);
                    
                    out.print(gson.toJson(Map.of(
                        "success", result.isValid(),
                        "message", result.getMessage()
                    )));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of(
                        "success", false,
                        "message", "Status is required"
                    )));
                }
                
            // Update guest password by ID
            } else if (pathInfo.matches("/api/\\d+/password")) {
                int id = extractIdFromPasswordPath(pathInfo);
                JsonObject json = parseJsonRequest(request);
                String password = json.has("password") ? json.get("password").getAsString() : null;
                
                if (password != null) {
                    ManageGuestService.ValidationResult result = guestService.updateGuestPassword(id, password);
                    
                    out.print(gson.toJson(Map.of(
                        "success", result.isValid(),
                        "message", result.getMessage()
                    )));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of(
                        "success", false,
                        "message", "Password is required"
                    )));
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
    
    // Handle API DELETE requests - Temporarily no authentication required for testing
    private void handleApiDeleteRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Delete guest by ID
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                boolean deleted = guestService.deleteGuest(id);
                
                out.print(gson.toJson(Map.of(
                    "success", deleted,
                    "message", deleted ? "Guest deleted successfully" : "Failed to delete guest"
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
    
    // Helper method to extract ID from path (e.g., /api/123)
    private int extractIdFromPath(String pathInfo) {
        String[] parts = pathInfo.split("/");
        return Integer.parseInt(parts[2]);
    }
    
    // Helper method to extract ID from status path (e.g., /api/123/status)
    private int extractIdFromStatusPath(String pathInfo) {
        String[] parts = pathInfo.split("/");
        return Integer.parseInt(parts[2]);
    }
    
    // Helper method to extract ID from password path (e.g., /api/123/password)
    private int extractIdFromPasswordPath(String pathInfo) {
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
    
    // Helper method to extract ManageGuest from request (JSON or form)
    private ManageGuest extractGuestFromRequest(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        
        if (contentType != null && contentType.contains("application/json")) {
            return extractGuestFromJson(request);
        } else {
            return extractGuestFromForm(request);
        }
    }
    
    // Extract ManageGuest from JSON
    private ManageGuest extractGuestFromJson(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        
        ManageGuest guest = new ManageGuest();
        
        if (json.has("id") && !json.get("id").isJsonNull()) {
            guest.setId(json.get("id").getAsInt());
        }
        
        if (json.has("fullName") && !json.get("fullName").isJsonNull()) {
            guest.setFullName(json.get("fullName").getAsString());
        }
        
        if (json.has("username") && !json.get("username").isJsonNull()) {
            guest.setUsername(json.get("username").getAsString());
        }
        
        if (json.has("email") && !json.get("email").isJsonNull()) {
            guest.setEmail(json.get("email").getAsString());
        }
        
        if (json.has("phone") && !json.get("phone").isJsonNull()) {
            guest.setPhone(json.get("phone").getAsString());
        }
        
        if (json.has("address") && !json.get("address").isJsonNull()) {
            guest.setAddress(json.get("address").getAsString());
        }
        
        if (json.has("gender") && !json.get("gender").isJsonNull()) {
            guest.setGender(json.get("gender").getAsString());
        }
        
        if (json.has("password") && !json.get("password").isJsonNull()) {
            guest.setPassword(json.get("password").getAsString());
        }
        
        if (json.has("status") && !json.get("status").isJsonNull()) {
            guest.setStatus(json.get("status").getAsString());
        }
        
        if (json.has("lastLogin") && !json.get("lastLogin").isJsonNull()) {
            guest.setLastLogin(LocalDateTime.parse(json.get("lastLogin").getAsString()));
        }
        
        if (json.has("createdDate") && !json.get("createdDate").isJsonNull()) {
            guest.setCreatedDate(LocalDate.parse(json.get("createdDate").getAsString()));
        } else {
            guest.setCreatedDate(LocalDate.now());
        }
        
        // Always set updated date to now
        guest.setUpdatedDate(LocalDateTime.now());
        
        return guest;
    }
    
    // Extract ManageGuest from form data
    private ManageGuest extractGuestFromForm(HttpServletRequest request) {
        ManageGuest guest = new ManageGuest();
        
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            guest.setId(Integer.parseInt(id));
        }
        
        String fullName = request.getParameter("fullName");
        if (fullName != null && !fullName.isEmpty()) {
            guest.setFullName(fullName);
        }
        
        String username = request.getParameter("username");
        if (username != null && !username.isEmpty()) {
            guest.setUsername(username);
        }
        
        String email = request.getParameter("email");
        if (email != null && !email.isEmpty()) {
            guest.setEmail(email);
        }
        
        String phone = request.getParameter("phone");
        if (phone != null && !phone.isEmpty()) {
            guest.setPhone(phone);
        }
        
        String address = request.getParameter("address");
        if (address != null && !address.isEmpty()) {
            guest.setAddress(address);
        }
        
        String gender = request.getParameter("gender");
        if (gender != null && !gender.isEmpty()) {
            guest.setGender(gender);
        }
        
        String password = request.getParameter("password");
        if (password != null && !password.isEmpty()) {
            guest.setPassword(password);
        }
        
        String status = request.getParameter("status");
        if (status != null && !status.isEmpty()) {
            guest.setStatus(status);
        }
        
        String createdDate = request.getParameter("createdDate");
        if (createdDate != null && !createdDate.isEmpty()) {
            guest.setCreatedDate(LocalDate.parse(createdDate));
        } else {
            guest.setCreatedDate(LocalDate.now());
        }
        
        guest.setUpdatedDate(LocalDateTime.now());
        
        return guest;
    }
}