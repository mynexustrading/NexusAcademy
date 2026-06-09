# **Nexus Academy Database Architecture v2**

## **Purpose**

Upgrade Database Architecture v1 so it supports:

* Journal as core evidence layer  
* Progression Rules v1  
* Stage completion logic  
* Identity progression  
* Certificate issuance  
* AI journal review  
* Admin/manual review  
* Future Nexus OS compatibility without building Nexus OS now

This document does not expand MVP scope.

---

## **1\. Database Design Principle**

Database v2 should not behave like a normal LMS database.

It must support:

* Learning  
* Evidence  
* Behaviour  
* Verification  
* Transformation

The Journal table must become a structured evidence layer, not a simple text log.

---

## **2\. Core Entity Groups**

Database v2 contains 9 groups:

1. User & Role  
2. Identity & Capability  
3. Curriculum  
4. Assessment  
5. Journal  
6. AI Review  
7. Progression  
8. Certification  
9. Admin Review & Audit

---

# **Group 1 — User & Role**

## **users**

Fields:

* id  
* name  
* email  
* password\_hash  
* role  
* current\_identity\_id  
* current\_stage\_id  
* onboarding\_completed  
* reality\_calibration\_accepted\_at  
* declared\_max\_risk\_percent  
* created\_at  
* updated\_at

Roles:

* student  
* mentor  
* admin  
* super\_admin

---

## **user\_profiles**

Fields:

* id  
* user\_id  
* experience\_level  
* primary\_market  
* current\_challenge  
* main\_goal  
* country  
* timezone  
* created\_at  
* updated\_at

---

# **Group 2 — Identity & Capability**

## **identities**

Fields:

* id  
* name  
* order\_index  
* description  
* is\_mvp\_active

Seed values:

1. Emotional Beginner  
2. Reactive Trader  
3. Structured Learner  
4. Disciplined Operator  
5. Institutional Thinker  
6. Professional Ecosystem Contributor

---

## **capabilities**

Fields:

* id  
* code  
* name  
* description

Seed values:

* C1 Market Understanding  
* C2 Risk Management  
* C3 Execution  
* C4 Psychology  
* C5 Workflow  
* C6 Statistical Thinking  
* C7 Professionalism

---

## **stage\_capabilities**

Fields:

* id  
* stage\_id  
* capability\_id  
* weight

Purpose:

Map each stage to capability focus.

---

# **Group 3 — Curriculum**

## **courses**

Fields:

* id  
* title  
* description  
* status  
* created\_at  
* updated\_at

---

## **stages**

Fields:

* id  
* course\_id  
* title  
* order\_index  
* target\_identity\_from\_id  
* target\_identity\_to\_id  
* is\_hidden  
* is\_mvp\_active  
* unlock\_type  
* created\_at  
* updated\_at

Notes:

Stage 8 should be stored but hidden.

---

## **modules**

Fields:

* id  
* stage\_id  
* title  
* order\_index  
* description  
* created\_at  
* updated\_at

---

## **lessons**

Fields:

* id  
* module\_id  
* title  
* order\_index  
* video\_url  
* pdf\_url  
* notes  
* lesson\_type  
* is\_required  
* created\_at  
* updated\_at

---

## **lesson\_completions**

Fields:

* id  
* user\_id  
* lesson\_id  
* completed\_at

Unique:

* user\_id \+ lesson\_id

---

# **Group 4 — Assessment**

## **quizzes**

Fields:

* id  
* stage\_id  
* module\_id  
* lesson\_id  
* quiz\_type  
* title  
* pass\_score  
* is\_required  
* created\_at  
* updated\_at

Quiz types:

* lesson  
* module  
* stage

---

## **questions**

Fields:

* id  
* quiz\_id  
* question\_text  
* question\_type  
* order\_index

---

## **answers**

Fields:

* id  
* question\_id  
* answer\_text  
* is\_correct  
* order\_index

---

## **quiz\_attempts**

Fields:

* id  
* user\_id  
* quiz\_id  
* score  
* passed  
* attempt\_number  
* submitted\_at

---

# **Group 5 — Journal**

## **journal\_entries**

Fields:

