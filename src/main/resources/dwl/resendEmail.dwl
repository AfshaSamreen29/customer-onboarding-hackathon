%dw 2.0
output text/plain
var row = vars.custRow[0]
var verificationUrl = p('app.verifyBaseUrl') ++ "?token=" ++ vars.resend.token
---
"Dear " ++ row.first_name ++ ",\n\n" ++
"You asked for a new verification link for " ++ row.company_name ++ ".\n\n" ++
"Customer ID: " ++ row.customer_id ++ "\n\n" ++
"Please verify your email address using the link below. The link is valid\n" ++
"until " ++ vars.resend.expiresAtIso ++ ".\n\n" ++
verificationUrl ++ "\n\n" ++
"If you did not request this, please ignore this email or contact\n" ++
"our support desk.\n\n" ++
"Regards,\n" ++
"Customer Onboarding Team\n"