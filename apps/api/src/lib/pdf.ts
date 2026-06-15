import { PDFDocument, StandardFonts, rgb, type PDFFont, type PDFPage } from "pdf-lib";

const PAGE = {
  width: 595.28,
  height: 841.89,
  marginX: 40,
  marginTop: 48,
  marginBottom: 52
};

const COLORS = {
  ink: rgb(0.16, 0.13, 0.11),
  muted: rgb(0.45, 0.39, 0.35),
  line: rgb(0.86, 0.82, 0.78),
  panel: rgb(0.98, 0.97, 0.95),
  header: rgb(0.95, 0.92, 0.88),
  accent: rgb(0.72, 0.52, 0.30),
  success: rgb(0.17, 0.44, 0.29)
};

type PdfContext = {
  doc: PDFDocument;
  page: PDFPage;
  font: PDFFont;
  fontBold: PDFFont;
  cursorY: number;
};

function normalizePdfText(text: string) {
  return text
    .replace(/[\u202f\u00a0]/g, " ")
    .replace(/[‘’]/g, "'")
    .replace(/[“”]/g, "\"")
    .replace(/[–—]/g, "-")
    .replace(/…/g, "...");
}

function widthOf(font: PDFFont, text: string, size: number) {
  return font.widthOfTextAtSize(normalizePdfText(text), size);
}

function wrapText(text: string, font: PDFFont, size: number, maxWidth: number) {
  const normalized = normalizePdfText(text).replace(/\s+/g, " ").trim();
  if (!normalized) return [""];

  const words = normalized.split(" ");
  const lines: string[] = [];
  let current = "";

  for (const word of words) {
    const candidate = current ? `${current} ${word}` : word;
    if (widthOf(font, candidate, size) <= maxWidth) {
      current = candidate;
      continue;
    }

    if (current) lines.push(current);
    current = word;
  }

  if (current) lines.push(current);
  return lines;
}

function drawTextBlock(
  ctx: PdfContext,
  text: string,
  options: {
    x?: number;
    size?: number;
    maxWidth?: number;
    lineHeight?: number;
    color?: ReturnType<typeof rgb>;
    bold?: boolean;
  } = {}
) {
  const x = options.x ?? PAGE.marginX;
  const size = options.size ?? 11;
  const font = options.bold ? ctx.fontBold : ctx.font;
  const maxWidth = options.maxWidth ?? PAGE.width - PAGE.marginX * 2;
  const lineHeight = options.lineHeight ?? size + 4;
  const lines = wrapText(text, font, size, maxWidth);

  for (const line of lines) {
    ctx.page.drawText(normalizePdfText(line), {
      x,
      y: ctx.cursorY,
      size,
      font,
      color: options.color ?? COLORS.ink
    });
    ctx.cursorY -= lineHeight;
  }
}

function drawLabelValue(
  ctx: PdfContext,
  label: string,
  value: string,
  options: { valueColor?: ReturnType<typeof rgb> } = {}
) {
  const size = 10;
  const labelWidth = widthOf(ctx.fontBold, label, size);
  const x = PAGE.marginX;
  ctx.page.drawText(normalizePdfText(label), { x, y: ctx.cursorY, size, font: ctx.fontBold, color: COLORS.muted });
  ctx.page.drawText(normalizePdfText(value), {
    x: x + labelWidth + 6,
    y: ctx.cursorY,
    size,
    font: ctx.font,
    color: options.valueColor ?? COLORS.ink
  });
  ctx.cursorY -= 16;
}

function drawSectionTitle(ctx: PdfContext, title: string) {
  ctx.page.drawText(normalizePdfText(title), {
    x: PAGE.marginX,
    y: ctx.cursorY,
    size: 12,
    font: ctx.fontBold,
    color: COLORS.ink
  });
  ctx.cursorY -= 18;
}

