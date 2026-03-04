<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- 
    notification.jsp - Reusable notification component
    Fixed version with working icons, progress line, and 3-second auto-close
    All notifications now properly close after 3 seconds
-->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notification Component</title>
    <!-- Tailwind via CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        
        @keyframes slideOut {
            from { transform: translateX(0); opacity: 1; }
            to { transform: translateX(100%); opacity: 0; }
        }
        
        @keyframes progressLine {
            from { width: 100%; }
            to { width: 0%; }
        }
        
        .notification-enter {
            animation: slideIn 0.3s ease forwards;
        }
        
        .notification-exit {
            animation: slideOut 0.3s ease forwards;
        }
        
        .progress-line {
            position: absolute;
            bottom: 0;
            left: 0;
            height: 3px;
            background: linear-gradient(90deg, rgba(255,255,255,0.7), rgba(255,255,255,0.9));
            animation: progressLine 3s linear forwards;
        }
        
        #notification-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 12px;
            max-width: 380px;
            width: 100%;
            pointer-events: none;
        }
        
        .notification-item {
            pointer-events: auto;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }
    </style>
</head>
<body>
    <div id="notification-container"></div>

    <script>
        (function() {
            // Create container if it doesn't exist
            if (!document.getElementById('notification-container')) {
                const container = document.createElement('div');
                container.id = 'notification-container';
                document.body.appendChild(container);
            }

            // Configuration for notification types
            const notificationConfig = {
                success: {
                    icon: 'https://cdn-icons-png.flaticon.com/128/14090/14090371.png',
                    borderColor: '#10b981',
                    bgColor: '#f0fdf4',
                    textColor: '#065f46',
                    iconBg: '#dcfce7'
                },
                error: {
                    icon: 'https://cdn-icons-png.flaticon.com/128/9068/9068699.png',
                    borderColor: '#ef4444',
                    bgColor: '#fef2f2',
                    textColor: '#991b1b',
                    iconBg: '#fee2e2'
                },
                info: {
                    icon: 'https://cdn-icons-png.flaticon.com/128/9347/9347264.png',
                    borderColor: '#3b82f6',
                    bgColor: '#eff6ff',
                    textColor: '#1e40af',
                    iconBg: '#dbeafe'
                },
                warning: {
                    icon: 'https://cdn-icons-png.flaticon.com/128/4712/4712039.png',
                    borderColor: '#f59e0b',
                    bgColor: '#fffbeb',
                    textColor: '#92400e',
                    iconBg: '#fef3c7'
                }
            };

            let activeNotifications = [];
            let notificationId = 0;

            window.showNotification = function(type, message, duration = 3000) {
                const config = notificationConfig[type] || notificationConfig.info;
                const id = notificationId++;
                
                const notification = document.createElement('div');
                notification.id = `notification-${id}`;
                notification.className = 'notification-item notification-enter rounded-xl border-2 bg-white shadow-lg overflow-hidden relative';
                notification.style.borderColor = config.borderColor;
                
                // Create notification content with icon and message
                const contentDiv = document.createElement('div');
                contentDiv.className = 'flex items-start p-4';
                contentDiv.style.backgroundColor = config.bgColor;
                
                // Icon container
                const iconContainer = document.createElement('div');
                iconContainer.className = 'flex-shrink-0 mr-3';
                const iconWrapper = document.createElement('div');
                iconWrapper.className = 'w-10 h-10 rounded-full flex items-center justify-center';
                iconWrapper.style.backgroundColor = config.iconBg;
                const iconImg = document.createElement('img');
                iconImg.src = config.icon;
                iconImg.alt = type;
                iconImg.className = 'w-6 h-6';
                iconWrapper.appendChild(iconImg);
                iconContainer.appendChild(iconWrapper);
                
                // Message container
                const messageContainer = document.createElement('div');
                messageContainer.className = 'flex-1 pt-0.5';
                const messagePara = document.createElement('p');
                messagePara.className = 'text-base font-medium';
                messagePara.style.color = config.textColor;
                messagePara.textContent = message;
                const typePara = document.createElement('p');
                typePara.className = 'text-xs mt-1';
                typePara.style.color = config.textColor;
                typePara.style.opacity = '0.7';
                typePara.textContent = type.charAt(0).toUpperCase() + type.slice(1);
                messageContainer.appendChild(messagePara);
                messageContainer.appendChild(typePara);
                
                // Close button
                const closeBtn = document.createElement('button');
                closeBtn.onclick = function() { closeNotification(id); };
                closeBtn.className = 'flex-shrink-0 ml-2 text-gray-400 hover:text-gray-600 transition-colors';
                closeBtn.innerHTML = `
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                    </svg>
                `;
                
                // Assemble content
                contentDiv.appendChild(iconContainer);
                contentDiv.appendChild(messageContainer);
                contentDiv.appendChild(closeBtn);
                notification.appendChild(contentDiv);
                
                // Add progress line
                const progressLine = document.createElement('div');
                progressLine.className = 'progress-line';
                progressLine.style.backgroundColor = config.borderColor;
                progressLine.style.background = `linear-gradient(90deg, ${config.borderColor}, ${config.textColor})`;
                notification.appendChild(progressLine);
                
                // Add to container
                const container = document.getElementById('notification-container');
                container.appendChild(notification);
                
                // Store notification data
                const notificationData = {
                    id: id,
                    element: notification,
                    timeout: setTimeout(() => closeNotification(id), duration)
                };
                
                // Check if we already have 3 notifications
                if (activeNotifications.length >= 3) {
                    // Remove the oldest notification immediately
                    const oldest = activeNotifications[0];
                    if (oldest) {
                        // Clear its timeout
                        clearTimeout(oldest.timeout);
                        // Remove it
                        closeNotification(oldest.id);
                    }
                }
                
                // Add the new notification
                activeNotifications.push(notificationData);
                
                return id;
            };

            window.closeNotification = function(id) {
                const notification = document.getElementById(`notification-${id}`);
                if (!notification) return;
                
                const index = activeNotifications.findIndex(n => n.id === id);
                if (index !== -1) {
                    // Clear timeout if it exists
                    if (activeNotifications[index].timeout) {
                        clearTimeout(activeNotifications[index].timeout);
                    }
                    
                    // Start exit animation
                    notification.classList.remove('notification-enter');
                    notification.classList.add('notification-exit');
                    
                    // Remove progress line animation
                    const progressLine = notification.querySelector('.progress-line');
                    if (progressLine) {
                        progressLine.style.animation = 'none';
                    }
                    
                    // Remove from DOM after animation
                    setTimeout(() => {
                        if (notification.parentNode) {
                            notification.parentNode.removeChild(notification);
                        }
                    }, 300);
                    
                    // Remove from array
                    activeNotifications.splice(index, 1);
                }
            };

            // Helper functions
            window.showSuccess = function(message, duration = 3000) {
                return showNotification('success', message, duration);
            };
            
            window.showError = function(message, duration = 3000) {
                return showNotification('error', message, duration);
            };
            
            window.showInfo = function(message, duration = 3000) {
                return showNotification('info', message, duration);
            };
            
            window.showWarning = function(message, duration = 3000) {
                return showNotification('warning', message, duration);
            };
        })();
    </script>
</body>
</html>