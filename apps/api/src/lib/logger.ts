function serializeError(err: unknown): Record<string, unknown> {
  if (err instanceof Error) {
    const record: Record<string, unknown> = {
      message: err.message,
      stack: err.stack ?? ""
    };
    // Include custom properties from Error subclasses (e.g. HttpAuthError.code)
    const errObj = err as unknown as Record<string, unknown>;
    for (const key of Object.keys(errObj)) {
      if (!(key in record)) {
        record[key] = errObj[key];
      }
    }
    return record;
  }
  if (typeof err === "string") return { message: err };
  return { message: String(err) };
}

export const logger = {
  info(message: string, context?: Record<string, unknown>) {
    console.info(JSON.stringify({ level: "info", message, ...context }));
  },
  warn(message: string, context?: Record<string, unknown>) {
    console.warn(JSON.stringify({ level: "warn", message, ...context }));
  },
  error(message: string, context?: Record<string, unknown>) {
    const serialized = context
      ? { ...context, error: context.error ? serializeError(context.error) : undefined }
      : {};
    console.error(JSON.stringify({ level: "error", message, ...serialized }));
  }
};
