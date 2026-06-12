/** Shared HTML email template for Beauté Avenue. */
export function buildEmailHtml(input: {
  preheader?: string;
  greeting: string;
  bodyLines: string[];
  cta?: { url: string; label: string };
  expiryNote?: string;
  usageNote?: string;
  ignoreNote?: boolean;
  footerNote?: string;
}): string {
  // bodyLines are pre-rendered safe HTML (supports <strong>, <br>, etc.)
  const lines = input.bodyLines.map((l) => `<tr><td style="padding:0 0 8px 0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;font-size:15px;line-height:1.6;color:#3c2e2a;mso-line-height-rule:exactly">${l}</td></tr>`).join("");

  const ctaBlock = input.cta
    ? `<tr><td style="padding:16px 0 8px 0">
        <a href="${escapeAttr(input.cta.url)}" target="_blank" style="display:inline-block;padding:14px 32px;border-radius:99px;background:#c47a5e;color:#fff;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;font-size:15px;font-weight:600;text-decoration:none;mso-hide:all">${escapeHtml(input.cta.label)}</a>
       </td></tr>
       <tr><td style="padding:0 0 12px 0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;font-size:12px;color:#a09088">Ou copiez ce lien dans votre navigateur :<br><span style="font-size:11px;word-break:break-all;color:#c47a5e">${escapeHtml(input.cta.url)}</span></td></tr>`
    : "";

  const notes: string[] = [];
  if (input.expiryNote) notes.push(input.expiryNote);
  if (input.usageNote) notes.push(input.usageNote);

  const notesBlock = notes.length > 0
    ? `<tr><td style="padding:8px 0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;font-size:12px;color:#a09088;line-height:1.5">${notes.map((n) => `<p style="margin:2px 0">${escapeHtml(n)}</p>`).join("")}</td></tr>`
    : "";

  const ignoreBlock = input.ignoreNote !== false
    ? `<tr><td style="padding:12px 0 0 0;border-top:1px solid #e8e0dc;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;font-size:12px;color:#a09088;line-height:1.5">
        <p style="margin:0">Vous ne connaissez pas ce salon ou n'êtes pas à l'origine de cette demande ?<br>Ignorez cet email. Aucune action ne sera effectuée sans votre confirmation.</p>
       </td></tr>`
    : "";

  const footerBlock = input.footerNote
    ? `<tr><td style="padding:8px 0 0 0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;font-size:12px;color:#a09088">${escapeHtml(input.footerNote)}</td></tr>`
    : "";

  return `<!DOCTYPE html>
<html lang="fr">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">${input.preheader ? `<meta name="x-apple-disable-message-reformatting"><meta name="color-scheme" content="light"><style>body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;margin:0;padding:0;background:#f7f4f2;color:#3c2e2a}:root{color-scheme:light;supported-color-schemes:light}</style>` : ""}</head>
<body style="margin:0;padding:0;background:#f7f4f2">
  ${input.preheader ? `<!--[if !mso]><!-- --><div style="display:none;font-size:1px;color:#f7f4f2;line-height:1px;max-height:0;max-width:0;opacity:0;overflow:hidden;mso-hide:all">${escapeHtml(input.preheader)}</div><!--<![endif]-->` : ""}
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f7f4f2;min-width:100%">
    <tr><td align="center" style="padding:32px 16px">
      <table role="presentation" width="560" cellpadding="0" cellspacing="0" style="max-width:560px;width:100%">
        <!-- Logo -->
        <tr><td align="center" style="padding:0 0 24px 0">
          <img src="https://beauteavenue.sn/logo.png" alt="Beauté Avenue" width="160" height="auto" style="display:block;border:0;outline:none">
        </td></tr>
        <!-- Card -->
        <tr><td style="background:#fff;border-radius:16px;padding:40px 32px;box-shadow:0 1px 3px rgba(0,0,0,0.06)">
          <table role="presentation" width="100%" cellpadding="0" cellspacing="0">
            <!-- Greeting -->
            <tr><td style="padding:0 0 16px 0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;font-size:17px;font-weight:600;color:#3c2e2a">${escapeHtml(input.greeting)}</td></tr>
            <!-- Body -->
            ${lines}
            <!-- CTA -->
            ${ctaBlock}
            <!-- Notes -->
            ${notesBlock}
            <!-- Ignore notice -->
            ${ignoreBlock}
            <!-- Footer note -->
            ${footerBlock}
          </table>
        </td></tr>
        <!-- Footer -->
        <tr><td align="center" style="padding:24px 16px 0 16px;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;font-size:11px;color:#a09088;line-height:1.5">
          Beauté Avenue · Dakar, Sénégal<br>
          <a href="https://beauteavenue.sn" style="color:#c47a5e;text-decoration:none">beauteavenue.sn</a>
        </td></tr>
      </table>
    </td></tr>
  </table>
</body>
</html>`;
}

export function escapeHtml(s: string): string {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
}

function escapeAttr(s: string): string {
  return s.replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/'/g, "&#039;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}