* id  
* user\_id  
* stage\_id  
* journal\_type  
* pair  
* direction  
* trade\_date  
* session  
* setup\_type  
* market\_bias  
* market\_condition  
* planned\_entry  
* planned\_sl  
* planned\_tp  
* actual\_entry  
* actual\_exit  
* risk\_percent  
* rr\_planned  
* rr\_achieved  
* result  
* confidence\_before  
* emotion\_before  
* emotion\_during  
* emotion\_after  
* followed\_plan  
* risk\_rule\_followed  
* what\_went\_well  
* what\_went\_wrong  
* lessons\_learned  
* improvement\_plan  
* chart\_screenshot\_url  
* status  
* submitted\_at  
* created\_at  
* updated\_at

Journal types:

* learning  
* execution  
* performance

Status:

* draft  
* submitted  
* reviewed  
* flagged

---

## **journal\_tags**

Fields:

* id  
* name  
* category

Examples:

* Liquidity Sweep  
* Order Block  
* FVG  
* BPR  
* Revenge Trade  
* FOMO  
* Overrisk  
* No SL  
* Good Discipline

---

## **journal\_entry\_tags**

Fields:

* id  
* journal\_entry\_id  
* journal\_tag\_id

---

## **risk\_plans**

Fields:

* id  
* user\_id  
* stage\_id  
* max\_risk\_percent  
* max\_daily\_loss\_percent  
* max\_weekly\_loss\_percent  
* rules\_text  
* submitted\_at  
* approved\_at  
* approved\_by

---

## **trade\_datasets**

Fields:

* id  
* user\_id  
* stage\_id  
* dataset\_name  
* trade\_count  
* win\_rate  
* average\_rr  
* expectancy  
* max\_drawdown  
* review\_text  
* submitted\_at  
* reviewed\_at  
* status

Used mainly for Stage 5.5 and Stage 7\.

---

# **Group 6 — AI Review**

## **ai\_reviews**

Fields:

* id  
* journal\_entry\_id  
* user\_id  
* completeness\_score  
* risk\_discipline\_score  
* reflection\_quality\_score  
* process\_compliance\_score  
* consistency\_score  
* overall\_score  
* feedback\_summary  
* missing\_fields\_json  
* risk\_flags\_json  
* reflection\_feedback  
* behaviour\_pattern\_feedback  
* prohibited\_advice\_detected  
* model\_version  
* created\_at

Important:

AI review must never store trading signals, entries, exits, or predictions.

---

## **ai\_review\_flags**

Fields:

* id  
* ai\_review\_id  
* flag\_type  
* severity  
* message  
* created\_at

Flag types:

* missing\_data  
* risk\_violation  
* weak\_reflection  
* repeated\_pattern  
* behaviour\_decline

Severity:

* low  
* medium  
* high

---

# **Group 7 — Progression**

## **progression\_rules**

Fields:

* id  
* stage\_id  
* required\_quiz\_score  
* required\_journal\_count  
* required\_trade\_plan\_count  
* required\_dataset\_trade\_count  
* min\_completeness\_score  
* min\_risk\_score  
* min\_reflection\_score  
* min\_process\_score  
* max\_recent\_risk\_violations  
* requires\_risk\_plan  
* requires\_manual\_review  
* certificate\_type\_id  
* unlocks\_stage\_id  
* created\_at  
* updated\_at

Purpose:

Make progression configurable instead of hard-coded.

---

## **stage\_progress**

Fields:

* id  
* user\_id  
* stage\_id  
* status  
* lesson\_completion\_percent  
* quiz\_passed  
* journal\_requirement\_met  
* behaviour\_requirement\_met  
* manual\_review\_status  
* completion\_percentage  
* started\_at  
* completed\_at  
* updated\_at

Status:

* locked  
* available  
* in\_progress  
* pending\_review  
* completed

---

## **identity\_progress**

Fields:

* id  
* user\_id  
* identity\_id  
* status  
* achieved\_at  
* source\_stage\_id

Status:

* current  
* achieved  
* future

---

## **capability\_scores**

Build now as simple version.

Fields:

* id  
* user\_id  
* capability\_id  
* stage\_id  
* score  
* source  
* calculated\_at

Source:

* quiz  
* journal  
* manual\_review  
* system

---

## **progression\_events**

Fields:

* id  
* user\_id  
* event\_type  
* stage\_id  
* identity\_id  
* certificate\_id  
* message  
* created\_at

Event examples:

* stage\_started  
* stage\_completed  
* identity\_achieved  
* certificate\_issued  
* review\_required  
* stage\_unlocked

---

# **Group 8 — Certification**

## **certificate\_types**

Fields:

* id  
* name  
* identity\_id  
* description  
* order\_index  
* is\_mvp\_active

Seed values:

