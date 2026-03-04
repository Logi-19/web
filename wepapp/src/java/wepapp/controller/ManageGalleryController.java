package wepapp.controller;

import wepapp.model.ManageGallery;
import wepapp.service.ManageGalleryService;
import wepapp.service.BlogCategoryService;
import wepapp.model.BlogCategory;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
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
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

// Front Controller Pattern - Single entry point for all gallery management requests
@WebServlet("/managegallery/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class ManageGalleryController extends HttpServlet {
    
    private ManageGalleryService galleryService;
    private BlogCategoryService categoryService;
    private Gson gson;
    private String uploadBasePath;
    private String galleryUploadPath;
    
    @Override
    public void init() throws ServletException {
        try {
            this.galleryService = new ManageGalleryService();
            this.categoryService = new BlogCategoryService();
            
            // Create Gson with custom LocalDate and LocalDateTime adapters
            this.gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .setPrettyPrinting()
                .create();
            
            // Set base upload path - creates "uploads" folder in web root
            uploadBasePath = getServletContext().getRealPath("/") + "uploads" + File.separator;
            
            // Set gallery-specific upload path - creates "uploads/gallery/" subfolder
            galleryUploadPath = uploadBasePath + "gallery" + File.separator;
            
            // Create uploads directory and gallery subdirectory if they don't exist
            File uploadDir = new File(uploadBasePath);
            if (!uploadDir.exists()) {
                boolean created = uploadDir.mkdirs();
                if (created) {
                    System.out.println("Uploads directory created at: " + uploadBasePath);
                }
            }
            
            File galleryDir = new File(galleryUploadPath);
            if (!galleryDir.exists()) {
                boolean created = galleryDir.mkdirs();
                if (created) {
                    System.out.println("Gallery upload directory created at: " + galleryUploadPath);
                }
            }
            
            // Check if directories are writable
            if (galleryDir.exists() && !galleryDir.canWrite()) {
                System.err.println("WARNING: Gallery upload directory is not writable: " + galleryUploadPath);
                // Try to set writable
                galleryDir.setWritable(true);
            }
            
            System.out.println("ManageGalleryController initialized successfully. Upload path: " + galleryUploadPath);
            System.out.println("Context Path: " + getServletContext().getContextPath());
            System.out.println("Real Path: " + getServletContext().getRealPath("/"));
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Failed to initialize ManageGalleryController", e);
        }
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
    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Set character encoding for all requests
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String method = request.getMethod();
        String pathInfo = request.getPathInfo();
        
        System.out.println("ManageGallery Request: " + method + " " + pathInfo);
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        
        super.service(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            // Check if it's an API request or page request
            if (isPageRequest(pathInfo)) {
                // For page requests, set content type to HTML
                response.setContentType("text/html");
                response.setCharacterEncoding("UTF-8");
                handlePageRequest(request, response, pathInfo);
            } else {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                handleApiGetRequest(request, response, pathInfo);
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Server error: " + e.getMessage());
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            // Set response content type and character encoding
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            // Check if it's an API request
            if (pathInfo != null && pathInfo.startsWith("/api")) {
                // Check if it's an image upload request
                if (pathInfo.equals("/api/upload")) {
                    handleImageUpload(request, response);
                } else {
                    handleApiPostRequest(request, response, pathInfo);
                }
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Method not allowed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            // Set response content type and character encoding
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            if (pathInfo != null && pathInfo.startsWith("/api")) {
                handleApiPutRequest(request, response, pathInfo);
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Method not allowed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            // Set response content type and character encoding
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            if (pathInfo != null && pathInfo.startsWith("/api")) {
                handleApiDeleteRequest(request, response, pathInfo);
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Method not allowed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
    
    // Helper method to send error response
    private void sendErrorResponse(HttpServletResponse response, int status, String message) throws IOException {
        if (!response.isCommitted()) {
            response.setStatus(status);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", message);
            errorResponse.put("success", false);
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(errorResponse));
            out.flush();
        }
    }
    
    // Helper method to determine if it's a page request
    private boolean isPageRequest(String pathInfo) {
        return pathInfo == null || 
               pathInfo.equals("/") || 
               pathInfo.equals("/gallery") ||
               pathInfo.equals("/managegallery") ||
               pathInfo.equals("/managegallery.jsp") ||
               pathInfo.equals("");
    }
    
    // Handle page requests
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/managegallery") || pathInfo.equals("/managegallery.jsp") || pathInfo.equals("")) {
                // Get categories for dropdown
                List<BlogCategory> categories = categoryService.getAllCategories();
                request.setAttribute("categories", categories);
                
                // The JSP is in the /admin/ directory
                String jspPath = "/admin/managegallery.jsp";
                System.out.println("Forwarding to: " + jspPath);
                request.getRequestDispatcher(jspPath).forward(request, response);
                
            } else if (pathInfo.equals("/gallery")) {
                // Redirect to main page
                response.sendRedirect(request.getContextPath() + "/managegallery/");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
    
    // Handle image upload
    private void handleImageUpload(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        PrintWriter out = response.getWriter();
        Map<String, Object> responseMap = new HashMap<>();
        
        try {
            List<String> uploadedUrls = new ArrayList<>();
            
            // Check if it's a multipart request
            String contentType = request.getContentType();
            if (contentType == null || !contentType.toLowerCase().startsWith("multipart/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                responseMap.put("success", false);
                responseMap.put("error", "Request must be multipart/form-data");
                out.print(gson.toJson(responseMap));
                return;
            }
            
            // Get all uploaded parts
            Collection<Part> parts = request.getParts();
            if (parts == null || parts.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                responseMap.put("success", false);
                responseMap.put("error", "No files uploaded");
                out.print(gson.toJson(responseMap));
                return;
            }
            
            System.out.println("Processing upload with " + parts.size() + " parts");
            
            boolean fileFound = false;
            for (Part part : parts) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    fileFound = true;
                    
                    // Get original filename
                    String originalFileName = getFileName(part);
                    System.out.println("Uploading file: " + originalFileName + ", size: " + part.getSize());
                    
                    // Generate unique filename
                    String fileExtension = "";
                    if (originalFileName != null && originalFileName.contains(".")) {
                        fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                    } else {
                        fileExtension = ".jpg";
                    }
                    
                    String fileName = UUID.randomUUID().toString() + fileExtension;
                    String filePath = galleryUploadPath + fileName;
                    
                    // Save file using InputStream to ensure proper writing
                    try (InputStream fileContent = part.getInputStream()) {
                        File targetFile = new File(filePath);
                        Files.copy(fileContent, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                        System.out.println("File saved to: " + filePath);
                    }
                    
                    // Generate URL for the image (with /uploads/gallery/ path)
                    String imageUrl = request.getContextPath() + "/uploads/gallery/" + fileName;
                    uploadedUrls.add(imageUrl);
                    
                    System.out.println("Image URL: " + imageUrl);
                }
            }
            
            if (!fileFound) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                responseMap.put("success", false);
                responseMap.put("error", "No valid image files found in upload");
                out.print(gson.toJson(responseMap));
                return;
            }
            
            responseMap.put("success", true);
            responseMap.put("images", uploadedUrls);
            responseMap.put("message", "Images uploaded successfully to uploads/gallery/");
            responseMap.put("count", uploadedUrls.size());
            
            System.out.println("Upload successful. " + uploadedUrls.size() + " files uploaded.");
            out.print(gson.toJson(responseMap));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            
            responseMap.put("success", false);
            responseMap.put("error", e.getMessage());
            responseMap.put("errorType", e.getClass().getName());
            
            out.print(gson.toJson(responseMap));
        }
    }
    
    // Handle API GET requests
    private void handleApiGetRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        PrintWriter out = response.getWriter();
        Map<String, Object> errorMap = new HashMap<>();
        
        try {
            if (pathInfo == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                errorMap.put("error", "Invalid API endpoint");
                out.print(gson.toJson(errorMap));
                return;
            }
            
            System.out.println("API GET request: " + pathInfo);
            
            // Get all gallery items
            if (pathInfo.equals("/api/list")) {
                try {
                    List<ManageGallery> items = galleryService.getAllGalleryItems();
                    // Ensure items is not null
                    if (items == null) {
                        items = new ArrayList<>();
                    }
                    String jsonResponse = gson.toJson(items);
                    System.out.println("Returning " + items.size() + " gallery items");
                    out.print(jsonResponse);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    errorMap.put("error", "Failed to load gallery items: " + e.getMessage());
                    errorMap.put("success", false);
                    out.print(gson.toJson(errorMap));
                }
                
            // Get visible items
            } else if (pathInfo.equals("/api/visible")) {
                List<ManageGallery> items = galleryService.getVisibleItems();
                if (items == null) items = new ArrayList<>();
                out.print(gson.toJson(items));
                
            // Get hidden items
            } else if (pathInfo.equals("/api/hidden")) {
                List<ManageGallery> items = galleryService.getHiddenItems();
                if (items == null) items = new ArrayList<>();
                out.print(gson.toJson(items));
                
            // Get items by category
            } else if (pathInfo.equals("/api/category")) {
                String categoryIdParam = request.getParameter("id");
                if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                    try {
                        int categoryId = Integer.parseInt(categoryIdParam);
                        List<ManageGallery> items = galleryService.getItemsByCategory(categoryId);
                        if (items == null) items = new ArrayList<>();
                        out.print(gson.toJson(items));
                    } catch (NumberFormatException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        errorMap.put("error", "Invalid category ID format");
                        out.print(gson.toJson(errorMap));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    errorMap.put("error", "Category ID is required");
                    out.print(gson.toJson(errorMap));
                }
                
            // Get categories with item counts
            } else if (pathInfo.equals("/api/categories-with-counts")) {
                List<?> stats = galleryService.getCategoryStatistics();
                if (stats == null) stats = new ArrayList<>();
                out.print(gson.toJson(stats));
                
            // Get statistics
            } else if (pathInfo.equals("/api/stats")) {
                Map<String, Integer> stats = new HashMap<>();
                stats.put("total", galleryService.getTotalCount());
                stats.put("visible", galleryService.getVisibleCount());
                stats.put("hidden", galleryService.getHiddenCount());
                out.print(gson.toJson(stats));
                
            // Search items
            } else if (pathInfo.equals("/api/search")) {
                String keyword = request.getParameter("q");
                if (keyword != null && !keyword.isEmpty()) {
                    List<ManageGallery> items = galleryService.searchItems(keyword);
                    if (items == null) items = new ArrayList<>();
                    out.print(gson.toJson(items));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    errorMap.put("error", "Search keyword is required");
                    out.print(gson.toJson(errorMap));
                }
                
            // Get item by ID
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                ManageGallery item = galleryService.getGalleryItemById(id);
                if (item != null) {
                    out.print(gson.toJson(item));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    errorMap.put("error", "Gallery item not found");
                    out.print(gson.toJson(errorMap));
                }
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                errorMap.put("error", "API endpoint not found: " + pathInfo);
                out.print(gson.toJson(errorMap));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errorMap.put("error", e.getMessage());
            errorMap.put("stacktrace", e.toString());
            errorMap.put("success", false);
            out.print(gson.toJson(errorMap));
        } finally {
            out.flush();
        }
    }
    
    // Handle API POST requests
    private void handleApiPostRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        PrintWriter out = response.getWriter();
        Map<String, Object> responseMap = new HashMap<>();
        
        try {
            System.out.println("API POST request: " + pathInfo);
            
            // Create new gallery item
            if (pathInfo.equals("/api/create")) {
                ManageGallery item = extractGalleryFromRequest(request);
                ManageGalleryService.ValidationResult result = galleryService.createGalleryItem(item);
                
                responseMap.put("success", result.isValid());
                responseMap.put("message", result.getMessage());
                
                if (result.isValid()) {
                    responseMap.put("item", item);
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
                
                out.print(gson.toJson(responseMap));
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                responseMap.put("error", "API endpoint not found");
                out.print(gson.toJson(responseMap));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseMap.put("error", e.getMessage());
            out.print(gson.toJson(responseMap));
        }
    }
    
    // Handle API PUT requests
    private void handleApiPutRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        PrintWriter out = response.getWriter();
        Map<String, Object> responseMap = new HashMap<>();
        
        try {
            System.out.println("API PUT request: " + pathInfo);
            
            // Update status (visible/hidden) by ID
            if (pathInfo.matches("/api/\\d+/status")) {
                int id = extractIdFromPath(pathInfo);
                JsonObject json = parseJsonRequest(request);
                
                boolean status = json.get("status").getAsBoolean();
                boolean updated = galleryService.updateItemStatus(id, status);
                
                responseMap.put("success", updated);
                responseMap.put("message", updated ? "Status updated successfully" : "Failed to update status");
                out.print(gson.toJson(responseMap));
                
            // Toggle status
            } else if (pathInfo.matches("/api/\\d+/toggle-status")) {
                int id = extractIdFromPath(pathInfo);
                boolean updated = galleryService.toggleItemStatus(id);
                
                responseMap.put("success", updated);
                responseMap.put("message", updated ? "Status toggled successfully" : "Failed to toggle status");
                out.print(gson.toJson(responseMap));
                
            // Update entire gallery item
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                ManageGallery item = extractGalleryFromRequest(request);
                item.setId(id);
                
                ManageGalleryService.ValidationResult result = galleryService.updateGalleryItem(item);
                
                responseMap.put("success", result.isValid());
                responseMap.put("message", result.getMessage());
                out.print(gson.toJson(responseMap));
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                responseMap.put("error", "API endpoint not found");
                out.print(gson.toJson(responseMap));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseMap.put("error", e.getMessage());
            out.print(gson.toJson(responseMap));
        }
    }
    
    // Handle API DELETE requests
    private void handleApiDeleteRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        PrintWriter out = response.getWriter();
        Map<String, Object> responseMap = new HashMap<>();
        
        try {
            System.out.println("API DELETE request: " + pathInfo);
            
            // Delete gallery item by ID
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                boolean deleted = galleryService.deleteGalleryItem(id);
                
                responseMap.put("success", deleted);
                responseMap.put("message", deleted ? "Gallery item deleted successfully" : "Failed to delete gallery item");
                out.print(gson.toJson(responseMap));
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                responseMap.put("error", "API endpoint not found");
                out.print(gson.toJson(responseMap));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseMap.put("error", e.getMessage());
            out.print(gson.toJson(responseMap));
        }
    }
    
    // Helper method to extract ID from path
    private int extractIdFromPath(String pathInfo) {
        try {
            String[] parts = pathInfo.split("/");
            return Integer.parseInt(parts[2]);
        } catch (Exception e) {
            throw new NumberFormatException("Invalid ID in path: " + pathInfo);
        }
    }
    
    // Helper method to parse JSON request
    private JsonObject parseJsonRequest(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        String jsonString = sb.toString();
        System.out.println("Received JSON: " + jsonString);
        return JsonParser.parseString(jsonString).getAsJsonObject();
    }
    
    // Helper method to extract filename from Part
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) {
            return UUID.randomUUID().toString() + ".jpg";
        }
        
        String[] tokens = contentDisposition.split(";");
        
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf("=") + 1).trim().replace("\"", "");
                // Sanitize filename - remove path if present
                fileName = new File(fileName).getName();
                return fileName;
            }
        }
        return UUID.randomUUID().toString() + ".jpg";
    }
    
    // Helper method to extract ManageGallery from request (JSON)
    private ManageGallery extractGalleryFromRequest(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        
        ManageGallery item = new ManageGallery();
        
        if (json.has("id") && !json.get("id").isJsonNull()) {
            item.setId(json.get("id").getAsInt());
        }
        
        if (json.has("title") && !json.get("title").isJsonNull()) {
            item.setTitle(json.get("title").getAsString());
        }
        
        if (json.has("description") && !json.get("description").isJsonNull()) {
            item.setDescription(json.get("description").getAsString());
        }
        
        if (json.has("categoryId") && !json.get("categoryId").isJsonNull()) {
            item.setCategoryId(json.get("categoryId").getAsInt());
        }
        
        if (json.has("images") && !json.get("images").isJsonNull()) {
            List<String> images = new ArrayList<>();
            var imagesArray = json.getAsJsonArray("images");
            for (var element : imagesArray) {
                images.add(element.getAsString());
            }
            item.setImages(images);
        }
        
        if (json.has("status") && !json.get("status").isJsonNull()) {
            item.setStatus(json.get("status").getAsBoolean());
        }
        
        // Set postedDate if not provided (for new items)
        if (!json.has("postedDate") || json.get("postedDate").isJsonNull()) {
            item.setPostedDate(LocalDateTime.now());
        }
        
        return item;
    }
}