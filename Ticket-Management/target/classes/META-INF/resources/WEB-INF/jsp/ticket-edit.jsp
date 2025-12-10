<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Ticket</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            position: relative;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            background: url('https://cdn.pixabay.com/photo/2022/07/10/19/30/house-7313645_1280.jpg') no-repeat center center fixed;
            background-size: cover;
            z-index: 0;
        }
        /* Dark overlay */
        body::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6); /* Adjust darkness here */
            z-index: -1;
        }
        .container {
            max-width: 800px;
            width: 100%;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.4);
            padding: 40px;
            position: relative;
            z-index: 1;
        }
        h1 {
            color: #333;
            margin-bottom: 30px;
            font-size: 2em;
            text-align: center;
        }
        .form-group {
            margin-bottom: 25px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #374151;
            font-weight: 600;
            font-size: 14px;
        }
        input[type="text"],
        input[type="email"],
        input[type="tel"],
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            font-family: inherit;
        }
        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        textarea {
            min-height: 120px;
            resize: vertical;
        }
        input[type="file"] {
            padding: 10px;
            border: 2px dashed #e5e7eb;
            cursor: pointer;
        }
        input[type="file"]:hover {
            border-color: #667eea;
            background: #f9fafb;
        }
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        .btn {
            flex: 1;
            padding: 14px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            transition: all 0.3s;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        .btn-secondary:hover {
            background: #4b5563;
        }
        .required {
            color: #ef4444;
        }
        .info-text {
            font-size: 12px;
            color: #6b7280;
            margin-top: 5px;
        }
        .current-file {
            padding: 10px;
            background: #f0fdf4;
            border: 1px solid #86efac;
            border-radius: 6px;
            margin-top: 8px;
            color: #166534;
            font-size: 14px;
        }
        .status-info {
            padding: 15px;
            background: #eff6ff;
            border: 1px solid #93c5fd;
            border-radius: 8px;
            margin-bottom: 25px;
        }
        .status-info h3 {
            color: #1e40af;
            margin-bottom: 5px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>✏️ Edit Ticket</h1>

        <div class="status-info">
            <h3>Current Status</h3>
            <p>You can update ticket details and change the status below. Use "Mark as Solved" button on the list page for quick status updates.</p>
        </div>

        <form action="${pageContext.request.contextPath}/tickets/${ticket.id}" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="customerName">Customer Name <span class="required">*</span></label>
                <input type="text" id="customerName" name="customerName"
                       value="${ticket.customerName}" required>
            </div>

            <div class="form-group">
                <label for="contactNumber">Contact Number <span class="required">*</span></label>
                <input type="tel" id="contactNumber" name="contactNumber"
                       value="${ticket.contactNumber}" required>
            </div>

            <div class="form-group">
                <label for="email">Email Address <span class="required">*</span></label>
                <input type="email" id="email" name="email"
                       value="${ticket.email}" required>
            </div>

            <div class="form-group">
                <label for="category">Category <span class="required">*</span></label>
                <select id="category" name="category" required>
                    <option value="BROKER_HIRING" ${ticket.category == 'BROKER_HIRING' ? 'selected' : ''}>
                        Broker Hiring
                    </option>
                    <option value="LAND_PROPERTY_SELLING" ${ticket.category == 'LAND_PROPERTY_SELLING' ? 'selected' : ''}>
                        Land Property Selling
                    </option>
                    <option value="GENERAL_INQUIRY" ${ticket.category == 'GENERAL_INQUIRY' ? 'selected' : ''}>
                        General Inquiry
                    </option>
                </select>
            </div>

            <div class="form-group">
                <label for="status">Status <span class="required">*</span></label>
                <select id="status" name="status" required>
                    <option value="PENDING" ${ticket.status == 'PENDING' ? 'selected' : ''}>
                        Pending
                    </option>
                    <option value="IN_PROGRESS" ${ticket.status == 'IN_PROGRESS' ? 'selected' : ''}>
                        In Progress
                    </option>
                    <option value="SOLVED" ${ticket.status == 'SOLVED' ? 'selected' : ''}>
                        Solved
                    </option>
                    <option value="CLOSED" ${ticket.status == 'CLOSED' ? 'selected' : ''}>
                        Closed
                    </option>
                </select>
            </div>

            <div class="form-group">
                <label for="subject">Subject <span class="required">*</span></label>
                <input type="text" id="subject" name="subject"
                       value="${ticket.subject}" required>
            </div>

            <div class="form-group">
                <label for="concern">Concern/Details <span class="required">*</span></label>
                <textarea id="concern" name="concern" required>${ticket.concern}</textarea>
            </div>

            <div class="form-group">
                <label for="file">Update Document (Optional)</label>
                <c:if test="${not empty ticket.documentPath}">
                    <div class="current-file">
                        📎 Current file: ${ticket.documentPath}
                    </div>
                </c:if>
                <input type="file" id="file" name="file"
                       accept="image/*,.pdf,.doc,.docx">
                <p class="info-text">Upload a new file to replace the existing one</p>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-primary">Update Ticket</button>
                <a href="${pageContext.request.contextPath}/tickets" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>
