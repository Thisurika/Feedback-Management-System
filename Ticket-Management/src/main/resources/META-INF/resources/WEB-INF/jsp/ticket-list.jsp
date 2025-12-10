<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>Ticket Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #ffffff; /* Changed to white as requested */
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 30px;
        }
        h1 {
            color: #333;
            margin-bottom: 30px;
            font-size: 2.5em;
            text-align: center;
        }
        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
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
        .btn-success {
            background: #10b981;
            color: white;
            padding: 8px 16px;
            font-size: 14px;
        }
        .btn-warning {
            background: #f59e0b;
            color: white;
            padding: 8px 16px;
            font-size: 14px;
        }
        .btn-danger {
            background: #ef4444;
            color: white;
            padding: 8px 16px;
            font-size: 14px;
        }
        .btn-success:hover { background: #059669; }
        .btn-warning:hover { background: #d97706; }
        .btn-danger:hover { background: #dc2626; }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 500;
        }
        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #10b981;
        }
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #ef4444;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
        }
        th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #e5e7eb;
        }
        tr:hover {
            background: #f9fafb;
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }
        .status-in-progress {
            background: #dbeafe;
            color: #1e40af;
        }
        .status-solved {
            background: #d1fae5;
            color: #065f46;
        }
        .status-closed {
            background: #e5e7eb;
            color: #374151;
        }
        .category-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        .category-broker {
            background: #ddd6fe;
            color: #5b21b6;
        }
        .category-land {
            background: #fed7aa;
            color: #9a3412;
        }
        .category-general {
            background: #bae6fd;
            color: #075985;
        }
        .actions {
            display: flex;
            gap: 8px;
        }
        .no-tickets {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
            font-size: 18px;
        }
        #modalDocument img {
            max-width: 100%;
            max-height: 400px;
            display: block;
            margin-top: 10px;
            border-radius: 8px;
        }
        /* modern modal styles */
        #ticketModal { display: none; position: fixed; inset: 0; z-index: 9999; font-family: inherit; }
        #ticketModal[aria-hidden="false"] { display: block; }

        /* semi-transparent backdrop */
        #ticketModal .modal-backdrop {
          position: absolute; inset: 0;
          background: linear-gradient(180deg, rgba(15,23,42,0.6), rgba(15,23,42,0.54));
          backdrop-filter: blur(3px);
        }

        /* card */
        #ticketModal .modal-card {
          position: relative;
          max-width: 940px;
          width: calc(100% - 48px);
          margin: 48px auto;
          background: linear-gradient(180deg, #ffffff, #fbfbff);
          border-radius: 12px;
          box-shadow: 0 20px 50px rgba(2,6,23,0.45);
          padding: 20px 20px 18px;
          z-index: 2;
          transform: translateY(12px);
          opacity: 0;
          transition: transform .22s ease, opacity .22s ease;
        }

        /* show animation */
        #ticketModal[aria-hidden="false"] .modal-card {
          transform: translateY(0);
          opacity: 1;
        }

        /* close button */
        .modal-close {
          position: absolute;
          right: 14px;
          top: 12px;
          border: none;
          background: transparent;
          font-size: 20px;
          cursor: pointer;
          color: #374151;
        }

        /* header */
        .modal-header { display:flex; justify-content:space-between; align-items:flex-start; gap:12px; margin-bottom:12px; }
        .modal-title { margin:0; font-size:20px; color:#111827; }
        .modal-subtitle { margin:0; color:#6b7280; font-size:13px; }

        /* status badge */
        .modal-status { align-self:center; padding:8px 12px; border-radius:999px; font-weight:700; font-size:13px; text-transform:capitalize; }

        /* body */
        .modal-body { padding: 8px 0 12px; }
        .modal-grid { display:grid; grid-template-columns: 1fr 1.3fr; gap: 18px; align-items:start; }

       /* left meta */
       .meta p {
         margin:6px 0;
         display:flex;
         align-items:center;
         gap:6px; /* smaller gap for closeness */
       }
       .meta-label {
         color:#6b7280;
         font-size:13px;
         min-width:80px; /* consistent width for labels */
       }
       .meta-value {
         color:#111827;
         font-weight:600;
         text-align:left;
       }


        /* subject & concern */
        .subject { margin:6px 0 10px; color:#0f172a; font-size:16px; }
        .concern { background:#f8fafc; padding:12px; border-radius:8px; color:#0f172a; line-height:1.5; max-height:220px; overflow:auto; border:1px solid #eef2ff; }

        /* document preview */
        .document-section { margin-top:14px; }
        .document-preview { margin-top:8px; min-height:64px; display:flex; align-items:center; gap:12px; flex-wrap:wrap; }
        .document-preview img { max-width:220px; max-height:160px; object-fit:cover; border-radius:8px; border:1px solid #e6eef8; }
        .document-preview iframe { width:100%; min-height:360px; border-radius:8px; border:1px solid #e6eef8; }

        /* footer */
        .modal-footer {
          display:flex;
          justify-content:flex-end;
          gap:10px;
          margin-top:14px;
          align-items:center;
        }

        /* responsive */
        @media (max-width:820px) {
          .modal-grid { grid-template-columns: 1fr; }
          .meta p { justify-content:flex-start; gap:8px; }
          .meta-label { width:35%; color:#6b7280; }
          .meta-value { text-align:left; }
          .document-preview iframe { min-height:260px; }
        }


        /* NEW: filter bar styles (added) */
        .filter-bar {
            display: flex;
            gap: 12px;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        /* UPDATED: filter bar styles (filters left, actions right) */
        .filter-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            gap: 16px;
            flex-wrap: wrap;
        }

        /* left side group of filters */
        .filter-group {
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-group label {
            font-size: 14px;
            color: #374151;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* right side group for buttons */
        .filter-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }


        .filter-select {
            padding: 8px 10px;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
            font-size: 14px;
        }
        .filter-clear {
            padding: 8px 12px;
            border-radius: 8px;
            background: #ef4444;
            color: #fff;
            border: none;
            cursor: pointer;
        }
        .filter-clear:hover { opacity: 0.95; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎫 Feedback Management System</h1>

        <div class="header-actions">
            <h2>All Tickets</h2>
            <!-- Buttons moved to filter bar for better alignment -->
        </div>

        <!-- NEW: Filter bar (category + status + clear). This is the only UI added. -->
        <div class="filter-bar" aria-label="Ticket filters">
            <div class="filter-group" role="group" aria-label="Filters">
                <label for="filterCategory">
                    Category:
                    <select id="filterCategory" class="filter-select">
                        <option value="ALL">All</option>
                        <option value="BROKER_HIRING">Broker Hiring</option>
                        <option value="LAND_PROPERTY_SELLING">Land Property Selling</option>
                        <option value="GENERAL_INQUIRY">General Inquiry</option>
                        <option value="GENERAL">General</option>
                    </select>
                </label>

                <label for="filterStatus">
                    Status:
                    <select id="filterStatus" class="filter-select">
                        <option value="ALL">All</option>
                        <option value="PENDING">Pending</option>
                        <option value="IN_PROGRESS">In Progress</option>
                        <option value="SOLVED">Solved</option>
                        <option value="CLOSED">Closed</option>
                    </select>
                </label>

                <button id="clearFilters" class="filter-clear" title="Clear filters">Clear Filters</button>
            </div>

            <div class="filter-actions" role="group" aria-label="Actions">
                <a href="${pageContext.request.contextPath}/tickets/new" class="btn btn-primary" title="Create New Ticket">
                    ➕ Create New Ticket
                </a>
                <a href="${pageContext.request.contextPath}/tickets/dashboard" class="btn btn-primary" title="Dashboard">
                    📊 Dashboard
                </a>
            </div>
        </div>

        <!-- END filter bar -->

        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <c:choose>
            <c:when test="${not empty tickets}">
                <table>
                    <thead>
                        <tr>
                            <th>Id</th>
                            <th>Customer Name</th>
                            <th>Contact</th>
                            <th>Email</th>
                            <th>Subject</th>
                            <th>Category</th>
                            <th>Status</th>
                            <th>Created At</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${tickets}" var="ticket" varStatus="loop">
                            <tr>
                                <td>
                                    <span
                                        class="open-modal"
                                        style="cursor:pointer; color:blue; text-decoration:underline;"
                                        data-id="${ticket.id}"
                                        data-customer="${ticket.customerName}"
                                        data-contact="${ticket.contactNumber}"
                                        data-email="${ticket.email}"
                                        data-subject="${ticket.subject}"
                                        data-category="${ticket.category}"
                                        data-status="${ticket.status}"
                                        data-date="<fmt:formatDate value='${ticket.listingDateAsDate}' pattern='MMM dd, yyyy' />"
                                        data-concern="${fn:escapeXml(ticket.concern)}"
                                        data-document="${fn:escapeXml(ticket.documentPath)}"
                                    >
                                        ${loop.count}
                                    </span>
                                </td>

                                <td><strong>${ticket.customerName}</strong></td>
                                <td>${ticket.contactNumber}</td>
                                <td>${ticket.email}</td>
                                <td>${ticket.subject}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${ticket.category == 'BROKER_HIRING'}">
                                            <span class="category-badge category-broker">Broker Hiring</span>
                                        </c:when>
                                        <c:when test="${ticket.category == 'LAND_PROPERTY_SELLING'}">
                                            <span class="category-badge category-land">Land Property Selling</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="category-badge category-general">General Inquiry</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${ticket.status == 'PENDING'}">
                                            <span class="status-badge status-pending">Pending</span>
                                        </c:when>
                                        <c:when test="${ticket.status == 'IN_PROGRESS'}">
                                            <span class="status-badge status-in-progress">In Progress</span>
                                        </c:when>
                                        <c:when test="${ticket.status == 'SOLVED'}">
                                            <span class="status-badge status-solved">Solved</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-closed">Closed</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${ticket.listingDateAsDate}" pattern="MMM dd, yyyy" />
                                </td>
                                <td>
                                    <div class="actions">
                                        <c:if test="${ticket.status != 'SOLVED' && ticket.status != 'CLOSED'}">
                                            <c:choose>
                                                <c:when test="${loop.first && ticket.status == 'PENDING'}">
                                                    <form method="post" action="${pageContext.request.contextPath}/tickets/${ticket.id}/solve" style="display:inline;">
                                                        <button type="submit" class="btn btn-success">✓ Solve</button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${!loop.first && ticket.status == 'PENDING'}">
                                                    <button type="button" class="btn btn-success" disabled style="opacity: 0.5; cursor: not-allowed;" title="Please solve the first pending ticket first">✓ Solve</button>
                                                </c:when>
                                                <c:when test="${ticket.status == 'IN_PROGRESS'}">
                                                    <form method="post" action="${pageContext.request.contextPath}/tickets/${ticket.id}/solve" style="display:inline;">
                                                        <button type="submit" class="btn btn-success">✓ Solve</button>
                                                    </form>
                                                </c:when>
                                            </c:choose>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/tickets/${ticket.id}/edit" class="btn btn-warning">✏ Edit</a>
                                        <a href="${pageContext.request.contextPath}/tickets/${ticket.id}/delete"
                                           class="btn btn-danger"
                                           onclick="return confirm('Are you sure you want to delete this ticket?')">🗑 Delete</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="no-tickets">
                    <p>No tickets found. Create your first ticket to get started!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Modal -->
    <!-- BEGIN: Modern modal -->
    <div id="ticketModal" aria-hidden="true" role="dialog" aria-labelledby="ticketModalTitle">
      <div class="modal-backdrop"></div>
      <div class="modal-card" role="document" aria-modal="true">
        <button class="modal-close" aria-label="Close ticket details" onclick="closeModal()">
          ✕
        </button>

        <header class="modal-header">
          <div>
            <h3 id="ticketModalTitle" class="modal-title">Ticket Details</h3>
            <p class="modal-subtitle" id="modalDateSmall"></p>
          </div>
          <div class="modal-status" id="modalStatusBadge"></div>
        </header>

        <section class="modal-body">
          <div class="modal-grid">
            <div class="meta">
              <p><span class="meta-label">Customer</span><span id="modalCustomer" class="meta-value"></span></p>
              <p><span class="meta-label">Contact</span><span id="modalContact" class="meta-value"></span></p>
              <p><span class="meta-label">Email</span><span id="modalEmail" class="meta-value"></span></p>
              <p><span class="meta-label">Category</span><span id="modalCategory" class="meta-value"></span></p>
            </div>

            <div class="subject-concern">
              <p><span class="meta-label">Subject</span></p>
              <h4 id="modalSubject" class="subject"></h4>

              <p style="margin-top:12px;"><span class="meta-label">Concern</span></p>
              <div id="modalConcern" class="concern"></div>
            </div>
          </div>

          <div class="document-section">
            <p class="meta-label">Attached Document</p>
            <div id="modalDocument" class="document-preview">
              <!-- preview injected by JS -->
            </div>
          </div>
        </section>

        <footer class="modal-footer">
          <a id="openTicketEdit" href="#" class="btn btn-warning">✏ Edit</a>
          <form id="solveFormWrapper" method="post" action="#" style="display:inline;">
            <button id="solveButton" type="submit" class="btn btn-success">✓ Solve</button>
          </form>
          <a id="deleteLink" href="#" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this ticket?')">🗑 Delete</a>
        </footer>
      </div>
    </div>
    <!-- END: Modern modal -->


    <script>
        // Replace the whole "Open Modal" block with this corrected version
        document.querySelectorAll('.open-modal').forEach(function(item) {
          item.addEventListener('click', function() {
            const modal = document.getElementById('ticketModal');
            const modalCustomer = document.getElementById('modalCustomer');
            const modalContact = document.getElementById('modalContact');
            const modalEmail = document.getElementById('modalEmail');
            const modalSubject = document.getElementById('modalSubject');
            const modalConcern = document.getElementById('modalConcern');
            const modalCategory = document.getElementById('modalCategory');
            const modalDateSmall = document.getElementById('modalDateSmall');
            const modalStatusBadge = document.getElementById('modalStatusBadge');
            const modalDocument = document.getElementById('modalDocument');

            modalCustomer.textContent = this.dataset.customer || '-';
            modalContact.textContent = this.dataset.contact || '-';
            modalEmail.textContent = this.dataset.email || '-';
            modalSubject.textContent = this.dataset.subject || '-';

            // preserve newlines in concern
            const rawConcern = this.dataset.concern || '';
            modalConcern.innerHTML = rawConcern ? rawConcern.replace(/\n/g, '<br/>') : '<span style="color:#6b7280;">No details provided.</span>';

            // category mapping
            const categoryMap = {
              'BROKER_HIRING': 'Broker Hiring',
              'LAND_PROPERTY_SELLING': 'Land Property Selling',
              'GENERAL_INQUIRY': 'General Inquiry',
              'GENERAL': 'General Inquiry'
            };
            modalCategory.textContent = categoryMap[this.dataset.category] || (this.dataset.category || '-');

            // status mapping + badge color
            const statusMap = {
              'PENDING': { text: 'Pending', color: '#92400e', bg:'#fffbeb' },
              'IN_PROGRESS': { text: 'In Progress', color: '#1e40af', bg:'#eff6ff' },
              'SOLVED': { text: 'Solved', color: '#065f46', bg:'#ecfdf5' },
              'CLOSED': { text: 'Closed', color: '#374151', bg:'#f3f4f6' }
            };
            const s = statusMap[this.dataset.status] || { text: (this.dataset.status || 'Unknown'), color:'#374151', bg:'#f3f4f6' };
            modalStatusBadge.textContent = s.text;
            modalStatusBadge.style.background = s.bg;
            modalStatusBadge.style.color = s.color;

            // date
            modalDateSmall.textContent = this.dataset.date || '';

            // DOCUMENT handling using DOM methods (no tricky innerHTML strings)
            modalDocument.innerHTML = ''; // clear previous
            const docPath = this.dataset.document;
            if (docPath && docPath.trim() !== '' && docPath !== 'null') {
              const filename = docPath.split('/').pop().split('\\').pop();
              const extension = filename.split('.').pop().toLowerCase();
              const documentUrl = '${pageContext.request.contextPath}/tickets/documents/' + encodeURIComponent(filename);

              if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].includes(extension)) {
                const img = document.createElement('img');
                img.src = documentUrl;
                img.alt = 'Document Image';
                img.style.maxWidth = '220px';
                img.style.maxHeight = '160px';
                img.style.objectFit = 'cover';
                img.style.borderRadius = '8px';
                img.style.border = '1px solid #e6eef8';
                img.onerror = function() {
                  // replace preview with error message
                  const p = document.createElement('p');
                  p.style.color = 'red';
                  p.textContent = 'Error loading image';
                  this.parentElement.innerHTML = '';
                  this.parentElement.appendChild(p);
                };
                modalDocument.appendChild(img);
              } else if (extension === 'pdf') {
                const iframe = document.createElement('iframe');
                iframe.src = documentUrl;
                iframe.frameBorder = '0';
                iframe.style.width = '100%';
                iframe.style.minHeight = '360px';
                iframe.style.borderRadius = '8px';
                iframe.style.border = '1px solid #e6eef8';
                modalDocument.appendChild(iframe);
              } else {
                const a = document.createElement('a');
                a.href = documentUrl;
                a.target = '_blank';
                a.className = 'btn btn-primary';
                a.style.display = 'inline-block';
                a.textContent = '📄 Open document';
                modalDocument.appendChild(a);
              }
            } else {
              const span = document.createElement('span');
              span.style.color = '#6b7280';
              span.textContent = 'No document attached.';
              modalDocument.appendChild(span);
            }

            // wire action links (Edit, Solve form, Delete)
            const ticketId = this.dataset.id;
            const editLink = document.getElementById('openTicketEdit');
            const solveFormWrap = document.getElementById('solveFormWrapper');
            const solveButton = document.getElementById('solveButton');
            const deleteLink = document.getElementById('deleteLink');

            if (ticketId) {
              editLink.href = '${pageContext.request.contextPath}/tickets/' + ticketId + '/edit';
              solveFormWrap.action = '${pageContext.request.contextPath}/tickets/' + ticketId + '/solve';
              deleteLink.href = '${pageContext.request.contextPath}/tickets/' + ticketId + '/delete';
              if (solveButton) solveButton.style.display = '';
            } else {
              if (solveButton) solveButton.style.display = 'none';
            }

            // show modal
            modal.setAttribute('aria-hidden', 'false');
          });
        });



        // Close Modal
        function closeModal() {
          const modal = document.getElementById('ticketModal');
          modal.setAttribute('aria-hidden', 'true');
          const solveButton = document.getElementById('solveButton');
          if (solveButton) solveButton.style.display = '';
        }

        // close when clicking the backdrop (not inside the card)
        document.getElementById('ticketModal').addEventListener('click', function(e) {
          if (e.target && e.target.classList && e.target.classList.contains('modal-backdrop')) {
            closeModal();
          }
        });

        // Close modal on Escape key
        document.addEventListener('keydown', function(event) {
          if (event.key === 'Escape') {
            closeModal();
          }
        });


        // NEW: Filtering logic (category + status). This JS was added without touching existing logic.
        (function() {
            const categorySelect = document.getElementById('filterCategory');
            const statusSelect = document.getElementById('filterStatus');
            const clearBtn = document.getElementById('clearFilters');

            function applyFilters() {
                const selectedCategory = categorySelect.value;
                const selectedStatus = statusSelect.value;

                const rows = document.querySelectorAll('tbody tr');
                rows.forEach(function(row) {
                    const opener = row.querySelector('.open-modal');
                    if (!opener) {
                        // no opener found - hide just in case
                        row.style.display = 'none';
                        return;
                    }

                    const rowCategory = opener.dataset.category || '';
                    const rowStatus = opener.dataset.status || '';

                    // category matching: allow both GENERAL and GENERAL_INQUIRY to match "General Inquiry"
                    let categoryMatch = (selectedCategory === 'ALL');
                    if (!categoryMatch) {
                        if (selectedCategory === 'GENERAL_INQUIRY') {
                            categoryMatch = (rowCategory === 'GENERAL_INQUIRY' || rowCategory === 'GENERAL' || rowCategory === '');
                        } else {
                            categoryMatch = (rowCategory === selectedCategory);
                        }
                    }

                    const statusMatch = (selectedStatus === 'ALL' || rowStatus === selectedStatus);

                    row.style.display = (categoryMatch && statusMatch) ? '' : 'none';
                });
            }

            // Attach events
            categorySelect.addEventListener('change', applyFilters);
            statusSelect.addEventListener('change', applyFilters);

            clearBtn.addEventListener('click', function() {
                categorySelect.value = 'ALL';
                statusSelect.value = 'ALL';
                applyFilters();
            });

            // Run once on load to ensure filters apply if something pre-selected
            document.addEventListener('DOMContentLoaded', applyFilters);
        })();
        // END filtering logic
    </script>

</body>
</html>
