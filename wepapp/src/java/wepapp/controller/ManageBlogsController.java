package wepapp.controller;

import wepapp.model.ManageBlogs;
import wepapp.service.ManageBlogsService;
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
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

// Front Controller Pattern - Single entry point for all blog management requests
@WebServlet("/manageblogs/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class ManageBlogsController extends HttpServlet {
    
    private ManageBlogsService blogsService;
    private BlogCategoryService categoryService;
    private Gson gson;
    private String uploadBasePath;
    private String blogUploadPath;
    
    @Override
    public void init() throws ServletException {
        this.blogsService = new ManageBlogsService();
        this.categoryService = new BlogCategoryService();
        
        // Create Gson with custom LocalDate and LocalDateTime adapters
        this.gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .create();
        
        // Set base upload path - creates "uploads" folder in web root
        uploadBasePath = getServletContext().getRealPath("/") + "uploads" + File.separator;
        
        // Set blog-specific upload path - creates "uploads/blogs/" subfolder
        blogUploadPath = uploadBasePath + "blogs" + File.separator;
        
        // Create uploads directory and blogs subdirectory if they don't exist
        File uploadDir = new File(uploadBasePath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            if (created) {
                System.out.println("Uploads directory created at: " + uploadBasePath);
            }
        }
        
        File blogDir = new File(blogUploadPath);
        if (!blogDir.exists()) {
            boolean created = blogDir.mkdirs();
            if (created) {
                System.out.println("Blogs upload directory created at: " + blogUploadPath);
            }
        }
        
        // Check if directories are writable
        if (!blogDir.canWrite()) {
            System.err.println("WARNING: Blogs upload directory is not writable: " + blogUploadPath);
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
            // Check if it's an image upload request
            if (pathInfo.equals("/api/upload")) {
                handleImageUpload(request, response);
            } else {
                handleApiPostRequest(request, response, pathInfo);
            }
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
               pathInfo.equals("/blogs") ||
               pathInfo.equals("/manageblogs.jsp");
    }
    
    // Handle page requests
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/manageblogs.jsp")) {
            // Get categories for dropdown
            List<BlogCategory> categories = categoryService.getAllCategories();
            request.setAttribute("categories", categories);
            
            // Get next blog prefix
            String nextPrefix = blogsService.getNextBlogPrefix();
            request.setAttribute("nextBlogPrefix", nextPrefix);
            
            // Show blog management page
            request.getRequestDispatcher("/manageblogs.jsp").forward(request, response);
        } else if (pathInfo.equals("/blogs")) {
            // Redirect to main page
            response.sendRedirect(request.getContextPath() + "/manageblogs/");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    // Handle image upload
    private void handleImageUpload(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            List<String> uploadedUrls = new ArrayList<>();
            
            // Get all uploaded parts
            for (Part part : request.getParts()) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    // Generate unique filename
                    String fileName = UUID.randomUUID().toString() + "_" + getFileName(part);
                    String filePath = blogUploadPath + fileName;
                    
                    // Save file
                    part.write(filePath);
                    
                    // Generate URL for the image (now with /uploads/blogs/ path)
                    String imageUrl = request.getContextPath() + "/uploads/blogs/" + fileName;
                    uploadedUrls.add(imageUrl);
                }
            }
            
            Map<String, Object> responseMap = new HashMap<>();
            responseMap.put("success", true);
            responseMap.put("images", uploadedUrls);
            responseMap.put("message", "Images uploaded successfully to uploads/blogs/");
            
            out.print(gson.toJson(responseMap));
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of(
                "success", false,
                "error", e.getMessage()
            )));
            e.printStackTrace();
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
            
            // Get all blogs
            if (pathInfo.equals("/api/list")) {
                List<ManageBlogs> blogs = blogsService.getAllBlogs();
                out.print(gson.toJson(blogs));
                
            // Get visible blogs
            } else if (pathInfo.equals("/api/visible")) {
                List<ManageBlogs> blogs = blogsService.getVisibleBlogs();
                out.print(gson.toJson(blogs));
                
            // Get hidden blogs
            } else if (pathInfo.equals("/api/hidden")) {
                List<ManageBlogs> blogs = blogsService.getHiddenBlogs();
                out.print(gson.toJson(blogs));
                
            // Get blogs by category
            } else if (pathInfo.equals("/api/category")) {
                String categoryIdParam = request.getParameter("id");
                if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                    int categoryId = Integer.parseInt(categoryIdParam);
                    List<ManageBlogs> blogs = blogsService.getBlogsByCategory(categoryId);
                    out.print(gson.toJson(blogs));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Category ID is required")));
                }
                
            // Get categories with blog counts
            } else if (pathInfo.equals("/api/categories-with-counts")) {
                List<ManageBlogsService.CategoryStat> stats = blogsService.getCategoryStatistics();
                out.print(gson.toJson(stats));
                
            // Get statistics
            } else if (pathInfo.equals("/api/stats")) {
                Map<String, Integer> stats = new HashMap<>();
                stats.put("total", blogsService.getTotalCount());
                stats.put("visible", blogsService.getVisibleCount());
                stats.put("hidden", blogsService.getHiddenCount());
                out.print(gson.toJson(stats));
                
            // Get next blog prefix
            } else if (pathInfo.equals("/api/next-prefix")) {
                String nextPrefix = blogsService.getNextBlogPrefix();
                out.print(gson.toJson(Map.of("prefix", nextPrefix)));
                
            // Search blogs
            } else if (pathInfo.equals("/api/search")) {
                String keyword = request.getParameter("q");
                if (keyword != null && !keyword.isEmpty()) {
                    List<ManageBlogs> blogs = blogsService.searchBlogs(keyword);
                    out.print(gson.toJson(blogs));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Search keyword is required")));
                }
                
            // Get blog by ID
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                ManageBlogs blog = blogsService.getBlogById(id);
                if (blog != null) {
                    out.print(gson.toJson(blog));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(Map.of("error", "Blog not found")));
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
            // Create new blog
            if (pathInfo.equals("/api/create")) {
                ManageBlogs blog = extractBlogFromRequest(request);
                ManageBlogsService.ValidationResult result = blogsService.createBlog(blog);
                
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("success", result.isValid());
                responseMap.put("message", result.getMessage());
                
                if (result.isValid()) {
                    responseMap.put("blog", blog);
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
            // Update status (visible/hidden) by ID
            if (pathInfo.matches("/api/\\d+/status")) {
                int id = extractIdFromPath(pathInfo);
                JsonObject json = parseJsonRequest(request);
                
                boolean status = json.get("status").getAsBoolean();
                boolean updated = blogsService.updateBlogStatus(id, status);
                
                out.print(gson.toJson(Map.of(
                    "success", updated,
                    "message", updated ? "Status updated successfully" : "Failed to update status"
                )));
                
            // Toggle status
            } else if (pathInfo.matches("/api/\\d+/toggle-status")) {
                int id = extractIdFromPath(pathInfo);
                boolean updated = blogsService.toggleBlogStatus(id);
                
                out.print(gson.toJson(Map.of(
                    "success", updated,
                    "message", updated ? "Status toggled successfully" : "Failed to toggle status"
                )));
                
            // Update entire blog
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                ManageBlogs blog = extractBlogFromRequest(request);
                blog.setId(id);
                
                ManageBlogsService.ValidationResult result = blogsService.updateBlog(blog);
                
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
            // Delete blog by ID
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                boolean deleted = blogsService.deleteBlog(id);
                
                out.print(gson.toJson(Map.of(
                    "success", deleted,
                    "message", deleted ? "Blog deleted successfully" : "Failed to delete blog"
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
    
    // Helper method to extract filename from Part
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return UUID.randomUUID().toString() + ".jpg";
    }
    
    // Helper method to extract ManageBlogs from request (JSON)
    private ManageBlogs extractBlogFromRequest(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        
        ManageBlogs blog = new ManageBlogs();
        
        if (json.has("id") && !json.get("id").isJsonNull()) {
            blog.setId(json.get("id").getAsInt());
        }
        
        if (json.has("blogPrefix") && !json.get("blogPrefix").isJsonNull()) {
            blog.setBlogPrefix(json.get("blogPrefix").getAsString());
        } else {
            // Auto-generate prefix if not provided
            blog.setBlogPrefix(blogsService.getNextBlogPrefix());
        }
        
        if (json.has("title") && !json.get("title").isJsonNull()) {
            blog.setTitle(json.get("title").getAsString());
        }
        
        if (json.has("description") && !json.get("description").isJsonNull()) {
            blog.setDescription(json.get("description").getAsString());
        }
        
        if (json.has("categoryId") && !json.get("categoryId").isJsonNull()) {
            blog.setCategoryId(json.get("categoryId").getAsInt());
        }
        
        if (json.has("images") && !json.get("images").isJsonNull()) {
            List<String> images = new ArrayList<>();
            var imagesArray = json.getAsJsonArray("images");
            for (var element : imagesArray) {
                images.add(element.getAsString());
            }
            blog.setImages(images);
        }
        
        if (json.has("link") && !json.get("link").isJsonNull()) {
            blog.setLink(json.get("link").getAsString());
        }
        
        if (json.has("blogDate") && !json.get("blogDate").isJsonNull()) {
            blog.setBlogDate(LocalDate.parse(json.get("blogDate").getAsString()));
        }
        
        if (json.has("status") && !json.get("status").isJsonNull()) {
            blog.setStatus(json.get("status").getAsBoolean());
        }
        
        return blog;
    }
}