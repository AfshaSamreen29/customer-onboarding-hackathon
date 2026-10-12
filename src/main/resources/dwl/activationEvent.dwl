%dw 2.0
output application/java
var row = vars.customerRow[0]
---
{
  correlationId: vars.correlationId,
  eventType: "ACCOUNT_ACTIVATED",
  eventTimestamp: now() as String {format: "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"},
  retryCount: 0,
  payload: {
    customerId: row.customer_id,
    tenantId: row.tenant_id,
    companyName: row.company_name,
    planCode: row.plan_code,
    seats: row.seats,
    region: row.region,
    primaryUserEmail: row.email
  }
}