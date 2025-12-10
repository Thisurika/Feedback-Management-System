package com.example.Ticket.Management.controller;

import com.example.Ticket.Management.model.Ticket;
import com.example.Ticket.Management.service.TicketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ResponseBody;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/tickets")
public class TicketController {

    @Autowired
    private TicketService ticketService;

    @GetMapping
    public String listTickets(Model model) {
        model.addAttribute("tickets", ticketService.getAllTickets());
        return "ticket-list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("ticket", new Ticket());
        return "ticket-create";
    }

    @PostMapping
    public String createTicket(@ModelAttribute Ticket ticket,
                               @RequestParam(value = "file", required = false) MultipartFile file,
                               RedirectAttributes redirectAttributes) {
        try {
            ticketService.createTicket(ticket, file);
            redirectAttributes.addFlashAttribute("success", "Ticket created successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error creating ticket: " + e.getMessage());
        }
        return "redirect:/tickets";
    }

    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Ticket ticket = ticketService.getTicketById(id)
                    .orElseThrow(() -> new RuntimeException("Ticket not found"));
            model.addAttribute("ticket", ticket);
            return "ticket-edit";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Ticket not found!");
            return "redirect:/tickets";
        }
    }

    @PostMapping("/{id}")
    public String updateTicket(@PathVariable Long id,
                               @ModelAttribute Ticket ticket,
                               @RequestParam(value = "file", required = false) MultipartFile file,
                               RedirectAttributes redirectAttributes) {
        try {
            ticketService.updateTicket(id, ticket, file);
            redirectAttributes.addFlashAttribute("success", "Ticket updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating ticket: " + e.getMessage());
        }
        return "redirect:/tickets";
    }

    @GetMapping("/{id}/delete")
    public String deleteTicket(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            ticketService.deleteTicket(id);
            redirectAttributes.addFlashAttribute("success", "Ticket deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting ticket: " + e.getMessage());
        }
        return "redirect:/tickets";
    }


    @GetMapping("/documents/{filename:.+}")
    @ResponseBody
    public ResponseEntity<Resource> serveDocument(@PathVariable String filename) {
        try {
            Path file = Paths.get("uploads").resolve(filename);
            Resource resource = new UrlResource(file.toUri());

            if (resource.exists() || resource.isReadable()) {
                String contentType = Files.probeContentType(file);
                if (contentType == null) {
                    contentType = "application/octet-stream";
                }

                return ResponseEntity.ok()
                        .contentType(MediaType.parseMediaType(contentType))
                        .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + resource.getFilename() + "\"")
                        .body(resource);
            } else {
                throw new RuntimeException("Could not read file: " + filename);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error serving file: " + e.getMessage());
        }
    }

    @PostMapping("/{id}/solve")
    public String markAsSolved(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            Ticket ticketToSolve = ticketService.getTicketById(id)
                    .orElseThrow(() -> new RuntimeException("Ticket not found"));

            // Check if it's IN_PROGRESS - always allow
            if (ticketToSolve.getStatus() == Ticket.Status.IN_PROGRESS) {
                ticketService.markAsSolved(id);
                redirectAttributes.addFlashAttribute("success", "Ticket marked as solved!");
                return "redirect:/tickets";
            }

            // For PENDING tickets, check if it's the first one
            List<Ticket> allTickets = ticketService.getAllTickets();
            Ticket firstPendingTicket = allTickets.stream()
                    .filter(t -> t.getStatus() == Ticket.Status.PENDING)
                    .findFirst()
                    .orElse(null);

            if (firstPendingTicket != null && firstPendingTicket.getId().equals(id)) {
                ticketService.markAsSolved(id);
                redirectAttributes.addFlashAttribute("success", "Ticket marked as solved!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Please solve the first pending ticket first!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating ticket: " + e.getMessage());
        }
        return "redirect:/tickets";
    }

    // Add this to your TicketController.java

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        // Get all tickets
        List<Ticket> allTickets = ticketService.getAllTickets();

        // Total tickets
        model.addAttribute("totalTickets", allTickets.size());

        // Count by status
        long pendingCount = allTickets.stream()
                .filter(t -> t.getStatus() == Ticket.Status.PENDING)
                .count();
        long inProgressCount = allTickets.stream()
                .filter(t -> t.getStatus() == Ticket.Status.IN_PROGRESS)
                .count();
        long solvedCount = allTickets.stream()
                .filter(t -> t.getStatus() == Ticket.Status.SOLVED)
                .count();
        long closedCount = allTickets.stream()
                .filter(t -> t.getStatus() == Ticket.Status.CLOSED)
                .count();

        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("inProgressCount", inProgressCount);
        model.addAttribute("solvedCount", solvedCount);
        model.addAttribute("closedCount", closedCount);

        // Count by category
        long brokerHiringCount = allTickets.stream()
                .filter(t -> t.getCategory() == Ticket.Category.BROKER_HIRING)
                .count();
        long landPropertyCount = allTickets.stream()
                .filter(t -> t.getCategory() == Ticket.Category.LAND_PROPERTY_SELLING)
                .count();
        long generalInquiryCount = allTickets.stream()
                .filter(t -> t.getCategory() == Ticket.Category.GENERAL_INQUIRY)
                .count();

        model.addAttribute("brokerHiringCount", brokerHiringCount);
        model.addAttribute("landPropertyCount", landPropertyCount);
        model.addAttribute("generalInquiryCount", generalInquiryCount);

        // Get recent tickets (last 5)
        List<Ticket> recentTickets = allTickets.stream()
                .sorted((t1, t2) -> t2.getCreatedAt().compareTo(t1.getCreatedAt()))
                .limit(5)
                .collect(Collectors.toList());

        model.addAttribute("recentTickets", recentTickets);

        return "dashboard";
    }
}
