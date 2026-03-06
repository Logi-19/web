package wepapp.controller;

import wepapp.model.ManageStaff;
import wepapp.model.Role;
import wepapp.service.ManageStaffService;
import wepapp.service.RoleService;
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
import java.util.concurrent.ConcurrentHashMap;

// Front Controller Pattern - Single entry point for all staff-related requests
@WebServlet("/staff/*")
public class ManageStaffController extends HttpServlet {
    
    private ManageStaffService staffService;
    private RoleService roleService;
    private Gson gson;
    
    // Store active sessions for API authentication
    private static final Map<String, LoginSession> activeSessions = new ConcurrentHashMap<>();
    
    // Inner class for login session
    private static class LoginSession {
        int staffId;
        String staffName;
        String regNo;
        String role;
        LocalDateTime loginTime;
        
        LoginSession(int staffId, String staffName, String regNo, String role) {
            this.staffId = staffId;
            this.staffName = staffName;
            this.regNo = regNo;
            this.role = role;
            this.loginTime = LocalDateTime.now();
        }
    }
    
    @Override
    public void init() throws ServletException {
        this.staffService = new ManageStaffService();
        this.roleService = new RoleService();
        
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
               pathInfo.equals("/managestaffs.jsp") ||
               pathInfo.equals("/newstaff.jsp") ||
               pathInfo.equals("/login.jsp");
    }
    
