package wepapp.controller;

import wepapp.model.Feedback;
import wepapp.service.FeedbackService;
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
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// Front Controller Pattern - Single entry point for all feedback-related requests
@WebServlet("/feedback/*")
public class FeedbackController extends HttpServlet {
    
    private FeedbackService feedbackService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        this.feedbackService = new FeedbackService();
        
        // Create Gson with custom LocalDate adapter
        this.gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
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
            // Handle form submission
            handleFormSubmission(request, response);
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
               pathInfo.equals("/form") ||
               pathInfo.equals("/manage") ||
               pathInfo.equals("/feedback.jsp") ||
               pathInfo.equals("/managefeedback.jsp") ||
               pathInfo.equals("/submit");
    }
    
    // Handle page requests
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/form") || pathInfo.equals("/feedback.jsp")) {
            // Show feedback form page
            request.getRequestDispatcher("/feedback.jsp").forward(request, response);
        } else if (pathInfo.equals("/manage") || pathInfo.equals("/managefeedback.jsp")) {
            // Show feedback management page
            request.getRequestDispatcher("/managefeedback.jsp").forward(request, response);
        } else if (pathInfo.equals("/submit")) {
            // Handle form submission (this is handled in doPost)
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
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
            
            // Get all feedback
            if (pathInfo.equals("/api/list")) {
                List<Feedback> feedbacks = feedbackService.getAllFeedback();
                out.print(gson.toJson(feedbacks));
                
            // Get visible feedback (status = true)
            } else if (pathInfo.equals("/api/visible")) {
                List<Feedback> feedbacks = feedbackService.getVisibleFeedback();
                out.print(gson.toJson(feedbacks));
                
            // Get hidden feedback (status = false)
            } else if (pathInfo.equals("/api/hidden")) {
                List<Feedback> feedbacks = feedbackService.getHiddenFeedback();
                out.print(gson.toJson(feedbacks));
                
            // Get feedback by rating
            } else if (pathInfo.matches("/api/rating/\\d+")) {
                int rating = extractRatingFromPath(pathInfo);
                List<Feedback> feedbacks = feedbackService.getFeedbackByRating(rating);
                out.print(gson.toJson(feedbacks));
                
            // Get statistics
            } else if (pathInfo.equals("/api/stats")) {
                Map<String, Object> stats = new HashMap<>();
                stats.put("total", feedbackService.getTotalCount());
                stats.put("visible", feedbackService.getVisibleCount());
                stats.put("hidden", feedbackService.getHiddenCount());
                stats.put("averageRating", feedbackService.getAverageRating());
                stats.put("ratingDistribution", feedbackService.getRatingDistribution());
                out.print(gson.toJson(stats));
                
            // Search feedback
            } else if (pathInfo.equals("/api/search")) {
                String keyword = request.getParameter("q");
                if (keyword != null && !keyword.isEmpty()) {
                    List<Feedback> feedbacks = feedbackService.searchFeedback(keyword);
                    out.print(gson.toJson(feedbacks));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Search keyword is required")));
                }
                
            // Get feedback by ID
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                Feedback feedback = feedbackService.getFeedbackById(id);
                if (feedback != null) {
                    out.print(gson.toJson(feedback));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(Map.of("error", "Feedback not found")));
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
            // Create new feedback
            if (pathInfo.equals("/api/create")) {
                Feedback feedback = extractFeedbackFromRequest(request);
                FeedbackService.ValidationResult result = feedbackService.submitFeedback(feedback);
                
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("success", result.isValid());
                responseMap.put("message", result.getMessage());
                
                if (result.isValid()) {
                    responseMap.put("feedback", feedback);
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
                boolean updated;
                
                if (status) {
                    updated = feedbackService.showFeedback(id);
                } else {
                    updated = feedbackService.hideFeedback(id);
                }
                
                out.print(gson.toJson(Map.of(
                    "success", updated,
                    "message", updated ? "Status updated successfully" : "Failed to update status"
                )));
                
            // Update status from string (for backward compatibility)
            } else if (pathInfo.matches("/api/\\d+/status-from-string")) {
                int id = extractIdFromPath(pathInfo);
                JsonObject json = parseJsonRequest(request);
                
                String statusStr = json.get("status").getAsString();
                boolean status = statusStr.equalsIgnoreCase("show") || 
                                statusStr.equalsIgnoreCase("visible") || 
                                statusStr.equalsIgnoreCase("true");
                
                boolean updated;
                if (status) {
                    updated = feedbackService.showFeedback(id);
                } else {
                    updated = feedbackService.hideFeedback(id);
                }
                
                out.print(gson.toJson(Map.of(
                    "success", updated,
                    "message", updated ? "Status updated successfully" : "Failed to update status"
                )));
                
            // Toggle status
            } else if (pathInfo.matches("/api/\\d+/toggle-status")) {
                int id = extractIdFromPath(pathInfo);
                boolean updated = feedbackService.toggleStatus(id);
                
                out.print(gson.toJson(Map.of(
                    "success", updated,
                    "message", updated ? "Status toggled successfully" : "Failed to toggle status"
                )));
                
            // Update entire feedback
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                Feedback feedback = extractFeedbackFromRequest(request);
                feedback.setId(id);
                
                boolean updated = feedbackService.updateFeedback(feedback);
                
                out.print(gson.toJson(Map.of(
                    "success", updated,
                    "message", updated ? "Feedback updated successfully" : "Failed to update feedback"
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
            // Delete feedback by ID
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                boolean deleted = feedbackService.deleteFeedback(id);
                
                out.print(gson.toJson(Map.of(
                    "success", deleted,
                    "message", deleted ? "Feedback deleted successfully" : "Failed to delete feedback"
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
    
    // Handle form submission from feedback.jsp
    private void handleFormSubmission(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            Feedback feedback = extractFeedbackFromForm(request);
            FeedbackService.ValidationResult result = feedbackService.submitFeedback(feedback);
            
            Map<String, Object> responseMap = new HashMap<>();
            responseMap.put("success", result.isValid());
            responseMap.put("message", result.getMessage());
            
            if (result.isValid()) {
                responseMap.put("feedback", feedback);
                
                // Store in session for notification
                HttpSession session = request.getSession();
                session.setAttribute("notification", 
                    Map.of("type", "success", "message", result.getMessage()));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
            
            out.print(gson.toJson(responseMap));
            
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
    
    // Helper method to extract rating from path
    private int extractRatingFromPath(String pathInfo) {
        String[] parts = pathInfo.split("/");
        return Integer.parseInt(parts[3]);
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
    
    // Helper method to extract Feedback from request (JSON or form)
    private Feedback extractFeedbackFromRequest(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        
        if (contentType != null && contentType.contains("application/json")) {
            return extractFeedbackFromJson(request);
        } else {
            return extractFeedbackFromForm(request);
        }
    }
    
    // Extract Feedback from JSON
    private Feedback extractFeedbackFromJson(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        
        Feedback feedback = new Feedback();
        
        if (json.has("name") && !json.get("name").isJsonNull()) {
            feedback.setName(json.get("name").getAsString());
        }
        
        if (json.has("email") && !json.get("email").isJsonNull()) {
            feedback.setEmail(json.get("email").getAsString());
        }
        
        if (json.has("rating") && !json.get("rating").isJsonNull()) {
            feedback.setRating(json.get("rating").getAsInt());
        }
        
        if (json.has("message") && !json.get("message").isJsonNull()) {
            feedback.setMessage(json.get("message").getAsString());
        }
        
        if (json.has("status") && !json.get("status").isJsonNull()) {
            // Handle both boolean and string status
            if (json.get("status").isJsonPrimitive() && json.get("status").getAsJsonPrimitive().isBoolean()) {
                feedback.setStatus(json.get("status").getAsBoolean());
            } else {
                String statusStr = json.get("status").getAsString();
                feedback.setStatusFromString(statusStr);
            }
        } else {
            feedback.setStatus(true); // Default to visible
        }
        
        if (json.has("submittedDate") && !json.get("submittedDate").isJsonNull()) {
            feedback.setSubmittedDate(LocalDate.parse(json.get("submittedDate").getAsString()));
        } else {
            feedback.setSubmittedDate(LocalDate.now());
        }
        
        return feedback;
    }
    
    // Extract Feedback from form data
    private Feedback extractFeedbackFromForm(HttpServletRequest request) {
        Feedback feedback = new Feedback();
        
        String name = request.getParameter("name");
        if (name != null && !name.isEmpty()) {
            feedback.setName(name);
        }
        
        String email = request.getParameter("email");
        if (email != null && !email.isEmpty()) {
            feedback.setEmail(email);
        }
        
        String ratingParam = request.getParameter("rating");
        if (ratingParam != null && !ratingParam.isEmpty()) {
            try {
                feedback.setRating(Integer.parseInt(ratingParam));
            } catch (NumberFormatException e) {
                feedback.setRating(5); // default to 5 if invalid
            }
        }
        
        String message = request.getParameter("message");
        if (message != null && !message.isEmpty()) {
            feedback.setMessage(message);
        }
        
        // Set default values
        feedback.setStatus(true); // visible by default
        feedback.setSubmittedDate(LocalDate.now());
        
        return feedback;
    }
}