function escapePdfText(value: string) {
  return value.replace(/\\/g, "\\\\").replace(/\(/g, "\\(").replace(/\)/g, "\\)");
}

function buildPdf(content: string): Buffer {
  const objects = [
    "1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj\n",
    "2 0 obj << /Type /Pages /Kids [3 0 R] /Count 1 >> endobj\n",
    "3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 4 0 R /F2 5 0 R >> >> /Contents 6 0 R >> endobj\n",
    "4 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> endobj\n",
    "5 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >> endobj\n",
    `6 0 obj << /Length ${Buffer.byteLength(content, "utf8")} >> stream\n${content}\nendstream\nendobj\n`
  ];

  let pdf = "%PDF-1.4\n";
  const offsets = [0];
  for (const object of objects) {
    offsets.push(Buffer.byteLength(pdf, "utf8"));
    pdf += object;
  }

  const xrefStart = Buffer.byteLength(pdf, "utf8");
  const xref = [
    `xref\n0 ${objects.length + 1}`,
    "0000000000 65535 f ",
    ...offsets.slice(1).map((offset) => `${String(offset).padStart(10, "0")} 00000 n `)
  ].join("\n");

  const trailer = [
    "trailer",
    `<< /Size ${objects.length + 1} /Root 1 0 R >>`,
    "startxref",
    String(xrefStart),
    "%%EOF"
  ].join("\n");

  return Buffer.from(`${pdf}${xref}\n${trailer}\n`, "utf8");
}

export function buildBookingConfirmationPdf(input: {
  salonName: string;
  serviceName: string;
  clientName: string;
  startsAt: string;
  endsAt: string;
  depositAmountXof: number;
  totalAmountXof: number;
  bookingId: string;
  status: string;
}): Buffer {
  const content = [
    // Header background bar
    "0.95 0.89 0.84 rg",
    "40 770 515 48 re",
    "f",
    // Brand
    "BT",
    "/F2 20 Tf",
    "52 795 Td",
    "(Beaut\\351 Avenue) Tj",
    "ET",
    "BT",
    "/F1 10 Tf",
    "52 781 Td",
    "(Confirmation de r\\351servation) Tj",
    "ET",
    // Booking metadata
    "BT",
    "/F1 10 Tf",
    "370 796 Td",
    `(${escapePdfText(`R\\351servation N° ${input.bookingId.slice(0, 12)}`)}) Tj`,
    "ET",
    "BT",
    "/F1 10 Tf",
    "370 782 Td",
    `(${escapePdfText(`Statut: ${input.status}`)}) Tj`,
    "ET",
    // Salon section
    "BT",
    "/F2 12 Tf",
    "52 736 Td",
    "(D\\351tails de la r\\351servation) Tj",
    "ET",
    "BT",
    "/F1 10 Tf",
    "52 720 Td",
    `(${escapePdfText(`Salon: ${input.salonName}`)}) Tj`,
    "ET",
    "BT",
    "/F1 10 Tf",
    "52 706 Td",
    `(${escapePdfText(`Service: ${input.serviceName}`)}) Tj`,
    "ET",
    "BT",
    "/F1 10 Tf",
    "52 692 Td",
    `(${escapePdfText(`Client: ${input.clientName}`)}) Tj`,
    "ET",
    // Date section
    "BT",
    "/F2 12 Tf",
    "52 662 Td",
    "(Horaires) Tj",
    "ET",
    "BT",
    "/F1 10 Tf",
    "52 646 Td",
    `(${escapePdfText(`D\\351but: ${input.startsAt}`)}) Tj`,
    "ET",
    "BT",
    "/F1 10 Tf",
    "52 632 Td",
    `(${escapePdfText(`Fin: ${input.endsAt}`)}) Tj`,
    "ET",
    // Table header
    "0.93 0.92 0.90 rg",
    "40 598 515 26 re",
    "f",
    "BT",
    "/F2 10 Tf",
    "56 606 Td",
    "(Libell\\351) Tj",
    "ET",
    "BT",
    "/F2 10 Tf",
    "485 606 Td",
    "(Montant) Tj",
    "ET",
    // Grid lines
    "0.82 0.80 0.76 RG",
    "1 w",
    "40 598 m 555 598 l S",
    "40 572 m 555 572 l S",
    // Line items
    "BT",
    "/F1 11 Tf",
    "56 580 Td",
    `(${escapePdfText(input.serviceName)}) Tj`,
    "ET",
    "BT",
    "/F1 11 Tf",
    "485 580 Td",
    `(${escapePdfText(`${input.totalAmountXof.toLocaleString("fr-FR")} FCFA`)}) Tj`,
    "ET",
    // Deposit line
    input.depositAmountXof > 0 ? [
      "BT",
      "/F1 11 Tf",
      "56 554 Td",
      "(Acompte vers\\351) Tj",
      "ET",
      "BT",
      "/F1 11 Tf",
      "485 554 Td",
      `(${escapePdfText(`${input.depositAmountXof.toLocaleString("fr-FR")} FCFA`)}) Tj`,
      "ET",
      "BT",
      "/F2 12 Tf",
      "56 528 Td",
      "(Reste \\340 payer) Tj",
      "ET",
      "BT",
      "/F2 12 Tf",
      "450 528 Td",
      `(${escapePdfText(`${(input.totalAmountXof - input.depositAmountXof).toLocaleString("fr-FR")} FCFA`)}) Tj`,
      "ET"
    ].join("\n") : [
      "BT",
      "/F2 12 Tf",
      "56 554 Td",
      "(Total TTC) Tj",
      "ET",
      "BT",
      "/F2 12 Tf",
      "450 554 Td",
      `(${escapePdfText(`${input.totalAmountXof.toLocaleString("fr-FR")} FCFA`)}) Tj`,
      "ET"
    ].join("\n"),
    // Footer
    "BT",
    "/F1 9 Tf",
    "52 100 Td",
    "(Merci pour votre confiance. Ce document sert de justificatif.) Tj",
    "ET",
    "BT",
    "/F1 9 Tf",
    "52 86 Td",
    "(support@beauteavenue.com  |  +221 33 800 12 34) Tj",
    "ET"
  ].join("\n");

  return buildPdf(content);
}