    // Handle page requests
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/managestaffs.jsp")) {
            // Check if user is logged in via session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("staffId") == null) {
                response.sendRedirect(request.getContextPath() + "/staff/login.jsp");
                return;
            }
            // Show manage staff page
            request.getRequestDispatcher("/managestaffs.jsp").forward(request, response);
        } else if (pathInfo.equals("/newstaff.jsp")) {
            // Check if user is logged in
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("staffId") == null) {
                response.sendRedirect(request.getContextPath() + "/staff/login.jsp");
                return;
            }
            // Show new staff registration page
            // Get all roles for dropdown
            List<Role> roles = roleService.getAllRoles();
            request.setAttribute("roles", roles);
            request.getRequestDispatcher("/newstaff.jsp").forward(request, response);
        } else if (pathInfo.equals("/login.jsp")) {
            // Show login page
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else if (pathInfo.equals("/list")) {
            // Redirect to main page
            response.sendRedirect(request.getContextPath() + "/staff/");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    // Handle API GET requests
    private void handleApiGetRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        // Check authentication for protected endpoints (except public ones)
        if (!isPublicEndpoint(pathInfo)) {
//            String token = extractToken(request);
//            if (token == null || !activeSessions.containsKey(token)) {
//                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
//                out.print(gson.toJson(Map.of("error", "Unauthorized - Please login first")));
//                return;
//            }
        }
        
        try {
            if (pathInfo == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(Map.of("error", "Invalid API endpoint")));
                return;
            }
            
            // Get all staff
            if (pathInfo.equals("/api/list")) {
                List<ManageStaff> staffList = staffService.getAllStaff();
                out.print(gson.toJson(staffList));
                
            // Get recent staff
            } else if (pathInfo.equals("/api/recent")) {
                int limit = getIntParameter(request, "limit", 5);
                List<ManageStaff> staffList = staffService.getRecentStaff(limit);
                out.print(gson.toJson(staffList));
                
            // Get statistics
            } else if (pathInfo.equals("/api/stats")) {
                Map<String, Object> stats = new HashMap<>();
                stats.put("total", staffService.getTotalCount());
                stats.put("active", staffService.getActiveCount());
                stats.put("inactive", staffService.getInactiveCount());
                stats.put("joinedThisMonth", staffService.getJoinedThisMonthCount());
                
                // Get role counts
                List<Role> roles = roleService.getAllRoles();
                Map<String, Integer> roleCounts = new HashMap<>();
                for (Role role : roles) {
                    roleCounts.put(role.getName(), staffService.getCountByRoleId(role.getId()));
                }
                stats.put("roleCounts", roleCounts);
                
                out.print(gson.toJson(stats));
                
            // Search staff
            } else if (pathInfo.equals("/api/search")) {
                String keyword = request.getParameter("q");
                if (keyword != null && !keyword.isEmpty()) {
                    List<ManageStaff> staffList = staffService.searchStaff(keyword);
                    out.print(gson.toJson(staffList));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Search keyword is required")));
                }
                
            // Get staff by role
            } else if (pathInfo.equals("/api/by-role")) {
                String roleIdParam = request.getParameter("roleId");
                if (roleIdParam != null && !roleIdParam.isEmpty()) {
                    int roleId = Integer.parseInt(roleIdParam);
                    List<ManageStaff> staffList = staffService.getStaffByRoleId(roleId);
                    out.print(gson.toJson(staffList));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Role ID is required")));
                }
                
            // Get staff by status
            } else if (pathInfo.equals("/api/by-status")) {
                String status = request.getParameter("status");
                if (status != null && !status.isEmpty()) {
                    List<ManageStaff> staffList = staffService.getStaffByStatus(status);
                    out.print(gson.toJson(staffList));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Status is required")));
                }
                
            // Check if username exists
            } else if (pathInfo.equals("/api/check-username")) {
                String username = request.getParameter("username");
                String excludeId = request.getParameter("excludeId");
                
                if (username != null && !username.isEmpty()) {
                    boolean exists;
                    if (excludeId != null && !excludeId.isEmpty()) {
                        exists = staffService.usernameExistsExcludingId(username, Integer.parseInt(excludeId));
                    } else {
                        exists = staffService.usernameExists(username);
                    }
                    out.print(gson.toJson(Map.of("exists", exists)));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Username is required")));
                }
                
            // Check if email exists
            } else if (pathInfo.equals("/api/check-email")) {
                String email = request.getParameter("email");
                String excludeId = request.getParameter("excludeId");
                
                if (email != null && !email.isEmpty()) {
                    boolean exists;
                    if (excludeId != null && !excludeId.isEmpty()) {
                        exists = staffService.emailExistsExcludingId(email, Integer.parseInt(excludeId));
                    } else {
                        exists = staffService.emailExists(email);
                    }
                    out.print(gson.toJson(Map.of("exists", exists)));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Email is required")));
                }
                
            // Check if phone exists
            } else if (pathInfo.equals("/api/check-phone")) {
                String phone = request.getParameter("phone");
                String excludeId = request.getParameter("excludeId");
                
                if (phone != null && !phone.isEmpty()) {
                    boolean exists;
                    if (excludeId != null && !excludeId.isEmpty()) {
                        exists = staffService.phoneExistsExcludingId(phone, Integer.parseInt(excludeId));
                    } else {
                        exists = staffService.phoneExists(phone);
                    }
                    out.print(gson.toJson(Map.of("exists", exists)));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Phone number is required")));
                }
                
            // Get staff by ID
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                ManageStaff staff = staffService.getStaffById(id);
                if (staff != null) {
                    // Add role information
                    Map<String, Object> responseMap = new HashMap<>();
                    responseMap.put("staff", staff);
                    responseMap.put("role", staffService.getStaffRole(id));
                    out.print(gson.toJson(responseMap));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(Map.of("error", "Staff member not found")));
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
            // Create new staff
            if (pathInfo.equals("/api/create")) {
                // Check authentication for creating staff
//                String token = extractToken(request);
//                if (token == null || !activeSessions.containsKey(token)) {
//                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
//                    out.print(gson.toJson(Map.of("error", "Unauthorized - Please login first")));
//                    return;
//                }
                
                ManageStaff staff = extractStaffFromRequest(request);
                ManageStaffService.ValidationResult result = staffService.createStaff(staff);
                
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("success", result.isValid());
                responseMap.put("message", result.getMessage());
                
                if (result.isValid()) {
                    // Don't send password back
                    staff.setPassword(null);
                    responseMap.put("staff", staff);
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
                
                out.print(gson.toJson(responseMap));
                
            // Authenticate staff - Returns token for future use
            } else if (pathInfo.equals("/api/login")) {
                JsonObject json = parseJsonRequest(request);
                String username = json.has("username") ? json.get("username").getAsString() : null;
                String password = json.has("password") ? json.get("password").getAsString() : null;
                
                if (username != null && password != null) {
                    ManageStaff staff = staffService.authenticate(username, password);
                    
                    if (staff != null) {
                        // Update last login
                        staffService.updateLastLogin(staff.getId());
                        
                        // Also set in HTTP session
                        HttpSession session = request.getSession(true);
                        session.setAttribute("staffId", staff.getId());
                        session.setAttribute("staffName", staff.getFullname());
                        session.setAttribute("staffRegNo", staff.getRegNo());
                        
                        // Get role name
                        Role role = roleService.getRoleById(staff.getRoleId());
                        String roleName = role != null ? role.getName() : "Staff";
                        session.setAttribute("staffRole", roleName);
                        
                        // Generate token for API session management
                        String token = UUID.randomUUID().toString();
                        activeSessions.put(token, new LoginSession(
                            staff.getId(), 
                            staff.getFullname(), 
                            staff.getRegNo(),
                            roleName
                        ));
                        
                        // Return success with token and user info
                        Map<String, Object> responseMap = new HashMap<>();
                        responseMap.put("success", true);
                        responseMap.put("message", "Login successful");
                        responseMap.put("token", token); // Token for future session management
                        responseMap.put("staffId", staff.getId());
                        responseMap.put("staffName", staff.getFullname());
                        responseMap.put("staffRegNo", staff.getRegNo());
                        responseMap.put("staffEmail", staff.getEmail());
                        responseMap.put("staffRole", roleName);
                        responseMap.put("staffRoleId", staff.getRoleId());
                        
                        out.print(gson.toJson(responseMap));
                    } else {
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                        out.print(gson.toJson(Map.of(
                            "success", false,
                            "message", "Invalid username or password or account is inactive"
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
                String token = extractToken(request);
                if (token != null) {
                    activeSessions.remove(token);
                }
                
                // Invalidate HTTP session
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                
                out.print(gson.toJson(Map.of(
                    "success", true,
                    "message", "Logout successful"
                )));
                
            // Verify token - Check if token is still valid
            } else if (pathInfo.equals("/api/verify-token")) {
                String token = extractToken(request);
                if (token != null && activeSessions.containsKey(token)) {
                    LoginSession session = activeSessions.get(token);
                    out.print(gson.toJson(Map.of(
                        "success", true,
                        "valid", true,
                        "staffId", session.staffId,
                        "staffName", session.staffName,
                        "staffRegNo", session.regNo,
                        "staffRole", session.role
                    )));
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
    
    // Handle API PUT requests
    private void handleApiPutRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        // Check authentication for protected endpoints
//        String token = extractToken(request);
//        if (token == null || !activeSessions.containsKey(token)) {
//            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
//            out.print(gson.toJson(Map.of("error", "Unauthorized - Please login first")));
//            return;
//        }
        
        try {
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                
                // Update staff details
                if (request.getParameter("action") == null) {
                    ManageStaff staff = extractStaffFromRequest(request);
                    staff.setId(id);
                    
                    ManageStaffService.ValidationResult result = staffService.updateStaff(staff);
                    
                    out.print(gson.toJson(Map.of(
                        "success", result.isValid(),
                        "message", result.getMessage()
                    )));
                    
                // Update password only
                } else if ("password".equals(request.getParameter("action"))) {
                    JsonObject json = parseJsonRequest(request);
                    String newPassword = json.has("password") ? json.get("password").getAsString() : null;
                    
                    if (newPassword != null) {
                        ManageStaffService.ValidationResult result = staffService.updatePassword(id, newPassword);
                        out.print(gson.toJson(Map.of(
                            "success", result.isValid(),
                            "message", result.getMessage()
                        )));
                    } else {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Map.of("error", "Password is required")));
                    }
                    
                // Update status only
                } else if ("status".equals(request.getParameter("action"))) {
                    JsonObject json = parseJsonRequest(request);
                    String status = json.has("status") ? json.get("status").getAsString() : null;
                    
                    if (status != null) {
                        ManageStaffService.ValidationResult result = staffService.updateStatus(id, status);
                        out.print(gson.toJson(Map.of(
                            "success", result.isValid(),
                            "message", result.getMessage()
                        )));
                    } else {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Map.of("error", "Status is required")));
                    }
                    
                // Update role only
                } else if ("role".equals(request.getParameter("action"))) {
                    JsonObject json = parseJsonRequest(request);
                    int roleId = json.has("roleId") ? json.get("roleId").getAsInt() : 0;
                    
                    if (roleId > 0) {
                        ManageStaffService.ValidationResult result = staffService.updateRole(id, roleId);
                        out.print(gson.toJson(Map.of(
                            "success", result.isValid(),
                            "message", result.getMessage()
                        )));
                    } else {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Map.of("error", "Role ID is required")));
                    }
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
    
    // Handle API DELETE requests
    private void handleApiDeleteRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        // Check authentication for protected endpoints
//        String token = extractToken(request);
//        if (token == null || !activeSessions.containsKey(token)) {
//            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
//            out.print(gson.toJson(Map.of("error", "Unauthorized - Please login first")));
//            return;
//        }
        
        try {
            // Delete staff by ID
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                boolean deleted = staffService.deleteStaff(id);
                
                out.print(gson.toJson(Map.of(
                    "success", deleted,
                    "message", deleted ? "Staff member deleted successfully" : "Failed to delete staff member"
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
    
    // Helper method to check if endpoint is public (no authentication required)
    private boolean isPublicEndpoint(String pathInfo) {
        return pathInfo != null && (
            pathInfo.equals("/api/login") ||
            pathInfo.equals("/api/logout") ||
            pathInfo.equals("/api/verify-token") ||
            pathInfo.equals("/api/check-username") ||
            pathInfo.equals("/api/check-email") ||
            pathInfo.equals("/api/check-phone")
        );
    }
    
    // Helper method to extract token from request
    private String extractToken(HttpServletRequest request) {
        // Check Authorization header first
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            return authHeader.substring(7);
        }
        
        // Then check query parameter
        String token = request.getParameter("token");
        if (token != null && !token.isEmpty()) {
            return token;
        }
        
        // Then check session
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute("apiToken");
        }
        
        return null;
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
    
    // Helper method to extract ManageStaff from request (JSON or form)
    private ManageStaff extractStaffFromRequest(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        
        if (contentType != null && contentType.contains("application/json")) {
            return extractStaffFromJson(request);
        } else {
            return extractStaffFromForm(request);
        }
    }
    
    // Extract ManageStaff from JSON
    private ManageStaff extractStaffFromJson(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        
        ManageStaff staff = new ManageStaff();
        
        if (json.has("id") && !json.get("id").isJsonNull()) {
            staff.setId(json.get("id").getAsInt());
        }
        
        if (json.has("fullname") && !json.get("fullname").isJsonNull()) {
            staff.setFullname(json.get("fullname").getAsString());
        }
        
        if (json.has("username") && !json.get("username").isJsonNull()) {
            staff.setUsername(json.get("username").getAsString());
        }
        
        if (json.has("email") && !json.get("email").isJsonNull()) {
            staff.setEmail(json.get("email").getAsString());
        }
        
        if (json.has("phone") && !json.get("phone").isJsonNull()) {
            staff.setPhone(json.get("phone").getAsString());
        }
        
        if (json.has("gender") && !json.get("gender").isJsonNull()) {
            staff.setGender(json.get("gender").getAsString());
        }
        
        if (json.has("address") && !json.get("address").isJsonNull()) {
            staff.setAddress(json.get("address").getAsString());
        }
        
        if (json.has("password") && !json.get("password").isJsonNull()) {
            staff.setPassword(json.get("password").getAsString());
        }
        
        if (json.has("roleId") && !json.get("roleId").isJsonNull()) {
            staff.setRoleId(json.get("roleId").getAsInt());
        } else {
            staff.setRoleId(2); // Default role ID is 2 (Staff)
        }
        
        if (json.has("status") && !json.get("status").isJsonNull()) {
            staff.setStatus(json.get("status").getAsString());
        } else {
            staff.setStatus("active");
        }
        
        if (json.has("joinedDate") && !json.get("joinedDate").isJsonNull()) {
            staff.setJoinedDate(LocalDate.parse(json.get("joinedDate").getAsString()));
        } else {
            staff.setJoinedDate(LocalDate.now());
        }
        
        staff.setUpdatedDate(LocalDateTime.now());
        
        return staff;
    }
    
    // Extract ManageStaff from form data
    private ManageStaff extractStaffFromForm(HttpServletRequest request) {
        ManageStaff staff = new ManageStaff();
        
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            staff.setId(Integer.parseInt(id));
        }
        
        String fullname = request.getParameter("fullname");
        if (fullname != null && !fullname.isEmpty()) {
            staff.setFullname(fullname);
        }
        
        String username = request.getParameter("username");
        if (username != null && !username.isEmpty()) {
            staff.setUsername(username);
        }
        
        String email = request.getParameter("email");
        if (email != null && !email.isEmpty()) {
            staff.setEmail(email);
        }
        
        String phone = request.getParameter("phone");
        if (phone != null && !phone.isEmpty()) {
            staff.setPhone(phone);
        }
        
        String gender = request.getParameter("gender");
        if (gender != null && !gender.isEmpty()) {
            staff.setGender(gender);
        }
        
        String address = request.getParameter("address");
        if (address != null && !address.isEmpty()) {
            staff.setAddress(address);
        }
        
        String password = request.getParameter("password");
        if (password != null && !password.isEmpty()) {
            staff.setPassword(password);
        }
        
        String roleId = request.getParameter("roleId");
        if (roleId != null && !roleId.isEmpty()) {
            staff.setRoleId(Integer.parseInt(roleId));
        } else {
            staff.setRoleId(2); // Default role ID is 2 (Staff)
        }
        
        String status = request.getParameter("status");
        if (status != null && !status.isEmpty()) {
            staff.setStatus(status);
        } else {
            staff.setStatus("active");
        }
        
        String joinedDate = request.getParameter("joinedDate");
        if (joinedDate != null && !joinedDate.isEmpty()) {
            staff.setJoinedDate(LocalDate.parse(joinedDate));
        } else {
            staff.setJoinedDate(LocalDate.now());
        }
        
        staff.setUpdatedDate(LocalDateTime.now());
        
        return staff;
    }
}