package wepapp.service;

import wepapp.dao.FeedbackDAO;
import wepapp.model.Feedback;
import java.time.LocalDate;
import java.util.List;
import java.util.regex.Pattern;

// Strategy Pattern - Validation Strategy Interface
interface FeedbackValidationStrategy {
    boolean validate(Feedback feedback);
    String getErrorMessage();
}

// Name Validation Strategy
class FeedbackNameValidationStrategy implements FeedbackValidationStrategy {
    @Override
    public boolean validate(Feedback feedback) {
        return feedback.getName() != null && 
               !feedback.getName().trim().isEmpty() &&
               feedback.getName().length() >= 2;
    }
    
    @Override
    public String getErrorMessage() {
        return "Name is required and must be at least 2 characters long";
    }
}

// Email Validation Strategy
class FeedbackEmailValidationStrategy implements FeedbackValidationStrategy {
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    
    @Override
    public boolean validate(Feedback feedback) {
        return feedback.getEmail() != null && 
               !feedback.getEmail().trim().isEmpty() &&
               EMAIL_PATTERN.matcher(feedback.getEmail()).matches();
    }
    
    @Override
    public String getErrorMessage() {
        return "Invalid email format";
    }
}

// Rating Validation Strategy
class RatingValidationStrategy implements FeedbackValidationStrategy {
    @Override
    public boolean validate(Feedback feedback) {
        int rating = feedback.getRating();
        return rating >= 1 && rating <= 5;
    }
    
    @Override
    public String getErrorMessage() {
        return "Rating must be between 1 and 5 stars";
    }
}

// Message Validation Strategy
class FeedbackMessageValidationStrategy implements FeedbackValidationStrategy {
    @Override
    public boolean validate(Feedback feedback) {
        return feedback.getMessage() != null && 
               !feedback.getMessage().trim().isEmpty() &&
               feedback.getMessage().length() >= 4; // Minimum 4 characters as per frontend
    }
    
    @Override
    public String getErrorMessage() {
        return "Feedback message is required and must be at least 4 characters long";
    }
}

// Status Validation Strategy - Updated for boolean
class StatusValidationStrategy implements FeedbackValidationStrategy {
    @Override
    public boolean validate(Feedback feedback) {
        // Status is boolean, always valid (true/false)
        return true;
    }
    
    @Override
    public String getErrorMessage() {
        return "";
    }
}

// Main Service Class
public class FeedbackService {
    private final FeedbackDAO feedbackDAO;
    private final List<FeedbackValidationStrategy> validators;
    
    public FeedbackService() {
        this.feedbackDAO = FeedbackDAO.getInstance();
        this.validators = List.of(
            new FeedbackNameValidationStrategy(),
            new FeedbackEmailValidationStrategy(),
            new RatingValidationStrategy(),
            new FeedbackMessageValidationStrategy(),
            new StatusValidationStrategy()
        );
    }
    
    // Validate feedback using all strategies
    public ValidationResult validateFeedback(Feedback feedback) {
        for (FeedbackValidationStrategy validator : validators) {
            if (!validator.validate(feedback)) {
                return new ValidationResult(false, validator.getErrorMessage());
            }
        }
        return new ValidationResult(true, "Validation successful");
    }
    
    // Submit new feedback
    public ValidationResult submitFeedback(Feedback feedback) {
        // Validate first
        ValidationResult validationResult = validateFeedback(feedback);
        if (!validationResult.isValid()) {
            return validationResult;
        }
        
        // Set defaults if not set
        if (feedback.getSubmittedDate() == null) {
            feedback.setSubmittedDate(LocalDate.now());
        }
        
        // Status is boolean, default to true (visible) in model constructor
        
        // Save to database
        boolean saved = feedbackDAO.save(feedback);
        
        if (saved) {
            return new ValidationResult(true, "Thank you for your feedback! 🌊");
        } else {
            return new ValidationResult(false, "Failed to submit feedback. Please try again.");
        }
    }
    
    // Update feedback
    public boolean updateFeedback(Feedback feedback) {
        // Validate the feedback before updating
        ValidationResult validationResult = validateFeedback(feedback);
        if (!validationResult.isValid()) {
            System.out.println("Validation failed: " + validationResult.getMessage());
            return false;
        }

        // Update in database
        return feedbackDAO.update(feedback);
    }
    
    // Get all feedback
    public List<Feedback> getAllFeedback() {
        return feedbackDAO.findAll();
    }
    
    // Get feedback by ID
    public Feedback getFeedbackById(int id) {
        return feedbackDAO.findById(id);
    }
    
    // Get visible feedback (status = true)
    public List<Feedback> getVisibleFeedback() {
        return feedbackDAO.findVisible();
    }
    
    // Get hidden feedback (status = false)
    public List<Feedback> getHiddenFeedback() {
        return feedbackDAO.findHidden();
    }
    
    // Get feedback by rating
    public List<Feedback> getFeedbackByRating(int rating) {
        return feedbackDAO.findByRating(rating);
    }
    
    // Get feedback by minimum rating
    public List<Feedback> getFeedbackByMinRating(int minRating) {
        return feedbackDAO.findByMinRating(minRating);
    }
    
    // Search feedback
    public List<Feedback> searchFeedback(String keyword) {
        return feedbackDAO.search(keyword);
    }
    
    // Get feedback by date range
    public List<Feedback> getFeedbackByDateRange(LocalDate startDate, LocalDate endDate) {
        return feedbackDAO.findByDateRange(startDate, endDate);
    }
    
    // Get feedback by month and year
    public List<Feedback> getFeedbackByMonthYear(int month, int year) {
        return feedbackDAO.findByMonthYear(month, year);
    }
    
    // Show feedback (set status to true)
    public boolean showFeedback(int id) {
        Feedback feedback = feedbackDAO.findById(id);
        if (feedback != null && !feedback.isStatus()) {
            return feedbackDAO.updateStatus(id, true);
        }
        return false;
    }
    
    // Hide feedback (set status to false)
    public boolean hideFeedback(int id) {
        Feedback feedback = feedbackDAO.findById(id);
        if (feedback != null && feedback.isStatus()) {
            return feedbackDAO.updateStatus(id, false);
        }
        return false;
    }
    
    // Toggle status (visible/hidden)
    public boolean toggleStatus(int id) {
        return feedbackDAO.toggleStatus(id);
    }
    
    // Delete feedback
    public boolean deleteFeedback(int id) {
        return feedbackDAO.delete(id);
    }
    
    // Statistics methods
    public int getTotalCount() {
        return feedbackDAO.countAll();
    }
    
    public int getVisibleCount() {
        return feedbackDAO.countVisible();
    }
    
    public int getHiddenCount() {
        return feedbackDAO.countHidden();
    }
    
    public int getCountByRating(int rating) {
        return feedbackDAO.countByRating(rating);
    }
    
    public double getAverageRating() {
        return feedbackDAO.getAverageRating();
    }
    
    // Get rating distribution
    public int[] getRatingDistribution() {
        int[] distribution = new int[6]; // index 1-5 for ratings
        for (int i = 1; i <= 5; i++) {
            distribution[i] = feedbackDAO.countByRating(i);
        }
        return distribution;
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