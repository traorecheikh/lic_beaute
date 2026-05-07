import { z } from "zod";

export const pushTokenRegisterSchema = z.object({
  token: z.string().min(1).max(512),
  platform: z.enum(["ios", "android"]),
  deviceId: z.string().min(1).max(256)
});

export type PushTokenRegisterInput = z.infer<typeof pushTokenRegisterSchema>;
