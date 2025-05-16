Add-PathVariable "$env:ProgramFiles\OpenSSL"

# See https://stackoverflow.com/questions/14459078/unable-to-load-config-info-from-usr-local-ssl-openssl-cnf
# $env:OPENSSL_CONF = "$env:ProgramFiles\OpenSSL\openssl.cnf"

# $env:RANDFILE="$env:LOCALAPPDATA\openssl.rnd"

# From https://certsimple.com/blog/openssl-shortcuts
Function read-certificate($file) 
	write-output "openssl x509 -text -noout -in $file"
	openssl x509 -text -noout -in "$file"


Function read-csr($file) 
	write-output "openssl req -text -noout -verify -in $file"
	openssl req -text -noout -verify -in "$file"


Function read-rsa-key($file) 
	write-output openssl rsa -check -in "$file"
	openssl rsa -check -in "$file"


Function read-ecc-key($file) 
	write-output "openssl ec -check -in $file"
	openssl ec -check -in "$file"


Function read-pkcs12($file) 
	write-output "openssl pkcs12 -info -in $file"
	openssl pkcs12 -info -in "$file"


# Connecting to a server (Ctrl C exits)
Function test-openssl-client($server, $port) 
	write-output "openssl s_client -status -connect $server:443"
	openssl s_client -status -connect $server:$port


# Convert PEM private key, PEM certificate and PEM CA certificate (used by nginx, Apache, and other openssl apps)
# to a PKCS12 file (typically for use with Windows or Tomcat)
Function convert-pem-to-p12($key, $cert, $cacert, $output) 
	write-output "openssl pkcs12 -export -inkey $key -in $cert -certfile $cacert -out $output"
	openssl pkcs12 -export -inkey "$key" -in "$cert" -certfile "$cacert" -out "$output"


# Convert a PKCS12 file to PEM
Function convert-p12-to-pem($p12file, $pem) 
	write-output "openssl pkcs12 -nodes -in $p12file -out $pemfile"
	openssl pkcs12 -nodes -in "$p12file" -out "$pemfile"


# Convert a crt to a pem file
Function convert-crt-to-pem($crtfile) 
	write-output "openssl x509 -in $crtfile -out $basename.pem -outform PEM"
	openssl x509 -in $crtfile -out $basename.pem -outform PEM


# Check the modulus of an RSA certificate (to see if it matches a key)
Function show-rsa-certificate-modulus() 
	write-output "openssl x509 -noout -modulus -in "$1" | shasum -a 256"
	openssl x509 -noout -modulus -in "$1" | shasum -a 256


# Check the public point value of an ECDSA certificate (to see if it matches a key)
# See https://security.stackexchange.com/questions/73127/how-can-you-check-if-a-private-key-and-certificate-match-in-openssl-with-ecdsa
Function show-ecdsa-certificate-ppv-and-curve() 
	write-output "openssl x509 -in "$1" -pubkey | shasum -a 256"
	openssl x509 -noout -pubkey -in "$1" | shasum -a 256


# Check the modulus of an RSA key (to see if it matches a certificate)
Function show-rsa-key-modulus() 
	write-output "openssl rsa -noout -modulus -in "$1" | shasum -a 256"
	openssl rsa -noout -modulus -in "$1" | shasum -a 256


# Check the public point value of an ECDSA key (to see if it matches a certificate)
# See https://security.stackexchange.com/questions/73127/how-can-you-check-if-a-private-key-and-certificate-match-in-openssl-with-ecdsa
Function show-ecc-key-ppv-and-curve() 
	write-output "openssl ec -in "$1" -pubout | shasum -a 256"openssl ec -in key -pubout
	openssl pkey -pubout -in "$1" | shasum -a 256


# Check the modulus of a certificate request
Function show-rsa-csr-modulus() 
	write-output openssl req -noout -modulus -in "$1" | shasum -a 256
	openssl req -noout -modulus -in "$1" | shasum -a 256


# Encrypt a file (because zip crypto isn't secure)
Function protect-file() 
	write-output openssl aes-256-cbc -in "$1" -out "$2"
	openssl aes-256-cbc -in "$1" -out "$2"


# Decrypt a file
Function unprotect-file() 
	write-output aes-256-cbc -d -in "$1" -out "$2"
	openssl aes-256-cbc -d -in "$1" -out "$2"


# For setting up public key pinning
Function convert-key-to-hpkp-pin() 
	write-output openssl rsa -in "$1" -outform der -pubout | openssl dgst -sha256 -binary | openssl enc -base64
	openssl rsa -in "$1" -outform der -pubout | openssl dgst -sha256 -binary | openssl enc -base64


# For setting up public key pinning (directly from the site)
Function convert-website-to-hpkp-pin() 
	write-output openssl s_client -connect "$1":443 | openssl x509 -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
	openssl s_client -connect "$1":443 | openssl x509 -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64


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