function drawHeader(ctx: PdfContext, title: string, subtitle: string, topRight: string[]) {
  const headerHeight = 104;
  const headerTop = PAGE.height - PAGE.marginTop;
  const headerBottom = headerTop - headerHeight;
  const width = PAGE.width - PAGE.marginX * 2;

  ctx.page.drawRectangle({
    x: PAGE.marginX,
    y: headerBottom,
    width,
    height: headerHeight,
    color: COLORS.header
  });

  ctx.page.drawRectangle({
    x: PAGE.marginX,
    y: headerBottom,
    width: 8,
    height: headerHeight,
    color: COLORS.accent
  });

  ctx.page.drawText("Beauté Avenue", {
    x: PAGE.marginX + 18,
    y: headerTop - 34,
    size: 22,
    font: ctx.fontBold,
    color: COLORS.ink
  });
  ctx.page.drawText(normalizePdfText(title), {
    x: PAGE.marginX + 18,
    y: headerTop - 56,
    size: 13,
    font: ctx.font,
    color: COLORS.muted
  });
  ctx.page.drawText(normalizePdfText(subtitle), {
    x: PAGE.marginX + 18,
    y: headerTop - 76,
    size: 10,
    font: ctx.font,
    color: COLORS.muted
  });

  let rightY = headerTop - 30;
  for (const line of topRight) {
    const textWidth = widthOf(ctx.font, line, 10);
    ctx.page.drawText(normalizePdfText(line), {
      x: PAGE.marginX + width - 18 - textWidth,
      y: rightY,
      size: 10,
      font: ctx.font,
      color: COLORS.ink
    });
    rightY -= 16;
  }

  ctx.cursorY = headerBottom - 30;
}

function drawInfoPanel(ctx: PdfContext, rows: Array<{ label: string; value: string; valueColor?: ReturnType<typeof rgb> }>) {
  const lineHeight = 16;
  const panelHeight = 22 + rows.length * lineHeight;
  const topY = ctx.cursorY;
  const bottomY = topY - panelHeight;

  ctx.page.drawRectangle({
    x: PAGE.marginX,
    y: bottomY,
    width: PAGE.width - PAGE.marginX * 2,
    height: panelHeight,
    color: COLORS.panel
  });

  ctx.cursorY = topY - 18;
  for (const row of rows) {
    drawLabelValue(ctx, row.label, row.value, { valueColor: row.valueColor });
  }
  ctx.cursorY = bottomY - 24;
}

function drawAmountTable(
  ctx: PdfContext,
  rows: Array<{ label: string; amount: string }>,
  totalLabel: string,
  totalAmount: string
) {
  const tableWidth = PAGE.width - PAGE.marginX * 2;
  const headerHeight = 24;
  const rowHeight = 28;
  const totalHeight = 32;
  const topY = ctx.cursorY;
  const headerBottom = topY - headerHeight;
  const rowsBottom = headerBottom - rows.length * rowHeight;
  const tableBottom = rowsBottom - totalHeight;

  ctx.page.drawRectangle({
    x: PAGE.marginX,
    y: headerBottom,
    width: tableWidth,
    height: headerHeight,
    color: COLORS.panel
  });

  ctx.page.drawLine({
    start: { x: PAGE.marginX, y: headerBottom },
    end: { x: PAGE.marginX + tableWidth, y: headerBottom },
    thickness: 1,
    color: COLORS.line
  });

  ctx.page.drawText("Libellé", {
    x: PAGE.marginX + 16,
    y: topY - 16,
    size: 10,
    font: ctx.fontBold,
    color: COLORS.muted
  });
  ctx.page.drawText("Montant", {
    x: PAGE.marginX + tableWidth - 74,
    y: topY - 16,
    size: 10,
    font: ctx.fontBold,
    color: COLORS.muted
  });

  rows.forEach((row, index) => {
    const rowTop = headerBottom - index * rowHeight;
    const rowY = rowTop - 18;
    const amountWidth = widthOf(ctx.fontBold, row.amount, 11);

    ctx.page.drawText(normalizePdfText(row.label), {
      x: PAGE.marginX + 16,
      y: rowY,
      size: 11,
      font: ctx.font,
      color: COLORS.ink
    });
    ctx.page.drawText(normalizePdfText(row.amount), {
      x: PAGE.marginX + tableWidth - 16 - amountWidth,
      y: rowY,
      size: 11,
      font: ctx.fontBold,
      color: COLORS.ink
    });

    ctx.page.drawLine({
      start: { x: PAGE.marginX, y: rowTop - rowHeight },
      end: { x: PAGE.marginX + tableWidth, y: rowTop - rowHeight },
      thickness: 1,
      color: COLORS.line
    });
  });

  const totalAmountWidth = widthOf(ctx.fontBold, totalAmount, 12);
  ctx.page.drawText(normalizePdfText(totalLabel), {
    x: PAGE.marginX + 16,
    y: rowsBottom - 20,
    size: 12,
    font: ctx.fontBold,
    color: COLORS.ink
  });
  ctx.page.drawText(normalizePdfText(totalAmount), {
    x: PAGE.marginX + tableWidth - 16 - totalAmountWidth,
    y: rowsBottom - 20,
    size: 12,
    font: ctx.fontBold,
    color: COLORS.ink
  });

  ctx.cursorY = tableBottom - 28;
}

