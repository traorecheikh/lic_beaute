export type FieldErrors = Record<string, string>;

export interface ValidationSuccess<T> {
  success: true;
  data: T;
}

export interface ValidationFailure {
  success: false;
  errors: FieldErrors;
  formError: string | null;
}

export type ValidationResult<T> = ValidationSuccess<T> | ValidationFailure;

// Accepts any Zod schema (v3 or v4) — safeParse is stable across both versions.
// Uses `any` because Zod v3 and v4 have structurally incompatible type shapes
// but safeParse works identically at runtime.
export function validateForm<T>(schema: any, data: unknown): ValidationResult<T> {
  const result: { success: boolean; data?: T; error?: { issues: Array<{ path: (string | number | symbol)[]; message: string }> } } = schema.safeParse(data);
  if (result.success && result.data !== undefined) {
    return { success: true, data: result.data };
  }

  const errors: FieldErrors = {};
  if (result.error) {
    for (const issue of result.error.issues) {
      const path = issue.path.length === 0 ? "_form" : issue.path.map(String).join(".");
      if (!errors[path]) {
        errors[path] = issue.message;
      }
    }
  }

  return { success: false, errors, formError: errors._form ?? null };
}
