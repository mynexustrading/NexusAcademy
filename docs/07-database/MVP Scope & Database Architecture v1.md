# **Nexus Academy MVP Scope & Database Architecture v1**

### **Version 1.0 Draft**

### **Purpose: Development Specification for Anthony \+ Claude Code**

---

# **1\. MVP Objective**

The purpose of Nexus Academy v1.0 is NOT:

❌ Build Nexus OS

❌ Build a trading super app

❌ Build an AI trading platform

❌ Build a social community

❌ Build a signal service

---

The purpose is:

Launch the first version of the Nexus Trader Transformation System within 60-90 days.

---

# **2\. MVP Success Criteria**

After launch, we should be able to answer:

### **Learning**

* Which lessons are completed?  
* Which stages cause drop-off?  
* Which quizzes are failed most often?

---

### **Behaviour**

* Are students journaling?  
* Are students following risk rules?  
* Are students improving?

---

### **Transformation**

* Which students progressed?  
* Which identity level have they reached?  
* Which students require intervention?

---

# **3\. MVP Modules**

## **Module 1**

Authentication

---

Features:

* Register  
* Login  
* Logout  
* Password Reset

---

User Roles:

Student

Mentor

Admin

Super Admin

---

## **Module 2**

Academy Curriculum

---

Structure:

Course

Stage

Module

Lesson

---

Lesson Content:

* Video  
* PDF  
* Notes  
* Attachments

---

## **Module 3**

Quiz System

---

Quiz Types:

### **Lesson Quiz**

Optional

---

### **Module Quiz**

Required

---

### **Stage Quiz**

Required

---

Passing Score:

80%

---

## **Module 4**

Progression Engine

---

Tracks:

### **Identity Progress**

### **Capability Progress**

### **Stage Progress**

### **Quiz Progress**

### **Journal Progress**

---

Unlock Logic:

Current Stage Complete

↓

Next Stage Available

---

## **Module 5**

Journal System

(Core Layer)

---

Functions:

Create

Edit

Delete

Review

Search

Filter

---

Required for:

* Assessment  
* Certification  
* AI Review

---

## **Module 6**

AI Journal Review Assistant

---

Version 1:

Checks:

### **Missing Information**

### **Risk Compliance**

### **Reflection Quality**

### **Pattern Recognition**

---

No prediction.

No signals.

No market analysis.

---

## **Module 7**

Certificate System

---

Generate:

### **Foundation Certificate**

### **Structured Learner Certificate**

### **Disciplined Operator Certificate**

### **Institutional Thinker Certificate**

---

Verification Page:

Certificate ID

Status

Issue Date

---

## **Module 8**

Student Dashboard

---

Widgets:

### **Current Identity**

### **Current Stage**

### **Progress %**

### **Journal Health**

### **Next Milestone**

### **Recent Activity**

---

## **Module 9**

Admin Dashboard

---

User Management

Content Management

Quiz Management

Journal Oversight

Certificate Management

Analytics

---

# **4\. Navigation Architecture**

## **Student**

Dashboard

Academy

Journal

Certificates

Profile

---

## **Mentor**

Dashboard

Students

Journal Review

Reports

---

## **Admin**

Dashboard

Users

Academy

Quizzes

Certificates

Analytics

---

# **5\. Database Architecture**

---

## **Entity 1**

Users

id

name

email

password

role

identity\_level

created\_at

---

## **Entity 2**

Courses

id

title

description

---

## **Entity 3**

Stages

id

course\_id

title

order

---

## **Entity 4**

Modules

id

stage\_id

title

order

---

## **Entity 5**

Lessons

id

module\_id

title

video\_url

pdf\_url

---

## **Entity 6**

Quizzes

id

module\_id

stage\_id

pass\_score

---

## **Entity 7**

Questions

id

quiz\_id

question

---

## **Entity 8**

Answers

id

question\_id

answer

is\_correct

---

## **Entity 9**

Quiz Attempts

id

user\_id

quiz\_id

score

attempt\_date

---

## **Entity 10**

Journal Entries

id

user\_id

pair

direction

session

entry

sl

tp

risk\_percent

rr

emotion

reflection

created\_at

---

## **Entity 11**

AI Reviews

id

journal\_id

completeness\_score

risk\_score

reflection\_score

feedback

---

## **Entity 12**

Progress Records

id

user\_id

stage\_id

status

completion\_percentage

---

## **Entity 13**

Certificates

id

user\_id

certificate\_type

certificate\_id

issue\_date

---

# **6\. Future-Proof Database**

Reserve for future.

Do NOT build yet.

---

## **Future Entity**

Capability Scores

---

## **Future Entity**

Identity Scores

---

## **Future Entity**

Trade Statistics

---

## **Future Entity**

Nexus OS Integration

---

## **Future Entity**

Broker Integration

---

# **7\. MVP Development Priority**

## **Phase 1**

Foundation

Week 1-2

Authentication

Database

Roles

Admin

---

## **Phase 2**

Academy

Week 3-4

Curriculum

Lessons

Quiz

---

## **Phase 3**

Journal

Week 5

Journal

AI Review

---

## **Phase 4**

Progression

Week 6

Unlock Logic

Identity Tracking

Certificates

---

## **Phase 5**

Testing

Week 7-8

QA

Security

Deployment

---

# **8\. What Anthony Should NOT Build**

Absolutely avoid:

### **Social Feed**

### **Community Forum**

### **Copy Trading**

### **Broker API**

### **AI Mentor**

### **AI Copilot**

### **Signal Engine**

### **Economic Calendar**

### **World Monitor**

### **Nexus OS**

### **Mobile App**

### **Gamification**

### **Referral System**

---

# **9\. Build Readiness**

Current Status:

Product Architecture v1  
✅

Curriculum Validation Summary v1  
✅

Curriculum Architecture v2  
✅

Assessment Framework v1  
✅

Journal Architecture v1  
✅

MVP Scope & Database Architecture v1  
✅

---

# **Development Handoff Status**

At this point, Anthony and Claude Code have enough information to begin:

### **Database Design**

### **Backend API Design**

### **Frontend Layout**

### **Admin Dashboard**

### **Student Dashboard**

### **Journal System**

### **Progression Engine**

### **Certificate System**

without needing to redesign the product philosophy later.

---

