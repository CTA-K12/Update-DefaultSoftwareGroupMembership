<#
	.SYNOPSIS
		A brief description of the Update-DefaultSoftwareGroupMembership.ps1 file.
	
	.DESCRIPTION
		A description of the file.
	
	.NOTES
		===========================================================================
		Created on:   	4/14/2017 10:56 AM
		Created by:   	Eden Nelson
		Organization: 	Cascade Technology Alliance
		Filename:
		===========================================================================
	
	.PARAMETER groupIdentity
		A description of the groupIdentity parameter.
	
	.PARAMETER targetOU
		A description of the targetOU parameter.
	
	.PARAMETER isTrialRun
		A description of the isTrialRun parameter.
	
	.PARAMETER searchScope
		A description of the searchScope parameter.
#>
[CmdletBinding()]
param ()

Set-StrictMode -version 2
Import-Module ActiveDirectory

$groupIdentity = "Default Software"
$rootDN = [ADSI]"LDAP://RootDSE"; $rootDN = $rootDN.rootDomainNamingContext; [string]$rootDN = $rootDN

$membersToDelete = New-Object "System.Collections.Generic.LinkedList[string]"
$membersToAdd = New-Object "System.Collections.Generic.LinkedList[string]"
$targetMembers = New-Object "System.Collections.Generic.LinkedList[string]"

if (-Not (Get-ADGroup -Filter {
			SamAccountName -eq $groupIdentity
		}))
{
	New-ADGroup -GroupScope Global -GroupCategory Security -Description 'Add this group to a software groups that should be installed all workstations' -Name 'Default Software' -DisplayName 'Default Software' -Path "OU=Software Distribution,$rootDN"
}
else
{
	Set-ADGroup -Identity $groupIdentity -GroupScope Global -GroupCategory Security -Description 'Add this group to a software groups that should be installed all workstations' -DisplayName 'Default Software'
}

$group = Get-ADGroup -Identity $groupIdentity

foreach ($member in (Get-ADComputer -Filter {
			OperatingSystem -Like "*Pro" -or OperatingSystem -like "*Professional" -or OperatingSystem -like "*Enterprise" -or OperatingSystem -like "*Education" -or OperatingSystem -like "*Edu" -and OperatingSystem -notlike "*server*"
		} -SearchBase $rootDN))
{
	$targetMembers.Add($member)
}

foreach ($member in $targetMembers)
{
		$membersToAdd.Add($member)
}

foreach ($member in $membersToAdd)
{
	Add-ADGroupMember -Identity $groupIdentity -Members $member
}


