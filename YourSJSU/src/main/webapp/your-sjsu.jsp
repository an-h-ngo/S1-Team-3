<%@ page import="java.sql.*"%>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Sign In — YourSJSU</title>
  <style>
    *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

    :root {
      --bg: #ffffff;
      --bg2: #f5f5f4;
      --text: #0f0f0f;
      --muted: #6b7280;
      --hint: #9ca3af;
      --border: rgba(0,0,0,0.1);
      --border2: rgba(0,0,0,0.18);
      --accent: #2563eb;
      --accent-hover: #1d4ed8;
      --radius-md: 8px;
      --radius-lg: 12px;
      --font: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }

    body {
      font-family: var(--font);
      background: var(--bg2);
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 1rem;
    }

    .login-card {
      background: var(--bg);
      border: 0.5px solid var(--border2);
      border-radius: var(--radius-lg);
      width: 100%;
      max-width: 420px;
      overflow: hidden;
    }

    /* ── Header ── */
    .card-header { padding: 28px 32px 0; }

    .logo-row {
      display: flex;
      align-items: center;
      gap: 9px;
      margin-bottom: 22px;
    }

    .logo-box {
      width: 32px;
      height: 32px;
      background: var(--accent);
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .logo-name { font-size: 15px; font-weight: 500; color: var(--text); }

    .card-title  { font-size: 22px; font-weight: 500; color: var(--text); margin-bottom: 4px; }
    .card-sub    { font-size: 14px; color: var(--muted); }

    /* ── Body ── */
    .card-body { padding: 24px 32px 32px; }

    /* Table-based form fields */
    .form-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 16px;
    }

    .form-table tr + tr td { padding-top: 14px; }
    .form-table td { padding: 0; vertical-align: top; }

    .field-label {
      display: block;
      font-size: 13px;
      font-weight: 500;
      color: var(--muted);
      margin-bottom: 6px;
    }

    .field-input {
      width: 100%;
      height: 38px;
      padding: 0 12px;
      font-size: 14px;
      color: var(--text);
      background: var(--bg);
      border: 0.5px solid var(--border2);
      border-radius: var(--radius-md);
      outline: none;
      font-family: var(--font);
      transition: border-color 0.15s, box-shadow 0.15s;
    }

    .field-input:focus {
      border-color: var(--accent);
      box-shadow: 0 0 0 3px rgba(37,99,235,0.12);
    }

    .field-input::placeholder { color: var(--hint); }

    .pw-wrap { position: relative; }
    .pw-wrap .field-input { padding-right: 40px; }

    .pw-toggle {
      position: absolute;
      right: 10px;
      top: 50%;
      transform: translateY(-50%);
      background: none;
      border: none;
      padding: 4px;
      cursor: pointer;
      color: var(--hint);
      display: flex;
      align-items: center;
      line-height: 1;
    }

    .pw-toggle:hover { color: var(--muted); }

    /* Table-based options row */
    .options-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }

    .options-table td { padding: 0; }

    .check-label {
      display: flex;
      align-items: center;
      gap: 7px;
      font-size: 13px;
      color: var(--muted);
      cursor: pointer;
      user-select: none;
    }

    .check-label input[type=checkbox] {
      width: 15px;
      height: 15px;
      accent-color: var(--accent);
      cursor: pointer;
      margin: 0;
    }

    .forgot-link {
      font-size: 13px;
      color: var(--accent);
      text-decoration: none;
      display: block;
      text-align: right;
    }

    .forgot-link:hover { text-decoration: underline; }

    /* Buttons */
    .btn-signin {
      width: 100%;
      height: 40px;
      background: var(--accent);
      color: #fff;
      border: none;
      border-radius: var(--radius-md);
      font-size: 14px;
      font-weight: 500;
      font-family: var(--font);
      cursor: pointer;
      transition: background 0.15s, transform 0.1s;
      margin-bottom: 20px;
    }

    .btn-signin:hover  { background: var(--accent-hover); }
    .btn-signin:active { transform: scale(0.99); }

    /* Divider */
    .divider {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 20px;
    }

    .divider-line  { flex: 1; height: 0.5px; background: var(--border); }
    .divider-text  { font-size: 12px; color: var(--hint); }

    /* SSO button */
    .btn-sso {
      width: 100%;
      height: 40px;
      background: var(--bg);
      color: var(--text);
      border: 0.5px solid var(--border2);
      border-radius: var(--radius-md);
      font-size: 14px;
      font-family: var(--font);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      transition: background 0.15s;
      margin-bottom: 0;
    }

    .btn-sso:hover { background: var(--bg2); }

    /* Footer */
    .card-footer {
      border-top: 0.5px solid var(--border);
      padding: 16px 32px;
      text-align: center;
      font-size: 13px;
      color: var(--muted);
      background: var(--bg2);
    }

    .register-link { color: var(--accent); text-decoration: none; font-weight: 500; }
    .register-link:hover { text-decoration: underline; }
  </style>
</head>
<body>

<div class="login-card">

  <div class="card-header">
    <div class="logo-row">
      <div class="logo-box">
        <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
          <path d="M9 2L15.5 6V12L9 16L2.5 12V6L9 2Z" stroke="#fff" stroke-width="1.4" stroke-linejoin="round" fill="none"/>
          <circle cx="9" cy="9" r="2.2" fill="#fff"/>
        </svg>
      </div>
      <span class="logo-name"></span>
    </div>
    <h1 class="card-title">Sign in</h1>
    <p class="card-sub">Enter your credentials to continue</p>
  </div>

  <div class="card-body">

    <!-- Form fields as a table -->
    <table class="form-table">
      <tbody>
        <tr>
          <td>
            <label class="field-label" for="email">Email address</label>
            <input class="field-input" type="email" id="email" name="email" placeholder="you@company.com" />
          </td>
        </tr>
        <tr>
          <td>
            <label class="field-label" for="password">Password</label>
            <div class="pw-wrap">
              <input class="field-input" type="password" id="password" name="password" placeholder="••••••••" />
              <button class="pw-toggle" type="button" onclick="togglePw(this)" tabindex="-1" aria-label="Toggle password">
                <svg id="eye-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                  <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                  <circle cx="12" cy="12" r="3"/>
                </svg>
              </button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Remember me + Forgot password as a table -->
    <table class="options-table">
      <tbody>
        <tr>
          <td>
            <label class="check-label">
              <input type="checkbox" name="remember" /> Remember me
            </label>
          </td>
          <td style="text-align:right;">
            <a href="#" class="forgot-link">Forgot password?</a>
          </td>
        </tr>
      </tbody>
    </table>

    <button class="btn-signin" type="button">Sign in</button>

    <div class="divider">
      <div class="divider-line"></div>
      <span class="divider-text">or</span>
      <div class="divider-line"></div>
    </div>

    <button class="btn-sso" type="button">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
      </svg>
      Continue with SSO
    </button>

  </div>

  <div class="card-footer">
    Don't have an account? <a href="#" class="register-link">Create one</a>
  </div>

</div>

</body>
</html>