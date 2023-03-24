## Moncierge - Tracking your budget, simplified. 

### Moncierge is a mobile application to manage the time-defined budgets for personal use, group or have supervised budgets. <br>

### 📌 Table of Contents
* [Summary](#summary)
* [Requirements](#requirements)
* [Tech Stack](#tech-stack)
* [Design and Architecture](#design-and-architecture)
* [Snippets](#snippets)
* [Future Scope](#future-scope)
* [References](#references)

<a id="summary"></a>
### 📝 Summary
- Moncierge helps users track their expenses and manage their budget effectively.
- Users can define different categories and set a budget for each category. The application provides notifications if there is a violation in the budget.
- The application can be used for personal savings goals or for shared responsibilities, such as a shared budget for a flat or an organization's inventory, a trip, for organizers of a college fest or for child's allowance monitoring etc.
- Users can assign a supervisor to monitor their spending habits.

<a id="requirements"></a>
### 📋 Requirements
- Create and login account
- Users can elect a mode - personal or shared
- Create a group (under shared mode)
- Within each mode:
    - Define a category
    - Set a budget per category and/or overall for a given period (if needed)
    - Notification when expense exceeds the budget
    - Add/assign a supervisor for a given budget
    - Users can add an expense under a defined a category
    - Reporting:
        - Monthly reporting for expenditures and savings - overall summary along with per category distribution
        - Custom reports - Users can select a date range and/or choose a category to get a statement of the expenses
    - Specific for shared budget:
        - Add/invite members to join the group.
        - (Optional) Assign per user budget in the group along with per category.

<a id="tech-stack"></a>
### 💻 Tech Stack

<img alt="Firebase" src="https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white"/><img alt="Flutter" src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white"/><img alt="Gradle" src="https://img.shields.io/badge/Gradle-02303A.svg?style=for-the-badge&logo=Gradle&logoColor=white"/><img alt="Dart" src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white"/>

<a id="design-and-architecture"></a>
### 📐 Design and Architecture
Describes the high level design 

#### Class Diagram
![class diagram](./images/class_diagram.jpg)

#### NoSQL Database Diagram
![database diagram](./images/NoSQL_database_design.png)

#### Workflow Diagram
![workflow](./images/workflow_diagram.jpeg)

#### Notification Workflow
![notifications](./images/notification_workflow.jpeg)

<a id="snippets"></a>
## 💡 Snippets
Some working snippets of the project (UI or API or command line)

<a id="future-scope"></a>
### 🚀 Future Scope

The following features can be added in revisions of this application:
- Budget modification - Users can request budget update to the supervisor
- Add payment gateway, which would allow users to make transactions and update expenses simultaneously.

<a id="references"></a>
### 📚 References

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter for Beginners](https://www.youtube.com/playlist?list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Mailer](https://pub.dev/documentation/mailer/latest/)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)
