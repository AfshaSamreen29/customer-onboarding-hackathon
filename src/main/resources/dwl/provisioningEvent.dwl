%dw 2.0
output application/java

// PROPOSED DEFAULTS: only GROWTH_ANNUAL is given in the PDF. Edit the others as needed.
var entitlementMap = {
  STARTER_MONTHLY: ["DASHBOARDS"],
  STARTER_ANNUAL: ["DASHBOARDS"],
  GROWTH_MONTHLY: ["DASHBOARDS", "API_ACCESS"],
  GROWTH_ANNUAL: ["DASHBOARDS", "API_ACCESS", "SSO", "AUDIT_LOG"],
  ENTERPRISE_ANNUAL: ["DASHBOARDS", "API_ACCESS", "SSO", "AUDIT_LOG", "PRIORITY_SUPPORT"]
}
// PROPOSED DEFAULTS: region to data residency
var residencyMap = { AP_SOUTH: "IN", AP_NORTH: "IN", US_EAST: "US", EU_WEST: "EU" }
---
{
  correlationId: vars.correlationId,
  eventType: "ACCOUNT_SETUP_REQUESTED",
  eventTimestamp: now() as String {format: "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"},
  retryCount: 0,
  payload: {
    customerId: vars.ids.customerId,
    tenantId: vars.ids.tenantId,
    companyName: payload.company.companyName,
    planCode: payload.subscription.planCode,
    seats: payload.subscription.seats,
    region: payload.subscription.region,
    entitlements: entitlementMap[payload.subscription.planCode] default [],
    primaryUserEmail: lower(payload.primaryContact.email),
    dataResidency: residencyMap[payload.subscription.region] default "IN"
  }
}