* Foundation Certificate  
* Structured Learner Certificate  
* Disciplined Operator Certificate  
* Institutional Thinker Certificate  
* Professional Ecosystem Contributor Certificate

---

## **certificates**

Fields:

* id  
* user\_id  
* certificate\_type\_id  
* certificate\_uid  
* identity\_id  
* issued\_stage\_id  
* status  
* issue\_date  
* verification\_url  
* revoked\_at  
* revoked\_reason  
* created\_at

Status:

* active  
* revoked  
* expired

---

# **Group 9 — Admin Review & Audit**

## **manual\_reviews**

Fields:

* id  
* user\_id  
* stage\_id  
* reviewer\_id  
* review\_type  
* status  
* score  
* feedback  
* reviewed\_at  
* created\_at

Review types:

* stage\_5\_5\_dataset\_review  
* stage\_7\_framework\_review  
* admin\_override

Status:

* pending  
* approved  
* rejected  
* revision\_required

---

## **admin\_overrides**

Fields:

* id  
* user\_id  
* admin\_id  
* target\_type  
* target\_id  
* action  
* reason  
* created\_at

Purpose:

Allow controlled admin correction without silent database edits.

---

## **activity\_logs**

Fields:

* id  
* user\_id  
* actor\_id  
* action  
* entity\_type  
* entity\_id  
* metadata\_json  
* created\_at

Purpose:

Track important system actions.

---

# **3\. MVP Seed Progression Rules**

## **Stage 1**

* required\_quiz\_score: 80  
* required\_journal\_count: 10  
* min\_completeness\_score: 70  
* max\_recent\_risk\_violations: 2  
* requires\_risk\_plan: false  
* requires\_manual\_review: false  
* certificate: Foundation Certificate

## **Stage 2**

* required\_quiz\_score: 80  
* required\_journal\_count: 20  
* min\_reflection\_score: 70  
* max\_recent\_risk\_violations: 2  
* requires\_risk\_plan: true  
* requires\_manual\_review: false  
* certificate: none

## **Stage 3**

* required\_quiz\_score: 80  
* required\_journal\_count: 20  
* required\_trade\_plan\_count: 20  
* min\_completeness\_score: 75  
* requires\_manual\_review: false  
* certificate: Structured Learner Certificate

## **Stage 4**

* required\_quiz\_score: 80  
* required\_journal\_count: 20  
* min\_process\_score: 70  
* requires\_manual\_review: false  
* certificate: none

## **Stage 5**

* required\_quiz\_score: 80  
* required\_journal\_count: 30  
* min\_risk\_score: 75  
* min\_process\_score: 75  
* requires\_manual\_review: false  
* certificate: none

## **Stage 5.5**

* required\_quiz\_score: 80  
* required\_dataset\_trade\_count: 50  
* requires\_manual\_review: true  
* certificate: Disciplined Operator Certificate

## **Stage 6**

* required\_quiz\_score: 80  
* required\_journal\_count: 50  
* min\_risk\_score: 80  
* min\_reflection\_score: 75  
* min\_process\_score: 80  
* requires\_manual\_review: false  
* certificate: none

## **Stage 7**

* required\_quiz\_score: 80  
* required\_dataset\_trade\_count: 100  
* requires\_manual\_review: true  
* certificate: Institutional Thinker Certificate

---

# **4\. Do Not Build Yet**

Do not build these as active systems:

* Broker Integration  
* Nexus OS Integration  
* AI Mentor  
* AI Copilot  
* Community System  
* Trading Signals  
* Economic Calendar  
* World Monitor  
* Social Feed  
* Referral System  
* Mobile App

Database may reserve compatibility, but product must not expose these features in MVP.

---

# **5\. Development Priority**

Priority 1:

* users  
* profiles  
* identities  
* courses  
* stages  
* modules  
* lessons  
* lesson\_completions

Priority 2:

* quizzes  
* questions  
* answers  
* quiz\_attempts

Priority 3:

* journal\_entries  
* ai\_reviews  
* ai\_review\_flags  
* risk\_plans

Priority 4:

* progression\_rules  
* stage\_progress  
* identity\_progress  
* progression\_events

Priority 5:

* certificate\_types  
* certificates  
* manual\_reviews  
* admin\_overrides  
* activity\_logs

---

# **6\. Final Database Statement**

Database v2 exists to make Nexus Academy measurable.

Lessons measure learning.

Quizzes measure knowledge.

Journals measure evidence.

AI reviews measure behaviour.

Progression rules measure readiness.

Certificates represent verified transformation.

