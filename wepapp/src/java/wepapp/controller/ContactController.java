package wepapp.controller;

import wepapp.model.Contact;
import wepapp.service.ContactService;
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

// Front Controller Pattern - Single entry point for all contact-related requests
@WebServlet("/contact/*")
public class ContactController extends HttpServlet {
    
    private ContactService contactService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        this.contactService = new ContactService();
        
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
               pathInfo.equals("/messages") ||
               pathInfo.equals("/contact.jsp") ||
               pathInfo.equals("/contactmessage.jsp") ||
               pathInfo.equals("/submit"); // Add submit as page request for form posts
    }
    
    // Handle page requests
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/contact.jsp")) {
            // Show contact form page
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
        } else if (pathInfo.equals("/messages") || pathInfo.equals("/contactmessage.jsp")) {
            // Show contact messages management page
            request.getRequestDispatcher("/contactmessage.jsp").forward(request, response);
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
            
            // Get all contacts
            if (pathInfo.equals("/api/list")) {
                List<Contact> contacts = contactService.getAllContacts();
                out.print(gson.toJson(contacts));
                
            // Get unread contacts
            } else if (pathInfo.equals("/api/unread")) {
                List<Contact> contacts = contactService.getUnreadContacts();
                out.print(gson.toJson(contacts));
                
            // Get read contacts
            } else if (pathInfo.equals("/api/read")) {
                List<Contact> contacts = contactService.getReadContacts();
                out.print(gson.toJson(contacts));
                
            // Get replied contacts
            } else if (pathInfo.equals("/api/replied")) {
                List<Contact> contacts = contactService.getRepliedContacts();
                out.print(gson.toJson(contacts));
                
            // Get not replied contacts
            } else if (pathInfo.equals("/api/not-replied")) {
                List<Contact> contacts = contactService.getNotRepliedContacts();
                out.print(gson.toJson(contacts));
                
            // Get statistics
            } else if (pathInfo.equals("/api/stats")) {
                Map<String, Integer> stats = new HashMap<>();
                stats.put("total", contactService.getTotalCount());
                stats.put("unread", contactService.getUnreadCount());
                stats.put("read", contactService.getReadCount());
                stats.put("replied", contactService.getRepliedCount());
                stats.put("notReplied", contactService.getNotRepliedCount());
                out.print(gson.toJson(stats));
                
            // Search contacts
            } else if (pathInfo.equals("/api/search")) {
                String keyword = request.getParameter("q");
                if (keyword != null && !keyword.isEmpty()) {
                    List<Contact> contacts = contactService.searchContacts(keyword);
                    out.print(gson.toJson(contacts));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Map.of("error", "Search keyword is required")));
                }
                
            // Get contact by ID
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                Contact contact = contactService.getContactById(id);
                if (contact != null) {
                    out.print(gson.toJson(contact));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(Map.of("error", "Contact not found")));
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
            // Create new contact
            if (pathInfo.equals("/api/create")) {
                Contact contact = extractContactFromRequest(request);
                ContactService.ValidationResult result = contactService.submitContact(contact);
                
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("success", result.isValid());
                responseMap.put("message", result.getMessage());
                
                if (result.isValid()) {
                    responseMap.put("contact", contact);
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
            // Update status (read/unread) by ID
            if (pathInfo.matches("/api/\\d+/status")) {
                int id = extractIdFromPath(pathInfo);
                JsonObject json = parseJsonRequest(request);
                
                boolean status = json.get("status").getAsBoolean();
                boolean updated;
                
                if (status) {
                    updated = contactService.markAsRead(id);
                } else {
                    updated = contactService.markAsUnread(id);
                }
                
                out.print(gson.toJson(Map.of(
                    "success", updated,
                    "message", updated ? "Status updated successfully" : "Failed to update status"
                )));
                
            // Update reply status by ID
            } else if (pathInfo.matches("/api/\\d+/reply")) {
                int id = extractIdFromPath(pathInfo);
                JsonObject json = parseJsonRequest(request);
                
                boolean replied = json.get("replied").getAsBoolean();
                boolean updated;
                
                if (replied) {
                    updated = contactService.markAsReplied(id);
                } else {
                    updated = contactService.markAsNotReplied(id);
                }
                
                out.print(gson.toJson(Map.of(
                    "success", updated,
                    "message", updated ? "Reply status updated successfully" : "Failed to update reply status"
                )));
                
            // Toggle status
            } else if (pathInfo.matches("/api/\\d+/toggle-status")) {
                int id = extractIdFromPath(pathInfo);
                boolean updated = contactService.toggleStatus(id);
                
                out.print(gson.toJson(Map.of(
                    "success", updated,
                    "message", updated ? "Status toggled successfully" : "Failed to toggle status"
                )));
                
            // Toggle reply status
            } else if (pathInfo.matches("/api/\\d+/toggle-reply")) {
                int id = extractIdFromPath(pathInfo);
                boolean updated = contactService.toggleReplyStatus(id);
                
                out.print(gson.toJson(Map.of(
                    "success", updated,
                    "message", updated ? "Reply status toggled successfully" : "Failed to toggle reply status"
                )));
                
            // Update entire contact
            } else if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                Contact contact = extractContactFromRequest(request);
                contact.setId(id);
                
                boolean updated = contactService.updateContact(contact);
                
                out.print(gson.toJson(Map.of(
                    "success", updated,
                    "message", updated ? "Contact updated successfully" : "Failed to update contact"
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
            // Delete contact by ID
            if (pathInfo.matches("/api/\\d+")) {
                int id = extractIdFromPath(pathInfo);
                boolean deleted = contactService.deleteContact(id);
                
                out.print(gson.toJson(Map.of(
                    "success", deleted,
                    "message", deleted ? "Contact deleted successfully" : "Failed to delete contact"
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
    
    // Handle form submission from contact.jsp
    private void handleFormSubmission(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            Contact contact = extractContactFromForm(request);
            ContactService.ValidationResult result = contactService.submitContact(contact);
            
            Map<String, Object> responseMap = new HashMap<>();
            responseMap.put("success", result.isValid());
            responseMap.put("message", result.getMessage());
            
            if (result.isValid()) {
                responseMap.put("contact", contact);
                
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
    
    // Helper method to extract Contact from request (JSON or form)
    private Contact extractContactFromRequest(HttpServletRequest request) throws IOException {
        String contentType = request.getContentType();
        
        if (contentType != null && contentType.contains("application/json")) {
            return extractContactFromJson(request);
        } else {
            return extractContactFromForm(request);
        }
    }
    
    // Extract Contact from JSON
    private Contact extractContactFromJson(HttpServletRequest request) throws IOException {
        JsonObject json = parseJsonRequest(request);
        
        Contact contact = new Contact();
        
        if (json.has("name") && !json.get("name").isJsonNull()) {
            contact.setName(json.get("name").getAsString());
        }
        
        if (json.has("email") && !json.get("email").isJsonNull()) {
            contact.setEmail(json.get("email").getAsString());
        }
        
        if (json.has("phone") && !json.get("phone").isJsonNull()) {
            contact.setPhone(json.get("phone").getAsString());
        }
        
        if (json.has("message") && !json.get("message").isJsonNull()) {
            contact.setMessage(json.get("message").getAsString());
        }
        
        if (json.has("replyMethod") && !json.get("replyMethod").isJsonNull()) {
            contact.setReplyMethod(json.get("replyMethod").getAsString());
        }
        
        if (json.has("status") && !json.get("status").isJsonNull()) {
            contact.setStatus(json.get("status").getAsBoolean());
        }
        
        if (json.has("reply") && !json.get("reply").isJsonNull()) {
            contact.setReply(json.get("reply").getAsBoolean());
        }
        
        if (json.has("sentDate") && !json.get("sentDate").isJsonNull()) {
            contact.setSentDate(LocalDate.parse(json.get("sentDate").getAsString()));
        }
        
        return contact;
    }
    
    // Extract Contact from form data
    private Contact extractContactFromForm(HttpServletRequest request) {
        Contact contact = new Contact();
        
        String name = request.getParameter("name");
        if (name != null && !name.isEmpty()) {
            contact.setName(name);
        }
        
        String email = request.getParameter("email");
        if (email != null && !email.isEmpty()) {
            contact.setEmail(email);
        }
        
        String phone = request.getParameter("phone");
        if (phone != null && !phone.isEmpty()) {
            contact.setPhone(phone);
        }
        
        String message = request.getParameter("message");
        if (message != null && !message.isEmpty()) {
            contact.setMessage(message);
        }
        
        String replyMethod = request.getParameter("replyMethod");
        if (replyMethod != null && !replyMethod.isEmpty()) {
            contact.setReplyMethod(replyMethod);
        } else {
            contact.setReplyMethod("email"); // default
        }
        
        // Set default values
        contact.setStatus(false); // unread by default
        contact.setReply(false); // not replied by default
        contact.setSentDate(LocalDate.now());
        
        return contact;
    }
}