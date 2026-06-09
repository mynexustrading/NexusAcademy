# **Nexus Academy Claude Code Master Build Specification v1**

## **Document Purpose**

This document serves as the single source of truth for building Nexus Academy v1.0.

All development decisions should follow this document.

If any future document conflicts with this specification:

Master Build Specification Wins

until officially revised.

---

# **1\. Product Definition**

Nexus Academy is:

A Trader Transformation System

Nexus Academy is NOT:

* LMS only  
* Video course website  
* Signal platform  
* Trading community  
* Trading dashboard

---

Primary Goal:

Transform traders

Not:

Deliver content

---

# **2\. MVP Goal**

Launch:

Nexus Academy v1.0

within:

60-90 days

---

Success Metrics:

### **Educational**

* Stage completion rate  
* Quiz pass rate  
* Journal completion rate

---

### **Behavioral**

* Risk discipline  
* Journal consistency

---

### **Product**

* Weekly active users  
* Student retention

---

# **3\. Product Architecture**

Identity Layer

↓

Capability Layer

↓

Curriculum Layer

↓

Execution Layer

↓

Verification Layer

---

# **4\. Identity System**

Identity is primary progression.

Levels:

Emotional Beginner

Reactive Trader

Structured Learner

Disciplined Operator

Institutional Thinker

Professional Ecosystem Contributor

---

Student dashboard should prioritize:

Current Identity

before:

Course Progress

---

# **5\. Curriculum Structure**

Course

└── Stage

    └── Module

        └── Lesson

---

Stages:

Stage 1  
Trading Foundations

Stage 2  
Risk & Psychology

Stage 3  
Technical Execution

Stage 4  
Liquidity

Stage 5  
SMC Framework

Stage 5.5  
Statistical Edge Validation

Stage 6  
Execution Systems

Stage 7  
Institutional Framework

Stage 8  
Hidden (Future)

---

# **6\. Assessment Architecture**

Every stage requires:

---

Knowledge

Quiz ≥ 80%

---

Application

Required Journal Entries

---

Behavior

Consistency Requirement

---

Only after all three:

Stage Complete

---

# **7\. Journal Architecture**

Journal is:

Core Data Layer

---

Every Journal contains:

### **Trade Information**

* Pair  
* Direction  
* Session

---

### **Trade Plan**

* Entry  
* SL  
* TP  
* Risk

---

### **Execution**

* Result  
* RR

---

### **Psychology**

* Confidence  
* Emotion

---

### **Reflection**

* What went well  
* What went wrong  
* Lessons learned  
* Improvement plan

---

# **8\. AI Journal Review Assistant**

MVP Scope:

### **Completeness Review**

### **Risk Compliance Review**

### **Reflection Quality Review**

### **Behavior Pattern Review**

---

Not Allowed:

❌ Signals

❌ Predictions

❌ Trade Entries

❌ Trade Exits

❌ Financial Advice

---

# **9\. Progression Engine**

Track:

Identity Progress

Stage Progress

Quiz Progress

Journal Progress

Capability Progress

---

Unlock Logic:

Current Stage Complete

↓

Unlock Next Stage

---

# **10\. Certificate System**

Certificate Types:

Foundation

Structured Learner

Disciplined Operator

Institutional Thinker

---

Certificate contains:

* Name  
* Certificate ID  
* Date  
* Identity Level  
* Verification URL

---

# **11\. Student Dashboard**

Sections:

---

Identity Card

Current Identity  
Progress

---

Current Mission

Current Stage  
Current Module

---

Next Action

Next Lesson  
Next Quiz  
Next Journal

---

Journal Health

Journal Count

Risk Discipline

Reflection Quality

---

Recent Activity

---

# **12\. Navigation**

Student:

Dashboard

Academy

Journal

Certificates

Profile

---

Admin:

Dashboard

Users

Curriculum

Quizzes

Journals

Certificates

---

# **13\. Database Entities**

Required:

Users

Courses

Stages

Modules

Lessons

Quizzes

Questions

Answers

QuizAttempts

JournalEntries

AIReviews

ProgressRecords

Certificates

---

Reserved:

CapabilityScores

IdentityScores

TradeStatistics

NexusOS

Do not build yet.

---

# **14\. Technical Rules**

Priority:

Simple

Maintainable

Scalable

---

Prefer:

Modular Architecture

---

Avoid:

Monolith Logic

---

Everything should be:

Future Nexus Platform Compatible

---

# **15\. Explicitly Out of Scope**

Do NOT build:

Nexus OS

Broker Integration

AI Mentor

AI Copilot

Community Forum

Social Feed

Trading Signals

Economic Calendar

Copy Trading

Gamification

Referral System

Mobile App

---

# **16\. Development Phases**

### **Phase 1**

Foundation

* Auth  
* Roles  
* Database

---

### **Phase 2**

Academy

* Courses  
* Lessons  
* Quiz

---

### **Phase 3**

Journal

* Journal System  
* AI Review

---

### **Phase 4**

Progression

* Unlock Logic  
* Certificates

---

### **Phase 5**

Testing & Launch

---

# **17\. Build Success Definition**

Nexus Academy v1.0 is successful if:

A new student can:

Register

↓

Learn

↓

Journal

↓

Receive AI Feedback

↓

Pass Assessment

↓

Progress

↓

Earn Certificate

without needing human intervention.

---

# **Final Build Principle**

Build the smallest system that can transform a trader.

Do not build the future.

Build the foundation that allows the future to exist.

---

