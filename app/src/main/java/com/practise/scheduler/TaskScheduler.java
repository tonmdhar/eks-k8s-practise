package com.practise.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;

@Component("backupTaskScheduler")
public class TaskScheduler {
    @Scheduled(cron = "0 */5 * * * *")  // Runs every 5 minutes
    public void runTask() {
        System.out.println("Scheduled task executed at: " + LocalDateTime.now());
    }
}