# **Nexus Academy Progression Rules Specification v1**

## **Purpose**

Define exact engineering rules for stage completion, identity progression, certificate issuance, unlock logic, and journal-based behaviour verification.

This document does not redesign Nexus Academy.

It converts the existing architecture into build-ready progression logic.

---

## **1\. Core Principle**

Nexus Academy progression is not based on lesson completion alone.

A student progresses only when all three layers are satisfied:

1. Knowledge Verification  
2. Application Evidence  
3. Behaviour Verification

Formula:

Stage Complete \= Knowledge Pass \+ Application Pass \+ Behaviour Pass

If one layer fails, the stage remains incomplete.

---

## **2\. Progression Objects**

The system must track:

* Current Identity  
* Current Stage  
* Current Module  
* Lesson Completion  
* Quiz Completion  
* Journal Count  
* Journal Quality  
* Risk Discipline  
* Reflection Quality  
* Behaviour Flags  
* Certificate Eligibility

---

## **3\. Identity Path**

1. Emotional Beginner  
2. Reactive Trader  
3. Structured Learner  
4. Disciplined Operator  
5. Institutional Thinker  
6. Professional Ecosystem Contributor

MVP should support Identity 1–5.

Identity 6 is reserved for future Stage 8\.

---

## **4\. Stage Completion Rules**

### **Stage 1 — Trading Foundations & Market Survival**

Target Identity:

Emotional Beginner → Reactive Trader

Completion requires:

* All required lessons completed  
* Stage quiz score ≥ 80%  
* Minimum 10 demo journal entries  
* Journal completion rate ≥ 80%  
* No missing critical journal fields in final 3 entries

Certificate:

Foundation Certificate

Unlocks:

Stage 2

---

### **Stage 2 — Risk Management & Trader Psychology**

Target Identity:

Reactive Trader → Structured Learner

Completion requires:

* All required lessons completed  
* Stage quiz score ≥ 80%  
* Risk Plan submitted  
* Minimum 20 journal entries  
* Declared max risk rule recorded  
* No more than 2 risk violations in latest 10 journals  
* Reflection quality average ≥ 70

Certificate:

No certificate yet

Unlocks:

Stage 3

---

### **Stage 3 — Technical Execution Foundations**

Target Identity:

Structured Learner strengthened

Completion requires:

* All required lessons completed  
* Stage quiz score ≥ 80%  
* Minimum 20 structured trade plans  
* Minimum 20 journal entries  
* Trade plan field completed before execution in ≥ 80% of submitted journals  
* AI Review average completeness score ≥ 75

Certificate:

Structured Learner Certificate

Unlocks:

Stage 4

---

### **Stage 4 — Liquidity & Institutional Market Behavior**

Target Identity:

Structured Learner → Disciplined Operator

Completion requires:

* All required lessons completed  
* Stage quiz score ≥ 80%  
* Minimum 20 liquidity mapping journals  
* Liquidity concept fields completed in ≥ 80% of Stage 4 journals  
* Manual review optional, not required by default

Certificate:

No certificate yet

Unlocks:

Stage 5

---

### **Stage 5 — Smart Money Concepts Framework**

Target Identity:

Disciplined Operator strengthened

Completion requires:

* All required lessons completed  
* Stage quiz score ≥ 80%  
* Minimum 30 SMC-based journal entries  
* BOS / CHoCH / OB / FVG / BPR fields used correctly enough for review  
* Process compliance average ≥ 75  
* Risk discipline average ≥ 75

Certificate:

No certificate yet

Unlocks:

Stage 5.5

---

### **Stage 5.5 — Statistical Edge Validation**

Target Identity:

Disciplined Operator → Institutional Thinker preparation

Completion requires:

* All required lessons completed  
* Stage quiz score ≥ 80%  
* Minimum 50-trade dataset  
* Win rate calculated  
* Average RR calculated  
* Expectancy calculated  
* Drawdown reviewed  
* Performance Review submitted  
* Manual admin or mentor review required

Certificate:

Disciplined Operator Certificate

Unlocks:

Stage 6

---

### **Stage 6 — Execution Systems & Trade Management**

Target Identity:

Institutional Thinker preparation

Completion requires:

