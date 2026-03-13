### Task 1: Deep Research & Validation

**The Reality Check:**

*   **Problem Statement Strength:** Indian weddings waste 20-30% of prepared food, and the team quantifies this with the "Resource Surplus Paradox." The problem is real, culturally significant, and economically massive (India's wedding industry is worth $130B+). This is one of the strongest problem-market fits in the shortlist.
*   **Tech Stack Assessment:** FastAPI backend, ML (XGBoost/RandomForest) for prediction, Google Maps API, Razorpay — solid and practical. However, the abstract also mentions "Integrated Safety Bridge" with SOS features, "Carbon Footprint Tracking," and "Load Balancing for rush hours" — the scope creep is alarming. A wedding management tool is trying to also be an emergency response system and a sustainability platform.
*   **The QR Code Assumption:** The entire system hinges on guests scanning a QR code from their invitation to RSVP digitally. In practice, Indian wedding invitations are often physical cards, and many guests (especially elderly relatives) will never scan a QR code. The team's data capture mechanism has a critical adoption bottleneck.
*   **ML Prediction Accuracy:** Using XGBoost/RandomForest to predict "exact resource requirements" requires training data. Where does this data come from? There are no public datasets of Indian wedding attendance vs. RSVP patterns. Without historical data, the "predictive" models have nothing to learn from.

---

### Task 2: The "20+ Valid Failures" Challenge

#### A. Security & Data Integrity
1.  **Guest PII via QR Scan:** When a guest scans the QR and enters their details (name, phone, dietary preferences, room requirements), this PII is collected without a clear privacy policy. Sharing dietary restrictions ("vegetarian," "Jain") can reveal religious identity.
2.  **Payment Data through Razorpay:** If the system handles any financial transactions (vendor payments, guest contributions), PCI-DSS compliance is required. No mention of payment security standards.
3.  **Guest List Data Sensitivity:** A complete digital guest list with attendance patterns, food preferences, and room assignments is sensitive social data. If leaked, it could be used for targeted marketing or social engineering.
4.  **NGO Surplus Alert Data Integrity:** Automatically alerting NGOs about surplus food requires accurate data. If the system over-reports surplus (prediction error), NGOs send vehicles for food that doesn't exist — wasting their limited resources.

#### B. Scalability & Performance
5.  **Real-Time Dashboard During Event:** A wedding with 2,000 guests checking in simultaneously will generate a burst of API calls. The FastAPI backend must handle these concurrent WebSocket connections for real-time dashboard updates.
6.  **GPS Navigation Accuracy at Venue:** Google Maps GPS navigation to a specific wedding hall within a large convention center complex is inaccurate. GPS doesn't work well inside buildings. The "GPS-guided navigation to prevent venue gridlock" will fail indoors.
7.  **ML Model Cold Start:** The first client has zero historical data. The XGBoost model cannot make meaningful predictions without at least 50-100 past events as training data. Every early client gets unreliable predictions.
8.  **Multiple Simultaneous Events:** If the platform serves 10 weddings on the same Saturday evening (common in India), all generating real-time data, the infrastructure must handle 10x concurrent load.

#### C. UX/Edge Cases
9.  **The "Last-Minute Guest" Problem:** In Indian culture, uninvited guests showing up is extremely common (sometimes 20-30% above RSVP count). The system's "precise prediction" will fail against this deeply cultural phenomenon.
10. **Elderly Guest Digital Exclusion:** Grandparents, elderly relatives, and guests from rural backgrounds won't scan QR codes. Without a phone-based RSVP alternative (IVR call or WhatsApp message), a significant portion of the guest list remains invisible to the system.
11. **Multi-Day Event Complexity:** Indian weddings span 2-5 days with different events (Mehendi, Sangeet, Wedding, Reception) at different venues with different guest lists. The system treats "a wedding" as a single event.
12. **Dietary Preference Changes:** A guest RSVPs as "non-vegetarian" but changes their mind at the event. The "precision food allocation" doesn't account for day-of changes.

#### D. Logic & Implementation
13. **Carbon Footprint Calculation Accuracy:** Calculating the "environmental impact of the wedding (transport, food waste, electricity)" requires emission factors for Indian cooking methods, local electricity grids, and vehicle types. No data source for these factors is mentioned.
14. **"Zero-Waste Certification" Authority:** Who certifies a wedding as "zero-waste"? The platform self-certifying has zero credibility. Without third-party certification partnership, this is just a marketing badge.
15. **Parking Optimization Algorithm:** "Dynamically assigns slots to minimize congestion" requires knowing the venue's parking layout (number of spots, entry/exit points, distances). This venue-specific data must be manually configured for each event.
16. **SOS Emergency Feature Scope Creep:** Adding "Instant SOS Response" and "Integrated Safety Bridge" for medical emergencies at weddings is noble but distracts from the core value proposition and adds massive liability.

#### E. Compliance & Error Handling
17. **Food Safety Liability:** If the system recommends donating surplus food to an NGO and someone gets food poisoning, who is liable? The platform needs FSSAI compliance and food safety disclaimers.
18. **No Fallback for Prediction Failure:** If the ML model predicts 500 guests but 700 show up, there's no emergency catering protocol or real-time re-ordering system.
19. **Razorpay Payment Failure During Event:** If the payment system fails during a live event (vendor payment, guest contribution), there's no offline payment fallback.
20. **Data Retention After Event:** How long is guest data retained after the wedding? No data lifecycle policy is defined. Storing guest data indefinitely violates data minimization principles.
21. **Vendor Integration Dependency:** The system assumes caterers, decorators, and venue managers will use the platform. Getting traditional Indian wedding vendors to adopt new technology is the hardest go-to-market challenge — and it's not addressed.

---

### Task 3: The Mentor's Blueprint (10+ Strategic Additions)

**1. Build a "WhatsApp RSVP Bot" as the Primary Data Capture:**
Replace QR codes with a WhatsApp-based RSVP system. Guests receive a WhatsApp message: "You're invited to [Name]'s wedding! Reply 1 for Veg, 2 for Non-Veg, 3 for Jain. Will you attend? Yes/No." This solves the elderly/non-tech guest problem.

**2. Create a "Historical Wedding Data Marketplace":**
Partner with 50+ wedding planners to collect anonymized historical data (RSVPs vs. actual attendance, food ordered vs. consumed). Use this to pre-train your ML models before onboarding the first self-service client.

**3. Implement a "Buffer Algorithm" for Indian Cultural Patterns:**
Instead of predicting "exact" attendance, predict a range with confidence intervals: "Expected: 480-550 guests (85% confidence)." Add a culturally-calibrated buffer of 15-20% for uninvited guests. Honest ranges are more useful than false precision.

**4. Partner with Zomato/Swiggy for Emergency Catering:**
If actual attendance exceeds prediction by >15%, trigger an automated emergency order to a pre-configured cloud kitchen or catering partner. This is the "insurance policy" that makes precise prediction less critical.

**5. Build a Venue Digital Twin:**
Create a 2D/3D map of each venue showing parking spots, halls, rooms, and entry/exit points. This enables actual parking optimization, indoor navigation, and crowd flow simulation — not just GPS.

**6. Focus the MVP on "Food Waste Reduction" Only:**
Strip the SOS, carbon tracking, parking, and room allocation features. Build a laser-focused product: RSVP tracking -> food prediction -> surplus detection -> NGO alert. Nail one problem before expanding.

**7. Create a "Surplus Food Pickup" Network with NGOs:**
Pre-register local NGOs (Robin Hood Army, Feeding India) with the platform. When surplus is detected, auto-dispatch the nearest NGO with quantity, location, and pickup window. This is a standalone social impact feature.

**8. Implement a "Wedding Analytics Report" as a Premium Feature:**
After the event, generate a detailed report: Total guests vs. RSVP, food utilization percentage, cost savings from precision ordering, environmental impact avoided. This becomes the organizer's bragging document and your marketing material.

**9. Add a "Vendor Recommendation Engine":**
Based on event size, budget, and location, recommend verified caterers, decorators, and venues from your partner network. Commission-based vendor referrals become your primary revenue stream (5-10% per booking).

**10. Build a "Guest Experience Score" via Post-Event Survey:**
After the wedding, send guests a quick 3-question survey via WhatsApp: food rating, parking experience, overall satisfaction. This data helps organizers improve future events and gives the platform valuable NPS metrics.

**11. Target Corporate Events First (Easier B2B):**
Indian weddings are culturally complex and emotionally charged. Start with corporate events (annual parties, product launches) where decision-makers are data-driven and budgets are pre-approved. Use corporate event success stories to enter the wedding market.

---
