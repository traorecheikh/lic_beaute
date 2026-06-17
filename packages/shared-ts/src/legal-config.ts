export interface LegalConfig {
  appName: string;
  operatorName: string;
  formeJuridique: string;
  numeroRccm: string;
  ninea: string;
  adresseSiege: string;
  emailJuridique: string;
  telephone: string;
  responsableLegal: string;
  referenceCdp: string;
  documentVersion: string;
  lastUpdate: string;
  currentScope: string;
}

export const legalConfig: LegalConfig = {
  appName: "Beauté Avenue",
  operatorName: "NumuConnect",
  formeJuridique: "SUARL", // Legal form type
  numeroRccm: "", // Hiding if empty/placeholder
  ninea: "", // Hiding if empty/placeholder
  adresseSiege: "Point E, Dakar, Sénégal", // Fallback registered address
  emailJuridique: "support@beauteavenue.sn", // Fallback support email
  telephone: "+221338671010", // Fallback support phone
  responsableLegal: "", // Omitted / unused
  referenceCdp: "", // Hiding if empty/placeholder
  documentVersion: "1.0",
  lastUpdate: "17 juin 2026",
  currentScope: "Sénégal",
};
