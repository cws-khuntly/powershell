Add-PathVariable "$env:ProgramFiles\OpenSSL"

# See https://stackoverflow.com/questions/14459078/unable-to-load-config-info-from-usr-local-ssl-openssl-cnf
# $env:OPENSSL_CONF = "$env:ProgramFiles\OpenSSL\openssl.cnf"

# $env:RANDFILE="$env:LOCALAPPDATA\openssl.rnd"

# From https://certsimple.com/blog/openssl-shortcuts
Function read-certificate() {
    param (
        [string] $InputFile
    )

	Write-Output "openssl x509 -text -noout -in ${InputFile}"
	openssl x509 -text -noout -in "${InputFile}"
}

Function read-csr() {
    param (
        [string] $InputFile
    )

	Write-Output "openssl req -text -noout -verify -in ${InputFile}"
	openssl req -text -noout -verify -in "${InputFile}"
}

Function read-rsa-key() {
    param (
        [string] $InputFile
    )

	Write-Output "openssl rsa -check -in ${InputFile}"
	openssl rsa -check -in "${InputFile}"
}

Function read-ecc-key() {
    param (
        [string] $InputFile
    )

	Write-Output "openssl ec -check -in ${InputFile}"
	openssl ec -check -in "${InputFile}"
}

Function read-pkcs12() {
    param (
        [string] $InputFile
    )

	Write-Output "openssl pkcs12 -info -in ${InputFile}"
	openssl pkcs12 -info -in "${InputFile}"
}

# Connecting to a TargetHost (Ctrl C exits)
Function test-openssl-client() {
    param (
        [string] $TargetHost,
        [int] $TargetPort
    )

	Write-Output "openssl s_client -status -connect ${TargetHost}:${TargetPort}"
	openssl s_client -status -connect "${TargetHost}":"${TargetPort}"
}

# Convert PEM private key, PEM certificate and PEM CA certificate (used by nginx, Apache, and other openssl apps)
# to a PKCS12 InputFile (typically for use with Windows or Tomcat)
Function convert-pem-to-p12() {
    param (
        [string] $KeyFile,
        [string] $CertFile,
        [string] $CACertFile,
        [string] $OutFile
    )

	Write-Output "openssl pkcs12 -export -inkey ${KeyFile} -in ${CertFile} -certfile ${CACertFile} -out ${OutFile}"
	openssl pkcs12 -export -inkey "${KeyFile}" -in "${CertFile}" -certfile "${CACertFile}" -out "${OutFile}"
}

# Convert a PKCS12 InputFile to PEM
Function convert-p12-to-pem() {
    param (
        [string] $InputFile,
        [string] $OutputFile
    )

	Write-Output "openssl pkcs12 -nodes -in ${InputFile} -out ${OutputFile}"
	openssl pkcs12 -nodes -in "${InputFile}" -out "${OutputFile}"
}

# Convert a crt to a pem InputFile
Function convert-crt-to-pem() {
    param (
        [string] $InputFile,
        [string] $OutputFile
    )

	Write-Output "openssl x509 -in ${InputFile} -out ${OutputFile} -outform PEM"
	openssl x509 -in "${InputFile}" -out "${OutputFile}" -outform PEM
}

# Check the modulus of an RSA certificate (to see if it matches a key)
Function show-rsa-certificate-modulus() {
	Write-Output "openssl x509 -noout -modulus -in ${1} | shasum -a 256"
	openssl x509 -noout -modulus -in "${1}" | shasum -a 256
}

# Check the public point value of an ECDSA certificate (to see if it matches a key)
# See https://security.stackexchange.com/questions/73127/how-can-you-check-if-a-private-key-and-certificate-match-in-openssl-with-ecdsa
Function show-ecdsa-certificate-ppv-and-curve() {
	Write-Output "openssl x509 -in ${1} -pubkey | shasum -a 256"
	openssl x509 -noout -pubkey -in "${1}" | shasum -a 256
}

# Check the modulus of an RSA key (to see if it matches a certificate)
Function show-rsa-key-modulus() {
	Write-Output "openssl rsa -noout -modulus -in ${1} | shasum -a 256"
	openssl rsa -noout -modulus -in "${1}" | shasum -a 256
}

# Check the public point value of an ECDSA key (to see if it matches a certificate)
# See https://security.stackexchange.com/questions/73127/how-can-you-check-if-a-private-key-and-certificate-match-in-openssl-with-ecdsa
Function show-ecc-key-ppv-and-curve() {
	Write-Output "openssl ec -in ${1} -pubout | shasum -a 256"
	openssl pkey -pubout -in "${1}" | shasum -a 256
}

# Check the modulus of a certificate request
Function show-rsa-csr-modulus() {
	Write-Output "openssl req -noout -modulus -in ${1} | shasum -a 256"
	openssl req -noout -modulus -in "$1" | shasum -a 256
}

# Encrypt a InputFile (because zip crypto isn't secure)
Function protect-file() {
	Write-Output "openssl aes-256-cbc -in ${1} -out ${2}"
	openssl aes-256-cbc -in "${1}" -out "${2}"
}

# Decrypt a InputFile
Function unprotect-file() {
	Write-Output "openssl aes-256-cbc -d -in ${1} -out ${2}"
	openssl aes-256-cbc -d -in "${1}" -out "${2}"
}

# For setting up public key pinning
Function convert-key-to-hpkp-pin() {
	Write-Output "openssl rsa -in ${1} -outform der -pubout | openssl dgst -sha256 -binary | openssl enc -base64"
	openssl rsa -in "${1}" -outform der -pubout | openssl dgst -sha256 -binary | openssl enc -base64
}

# For setting up public key pinning (directly from the site)
Function convert-website-to-hpkp-pin() {
	Write-Output "openssl s_client -connect ${1}:443 | openssl x509 -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64"
	openssl s_client -connect "${1}":443 | openssl x509 -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
}

Export-ModuleMember -Function read-certificate
Export-ModuleMember -Function read-csr
Export-ModuleMember -Function read-rsa-key
Export-ModuleMember -Function read-ecc-key
Export-ModuleMember -Function read-pkcs12
Export-ModuleMember -Function test-openssl-client
Export-ModuleMember -Function convert-pem-to-p12
Export-ModuleMember -Function convert-p12-to-pem
Export-ModuleMember -Function convert-crt-to-pem
Export-ModuleMember -Function show-rsa-certificate-modulus
Export-ModuleMember -Function show-ecdsa-certificate-ppv-and-curve
Export-ModuleMember -Function show-rsa-key-modulus
Export-ModuleMember -Function show-ecc-key-ppv-and-curve
Export-ModuleMember -Function show-rsa-csr-modulus
Export-ModuleMember -Function protect-file
Export-ModuleMember -Function unprotect-file
Export-ModuleMember -Function convert-key-to-hpkp-pin
Export-ModuleMember -Function convert-website-to-hpkp-pin
