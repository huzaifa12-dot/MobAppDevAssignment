# Flutter Multi-Screen Application Development

Student Name: Muhammad Salman 
Student ID: SE-221020  

Repository: `huzaifa12-dot/MobAppDevAssignment`  
Branch: `main`

## Overview

This branch contains Assignment 1: a complete multi-screen Flutter authentication application with registration, login, dashboard, and detail screens.

## Features

- Registration with name, email, gender, password, and confirm password.
- Real-time validation with disabled submit button until valid.
- Password rules: minimum 6 characters, at least 1 uppercase letter, and at least 1 special character.
- Reusable validator class separated from UI.
- Login with email validation, password show/hide toggle, remember me checkbox, and basic session persistence.
- Dashboard with user name, avatar placeholder, subject list, and detail navigation.
- Enums for gender and authentication state.
- Controller/service layer separation.

## Screenshots

![Login Screen](screenshots/login.svg)
![Registration Screen](screenshots/register.svg)
![Dashboard Screen](screenshots/dashboard.svg)

## Run Project

```bash
flutter pub get
flutter run
```
