### Task 1: Deep Research & Validation
**The Reality Check:**
*   **Tech Stack Match:** Excellent. FastAPI is the perfect asynchronous backend for serving ML models (XGBoost/Random Forest), and Supabase with PostgreSQL provides robust relational data handling. 
*   **Cultural & Logic Contradiction:** You claim to "eliminate the traditional 20% food safety buffer" to achieve 100% utilization. In the Indian wedding market, running out of food is a reputational catastrophe for the host and the caterer. No event planner will buy a software that operates on a 0% margin of error. Your ML model must optimize the buffer, not eliminate it.
*   **The Data Gap:** Random Forest and XGBoost require large datasets of historical data to make accurate predictions. Since every wedding, family demographic, and venue is entirely different, you suffer from a severe "Cold Start Problem." 

---

### Task 2: The "20+ Valid Failures" Challenge

#### A. Security & Data Integrity
1.  **QR Spoofing & Forwarding:** What prevents a guest from screenshotting their personalized QR code and sending it to 5 uninvited friends? Without dynamic, time-rotating QR codes, your headcount security is nonexistent.
2.  **JWT Vulnerability:** If your Next.js frontend stores Supabase JWTs in `localStorage` rather than `httpOnly` cookies, your app is highly susceptible to Cross-Site Scripting (XSS) attacks.
3.  **PII & Dietary Data Exposure:** You are collecting granular guest data (locations, phone numbers, food preferences). Without column-level encryption in PostgreSQL, a database breach exposes sensitive tracking data.
4.  **Unsecured SOS Webhooks:** An open API endpoint for "Instant SOS Response" is a prime target for pranksters. If a bored teenager spams the SOS button, it will cause mass panic and render the system useless.

#### B. Scalability & Performance
5.  **The "Muhurtham" Spike Bottleneck:** Indian weddings have massive surges (e.g., 1000 guests arriving right before the main ceremony). Pinging the Next.js frontend for dynamic GPS and check-ins all at once will overwhelm your DB connections if Redis isn't configured for heavy read-caching.
6.  **Missing WebSocket Infrastructure:** You claim "Real-time metrics are pushed to the dashboard." FastAPI REST endpoints alone cannot *push* data. Without WebSockets or Server-Sent Events (SSE), your frontend will have to poll the server, killing performance.
7.  **Blocking ML Inference:** If your XGBoost predictions run synchronously on the FastAPI main thread every time a guest RSVPs, you will block the ASGI workers, causing timeouts during high traffic.
8.  **Database Locking on Load Balancing:** Managing "rush hours" by dynamically updating room and parking assignments will cause severe database row-locking issues in PostgreSQL if multiple ushers/guests are updating statuses concurrently.

#### C. UX/Edge Cases
9.  **The "Boomer" Factor:** A large portion of Indian wedding attendees are elderly. They will not scan QR codes, they will not RSVP digitally, and they will ignore your parking app. If 40% of guests bypass the system, your ML predictions become instantly worthless.
10. **Network Dead Zones:** Many marriage halls and farmhouses are in areas with terrible 4G/5G reception. A cloud-dependent QR check-in will completely fail at the entrance.
11. **Phantom RSVPs & "+3s":** People will RSVP "Yes" out of politeness but not show up, or RSVP for 2 and bring 5. Your data capture assumes user honesty, which is a critical flaw.
12. **The "Rogue Parker":** Your app "guides vehicles to designated spaces." What happens when a guest ignores the app and parks across three designated spots? The digital twin no longer matches physical reality, causing gridlock.

#### D. Logic & Implementation
13. **Late NGO Alert Trigger:** Your flow triggers NGOs "Post-meal" (e.g., midnight after a reception). NGOs cannot mobilize transport for highly perishable, cooked Indian food at 1 AM. It violates food safety logistics.
14. **Granular GPS Delusion:** Standard Google Maps APIs do not support indoor or highly granular "hall-specific" routing on private wedding grounds without expensive custom mapping.
15. **Unverifiable "Zero-Waste" Metrics:** Calculating accurate carbon footprints requires knowing exactly how much electricity and fuel was used. Approximating this via guest count is statistically invalid for a "Certification."
16. **Lack of Dynamic Re-Routing:** If a VIP arrives, there is no logic mentioned to dynamically clear a parking path or pause standard guest routing.

