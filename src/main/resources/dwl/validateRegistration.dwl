%dw 2.0
output application/json

// PROPOSED DEFAULTS: the PDF gives only one example of each list. Edit as needed.
var supportedPlans = ["STARTER_MONTHLY", "STARTER_ANNUAL", "GROWTH_MONTHLY", "GROWTH_ANNUAL", "ENTERPRISE_ANNUAL"]
var supportedRegions = ["AP_SOUTH", "AP_NORTH", "US_EAST", "EU_WEST"]
var supportedCountries = ["India", "United States", "United Kingdom", "Germany", "Singapore", "Australia", "Canada", "United Arab Emirates"]

var emailPattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
var phonePattern = /^\+?[0-9][0-9 -]{6,18}$/
var currencyPattern = /^[A-Z]{3}$/
var timestampPattern = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:\d{2})$/

fun obj(v) = if (v is Object) v else {}
fun isBlank(v) = if (v is String) (trim(v) == "") else true
fun fits(v, pattern) = if (v is String) (v matches pattern) else false
fun problem(field, message) = { field: field, message: message }

var company = obj(payload.company)
var address = obj(company.address)
var contact = obj(payload.primaryContact)
var sub = obj(payload.subscription)
var consent = obj(payload.consent)
---
[
  if (isBlank(company.companyName)) problem("company.companyName", "Company name is required") else null,

  if (not (supportedCountries contains address.country)) problem("company.address.country", "Country is missing or not supported") else null,

  if (isBlank(contact.firstName)) problem("primaryContact.firstName", "First name is required") else null,
  if (isBlank(contact.lastName)) problem("primaryContact.lastName", "Last name is required") else null,

  if (isBlank(contact.email)) problem("primaryContact.email", "Email is required")
  else if (not fits(contact.email, emailPattern)) problem("primaryContact.email", "Email format is invalid")
  else null,

  if (contact.phone != null and not fits(contact.phone, phonePattern)) problem("primaryContact.phone", "Phone format is invalid") else null,

  if (isBlank(sub.planCode)) problem("subscription.planCode", "Plan code is required")
  else if (not (supportedPlans contains sub.planCode)) problem("subscription.planCode", "Plan code is not supported")
  else null,

  if (not (sub.seats is Number)) problem("subscription.seats", "Seats must be a number")
  else if (sub.seats < 1) problem("subscription.seats", "Seats must be at least 1")
  else null,

  if (not fits(sub.billingCurrency, currencyPattern)) problem("subscription.billingCurrency", "Billing currency must be a 3-letter code such as INR") else null,

  if (not (supportedRegions contains sub.region)) problem("subscription.region", "Region is missing or unknown") else null,

  if (consent.termsAccepted != true) problem("consent.termsAccepted", "Terms must be accepted") else null,

  if (consent.marketingOptIn != null and not (consent.marketingOptIn is Boolean)) problem("consent.marketingOptIn", "Marketing opt-in must be true or false") else null,

  if (not fits(consent.acceptedAt, timestampPattern)) problem("consent.acceptedAt", "Accepted-at must be an ISO timestamp") else null
] filter ($ != null)