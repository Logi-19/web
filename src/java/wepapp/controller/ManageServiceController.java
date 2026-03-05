package wepapp.controller;

import wepapp.model.ManageService;
import wepapp.service.ManageServiceService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
import com.google.gson.reflect.TypeToken;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet("/manageservices/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class ManageServiceController extends HttpServlet {
    
    private ManageServiceService serviceService;
    private Gson gson;
    private String uploadBasePath;
    private String serviceUploadPath;
    
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
    public void init() throws ServletException {
        this.serviceService = new ManageServiceService();
        
        // Create Gson with custom adapters for Java 8 Time API
        this.gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .create();
        
        uploadBasePath = getServletContext().getRealPath("/") + "uploads" + File.separator;
        serviceUploadPath = uploadBasePath + "services" + File.separator;
        
        new File(uploadBasePath).mkdirs();
        new File(serviceUploadPath).mkdirs();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/manageservices.jsp")) {
            request.getRequestDispatcher("/manageservices.jsp").forward(request, response);
            return;
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo.startsWith("/api")) {
                handleApiGetRequest(pathInfo, request, out);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(Map.of("error", "Endpoint not found")));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("error", e.getMessage())));
        }
    }
    
    private void handleApiGetRequest(String pathInfo, HttpServletRequest request, PrintWriter out) {
        try {
            if (pathInfo.equals("/api/list")) {
                List<ManageService> services = serviceService.getAllServices();
                out.print(gson.toJson(services));
                
            } else if (pathInfo.equals("/api/available")) {
                List<ManageService> services = serviceService.getAvailableServices();
                out.print(gson.toJson(services));
                
            } else if (pathInfo.equals("/api/unavailable")) {
                List<ManageService> services = serviceService.getUnavailableServices();
                out.print(gson.toJson(services));
                
            } else if (pathInfo.equals("/api/category-stats")) {
                out.print(gson.toJson(serviceService.getCategoryStatistics()));
                
            } else if (pathInfo.equals("/api/stats")) {
                out.print(gson.toJson(serviceService.getStats()));
                
            } else if (pathInfo.equals("/api/exists")) {
                String title = request.getParameter("title");
                boolean exists = title != null && serviceService.serviceTitleExists(title);
                out.print(gson.toJson(Map.of("exists", exists)));
                
            } else if (pathInfo.equals("/api/search")) {
                String keyword = request.getParameter("q");
                List<ManageService> services = keyword != null ? serviceService.searchServices(keyword) : new ArrayList<>();
                out.print(gson.toJson(services));
                
            } else if (pathInfo.equals("/api/advanced-search")) {
                handleAdvancedSearch(request, out);
                
            } else if (pathInfo.equals("/api/by-category")) {
                String categoryIdParam = request.getParameter("categoryId");
                if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                    int categoryId = Integer.parseInt(categoryIdParam);
                    List<ManageService> services = serviceService.getServicesByCategory(categoryId);
                    out.print(gson.toJson(services));
                } else {
                    out.print(gson.toJson(new ArrayList<>()));
                }
                
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = Integer.parseInt(pathInfo.split("/")[2]);
                ManageService service = serviceService.getServiceById(id);
                if (service != null) {
                    out.print(gson.toJson(service));
                } else {
                    out.print(gson.toJson(Map.of("error", "Service not found")));
                }
            } else {
                out.print(gson.toJson(Map.of("error", "API endpoint not found")));
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print(gson.toJson(Map.of("error", e.getMessage())));
        }
    }
    
    private void handleAdvancedSearch(HttpServletRequest request, PrintWriter out) {
        String keyword = request.getParameter("keyword");
        String categoryIdParam = request.getParameter("categoryId");
        String status = request.getParameter("status");
        String minDurationParam = request.getParameter("minDuration");
        String maxDurationParam = request.getParameter("maxDuration");
        String minFeesParam = request.getParameter("minFees");
        String maxFeesParam = request.getParameter("maxFees");
        
        Integer categoryId = parseInteger(categoryIdParam);
        Integer minDuration = parseInteger(minDurationParam);
        Integer maxDuration = parseInteger(maxDurationParam);
        Double minFees = parseDouble(minFeesParam);
        Double maxFees = parseDouble(maxFeesParam);
        
        List<ManageService> services = serviceService.advancedSearch(
            keyword, categoryId, status, minDuration, maxDuration, minFees, maxFees
        );
        out.print(gson.toJson(services));
    }
    
    private Integer parseInteger(String value) {
        if (value == null || value.isEmpty() || value.equals("all") || value.equals("null")) return null;
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    private Double parseDouble(String value) {
        if (value == null || value.isEmpty() || value.equals("null")) return null;
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(Map.of("error", "Invalid request")));
                return;
            }
            
            if (pathInfo.equals("/api/upload")) {
                handleImageUpload(request, out);
            } else if (pathInfo.equals("/api/create")) {
                handleCreateService(request, out);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(Map.of("error", "API endpoint not found")));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("error", e.getMessage())));
        }
    }
    
    private void handleImageUpload(HttpServletRequest request, PrintWriter out) 
            throws IOException, ServletException {
        try {
            List<String> uploadedUrls = new ArrayList<>();
            
            for (Part part : request.getParts()) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    String fileName = UUID.randomUUID().toString() + "_" + getFileName(part);
                    part.write(serviceUploadPath + fileName);
                    uploadedUrls.add(request.getContextPath() + "/uploads/services/" + fileName);
                }
            }
            
            Map<String, Object> responseMap = new HashMap<>();
            responseMap.put("success", true);
            responseMap.put("images", uploadedUrls);
            responseMap.put("message", "Images uploaded successfully");
            
            out.print(gson.toJson(responseMap));
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print(gson.toJson(Map.of("success", false, "error", e.getMessage())));
        }
    }
    
    private void handleCreateService(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
            ManageService service = extractServiceFromRequest(request);
            ManageServiceService.ValidationResult result = serviceService.createService(service);
            out.print(gson.toJson(Map.of("success", result.isValid(), "message", result.getMessage())));
        } catch (JsonSyntaxException e) {
            out.print(gson.toJson(Map.of("success", false, "message", "Invalid JSON format")));
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(Map.of("error", "Invalid request")));
                return;
            }
            
            if (pathInfo.matches("/api/\\d+")) {
                int id = Integer.parseInt(pathInfo.split("/")[2]);
                handleUpdateService(request, id, out);
            } else if (pathInfo.equals("/api/status")) {
                handleUpdateStatus(request, out);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(Map.of("error", "API endpoint not found")));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("error", e.getMessage())));
        }
    }
    
    private void handleUpdateService(HttpServletRequest request, int id, PrintWriter out) throws IOException {
        try {
            ManageService service = extractServiceFromRequest(request);
            service.setId(id);
            ManageServiceService.ValidationResult result = serviceService.updateService(service);
            out.print(gson.toJson(Map.of("success", result.isValid(), "message", result.getMessage())));
        } catch (JsonSyntaxException e) {
            out.print(gson.toJson(Map.of("success", false, "message", "Invalid JSON format")));
        }
    }
    
    private void handleUpdateStatus(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
            JsonObject json = parseJsonRequest(request);
            int id = json.get("id").getAsInt();
            String status = json.get("status").getAsString();
            
            boolean updated = serviceService.updateServiceStatus(id, status);
            out.print(gson.toJson(Map.of(
                "success", updated,
                "message", updated ? "Status updated successfully" : "Failed to update status"
            )));
        } catch (Exception e) {
            e.printStackTrace();
            out.print(gson.toJson(Map.of("success", false, "message", e.getMessage())));
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo == null || !pathInfo.matches("/api/\\d+")) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(Map.of("error", "API endpoint not found")));
                return;
            }
            
            int id = Integer.parseInt(pathInfo.split("/")[2]);
            boolean deleted = serviceService.deleteService(id);
            out.print(gson.toJson(Map.of(
                "success", deleted,
                "message", deleted ? "Service deleted successfully" : "Failed to delete service"
            )));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("error", e.getMessage())));
        }
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return UUID.randomUUID().toString() + ".jpg";
    }
    
    private JsonObject parseJsonRequest(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        return JsonParser.parseString(sb.toString()).getAsJsonObject();
    }
    
    private ManageService extractServiceFromRequest(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        ManageService service = new ManageService();
        
        if (json.has("id") && !json.get("id").isJsonNull()) {
            service.setId(json.get("id").getAsInt());
        }
        if (json.has("title") && !json.get("title").isJsonNull()) {
            service.setTitle(json.get("title").getAsString());
        }
        if (json.has("description") && !json.get("description").isJsonNull()) {
            service.setDescription(json.get("description").getAsString());
        }
        if (json.has("categoryId") && !json.get("categoryId").isJsonNull()) {
            service.setCategoryId(json.get("categoryId").getAsInt());
        }
        if (json.has("duration") && !json.get("duration").isJsonNull()) {
            service.setDuration(json.get("duration").getAsInt());
        }
        if (json.has("fees") && !json.get("fees").isJsonNull()) {
            service.setFees(json.get("fees").getAsDouble());
        }
        if (json.has("status") && !json.get("status").isJsonNull()) {
            service.setStatus(json.get("status").getAsString());
        }
        
        if (json.has("images") && !json.get("images").isJsonNull()) {
            List<String> images = new ArrayList<>();
            json.getAsJsonArray("images").forEach(e -> images.add(e.getAsString()));
            service.setImages(images);
        }
        
        return service;
    }
}