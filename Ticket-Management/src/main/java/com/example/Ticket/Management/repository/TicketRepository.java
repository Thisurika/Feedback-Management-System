package com.example.Ticket.Management.repository;


import com.example.Ticket.Management.model.Ticket;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface TicketRepository extends JpaRepository<Ticket, Long> {
    List<Ticket> findAllByOrderByCreatedAtAsc();
    List<Ticket> findByCategoryOrderByCreatedAtAsc(Ticket.Category category);
    List<Ticket> findByStatusOrderByCreatedAtAsc(Ticket.Status status);
}
