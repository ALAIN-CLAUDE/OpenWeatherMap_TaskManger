# OpenWeatherMap_TaskManger
This repository holds implementation for integrating salesforce with OpenWeatherMap api and TaskManager LWCs
# Task Manager Lightning Web Component
![image](https://github.com/ALAIN-CLAUDE/OpenWeatherMap_TaskManger/assets/63712848/94ddc055-3724-4a55-ac58-22740c1d2f98)

https://github.com/ALAIN-CLAUDE/OpenWeatherMap_TaskManger/assets/63712848/8c14d09d-4f74-4b99-9f45-e67d398f1825



## Overview

The Task Manager Lightning Web Component is a Salesforce component designed to help users manage their tasks efficiently. It allows users to view, mark tasks as completed, and create new tasks directly from the Salesforce Home page. The component follows Salesforce Lightning Design System (SLDS) guidelines for a consistent and user-friendly experience.

## Features

- Displays a list of tasks assigned to the current user.
- Enables users to mark tasks as completed.
- Provides a button for creating new tasks with subject, due date, and priority specifications.
- Adheres to SLDS for a consistent look and feel.

## Installation

1. Deploy the Lightning Web Component to your Salesforce org.
    - Use Salesforce CLI or deploy through the Setup UI.
    - Example CLI command: `sfdx force:source:deploy -p force-app/main/default/lwc/TaskManager -u yourTargetOrgAlias`
    - Alternatively , you can use github desktop as on the image below to open the repo, right click on the package.xml file within manifest folder and  deploy into your org. NOTE: You must ensure you first deploy the custom objects separartely or create them in your org,  before deploying the rest of the types and their members.

    - ![image](https://github.com/ALAIN-CLAUDE/OpenWeatherMap_TaskManger/assets/63712848/667d1f33-ba79-46bb-b81c-202ca727fbe6)
    -  ![image](https://github.com/ALAIN-CLAUDE/OpenWeatherMap_TaskManger/assets/63712848/6e9ee886-2929-45b0-9274-da971dadaffb)


2. Add the "TaskManager" component to the Home page layout.
    - Navigate to Setup > Object Manager > Home Page.
    - Edit the Home page layout, drag and drop the "TaskManager" component.

3. Deploy Apex classes and triggers (if applicable).

## Usage

1. Navigate to the Salesforce Home page.
2. Locate the "Task Manager" component.
3. View, complete, and create tasks as needed.

## Technical Documentation

For detailed technical information, including code snippets and design choices, refer to the [Task Manager Technical Documentation.pdf](https://github.com/ALAIN-CLAUDE/OpenWeatherMap_TaskManger/files/14158515/Task.Manager.Technical.Documentation.pdf)

.

## Testing

1. Ensure the component is added to the Home page.
2. Open your Salesforce org and navigate to the Home page.
3. Interact with the "Task Manager" component.
4. Verify that tasks are displayed accurately.
5. Create a new task and confirm it reflects on the Home page.
6. Mark tasks as completed and check for updates.

---

# OpenWeatherMap Integration
![image](https://github.com/ALAIN-CLAUDE/OpenWeatherMap_TaskManger/assets/63712848/5b0ce13d-82a8-490a-be78-70eef7027884)


## Overview

The OpenWeatherMap Integration is a Salesforce solution that fetches real-time weather information for specified locations and associates it with Salesforce records. It includes Apex classes, triggers, and a Lightning Web Component to display weather data.

## Features

- Retrieves weather information using the OpenWeatherMap API.
- Associates weather data with Salesforce Location records.
- Includes a batch process and scheduler for periodic updates.

## Installation

1. Deploy the Apex classes, triggers, and Lightning Web Component to your Salesforce org.
    - Use Salesforce CLI or deploy through the Setup UI.
    - Example CLI command: `sfdx force:source:deploy -p force-app/main/default/classes -u yourTargetOrgAlias`

2. Configure named credentials and remote site settings for OpenWeatherMap API.
    - Navigate to Setup > Named Credentials to add credentials.
    - Add a remote site setting for OpenWeatherMap API.

3. Deploy and schedule the batch job (if applicable).

## Usage

1. Create or update Location records in Salesforce.
2. The weather information is automatically fetched and associated with the Location record.

## Technical Documentation

For detailed technical information, including code snippets, class details, and integration configurations, refer to the [OpenWeatherMap API Documentation.docx](https://github.com/ALAIN-CLAUDE/OpenWeatherMap_TaskManger/files/14158486/OpenWeatherMap.API.Documentation.docx)
.

## Testing

1. Ensure Location records exist with valid latitude and longitude.
2. Verify the WeatherInfo records are created or updated for these locations.
3. Optionally, run the batch process manually and observe results.
4. Check the scheduler settings and frequency for automated updates.
