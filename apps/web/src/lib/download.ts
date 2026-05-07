export type CsvCell = string | number | boolean | null | undefined;

function escapeCsv(value: CsvCell) {
  if (value === null || value === undefined) {
    return "";
  }

  const text = String(value);
  if (/[",\n]/.test(text)) {
    return `"${text.replace(/"/g, '""')}"`;
  }

  return text;
}

export function toCsv(headers: string[], rows: CsvCell[][]) {
  const lines = [headers.map(escapeCsv).join(",")];
  for (const row of rows) {
    lines.push(row.map(escapeCsv).join(","));
  }
  return `${lines.join("\n")}\n`;
}

export function triggerDownload(filename: string, content: string, mimeType = "text/plain;charset=utf-8") {
  const blob = new Blob([content], { type: mimeType });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement("a");
  anchor.href = url;
  anchor.download = filename;
  anchor.rel = "noopener";
  document.body.appendChild(anchor);
  anchor.click();
  document.body.removeChild(anchor);
  URL.revokeObjectURL(url);
}

export function downloadCsv(filename: string, headers: string[], rows: CsvCell[][]) {
  const csv = toCsv(headers, rows);
  triggerDownload(filename, csv, "text/csv;charset=utf-8");
}

export function openPrintableReport(title: string, headers: string[], rows: CsvCell[][]) {
  const tableRows = rows
    .map((row) => `<tr>${row.map((cell) => `<td>${String(cell ?? "")}</td>`).join("")}</tr>`)
    .join("");

  const html = `<!doctype html>
<html lang="fr">
<head>
  <meta charset="utf-8" />
  <title>${title}</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 24px; color: #1f2937; }
    h1 { margin: 0 0 16px; font-size: 18px; }
    table { width: 100%; border-collapse: collapse; font-size: 12px; }
    th, td { border: 1px solid #d1d5db; padding: 8px; text-align: left; }
    th { background: #f3f4f6; }
  </style>
</head>
<body>
  <h1>${title}</h1>
  <table>
    <thead>
      <tr>${headers.map((header) => `<th>${header}</th>`).join("")}</tr>
    </thead>
    <tbody>
      ${tableRows}
    </tbody>
  </table>
</body>
</html>`;

  const win = window.open("", "_blank", "noopener,noreferrer");
  if (!win) {
    throw new Error("popup_blocked");
  }

  win.document.write(html);
  win.document.close();
  win.focus();
  win.print();
}
