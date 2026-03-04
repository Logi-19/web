package wepapp.controller;

import wepapp.model.ManageRoom;
import wepapp.service.ManageRoomService;
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

@WebServlet("/managerooms/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class ManageRoomController extends HttpServlet {
    
    private ManageRoomService roomService;
    private Gson gson;
    private String uploadBasePath;
    private String roomUploadPath;
    
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
        this.roomService = new ManageRoomService();
        
        // Create Gson with custom adapters for Java 8 Time API
        this.gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .create();
        
        uploadBasePath = getServletContext().getRealPath("/") + "uploads" + File.separator;
        roomUploadPath = uploadBasePath + "rooms" + File.separator;
        
        new File(uploadBasePath).mkdirs();
        new File(roomUploadPath).mkdirs();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/managerooms.jsp")) {
            request.getRequestDispatcher("/managerooms.jsp").forward(request, response);
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
                List<ManageRoom> rooms = roomService.getAllRooms();
                out.print(gson.toJson(rooms));
                
            } else if (pathInfo.equals("/api/available")) {
                List<ManageRoom> rooms = roomService.getAvailableRooms();
                out.print(gson.toJson(rooms));
                
            } else if (pathInfo.equals("/api/maintenance")) {
                List<ManageRoom> rooms = roomService.getMaintenanceRooms();
                out.print(gson.toJson(rooms));
                
            } else if (pathInfo.equals("/api/room-types-with-counts")) {
                out.print(gson.toJson(roomService.getRoomTypeStatistics()));
                
            } else if (pathInfo.equals("/api/stats")) {
                out.print(gson.toJson(roomService.getStats()));
                
            } else if (pathInfo.equals("/api/next-prefix")) {
                out.print(gson.toJson(Map.of("prefix", roomService.getNextRoomPrefix())));
                
            } else if (pathInfo.equals("/api/exists")) {
                String roomNo = request.getParameter("roomNo");
                boolean exists = roomNo != null && roomService.roomNumberExists(roomNo);
                out.print(gson.toJson(Map.of("exists", exists)));
                
            } else if (pathInfo.equals("/api/search")) {
                String keyword = request.getParameter("q");
                List<ManageRoom> rooms = keyword != null ? roomService.searchRooms(keyword) : new ArrayList<>();
                out.print(gson.toJson(rooms));
                
            } else if (pathInfo.equals("/api/advanced-search")) {
                handleAdvancedSearch(request, out);
                
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = Integer.parseInt(pathInfo.split("/")[2]);
                ManageRoom room = roomService.getRoomById(id);
                if (room != null) {
                    out.print(gson.toJson(room));
                } else {
                    out.print(gson.toJson(Map.of("error", "Room not found")));
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
        String typeIdParam = request.getParameter("typeId");
        String status = request.getParameter("status");
        String minCapacityParam = request.getParameter("minCapacity");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        String facilityIdsParam = request.getParameter("facilityIds");
        
        Integer typeId = parseInteger(typeIdParam);
        Integer minCapacity = parseInteger(minCapacityParam);
        Double minPrice = parseDouble(minPriceParam);
        Double maxPrice = parseDouble(maxPriceParam);
        
        List<Integer> facilityIds = null;
        if (facilityIdsParam != null && !facilityIdsParam.isEmpty() && !facilityIdsParam.equals("[]")) {
            try {
                Type listType = new TypeToken<ArrayList<Integer>>(){}.getType();
                facilityIds = gson.fromJson(facilityIdsParam, listType);
            } catch (Exception e) {
                try {
                    Integer singleId = Integer.parseInt(facilityIdsParam.replace("[", "").replace("]", "").trim());
                    facilityIds = new ArrayList<>();
                    facilityIds.add(singleId);
                } catch (Exception ex) {
                    // Ignore
                }
            }
        }
        
        List<ManageRoom> rooms = roomService.advancedSearch(
            keyword, typeId, status, minCapacity, minPrice, maxPrice, facilityIds
        );
        out.print(gson.toJson(rooms));
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
                handleCreateRoom(request, out);
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
                    part.write(roomUploadPath + fileName);
                    uploadedUrls.add(request.getContextPath() + "/uploads/rooms/" + fileName);
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
    
    private void handleCreateRoom(HttpServletRequest request, PrintWriter out) throws IOException {
        try {
            ManageRoom room = extractRoomFromRequest(request);
            ManageRoomService.ValidationResult result = roomService.createRoom(room);
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
                handleUpdateRoom(request, id, out);
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
    
    private void handleUpdateRoom(HttpServletRequest request, int id, PrintWriter out) throws IOException {
        try {
            ManageRoom room = extractRoomFromRequest(request);
            room.setId(id);
            ManageRoomService.ValidationResult result = roomService.updateRoom(room);
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
            boolean deleted = roomService.deleteRoom(id);
            out.print(gson.toJson(Map.of(
                "success", deleted,
                "message", deleted ? "Room deleted successfully" : "Failed to delete room"
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
    
    private ManageRoom extractRoomFromRequest(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        ManageRoom room = new ManageRoom();
        
        if (json.has("id") && !json.get("id").isJsonNull()) {
            room.setId(json.get("id").getAsInt());
        }
        if (json.has("roomPrefix") && !json.get("roomPrefix").isJsonNull()) {
            room.setRoomPrefix(json.get("roomPrefix").getAsString());
        }
        if (json.has("roomNo") && !json.get("roomNo").isJsonNull()) {
            room.setRoomNo(json.get("roomNo").getAsString());
        }
        if (json.has("description") && !json.get("description").isJsonNull()) {
            room.setDescription(json.get("description").getAsString());
        }
        if (json.has("typeId") && !json.get("typeId").isJsonNull()) {
            room.setTypeId(json.get("typeId").getAsInt());
        }
        if (json.has("capacity") && !json.get("capacity").isJsonNull()) {
            room.setCapacity(json.get("capacity").getAsInt());
        }
        if (json.has("price") && !json.get("price").isJsonNull()) {
            room.setPrice(json.get("price").getAsDouble());
        }
        if (json.has("status") && !json.get("status").isJsonNull()) {
            room.setStatus(json.get("status").getAsString());
        }
        
        if (json.has("facilityIds") && !json.get("facilityIds").isJsonNull()) {
            List<Integer> facilityIds = new ArrayList<>();
            json.getAsJsonArray("facilityIds").forEach(e -> facilityIds.add(e.getAsInt()));
            room.setFacilityIds(facilityIds);
        }
        
        if (json.has("images") && !json.get("images").isJsonNull()) {
            List<String> images = new ArrayList<>();
            json.getAsJsonArray("images").forEach(e -> images.add(e.getAsString()));
            room.setImages(images);
        }
        
        return room;
    }
}