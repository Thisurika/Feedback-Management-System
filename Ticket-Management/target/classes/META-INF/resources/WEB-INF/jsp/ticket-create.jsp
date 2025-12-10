<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create New Ticket</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            padding: 20px;
            background: url("https://cdn.pixabay.com/photo/2022/07/10/19/30/house-7313645_1280.jpg") no-repeat center center fixed;
            background-size: cover;
            position: relative;
        }
        body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.55); /* dark overlay */
            z-index: -1;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.4);
            padding: 40px;
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
        .file-input-wrapper {
            position: relative;
            display: inline-block;
            width: 100%;
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
        .category-description {
            font-size: 13px;
            color: #6b7280;
            margin-top: 8px;
            padding: 10px;
            background: #f9fafb;
            border-radius: 6px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📝 Create New Ticket</h1>

        <form action="${pageContext.request.contextPath}/tickets" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="customerName">Customer Name <span class="required">*</span></label>
                <input type="text" id="customerName" name="customerName" required
                       placeholder="Enter customer full name">
            </div>

            <div class="form-group">
                <label for="contactNumber">Contact Number <span class="required">*</span></label>
                <input type="tel" id="contactNumber" name="contactNumber" required
                       placeholder="e.g., +94 77 123 4567">
            </div>

            <div class="form-group">
                <label for="email">Email Address <span class="required">*</span></label>
                <input type="email" id="email" name="email" required
                       placeholder="customer@example.com">
            </div>

            <div class="form-group">
                <label for="category">Category <span class="required">*</span></label>
                <select id="category" name="category" required onchange="updateCategoryDescription()">
                    <option value="">-- Select Category --</option>
                    <option value="BROKER_HIRING">Broker Hiring</option>
                    <option value="LAND_PROPERTY_SELLING">Land Property Selling</option>
                    <option value="GENERAL_INQUIRY">General Inquiry</option>
                </select>
                <div id="categoryDescription" class="category-description" style="display: none;"></div>
            </div>

            <div class="form-group">
                <label for="subject">Subject <span class="required">*</span></label>
                <input type="text" id="subject" name="subject" required
                       placeholder="Brief description of your request">
            </div>

            <div class="form-group">
                <label for="concern">Concern/Details <span class="required">*</span></label>
                <textarea id="concern" name="concern" required
                          placeholder="Provide detailed information about your concern..."></textarea>
                <p class="info-text">Please provide as much detail as possible to help us assist you better.</p>
            </div>

            <div class="form-group">
                <label for="file">Upload Document (Optional)</label>
                <input type="file" id="file" name="file"
                       accept="image/*,.pdf,.doc,.docx">
                <p class="info-text">Accepted formats: Images, PDF, Word documents (Max 10MB)</p>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-primary">Create Ticket</button>
                <a href="${pageContext.request.contextPath}/tickets" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

    <script>
        function updateCategoryDescription() {
            const category = document.getElementById('category').value;
            const descriptionDiv = document.getElementById('categoryDescription');

            const descriptions = {
                'BROKER_HIRING': 'You are looking to hire a broker for property transactions. We will connect you with qualified brokers in your area.',
                'LAND_PROPERTY_SELLING': 'You want to sell your land or property. Our team will assist you with the selling process and find potential buyers.',
                'GENERAL_INQUIRY': 'General questions or inquiries about our services.'
            };

            if (category && descriptions[category]) {
                descriptionDiv.textContent = descriptions[category];
                descriptionDiv.style.display = 'block';
            } else {
                descriptionDiv.style.display = 'none';
            }
        }
    </script>
</body>
</html>
