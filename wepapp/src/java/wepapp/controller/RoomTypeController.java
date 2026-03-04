package wepapp.controller;

import wepapp.model.RoomType;
import wepapp.service.RoomTypeService;
import com.google.gson.*;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/roomtypes/*")
public class RoomTypeController extends HttpServlet {
    
    private RoomTypeService roomTypeService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        try {
            this.roomTypeService = new RoomTypeService();
            
            this.gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
                
            System.out.println("RoomTypeController initialized successfully");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Failed to initialize RoomTypeController", e);
        }
    }
    
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
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/roomtypes.jsp")) {
            request.getRequestDispatcher("/roomtypes.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/api")) {
            handleApiGetRequest(request, response, pathInfo);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
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
    
    private void handleApiGetRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo.equals("/api/list")) {
                List<RoomType> roomTypes = roomTypeService.getAllRoomTypes();
                out.print(gson.toJson(roomTypes));
                
            } else if (pathInfo.equals("/api/recent")) {
                int limit = getIntParameter(request, "limit", 5);
                List<RoomType> roomTypes = roomTypeService.getRecentRoomTypes(limit);
                out.print(gson.toJson(roomTypes));
                
            } else if (pathInfo.equals("/api/search")) {
                String keyword = request.getParameter("q");
                if (keyword != null && !keyword.trim().isEmpty()) {
                    List<RoomType> roomTypes = roomTypeService.searchRoomTypes(keyword);
                    out.print(gson.toJson(roomTypes));
                } else {
                    out.print(gson.toJson(new ArrayList<>()));
                }
                
            } else if (pathInfo.equals("/api/exists")) {
                String name = request.getParameter("name");
                String excludeId = request.getParameter("excludeId");
                
                if (name != null && !name.trim().isEmpty()) {
                    boolean exists;
                    if (excludeId != null && !excludeId.isEmpty()) {
                        exists = roomTypeService.roomTypeExistsExcludingId(name, Integer.parseInt(excludeId));
                    } else {
                        exists = roomTypeService.roomTypeExists(name);
                    }
                    Map<String, Boolean> result = new HashMap<>();
                    result.put("exists", exists);
                    out.print(gson.toJson(result));
                } else {
                    Map<String, Boolean> result = new HashMap<>();
                    result.put("exists", false);
                    out.print(gson.toJson(result));
                }
                
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                RoomType roomType = roomTypeService.getRoomTypeById(id);
                if (roomType != null) {
                    out.print(gson.toJson(roomType));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "Room type not found");
                    out.print(gson.toJson(error));
                }
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                Map<String, String> error = new HashMap<>();
                error.put("error", "API endpoint not found");
                out.print(gson.toJson(error));
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            out.print(gson.toJson(error));
            e.printStackTrace();
        }
    }
    
    private void handleApiPostRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo.equals("/api/create")) {
                RoomType roomType = extractRoomTypeFromRequest(request);
                RoomTypeService.ValidationResult result = roomTypeService.createRoomType(roomType);
                
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("success", result.isValid());
                responseMap.put("message", result.getMessage());
                
                if (result.isValid()) {
                    responseMap.put("roomType", roomType);
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
                
                out.print(gson.toJson(responseMap));
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                Map<String, String> error = new HashMap<>();
                error.put("error", "API endpoint not found");
                out.print(gson.toJson(error));
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            out.print(gson.toJson(error));
            e.printStackTrace();
        }
    }
    
    private void handleApiPutRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                RoomType roomType = extractRoomTypeFromRequest(request);
                roomType.setId(id);
                
                RoomTypeService.ValidationResult result = roomTypeService.updateRoomType(roomType);
                
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("success", result.isValid());
                responseMap.put("message", result.getMessage());
                
                if (!result.isValid()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
                
                out.print(gson.toJson(responseMap));
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                Map<String, String> error = new HashMap<>();
                error.put("error", "API endpoint not found");
                out.print(gson.toJson(error));
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            out.print(gson.toJson(error));
            e.printStackTrace();
        }
    }
    
    private void handleApiDeleteRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                boolean deleted = roomTypeService.deleteRoomType(id);
                
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("success", deleted);
                responseMap.put("message", deleted ? "Room type deleted successfully" : "Failed to delete room type");
                
                out.print(gson.toJson(responseMap));
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                Map<String, String> error = new HashMap<>();
                error.put("error", "API endpoint not found");
                out.print(gson.toJson(error));
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            out.print(gson.toJson(error));
            e.printStackTrace();
        }
    }
    
    private int extractIdFromPath(String pathInfo) {
        String[] parts = pathInfo.split("/");
        return Integer.parseInt(parts[2]);
    }
    
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
    
    private JsonObject parseJsonRequest(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        return JsonParser.parseString(sb.toString()).getAsJsonObject();
    }
    
    private RoomType extractRoomTypeFromRequest(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        
        if (contentType != null && contentType.contains("application/json")) {
            return extractRoomTypeFromJson(request);
        } else {
            return extractRoomTypeFromForm(request);
        }
    }
    
    private RoomType extractRoomTypeFromJson(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        
        RoomType roomType = new RoomType();
        
        if (json.has("id") && !json.get("id").isJsonNull()) {
            roomType.setId(json.get("id").getAsInt());
        }
        
        if (json.has("name") && !json.get("name").isJsonNull()) {
            roomType.setName(json.get("name").getAsString());
        }
        
        roomType.setCreatedDate(LocalDate.now());
        roomType.setUpdatedDate(LocalDateTime.now());
        
        return roomType;
    }
    
    private RoomType extractRoomTypeFromForm(HttpServletRequest request) {
        RoomType roomType = new RoomType();
        
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            roomType.setId(Integer.parseInt(id));
        }
        
        String name = request.getParameter("name");
        if (name != null && !name.isEmpty()) {
            roomType.setName(name);
        }
        
        roomType.setCreatedDate(LocalDate.now());
        roomType.setUpdatedDate(LocalDateTime.now());
        
        return roomType;
    }
}