
# ToDo List App – Objective-C Workshop

A professional task management application built using **Objective-C** and **UIKit**. This app is designed for efficient task organization, local data persistence, and clear prioritization using a structured categorization system.

##  Features

### Core Functionality
* **Task Creation:** Add new tasks with a name, detailed description, and priority level.
* **Priority Visuals:** Features three priority levels (**High**, **Medium**, and **Low**), each represented by its own **unique image** for clear identification.
* **Task States:** Manage the lifecycle of a task through three stages:
    * **To-Do**: The initial state.
    * **In Progress**: Once started, a task cannot be reverted to "To-Do."
    * **Done**: Once finished, a task cannot be moved back to "In Progress."
* **Data Persistence:** All tasks are saved **locally**, ensuring your data is preserved every time you visit the app.

### Management & Organization
* **Segmented Control Navigation:** Effortlessly switch views between:
    * **All Notes**: A complete list of your tasks.
    * **Status Views**: Filter by To-Do, In Progress, or Done.
    * **Priority View**: Tasks are organized into **different sections** based on their priority level (High/Med/Low).
* **Search Interface:** Quick search by task name. If no results are found, a "pretty" empty state is displayed to inform the user.
* **Edit & Remove:** * Edit existing tasks with a mandatory **confirmation dialog** before changes are finalized.
    * Delete any task from the list at any time.

---

## Tech Stack

* **Language:** Objective-C
* **Framework:** UIKit
* **Data Persistence:** Core Data (or `NSUserDefaults` / `NSKeyedArchiver`)
* **Architecture:** MVC (Model-View-Controller)
* **UI Components:** `UITableView`, `UISegmentedControl`, `UISearchBar`, `UIAlertController`

---

## Demo

https://github.com/user-attachments/assets/6ba628c2-c1a4-48df-af43-52d4b3ad35ad

---

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/esraaehab333/ToDo-workshop-.git
   ```
2. **Open in Xcode(10):**
   Open the `ToDo-workshop-.xcodeproj` file.
3. **Run:**
   Build and run on your preferred iOS Simulator or physical device.

---

##  License
Developed individually as part of the professional mobile development track at ITI.
