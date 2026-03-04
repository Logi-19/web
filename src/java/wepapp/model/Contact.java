package wepapp.model;

import java.time.LocalDate;

public class Contact {
    private int id;
    private String name;
    private String email;
    private String phone;
    private String message;
    private String replyMethod; // email, phone, both
    private boolean status;  // true = read, false = unread
    private boolean reply;   // true = replied, false = not replied
    private LocalDate sentDate;
    
    // Default constructor
    public Contact() {}
    
    // Private constructor for Builder
    private Contact(Builder builder) {
        this.id = builder.id;
        this.name = builder.name;
        this.email = builder.email;
        this.phone = builder.phone;
        this.message = builder.message;
        this.replyMethod = builder.replyMethod;
        this.status = builder.status;
        this.reply = builder.reply;
        this.sentDate = builder.sentDate;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getReplyMethod() { return replyMethod; }
    public void setReplyMethod(String replyMethod) { this.replyMethod = replyMethod; }
    
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
    
    public boolean isReply() { return reply; }
    public void setReply(boolean reply) { this.reply = reply; }
    
    public LocalDate getSentDate() { return sentDate; }
    public void setSentDate(LocalDate sentDate) { this.sentDate = sentDate; }
    
    // Builder Pattern
    public static class Builder {
        private int id;
        private String name;
        private String email;
        private String phone;
        private String message;
        private String replyMethod = "email";
        private boolean status = false;
        private boolean reply = false;
        private LocalDate sentDate = LocalDate.now();
        
        public Builder id(int id) { this.id = id; return this; }
        public Builder name(String name) { this.name = name; return this; }
        public Builder email(String email) { this.email = email; return this; }
        public Builder phone(String phone) { this.phone = phone; return this; }
        public Builder message(String message) { this.message = message; return this; }
        public Builder replyMethod(String replyMethod) { this.replyMethod = replyMethod; return this; }
        public Builder status(boolean status) { this.status = status; return this; }
        public Builder reply(boolean reply) { this.reply = reply; return this; }
        public Builder sentDate(LocalDate sentDate) { this.sentDate = sentDate; return this; }
        
        public Contact build() {
            return new Contact(this);
        }
    }
    
    @Override
    public String toString() {
        return "Contact{" + "id=" + id + ", name=" + name + ", email=" + email + 
               ", status=" + (status ? "read" : "unread") + 
               ", reply=" + (reply ? "replied" : "not replied") + "}";
    }
}