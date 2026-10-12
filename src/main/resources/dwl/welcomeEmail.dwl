%dw 2.0
output text/plain
var verificationUrl = p('app.verifyBaseUrl') ++ "?token=" ++ vars.ids.token
---
"Dear " ++ payload.primaryContact.firstName ++ ",\n\n" ++
"Thank you for registering " ++ payload.company.companyName ++ ". Your account has\n" ++
"been created and is waiting for email verification.\n\n" ++
"Customer ID: " ++ vars.ids.customerId ++ "\n" ++
"Plan: " ++ payload.subscription.planCode ++ "\n" ++
"Seats: " ++ (payload.subscription.seats as String) ++ "\n" ++
"Region: " ++ payload.subscription.region ++ "\n\n" ++
"Please verify your email address using the link below. The link is valid\n" ++
"until " ++ vars.ids.expiresAtIso ++ ".\n\n" ++
verificationUrl ++ "\n\n" ++
"Once verified, your workspace will be provisioned automatically and you\n" ++
"will receive a second email confirming that it is ready to use.\n\n" ++
"If you did not request this account, please ignore this email or contact\n" ++
"our support desk.\n\n" ++
"Regards,\n" ++
"Customer Onboarding Team\n"