# SIG # Begin signature block
# MIIYPQYJKoZIhvcNAQcCoIIYLjCCGCoCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDhzQPRgGIulG9V
# /bxC1Q6flwFOrQ7xXk3ncEX/q6QJH6CCEuwwggPQMIICuKADAgECAhBWDzlgMpdv
# skWlu9PmVks2MA0GCSqGSIb3DQEBCwUAMFoxEzARBgoJkiaJk/IsZAEZFgNvcmcx
# GzAZBgoJkiaJk/IsZAEZFgtjYXNjYWRldGVjaDEVMBMGCgmSJomT8ixkARkWBWlu
# dHJhMQ8wDQYDVQQDEwZDVEEtQ0EwHhcNMTUwODE4MjIwMDI3WhcNMzUwODE4MjIy
# MDMwWjBaMRMwEQYKCZImiZPyLGQBGRYDb3JnMRswGQYKCZImiZPyLGQBGRYLY2Fz
# Y2FkZXRlY2gxFTATBgoJkiaJk/IsZAEZFgVpbnRyYTEPMA0GA1UEAxMGQ1RBLUNB
# MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnwUnO1/doXUEwlU3eS8B
# koKLxPCNr54RnKXIS9abNqrUn+EzeDpOxsmjomYaErLsQGrSeO/k93kCLtBVhTx2
# OaeSt3klYk88PVS2jHmTkowwvkxl/Nk/L7941lgeBE5YNmugSjGjvcVRvzC5Hd2n
# GaNj1SLWwDw3rwDmifBY0rcs140RE7T3Ms4pquIejfzk4CYf9M3cEKEVLDwgnN7L
# yJVVd1Wj4M472nwdU9XHjMqLTAds0258iGqFooWa8cdNRGP1F57bLn4wSK9wJXfb
# ydpgnXWkFsjb8uEiagjxBkXaR6M9uldrGaDN0o0XpP4xMBLeQcNMuhEH0EB4Joto
# cwIDAQABo4GRMIGOMBMGCSsGAQQBgjcUAgQGHgQAQwBBMA4GA1UdDwEB/wQEAwIB
# hjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBRFtRVw0jTNG1WszSXHh+qWu8Il
# nzASBgkrBgEEAYI3FQEEBQIDAgADMCMGCSsGAQQBgjcVAgQWBBSnN6gbSu96Heb+
# 2FbsX4B6hpdPijANBgkqhkiG9w0BAQsFAAOCAQEAC4FQJ3s5HFFiLD1z8XV63o6J
# wx0NWWDeOwcw7EbXmp72bm0QQLoFGpQsM5GTLdiu+HtGxrtUj6uQNKWgpWUp+Koy
# PEy9JoCEencFaPIyrG9iYTc1UXgwz719RVZ0h1/QloSGFXzgNxGNXkLGw1FsBmzg
# +DnwSUEKHt7yICi7LOKHju6qauhHg9T2sNNShB0yZaoMvRekXPXMWw4k+ccDdgcW
# MOF9VkdAvBFXx5BVoE6GuUZRYRVcQMH2rc0eGddfvZ3ZpVmK4DdBssNU47CmNix2
# mCaDzLc6mGuzMtKYnkzsh3+G2hj3kOQ+2x0D9eoBzyPhE+rmFw2eIDTCML2N+TCC
# BBUwggL9oAMCAQICCwQAAAAAATGJxlAEMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNV
# BAsTF0dsb2JhbFNpZ24gUm9vdCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWdu
# MRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTExMDgwMjEwMDAwMFoXDTI5MDMyOTEw
# MDAwMFowWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2Ex
# MTAvBgNVBAMTKEdsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gU0hBMjU2IC0g
# RzIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCqm47DqxFRJQG2lpTi
# T9jBCPZGI9lFxZWXW6sav9JsV8kzBh+gD8Y8flNIer+dh56v7sOMR+FC7OPjoUps
# DBfEpsG5zVvxHkSJjv4L3iFYE+5NyMVnCxyys/E0dpGiywdtN8WgRyYCFaSQkal5
# ntfrV50rfCLYFNfxBx54IjZrd3mvr/l/jk7htQgx/ertS3FijCPxAzmPRHm2dgNX
# nq0vCEbc0oy89I50zshoaVF2EYsPXSRbGVQ9JsxAjYInG1kgfVn2k4CO+Co4/Wug
# QGUfV3bMW44ETyyo24RQE0/G3Iu5+N1pTIjrnHswJvx6WLtZvBRykoFXt3bJ2IAK
# gG4JAgMBAAGjgegwgeUwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8C
# AQAwHQYDVR0OBBYEFJIhp0qVXWSwm7Qe5gA3R+adQStMMEcGA1UdIARAMD4wPAYE
# VR0gADA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9y
# ZXBvc2l0b3J5LzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3JsLmdsb2JhbHNp
# Z24ubmV0L3Jvb3QtcjMuY3JsMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i
# 3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQAEVoJKfNDOyb82ZtG+NZ6TbJfoBs4xGFn5
# bEFfgC7AQiW4GMf81LE3xGigzyhqA3RLY5eFd2E71y/j9b0zopJ9ER+eimzvLLD0
# Yo02c9EWNvG8Xuy0gJh4/NJ2eejhIZTgH8Si4apn27Occ+VAIs85ztvmd5Wnu7LL
# 9hmGnZ/I1JgFsnFvTnWu8T1kajteTkamKl0IkvGj8x10v2INI4xcKjiV0sDVzc+I
# 2h8otbqBaWQqtaai1XOv3EbbBK6R127FmLrUR8RWdIBHeFiMvu8r/exsv9GU979Q
# 4HvgkP0gGHgYIl0ILowcoJfzHZl9o52R0wZETgRuehwg4zbwtlC5MIIExjCCA66g
# AwIBAgIMJFS4fx4UU603+qF4MA0GCSqGSIb3DQEBCwUAMFsxCzAJBgNVBAYTAkJF
# MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWdu
# IFRpbWVzdGFtcGluZyBDQSAtIFNIQTI1NiAtIEcyMB4XDTE4MDIxOTAwMDAwMFoX
# DTI5MDMxODEwMDAwMFowOzE5MDcGA1UEAwwwR2xvYmFsU2lnbiBUU0EgZm9yIE1T
# IEF1dGhlbnRpY29kZSBhZHZhbmNlZCAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOC
# AQ8AMIIBCgKCAQEA2XhhoZauEv+j/yf2RGB7alYtZ+NfnzGSKkjt+QWEDm1OIlbK
# 2JmXjmnKn3sPCMgqK2jRKGErn+Qm7rq497DsXmob4li1tL0dCe3N6D3UZv++IiJt
# NibPEXiX6VUAKMPpN069GeUXhEiyHCGt7HPS86in6V/oNc6FE6cim6yC6f7xX8QS
# WrH3DEDm0qDgTWjQ7QwMEB2PBV9kVfm7KEcGDNgGPzfDJjYljHsPJ4hcODGlAfZe
# ZN6DwBRc4OfSXsyN6iOAGSqzYi5gx6pn1rNA7lJ/Vgzv2QXXlSBdhRVAz16RlVGe
# RhoXkb7BwAd1skv3NrrFVGxfihv7DShhyInwFQIDAQABo4IBqDCCAaQwDgYDVR0P
# AQH/BAQDAgeAMEwGA1UdIARFMEMwQQYJKwYBBAGgMgEeMDQwMgYIKwYBBQUHAgEW
# Jmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQC
# MAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwRgYDVR0fBD8wPTA7oDmgN4Y1aHR0
# cDovL2NybC5nbG9iYWxzaWduLmNvbS9ncy9nc3RpbWVzdGFtcGluZ3NoYTJnMi5j
# cmwwgZgGCCsGAQUFBwEBBIGLMIGIMEgGCCsGAQUFBzAChjxodHRwOi8vc2VjdXJl
# Lmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3RpbWVzdGFtcGluZ3NoYTJnMi5jcnQw
# PAYIKwYBBQUHMAGGMGh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3RpbWVz
# dGFtcGluZ3NoYTJnMjAdBgNVHQ4EFgQU1Ie4jeblQDydWgZjxkWE2d27HMMwHwYD
# VR0jBBgwFoAUkiGnSpVdZLCbtB7mADdH5p1BK0wwDQYJKoZIhvcNAQELBQADggEB
# ACRyUKUMvEAJpsH01YJqTkFfzseIOdPkfPkibDh4uPS692vhJOudfM1IrIvstXZM
# j9yCaQiW57rhZ7bwpr8YCELh680ZWDmlEWEj1hnXAOm70vlfQfsEPv6KIGAM0U8j
# WhkaGO/Yxt7WX1ShepPhtneFwPuxRsQJri9T+5WcjibiSuTE5jw177rG2bnFzc0H
# m2O7PQ9hvFV8IxC1jIqj0mhFsUC6oN08GxVAuEl4b+WUwG1WSzz2EirUhfNIEwXh
# uzBFCkG3fJJuvk6SYILKW2TmVdPSB96dX5uhAe2b8MNduxnwGAyaoBzpaggLPelm
# l6d1Hg+/KNcJIw3iFvq68zQwggYxMIIFGaADAgECAhNdAAACRI925v27gi6rAAMA
# AAJEMA0GCSqGSIb3DQEBCwUAMFoxEzARBgoJkiaJk/IsZAEZFgNvcmcxGzAZBgoJ
# kiaJk/IsZAEZFgtjYXNjYWRldGVjaDEVMBMGCgmSJomT8ixkARkWBWludHJhMQ8w
# DQYDVQQDEwZDVEEtQ0EwHhcNMTcwMzI3MTg0MTAwWhcNMjcwMzI1MTg0MTAwWjBu
# MRMwEQYKCZImiZPyLGQBGRYDb3JnMRswGQYKCZImiZPyLGQBGRYLY2FzY2FkZXRl
# Y2gxFTATBgoJkiaJk/IsZAEZFgVpbnRyYTENMAsGA1UECxMETUVTRDEUMBIGA1UE
# AxMLRWRlbiBOZWxzb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDq
# 3nkQcPytMS0qeat+jFQqNVQz0S7r/iVycsUkVpcAAYWnocqRmhAU2BW93il8xhe9
# hXWar9nU/Fh4AKaM6NXEvC1QLHc3YZfjf1oW2/FFf4pzVInbbc188+rzp2DNW6lq
# xxa2YUHqyuzv2J8tcfrKoRg+JCWd9cN/YGSibHQdw8tyoqmmWxFOjItY4IYOS+i+
# KLYT5waVpI8cTpF6TLPs2Kgkd6rD+fsOAXFH7McrR6Qivki31ZJPq+jV469VIjEQ
# DgixUW3Qo24y3hCHC8/Saxl68iSUbH0ATw+2iaT0R89S0YfQLbcG4bM3leypomgt
# yU2OV7gxeUyuuRkwK+Q/AgMBAAGjggLaMIIC1jA8BgkrBgEEAYI3FQcELzAtBiUr
# BgEEAYI3FQiB25s9gcXgEYHxjwCG95kz0utpgQq6rHyHqcB9AgFkAgECMBMGA1Ud
# JQQMMAoGCCsGAQUFBwMDMA4GA1UdDwEB/wQEAwIHgDAbBgkrBgEEAYI3FQoEDjAM
# MAoGCCsGAQUFBwMDMB0GA1UdDgQWBBTX8SkazfF1VgmRS6MtNYNzWRbFxjAfBgNV
# HSMEGDAWgBRFtRVw0jTNG1WszSXHh+qWu8IlnzCCAREGA1UdHwSCAQgwggEEMIIB
# AKCB/aCB+oaBv2xkYXA6Ly8vQ049Q1RBLUNBKDIpLENOPUNUQS1EQy0wMSxDTj1D
# RFAsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29u
# ZmlndXJhdGlvbixEQz1pbnRyYSxEQz1jYXNjYWRldGVjaCxEQz1vcmc/Y2VydGlm
# aWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1
# dGlvblBvaW50hjZodHRwOi8vY3RhY3JsLmNhc2NhZGV0ZWNoLm9yZy9DZXJ0RW5y
# b2xsL0NUQS1DQSgyKS5jcmwwgcUGCCsGAQUFBwEBBIG4MIG1MIGyBggrBgEFBQcw
# AoaBpWxkYXA6Ly8vQ049Q1RBLUNBLENOPUFJQSxDTj1QdWJsaWMlMjBLZXklMjBT
# ZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWludHJhLERD
# PWNhc2NhZGV0ZWNoLERDPW9yZz9jQUNlcnRpZmljYXRlP2Jhc2U/b2JqZWN0Q2xh
# c3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTA3BgNVHREEMDAuoCwGCisGAQQBgjcU
# AgOgHgwcbmVsc29uQGludHJhLmNhc2NhZGV0ZWNoLm9yZzANBgkqhkiG9w0BAQsF
# AAOCAQEAOoo+7nn7jGm+2AyZ15TWl0VjPzfKe02G+V/aKQj4BKyq+hWLVcNd4pxl
# qTqXF07s1NnVHsgozJBawzf8lQZMKmBp5InBN9rsL+4MK8tcou+xtRGhBYbZs8zO
# ejfQ7LjJQoBKDpjjqJsyCwitAec2MyGmEXSAiGMqoj5dLjhq9CMf7vxICgj4RPQk
# Hap2iOWDvpVSl8Gt+Fy5JXNG5EVQXBfy1ojZsdFMBrpdewVdMmwe5rmC+a0X3NK+
# vkD6H4kmZZc2GmDnv1unK3KsjO2gMnYnOGSuEmXRA9nuSWPbJFxIUsZzn2p+FfWQ
# Ngzz9wnFFpdHIEHKvkaXtmDzs3f65DGCBKcwggSjAgEBMHEwWjETMBEGCgmSJomT
# 8ixkARkWA29yZzEbMBkGCgmSJomT8ixkARkWC2Nhc2NhZGV0ZWNoMRUwEwYKCZIm
# iZPyLGQBGRYFaW50cmExDzANBgNVBAMTBkNUQS1DQQITXQAAAkSPdub9u4IuqwAD
# AAACRDANBglghkgBZQMEAgEFAKBMMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEE
# MC8GCSqGSIb3DQEJBDEiBCA3hm44AS7irnGxynwcxbGYArD/15JrJz0V2NgVZWM3
# FDANBgkqhkiG9w0BAQEFAASCAQCy83acqrk3JDj8mF8B7pVwpDP3YMSdaYYOl1fK
# EgKANRe8nqV+M4ri6RvaFDFZNXW+rFV9xYQj9jLqwz2GzF+nhG6ntOIyvc9YHr6f
# H2YBJpsNwF2Iz8vcyqH8g+s7ZN/i+x358TgCvQslLzEjoUqN/9oIyP9rSd4P00Zm
# g8obWDTaQbgGgIKIGx/Kj73bf6a/3yns1iO4J5Prk7MH6FLA8n3LzctopqziF+fF
# JggN+s0Ao47rngHEE66k7wkOCzWXrQ1CZBnkGEqNxFycxPc5NGyrhEwp2aBZG1m2
# 51DiF+6eINqsABHJ1GElDnPyD+JpdwcpqS8iFWRizm/5i7JIoYICuTCCArUGCSqG
# SIb3DQEJBjGCAqYwggKiAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEds
# b2JhbFNpZ24gbnYtc2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gVGltZXN0YW1waW5n
# IENBIC0gU0hBMjU2IC0gRzICDCRUuH8eFFOtN/qheDANBglghkgBZQMEAgEFAKCC
# AQwwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAw
# OTIzMTk1NDQwWjAvBgkqhkiG9w0BCQQxIgQg9f5h9omhfrr583bl8q4VM8Ojf4N4
# nWilP1kgQvLt5S4wgaAGCyqGSIb3DQEJEAIMMYGQMIGNMIGKMIGHBBQ+x2bV1NRy
# 4hsfIUNSHDG3kNlLaDBvMF+kXTBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xv
# YmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcg
# Q0EgLSBTSEEyNTYgLSBHMgIMJFS4fx4UU603+qF4MA0GCSqGSIb3DQEBAQUABIIB
# ACzHRfLZcKBvnv4plAMCehaJfvRLhZOlGxiNTM9qTsw6MfXOCNdXtiX+KaAJhZiF
# fSq6vlnYn8P4VNKymAOzUPshaLZGjBbAFvIT4XHv677Hjy2eyf4CxEF4zmtsuFen
# 3PZNKqVRbWpk6pW9IV5ynmypSwY+1wtrY8w1rqBQZVGNPXRYQbB4RCV194vClhgT
# YmaRL+IoKT9CqU4lZ6AZ/eyHw1Y5mKoEPFMlZdqlk09LBThze9sgx+iuL8T2NRPj
# buSshxC1s4gI5kTF7hizLceE603XSdJ30v5Qxam0lb21tUdTIIDul/fUjpuM1pdl
# JyurFXPKj7Hv037gNZztlbk=
# SIG # End signature block
