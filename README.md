# HealthMate — BMI & Health Calculator

> **A modern, responsive Flutter Web health companion with interactive calculators, visual scales, hydration tracking, and automated CI/CD deployment to GitHub Pages.**

[![Deploy HealthMate to GitHub Pages](https://github.com/ganeshguptha777-code/BMI/actions/workflows/deploy.yml/badge.svg)](https://github.com/ganeshguptha777-code/BMI/actions/workflows/deploy.yml)

---

## 🌟 Application Overview

**HealthMate** is a 100% client-side, privacy-first Flutter web application designed with Material 3 principles. It provides essential wellness estimation tools that run entirely in the browser with zero backend, database, or API dependencies.

### Key Features
1. **Interactive BMI Calculator**:
   - Gender selection cards with visual icons.
   - Age input validation.
   - Dual-unit height toggle (`cm` and `ft / in`).
   - Dual-unit weight toggle (`kg` and `lb`).
   - Standard clinical BMI formula: $\text{BMI} = \frac{\text{weight (kg)}}{(\text{height (m)})^2}$.
   - Results screen featuring a **4-color visual BMI scale**, category badges (Underweight, Normal, Overweight, Obese), ideal weight range for your height, and actionable lifestyle guidance.
2. **Daily Water Intake Calculator & Tracker**:
   - Calculates personalized daily hydration targets based on body weight, workout intensity, and climate.
   - Interactive glass-by-glass tracker (`+250 ml` / `-250 ml`) with an animated progress ring.
3. **Daily Calorie Needs (BMR & TDEE)**:
   - Uses the clinical **Mifflin-St Jeor** metabolic equation.
   - Supports 5 activity levels and goal targets (Maintain, Mild Loss, Moderate Loss, Muscle Gain).
   - Recommends balanced macronutrient splits (Protein 30%, Carbs 40%, Healthy Fats 30%).
4. **Ideal Body Weight Calculator**:
   - Side-by-side comparison of **Devine**, **Robinson**, and **WHO Healthy BMI (18.5 – 24.9)** ranges.
   - Live differential against your current weight.
5. **Health Insights & Tips**:
   - Curated evidence-based tips across **Hydration**, **Nutrition**, **Exercise**, **Sleep**, and **Mental Wellness**.
   - Interactive category filter chips and detail bottom-sheet modal.
6. **Profile & Settings**:
   - Metric vs. Imperial system toggle.
   - Light Mode & Dark Mode switch.
   - Data privacy confirmation: 100% offline and client-side.

---

## 🚀 Live Demo & Deployment URL

Once GitHub Actions finishes building, your web application will be live at:

```
https://ganeshguptha777-code.github.io/BMI/
```

*(Note: If you deploy to a repository named `<USERNAME>.github.io`, the base path will automatically be `https://<USERNAME>.github.io/` without the repository suffix.)*

---

## ⚙️ How to Upload & Deploy to GitHub (Zero SDKs Required)

You do **NOT** need Flutter, Dart, or Android Studio installed on your computer. GitHub Actions cloud runners handle the entire build and deployment process automatically.

### Option A: Using Git CLI (Recommended)

If you have Git installed, push this repository directly to your GitHub repo:

```bash
# 1. Add all project files
git add .

# 2. Commit the changes
git commit -m "Initial commit: Complete HealthMate Flutter Web frontend and CI/CD workflow"

# 3. Ensure the branch is named main
git branch -M main

# 4. Push to your GitHub repository
git push -u origin main
```

*(If prompted for credentials, use your GitHub username and a Personal Access Token with `repo` permissions).*

---

## 🔧 One-Time GitHub Pages Setup

To allow GitHub Actions to publish your site:

1. In your GitHub repository, click **Settings** (tab at the top).
2. On the left sidebar under *Code and automation*, click **Pages**.
3. Under **Build and deployment > Source**, change the dropdown from *Deploy from a branch* to:
   👉 **GitHub Actions**
4. That's it! GitHub Actions will now automatically run the workflow whenever you push to `main`.

---

## 🤖 CI/CD Workflow (`.github/workflows/deploy.yml`)

The repository includes a modern GitHub Actions workflow:
- **Triggers**: On every push to `main` and manually via `workflow_dispatch`.
- **Environment**: `ubuntu-latest`.
- **Steps**:
  1. Checks out repository source code via `actions/checkout@v4`.
  2. Sets up Flutter stable channel via `subosito/flutter-action@v2` with dependency caching.
  3. Executes `flutter pub get`.
  4. Runs `flutter analyze --no-fatal-warnings`.
  5. Computes the dynamic `--base-href` based on the repository name (`/BMI/` or `/` for root pages) and builds the production web app (`flutter build web --release`).
  6. Packages and uploads `build/web` as an artifact using `actions/upload-pages-artifact@v3`.
  7. Deploys directly to GitHub Pages via `actions/deploy-pages@v4`.

---
live link:https://ganeshguptha777-code.github.io/BMI/

## 🩺 Health & Wellness Disclaimer

HealthMate estimations (Body Mass Index, daily calorie goals, water intake, and ideal body weights) are intended strictly for educational, fitness, and lifestyle wellness purposes. They are based on population-level statistical formulas (such as Mifflin-St Jeor, Devine, and standard WHO BMI reference ranges) and do not substitute for personalized medical diagnosis, prescription, or clinical consultation.
