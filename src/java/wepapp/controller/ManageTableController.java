package wepapp.controller;

import wepapp.model.ManageTable;
import wepapp.service.ManageTableService;
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

@WebServlet("/managetables/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class ManageTableController extends HttpServlet {
    
    private ManageTableService tableService;
    private Gson gson;
    private String uploadBasePath;
    private String tableUploadPath;
    
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
        this.tableService = new ManageTableService();
        
        // Create Gson with custom adapters for Java 8 Time API
        this.gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .create();
        
        uploadBasePath = getServletContext().getRealPath("/") + "uploads" + File.separator;
        tableUploadPath = uploadBasePath + "tables" + File.separator;
        
        new File(uploadBasePath).mkdirs();
        new File(tableUploadPath).mkdirs();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/managetables.jsp")) {
            request.getRequestDispatcher("/managetables.jsp").forward(request, response);
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
                List<ManageTable> tables = tableService.getAllTables();
                out.print(gson.toJson(tables));
                
            } else if (pathInfo.equals("/api/available")) {
                List<ManageTable> tables = tableService.getAvailableTables();
                out.print(gson.toJson(tables));
                
            } else if (pathInfo.equals("/api/maintenance")) {
                List<ManageTable> tables = tableService.getMaintenanceTables();
                out.print(gson.toJson(tables));
                
            } else if (pathInfo.equals("/api/location-stats")) {
                out.print(gson.toJson(tableService.getLocationStatistics()));
                
            } else if (pathInfo.equals("/api/stats")) {
                out.print(gson.toJson(tableService.getStats()));
                
            } else if (pathInfo.equals("/api/next-prefix")) {
                out.print(gson.toJson(Map.of("prefix", tableService.getNextTablePrefix())));
                
            } else if (pathInfo.equals("/api/exists")) {
                String tableNo = request.getParameter("tableNo");
                boolean exists = tableNo != null && tableService.tableNumberExists(tableNo);
                out.print(gson.toJson(Map.of("exists", exists)));
                
            } else if (pathInfo.equals("/api/search")) {
                String keyword = request.getParameter("q");
                List<ManageTable> tables = keyword != null ? tableService.searchTables(keyword) : new ArrayList<>();
                out.print(gson.toJson(tables));
                
            } else if (pathInfo.equals("/api/by-location")) {
                String locationIdParam = request.getParameter("locationId");
                if (locationIdParam != null && !locationIdParam.isEmpty()) {
                    int locationId = Integer.parseInt(locationIdParam);
                    List<ManageTable> tables = tableService.getTablesByLocation(locationId);
                    out.print(gson.toJson(tables));
                } else {
                    out.print(gson.toJson(new ArrayList<>()));
                }
                
            } else if (pathInfo.equals("/api/advanced-search")) {
                handleAdvancedSearch(request, out);
                
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = Integer.parseInt(pathInfo.split("/")[2]);
                ManageTable table = tableService.getTableById(id);
                if (table != null) {
                    out.print(gson.toJson(table));
                } else {
                    out.print(gson.toJson(Map.of("error", "Table not found")));
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
        String locationIdParam = request.getParameter("locationId");
        String status = request.getParameter("status");
        String minCapacityParam = request.getParameter("minCapacity");
        
        Integer locationId = parseInteger(locationIdParam);
        Integer minCapacity = parseInteger(minCapacityParam);
        
        List<ManageTable> tables = tableService.advancedSearch(keyword, locationId, status, minCapacity);
        out.print(gson.toJson(tables));
    }
    
    private Integer parseInteger(String value) {
        if (value == null || value.isEmpty() || value.equals("all") || value.equals("null")) return null;
        try {
            return Integer.parseInt(value);
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
                handleCreateTable(request, out);
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
                    part.write(tableUploadPath + fileName);
                    uploadedUrls.add(request.getContextPath() + "/uploads/tables/" + fileName);
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
    
    private void handleCreateTable(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
            ManageTable table = extractTableFromRequest(request);
            ManageTableService.ValidationResult result = tableService.createTable(table);
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
                handleUpdateTable(request, id, out);
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
    
    private void handleUpdateTable(HttpServletRequest request, int id, PrintWriter out) throws IOException {
        try {
            ManageTable table = extractTableFromRequest(request);
            table.setId(id);
            ManageTableService.ValidationResult result = tableService.updateTable(table);
            out.print(gson.toJson(Map.of("success", result.isValid(), "message", result.getMessage())));
        } catch (JsonSyntaxException e) {
            out.print(gson.toJson(Map.of("success", false, "message", "Invalid JSON format")));
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
            boolean deleted = tableService.deleteTable(id);
            out.print(gson.toJson(Map.of(
                "success", deleted,
                "message", deleted ? "Table deleted successfully" : "Failed to delete table"
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
    
    private ManageTable extractTableFromRequest(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        ManageTable table = new ManageTable();
        
        if (json.has("id") && !json.get("id").isJsonNull()) {
            table.setId(json.get("id").getAsInt());
        }
        if (json.has("tablePrefix") && !json.get("tablePrefix").isJsonNull()) {
            table.setTablePrefix(json.get("tablePrefix").getAsString());
        }
        if (json.has("tableNo") && !json.get("tableNo").isJsonNull()) {
            table.setTableNo(json.get("tableNo").getAsString());
        }
        if (json.has("description") && !json.get("description").isJsonNull()) {
            table.setDescription(json.get("description").getAsString());
        }
        if (json.has("locationId") && !json.get("locationId").isJsonNull()) {
            table.setLocationId(json.get("locationId").getAsInt());
        }
        if (json.has("capacity") && !json.get("capacity").isJsonNull()) {
            table.setCapacity(json.get("capacity").getAsInt());
        }
        if (json.has("status") && !json.get("status").isJsonNull()) {
            table.setStatus(json.get("status").getAsString());
        }
        
        if (json.has("images") && !json.get("images").isJsonNull()) {
            List<String> images = new ArrayList<>();
            json.getAsJsonArray("images").forEach(e -> images.add(e.getAsString()));
            table.setImages(images);
        }
        
        return table;
    }
}