package com.example.Ticket.Management.service;

import com.example.Ticket.Management.repository.TicketRepository;
import com.example.Ticket.Management.model.Ticket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class TicketService {

    @Autowired
    private TicketRepository ticketRepository;

    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    public List<Ticket> getAllTickets() {
        return ticketRepository.findAllByOrderByCreatedAtAsc();
    }

    public Optional<Ticket> getTicketById(Long id) {
        return ticketRepository.findById(id);
    }

    public Ticket createTicket(Ticket ticket, MultipartFile file) throws IOException {
        if (file != null && !file.isEmpty()) {
            String fileName = saveFile(file);
            ticket.setDocumentPath(fileName);
        }
        return ticketRepository.save(ticket);
    }

    public Ticket updateTicket(Long id, Ticket ticketDetails, MultipartFile file) throws IOException {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Ticket not found with id: " + id));

        ticket.setCustomerName(ticketDetails.getCustomerName());
        ticket.setContactNumber(ticketDetails.getContactNumber());
        ticket.setEmail(ticketDetails.getEmail());
        ticket.setSubject(ticketDetails.getSubject());
        ticket.setConcern(ticketDetails.getConcern());
        ticket.setCategory(ticketDetails.getCategory());
        ticket.setStatus(ticketDetails.getStatus());

        if (file != null && !file.isEmpty()) {
            // Delete old file if exists
            if (ticket.getDocumentPath() != null) {
                deleteFile(ticket.getDocumentPath());
            }
            String fileName = saveFile(file);
            ticket.setDocumentPath(fileName);
        }

        return ticketRepository.save(ticket);
    }

    public void deleteTicket(Long id) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Ticket not found with id: " + id));

        if (ticket.getDocumentPath() != null) {
            deleteFile(ticket.getDocumentPath());
        }

        ticketRepository.delete(ticket);
    }

    public Ticket markAsSolved(Long id) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Ticket not found with id: " + id));
        ticket.setStatus(Ticket.Status.SOLVED);
        return ticketRepository.save(ticket);
    }

    private String saveFile(MultipartFile file) throws IOException {
        File uploadDirectory = new File(uploadDir);
        if (!uploadDirectory.exists()) {
            uploadDirectory.mkdirs();
        }

        String originalFileName = file.getOriginalFilename();
        String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
        String fileName = UUID.randomUUID().toString() + extension;

        Path filePath = Paths.get(uploadDir, fileName);
        Files.write(filePath, file.getBytes());

        return fileName;
    }

    private void deleteFile(String fileName) {
        try {
            Path filePath = Paths.get(uploadDir, fileName);
            Files.deleteIfExists(filePath);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}