function drawFooter(ctx: PdfContext, lines: string[]) {
  let footerY = PAGE.marginBottom;
  for (const line of lines.reverse()) {
    ctx.page.drawText(normalizePdfText(line), {
      x: PAGE.marginX,
      y: footerY,
      size: 9,
      font: ctx.font,
      color: COLORS.muted
    });
    footerY += 14;
  }
}

async function createPdf(): Promise<PdfContext> {
  const doc = await PDFDocument.create();
  const font = await doc.embedFont(StandardFonts.Helvetica);
  const fontBold = await doc.embedFont(StandardFonts.HelveticaBold);
  const page = doc.addPage([PAGE.width, PAGE.height]);
  return {
    doc,
    page,
    font,
    fontBold,
    cursorY: PAGE.height - PAGE.marginTop
  };
}

export async function buildBookingConfirmationPdf(input: {
  salonName: string;
  serviceName: string;
  clientName: string;
  startsAt: string;
  endsAt: string;
  depositAmountXof: number;
  totalAmountXof: number;
  bookingId: string;
  status: string;
}): Promise<Buffer> {
  const ctx = await createPdf();
  drawHeader(ctx, "Confirmation de réservation", "Document client", [
    `Référence ${input.bookingId.slice(0, 12)}`,
    `Statut ${input.status}`
  ]);

  drawInfoPanel(ctx, [
    { label: "Salon", value: input.salonName },
    { label: "Service", value: input.serviceName },
    { label: "Client", value: input.clientName },
    { label: "Début", value: input.startsAt },
    { label: "Fin", value: input.endsAt }
  ]);

  drawSectionTitle(ctx, "Montants");
  const rows = [
    { label: input.serviceName, amount: `${input.totalAmountXof.toLocaleString("fr-FR")} FCFA` }
  ];
  if (input.depositAmountXof > 0) {
    rows.push({ label: "Acompte déjà réglé", amount: `${input.depositAmountXof.toLocaleString("fr-FR")} FCFA` });
  }

  drawAmountTable(
    ctx,
    rows,
    input.depositAmountXof > 0 ? "Reste à régler" : "Total TTC",
    `${(input.depositAmountXof > 0 ? input.totalAmountXof - input.depositAmountXof : input.totalAmountXof).toLocaleString("fr-FR")} FCFA`
  );

  drawTextBlock(ctx, "Présentez ce document au salon si une confirmation vous est demandée.", {
    size: 10,
    color: COLORS.muted
  });
  drawFooter(ctx, [
    "Service client : support@beauteavenue.com | +221 33 800 12 34",
    "Merci pour votre confiance."
  ]);

  return Buffer.from(await ctx.doc.save());
}

export async function buildInvoicePdf(input: {
  invoiceNumber: string;
  issuedAt: string;
  status: string;
  amountLabel: string;
  billingProvider: string;
  salonName: string;
}): Promise<Buffer> {
  const ctx = await createPdf();
  drawHeader(ctx, "Facture d'abonnement", "Document de facturation", [
    `Facture ${input.invoiceNumber}`,
    `Émise le ${input.issuedAt}`,
    `Statut ${input.status}`
  ]);

  drawInfoPanel(ctx, [
    { label: "Salon", value: input.salonName },
    { label: "Mode de paiement", value: input.billingProvider },
    { label: "Montant", value: `${input.amountLabel} FCFA`, valueColor: COLORS.success }
  ]);

  drawSectionTitle(ctx, "Détail");
  drawAmountTable(ctx, [
    { label: "Abonnement mensuel Beauté Avenue", amount: `${input.amountLabel} FCFA` }
  ], "Total à payer", `${input.amountLabel} FCFA`);

  drawTextBlock(ctx, "Cette facture confirme votre abonnement et peut être conservée comme justificatif comptable.", {
    size: 10,
    color: COLORS.muted
  });
  drawFooter(ctx, [
    "Service client : support@beauteavenue.com | +221 33 800 12 34",
    "Merci pour votre confiance."
  ]);

  return Buffer.from(await ctx.doc.save());
}
