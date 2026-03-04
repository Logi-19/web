package wepapp.controller;

import wepapp.model.Facility;
import wepapp.service.FacilityService;
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
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// Front Controller Pattern - Single entry point for all facility-related requests
@WebServlet("/facility/*")
public class FacilityController extends HttpServlet {
    
    private FacilityService facilityService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        this.facilityService = new FacilityService();
        
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
               pathInfo.equals("/facilities") ||
               pathInfo.equals("/facility.jsp");
    }
    
    // Handle page requests
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/facility.jsp")) {
            // Show facility management page
            request.getRequestDispatcher("/facility.jsp").forward(request, response);
        } else if (pathInfo.equals("/facilities")) {
            // Redirect to main page
            response.sendRedirect(request.getContextPath() + "/facility/");
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
            
            // Get all facilities
            if (pathInfo.equals("/api/list")) {
                List<Facility> facilities = facilityService.getAllFacilities();
                out.print(gson.toJson(facilities));
                
            // Get recent facilities
            } else if (pathInfo.equals("/api/recent")) {
                int limit = getIntParameter(request, "limit", 5);
                List<Facility> facilities = facilityService.getRecentFacilities(limit);
                out.print(gson.toJson(facilities));
                
            // Get statistics
            } else if (pathInfo.equals("/api/stats")) {
                Map<String, Integer> stats = new HashMap<>();
                stats.put("total", facilityService.getTotalCount());
                stats.put("createdThisMonth", facilityService.getCreatedThisMonthCount());
                stats.put("createdLastMonth", facilityService.getCreatedLastMonthCount());
                out.print(gson.toJson(stats));
                
            // Search facilities
            } else if (pathInfo.equals("/api/search")) {
                String keyword = request.getParameter("q");
                if (keyword != null && !keyword.isEmpty()) {
                    List<Facility> facilities = facilityService.searchFacilities(keyword);
                    out.print(gson.toJson(facilities));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Search keyword is required")));
                }
                
            // Check if facility exists
            } else if (pathInfo.equals("/api/exists")) {
                String name = request.getParameter("name");
                String excludeId = request.getParameter("excludeId");
                
                if (name != null && !name.isEmpty()) {
                    boolean exists;
                    if (excludeId != null && !excludeId.isEmpty()) {
                        exists = facilityService.facilityExistsExcludingId(name, Integer.parseInt(excludeId));
                    } else {
                        exists = facilityService.facilityExists(name);
                    }
                    out.print(gson.toJson(Map.of("exists", exists)));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Facility name is required")));
                }
                
            // Get facility by ID
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                Facility facility = facilityService.getFacilityById(id);
                if (facility != null) {
                    out.print(gson.toJson(facility));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(Map.of("error", "Facility not found")));
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
            // Create new facility
            if (pathInfo.equals("/api/create")) {
                Facility facility = extractFacilityFromRequest(request);
                FacilityService.ValidationResult result = facilityService.createFacility(facility);
                
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("success", result.isValid());
                responseMap.put("message", result.getMessage());
                
                if (result.isValid()) {
                    responseMap.put("facility", facility);
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
    
    // Handle API PUT requests
    private void handleApiPutRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Update facility by ID
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                Facility facility = extractFacilityFromRequest(request);
                facility.setId(id);
                
                FacilityService.ValidationResult result = facilityService.updateFacility(facility);
                
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
            // Delete facility by ID
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                boolean deleted = facilityService.deleteFacility(id);
                
                out.print(gson.toJson(Map.of(
                    "success", deleted,
                    "message", deleted ? "Facility deleted successfully" : "Failed to delete facility"
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
    
    // Helper method to extract Facility from request (JSON or form)
    private Facility extractFacilityFromRequest(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        
        if (contentType != null && contentType.contains("application/json")) {
            return extractFacilityFromJson(request);
        } else {
            return extractFacilityFromForm(request);
        }
    }
    
    // Extract Facility from JSON
    private Facility extractFacilityFromJson(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        
        Facility facility = new Facility();
        
        if (json.has("id") && !json.get("id").isJsonNull()) {
            facility.setId(json.get("id").getAsInt());
        }
        
        if (json.has("name") && !json.get("name").isJsonNull()) {
            facility.setName(json.get("name").getAsString());
        }
        
        if (json.has("createdDate") && !json.get("createdDate").isJsonNull()) {
            facility.setCreatedDate(LocalDate.parse(json.get("createdDate").getAsString()));
        } else {
            facility.setCreatedDate(LocalDate.now());
        }
        
        // Always set updated date to now
        facility.setUpdatedDate(LocalDateTime.now());
        
        return facility;
    }
    
    // Extract Facility from form data
    private Facility extractFacilityFromForm(HttpServletRequest request) {
        Facility facility = new Facility();
        
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            facility.setId(Integer.parseInt(id));
        }
        
        String name = request.getParameter("name");
        if (name != null && !name.isEmpty()) {
            facility.setName(name);
        }
        
        String createdDate = request.getParameter("createdDate");
        if (createdDate != null && !createdDate.isEmpty()) {
            facility.setCreatedDate(LocalDate.parse(createdDate));
        } else {
            facility.setCreatedDate(LocalDate.now());
        }
        
        facility.setUpdatedDate(LocalDateTime.now());
        
        return facility;
    }
}