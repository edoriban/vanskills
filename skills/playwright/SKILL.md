---
name: playwright
description: >
  Playwright E2E testing patterns.
  Trigger: When writing Playwright E2E tests (Page Object Model, selectors, MCP exploration workflow).
license: MIT
metadata:
  author: vandev
  version: "1.0"
  scope: [root]
  auto_invoke: "Writing Playwright E2E tests"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## MCP Workflow (MANDATORY If Available)

**If you have Playwright MCP tools, ALWAYS use them BEFORE creating any test:**

1. **Navigate** to target page
2. **Take snapshot** to see page structure and elements
3. **Interact** with forms/elements to verify exact user flow
4. **Take screenshots** to document expected states
5. **Verify page transitions** through complete flow (loading, success, error)
6. **Document actual selectors** from snapshots (use real refs and labels)
7. **Only after exploring** create test code with verified selectors

**If MCP NOT available:** Proceed with test creation based on docs and code analysis.

## File Structure

```
tests/
├── base-page.ts              # Parent class for ALL pages
├── helpers.ts                # Shared utilities
└── {page-name}/
    ├── {page-name}-page.ts   # Page Object Model
    ├── {page-name}.spec.ts   # ALL tests here (NO separate files!)
    └── {page-name}.md        # Test documentation
```

## Selector Priority (REQUIRED)

```typescript
// 1. BEST - getByRole for interactive elements
this.submitButton = page.getByRole("button", { name: "Submit" });
this.navLink = page.getByRole("link", { name: "Dashboard" });

// 2. BEST - getByLabel for form controls
this.emailInput = page.getByLabel("Email");
this.passwordInput = page.getByLabel("Password");

// 3. SPARINGLY - getByText for static content only
this.errorMessage = page.getByText("Invalid credentials");
this.pageTitle = page.getByText("Welcome");

// 4. LAST RESORT - getByTestId when above fail
this.customWidget = page.getByTestId("date-picker");

// AVOID fragile selectors
this.button = page.locator(".btn-primary");  // NO
this.input = page.locator("#email");         // NO
```

## Page Object Pattern

```typescript
import { Page, Locator, expect } from "@playwright/test";

// BasePage - ALL pages extend this
export class BasePage {
  constructor(protected page: Page) {}

  async goto(path: string): Promise<void> {
    await this.page.goto(path);
    await this.page.waitForLoadState("networkidle");
  }

  async waitForNotification(): Promise<void> {
    await this.page.waitForSelector('[role="status"]');
  }

  async verifyNotificationMessage(message: string): Promise<void> {
    const notification = this.page.locator('[role="status"]');
    await expect(notification).toContainText(message);
  }
}

// Page-specific implementation
export interface LoginData {
  email: string;
  password: string;
}

export class LoginPage extends BasePage {
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;

  constructor(page: Page) {
    super(page);
    this.emailInput = page.getByLabel("Email");
    this.passwordInput = page.getByLabel("Password");
    this.submitButton = page.getByRole("button", { name: "Sign in" });
  }

  async goto(): Promise<void> {
    await super.goto("/login");
  }

  async login(data: LoginData): Promise<void> {
    await this.emailInput.fill(data.email);
    await this.passwordInput.fill(data.password);
    await this.submitButton.click();
  }

  async verifyCriticalOutcome(): Promise<void> {
    await expect(this.page).toHaveURL("/dashboard");
  }
}
```

## Test Pattern with Tags

```typescript
import { test, expect } from "@playwright/test";
import { LoginPage } from "./login-page";

test.describe("Login", () => {
  test("User can login successfully",
    { tag: ["@critical", "@e2e", "@login", "@LOGIN-E2E-001"] },
    async ({ page }) => {
      const loginPage = new LoginPage(page);

      await loginPage.goto();
      await loginPage.login({ email: "user@test.com", password: "pass123" });

      await expect(page).toHaveURL("/dashboard");
    }
  );
});
```

**Tag Categories:**
- Priority: `@critical`, `@high`, `@medium`, `@low`
- Type: `@e2e`
- Feature: `@signup`, `@signin`, `@dashboard`
- Test ID: `@SIGNUP-E2E-001`, `@LOGIN-E2E-002`

## Commands

```bash
npx playwright test                    # Run all
npx playwright test --grep "login"     # Filter by name
npx playwright test --ui               # Interactive UI
npx playwright test --debug            # Debug mode
npx playwright test tests/login/       # Run specific folder
```