* All required lessons completed  
* Stage quiz score ≥ 80%  
* Minimum 50 journal entries  
* Workflow compliance ≥ 80%  
* Risk discipline average ≥ 80  
* Reflection quality average ≥ 75

Certificate:

No certificate yet

Unlocks:

Stage 7

---

### **Stage 7 — Institutional Trading Framework**

Target Identity:

Institutional Thinker

Completion requires:

* All required lessons completed  
* Stage quiz score ≥ 80%  
* Complete Trading Plan submitted  
* 100-trade review submitted  
* Personal Framework Submission completed  
* Manual admin or mentor review required

Certificate:

Institutional Thinker Certificate

Unlocks:

Future Stage 8 placeholder only

---

## **5\. Capital Protection Rules**

MVP must enforce capital protection messaging.

Stage 1–3:

Demo only

Stage 4–5:

Demo or micro account only

Stage 6+:

Controlled live capital allowed

Stage 7:

Performance review required before scaling discussion

The platform should display this clearly but does not need broker enforcement in MVP.

---

## **6\. Journal Quality Rules**

Each journal receives:

* Completeness Score  
* Risk Discipline Score  
* Reflection Quality Score  
* Process Compliance Score  
* Consistency Score

Minimum scoring logic:

Completeness Score checks:

* Pair  
* Direction  
* Session  
* Entry  
* SL  
* TP  
* Risk %  
* Result  
* Reflection fields

Risk Discipline Score checks:

* Risk % recorded  
* Risk % within declared max  
* SL exists  
* Trade has plan before execution

Reflection Quality Score checks:

* What went well  
* What went wrong  
* Lessons learned  
* Improvement plan  
* Actionable detail

Process Compliance Score checks:

* Setup type recorded  
* Market bias recorded  
* Plan followed  
* Entry/exit reviewed

Consistency Score checks:

* Recent journal frequency  
* Repeated risk violations  
* Repeated missing fields  
* Improving or declining behaviour trend

---

## **7\. Unlock Logic**

Default state:

Only Stage 1 is unlocked after onboarding.

Next stage unlocks only when:

* Current stage status \= completed  
* Required quiz passed  
* Required journal/application evidence completed  
* Behaviour requirements passed  
* Manual review approved, if required

Stage lock states:

* locked  
* available  
* in\_progress  
* pending\_review  
* completed

---

## **8\. Certificate Issuance Rules**

Certificates are identity-based, not stage-name based.

Certificate issuance requires:

* Related stage completion  
* Certificate eligibility check  
* Unique certificate ID generated  
* Verification URL generated  
* Issue date recorded  
* Certificate status \= active

Certificate types:

1. Foundation Certificate — after Stage 1  
2. Structured Learner Certificate — after Stage 3  
3. Disciplined Operator Certificate — after Stage 5.5  
4. Institutional Thinker Certificate — after Stage 7

---

## **9\. Manual Review Rules**

Manual review required only for:

* Stage 5.5  
* Stage 7

Reason:

These stages involve statistical validation, trading framework review, and higher-stakes certification.

All other stages can use:

* Lesson completion  
* Quiz result  
* Journal count  
* AI review scores  
* Behaviour rules

---

## **10\. Retention Protection Rules**

To avoid excessive friction:

* Do not block lesson viewing too aggressively.  
* Block certification and stage completion, not basic learning access.  
* Allow students to continue watching unlocked stage content while pending review.  
* Use warnings before hard locks.  
* Show clear next action on dashboard.  
* Avoid long unclear milestone cycles.

Dashboard should always answer:

“What do I need to do next?”

---

## **11\. AI Review Boundary**

AI Review may evaluate:

* Missing information  
* Risk compliance  
* Reflection quality  
* Behaviour patterns  
* Consistency trend

AI Review must not provide:

* Trade signals  
* Buy/sell instructions  
* Entry recommendations  
* Exit recommendations  
* Market predictions  
* Financial advice

---

## **12\. MVP Priority**

Build first:

* Stage 1–3 progression rules  
* Journal scoring  
* Quiz pass logic  
* Certificate issuance for Foundation and Structured Learner  
* Basic admin override  
* Manual review placeholder for Stage 5.5 and Stage 7

Stage 4–7 can exist structurally first.

Stage 8 hidden.