export function buildInvoicePdf(input: {
  invoiceNumber: string;
  issuedAt: string;
  status: string;
  amountLabel: string;
  billingProvider: string;
  salonName: string;
}): Buffer {
  const rows = [
    { label: "Abonnement mensuel", amount: input.amountLabel }
  ];
  const lineItems = rows
    .map((row, index) => ({
      y: 642 - index * 26,
      ...row
    }))
    .map((row) => [
      "BT",
      `/F1 11 Tf`,
      `56 ${row.y} Td`,
      `(${escapePdfText(row.label)}) Tj`,
      "ET",
      "BT",
      `/F1 11 Tf`,
      `485 ${row.y} Td`,
      `(${escapePdfText(row.amount)} FCFA) Tj`,
      "ET"
    ].join("\n"))
    .join("\n");

  const content = [
    // Header background bar
    "0.95 0.93 0.89 rg",
    "40 770 515 48 re",
    "f",
    // Brand
    "BT",
    "/F2 20 Tf",
    "52 795 Td",
    "(Beaut\\351 Avenue) Tj",
    "ET",
    "BT",
    "/F1 10 Tf",
    "52 781 Td",
    "(Facture d\\'abonnement) Tj",
    "ET",
    // Invoice metadata
    "BT",
    "/F1 10 Tf",
    "370 796 Td",
    `(${escapePdfText(`N° ${input.invoiceNumber}`)}) Tj`,
    "ET",
    "BT",
    "/F1 10 Tf",
    "370 782 Td",
    `(${escapePdfText(`Date ${input.issuedAt}`)}) Tj`,
    "ET",
    "BT",
    "/F1 10 Tf",
    "370 768 Td",
    `(${escapePdfText(`Statut ${input.status}`)}) Tj`,
    "ET",
    // Billing section label
    "BT",
    "/F2 12 Tf",
    "52 736 Td",
    "(D\\351tails de facturation) Tj",
    "ET",
    // Detail text
    "BT",
    "/F1 10 Tf",
    "52 720 Td",
    `(${escapePdfText(`Salon: ${input.salonName}`)}) Tj`,
    "ET",
    "BT",
    "/F1 10 Tf",
    "52 706 Td",
    `(${escapePdfText(`Mode de r\\350glement: ${input.billingProvider}`)}) Tj`,
    "ET",
    // Table header
    "0.93 0.92 0.90 rg",
    "40 668 515 26 re",
    "f",
    "BT",
    "/F2 10 Tf",
    "56 676 Td",
    "(Libell\\351) Tj",
    "ET",
    "BT",
    "/F2 10 Tf",
    "485 676 Td",
    "(Montant) Tj",
    "ET",
    // Row grid lines
    "0.82 0.80 0.76 RG",
    "1 w",
    "40 668 m 555 668 l S",
    "40 638 m 555 638 l S",
    "40 612 m 555 612 l S",
    // Line items
    lineItems,
    // Total
    "BT",
    "/F2 12 Tf",
    "56 586 Td",
    "(Total TTC) Tj",
    "ET",
    "BT",
    "/F2 12 Tf",
    `450 586 Td`,
    `(${escapePdfText(`${input.amountLabel} FCFA`)}) Tj`,
    "ET",
    // Footer
    "BT",
    "/F1 9 Tf",
    "52 100 Td",
    "(Merci pour votre confiance.) Tj",
    "ET",
    "BT",
    "/F1 9 Tf",
    "52 86 Td",
    "(support@beauteavenue.com  |  +221 33 800 12 34) Tj",
    "ET"
  ].join("\n");

  return buildPdf(content);
}
