package wepapp.service;

import wepapp.dao.ContactDAO;
import wepapp.model.Contact;
import java.time.LocalDate;
import java.util.List;
import java.util.regex.Pattern;

// Strategy Pattern - Validation Strategy Interface
interface ValidationStrategy {
    boolean validate(Contact contact);
    String getErrorMessage();
}

// Email Validation Strategy
class EmailValidationStrategy implements ValidationStrategy {
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    
    @Override
    public boolean validate(Contact contact) {
        return contact.getEmail() != null && 
               !contact.getEmail().trim().isEmpty() &&
               EMAIL_PATTERN.matcher(contact.getEmail()).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Invalid email format";
    }
}

// Phone Validation Strategy (optional field)
class PhoneValidationStrategy implements ValidationStrategy {
    private static final Pattern PHONE_PATTERN = 
        Pattern.compile("^\\+?[0-9]{10,14}$");
    
    @Override
    public boolean validate(Contact contact) {
        // Phone is optional - if provided, validate format
        if (contact.getPhone() == null || contact.getPhone().trim().isEmpty()) {
            return true;
        }
        return PHONE_PATTERN.matcher(contact.getPhone()).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Invalid phone number format. Use format: +94771234567";
    }
}

// Required Fields Validation Strategy
class RequiredFieldsValidationStrategy implements ValidationStrategy {
    @Override
    public boolean validate(Contact contact) {
        return contact.getName() != null && !contact.getName().trim().isEmpty() &&
               contact.getEmail() != null && !contact.getEmail().trim().isEmpty() &&
               contact.getMessage() != null && !contact.getMessage().trim().isEmpty();
    }
    
    @Override
    public String getErrorMessage() {
        return "Name, email, and message are required fields";
    }
}

// Reply Method Validation Strategy
class ReplyMethodValidationStrategy implements ValidationStrategy {
    @Override
    public boolean validate(Contact contact) {
        String method = contact.getReplyMethod();
        return method != null && 
               (method.equals("email") || method.equals("phone") || method.equals("both"));
    }
    
    @Override
    public String getErrorMessage() {
        return "Reply method must be email, phone, or both";
    }
}

// Main Service Class
public class ContactService {
    private final ContactDAO contactDAO;
    private final List<ValidationStrategy> validators;
    
    public ContactService() {
        this.contactDAO = ContactDAO.getInstance();
        this.validators = List.of(
            new RequiredFieldsValidationStrategy(),
            new EmailValidationStrategy(),
            new PhoneValidationStrategy(),
            new ReplyMethodValidationStrategy()
        );
    }
    
    // Validate contact using all strategies
    public ValidationResult validateContact(Contact contact) {
        for (ValidationStrategy validator : validators) {
            if (!validator.validate(contact)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Submit new contact message
    public ValidationResult submitContact(Contact contact) {
        // Validate first
        ValidationResult validationResult = validateContact(contact);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Set defaults if not set
        if (contact.getSentDate() == null) {
            contact.setSentDate(LocalDate.now());
        }
        
        // Save to database
        boolean saved = contactDAO.save(contact);
        
        if (saved) {
            return new ValidationResult(true, "Message sent successfully! We'll respond within 24 hours.");
        } else {
            return new ValidationResult(false, "Failed to send message. Please try again.");
        }
    }
    
    // Update contact
    public boolean updateContact(Contact contact) {
        // Validate the contact before updating
        ValidationResult validationResult = validateContact(contact);
        if (!validationResult.isValid()) {
            System.out.println("Validation failed: " + validationResult.getMessage());
            return false;
        }

        // Update in database
        return contactDAO.update(contact);
    }
    
    // Get all contacts
    public List<Contact> getAllContacts() {
        return contactDAO.findAll();
    }
    
    // Get contact by ID
    public Contact getContactById(int id) {
        return contactDAO.findById(id);
    }
    
    // Get unread contacts
    public List<Contact> getUnreadContacts() {
        return contactDAO.findByStatus(false);
    }
    
    // Get read contacts
    public List<Contact> getReadContacts() {
        return contactDAO.findByStatus(true);
    }
    
    // Get replied contacts
    public List<Contact> getRepliedContacts() {
        return contactDAO.findByReplyStatus(true);
    }
    
    // Get not replied contacts
    public List<Contact> getNotRepliedContacts() {
        return contactDAO.findByReplyStatus(false);
    }
    
    // Get contacts by reply method
    public List<Contact> getContactsByReplyMethod(String method) {
        return contactDAO.findByReplyMethod(method);
    }
    
    // Search contacts
    public List<Contact> searchContacts(String keyword) {
        return contactDAO.search(keyword);
    }
    
    // Get contacts by date range
    public List<Contact> getContactsByDateRange(LocalDate startDate, LocalDate endDate) {
        return contactDAO.findByDateRange(startDate, endDate);
    }
    
    // Get contacts by month and year
    public List<Contact> getContactsByMonthYear(int month, int year) {
        return contactDAO.findByMonthYear(month, year);
    }
    
    // Mark as read
    public boolean markAsRead(int id) {
        Contact contact = contactDAO.findById(id);
        if (contact != null && !contact.isStatus()) {
            return contactDAO.updateStatus(id, true);
        }
        return false;
    }
    
    // Mark as unread
    public boolean markAsUnread(int id) {
        Contact contact = contactDAO.findById(id);
        if (contact != null && contact.isStatus()) {
            return contactDAO.updateStatus(id, false);
        }
        return false;
    }
    
    // Mark as replied
    public boolean markAsReplied(int id) {
        Contact contact = contactDAO.findById(id);
        if (contact != null && !contact.isReply()) {
            return contactDAO.updateReplyStatus(id, true);
        }
        return false;
    }
    
    // Mark as not replied
    public boolean markAsNotReplied(int id) {
        Contact contact = contactDAO.findById(id);
        if (contact != null && contact.isReply()) {
            return contactDAO.updateReplyStatus(id, false);
        }
        return false;
    }
    
    // Toggle status (read/unread)
    public boolean toggleStatus(int id) {
        Contact contact = contactDAO.findById(id);
        if (contact != null) {
            return contactDAO.updateStatus(id, !contact.isStatus());
        }
        return false;
    }
    
    // Toggle reply status
    public boolean toggleReplyStatus(int id) {
        Contact contact = contactDAO.findById(id);
        if (contact != null) {
            return contactDAO.updateReplyStatus(id, !contact.isReply());
        }
        return false;
    }
    
    // Delete contact
    public boolean deleteContact(int id) {
        return contactDAO.delete(id);
    }
    
    // Statistics methods
    public int getTotalCount() {
        return contactDAO.countAll();
    }
    
    public int getUnreadCount() {
        return contactDAO.countUnread();
    }
    
    public int getReadCount() {
        return contactDAO.countRead();
    }
    
    public int getRepliedCount() {
        return contactDAO.countReplied();
    }
    
    public int getNotRepliedCount() {
        return contactDAO.countNotReplied();
    }
    
    // Inner class for validation result
    public static class ValidationResult {
        private final boolean valid;
        private final String message;
        
        public ValidationResult(boolean valid, String message) {
            this.valid = valid;
            this.message = message;
        }
        
        public boolean isValid() { return valid; }
        public String getMessage() { return message; }
    }
}