#### E. Compliance & Error Handling
17. **FSSAI Liability (Food Safety):** Distributing leftover buffet food in India falls under FSSAI regulations. If food spoils during the NGO transfer and people get sick, the event planner (your client) is legally liable. You lack a digital liability waiver flow.
18. **No Offline Check-in Fallback:** If your backend goes down, the bouncers at the door have no way to verify guests. There is no offline PWA ledger mentioned.
19. **Google Maps API Billing Trap:** An unoptimized frontend constantly querying Google Maps API for live tracking 2,000 guests will drain your startup's bank account in hours.
20. **Device Battery Drain:** Live GPS tracking via a Next.js web app will rapidly drain the battery of the guest's phone during an event that lasts several hours.

---

### Task 3: The Mentor’s Blueprint (10+ Strategic Additions)
*To evolve FIGHT CLUB from a hackathon MVP to a VC-backable B2B Event-Tech startup, implement the following architectural shifts:*

**1. WhatsApp Bot Integration (Frictionless RSVP):**
Ditch the mandatory web portal for guests. Integrate the WhatsApp Business API. Allow guests to RSVP, select meals, and receive their QR codes entirely within WhatsApp. This solves the "Boomer Factor" instantly.

**2. Computer Vision for Real-Time Headcounts (Passive Data):**
Don't rely solely on QR scans. Integrate a lightweight OpenCV model with the venue's existing CCTV at the dining hall entrance to count actual heads entering vs. exiting. Feed this *passive* data into your ML model for real-time consumption rates.

**3. Predictive (Pre-Meal) NGO Dispatching:**
Instead of alerting NGOs *after* the event, use your ML model to predict surplus *during* the meal. If the CV camera detects dining has slowed by 80%, trigger the NGO dispatch so they arrive exactly as the buffet closes, ensuring food safety.

**4. Introduce "Dynamic Buffer Optimization":**
Never claim to eliminate the buffer. Pivot your ML model's output to calculate a "Dynamic Buffer" (e.g., 4.5% instead of 20%). Show the caterer the exact statistical confidence interval so they feel safe trusting the AI.

**5. Asynchronous ML Architecture:**
Remove XGBoost from the main FastAPI thread. Use Celery and Redis to queue RSVP updates and run batch predictions every 15 minutes, pushing the updated analytics to the dashboard via WebSockets.

**6. Offline-First PWA for Venue Staff:**
Build the Organizer/Usher Dashboard as a Progressive Web App (PWA) with SQLite/IndexedDB. Allow them to scan QR codes offline; the app will automatically sync with Supabase the moment the device reconnects to Wi-Fi.

**7. IoT Smart Parking Integration:**
Don't rely on guests following GPS. Partner with venues to use simple IoT ultrasonic sensors or CCTV to detect which parking spots are *actually* filled, updating the organizer dashboard's map in real-time.

**8. Tiered RBAC (Role-Based Access Control):**
The Event Planner, Caterer, and Security Guard need completely different interfaces. Implement strict RBAC. The caterer should only see food metrics, security should only see parking/SOS, and the planner sees the master view.

**9. FSSAI & Legal API Handshake:**
Build a digital sign-off feature. When the NGO picks up the food, both the caterer and NGO representative digitally sign via the app, logging the timestamp and transferring legal liability away from the host.

**10. "Eco-Flex" Gamification for Guests:**
Incentivize guests to carpool or choose eco-friendly options during RSVP by offering them "VIP Parking" or priority seating. Use behavioral economics to shape logistics rather than just reacting to them.

**11. Time-Based Rotating QR Codes (TOTP):**
To prevent ticket spoofing, implement Time-Based One-Time Passwords (TOTP) into the QR codes, similar to how ticketing platforms (like BookMyShow or Ticketmaster) prevent screenshot sharing.

